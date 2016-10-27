# -*- coding: utf-8 -*-
#############################################################
# 案例分析
# 1载入数据
import pandas as pd
df=pd.read_csv('https://raw.githubusercontent.com/rasbt/python_reference/master/Data/some_soccer_data.csv')
df

# 2列的重命名
df.columns=[c.lower() for c in df.columns]   #########列名称小写化
df.tail(3)                                   #最后三行数据

df=df.rename(columns={'p':'points',          #########特定列名称的重命名
                      'gp':'games',
                      'sot':'shots_on_target',
                      'g':'goals',
                      'a':'assists',
                      'ppg':'points_per_game'})
df.tail(3)

# 3运用函数处理数据

###########改变列中的值
# 去除球员薪水中的单位$m
df['salary']=df['salary'].apply(lambda x:x.strip('$ m'))
df.tail(3)


###########增加新列 team position
df['team']=pd.Series('',index=df.index)        #方法一
df.insert(loc=8,column='position',value='')    #方法二
df.tail(3)


##########处理球员列(有问题)
def process_player_col(text):
    name, rest = text.split('\n')
    position, team = [x.strip() for x in rest.split(' — ')]
    return pd.Series([name, team, position])
df[['player', 'team', 'position']] = df.player.apply(process_player_col)
df.tail(3)


#########处理项中的大写字母
cols=['player','position','team']
df[cols]=df[cols].applymap(lambda x:x.lower())
df.head()

# 4处理NAN值
#########计算存在NAN的列数
nans=df.shape[0]-df.dropna().shape[0]
print('% d rows have missing values'% nans)

#########选择存在NAN的列
df[df['assists'].isnull()]

#########选择没有NAN的列
df[df['assists'].notnull()]

#########对空值进行填充
df.fillna(value=0,inplace=True)
df


# 5行的处理
########增加新的行
import numpy as np
df=df.append(pd.Series([np.nan]*len(df.columns),#fill cells with NaNs
                       index=df.columns),
            ignore_index=True)
df.tail(3)


########对新的行进行赋值
df.loc[df.index[-1],'player']='messi'
df.loc[df.index[-1],'salary']=25.8
df.loc[df.index[-1],'games']=40
df.loc[df.index[-1],'goals']=50
df.loc[df.index[-1],'assists']=20
df.loc[df.index[-1],'shots_on_target']=100
df.loc[df.index[-1],'points_per_game']=24
df.loc[df.index[-1],'points']=450
df.loc[df.index[-1],'position']='forward'
df.loc[df.index[-1],'team']= 'barcelona'
df.tail(3)




# 6排序以及重新索引
df.sort('goals',ascending=False,inplace=True)
df.head()

#########在排序后，重塑索引
df.index=range(1,len(df.index)+1)
df.head()


#########更新列
df_2=df.copy()
df_2.loc[0:2,'salary']=[20.0,15.0]
df_2.head(3)

########使用球员列作索引
df.set_index('player',inplace=True)
df.head(3)
df_2.set_index('player',inplace=True)
df_2.head(3)

########更新薪水列的值
df.update(other=df_2['salary'],overwrite=True)
df.head(3)

#######重新设置新的索引
df.reset_index(inplace=True)
df.head(3)


#7数据库式检索
######选择在阿森纳或切尔西效力的球员
df[(df['team']=='arsenal')|(df['team']=='chelsea')]

#####选择在arsenal队中的前锋
df[(df['team']=='arsenal')&(df['position']=='forward')]


