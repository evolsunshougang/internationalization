#-*- coding:utf-8 -*-

import sys
import re 
reload(sys)
#截取中文
# sys.setdefaultencoding('utf-8')
def check_contain_chinese(check_str):
	target=""
	temp=check_str.decode("utf8")
	pattern = re.compile(u'[\u4e00-\u9fa5]')
	results=pattern.findall(temp)
	for result in results:
		target=target+result
	return target
print check_contain_chinese("sdf就sdf国sdf了sdf")

