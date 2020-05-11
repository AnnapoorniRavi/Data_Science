# -*- coding: utf-8 -*-
"""
Created on Sat Apr 18 13:32:54 2020

@author: Sahi
"""
import numpy as np # linear algebra
import pandas as pd # data processing, CSV file I/O (e.g. pd.read_csv)
import matplotlib.pyplot as plt
import seaborn as sbn
import datetime as dt
import os 

df = pd.read_csv('Tornadoes_SPC_1950to2015.csv',delimiter=',', encoding="utf-8-sig")
tornadoes_1950 = df[df['yr'] >= 1950][['st','loss']]
tornadoes_1950.head(10)

tornadoes_damage = pd.DataFrame({'count': tornadoes_1950.groupby(['st'])['loss'].count(), 'total_loss': tornadoes_1950.groupby(['st'])['loss'].sum()})
tornadoes_damage

#Separate the dataframe into series
count = tornadoes_damage['count'] 
loss = tornadoes_damage['total_loss']

#Find the state with maximum number of tornadoes and then get the index label and plot points
max_tornado_count = tornadoes_damage['count'].max()
max_tornado_cnt_label = tornadoes_damage[tornadoes_damage['count'] == max_tornado_count].index.tolist()[0]
max_tornado_cnt_x = tornadoes_damage[tornadoes_damage['count'] == max_tornado_count]['count']
max_tornado_cnt_y = tornadoes_damage[tornadoes_damage['count'] == max_tornado_count]['total_loss']

#Find the state with maximum amount of property damage and then get the index label and plot points
max_tornado_loss = tornadoes_damage['total_loss'].max()
max_tornado_loss_label = tornadoes_damage[tornadoes_damage['total_loss'] == max_tornado_loss].index.tolist()[0]
max_tornado_loss_x = tornadoes_damage[tornadoes_damage['total_loss'] == max_tornado_loss]['count']
max_tornado_loss_y = tornadoes_damage[tornadoes_damage['total_loss'] == max_tornado_loss]['total_loss']

#Prepare our plot
colors = np.random.rand(52)
area = count
plt.scatter(count, loss,s=area,c=colors,alpha=.5)

#Provide axis labels and a title
xlab = "Number of Tornadoes [in thousands]"
ylab = "Total Loss in million USD"
title = "Total Property Loss Since 1950 to 2018"

plt.xlabel(xlab)
plt.ylabel(ylab)
plt.title(title)

#set the axis limits
plt.xlim(0, 3500)
plt.ylim(0, 6000)

#Apply grid lines for good measure
plt.grid(True)

#Plot the max values for count and loss
plt.text(max_tornado_cnt_x, max_tornado_cnt_y, max_tornado_cnt_label)
plt.text(max_tornado_loss_x, max_tornado_loss_y, max_tornado_loss_label)

plt.show()

#Converting the time column format from object to timedelta

df.describe()
df['tz'].value_counts()

df['time'] = pd.to_timedelta(df['time'])

#storm_df.loc[storm_df['tz']==9,'time']
df.loc[df['tz']==9,'time'] = df.loc[df['tz']==9,'time'] - dt.timedelta(hours=5)

#storm_df.loc[storm_df['tz']==0,'date']
df['date'] = pd.to_datetime(df['date'], format='%m/%d/%Y')

print("FC values in the storm data:")
print(df['fc'].value_counts())
print("\n")
print("Unknown Magnitude Values:")
print(df['mag'].value_counts())

df['loss'].value_counts()

#Inspecting the loss values occured by tornadoes before and after the years 1984

df[df['yr']<1990].plot.line('date', 'loss')
df[df['yr']>=1990].plot.line('date', 'loss')

##Grouping Values Based on Loss 

df.loc[(df['yr']>=1990) & (df['loss'] > 0) & (df['loss'] < .00005),'loss'] = 1
df.loc[(df['yr']>=1990) & (df['loss'] >= .00005) & (df['loss'] < .0005),'loss'] = 2
df.loc[(df['yr']>=1990) & (df['loss'] >= .0005) & (df['loss'] < .005),'loss'] = 3
df.loc[(df['yr']>=1990) & (df['loss'] >= .005) & (df['loss'] < .05),'loss'] = 4
df.loc[(df['yr']>=1990) & (df['loss'] >= .05) & (df['loss'] < .5),'loss'] = 5
df.loc[(df['yr']>=1990) & (df['loss'] >= .5) & (df['loss'] < 5),'loss'] = 6
df.loc[(df['yr']>=1990) & (df['loss'] >= 5) & (df['loss'] < 50),'loss'] = 7
df.loc[(df['yr']>=1990) & (df['loss'] >= 50) & (df['loss'] < 500),'loss'] = 8
df.loc[(df['yr']>=1990) & (df['loss'] >= 500) & (df['loss'] <= 5000),'loss'] = 9

df.loc[(df['yr']>=1990) & (df['loss'] >= 500) & (df['loss'] <= 5000),'loss']

df['loss'].value_counts()

#Converting length in miles to yards based on the calculation 1 mile = 1760 yards

df['len'] = df['len']*1760
df.plot.scatter('yr','len', figsize=(13,8))
df.plot.scatter('yr','wid', figsize=(13,8))

df[(df['len']>300000) | (df['wid']>3000)]

df[['inj','fat','loss','closs','len','wid']].corr()

#Correlation matrix for the numeric dimensions/variables for storm data

names = df.dtypes[(storm_df.dtypes=='int64') | (storm_df.dtypes=='float64')].index
print(names)
cm = np.arange(0,len(names),1)
print(cm)

fig = plt.figure(figsize=(13,13))
ax1 = fig.add_subplot(111)
plt1 = ax1.matshow(df.corr(), vmin=-1, vmax=1, cmap=plt.get_cmap('PuOr'))
fig.colorbar(plt1)
ax1.set_xticks(cm)
ax1.set_xticklabels(names)
ax1.set_yticks(cm)
ax1.set_yticklabels(names)
plt.show()