# coding=utf-8
import os.path

from chineseChange import *  # 匹配中文的正则
from form import *  # 表单中文的匹配正则
from js import *  # js里的中文匹配正则
from title import *  # 列表标题的中文匹配正则

rootdir = "./jdcx"  # 源文件路径
formpath = "./target/form.txt"  # 表单中文导出文件路径
titlepath = "./target/title.txt"  # 列表中文导出文件路径
jspath = "./target/js.txt"  # js中文导出文件路径
file_count = 0  # 文件个数
formtext = ''  # 匹配出表单的html
formcontent = ''  # 匹配出表单中文
titletext = ''  # 匹配出列表的js
titlecontent = ''  # 匹配出列表中文
jstext = ''  # 匹配出js
jscontent = ''  # 匹配出js中的中文
for parent, dirnames, filenames in os.walk(rootdir):

	for filename in filenames:  # 输出文件信息
		if filename.find('jsp') > 0:
			file_count += 1
			file = open(rootdir + '/' + filename)
			for line in file:
				pass
				formtext = check_form(line)  # 表单中文
				titletext = check_title(line)  # 列表的标题
				jstext = check_js(line)  # js的中文
				# 表单中文匹配
				formcontent = formcontent + "&" + check_contain_chinese(formtext) + "&" + filename + "\n"
				view = open(formpath, 'w')
				view.write(formcontent)
				view.close()
				# 列表标题中文匹配
				if "[" in titletext:
					for text in titletext.split(','):
						titlecontent = titlecontent + "&" + check_contain_chinese(text) + "&" + filename + "\n"
						view = open(titlepath, 'w')
						view.write(titlecontent)
						view.close()
				# js中文匹配
				jscontent = jscontent + "&" + check_contain_chinese(jstext) + "&" + filename + "\n"
				view = open(jspath, 'w')
				view.write(jscontent)
				view.close()

			file.close()
			if os.path.exists(formpath) == False:  # 是否存在form表单中文路径
				os.mkdir(formpath);
			if os.path.exists(titlepath) == False:  # 是否存在标题中文路径
				os.mkdir(titlepath);
			if os.path.exists(jspath) == False:  # 是否存在js中文路径
				os.mkdir(jspath);
			print "文件名" + filename

			# print "the full name of the file is comploted:" + filename #输出文件路径信息
print 'completed file count=' + str(file_count)
