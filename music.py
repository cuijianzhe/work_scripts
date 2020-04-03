#!/usr/bin/python
# -*- coding: utf-8 -*-
# @Time  : 2020/03/27 21:36
# @Author : cuijianzhe
# @File  : music.py
# @Software: PyCharm
import os
import json
import requests

headers = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.130 Safari/537.36',
    'Content-Type': 'application/x-www-form-urlencoded',
    'Referer': 'http://music.163.com/discover',
    'Accept': '*/*'
}

class NeteaseSignin():
    def __init__(self,username,password):
        self.name = username
        self.password = password
        self.session = NeteaseSignin.login(username,password)
    def run(self):
        signin_url = "http://www.cjzshilong.cn:3001/daily_signin"
        res_signin = self.session.get(signin_url, headers=headers)
        data = json.loads(res_signin.text)
        if data.get('code') == 200:
            info = '''今日网易云签到获得%s云贝
返回相关信息：%s'''%(data.get('point'),data)
            return info
        else:
            info = '''今日网易云%s
返回相关信息：%s'''%(data.get('msg'),data)
            return info

    @staticmethod
    def login(username,password):
        session = requests.Session()
        api_url = "http://cjzshilong.cn:3001/login?email=%s&password=%s" % (username,password)
        res = session.get(api_url, headers=headers)
        # str_res = json.loads(res.text)
        return session
class feishu():
    def __init__(self,mobile,text):
        self.mobile = mobile
        self.token = feishu.get_token()
        self.text = text
    def getuserid(self):
        headers_group = {
            "Authorization": "Bearer %s" % self.token,
            "Content-Type": "application/json"
        }
        try:
            userurl = "https://open.feishu.cn/open-apis/user/v1/batch_get_id?mobiles=%s" %self.mobile
            res_data = requests.get(url=userurl, headers=headers_group)
            code = json.loads(res_data.text).get('code')
            if code == 0:
                userid = json.loads(res_data.text)['data']['mobile_users'][self.mobile][0]['user_id']
                return userid
            else:
                error = json.loads(res_data.text).get('msg')
                print('请求出错：{}'.format(error))
        except:
            print('请求失败')
    def send_messages(self,userid):
        headers_group = {
            "Authorization": "Bearer %s" % self.token,
            "Content-Type": "application/json"
        }
        message_url = "https://open.feishu.cn/open-apis/message/v4/send/"
        # 发送富文本消息
        data = {
            "user_id": userid,
            "msg_type": "post",
            "content": {
                "post": {
                    "zh_cn": {
                        "title": "今日网易云音乐签到内容如下：",
                        "content": [
                            [
                                {
                                    "tag": "text",
                                    "un_escape": True,
                                    "text": "%s&nbsp;" % self.text
                                },
                                {
                                    "tag": "at",
                                    "user_id": userid

                                }
                            ]
                        ]
                    }
                }
            }
        }
        request = requests.post(url=message_url, headers=headers_group, json=data)
    @staticmethod
    def get_token():
        data = {"app_id":"cli_9xxxxd","app_secret":"YJJ7UTMTIlDxw4gdxxxb5zOuLYUi"}
        headers = {"Content-Type": "application/json"}
        url_token = "https://open.feishu.cn/open-apis/auth/v3/tenant_access_token/internal/"
        try:
            res = requests.post(url_token, json=data, headers=headers)
            if res.status_code == 200:
                token = (json.loads(res.text)).get('tenant_access_token')
                return token
        except:
            print('请求失败')

if __name__ == '__main__':
    filepath = '/scripts/music163/config.json'
    if os.path.exists(filepath):
        f = open(filepath, 'r', encoding='utf-8')
        info = json.load(f)
        f.close()
    else:
        username = input('--username:')
        password = input('--password:')
        info = {'username': username, 'password': password}
        f = open(filepath, 'w', encoding='utf-8')
        json.dump(info, f)
        f.close()
    sign_in = NeteaseSignin(username=info.get('username'),password=info.get('password'))
    text = sign_in.run()
    mobiles = '18600796142'
    res = feishu(mobiles,text)
    userid = res.getuserid()
    res.send_messages(userid)
