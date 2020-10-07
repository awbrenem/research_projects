tplot_options,'title','from jan3_zoomed_event.pro'

date = '2014-01-03'
probe = 'a'
rbspx = 'rbspa'
timespan,date

rbsp_efw_init

trange = timerange()

fcals = rbsp_efw_get_gain_results()
fbinsL = fcals.cal_spec.freq_spec64L
fbinsH = fcals.cal_spec.freq_spec64H
bandw = fbinsH - fbinsL


rbsp_efw_position_velocity_crib,/noplot,/notrace
rbsp_load_emfisis,probe=probe,/quicklook



;Get BARREL SSPC  (20 keV min - best freq resolution)
path = '~/Desktop/Research/RBSP_hiss_precip/barrel_cdfs/'
fn2 = 'bar_2I_l2_sspc_20140103_v00.cdf'
cdf2tplot,files=path+fn2

get_data,'SSPC',data=sspc
maxsspc = fltarr(n_elements(sspc.x))

for qq=0,n_elements(sspc.x)-1 do begin     $
	tmp = max(sspc.y[qq,*],/nan,wh)   & $
	maxsspc[qq] = sspc.v[wh]
	
	
store_data,'maxsspc',data={x:sspc.x,y:maxsspc}
options,'maxsspc','ytitle','2I SSPC max val!CkeV'

;-----------------------------------------------------------
;Get BARREL coord
path = '~/Desktop/Research/RBSP_hiss_precip/barrel_mapping/BARREL_RBSP_Kp3/'


restore, path+"barrel_template.sav"
myfile = path+"bar_2I_140103_mag.dat"
data = read_ascii(myfile, template = res)

;data.mlt = data.mlt*360.0/24.0
;x = abs(data.l)*cos(data.mlt*!pi/180.0)
;y = abs(data.l)*sin(data.mlt*!pi/180.0)

tms = time_double('2014-01-03/00:00') + data.utsec
store_data,'mlt_2I',data={x:tms,y:data.mlt}
store_data,'l_2I',data={x:tms,y:abs(data.l)}
store_data,'mlat_2I',data={x:tms,y:data.lat}
store_data,'alt_2I',data={x:tms,y:data.alt}



;utstart = fix(hour)*3600.00+fix(minute)*60.0
;utend = utstart+60.0
;st = where(data.utsec gt utstart and data.utsec lt utend, count)
;if count gt 0 then begin
;avex = MEAN(x(st))
;avey = MEAN(y(st))
;L = abs(MEAN(data.l(st)))

restore, path+"barrel_template.sav"
myfilew = path+"bar_2W_140103_mag.dat"
dataw = read_ascii(myfilew, template = res)

;data.mlt = data.mlt*360.0/24.0
;x = abs(data.l)*cos(data.mlt*!pi/180.0)
;y = abs(data.l)*sin(data.mlt*!pi/180.0)

store_data,'mlt_2W',data={x:tms,y:dataw.mlt}
store_data,'l_2W',data={x:tms,y:abs(dataw.l)}


;-------------------------------------------------

;Find difference b/t BARREL and RBSP locations

dif_data,'rbspa_state_mlt','mlt_2I'
dif_data,'rbspa_state_lshell','l_2I'

get_data,'rbspa_state_mlt-mlt_2I',data=dd
store_data,'rbspa_state_mlt-mlt_2I',data={x:dd.x,y:abs(dd.y)}
get_data,'rbspa_state_lshell-l_2I',data=dd
store_data,'rbspa_state_lshell-l_2I',data={x:dd.x,y:abs(dd.y)}

;------------------------------------------------
;Find absolute separation b/t VAPa and 2I

tinterpol_mxn,'mlt_2I','rbspa_state_mlt'
get_data,'mlt_2I_interp',data=t
mlt2I = t.y * 360./24.
get_data,'rbspa_state_mlt',data=t
mlta = t.y

tinterpol_mxn,'l_2I','rbspa_state_lshell'
get_data,'l_2I_interp',data=t
l2I = t.y
get_data,'rbspa_state_lshell',data=t
la = t.y

tinterpol_mxn,'alt_2I','rbspa_state_lshell'
get_data,'alt_2I_interp',data=t
alt2I = t.y
r2I = (6370. + alt2I)/6370.

;Can get 2I mlat from Lshell and altitude
;Lshell = rad/(cos(!dtor*mlat)^2)  ;L-shell in centered dipole
mlat2I = acos(sqrt(r2I/l2I))/!dtor
mlat2I = -1*mlat2I  ;southern hemisphere
store_data,'mlat_2I',data={x:t.x,y:mlat2I}

get_data,'rbspa_state_mlat',data=t
mlata = t.y
colata = 90. - mlata
store_data,'rbspa_state_colat',data={x:t.x,y:colata}

get_data,'mlat_2I',data=t
mlat2i = t.y
colat2i = 90. - mlat2i
store_data,'colat_2I',data={x:t.x,y:colat2I}


