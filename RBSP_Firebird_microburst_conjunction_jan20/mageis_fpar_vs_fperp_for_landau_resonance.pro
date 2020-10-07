;Test to see if the chorus on Jan20, 2016 during FIREBIRD_RBSP_campaign
;is Landau resonant with electrons. Analysis from Agapitov, 2015.
;Results are VERY promising. They strongly suggest that Landau the chorus
;waves are accel e- via Landau resonance near 19:44 UT.




timespan,'2016-01-20'

rbsp_load_efw_spec,probe='a',type='calibrated',/pt



path = '/Users/aaronbreneman/Desktop/Research/RBSP_Firebird_microburst_conjunction_jan20/MagEIS/'
;fn = 'rbspa_rel03_ect-mageis-L2_20160120_v4.3.0.cdf'
fn = 'rbspa_rel03_ect-mageis-L3_20160120_v7.5.1.cdf'
cdf2tplot,path+fn
get_data,'FEDU',data=fedu

;-----------------------------------------------------
;Load HOPE data
;fn = 'rbspa_rel03_ect-hope-MOM-L3_20160120_v6.3.2.cdf'
fn = 'rbspa_rel03_ect-hope-PA-L3_20160120_v6.3.2.cdf'
;fn = 'rbspa_rel03_ect-hope-sci-L2_20160120_v5.2.0.cdf'
;fn = 'rbspa_rel03_ect-hope-sci-L2SA_20160120_v5.2.0.cdf'

path = '/Users/aaronbreneman/Desktop/Research/RBSP_Firebird_microburst_conjunction_jan20/HOPE/'

cdf2tplot,path+fn
get_data,'FEDU',data=fedu_hope
timesh = fedu_hope.x
energiesh = fedu_hope.v2[0,*]/1000.
;Pitch-angles
;4.50000      18.0000      36.0000      54.0000      72.0000      90.0000      108.000      126.000      144.000      162.000
; 175.500

;ENERGIES (eV)
; 14.9846
;       16.8137
;       18.8538
;       21.1754
;       23.7079
;       26.5923
;       29.8284
;       33.4866
;       37.5669
;       42.1396
;       47.2752
;       52.9735
;       59.4457
;       66.6918
;       74.7821
;       83.8572
;       94.0579
;       105.525
;       118.329
;       132.680
;       148.861
;       166.941
;       187.201
;       209.995
;       235.532
;       264.164
;       296.244
;       332.263
;       372.714
;       418.020
;       468.812
;       525.796
;       589.744
;       661.431
;       741.841
;       832.100
;       933.263
;       1046.67
;       1173.93
;       1316.67
;       1476.79
;       1656.32
;       1857.66
;       2083.56
;       2336.89
;       2620.96
;       2939.65
;       3297.02
;       3697.88
;       4147.48
;       4651.75
;       5217.30
;       5851.64
;       6563.09
;       7361.07
;       8256.00
;       9259.82
;       10385.6
;       11648.3
;       13064.5
;       14652.9
;       16434.4
;       18432.5
;       20673.5
;       23187.0
;       26006.1
;       29168.0
;       32714.2
;       36691.7
;       41152.6
;       46156.0
;       51767.7
;-----------------------------------------------------




;pitch angles
print,fedu.v1

;8.1818182       24.545455       40.909091       57.272727       73.636364       90.000000       106.36364       122.72727       139.09091       155.45455
; 171.81818

;energy bins (time-varying)

print,fedu.v2[0,*]
times = fedu.x
energies = fedu.v2[0,*]
; 31.500000
;  53.799999
;  79.800003
;  108.30000
;  143.50000
;  183.39999
;  226.10001
;  231.80000
;  342.10001
;  464.39999
;  593.00000
;  741.59998
;  901.79999
;  999.00000
;  1077.7000
;  1547.0000
;  1701.0000
;  2275.0000
;  2651.0000
;  3681.0000
;  4216.0000


p8 = fedu.y[*,*,0]
p24 = fedu.y[*,*,1]
p90 = fedu.y[*,*,5]

p4h = fedu_hope.y[*,*,0]
p18h = fedu_hope.y[*,*,1]
p90h = fedu_hope.y[*,*,5]


;For each energy
p8_e31 = p8[*,0]
p24_e31 = p24[*,0]
p90_e31 = p90[*,0]

p8_e53 = p8[*,1]
p24_e53 = p24[*,1]
p90_e53 = p90[*,1]

p8_e226 = p8[*,6]
p24_e226 = p24[*,6]
p90_e226 = p90[*,6]


store_data,'p8_e31',times,p8_e31
store_data,'p24_e31',times,p24_e31
store_data,'p90_e31',times,p90_e31

store_data,'p8_e53',times,p8_e53
store_data,'p24_e53',times,p24_e53
store_data,'p90_e53',times,p90_e53

store_data,'p8_e226',times,p8_e226
store_data,'p24_e226',times,p24_e226
store_data,'p90_e226',times,p90_e226

rat_p8p90_e31 = p8_e31/p90_e31
rat_p24p90_e31 = p24_e31/p90_e31
rat_p8p90_e53 = p8_e53/p90_e53
rat_p24p90_e53 = p24_e53/p90_e53
rat_p8p90_e226 = p8_e226/p90_e226
rat_p24p90_e226 = p24_e226/p90_e226

