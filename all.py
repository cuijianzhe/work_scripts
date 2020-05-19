import random
'''
Autor:cuijianzhe 
The 
#这里要用到random函数中的随机生成一个区间的整数 randint 函数模块
'''
def generate_code(code_len):
    all_char = '0123456789qazwsxedcrfvtgbyhnujmikolpQAZWSXEDCRFVTGBYHNUJIKOLP!@#$%^&*()><?'
    index = len(all_char) - 1
    code = ''
    for _ in range(int(code_len)):
        num = random.randint(0,index)
        code += all_char[num]
        res = ''.join(code)
    return res
count = input('请输入你要产生多少条密码：').strip()
length = input('请输入你要产生密码的长度:').strip()
for _ in range(int(count)):
    print(generate_code(length))
    with open('passwds.txt','a+') as fw:
        fw.seek(0)
        fw.writelines(generate_code(length) + '\n')

