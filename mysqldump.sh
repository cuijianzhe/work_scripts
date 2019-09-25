#!/bin/bash
#--------------------------------------------------------------------------------#
  #Shell Command For Backup MySQL Databaes Everyday Automatically By Crontab
  #Author     : cuijianzhe
  #QQ         : 598941324
  #Create date: 2019-3-19
#--------------------------------------------------------------------------------#
#-----------------------Back up MySQL every day----------------------------------#
#--------------------------------------------------------------------------------#
User=solo                                    #数据库用户
Password=b3blogsolo                          #用户登录密码
DataBase=solo                                 #数据库名
Backup_DIR=/usr/local/mysql/mysqlbackup/      #存放备份数据库文件路径
LogFile_DIR=/usr/local/mysql/mysqlbackup_log/ #存放备份数据库日志路径
LogFile="$LogFile_DIR"mysql_backup.log
Date=`date +%Y-%m-%d`  
start_time=`date +'%Y-%m-%d %H:%M:%S'`                  #获取时间
DumpFile="$Date"-"$DataBase".sql             
Archive="$Date"-"$DataBase"_sql.tar.gz       #打包后名称
SaveTime=5
DelFile=`find $Backup_DIR -type f -mtime +$SaveTime -exec ls {} \;`  #查找大于5天的备份文件
#-------------------------------------------------------------------------------#
  if [ ! -d $Backup_DIR ];                     #判断路径是否存在，若没有则创建
    then
      mkdir -p "$Backup_DIR"
  fi
  [ ! -d $LogFile_DIR ] && mkdir -p $LogFile_DIR
  if [ ! -f "$LogFile" ];
    then
      touch $LogFile
  fi
#-------------------------------------------------------------------------------#
  echo -e "\n" >> $LogFile
  echo "#--------------------------------------------------------#" >> $LogFile
  echo "#------------Backup Date:$start_time !!!--------------#" >> $LogFile
  echo "#--------------------------------------------------------#" >> $LogFile

#-------------------------------------------------------------------------------#
  cd $Backup_DIR
  mysqldump -u$User -p$Password $DataBase > $DumpFile   #mysqldump备份
  if [[ $? == 0 ]];
    then
      tar czvf $Archive $DumpFile >> $LogFile 2>&1                  #判断是否成功，成功则打包，未成功则些入到日志文件
      echo -e "$User :$Archive Backup Successul !!!" >> $LogFile
      rm -rf $DumpFile                                              #打包后删除sql文件
  else
      echo -e "$User :$Archive Backup Fail !!!" >> $LogFile
  fi
#-------------------------------------------------------------------------------#
#--------------------Delete MySQL backup 5 days ago----------------------------#
#-------------------------------------------------------------------------------#
#  echo -e "\n" >> $LogFile
  echo "#--------------------------------------------------------#" >> $LogFile
  echo "#------------Delete Date:$start_time !!!--------------#" >> $LogFile
  echo "#--------------------------------------------------------#" >> $LogFile
#-------------------------------------------------------------------------------#
  if [[ $? == 0 ]];                                 
    then
      for delfile in ${DelFile}
        do
          rm -rf $delfile                         #删除5天前备份
      done
    echo -e "$User :Successfully deleted 5 days before backup !!!" >> $LogFile
  else
    echo -e "$User :Unsuccessful deletion of backup 5 days ago !!!" >> $LogFile
  fi
#-------------------------------打印备份所需时间----------------------------------------------#
end_time=`date +'%Y-%m-%d %H:%M:%S'`
start_seconds=$(date --date="$start_time" +%s);
end_seconds=$(date --date="$end_time" +%s);
time_total=$((end_seconds-start_seconds))

if [[ $time_total -lt 60 ]];then
   echo -e  "备份所用时间为："$(($time_total))"s"  >>$LogFile
else
   echo -e  "备份所用时间为：$(($time_total/60|bc))minutes"  >>$LogFile
   echo -e  "备份开始时间为: $start_time ,结束时间为：$end_time"  >> $LogFile
fi
