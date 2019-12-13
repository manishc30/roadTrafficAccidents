#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Aug 12 18:52:32 2019

@author: manish
"""

#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Aug 12 14:03:35 2019

@author: manish
"""

from string import ascii_uppercase
from sklearn import preprocessing, model_selection, metrics, ensemble
import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split
#from sklearn.metrics import accuracy_score
from sklearn.ensemble import AdaBoostClassifier

from sklearn.svm import SVC
from sklearn import metrics
from sklearn.metrics import confusion_matrix, accuracy_score


pd.options.mode.chained_assignment = None  # default='warn'

df_accident = pd.read_csv("/home/hduser/Desktop/PFDA-VM-Share/sf_PFDA_VM_Share/PFDA_Project/ml/Accidents.csv")

with open("/home/hduser/Desktop/PFDA-VM-Share/sf_PFDA_VM_Share/PFDA_Project/ml/Accidents.csv", 'r') as f:
    df_accident = pd.read_csv(f,encoding='utf-8')
    

#df_accident.describe()

#df_accident.columns

#df_accident['Accident_Severity']


# Preprocessing
df_accident['Date']=pd.to_datetime(df_accident['Date'], format='%d/%m/%Y')
df_accident['Time']=pd.to_datetime(df_accident['Time'], format='%H:%M')


# 1 is fatal(1.249%), 2 is Severe(17.22%), and 3 is Slight(81.52%)
print('Severity of Accident: '+str(float(len(df_accident[df_accident['Accident_Severity']==3]))/float(len(df_accident))*100)[:5]+'%')


print('Police Attended: '+str(float(len(df_accident[df_accident['Did_Police_Officer_Attend_Scene_of_Accident']==0]))/float(len(df_accident))*100)[:5]+'%')


#GBM requires y labels to start at 0
df_accident['Did_Police_Officer_Attend_Scene_of_Accident']=df_accident['Did_Police_Officer_Attend_Scene_of_Accident'].replace(2,0)

#drop na
df_accident=df_accident.dropna()

#encode categorical variables as integers for GBM
le=preprocessing.LabelEncoder()
lizt=df_accident.select_dtypes([object]).columns.values

print(df_accident.dtypes)
total = df_accident.isnull().sum().sort_values(ascending=False)
percent = (df_accident.isnull().sum()/df_accident.isnull().count()).sort_values(ascending=False)
missing_data = pd.concat([total, percent], axis=1, keys=['Total', 'Percent'])
missing_data.head(5)

#some missing LSOA data before encoding

# No Need of Plots in pyspark
# Location plot of accidents
#plt.figure(figsize=(10,15))
#plt.scatter(df_accident['Longitude'],df_accident['Latitude'],c=df_accident['Accident_Severity'])
#plt.ylim((49.8,61))
#plt.xlim((-8.5,2))
#plt.show()



# Number of vehicles involved in accidents. For fatal accidents(1), there are more number of vehicles involved
#f, ax = plt.subplots(figsize=(12, 8))
#ax = sns.violinplot(x="Accident_Severity", y="Number_of_Vehicles",data=df_accident, palette="muted")

# Feature correlations (Not working)
#sns.set(style="white")

#corrmat = df_accident.corr()

#mask = np.zeros_like(corrmat, dtype=np.bool)
#mask[np.triu_indices_from(mask)] = True

#f, ax = plt.subplots(figsize=(12, 9))

#cmap = sns.diverging_palette(220,10, as_cmap=True)


# SHows the correlation
#sns.heatmap(corrmat, vmax=.9, square=True, linewidths=.5, cbar_kws={"shrink": .5},mask=mask, cmap=cmap, ax=ax)
#plt.title("Correlation Matrix")
#plt.show()

#cols=['Number_of_Vehicles','Road_Surface_Conditions','Special_Conditions_at_Site','Light_Conditions']
#sns.pairplot(df_accident,vars=cols,hue='Accident_Severity', hue_order=[3,2,1], size = 2.5)


# Model building

# Building train and test sets
X=df_accident.drop(['Accident_Severity','Accident_Index','Time','Date','LSOA_of_Accident_Location','Local_Authority_.Highway.'], axis=1) #drop
y=df_accident['Accident_Severity']
X_train, X_test, y_train, y_test=model_selection.train_test_split(X,y, test_size=0.30)


# Checking data has been formatted correctly
print(X_train.dtypes)


svc=SVC(probability=True, kernel='linear')

# Adaboost
clf = AdaBoostClassifier(n_estimators=50,learning_rate=1)
model = clf.fit(X_train, y_train)

y_pred = model.predict(X_test)
cm = confusion_matrix(y_test, y_pred)
print (cm)

print("Accuracy:", accuracy_score(y_test, y_pred))
