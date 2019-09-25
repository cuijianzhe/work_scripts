#!/bin/env python3
import pypinyin
str = '崔建哲，中国，狸米，大傻，杨和苏'
kk = ''
pin = pypinyin.pinyin(str,style=pypinyin.NORMAL)
for n in pin:
    kk += ''.join(n)
print(kk)
