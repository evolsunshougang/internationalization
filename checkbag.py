# coding=utf-8
import os.path

from chineseChange import *  # 匹配中文的正则
from form import *  # 表单中文的匹配正则
formpath = "./target/form.txt"  # 表单中文导出文件路径
def getCn(root):
	file_count = 0  # 文件个数
	formcontent='';
	for parent, dirnames, filenames in os.walk(root):

		for filename in filenames:  # 输出文件信息
			if filename.endswith('jsp') > 0:
				file_count += 1
				file = open(parent + '/' + filename)
				for line in file:
					pass
					if line.find(',') > 0:
						strn = line.split(',');
						for strs in strn:
							formtext = check_form(strs)  # 表单中文
							# 表单中文匹配
							formcontent = formcontent + "&" + check_contain_chinese(formtext) + "&" + filename + "\n"
					else:
						formtext = check_form(line)  # 表单中文
						# 表单中文匹配
						formcontent = formcontent + "&" + check_contain_chinese(formtext) + "&" + filename + "\n"
					view = open(formpath, 'w')
					view.write(formcontent)
					view.close()
				file.close()
				if os.path.exists(formpath) == False:  # 是否存在form表单中文路径
					os.mkdir(formpath);
				# if os.path.exists(titlepath) == False:  # 是否存在标题中文路径
				# 	os.mkdir(titlepath);
				# if os.path.exists(jspath) == False:  # 是否存在js中文路径
				# 	os.mkdir(jspath);
				print "文件名" + filename

			# print "the full name of the file is comploted:" + filename #输出文件路径信息
	print 'completed file count=' + str(file_count)
