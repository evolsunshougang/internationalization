#-*- coding:utf-8 -*-

import re
import urllib2
import sys
import re

from pip._vendor.requests.packages import chardet

reload(sys)
#截取列表中文
#正则匹配结果   例如： ['id','资质类型','状态','认可时间','限制说明中文','限制说明英文','备注']
type= sys.setdefaultencoding('utf-8')
#截取列表中文
#正则匹配结果   例如： ['id','资质类型','状态','认可时间','限制说明中文','限制说明英文','备注']
def check_title(check_str):
	target=""
	temp=check_str.decode("utf8")

	pattern = re.compile(u'[\[].*]')

	results=pattern.findall(temp)
	for result in results:
		target=target+result
	return target
#print check_title("colNames: ['id','资质类型','状态','认可时间','限制说明中文','限制说明英文','备注'], ")


def getProvince(mainUrl):
	headers = {'User-Agent': 'Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.6) Gecko/20091201 Firefox/3.5.6'}
	req = urllib2.Request(mainUrl);
	resp = urllib2.urlopen(req);
	respHtml = resp.read();
	char_type = chardet.detect(respHtml);
	#
	print  char_type;
	respHtml = unicode(respHtml, "GBK").encode("utf8")
	# pattern = re.compile(u'<ul class="interval01-list">')
	# results=respHtml[respHtml.rfind('<ul class="interval01-list">') +1 :respHtml.rfind('<!--有参数配置 start-->')]
	print respHtml


	print getProvince("https://car.autohome.com.cn/price/brand-25.html");