# -*- coding: utf-8 -*-
# 1 open函数
file=open( 'test.txt','r')
line=file.readline()
line=file.readlines()
print line
file.close


# 2 linecache缓存优化
import linecache
print linecache.getline('test.txt',2)
print linecache.getlines('test.txt')


# 3 word读取
from win32com import client               #从win32包中引入client包
word=client.Dispatch('Word.Application')  #创建对象实例
doc=word.Documents.Open('test.doc')       #打开
print doc.content                         #打印
doc.Close()                               #关闭
word.Quit()


# 4 excel读取

# 加载模块
import xlrd
data=xlrd.open_workbook('test.xls')

#查看并打印文件中包含的sheet的名称
sheet_names=data.sheet_names()     
print "sheet names:",sheet_names

#通过索引顺序获取
table=data.sheet_by_index(0) 
table      

#获取第一张工作表的行数和列数
nrows=table.nrows
print "rows number:",nrows
ncols=table.ncols
print "cols number:",ncols

#获取第一张工作表的第2行和第2列的值（数组）
print "the value of the 2nd row:",table.row_values(2)
print "the value of the 2nd col:",table.col_values(2)

# 获取特定单元格的值
print "the value of the 1st row of the 1st col:",table.cell_value(2,0)
print "the value of the 1st row of the 2st col:",table.cell_value(3,1)


# 5 数据库读取
# MySQL数据库
import MySQLdb
db=MySQLdb.connect("localhost","root","7125","company")    #主机名  用户名  密码  数据库
#使用cursor()方法获取操作游标
cursor=db.cursor()
# SQL查询语句
sql="select * from t_employee \
        where empno=7369"
try:
    #执行SQL语句
    cursor.execute(sql)
    #获取所有记录的列表
    results=cursor.fetchall()
    for row in results:
        empno=row[0]
        ename=row[1]
        job=row[2]
        mgr=row[3]
        hiredate=row[4]
        sal=row[5]
        comm=row[6]
        deptno=row[7]
        #打印结果
        print "empno=%s,ename=%s,job=%s,mgr=%s,hiredate=%d,sal=%d,comm=%d,deptno=%s" % \
                (empno,ename,job,mgr,hiredate,sal,comm,deptno)
except:
    print "Error:unable to fecth data"
# 关闭数据库
db.close()