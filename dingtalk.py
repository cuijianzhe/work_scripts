#!/usr/bin/python3
# -*- coding: utf-8 -*-
#Author: aiker@gdedu.ml
#   power by  cuijianzhe  #
import requests
import json
import sys
import os

headers = {'Content-Type': 'application/json;charset=utf-8'}
api_url = "https://oapi.dingtalk.com/robot/send?access_token=d93091d8781634b9029ba0a5a25696c33ca8ec0cc387d633ca65f4925e9029f2"

def msg(text):
    json_text= {
      "msgtype": "markdown",
      "markdown": {
          "title": "网络报警通知",
          "text": text
      },
       "at": {
           "atMobiles": [
               ""
           ],
           "isAtAll": False
        }
     }
    print(requests.post(api_url,json.dumps(json_text),headers=headers).content)

if __name__ == '__main__':
    text = sys.argv[1]
    msg(text)
