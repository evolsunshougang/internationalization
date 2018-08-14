# encoding: utf-8
import json

import requests
url = "https://cloud.huatu.com/user/fore/login/do-login.json"
data = {
  "phoneNo": "18511664692",
  "verifyCode": "180125",
  "token": "null"
}
temp =json.dumps(data)
headers = {"content-type":"application/json"}
r = requests.post(url,data=temp,headers=headers)
r_state = r.status_code
print(r_state)
if r_state == 200:
    print("测试通过")
else:
    print("测试不通过")

url = 'https://login.woego.cn/woego/login/pageInit'
data = {
    'staffId':'wangyi',
    'password':'888888Aa',
    'verifyCode':'null'
}
temp = json.dumps(data)
headers = {"content-type":"application/json"}
r = requests.post(url,data=temp,headers=headers)
r_state = r.status_code
print(r_state)
if r_state == 200:
    print("测试通过")
else:
    print("测试不通过")

url = 'https://login.woego.cn/woego/captcha/CapthcaImage?a=1521016225326'
headers = {"content-type":"application/json"}
r = requests.get(url,headers=headers)
r_state = r.status_code
print(r_state)
if r_state == 200:
    print("测试通过")
else:
    print("测试不通过")


