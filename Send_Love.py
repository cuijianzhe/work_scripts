#!/bin/env python3
###################################################################
#  This script is to send emails to Lijuan regularly              #
#  Date: 2020-1-7                                                 #
#  Author: cuijianzhe                                             #
#  Email: 598941324@qq.com                                        # 
###################################################################

import smtplib
from email.mime.text import MIMEText
from email.utils import formataddr
import datetime
import time
import random
import linecache
def symbol(file):
    fuhao = ["(￣▽￣)~*","(￣▽￣)／","(〃'▽'〃)","ヾ(ｏ･ω･)ﾉ","(￣.￣)","ヾ(@^▽^@)ノ","(｡◕ˇ∀ˇ◕)","(￢_￢)瞄","＾＿－)≡★ ","✧(＾＿－✿ ","｡◕ᴗ◕｡","ლ(⁰⊖⁰ლ)","(´•༝•`)","( ･´ω`･ )","(*≧▽≦)","(´･ᴗ･`)"]
    # fuhao = ['▲','▼','●','◆','■','★','▶','◀','♥','♦','$','%','@','&']
    huashu = ["❤ 爱你的哲哥 ❤","❤ L love you ❤","❤ jialijuan，你是我的宝宝 ❤","❤ 我不管，你就是我的人了 ❤","❤ 著名奶茶鉴定家 ❤","❤ 退役魔法少女 ❤","首席漂亮官","当地比较可爱的一类人","哲哥要娶你"]
    date = time.strftime('%Y-%m-%d',time.localtime())
    starttime = datetime.datetime(2019,12,16)
    endtime = datetime.datetime.now()
    times = (endtime - starttime).days
    with open(file,encoding='utf-8') as yuju:
        qinghua = linecache.getline('wenben', random.randint(1, len(yuju.readlines()))).split('、')[1].strip()
    word = random.choice(huashu)
    hongxin = (random.choice(fuhao)) * 8
    body = """
    Dear LiJuan：
    
         %s
         
         ❤ 今天是%s，是我和你在一起的第%s天，我至死不渝的爱你……   ❤
         ❤ 今日份小甜甜：%s

         %s
         
         ❤ %s ❤
    """%(hongxin,date,times,qinghua,hongxin,word)
    return body
def _email(content):
    my_sender = '22222222@qq.com'
    my_pass = 'mypassword'
    my_user = '1111111111@qq.com'
    msg = MIMEText(content, 'plain', 'utf-8')
    msg['From'] = formataddr(["爱你的哲", my_sender])
    msg['To'] = formataddr(["小娟娟", my_user])
    msg['Subject'] = '更新爱你的日期到永远'
    server = smtplib.SMTP_SSL("smtp.qq.com", 465)
    server.login(my_sender, my_pass)
    server.sendmail(my_sender, [my_user], msg.as_string())
    server.quit()
if __name__ == '__main__':
    text = symbol('/shell/love/wenben')
    _email(text)
