#!/bin/env python3
import json
import os
import sys
import subprocess
def discovery():
    CMD_name = '''snmpwalk -v 2c -c limi@2018  10.200.250.5 enterprises.2011.6.139.13.3.10.1.5 | awk  '{print $4}' | sed 's/"//g' '''
    CMD_id = 'snmpwalk -v 2c -c limi@2018  10.200.250.5 1.3.6.1.4.1.2011.6.139.13.3.10.1.5 | cut -f1 -d "=" | cut -f10 -d "."'
    ap_id = subprocess.getoutput(CMD_id)
    ap_name = subprocess.getoutput(CMD_name)
   #print(ap_id)
    id_list = ap_id.split("\n") #把AP的id每行数据添加到列表
    name_list = ap_name.split("\n")
    AP_list = list(zip(id_list,name_list))
    ap_dict = {}
    for v in AP_list:
        ap_dict[v[0]] = v[1]
    return ap_dict

#格式化成适合zabbix lld的json数据
if __name__ == "__main__":    
    ap_value = discovery()
    ap_list = []
    for key in ap_value:
        ap_list += [{'{#APID}':key,'{#APNAME}':ap_value[key]}]
    #print(ap_list)
    print(json.dumps({'data':ap_list},sort_keys=True,indent=4,separators=(',',':')))
