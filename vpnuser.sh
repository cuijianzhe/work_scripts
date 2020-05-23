#!/bin/bash 
# Script to add/del/update/search an VPN user for both IPsec/L2TP
# Copyright (C) 2018-2020 Cui Jianzhe <598941324@qq.com>

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
SYS_DT=$(date +%F-%T)
conf_bk() { /bin/cp -f "$1" "$1.old-$SYS_DT" 2>/dev/null; }
VPN_USER=$2
VPN_PASSWORD=$3
VPN_PASSWORD_ENC=$(openssl passwd -1 "$VPN_PASSWORD")
BINARY_NAME=vpnuser
chap_path=/etc/ppp/chap-secrets
ipsec_path=/etc/ipsec.d/passwd
userAdd() {
          cat <<EOF
Welcome! This script will add or update an VPN user account
Please double check before continuing!
================================================
VPN user to add:
Username: $VPN_USER
Password: $VPN_PASSWORD
Write these down. You'll need them to connect!
================================================
EOF

printf "Do you want to continue? [y/N] "
read -r response
case $response in
  [yY][eE][sS]|[yY])
    echo
    echo "Adding or updating VPN user..."
    echo
    ;;
  *)
    echo "Abort. No changes were made."
    exit 1
    ;;
esac
         
          cat >> $chap_path <<EOF
"$VPN_USER" l2tpd "$VPN_PASSWORD" *
EOF
          cat >> $ipsec_path <<CCC
$VPN_USER:$VPN_PASSWORD_ENC:xauth-psk
CCC
}

delUser() {
          cat <<EOF
Welcome! This script will delete an VPN user account
Please double check before continuing!
================================================
VPN user to delete:
Username: $VPN_USER
================================================
EOF

printf "Do you want to continue? [y/N] "
read -r response
case $response in
  [yY][eE][sS]|[yY])
    echo
    echo "Deleting VPN user..."
    echo
    ;;
  *)
    echo "Abort. No changes were made."
    exit 1
    ;;
esac
          # Delete VPN user
          sed -i "/^\"$VPN_USER\" /d" $chap_path  || echo -e " 删除$VPN_USER 失败，\033[1;5;41;4m 输入有误或者不存在 \033[0m"
          # shellcheck disable=SC2016
          sed -i '/^'"$VPN_USER"':\$1\$/d' $ipsec_path || echo -e " 删除$VPN_USER 失败，\033[1;5;41;4m 输入有误或者不存在 \033[0m"
          #grep "$VPN_USER" $chap_path && sed -i "/$VPN_USER/d" $chap_path || echo -e " 删除$VPN_USER 失败，\033[1;5;41;4m 输入有误或者不存在 \033[0m"
}
updateUser() {
                    cat <<EOF
Welcome! This script will add or update an VPN user account
Please double check before continuing!
================================================
VPN user to  update:
Username: $VPN_USER
Password: $VPN_PASSWORD
Write these down. You'll need them to connect!
================================================
EOF

printf "Do you want to continue? [y/N] "
read -r response
case $response in
  [yY][eE][sS]|[yY])
    echo
    echo "Adding or updating VPN user..."
    echo
    ;;
  *)
    echo "Abort. No changes were made."
    exit 1
    ;;
esac
          # update VPN user
          sed -i "/^\"$VPN_USER\" /d" /etc/ppp/chap-secrets
          cat >> /etc/ppp/chap-secrets <<EOF
"$VPN_USER" l2tpd "$VPN_PASSWORD" *
EOF
          # shellcheck disable=SC2016
          sed -i '/^'"$VPN_USER"':\$1\$/d' /etc/ipsec.d/passwd
          cat >> /etc/ipsec.d/passwd <<EOF
$VPN_USER:$VPN_PASSWORD_ENC:xauth-psk
EOF
}

searchUser() {
             passwd=`grep $VPN_USER $chap_path | awk '{print $3}' | sed 's/"//g'`
             if [ $passwd ];
                then
                    cat <<EOF
Welcome! This script is for querying VPN users
Please double check before continuing!
================================================
VPN user to  update:
Username: $VPN_USER
Password: $passwd
Query completed. You can need them to connect!
================================================
EOF
             else
                 echo -e "\033[41;37m $VPN_USER is not in $chap_path and $ipsec_path . It is search Fail !!! \033[0m"
             fi
}

# Backup config files
conf_bk "/etc/ppp/chap-secrets"
conf_bk "/etc/ipsec.d/passwd"
case "$1" in
        -add)
               userAdd "$@"
               ;;
        -del)
               delUser "$@"
               ;;
        -update)
               updateUser "$@"
               ;;
        -search)
               searchUser "$@"
               ;;
        help|*)
        echo $"Usage: sh $0 {-add|-del|-update|-search} username password" 
               cat <<EOF
                       -add            - add $BINARY_NAME
                       -del            - del $BINARY_NAME
                       -update         - update $BINARY_NAME
                       -search         - show current status of $BINARY_NAME
                       help            - the example: sh $0 -add vpnuser 12345678 | sh $0 -search vpnuser
EOF
	       exit 1
               ;;
esac
exit 0
# Update file attributes
chmod 600 /etc/ppp/chap-secrets* /etc/ipsec.d/passwd*
