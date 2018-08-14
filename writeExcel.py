# -*- coding: utf-8 -*-
import xlrd
import mysqldbhelper

db = mysqldbhelper.DatabaseConnection('192.168.12.132',
									  user='shougang',
									  passwd='shougang123',
									  db='bb_dictionary')
def open_excel(file= 'file.xls'):
    try:
        data = xlrd.open_workbook(file)
        return data
    except Exception,e:
        print str(e)
#根据索引获取Excel表格中的数据   参数:file：Excel文件路径     colnameindex：表头列名所在行的所以  ，by_index：表的索引
def excel_table_byindex(file= 'file.xls',colnameindex=0,by_index=0):
    data = open_excel(file)
    data.encoding = "GBK"
    table = data.sheets()[by_index]
    nrows = table.nrows #行数
    ncols = table.ncols #列数
    colnames =  table.row_values(colnameindex) #某一行数据
    list =[]
    for rownum in range(1,nrows):

         row = table.row_values(rownum)
         if row:
             app = {}
             for i in range(len(colnames)):
                app[colnames[i]] =row[i]
             list.append(app)
    return list

#根据名称获取Excel表格中的数据   参数:file：Excel文件路径     colnameindex：表头列名所在行的所以  ，by_name：Sheet1名称
def excel_table_byname(file= 'file.xls',colnameindex=0,by_name=u'Sheet1'):
    data = open_excel(file)
    table = data.sheet_by_name(by_name)
    nrows = table.nrows #行数
    colnames =  table.row_values(colnameindex) #某一行数据
    list =[]
    for rownum in range(1,nrows):
         row = table.row_values(rownum)
         if row:
             app = {}
             for i in range(len(colnames)):
                app[colnames[i]] = row[i]
             list.append(app)
    return list

def main():
   tables = excel_table_byindex()
   for row in tables:
       db.put('''INSERT INTO t_user_lihy(teacher_id, teacher_name, teacher_phone, city, branch_school_id, business_unit_id, 
teacher_center_id, monthly_teaching_hours, yearly_teaching_hours, total_teaching_hours, creater_id,
 creater_name, created_time, modifier_id, modifier_name, modified_time, is_deleted, 
 district, province, NICK_NAME, TEACHER_BELONG, teacher_type, sex, is_Competency, crm_teacher_id) 
                          values(%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)''',
              (row['username'], row['password'], row['nickname'], row['realname'], row['cellphone'], row['email'],
               row['is_locked'],
               row['is_deleted'], row['last_login_ip'], row['group_id'], row['branch_school_id'],
               row['branch_department_id'],
               row['province_id'], row['portrait_url'], row['org_id'], row['business_department_id'], row['weixin'],
               row['birthday'], row['is_employee'], row['is_student'], row['is_teacher'], row['gender'],
               row['teacher_id'],
               row['emp_no'], row['manager_emp_no'], row['student_open_id'], row['employee_open_id'],
               row['teacher_open_id'], row['crm_teacher_id']))


if __name__=="__main__":
    main()