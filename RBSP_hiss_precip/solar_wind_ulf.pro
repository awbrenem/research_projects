date = '2014-01-03'
timespan,date

t0 = time_double('2013-12-20/00:00')
t1 = time_double('2014-02-10/00:00')
t0z = time_double('2014-01-03/10:00')
t1z = time_double('2014-01-03/21:00')

tlimit,t0,t1

path = '~/Desktop/Research/RBSP_hiss_precip/solar_wind_ulf/cdf_files/'

;**************************************************
;Wind data
;**************************************************

fn = 'wi_h2_mfi_20140103_v04.cdf'
cdf2tplot,files=path+fn

tplot,['BF1','BGSE']

;; fn = 'wi_h0_mfi_20140103_v04.cdf'

;; fn ='wi_pm_3dp_20140103_v05.cdf'
;; cdf2tplot,files=path+fn

;; fn = 'wi_plsp_3dp_20140103_v02.cdf'
;; cdf2tplot,files=path+fn


;**************************************************
;ACE data
;**************************************************

fn = 'ac_h0_mfi_20140103_v06.cdf'
cdf2tplot,files=path+fn

tplot,['Magnitude','BGSEc','SC_pos_GSE']

;**************************************************
;OMNI data
;**************************************************

fn = 'omni_hro_1min_20140101_v01.cdf'
cdf2tplot,files=path+fn
tplot,['flow_speed','proton_density','Pressure']

fn = 'omni_hro_1min_20131201_v01.cdf'
cdf2tplot,files=path+fn
copy_data,'Pressure','Pressure1'
copy_data,'proton_density','proton_density1'
fn = 'omni_hro_1min_20140101_v01.cdf'
cdf2tplot,files=path+fn
copy_data,'Pressure','Pressure2'
copy_data,'proton_density','proton_density2'
fn = 'omni_hro_1min_20140201_v01.cdf'
cdf2tplot,files=path+fn
copy_data,'Pressure','Pressure3'
copy_data,'proton_density','proton_density3'

get_data,'Pressure1',data=p1
get_data,'Pressure2',data=p2
get_data,'Pressure3',data=p3
pf = [p1.y,p2.y,p3.y]
tf = [p1.x,p2.x,p3.x]
store_data,'Pressure',data={x:tf,y:pf}


get_data,'proton_density1',data=p1
get_data,'proton_density2',data=p2
get_data,'proton_density3',data=p3
pf = [p1.y,p2.y,p3.y]
tf = [p1.x,p2.x,p3.x]
store_data,'proton_density',data={x:tf,y:pf}

tlimit,t0,t1
ylim,'Pressure',0,10
ylim,'proton_density',0,40
tplot,['Pressure','proton_density']



get_data,'Pressure',data=dd
goo = where(dd.y lt 0.)
if goo[0] ne -1 then dd.y[goo] = !values.f_nan
xv = dd.x
yv = dd.y
interp_gap,xv,yv
store_data,'Pressure',data={x:xv,y:yv}
;options,'Pressure','colors',250


get_data,'proton_density',data=dd
goo = where(dd.y lt 0.)
if goo[0] ne -1 then dd.y[goo] = !values.f_nan
xv = dd.x
yv = dd.y
interp_gap,xv,yv
store_data,'proton_density',data={x:xv,y:yv}
;options,'proton_density','colors',250



rbsp_detrend,['Pressure','proton_density'],60.*30.

tplot,['Pressure','proton_density']+'_detrend'



x = tsample('proton_density',[t0,t1],times=tms)
store_data,'proton_density_tl',data={x:tms,y:x}
x = tsample('Pressure',[t0,t1],times=tms)
store_data,'Pressure_tl',data={x:tms,y:x}



.compile /Users/aaronbreneman/Desktop/code/Aaron/IDL/analysis/plot_wavestuff.pro




epsd = {yrange:[-50,30],xrange:[0.0005,0.01],xlog:1}
;espec = {yrange:[0.001,1000],ylog:1}
plot_wavestuff,'proton_density_tl',/psd,/wf,extra_psd=epsd,/postscript