store_data,'rat_p8p90_e31',times,rat_p8p90_e31
store_data,'rat_p24p90_e31',times,rat_p24p90_e31
store_data,'rat_p8p90_e53',times,rat_p8p90_e53
store_data,'rat_p24p90_e53',times,rat_p24p90_e53
store_data,'rat_p8p90_e226',times,rat_p8p90_e226
store_data,'rat_p24p90_e226',times,rat_p24p90_e226



tplot,['rat_p8p90_e31','rat_p24p90_e31']
tplot,['rat_p8p90_e53','rat_p24p90_e53']
tplot,['rat_p8p90_e226','rat_p24p90_e226']

tlimit,'2016-01-20/17:00','2016-01-20/20:20'


;---------------------------------------------------
;For a select timerange, plot F||/Fperp vs E [keV]
;---------------------------------------------------


;chorus times
t0 = time_double('2016-01-20/19:15:00')
t1 = time_double('2016-01-20/19:35:00')

;during actual FB conjunction
t0 = time_double('2016-01-20/19:42:00')
t1 = time_double('2016-01-20/19:47:00')

;during actual times of EFW B2
t0 = time_double('2016-01-20/19:41:00')
t1 = time_double('2016-01-20/19:41:20')


;previous apogee (some chorus (near flh) until 11:08)
t0 = time_double('2016-01-20/11:00')
t1 = time_double('2016-01-20/11:10')

;previous apogee (no chorus after 11:08)
t0 = time_double('2016-01-20/11:08')
t1 = time_double('2016-01-20/11:12')

;power at f<flh
t0 = time_double('2016-01-20/13:20')
t1 = time_double('2016-01-20/13:30')


;first apogee (no VLF)
t0 = time_double('2016-01-20/03:00')
t1 = time_double('2016-01-20/03:10')

tlimit,t0,t1

;pclose



;MagEIS
goodt = where((times ge t0) and (times le t1))
p8T = p8[goodt,*]
p24T = p24[goodt,*]
p90T = p90[goodt,*]

rat_p8p90T = p8T/p90T
rat_p24p90T = p24T/p90T

rat_p24p90T_med = fltarr(n_elements(energies))
rat_p24p90T_mean = fltarr(n_elements(energies))
for i=0,n_elements(energies)-1 do rat_p24p90T_med[i] = median(rat_p24p90T[*,i],/double)
for i=0,n_elements(energies)-1 do begin $
  tmp = moment(rat_p24p90T[*,i]) & $
  rat_p24p90T_mean[i] = tmp[0]


;HOPE
goodth = where((timesh ge t0) and (timesh le t1))
p4Th = p4h[goodth,*]
p18Th = p18h[goodth,*]
p90Th = p90h[goodth,*]

rat_p4p90Th = p4Th/p90Th
rat_p18p90Th = p18Th/p90Th

;rat_p4p90Th_med = fltarr(n_elements(energiesh))
;rat_p4p90Th_mean = fltarr(n_elements(energiesh))
rat_p18p90Th_med = fltarr(n_elements(energiesh))
rat_p18p90Th_mean = fltarr(n_elements(energiesh))
for i=0,n_elements(energiesh)-1 do rat_p18p90Th_med[i] = median(rat_p18p90Th[*,i],/double)
for i=0,n_elements(energiesh)-1 do begin $
  tmp = moment(rat_p18p90Th[*,i]) & $
  rat_p18p90Th_mean[i] = tmp[0]





  popen,'~/Desktop/jan20_2016_RBA_1941-194120.ps'
  ylim,['rbspa_efw_64_spec0','rbspa_efw_64_spec4'],10,5000,1
  tplot,['rbspa_efw_64_spec0','rbspa_efw_64_spec4']

!p.multi = [0,0,2]
;HOPE
plot,energiesh,rat_p18p90Th[0,*],xrange=[0.01,60],xstyle=1,/xlog,xtitle='E [keV]',ytitle='HOPE!C(L3 FEDU)!C(fpar/fperp)',yrange=[0,1],/nodata
for i=0,53 do oplot,energiesh,rat_p18p90Th[i,*],color=250
oplot,energiesh,rat_p18p90Th_med,color=0,thick=3
oplot,energiesh,rat_p18p90Th_mean,color=50,thick=3

plot,energies,rat_p24p90T[0,*],xrange=[20,1000],xstyle=1,xtitle='E [keV]',ytitle='MagEIS!C(L3 FEDU)!C(fpar/fperp)',yrange=[0,0.8],/nodata
for i=0,53 do oplot,energies,rat_p24p90T[i,*],color=250
oplot,energies,rat_p24p90T_med,color=0,thick=3
oplot,energies,rat_p24p90T_mean,color=50,thick=3

pclose


;Combine data sets
;energiesF = [reform(energiesh),reform(energies)]
;ratf = [reform(rat_p4p90Th[10,*]),reform(rat_p24p90T[10,*])]
;plot,energiesF,ratf,xrange=[1,5000],/xlog,xtitle='E [keV]',ytitle='HOPE!C(L3 FEDU)!C(fpar/fperp)',yrange=[0,1]

;for i=0,53 do oplot,energiesh,rat_p18p90Th[i,*],color=250
;oplot,energiesh,rat_p4p90Th_med,color=0,thick=3
