# -*- coding: utf-8 -*-
#################################################################### Numpy提供了两种基本对象：ndarray多维数组和ufunc处理数据函数
import numpy as np

# 1 ndarray
a=np.array([1,2,3,4])
b=np.array([5,6,7,8])
c=np.array([[1,2,3,4],[4,5,6,7],[7,8,9,10]])
a,b,c
a
b
c
c.dtype
a.shape

c.shape
c

c.shape=2,-1 #某个轴的元素为-1时，将根据元素的个数自动计算此轴的长度

# reshape方法创建改变尺寸的新数组，原数组的shape保持不变
d=c.reshape((6,2))
# 但是d和c共享了数组存储区域内的数据，修改一个另一个会改变

e=np.array([[1,2,3,4],[4,5,6,7],[7,8,9,10]],dtype=np.float)
e


# 2 ufunc运算
#能够对数组的每个元素进行操作，在C语言的级别实现的，计算速度非常快
import numpy as np
x=np.linspace(0,2*np.pi,10)
# 对数组x中的每个元素进行正弦计算，返回一个同样大小的新数组
y=np.sin(x)
y

# 单个值计算
np.sin(0.5)


########################################################################Scipy数值计算库
# 1 Scipy进行最小二乘拟合：最小二乘拟合的函数leastsq
import numpy as np
from scipy.optimize import leastsq
import pylab as pl

def func(x,p):
    """
    数据拟合所用的函数：A*sin(2*pi*k*x+theta)
    """
    A,k,theta=p
    return A*np.sin(2*np.pi*k*x+theta)
def residuals(p,y,x):
    """
    试验数据x,y和拟合函数之间的差，p为拟合需要找到的系数
    """
    return y-func(x,p)
x=np.linspace(0,-2*np.pi,100)
A,k,theta=10,0.34,np.pi/6           #真实数据的函数参数
y0=func(x,[A,k,theta])              #真实数据
y1=y0+2*np.random.randn(len(x))     #加入噪声之后的实验数据

p0=[7,0.2,0]                        #第一次猜测的函数拟合参数

#调用的leastsq进行数据拟合
#residuals为计算误差的函数
#p0为拟合参数的初始值
#args为需要拟合的实验数据
plsq=leastsq(residuals,p0,args=(y1,x))

print u"真实参数：",[A,k,theta]
print u"拟合参数：",plsq[0]        #实验数据拟合后的参数


#一起运行
pl.plot(x,y0,label=u"真实数据")
pl.plot(x,y1,label=u"带噪声的实验数据")
pl.plot(x,func(x,plsq[0]),label=u"拟合数据")
pl.legend()
pl.show()

  

# 2 函数最小值
# optimize库提供了几个求函数最小值的算法：
# fmin   min_powell     fmin_cg      fmin_bfgs    