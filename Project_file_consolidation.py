import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import os

from sklearn.decomposition import PCA as pca
from sklearn.decomposition import FactorAnalysis as fact
from sklearn import preprocessing
from factor_analyzer import FactorAnalyzer

import sklearn.metrics as metcs
from scipy.cluster import hierarchy as hier
from sklearn import cluster as cls

dir = r'C:\Priyanka_Spring2020\R_Python'

os.chdir(dir)

Tornadoes_data1 = pd.read_csv('Tornadoes_SPC_1950to2015.csv', sep = ",")
Tornadoes_data2 = pd.read_csv('2018_torn_prelim.csv', sep = ",")
Tornadoes_data3 = pd.read_csv('2017_torn.csv', sep = ",")
Tornadoes_data4 = pd.read_csv('2016_torn.csv', sep = ",")


cols1 = ["om","yr","mo","dy","tz","st","stf","stn","mag","inj","fat","loss","closs","slat","slon","elat","elon","len","wid","fc"]
Tornadoes_data1 = Tornadoes_data1.filter(cols1, axis = 1)
Tornadoes_data2 = Tornadoes_data2.filter(cols1, axis = 1)
Tornadoes_data3 = Tornadoes_data3.filter(cols1, axis = 1)
Tornadoes_data4 = Tornadoes_data4.filter(cols1, axis = 1)


Tornadoes_data = pd.concat([Tornadoes_data1,Tornadoes_data2,Tornadoes_data3,Tornadoes_data4])

cols2 = ["om","yr"]
Tornadoes_data5 = Tornadoes_data.filter(cols2, axis = 1)

Tornadoes_data5.to_csv('C:\Priyanka_Spring2020\R_Python\Tornadoes_data5.csv')








