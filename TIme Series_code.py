from sqlalchemy import create_engine
from sqlalchemy.sql import select
import pandas as pd
import numpy as np
import pymysql
engine =create_engine("mysql+pymysql://root:WELcome@123@127.0.0.1:3306/temp")
conn = engine.connect()
data=pd.read_sql('select * from tornadoes_data_yr_count',conn)

tornadoes_data_yr_count = data

tornadoes_data_yr_count.to_csv('C://Priyanka_Spring2020//R_Python//tornadoes_data_yr_count.csv')

from pandas import read_csv
from matplotlib import pyplot
series = read_csv('tornadoes_data_yr_count.csv', header=0, index_col=0, parse_dates=True, squeeze=True)
series.plot(figsize=(14,6))
pyplot.show()

# create a scatter plot
from pandas import read_csv
from matplotlib import pyplot
from pandas.plotting import lag_plot
series = read_csv('tornadoes_data_yr_count.csv', header=0, index_col=0, parse_dates=True, squeeze=True)
lag_plot(series)
pyplot.show()