;Calculate SM coord (using MLT as longitude...shouldn't matter b/c I only want to know
;the absolute separation b/t VAPa and 2I)
longa = mlta*360./24.
long2i = mlt2i
store_data,'longa',data={x:t.x,y:longa}
store_data,'long2I',data={x:t.x,y:long2i}
get_data,'rbspa_state_radius',data=rada
rada = rada.y
rad2i = r2i
colata = colata
colat2i = colat2i

x_sma = rada*sin(colata*!dtor)*cos(longa*!dtor)
y_sma = rada*sin(colata*!dtor)*sin(longa*!dtor)
z_sma = rada*cos(colata*!dtor)

x_sm2i = rad2i*sin(colat2i*!dtor)*cos(long2i*!dtor)
y_sm2i = rad2i*sin(colat2i*!dtor)*sin(long2i*!dtor)
z_sm2i = rad2i*cos(colat2i*!dtor)

smdiff = sqrt((abs(x_sma-x_sm2i))^2 + (abs(y_sma-y_sm2i))^2 + (abs(z_sma-z_sm2i))^2)
store_data,'separation',data={x:t.x,y:smdiff*6370.}

store_data,'xsma',data={x:t.x,y:x_sma}
store_data,'ysma',data={x:t.x,y:y_sma}
store_data,'zsma',data={x:t.x,y:z_sma}
store_data,'xsm2I',data={x:t.x,y:x_sm2i}
store_data,'ysm2I',data={x:t.x,y:y_sm2i}
store_data,'zsm2I',data={x:t.x,y:z_sm2i}
store_data,'xdiff',data={x:t.x,y:(x_sma-x_sm2i)}
store_data,'ydiff',data={x:t.x,y:(y_sma-y_sm2i)}
store_data,'zdiff',data={x:t.x,y:(z_sma-z_sm2i)}

tplot,'separation'
tplot,['longa','long2I']
tplot,['rbspa_state_mlat','mlat_2I']
tplot,['rbspa_state_colat','colat_2I']
tplot,['xsma','xsm2I']
tplot,['ysma','ysm2I']
tplot,['zsma','zsm2I']
tplot,['xdiff','ydiff','zdiff']



;--------------------------------------------------
payloads = ['2I','2W']
spinperiod = 11.8
rbsp_load_barrel_lc,payloads,date,type='rcnt'
;rbsp_load_barrel_lc,payloads,date,type='ephm'
rbsp_load_barrel_lc,payloads,date


;Get rid of NaN values in the peak detector data. This messes up the downsampling
get_data,'PeakDet_2I',data=dd
goo = where(dd.y lt 0.)
if goo[0] ne -1 then dd.y[goo] = !values.f_nan
xv = dd.x
yv = dd.y
interp_gap,xv,yv
store_data,'PeakDet_2I',data={x:xv,y:yv}
options,'PeakDet_2I','colors',250


;--------------------------------------------------------
;MAGEIS file
pn = '~/Desktop/Research/RBSP_hiss_precip/mageis_cdfs/'
fnt = 'rbspa_rel02_ect-mageis-L2_20140103_v3.0.0.cdf'
cdf2tplot,file=pn+fnt
get_data,'FESA',data=dd
store_data,'FESA',data={x:dd.x,y:dd.y,v:reform(dd.v[0,*])}
get_data,'FESA',data=dd
store_data,'fesa_2mev',data={x:dd.x,y:dd.y[*,21]}
ylim,'fesa_2mev',0.02,100,1
ylim,'FESA',30,4000,1
tplot,'FESA'
zlim,'FESA',0,1d5


;--------------------------------------------------------
;EMFISIS file with hiss spec
pn = '~/Desktop/Research/RBSP_hiss_precip/emfisis_cdfs/'
fnt = 'rbsp-a_WFR-spectral-matrix_emfisis-L2_20140103_v1.3.2.cdf'
cdf2tplot,file=pn+fnt
get_data,'BwBw',data=dd
store_data,'BwBw',data={x:dd.x,y:1000.*1000.*dd.y,v:reform(dd.v)}
options,'BwBw','spec',1
zlim,'BwBw',1d-6,100,1
ylim,'BwBw',20,1000,1

rbspx = 'rbsp' + probe
;t0 = time_double('2014-01-06/20:00')
;t1 = time_double('2014-01-06/22:00')
t0 = time_double('2014-01-03/19:30')
t1 = time_double('2014-01-03/22:30')
timespan, date


rbsp_efw_init	
!rbsp_efw.user_agent = ''
tplot_options,'xmargin',[20.,15.]
tplot_options,'ymargin',[3,6]
tplot_options,'xticklen',0.08
tplot_options,'yticklen',0.02
tplot_options,'xthick',2
tplot_options,'ythick',2
tplot_options,'labflag',-1	
	

rbsp_load_efw_spec,probe=probe,type='calibrated',/pt

rbsp_load_efw_waveform,probe=probe,type='calibrated',datatype='vsvy'
split_vec,rbspx + '_efw_vsvy', suffix='_V'+['1','2','3','4','5','6']
get_data,rbspx + '_efw_vsvy_V1',data=v1
get_data,rbspx + '_efw_vsvy_V2',data=v2
sum12 = (v1.y + v2.y)/2.
density = 7354.3897*exp(sum12*2.8454878)+96.123628*exp(sum12*0.43020781)
store_data,'density'+probe,data={x:v1.x,y:density}
ylim,'density?',1,10000,1
options,'density'+probe,'ytitle','density'+strupcase(probe)+'!Ccm^-3'


