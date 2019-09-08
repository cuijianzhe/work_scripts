#!/bin/env python3
import requests
import json
import os
import sys
import subprocess
import time
url = "https://www.cjzshilong.cn"
api_url = "https://oapi.dingtalk.com/robot/send?access_token=89e3fdff70455b397c31db499deaa1c8087fa7977506aba87daf167abe981200"
headers = {'Content-Type': 'application/json;charset=utf-8'}
cur_time = time.asctime(time.localtime(time.time()))
CMD_code = '''echo `curl -o /dev/null -s -m 10 --connect-timeout 10 -w %{http_code} "https://www.cjzshilong.cn"`'''
code = subprocess.getoutput(CMD_code)
#print(code)
CMD_time = ''' curl -o /dev/null -s -w "time_connect: %{time_connect}\ntime_starttransfer: %{time_starttransfer}\ntime_total: %{time_total}\n" "https://www.cjzshilong.cn" | awk /time_total/ | awk -F ': ' '{print $2}' '''
res_time = subprocess.getoutput(CMD_time)
#print(res_time)

def msg(text):
    json_text= {
        "actionCard": {
            "title": "solo状态码报警",
            "text":
             text,
            "hideAvatar": "0",
            "btnOrientation": "0",
            "btns": [
                {
                    "title": "URL链接测试",
                    "actionURL": "https://www.cjzshilong.cn/"
                },
            ]
        },
        "msgtype": "actionCard"
    }
    Text = requests.post(api_url,data=json.dumps(json_text),headers=headers).json()
    return Text

def message():
    mess = "solo网站状态码测试 \n\n Web网址: %s \n\n 状态码：%s \n\n 网站响应时间: %s s \n\n 当前时间：%s \n\n"%(url,code,res_time,cur_time)
    return mess

if __name__ == '__main__':
    if code != '200' or res_time > '2':
      text = message()
      msg(text)
    else:
      pass
