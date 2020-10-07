rbsp_efw_init


path = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/solar_wind_data/'
fn = 'omni_hros_1min_20140101000000_20140215000000.cdf'
cdf2tplot,path+fn

get_data,'BX_GSE',t,bx
get_data,'BY_GSE',t,by
get_data,'BZ_GSE',t,bz
bmag = sqrt(bx^2 + by^2 + bz^2)
store_data,'bmag',t,bmag

;Add 0.7 mHz (23.8 min "magic" period lines)
nlines = 40.*86400./(23.8*60.)
tlines = dindgen(nlines)*(23.8*60.) + time_double('2014-01-01')


;----------------------------------------------
;;Manually create pressure variable as n*V^2.
;;YES, THIS IS THE SAME AS THE OMNI "PRESSURE" VARIABLE. 
;;THEREFORE IT'S RAM PRESSURE, NOT THERMAL PRESSURE
;get_data,'proton_density',t,pd 
;get_data,'flow_speed',t,fs 
;p = pd*fs^2 
;store_data,'Pressure_ram',t,p 
;-------------------------------------------


var = 'Pressure'
;var = 'bmag'
;var = 'BZ_GSM'
;var = 'BX_GSE'
;var = 'proton_density'
rbsp_detrend,var,60.*4
rbsp_detrend,var+'_smoothed',60.*60.
tplot,var+'_smoothed_detrend'
timebar,tlines

t0 = time_double('2014-01-12/10:00')
t1 = time_double('2014-01-12/16:00')
yv = tsample(var+'_smoothed_detrend',[t0,t1],times=tms)
store_data,var+'_smoothed_detrend2',tms,yv

get_data,var+'_smoothed_detrend2',t,d
goo = where(finite(d) eq 0.)
if goo[0] ne -1 then d[goo] = 1.
store_data,var+'_smoothed_detrend2',t,d

permin = 1*60. ;msec
permax = 160.*60. ;msec

fmin = 1/permax 
fmax = 1/permin 

epsd = {yrange:[-20,30],xrange:[fmin,fmax],xlog:1}
plot_wavestuff,var+'_smoothed_detrend2',/psd,extra_psd=epsd,vline=0.0007




;----------------------------------------------
;Load BARREL magnetometer data
;----------------------------------------------

path = '~/Downloads/'
fn = 'bar_2L_l2_magn_20140110_v05.cdf'
cdf2tplot,path+fn

path = '~/Downloads/'
fn = 'bar_2K_l2_fspc_20140106_v05.cdf'
cdf2tplot,path+fn
add_data,'FSPC1a','FSPC1b',newname='FSPCtmp'
add_data,'FSPCtmp','FSPC1c',newname='FSPCtmp'
add_data,'FSPCtmp','FSPC2',newname='FSPCtmp'
add_data,'FSPCtmp','FSPC3',newname='FSPCtmp'
add_data,'FSPCtmp','FSPC4',newname='FSPC_2K'
rbsp_detrend,'FSPC_2K',60.
rbsp_detrend,'FSPC_2K_smoothed',60.*60.


fn = 'bar_2W_l2_fspc_20140106_v05.cdf'
cdf2tplot,path+fn
add_data,'FSPC1a','FSPC1b',newname='FSPCtmp'
add_data,'FSPCtmp','FSPC1c',newname='FSPCtmp'
add_data,'FSPCtmp','FSPC2',newname='FSPCtmp'
add_data,'FSPCtmp','FSPC3',newname='FSPCtmp'
add_data,'FSPCtmp','FSPC4',newname='FSPC_2W'
rbsp_detrend,'FSPC_2W',60.
rbsp_detrend,'FSPC_2W_smoothed',60.*60.


tplot,['FSPC_2K_smoothed_detrend','FSPC_2W_smoothed_detrend']
store_data,'comb',data=['FSPC_2K_smoothed_detrend','FSPC_2W_smoothed_detrend']
options,'comb','colors',[0,250]
tplot,['FSPC_2K_smoothed_detrend','FSPC_2W_smoothed_detrend','Pressure','bmag']


rbsp_detrend,['FSPC1a_2K','FSPC1a_2W'],1
tplot,['FSPC1a_2K','FSPC1a_2W']+'_smoothed'


timespan,'2014-01-05'

bar_2W_l2_fspc_20140105_v05.cdf
payload = '2W'
load_barrel_lc,payload,type='fspc'
rbsp_detrend,'FSPC1a_2W',60.*5.

bar_2K_l2_fspc_20140105_v05.cdf
payload = '2K'
load_barrel_lc,payload,type='fspc'
rbsp_detrend,'FSPC1a_2K',60.*5.

tplot,['FSPC1a_2W_smoothed','FSPC1a_2K_smoothed']