;Calculate flhr
get_data,'rbsp'+probe+'_efw_64_spec4',data=spec



tinterpol_mxn,'rbsp'+probe+'_emfisis_quicklook_Magnitude',spec.x,newname='Bmag'
tinterpol_mxn,'densitya',spec.x,newname='dens'
get_data,'Bmag',data=bmag
fce = 28. * bmag.y
fci = fce/1836.


flhr = sqrt(fce*fci)
store_data,'flhr',data={x:spec.x,y:flhr}

get_data,'dens',data=dens
fpe = 8980.*sqrt(dens.y)
fpi = fpe/(sqrt(1)*43.)                                ;Ion plasma freq (Hz)
flhr = sqrt(fpi*fpi*fce*fci)/sqrt(fce*fci+(fpi^2))   ;Lower Hybrid Res freq (Hz)
store_data,'flhr2',data={x:spec.x,y:flhr}



ylim,['rbsp'+probe+'_efw_64_spec4','flhr'],30,1000,1
store_data,'spec_flhr',data=['rbsp'+probe+'_efw_64_spec4','flhr']
;options,'spec_flhr','spec',1
ylim,'spec_flhr',30,300,1






ylim,'FESA',30,300,1

store_data,'mlt_both',data=['rbspa_state_mlt','mlt_2I']
store_data,'l_both',data=['rbspa_state_lshell','l_2I']
options,'mlt_both','colors',[0,250]
options,'l_both','colors',[0,250]

tplot,['densitya','fesa_2mev','FESA','rbspa_state_lshell','rbspa_state_mlt','mlt_both','l_both','PeakDet_2I']
timebar,[t0,t1]



;---------------------------------------------------------
;Integrate spec RMS amplitude
trange = timerange()
fcals = rbsp_efw_get_gain_results()
fbinsL = fcals.cal_spec.freq_spec64L
fbinsH = fcals.cal_spec.freq_spec64H
bandw = fbinsH - fbinsL


