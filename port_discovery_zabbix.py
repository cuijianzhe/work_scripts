#!/bin/env python3

import subprocess
import json
import re

def PortList():
    CMD = "sudo netstat -pntl | awk '{print $4,$7}'|grep  [0-9] |egrep -vw '%s'"
    Result_str = subprocess.getoutput(CMD)
   #print(Result_str)
    tmp_list = Result_str.split("\n")
    #print(tmp_list)
    port_dict = {}
    for line in tmp_list:
       # print(line)
         PORT_REG = re.search(r"(127.0.0.1:|:::|0.0.0.0:)(\d+).+\d+/(\S+)",line)
#         print(PORT_REG)
         if PORT_REG is not None:
             match_line = (PORT_REG.groups())
             port_dict [ match_line[1]] = match_line[2]
    return port_dict

if __name__ == "__main__":
    Results = PortList()
    ports = []
    for key in Results:
        ports += [{'{#PNAME}':key,'{#PPORT}':Results[key]}]
    print(json.dumps({'data':ports},sort_keys=True,indent=4,separators=(',',':')))
    
