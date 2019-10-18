#!/bin/sh
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
    --volume /dockerdata/solo/skins/:/opt/solo/skins/ \
    --rm \
    b3log/solo --listen_port=8080 --server_scheme=https --lute_http=  --server_host=www.cjzshilong.cn --server_port=

}
    sleep 5
del(){
    num=`docker images |grep b3log/solo|wc -l`
    if [ "$num" -gt 1 ]; then
        images=`docker images |grep b3log/solo | awk 'NR==2{print $3}'`
        echo $images
        docker rmi $images
        echo -e "--------------------$end_time 删除镜像id:$images --------------------------"

    else
        echo -e "-------------------------$end_time 没有旧的镜像可删除 -----------------------"
    fi

}
#---------------------------lute安装脚本--------------------------------
lute(){
    docker pull b3log/lute-http
    docker run --detach --name lute-http  --rm --network=host b3log/lute-http
}

lute_http=`docker ps | grep b3log/lute-http`

solo_time(){
    end_time=`date +'%Y-%m-%d %H:%M:%S'`
    start_seconds=$(date --date="$start_time" +%s);
    end_seconds=$(date --date="$end_time" +%s);
    echo "脚本运行所用时间为："$((end_seconds-start_seconds))"s"
    echo "开始时间为: $start_time ,结束时间为：$end_time"
    echo " "

}
#----------------------------判断solo是否有新版本-------------------------------------

upgrade(){
    isUpgrad=$(docker pull b3log/solo|grep "Downloaded")
    if [[ -z  $isUpgrad ]] 
    then 
        echo $start_time :detection version is the latest version
    else
        solo
        del
    fi
}
#---------------------判断docker镜像是否正常运行---------------------------
Server_test(){
    server=`docker ps | grep b3log/solo`
    if [ -z "$server" ]; then  #如果查询结果为空，则停留10秒继续pull镜像
        sleep 5
        echo '----------docker-solo状态异常，重新安装------------'
        solo
    fi
    lute_http=`docker ps | grep b3log/lute-http`
    if [ -z "$lute_http" ]; then
       sleep 3
       lute
    fi

}
upgrade
Server_test
solo_time
#--------------------------------------------------------------------------