get_data,'rbsp'+probe+'_efw_64_spec2',data=bu2
get_data,'rbsp'+probe+'_efw_64_spec3',data=bv2
get_data,'rbsp'+probe+'_efw_64_spec4',data=bw2
bu2.y[*,0:2] = 0.
bv2.y[*,0:2] = 0.
bw2.y[*,0:2] = 0.
bu2.y[*,45:63] = 0.
bv2.y[*,45:63] = 0.
bw2.y[*,45:63] = 0.
nelem = n_elements(bu2.x)
bt = fltarr(nelem)
;Add up amplitude in all 64 bins and multiply each bin by a bandwidth
ball = bu2.y + bv2.y + bw2.y
for j=0L,nelem-1 do bt[j] = sqrt(total(ball[j,*]*bandw))  ;RMS method (Malaspina's method)
store_data,'Bfield_hissint',data={x:bu2.x,y:bt}
tplot,'Bfield_hissint'



rbsp_detrend,'densitya',60.*10.
copy_data,'densitya_smoothed','densitya_smoothed1'      
rbsp_detrend,'densitya',60.*0.1667
tplot,['densitya_smoothed1','densitya_detrend'] 
   

get_data,'densitya_smoothed1',data=ds
get_data,'densitya_smoothed',data=d
dn_n = 100.*(d.y - ds.y)/ds.y

store_data,'dn_n',data={x:ds.x,y:dn_n}
tplot,['densitya_smoothed1','densitya_smoothed','dn_n']
rbsp_detrend,['Bfield_hissint','PeakDet_2I','LC1_2I','dn_n'],60.*20
rbsp_detrend,['Bfield_hissint','PeakDet_2I','LC1_2I','dn_n']+'_detrend',60.*0.7


options,'BwBw','ytitle','BwBw'
options,'BwBw','ysubtitle','[pT^2/Hz]'

store_data,'lboth',data=['rbspa_state_lshell','l_2I']
store_data,'mltboth',data=['rbspa_state_mlt','mlt_2I']


tlimit,'2014-01-03/19:30','2014-01-03/22:30'   

zlim,'BwBw',1d-2,20,1
ylim,'BwBw',20,600,1
ylim,'PeakDet_2I',3000,20000
ylim,'PeakDet_2I_detrend_smoothed',-3000,3000
ylim,'Bfield_hissint_detrend_smoothed',-20,30
ylim,'dn_n_detrend_smoothed',-40,40
options,['rbspa_state_mlt-mlt_2I','rbspa_state_lshell-l_2I'],'panel_size',0.7

tplot,['BwBw','Bfield_hissint_detrend_smoothed','PeakDet_2I_detrend_smoothed','dn_n_detrend_smoothed','mltboth','lboth','rbspa_state_mlt-mlt_2I','rbspa_state_lshell-l_2I']


;tplot nonaltered data for scale
tplot,['Bfield_hissint','PeakDet_2I','dn_n']


;******************************************************************
;------------------------------------------------------------------
;******************************************************************
;------------------------------------------------------------------
;******************************************************************
;------------------------------------------------------------------
;******************************************************************
;------------------------------------------------------------------
;Look for wave fluctuations in Bfield and Efield survey products
;------------------------------------------------------------------
;******************************************************************


tplot_options,'title','from jan3_zoomed_event.pro'

date = '2014-01-03'
probe = 'a'
rbspx = 'rbspa'
timespan,date

rbsp_efw_init

trange = timerange()

fcals = rbsp_efw_get_gain_results()
fbinsL = fcals.cal_spec.freq_spec64L
fbinsH = fcals.cal_spec.freq_spec64H
bandw = fbinsH - fbinsL




t0 = time_double('2014-01-03/19:30')
t1 = time_double('2014-01-03/22:30')

rbsp_load_efw_spec,probe=probe,type='calibrated',/pt
rbsp_efw_position_velocity_crib,/noplot,/notrace
rbsp_efw_vxb_subtract_crib,probe,/hires,/no_spice_load
;-----------------------------------------------
rbsp_load_efw_waveform,probe=probe,type='calibrated',datatype='vsvy'
split_vec,rbspx + '_efw_vsvy', suffix='_V'+['1','2','3','4','5','6']
get_data,rbspx + '_efw_vsvy_V1',data=v1
get_data,rbspx + '_efw_vsvy_V2',data=v2
sum12 = (v1.y + v2.y)/2.
density = 7354.3897*exp(sum12*2.8454878)+96.123628*exp(sum12*0.43020781)
store_data,'density'+probe,data={x:v1.x,y:density}
ylim,'density?',1,10000,1
options,'density'+probe,'ytitle','density'+strupcase(probe)+'!Ccm^-3'
;-----------------------------------------------
get_data,'rbsp'+probe+'_efw_64_spec2',data=bu2
get_data,'rbsp'+probe+'_efw_64_spec3',data=bv2
get_data,'rbsp'+probe+'_efw_64_spec4',data=bw2
bu2.y[*,0:2] = 0.
bv2.y[*,0:2] = 0.
bw2.y[*,0:2] = 0.
bu2.y[*,45:63] = 0.
bv2.y[*,45:63] = 0.
bw2.y[*,45:63] = 0.
nelem = n_elements(bu2.x)
bt = fltarr(nelem)
;Add up amplitude in all 64 bins and multiply each bin by a bandwidth
ball = bu2.y + bv2.y + bw2.y
for j=0L,nelem-1 do bt[j] = sqrt(total(ball[j,*]*bandw))  ;RMS method (Malaspina's method)
store_data,'Bfield_hissint',data={x:bu2.x,y:bt}
tplot,'Bfield_hissint'
;-----------------------------------------------
;MAGEIS file
pn = '~/Desktop/Research/RBSP_hiss_precip/mageis_cdfs/'
fnt = 'rbspa_rel02_ect-mageis-L2_20140103_v3.0.0.cdf'
cdf2tplot,file=pn+fnt
get_data,'FESA',data=dd
store_data,'FESA',data={x:dd.x,y:dd.y,v:reform(dd.v[0,*])}
get_data,'FESA',data=dd
store_data,'fesa_2mev',data={x:dd.x,y:dd.y[*,21]}
ylim,'fesa_2mev',0.02,100,1
ylim,'FESA',30,4000,1
tplot,'FESA'
zlim,'FESA',0,1d5
;-----------------------------------------------
payloads = ['2I','2W']
spinperiod = 11.8
rbsp_load_barrel_lc,payloads,date,type='rcnt'

;Get rid of NaN values in the peak detector data. This messes up the downsampling
get_data,'PeakDet_2I',data=dd
goo = where(dd.y lt 0.)
if goo[0] ne -1 then dd.y[goo] = !values.f_nan
xv = dd.x
yv = dd.y
interp_gap,xv,yv
store_data,'PeakDet_2I',data={x:xv,y:yv}
options,'PeakDet_2I','colors',250
;--------------------------------------------------


get_data,'rbspa_efw_esvy_mgse_vxb_removed',data=esvy
times = esvy.x

rbsp_boom_directions_crib,times,'a',/no_spice_load
tplot,['vecu_gse','vecv_gse','vecw_gse']


rbsp_load_emfisis,probe=probe,coord='gse',cadence='1sec',level='l3'  ;load this for the mag model subtract


;Create dB/B variable
rbsp_detrend,'rbspa_emfisis_l3_1sec_gse_Magnitude',60.*10.
copy_data,'rbspa_emfisis_l3_1sec_gse_Magnitude_smoothed','rbspa_emfisis_l3_1sec_gse_Magnitude_smoothed1'
rbsp_detrend,'rbspa_emfisis_l3_1sec_gse_Magnitude',60.*0.1667
tplot,['rbspa_emfisis_l3_1sec_gse_Magnitude_smoothed1','rbspa_emfisis_l3_1sec_gse_Magnitude_detrend'] 
   

get_data,'rbspa_emfisis_l3_1sec_gse_Magnitude_smoothed1',data=ds
get_data,'rbspa_emfisis_l3_1sec_gse_Magnitude_smoothed',data=d
db_b = 100.*(d.y - ds.y)/ds.y

store_data,'db_b',data={x:ds.x,y:db_b}

;dB/B waves show 1% fluctuations
tplot,['db_b','rbspa_emfisis_l3_1sec_gse_Magnitude_detrend','rbspa_emfisis_l3_1sec_gse_Magnitude_smoothed']




rbsp_detrend,'rbspa_emfisis_l3_1sec_gse_Magnitude',60.*5.


tinterpol_mxn,'rbspa_emfisis_l3_4sec_gse_Mag',times,newname='rbspa_emfisis_l3_4sec_gse_Mag'
tinterpol_mxn,'rbspa_emfisis_l3_4sec_gse_Magnitude',times,newname='rbspa_emfisis_l3_4sec_gse_Magnitude'

get_data,'rbspa_emfisis_l3_4sec_gse_Mag',data=mag
get_data,'rbspa_emfisis_l3_4sec_gse_Magnitude',data=magnit
magnit = magnit.y
mag_uvec = [[mag.y[*,0]],[mag.y[*,1]],[mag.y[*,2]]]
mag_uvec[*,0] /= magnit
mag_uvec[*,1] /= magnit
mag_uvec[*,2] /= magnit



;Find out when the u and v antennas are roughly perp and parallel to Bo
get_data,'vecu_gse',data=vecu
get_data,'vecv_gse',data=vecv
get_data,'vecw_gse',data=vecw

angleub = fltarr(n_elements(vecu.x))
for i=0L,n_elements(vecu.x)-1 do angleub[i] = acos(total(mag_uvec[i,*] * vecu.y[i,*]))/!dtor
store_data,'angleub',data={x:times,y:angleub}
anglevb = fltarr(n_elements(vecu.x))
for i=0L,n_elements(vecu.x)-1 do anglevb[i] = acos(total(mag_uvec[i,*] * vecv.y[i,*]))/!dtor
store_data,'anglevb',data={x:times,y:anglevb}
anglewb = fltarr(n_elements(vecu.x))
for i=0L,n_elements(vecu.x)-1 do anglewb[i] = acos(total(mag_uvec[i,*] * vecw.y[i,*]))/!dtor
store_data,'anglewb',data={x:times,y:anglewb}


;plot angle b/t antennas and Bo
tplot,['angleub','anglevb','anglewb']



;Load the Esvy in UVW to see what the parallel and perp (to Bo) components are

rbsp_load_efw_waveform,probe='a',type='calibrated',datatype='esvy',coord='uvw'
copy_data,'rbspa_efw_esvy','rbspa_efw_esvy_uvw'
get_data,'rbspa_efw_esvy_uvw',data=esvy_uvw

esvy_u = esvy_uvw.y[*,0]
goo = where((angleub le 87) or (angleub ge 92))
esvy_u[goo] = !values.f_nan
store_data,'esvy_u_perp',data={x:times,y:esvy_u}

esvy_u = esvy_uvw.y[*,0]
goo = where(angleub ge 2)
esvy_u[goo] = !values.f_nan
store_data,'esvy_u_para',data={x:times,y:esvy_u}


ylim,['esvy_u_perp','esvy_u_para'],-2,2
tplot,['esvy_u_perp','esvy_u_para']


;Replace the spinaxis MGSE component with the perp component from E12
get_data,'esvy_u_perp',data=eperp
get_data,'rbspa_efw_esvy_mgse_vxb_removed',data=emgse

emgse.y[*,0] = eperp.y
store_data,'rbspa_efw_esvy_mgse_vxb_removed_fixed',data=emgse


;Create dE/E variable
rbsp_detrend,'rbspa_efw_esvy_mgse_vxb_removed_fixed',60.*10.
copy_data,'rbspa_efw_esvy_mgse_vxb_removed_fixed_smoothed','rbspa_efw_esvy_mgse_vxb_removed_fixed_smoothed1'
rbsp_detrend,'rbspa_efw_esvy_mgse_vxb_removed_fixed',60.*0.1667
tplot,['rbspa_efw_esvy_mgse_vxb_removed_fixed_smoothed1','rbspa_efw_esvy_mgse_vxb_removed_fixed_detrend'] 
   

get_data,'rbspa_efw_esvy_mgse_vxb_removed_fixed_smoothed1',data=ds
get_data,'rbspa_efw_esvy_mgse_vxb_removed_fixed_smoothed',data=d
de_e = 100.*(d.y - ds.y)/ds.y

store_data,'de_e',data={x:ds.x,y:dn_n}

;dB/B waves show 1% fluctuations
tplot,['de_e','rbspa_efw_esvy_mgse_vxb_removed_fixed_detrend','rbspa_efw_esvy_mgse_vxb_removed_fixed_smoothed']








;Transform Bfield into MGSE
get_data,'rbspa_spinaxis_direction_gse',data=wsc
wsc_gse = reform(wsc.y[0,*])
rbsp_gse2mgse,'rbspa_emfisis_l3_1sec_gse_Mag',wsc_gse,newname='rbspa_emfisis_l3_1sec_mgse_Mag'
tinterpol_mxn,'rbspa_emfisis_l3_1sec_mgse_Mag',times,newname='rbspa_emfisis_l3_1sec_mgse_Mag'

;Smooth the data over short timespan
rbsp_detrend,['rbspa_emfisis_l3_1sec_mgse_Mag'],60.*5.



;Rotate fixed efield to Bo
fa = rbsp_rotate_field_2_vec('rbspa_efw_esvy_mgse_vxb_removed_fixed','rbspa_emfisis_l3_1sec_mgse_Mag_smoothed',/efa)
ylim,'rbspa_efw_esvy_mgse_vxb_removed_fixed_EFA_coord',-2,2


;Now rotate the detrended Bo to smoothed Bo
fa = rbsp_rotate_field_2_vec('rbspa_emfisis_l3_1sec_mgse_Mag_detrend','rbspa_emfisis_l3_1sec_mgse_Mag_smoothed',/efa)


;****************************
;Test wave with z MGSE = 0
get_data,'rbspa_emfisis_l3_1sec_mgse_Mag_detrend',data=dd

wx = sin(indgen(n_elements(dd.x))/10.)
wy = cos(indgen(n_elements(dd.x))/10.)
wz = replicate(0.,n_elements(dd.x))


tstwave = [[wx],[wy],[wz]]
store_data,'tstwave',data={x:dd.x,y:tstwave}

fa = rbsp_rotate_field_2_vec('tstwave','rbspa_emfisis_l3_1sec_mgse_Mag_smoothed_DS')
fa = rbsp_rotate_field_2_vec('tstwave','rbspa_emfisis_l3_1sec_mgse_Mag_smoothed',/efa)

;These both look good. The field-aligned z component is small
tplot,['tstwave_FA_minvar','tstwave_EFA_coord']

;****************************



;*****TRY MINVAR COORD********
;Rotate fixed efield to Bo
rbsp_downsample,'rbspa_emfisis_l3_1sec_mgse_Mag_smoothed',1/2
fa = rbsp_rotate_field_2_vec('rbspa_emfisis_l3_1sec_mgse_Mag_detrend','rbspa_emfisis_l3_1sec_mgse_Mag_smoothed_DS')
;****************************


;split_vec,'rbspa_emfisis_l3_1sec_gse_Mag'
rbsp_detrend,'rbspa_emfisis_l3_1sec_gse_Mag',60.*5.

;VERY LITTLE FA EFIELD COMPONENT.
tplot,['rbspa_efw_esvy_mgse_vxb_removed_fixed_EFA_coord','rbspa_emfisis_l3_1sec_mgse_Mag_detrend_EFA_coord']

;Check the GSE mag to be sure that there is a field-aligned component
tplot,'rbspa_emfisis_l3_1sec_gse_Mag_detrend'

;OK, now I'm convinced that there is a FA compressional Bmag component
;Let's compare this to dn/n

split_vec,'rbspa_emfisis_l3_1sec_mgse_Mag_detrend_EFA_coord'

;Clearly the Bz component correlates well with dn/n much better than
;the perp components
tplot,['rbspa_emfisis_l3_1sec_mgse_Mag_detrend_EFA_coord_x',$
	   'rbspa_emfisis_l3_1sec_mgse_Mag_detrend_EFA_coord_y',$
	   'rbspa_emfisis_l3_1sec_mgse_Mag_detrend_EFA_coord_z','dn_n']

;OK, let's overplot the phases of dn_n and FA Bw to see if it's slow or fast mode
rbsp_detrend,['rbspa_emfisis_l3_1sec_mgse_Mag_detrend_EFA_coord_z','dn_n'],60.*3.
tplot,['rbspa_emfisis_l3_1sec_mgse_Mag_detrend_EFA_coord_z','dn_n']+'_detrend'

;Normalize these and overplot
get_data,'rbspa_emfisis_l3_1sec_mgse_Mag_detrend_EFA_coord_z',data=tmp
tmp2 = tmp.y*10.
store_data,'rbspa_emfisis_l3_1sec_mgse_Mag_detrend_EFA_coord_z_x10',data={x:tmp.x,y:tmp2}


;Test phase of dn_n
rbsp_detrend,'densitya',60.*5.
rbsp_detrend,'densitya_detrend',60.*0.2

store_data,'corr',data=['rbspa_emfisis_l3_1sec_mgse_Mag_detrend_EFA_coord_z_x10','dn_n_detrend']
options,'corr','colors',[0,250]
options,'corr','ytitle','Black=10x Bw FA (nT)!CRed=dn_n percent!Cdetrended'
store_data,'corr2',data=['rbspa_emfisis_l3_1sec_mgse_Mag_detrend_EFA_coord_z_x10','densitya_detrend_smoothed']
options,'corr2','colors',[0,250]
options,'corr2','ytitle','Black=10x Bw FA (nT)!CRed=density(cm-3)!Cdetrended'


;Density and FA Bw are out of phase, suggesting slow mode wave
tplot,['corr','corr2']

get_data,'FESA',data=fesa

store_data,'fesa30',data={x:fesa.x,y:fesa.y[*,3]}
store_data,'fesa54',data={x:fesa.x,y:fesa.y[*,4]}
store_data,'fesa80',data={x:fesa.x,y:fesa.y[*,5]}
store_data,'fesa108',data={x:fesa.x,y:fesa.y[*,6]}
store_data,'fesa144',data={x:fesa.x,y:fesa.y[*,8]}

rbsp_detrend,'fesa*',60.*3.
store_data,'fesas',data=['fesa30','fesa54','fesa80','fesa108','fesa144']+'_detrend'
options,'fesas','colors',[0,50,100,150,200]

tplot,['corr2','fesa30_detrend','fesa54_detrend','fesa80_detrend','fesa108_detrend','fesa144_detrend']


get_data,'rbspa_emfisis_l3_1sec_mgse_Mag_detrend_EFA_coord_x',data=mx
get_data,'rbspa_emfisis_l3_1sec_mgse_Mag_detrend_EFA_coord_y',data=my
get_data,'rbspa_emfisis_l3_1sec_mgse_Mag_detrend_EFA_coord_z',data=mz
mag = sqrt(mx.y^2 + my.y^2 + mz.y^2)
store_data,'Bmag_10x',data={x:mx.x,y:mag*10.}
store_data,'Bmag',data={x:mx.x,y:mag}

get_data,'rbspa_emfisis_l3_1sec_gse_Magnitude_detrend',data=dd
store_data,'rbspa_emfisis_l3_1sec_gse_Magnitude_detrend_10x',data={x:dd.x,y:10*dd.y}
get_data,'fesa30_detrend',data=dd
store_data,'fesatmp',data={x:dd.x,y:dd.y/100.}
store_data,'comb1',data=['rbspa_emfisis_l3_1sec_mgse_Mag_detrend_EFA_coord_z_x10','fesatmp']
store_data,'comb2',data=['densitya_detrend_smoothed','fesatmp']
store_data,'comb3',data=['rbspa_emfisis_l3_1sec_gse_Magnitude_detrend_10x','fesatmp']
;store_data,'comb3',data=['Bmag','fesatmp']
store_data,'comb4',data=['Bmag','rbspa_emfisis_l3_1sec_mgse_Mag_detrend_EFA_coord_z']
options,'comb1','colors',[0,250]
options,'comb2','colors',[50,250]
options,'comb3','colors',[0,250]
options,'comb1','ytitle','Bw_FA(nTx10)!CRed=FESA30keV!Cdetrend'
options,'comb2','ytitle','Density(cm-3)!CRed=FESA30keV!Cdetrend'
options,'comb3','ytitle','Bmag(nTx10)!CRed=FESA30keV!Cdetrend'

tplot,['comb1','comb2']

store_data,'comb2',data=['rbspa_emfisis_l3_1sec_mgse_Mag_detrend_EFA_coord_z_x10','densitya_detrend_smoothed','fesatmp']
options,'comb2','colors',[0,50,250]



get_data,'FPSA',data=fpsa

store_data,'fpsa58',data={x:fpsa.x,y:fpsa.y[*,0]}
store_data,'fpsa70',data={x:fpsa.x,y:fpsa.y[*,1]}
store_data,'fpsa83',data={x:fpsa.x,y:fpsa.y[*,2]}
store_data,'fpsa99',data={x:fpsa.x,y:fpsa.y[*,3]}
store_data,'fpsa118',data={x:fpsa.x,y:fpsa.y[*,4]}

rbsp_detrend,'fpsa*',60.*3.
store_data,'fpsas',data=['fpsa58','fpsa70','fpsa83','fpsa99','fpsa118']+'_detrend'
options,'fpsas','colors',[0,50,100,150,200]

tplot,['corr2','fpsa58_detrend','fpsa70_detrend','fpsa83_detrend','fpsa99_detrend','fpsa118_detrend']

tplot,['corr2','fpsas']


;tplot,['rbspa_emfisis_l3_1sec_mgse_Mag_detrend_EFA_coord','rbspa_emfisis_l3_1sec_gse_Magnitude_detrend']






;***********************************************************
;PERFORM A MINVAR ANALYSIS ON THE 1MIN WAVES (NOT DOTTED INTO BO)
;***********************************************************

rbsp_detrend,'rbspa_emfisis_l3_1sec_gse_Mag',60.*30.
copy_data,'rbspa_emfisis_l3_1sec_gse_Mag_smoothed','rbspa_emfisis_l3_1sec_gse_Mag_DC'

;rbsp_detrend,'rbspa_emfisis_l3_1sec_gse_Mag',60.*0.1
;tplot,'rbspa_emfisis_l3_1sec_gse_Mag_detrend'
rbsp_detrend,'rbspa_emfisis_l3_1sec_gse_Mag',60.*20.
tplot,'rbspa_emfisis_l3_1sec_gse_Mag_detrend'


get_data,'rbspa_emfisis_l3_1sec_gse_Mag_detrend',data=btmp
;tt0 = '2014-01-03/20:09'
;tt1 = '2014-01-03/20:10'
;tt0 = '2014-01-03/20:09'    
;tt1 = '2014-01-03/20:20'
tt0 = '2014-01-03/20:00'
tt1 = '2014-01-03/20:30'

tplot,'rbspa_emfisis_l3_1sec_gse_Mag_detrend'
tlimit,tt0,tt1

ts = tsample('rbspa_emfisis_l3_1sec_gse_Mag_detrend',[time_double(tt0),time_double(tt1)],times=tms)
store_data,'Bw',data={x:tms,y:ts}


;Bandpass the data
get_data,'Bw',data=bw
srt = 1/(bw.x[1]-bw.x[0])
lf = 0.003
hf = 0.05

vb = vector_bandpass(bw.y,srt,lf,hf)
store_data,'Bwbp',data={x:bw.x,y:vb}
tplot,['Bw','Bwbp']
copy_data,'Bwbp','Bw'




plot_wavestuff,'Bw',/hod


x_data = vb[*,0]
y_data = vb[*,1]
z_data = vb[*,2]

orig_arr = [[x_data],[y_data],[z_data]]
vectors = rbsp_min_var(x_data,y_data,z_data,eig_vals=eig_vals)
print,'*******************************'
print,'int/min',eig_vals[1]/eig_vals[0]
print,'max/int',eig_vals[2]/eig_vals[1]
print,'*******************************'
rot_arr = fltarr(n_elements(x_data),3)
for bb=0L,n_elements(x_data)-1 do rot_arr[bb,*] = reform(vectors ## [[x_data[bb]],[y_data[bb]],[z_data[bb]]])
store_data,'Bw_minvar1',data={x:tms,y:rot_arr}

;eigenvectors in GSE
ev_min = vectors[*,0]
ev_int = vectors[*,1]
ev_max = vectors[*,2]


;Bo in GSE 
tsdc = tsample('rbspa_emfisis_l3_1sec_gse_Mag_DC',[time_double(tt0),time_double(tt1)],times=tmsdc)
Bogse = reform(tsdc[0,*])
bmg = sqrt(Bogse[0]^2 + Bogse[1]^2 + Bogse[2]^2)
bogse = Bogse/bmg


;angle b/t eigenvalues and Bo
anglemax = acos(total(ev_max*Bogse))/!dtor
print,'Angle b/t Bo and Max eigenvec: ',anglemax
angleint = acos(total(ev_int*Bogse))/!dtor
print,'Angle b/t Bo and Int eigenvec: ',angleint
anglemin = acos(total(ev_min*Bogse))/!dtor
print,'Angle b/t Bo and Min eigenvec: ',anglemin


tplot,['Bw','Bw_minvar1']
tlimit,tt0,tt1
plot_wavestuff,'Bw_minvar1',/hod,vec=Bogse






;*****
;Method 2

minvar_matrix_make,'Bw';,tstart=tt0,tstop=tt1
;order is max, int, min
tvector_rotate,'Bw_mva_mat','Bw',newname='Bw_minvar2'
;Rearrange the order of results
get_data,'Bw_minvar2',data=dd
store_data,'Bw_minvar2',data={x:dd.x,y:[[dd.y[*,2]],[dd.y[*,1]],[dd.y[*,0]]]}

tplot,['Bw','Bw_minvar1','Bw_minvar2']




;*******
;Method3

x = rbsp_min_var_rot(vb,BKG_FIELD=bogse)

store_data,'Bw_minvar3',data={x:tms,y:x.mv_field}
tplot,['Bw','Bw_minvar1','Bw_minvar2','Bw_minvar3']
tlimit,tt0,tt1

emin = x.eigenvectors[*,0]
eint = x.eigenvectors[*,1]
emax = x.eigenvectors[*,2]

;angle b/t eigenvalues and Bo
anglemax = acos(total(emax*Bogse))/!dtor
print,'Angle b/t Bo and Max eigenvec: ',anglemax
angleint = acos(total(eint*Bogse))/!dtor
print,'Angle b/t Bo and Int eigenvec: ',angleint
anglemin = acos(total(emin*Bogse))/!dtor
print,'Angle b/t Bo and Min eigenvec: ',anglemin







;Bandpass before finding min var


get_data,'Bw',data=bw
srt = 1/(bw.x[1]-bw.x[0])
lf = 0.004
hf = 0.05

vb = vector_bandpass(bw.y,srt,lf,hf)

store_data,'Bwbp',data={x:bw.x,y:vb}
tplot,['Bw','Bwbp']


FUNCTION vector_bandpass,dat,srt,lf,hf,LOWF=lowf,MIDF=midf,HIGHF=highf


x = rbsp_min_var_rot(ts,BKG_FIELD=bogse)

store_data,'Bw_minvar3',data={x:tms,y:x.mv_field}
tplot,['Bw','Bw_minvar1','Bw_minvar2','Bw_minvar3']
tlimit,tt0,tt1

emin = x.eigenvectors[*,0]
eint = x.eigenvectors[*,1]
emax = x.eigenvectors[*,2]

;angle b/t eigenvalues and Bo
anglemax = acos(total(emax*Bogse))/!dtor
print,'Angle b/t Bo and Max eigenvec: ',anglemax
angleint = acos(total(eint*Bogse))/!dtor
print,'Angle b/t Bo and Int eigenvec: ',angleint
anglemin = acos(total(emin*Bogse))/!dtor
print,'Angle b/t Bo and Min eigenvec: ',anglemin

