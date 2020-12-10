#plot a broken bar timeline of EFW data products
# Convention for import of the pyplot interface
import matplotlib.pyplot as plt
import datetime as dt
from datetime import date, timedelta



#Define start/stop times for EFW data products


#RBSPa

#spinfit V12
dstarta = [date(2012,9,30)]
dstopa =  [date(2015,10,1)]
labela = ["sfv12"]
colora = ["blue"]


#spinfit V34
dstarta.append(date(2015,10,1))
dstopa.append(date(2019,9,1))
labela.append("sfv34")
colora.append("blue")

#spectral data
dstarta.append(date(2012,9,1))
dstopa.append(date(2019,9,1))
labela.append("spec V1,V2,E12,E34,SCMu,v,w")
colora.append("purple")

#Xspec mode 1
dstarta.append(date(2012,9,1))
dstopa.append(date(2016,8,1))
labela.append("Xspec E12,SCMu,v,w")
colora.append("pink")

#Xspec mode 2
dstarta.append(date(2016,8,1))
dstopa.append(date(2019,9,1))
labela.append("Xspec E34,SCMu,v,w")
colora.append("pink")



#FBK13 from E12
dstarta.append(date(2012,9,1))
dstopa.append(date(2013,3,16))
labela.append("FBK13 from E12")
colora.append("green")

#FBK7 from E12 and SCMw
dstarta.append(date(2013,3,17))
dstopa.append(date(2018,4,13))
labela.append("FBK7 from E12 and SCMw")
colora.append("green")

#FBK13 from E34 and SCMw
dstarta.append(date(2018,4,14))
dstopa.append(date(2019,9,1))
labela.append("FBK13 from E34 and SCMw")
colora.append("green")




# Now convert them to matplotlib's internal format...
edate_a, bdate_a = [mdates.date2num(item) for item in (dstopa, dstarta)]


#Plot RBSPa timeline
fig, ax = plt.subplots()

# Plot the data
ax.barh(labela, edate_a - bdate_a, left=bdate_a, height=0.8, align='center', color=colora)
ax.axis('tight')
plt.title('From EFW_dataproduct_timeline.py')
# We need to tell matplotlib that these are dates...
ax.xaxis_date()
plt.show()











