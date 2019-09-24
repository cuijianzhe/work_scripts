# port-discovery
my first github,
**port_discovery.py:Automatic port discovery based on Python 3 ---端口以及服务名自动发现

**Huawei_AP_discovery.py:Automatic discovery of Huawei AP on Python 3---自动发现华为无线AP
'''bash
[root@zabbix /data/shell]# python3 Huwei_AP_discovery.py 
{
    "data":[
        {
            "{#APID}":"0 ",
            "{#APNAME}":"area9-9"
        },
        {
            "{#APID}":"1 ",
            "{#APNAME}":"area8-12"
        },
        {
            "{#APID}":"2 ",
            "{#APNAME}":"area8-14"
        },
        {
            "{#APID}":"3 ",
            "{#APNAME}":"area6-48"
        },
        {
            "{#APID}":"4 ",
            "{#APNAME}":"area6-50"
        },
        {
            "{#APID}":"5 ",
            "{#APNAME}":"area8-52"
        },
        {
            "{#APID}":"6 ",
            "{#APNAME}":"area6-49"
        },
        {
            "{#APID}":"7 ",
            "{#APNAME}":"area6-47"
        }
     ]
 }

'''

dingcard.py: **独立跳转ActionCard类型 传参到钉钉自定义机器人


author: cuijianzhe.

## dingtalk.py
**向钉钉发送markdown消息**

默认标题：网络设备故障问题: {EVENT.NAME}

<font color=#dd0000 size=3 >网络设备故障问题：{TRIGGER.NAME}
</font>
> 服务端报警内容如下，请及时处理！
> - 故障时间：{EVENT.DATE} {EVENT.TIME} 
> - 当前时间：{DATE} {TIME} 
> - 持续时长: {EVENT.AGE}inute  
> - 故障级别：{TRIGGER.SEVERITY}
> - 故障 ID：{EVENT.ID}
{TRIGGER.URL}
> - 故障设备： {HOST.NAME}
> 
> - 状态：**{ITEM.LASTVALUE}**
>
![](http://blog.cjzshilong.cn/images/xx.png)
>
#### [内网设备监控平台链接地址](http://192.168.51.202:3000)
#### 用户：limi
#### 密码：jhzxxb@100
如图：
https://github.com/cuijianzhe/discover_server/blob/master/zabbix_ding.png

![](https://github.com/cuijianzhe/discover_server/blob/master/zabbix_ding.png)
