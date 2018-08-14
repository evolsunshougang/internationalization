# coding=utf-8
import os.path

import mysqldbhelper

db = mysqldbhelper.DatabaseConnection('192.168.12.132',
									  user='u_config',
									  passwd='maLwrO1s',
									  db='huatu_config')
#
#
# # 批量插入数据
# values = []
# for i in range(3, 20):
# 	values.append((i, 'kk' + str(i)))

db.put('''INSERT INTO t_level(level_id,level_name,creater_id,creater_name,modifier_id, modifier_name, is_deleted ) 
values(%s,%s,%s,%s,%s,%s,%s)''',('99', '测试','1','系统管理员','1','系统管理员','0'))






# rootdir = "./jdcx"  # 源文件路径


# formpath = "./target/form.txt"  # 表单中文导出文件路径
# # titlepath = "./target/title.txt"  # 列表中文导出文件路径
# # jspath = "./target/js.txt"  # js中文导出文件路径
# formtext = ''  # 匹配出表单的html
# formcontent = ''  # 匹配出表单中文
# titletext = ''  # 匹配出列表的js
# titlecontent = ''  # 匹配出列表中文
# jstext = ''  # 匹配出js
# jscontent = ''  # 匹配出js中的中文
