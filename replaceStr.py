# coding=utf-8
import os
import os.path

import xlrd
from writeExcel import  excel_table_byindex

rootdir =  "./jdcx"                                 # 指明被遍历的文件夹

for parent,dirnames,filenames in os.walk(rootdir):    #三个参数：分别返回1.父目录 2.所有文件夹名字（不含路径） 3.所有文件名字
	for filename in filenames :
		if filename.endswith('jsp') > 0:
			file = open(parent + '/' + filename,"r+")
			for line in file :
				fname = "file.xls"
				bk = xlrd.open_workbook(fname)
				shxrange = range(bk.nsheets)
				try:
					sh = bk.sheet_by_name("Sheet1")
				except:
					print "no sheet in %s named Sheet1" % fname
				# 获取行数
				nrows = sh.nrows
				# 获取列数
				ncols = sh.ncols
				# 获取各行数据
				for i in range(1, nrows):
					row_data = sh.row_values(i)
					file.write(line.replace("流程类型", "<fmt:message key=\"shiyanchul\">"))
			file.close()