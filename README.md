my first github,实现使用脚本满足日常使用

## 1. port_discovery.py
**port_discovery.py:Automatic port discovery based on Python 3 ---端口以及服务名自动发现
基于python3实现centos服务中的端口以及对应服务名自动发现**

## 2. Huawei_AP_discovery.py
**Huawei_AP_discovery.py:Automatic discovery of Huawei AP on Python 3---自动发现华为无线AP
python3实现针对华为AC的snmp oid值进行对无线AP进行自动发现



## 3.dingtalk.py
**向钉钉发送markdown消息**


**dingcard.py: 独立跳转ActionCard类型文本 传参到钉钉自定义机器人**

## 如图：

![](https://github.com/cuijianzhe/discover_server/blob/master/img/action.png)

## 效果如下：
![](https://github.com/cuijianzhe/discover_server/blob/master/img/cccc.png)

## 4.mysqldump.sh 数据库备份
**通过定时脚本实现数据库的日常备份**
## 5.实现汉子转换拼音
## 人名转拼音模块，暂不添加
```python
str = '崔建哲，中国，狸米，大傻，杨和苏'
kk = ''
pin = pypinyin.pinyin(str,style=pypinyin.NORMAL)
for n in pin:
    kk += ''.join(n)
print(kk)
```
效果：`cuijianzhe，zhongguo，limi，dasha，yanghesu`
