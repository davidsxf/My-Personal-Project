# -*- coding: utf-8 -*-
'''
减去平均数
计算协方差矩阵
计算协方差矩阵的特征值和特征向量
将特征值从大到小排序
保留最大的K个特征向量
将数据转换到上述K各特征向量构建的新空间中
'''
from numpy import *

def loadDataSet(fileName, delim='\t'):
    fr = open(fileName)
    stringArr = [line.strip().split(delim) for line in fr.readlines()]
    datArr = [map(float,line) for line in stringArr]
    return mat(datArr)

def pca(dataMat, topNfeat=999999):
    meanVals = mean(dataMat, axis=0)
    DataAdjust = dataMat - meanVals           #减去平均值
    covMat = cov(DataAdjust, rowvar=0)
    eigVals,eigVects = linalg.eig(mat(covMat)) #计算特征值和特征向量
    #print eigVals
    eigValInd = argsort(eigVals)
    eigValInd = eigValInd[:-(topNfeat+1):-1]   #保留最大的前K个特征值
    redEigVects = eigVects[:,eigValInd]        #对应的特征向量
    lowDDataMat = DataAdjust * redEigVects     #将数据转换到低维新空间
    reconMat = (lowDDataMat * redEigVects.T) + meanVals   #重构数据，用于调试
    return lowDDataMat, reconMat


# 测试数据testSet.txt由1000个数据点组成。
#下面对数据进行降维，并用matplotlib模块将降维后的数据和原始数据一起绘制出来。
import matplotlib
import matplotlib.pyplot as plt

dataMat = loadDataSet('testSet.txt')
lowDMat, reconMat = pca(dataMat,1)
print "shape(lowDMat): ",shape(lowDMat)

fig = plt.figure()
ax = fig.add_subplot(111)
ax.scatter(dataMat[:,0].flatten().A[0],dataMat[:,1].flatten().A[0],marker='^',s=90)
ax.scatter(reconMat[:,0].flatten().A[0],reconMat[:,1].flatten().A[0],marker='o',s=50,c='red')
plt.show()
