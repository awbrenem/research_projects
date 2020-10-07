;Determine chorus properties from burst data
rbsp_efw_init

path = '/Users/aaronbreneman/Desktop/Research/RBSP_Firebird_microburst_conjunction_jan20/EMFISIS/'

fn2 = 'rbsp-a_magnetometer_4sec-gse_emfisis-L3_20160120_v1.3.2.cdf'
cdf2tplot,path+fn2

fn = 'rbsp-a_20160120T19_WNA-wav-cont-bst-sm_fft1024-fa2-fo75-to75_CDF_v4_10e6filter.cdf'
cdf2tplot,path+fn


minamp = 1d-3

copy_data,'bsum','bsum_orig'
get_data,'bsum_orig',data=d,dlim=dlim,lim=lim
store_data,'bsum_orig',data={x:d.x,y:d.y,v:reform(d.v)},dlim=dlim,lim=lim


get_data,'bsum',data=d,dlim=dlim,lim=lim
bad = where(d.y lt minamp)
if bad[0] ne -1 then d.y[bad] = !values.f_nan
store_data,'bsum',data={x:d.x,y:d.y,v:reform(d.v)},dlim=dlim,lim=lim

;Create single phi variable that ranges from 0-360
get_data,'phsvd',data=d,dlim=dlim,lim=lim
if bad[0] ne -1 then d.y[bad] = !values.f_nan
goo = where(d.y lt 0.)
d360 = d.y
;change to 0-360 deg
d360[goo] = d360[goo] + 360.
store_data,'phsvd',data={x:d.x,y:d360,v:reform(d.v)},dlim=dlim,lim=lim
options,'phsvd','ytitle','Phi!C0=antiearthward!C180=earthward'

;Create two separate phi variables, earthward, and anti-earthward.
;Each goes from -180 to 180.
;This has the advantage of being able to scale the colorbar nicely

;anti-earthward
d2 = d360
d2[*] = !values.f_nan
goo = where((d360 ge 0.) and (d360 lt 90.))
d2[goo] = d360[goo]
goo = where((d360 ge 270.) and (d360 le 360.))
d2[goo] = d360[goo] - 360.
store_data,'phsvd_antiearthward',data={x:d.x,y:d2,v:reform(d.v)},dlim=dlim,lim=lim
options,'phsvd_antiearthward','ytitle','Phi!C0=antiearthward!C+90=north'


d2 = d360
d2[*] = !values.f_nan
goo = where((d360 gt 90.) and (d360 le 270.))
d2[goo] = d360[goo]
d2 = -1*d2 + 180.
store_data,'phsvd_earthward',data={x:d.x,y:d2,v:reform(d.v)},dlim=dlim,lim=lim
options,'phsvd_earthward','ytitle','Phi!C0=earthward!C+90=north'





get_data,'esum',data=d,dlim=dlim,lim=lim
if bad[0] ne -1 then d.y[bad] = !values.f_nan
store_data,'esum',data={x:d.x,y:d.y,v:reform(d.v)},dlim=dlim,lim=lim

get_data,'thsvd',data=d,dlim=dlim,lim=lim
if bad[0] ne -1 then d.y[bad] = !values.f_nan
store_data,'thsvd',data={x:d.x,y:d.y,v:reform(d.v)},dlim=dlim,lim=lim

get_data,'phpoy1_2_3',data=d,dlim=dlim,lim=lim
if bad[0] ne -1 then d.y[bad] = !values.f_nan
store_data,'phpoy1_2_3',data={x:d.x,y:d.y,v:reform(d.v)},dlim=dlim,lim=lim

get_data,'thpoy1_2_3',data=d,dlim=dlim,lim=lim
if bad[0] ne -1 then d.y[bad] = !values.f_nan
store_data,'thpoy1_2_3',data={x:d.x,y:d.y,v:reform(d.v)},dlim=dlim,lim=lim



ylim,'*',400,1800,0
ylim,'Magnitude',140,160
zlim,'bsum',minamp,1d-2,1
zlim,'esum',1d-2,1d0,1
zlim,'thsvd',0,50,0

;phi angles are definitely slightly negative
zlim,'phsvd_earthward',-90,90,0
zlim,'phsvd_antiearthward',-90,90,0
zlim,'phsvd',0,360.,0

tplot,['bsum','esum','thsvd','phsvd_earthward','phsvd_antiearthward']




tlimit,'2016-01-20/19:41:06','2016-01-20/19:41:14'



;Find amplitude and compare to FILTERBANK data
binsize = 34.17   ;delta-f

t0z = time_double('2016-01-20/19:41:09.100')

tlimit,t0z-0.2,t0z+0.2
tplot,['bsum','thsvd']

;1470 - 850
;.160

;780  1538
;230


bval = tsample('bsum',t0z,times=tt)
eval = tsample('esum',t0z,times=tt)

print,time_string(tt,prec=3)
;2016-01-20/19:41:09.101

;calculate max amplitude
bmax2 = max(bval,/nan)
bmax = 1000.*sqrt(bmax) ;pT/sqrt(Hz)
emax2 = max(eval,/nan)
emax = sqrt(emax2)       ;mV/m/sqrt(Hz)


bmax = bmax*sqrt(binsize)
;RBSP_EFW> print,bmax
;      447.179
emax = emax*sqrt(binsize)
;RBSP_EFW> print,emax
;      3.97399


tplot,['bsum','thsvd']


timespan,'2016-01-20'
rbsp_load_efw_fbk,type='calibrated'
rbsp_split_fbk,'a'
rbsp_split_fbk,'b'


tlimit,'2016-01-20/19:00','2016-01-20/20:10'
;Bfield
tplot,['rbspa_fbk2_7pk_5','rbspb_fbk2_7pk_5']
;tplot,['rbspa_fbk2_7pk_4','rbspa_fbk2_7pk_5']

;Efield
tplot,['rbspa_fbk1_7pk_5','rbspb_fbk1_7pk_5']


;E and B
tplot,['rbspa_fbk1_7pk_5','rbspa_fbk2_7pk_5']

;tplot,'bsum'
;get_data,'bsum',t,b,v
