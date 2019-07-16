#!/usr/bin/python
# -*- coding: utf-8 -*-

# 使用python2 commands模块

import re
import commands
import json

DROP_LIST = ['22','25','111']
# 排除端口

def filterList():
    DROP_str = "|".join(DROP_LIST)
    CMD="sudo netstat -pntl | awk '{print $4,$7}'|grep  [0-9] |egrep -vw '%s'" % (DROP_str)
    Result_Str = commands.getoutput(CMD)
    #print (Result_Str)
    tmp_list = Result_Str.split("\n") #每行加入列表
    new_dict = {}
    for line in tmp_list:
       # print (line)
       PORT_REG = re.search(r"(127.0.0.1:|:::|0.0.0.0:)(\d+).+\d+/(\S+)",line)
       if PORT_REG is not None:
           match_line =  (PORT_REG.groups())
           new_dict[ match_line[-1]]  =  match_line[-2]
    return new_dict

if __name__ == "__main__":
    Results = filterList()

    #格式化成适合zabbix lld的json数据
    ports = []
    for key  in  Results:
        ports += [{'{#PNAME}':key,'{#PPORT}':Results[key]}]
    print json.dumps({'data':ports},sort_keys=True,indent=4,separators=(',',':'))