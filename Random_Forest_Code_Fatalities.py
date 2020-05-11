import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier

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

Tornadoes_data1 = pd.read_csv('Tornadoes_data.csv', sep = ",")

cols1 = ["om","yr","mo","dy","tz","stf","stn","mag","inj","loss","closs","slat","slon","elat","elon","len","wid","fc"]
Tornadoes_data = Tornadoes_data1.filter(cols1, axis = 1)

# Labels are the values we want to predict
labels = np.array(Tornadoes_data['fat'])
# Remove the labels from the features
# axis 1 refers to the columns
features= Tornadoes_data.drop('fat', axis = 1)
# Saving feature names for later use
feature_list = list(Tornadoes_data.columns)
features_list2 = list(Tornadoes_data.drop('fat', axis = 1).columns)
# Convert to numpy array
features = np.array(features)

# Split the data into training and testing sets
train_features, test_features, train_labels, test_labels = train_test_split(features, labels, test_size = 0.25, random_state = 42)

scaler = StandardScaler()
scaler.fit(train_features)
print(scaler.transform(train_features))

scale_train = scaler.transform(train_features)
# [[-1.]
#  [-1.]
#  [ 1.]
#  [ 1.]]
print(scaler.mean_)
# [0.5]
print(scaler.var_)
# [0.25]: sample variance

scaler = StandardScaler()
scaler.fit(test_features)
print(scaler.transform(test_features))

scale_test = scaler.transform(test_features)

# Parameters based on training data is applied.

# Import the model we are using
from sklearn.ensemble import RandomForestRegressor
# Instantiate model with 1000 decision trees
rf = RandomForestRegressor(n_estimators = 1000, random_state = 42)
# Train the model on training data
rf.fit(train_features, train_labels)

predictions = rf.predict(test_features)

from sklearn.metrics import mean_squared_error


mean_squared_error(test_labels, predictions, sample_weight=None, multioutput='uniform_average', squared=True)

pd.crosstab(test_labels, predictions, rownames=['True'], colnames=['Predicted'], margins=True)