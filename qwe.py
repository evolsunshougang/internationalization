#! /usr/bin/python
# coding=utf-8

#读取网页内容生成HTML文件
import urllib2
import re
from bs4 import BeautifulSoup
target =''
response = urllib2.urlopen('https://epay.10010.com/helpcenter/')
html = response.read()
soup = BeautifulSoup(html,"html.parser")
html=unicode(html,'utf-8')

results =re.findall(ur"[\u4e00-\u9fa5]+",html)
for result in results:
	target = target + result
print  target
file = open("ng.txt","w")
file.write(target.encode('gb2312'))
