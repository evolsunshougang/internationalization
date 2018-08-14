#! /usr/bin/python
# coding=utf-8

import xlrd
jspath = "./target/form.txt"  # js中文导出文件路径
path = 'file.xls'
strs = ''
data = xlrd.open_workbook(path)
table = data.sheets
table = data.sheet_by_name('Sheet1')
n = 0
i = 0
file = open(jspath,'w+')
for n in range(table.nrows):
    for i in range(table.ncols):
		str = str + table.row_values(n)[i]+"\n"
strs = str
file.write(strs)
