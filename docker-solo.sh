#!/bin/bash
# Solo docker 升级脚本&删除旧的镜像脚本
# Author:cuijianzhe
[ -f /etc/init.d/functions ] && . /etc/init.d/functions

start_time=`date +'%Y-%m-%d %H:%M:%S'`
solo(){
    echo "-----------------solo upgrading------------------------------"
    docker pull b3log/solo
    docker stop solo
    docker run --detach --name solo --network=host \
    --env RUNTIME_DB="MYSQL" \
    --env JDBC_USERNAME="solo" \
    --env JDBC_PASSWORD="b3blogsolo" \
    --env JDBC_DRIVER="com.mysql.cj.jdbc.Driver" \
    --env JDBC_URL="jdbc:mysql://127.0.0.1:3306/solo?useUnicode=yes&characterEncoding=UTF-8&useSSL=false&serverTimezone=UTC" \
    --volume /dockerdata/solo/solo-skins:/opt/solo/skins/ \
    --rm \
    b3log/solo --listen_port=8080 --server_scheme=https --lute_http=http://127.0.0.1:8249  --server_host=www.cjzshilong.cn --server_port=
    
}
#--------------------------删除无用镜像image包--------------------------#
del(){
    num=`docker images |grep none |wc -l`
    echo "当前存在无用镜像包$num 个."
    for ((i=1;i<=$num;i++))
    do  
        images=`docker images |grep none | awk '{print $3}'`
        docker rmi $images
	if [[ $? == 0 ]];
           then
               echo -e "------------------$end_time 删除镜像id:$images 成功-----------------------"
	   else
               echo -e "-----------------$end_time 删除镜像id:$images 失败 -----------------------"
        fi
    done
}

#---------------------------lute安装脚本--------------------------------
lute(){
    docker pull b3log/lute-http
    docker stop solo
    docker stop lute-http
    docker rm lute-http
    docker run --detach --name lute-http  --network=host b3log/lute-http
}

solo_time(){
    end_time=`date +'%Y-%m-%d %H:%M:%S'`
    start_seconds=$(date --date="$start_time" +%s);
    end_seconds=$(date --date="$end_time" +%s);
    echo "脚本运行所用时间为："$((end_seconds-start_seconds))"s"
    echo "开始时间为: $start_time ,结束时间为：$end_time"
    echo " "

}
#----------------------------判断solo是否有新版本-------------------------------------

upgrade_solo(){
    isUpgrad=$(docker pull b3log/solo|grep "Downloaded")
    if [[ -z  $isUpgrad ]] 
    then 
        echo $start_time :Detection solo version is the latest version
    else
        solo
    fi
}
#---------------------------判断lute是否有新版本----------------------------------
upgrade_lute(){
    isUpgrad=$(docker pull b3log/lute-http|grep "Downloaded")
    if [[ -z  $isUpgrad ]]
    then
        echo $start_time :Detection lute version is the latest version
    else
        lute
    fi
}
#---------------------判断docker镜像是否正常运行---------------------------
Server_test(){
    server=`docker ps | grep b3log/solo`
    if [ -z "$server" ]; then  #如果查询结果为空，则停留5秒继续pull镜像
        sleep 5
        echo '----------docker-solo状态异常，重新安装------------'
        solo
    fi
    lute_http=` docker ps  | grep lute-http`
    if [ -z "$lute_http" ]; then
       sleep 3
       lute
    fi
}

main(){
    upgrade_lute
    upgrade_solo
    Server_test
    solo_time
    del
}
main
#--------------------------------------------------------------------------


作者：cuijianzhe
链接：https://hacpai.com/article/1554909875932
来源：黑客派
协议：CC BY-SA 4.0 https://creativecommons.org/licenses/by-sa/4.0/
