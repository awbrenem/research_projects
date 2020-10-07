;19:46

rbsp_efw_init
timespan,'2018-04-23'
;timespan,'2017-12-04'
;fn = 'rbspa_l1_vb1_20171121_v02_2000-2010.cdf'
path = '/Users/aaronbreneman/Desktop/Research/RBSP_Firebird_microburst_conjunctions_all/data/rbspa_20180423/'

;***************
;Combine multiple files (magnetic field)
fn = 'rbspa_l1_mscb1_20180423_v02_2003_2014.cdf'
cdf2tplot,path+fn
copy_data,'mscb1','mscb1_1'

fn = 'rbspa_l1_mscb1_20180423_v02_2013_2024.cdf'
cdf2tplot,path+fn
copy_data,'mscb1','mscb1_2'

fn = 'rbspa_l1_mscb1_20180423_v02_2024_2035.cdf'
cdf2tplot,path+fn
copy_data,'mscb1','mscb1_3'


fn = 'rbspa_l1_mscb1_20180423_v02_20_45_02.cdf'
cdf2tplot,path+fn
copy_data,'mscb1','mscb1_4'



get_data,'mscb1_1',t1,d1
get_data,'mscb1_2',t2,d2
get_data,'mscb1_3',t3,d3
get_data,'mscb1_4',t4,d4
d1x = [d1[*,0],d2[*,0],d3[*,0],d4[*,0]]
d2x = [d1[*,1],d2[*,1],d3[*,1],d4[*,1]]
d3x = [d1[*,2],d2[*,2],d3[*,2],d4[*,2]]

d = [[d1x],[d2x],[d3x]]

store_data,'mscb1',[t1,t2],d


get_data,'mscb1',t,bw
srt = 1/(t[1]-t[0])
plot_wavestuff,'mscb1',/spec,/nodelete
copy_data,'x_SPEC','mscb1_spec'
ylim,'mscb1_spec',100,3000,1
tplot,'mscb1_spec'


x = rbsp_vector_bandpass(bw,srt,100.,8000.)

store_data,'mscb1bp',t,x[*,0]
tplot,['mscb1bp']


plot_wavestuff,'mscb1bp',/spec,/nodelete
copy_data,'x_SPEC','mscb1bp_spec'















;***************
;Combine multiple files (electric field from probe potentials)

fn = 'rbspa_l1_vb1_20171121_v02_1940-1950.cdf'
cdf2tplot,path+fn
copy_data,'vb1','vb1_1'

fn = 'rbspa_l1_vb1_20171121_v02_1950-2000.cdf'
cdf2tplot,path+fn
copy_data,'vb1','vb1_2'

get_data,'vb1_1',t1,d1
get_data,'vb1_2',t2,d2
d1x = [d1[*,0],d2[*,0]]
d2x = [d1[*,1],d2[*,1]]
d3x = [d1[*,2],d2[*,2]]
d4x = [d1[*,3],d2[*,3]]
d5x = [d1[*,4],d2[*,4]]
d6x = [d1[*,5],d2[*,5]]
d = [[d1x],[d2x],[d3x],[d4x],[d5x],[d6x]]

store_data,'vb1',[t1,t2],d
;***************



rbsp_load_ect_l3,'a','hope',/get_support_data

firebird_load_data,'4'


rbsp_load_emfisis,probe='a',level='l3',coord='gse'
get_data,'rbspa_emfisis_l3_4sec_gse_Magnitude',t,d

fce = 28.*d
fce_2 = fce/2.
fce_01 = fce*0.1

store_data,'fces',t,[[fce],[fce_2],[fce_01]]
options,'fces','thick',4


split_vec,'vb1',suffix='_v'+['1','2','3','4','5','6']

get_data,'vb1_v1',t,v1
get_data,'vb1_v2',t,v2
get_data,'vb1_v3',t,v3
get_data,'vb1_v4',t,v4

store_data,'dens_proxy',t,(v2+v4)/2.
rbsp_detrend,'dens_proxy',0.1
rbsp_detrend,'dens_proxy_detrend',12.

;tplot,['vb1_v?']

store_data,'e12',t,(v1-v2)/100.
store_data,'e34',t,(v3-v4)/100.
;tplot,'e34'

get_data,'e12',t,e12
get_data,'e34',t,e34
e56 = e34
e56[*] = 0.
ew = [[e12],[e34],[e56]]

srt = 1/(t[1]-t[0])


x = rbsp_vector_bandpass(ew,srt,100.,8000.)

store_data,'e12bp',t,x[*,0]
store_data,'e34bp',t,x[*,1]

tplot,['e34bp']


plot_wavestuff,'e34bp',/spec,/nodelete
copy_data,'x_SPEC','e34bp_spec'

get_data,'e34bp_spec',data=tdat
goo = where(tdat.v ge 600.)
store_data,'power_600Hz',tdat.x,tdat.y[*,goo[0]]
goo = where(tdat.v ge 1000.)
store_data,'power_1000Hz',tdat.x,tdat.y[*,goo[0]]

split_vec,'fb_col_flux'

store_data,'e34spec_comb',data=['e34bp_spec','fces']
zlim,'e34bp_spec',1d-8,1d-4,1
ylim,'e34spec_comb',300,6000,1

ylim,'dens_proxy_detrend_smoothed',-1,1
ylim,'power_600Hz',0,0.0002
ylim,'power_1000Hz',0,0.0002
ylim,'rbspa_ect_hope_L3_Ion_density',0.22,0.3
ylim,'rbspa_ect_hope_L3_Dens_e_200',0.06,.1
ylim,'fb_col_flux_0',0.1,100,1
options,'e34spec_comb','ytitle','E34 EFW!CmV/m'
tplot_options,'title','from plot_burst_for'
tplot,['e34spec_comb','rbspa_emfisis_l3_4sec_gse_Magnitude','dens_proxy_smoothed','fb_col_flux_0','rbspa_ect_hope_L3_Ion_density','power_600Hz','power_1000Hz']
