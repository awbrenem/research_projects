;Get Lunjin conjunction times and ephemeris for the 2016-01-21 (and 01-22) conjunctions

p = get_project_paths()
p = p.breneman_conjunctions

fnn = 'FU4_RBSPA_conjunctions_hr.sav'

restore,p+fnn



t0st = time_string(t0)
dates = strmid(t0st,0,10)
goo = where(dates eq '2016-01-22')

print,fnn
print,'L = ',meanL[goo]
print,'MLT = ',meanMLT[goo]
print,'mindist = ',mindist[goo]
print,'minMLT = ',minmlt[goo]
print,'t0 = ',time_string(t0[goo])
print,'t1 = ',time_string(t1[goo])


timespan,'2016-01-21'
firebird_load_context_data_cdf_file,'3'



FU3_RBSPA_conjunctions_hr.sav
t0 =  '2016-01-21/22:46:18'
t1 =  '2016-01-21/22:47:17'
Alt = 628 - 623
L =   6.9 - 5.1
MLT =  10.3 - 10.3
lat = 66.6 - 63.2
mindist =       132.519
minMLT =      0.153931

print,tsample('Alt',[time_double(t0),time_double(t1)])
print,tsample('McIlwainL',[time_double(t0),time_double(t1)])
print,tsample('MLT',[time_double(t0),time_double(t1)])
print,tsample('Lat',[time_double(t0),time_double(t1)])


FU3_RBSPB_conjunctions_hr.sav
t0 =  '2016-01-21/22:46:23'
t1 =  '2016-01-21/22:47:17'
Alt = 627 - 623
L =   6.7 - 5.1
MLT = 10.3 - 10.3
lat = 66.3 - 63.5
mindist =       78.5437
minMLT =      0.226311


print,tsample('Alt',[time_double(t0),time_double(t1)])
print,tsample('McIlwainL',[time_double(t0),time_double(t1)])
print,tsample('MLT',[time_double(t0),time_double(t1)])
print,tsample('Lat',[time_double(t0),time_double(t1)])





timespan,'2016-01-21'
firebird_load_context_data_cdf_file,'4'


FU4_RBSPA_conjunctions_hr.sav
t0 =  '2016-01-21/22:42:23'
t1 =  '2016-01-21/22:43:17'
Alt = 628 - 623
L =  6.8 - 5.2
MLT = 10.3 - 10.3
lat = 66.3 - 63.5
mindist =       157.681
minMLT =      0.114074

print,tsample('Alt',[time_double(t0),time_double(t1)])
print,tsample('McIlwainL',[time_double(t0),time_double(t1)])
print,tsample('MLT',[time_double(t0),time_double(t1)])
print,tsample('Lat',[time_double(t0),time_double(t1)])



timespan,'2016-01-22'
firebird_load_context_data_cdf_file,'4'

FU4_RBSPA_conjunctions_hr.sav
t0 =  '2016-01-22/00:16:57'
t1 =  '2016-01-22/00:17:12'
Alt = 631 - 631
L =   6.5 - 6.1
MLT = 10.6 - 10.6
lat = 69.0 - 68.3
mindist =       443.734
minMLT =       1.01451

print,tsample('Alt',[time_double(t0),time_double(t1)])
print,tsample('McIlwainL',[time_double(t0),time_double(t1)])
print,tsample('MLT',[time_double(t0),time_double(t1)])
print,tsample('Lat',[time_double(t0),time_double(t1)])



timespan,'2016-01-21'
firebird_load_context_data_cdf_file,'4'

FU4_RBSPB_conjunctions_hr.sav
t0 =  '2016-01-21/21:08:03'
t1 =  '2016-01-21/21:09:02'
Alt = 623 - 618
L =   6.6 - 5.0
MLT = 10.3 - 10.3
lat = 62.7 - 59.6
mindist =       750.461
minMLT =      0.848254 

print,tsample('Alt',[time_double(t0),time_double(t1)])
print,tsample('McIlwainL',[time_double(t0),time_double(t1)])
print,tsample('MLT',[time_double(t0),time_double(t1)])
print,tsample('Lat',[time_double(t0),time_double(t1)])



FU4_RBSPB_conjunctions_hr.sav
t0 = '2016-01-21/22:42:23'
t1 = '2016-01-21/22:43:17'
Alt = 628 - 624
L =   6.8 - 5.2
MLT = 10.3 - 10.3
lat = 66.3 - 63.5
mindist = 99.3680
minMLT =  0.191896

print,tsample('Alt',[time_double(t0),time_double(t1)])
print,tsample('McIlwainL',[time_double(t0),time_double(t1)])
print,tsample('MLT',[time_double(t0),time_double(t1)])
print,tsample('Lat',[time_double(t0),time_double(t1)])


