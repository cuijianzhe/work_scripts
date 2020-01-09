my scripts on github,实现使用脚本满足日常使用

## 1.docker-solo.sh ❤️ 
* 检测 Solo 版本是否有新版本；
* 可自动删除更新后的 Solo 镜像包；
* 自动检测 Solo 是否安装部署成功，不成功则再次 pull 镜像
* 检测 lute-http 是否正常运行


## 2. port_discovery.py
port_discovery.py:Automatic port discovery based on Python 3 ---端口以及服务名自动发现
基于python3实现centos服务中的端口以及对应服务名自动发现

## 3. Huawei_AP_discovery.py
Huawei_AP_discovery.py:Automatic discovery of Huawei AP on Python 3---自动发现华为无线AP
python3实现针对华为AC的snmp oid值进行对无线AP进行自动发现


## 4.dingtalk.py
可以向钉钉发送markdown消息

## 如图：

![](https://github.com/cuijianzhe/discover_server/blob/master/img/action.png)

## 效果如下：
![](https://github.com/cuijianzhe/discover_server/blob/master/img/cccc.png)
> dingcard.py: 独立跳转ActionCard类型文本 传参到钉钉自定义机器人,本脚本实现web状态码检测，并且发送钉钉消息
## 5.mysqldump.sh 数据库备份
通过定时脚本实现数据库的日常备份

## 6. 人名转拼音模块
```python
str = '崔建哲，中国，狸米，大傻，杨和苏'
kk = ''
pin = pypinyin.pinyin(str,style=pypinyin.NORMAL)
for n in pin:
    kk += ''.join(n)
print(kk)
```
效果：`cuijianzhe，zhongguo，limi，dasha，yanghesu`
## 7. 每日5:21自动发送情话到自己喜欢的女孩子邮箱
