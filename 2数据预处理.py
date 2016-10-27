# -*- coding: utf-8 -*-
"""
Created on Sun Oct 16 13:28:10 2016

@author: zydeve
"""
#################################### 1 pandas的引入
from pandas import Series,DataFrame
import pandas as pd
import numpy as np

#################################### 2 pandas中的数据结构
# Series:一维数组与numpy的一维数组array类似，与Python的基本数据结构list类似。区别在于list可以存储不同数据类型，
# 而Series 和Numpy必须存储相同数据类型
# DataFrame：二维的表格型数据类型

# 2.1Series
# Series对象两个主要的属性：index和values
s=Series([1,2,3.0,'abc'])
s

s1=Series(data=[1,3,5,7],index=['a','b','c','d'])
s1

s1.index
s1.values


# 2.2DataFrame
# 类似于电子表格的数据结构，DataFrame有行与列的索引。可以看做是一个Series的字典
# 常用一个相等长度列表的字典或Numpy数组：
data={'state':['ssd','fda','sa','edq','deqd'],
      'year':[2000,2001,2002,2003,2001],
    'pop':[1.5,1.7,3.6,2.4,2.9]}
frame=DataFrame(data)
frame
# 与Series一样，DataFrame也会索引自动分配，并且对列进行随机排序
# 自定义列的顺序
DataFrame(data,columns=['year','state','pop'])

# 传一个空值列，表示为NA值
frame2=DataFrame(data,columns=['year','state','pop','debt'])
frame2

# DataFrame中的一列可以通过字典记法或属性来检索
frame2['state']
#赋值
frame2['debt']=15



##################################### 3 数据清洗
# 3.1 处理缺失数据
#3.1.1 当作空值丢弃掉
string_data=Series(['sjsjdjs','sdada','fwfwf','rgwg'])
string_data
string_data.isnull()

string_data[0]=None   #替换掉第一个值为None值，被当作为NA处理
string_data
string_data.isnull()

# 处理NA的四种方法：dropna,fillna,isnull,notnull



# dropna重点讲解：
########## 丢弃行
# dropna返回一个仅含非空数据和索引值的Series
from numpy import nan as NA
data=Series([1,NA,3,NA,7])
data.dropna()

# dropna默认丢弃任何含有缺失值的行(只要有NA的行 就被消灭掉了)
data=DataFrame([[1,2,3,4],[1,NA,3,NA],[NA,NA,NA,NA],[3,4,5,NA]])
data
cleaned=data.dropna()
cleaned

# 传入参数how将只会丢弃那些全为NA的行，默认any,修改为all
data.dropna(how='all')   


########丢弃列
data[4]=NA
data
data.dropna(axis=1,how='all')



#3.1.2 填补空值
data.fillna(4)    #将所有的NA填补为40




# 检测和过滤异常值
data=DataFrame(np.random.randn(1000,4))     #异常值（outlier）的过滤或变换运算在很大程度上就是数组运算
data.describe()

# 找出绝对值超过3的项
col=data[3]
col[np.abs(col)>3]

# 选出所有的绝对值超过3的值的所以行，可以利用布尔型索引和any方法
data[(np.abs(data)>3).any(1)]



#3.1.3 移除重复数据
from pandas import Series,DataFrame
import pandas as pd
import numpy as np
data=pd.DataFrame({'k1':['one']*3+['two']*4,
                   'k2':[1,1,2,3,3,4,4]})
data
# DataFrame的duplicated方法返回一个布尔型Series，表示各行是否是重复行：
data.duplicated()
data.drop_duplicates()  #移除了重复行






















