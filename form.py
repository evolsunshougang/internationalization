#-*- coding:utf-8 -*-

import sys
import re 
reload(sys)
#截取表单中文
#正则匹配结果   例如： 保存
sys.setdefaultencoding('utf-8')
def check_form(check_str):
	target=""
	temp=check_str.decode("utf8")

	pattern = re.compile(u'.*>*<')
	if temp.find('==')> 0 :
		results='';
	elif temp.find('/')>0:
		results ='';
	elif temp.find('*')>0:
		results='';
	elif temp.find('-')>0:
		results='';
	elif temp.find('!=') > 0:
		results = '';
	else :
		results = temp;
	for result in results:
		target=target+result
	return target	
