
tplot_options,'title','from jan5_zoomed_event.pro'

date = '2014-01-05'
probe = 'b'
rbspx = 'rbspb'
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
fn2 = 'bar_2K_l2_sspc_20140105_v00.cdf'
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
myfile = path+"bar_2K_140103_mag.dat"
data = read_ascii(myfile, template = res)

;data.mlt = data.mlt*360.0/24.0
;x = abs(data.l)*cos(data.mlt*!pi/180.0)
;y = abs(data.l)*sin(data.mlt*!pi/180.0)

tms = time_double('2014-01-05/00:00') + data.utsec
store_data,'mlt_2K',data={x:tms,y:data.mlt}
store_data,'l_2K',data={x:tms,y:abs(data.l)}
store_data,'mlat_2K',data={x:tms,y:data.lat}
store_data,'alt_2K',data={x:tms,y:data.alt}



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

dif_data,'rbspb_state_mlt','mlt_2I'
dif_data,'rbspb_state_lshell','l_2I'

get_data,'rbspb_state_mlt-mlt_2I',data=dd
store_data,'rbspb_state_mlt-mlt_2I',data={x:dd.x,y:abs(dd.y)}
get_data,'rbspb_state_lshell-l_2I',data=dd
store_data,'rbspb_state_lshell-l_2I',data={x:dd.x,y:abs(dd.y)}

;------------------------------------------------
;Find absolute separation b/t VAPa and 2I

tinterpol_mxn,'mlt_2I','rbspb_state_mlt'
get_data,'mlt_2I_interp',data=t
mlt2I = t.y * 360./24.
get_data,'rbspb_state_mlt',data=t
mlta = t.y

tinterpol_mxn,'l_2I','rbspb_state_lshell'
get_data,'l_2I_interp',data=t
l2I = t.y
get_data,'rbspb_state_lshell',data=t
la = t.y

tinterpol_mxn,'alt_2I','rbspb_state_lshell'
get_data,'alt_2I_interp',data=t
alt2I = t.y
r2I = (6370. + alt2I)/6370.

;Can get 2I mlat from Lshell and altitude
;Lshell = rad/(cos(!dtor*mlat)^2)  ;L-shell in centered dipole
mlat2I = acos(sqrt(r2I/l2I))/!dtor
mlat2I = -1*mlat2I  ;southern hemisphere
store_data,'mlat_2I',data={x:t.x,y:mlat2I}

get_data,'rbspb_state_mlat',data=t
mlata = t.y
colata = 90. - mlata
store_data,'rbspb_state_colat',data={x:t.x,y:colata}

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
get_data,'rbspb_state_radius',data=rada
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
tplot,['rbspb_state_mlat','mlat_2I']
tplot,['rbspb_state_colat','colat_2I']
tplot,['xsma','xsm2I']
tplot,['ysma','ysm2I']
tplot,['zsma','zsm2I']
tplot,['xdiff','ydiff','zdiff']



;--------------------------------------------------
payloads = ['2K','2I','2W','2X']
spinperiod = 11.8
rbsp_load_barrel_lc,payloads,date,type='rcnt'
;rbsp_load_barrel_lc,payloads,date,type='ephm'
rbsp_load_barrel_lc,payloads,date


;Get rid of NaN values in the peak detector data. This messes up the downsampling
get_data,'PeakDet_2K',data=dd
goo = where(dd.y lt 0.)
if goo[0] ne -1 then dd.y[goo] = !values.f_nan
xv = dd.x
yv = dd.y
interp_gap,xv,yv
store_data,'PeakDet_2K',data={x:xv,y:yv}
options,'PeakDet_2K','colors',250

;Get rid of NaN values in the peak detector data. This messes up the downsampling
get_data,'PeakDet_2I',data=dd
goo = where(dd.y lt 0.)
if goo[0] ne -1 then dd.y[goo] = !values.f_nan
xv = dd.x
yv = dd.y
interp_gap,xv,yv
store_data,'PeakDet_2I',data={x:xv,y:yv}
options,'PeakDet_2I','colors',250

;Get rid of NaN values in the peak detector data. This messes up the downsampling
get_data,'PeakDet_2W',data=dd
goo = where(dd.y lt 0.)
if goo[0] ne -1 then dd.y[goo] = !values.f_nan
xv = dd.x
yv = dd.y
interp_gap,xv,yv
store_data,'PeakDet_2W',data={x:xv,y:yv}
options,'PeakDet_2W','colors',250

;Get rid of NaN values in the peak detector data. This messes up the downsampling
get_data,'PeakDet_2X',data=dd
goo = where(dd.y lt 0.)
if goo[0] ne -1 then dd.y[goo] = !values.f_nan
xv = dd.x
yv = dd.y
interp_gap,xv,yv
store_data,'PeakDet_2X',data={x:xv,y:yv}
options,'PeakDet_2X','colors',250

;--------------------------------------------------------
;MAGEIS file
pn = '~/Desktop/Research/RBSP_hiss_precip/mageis_cdfs/'
fnt = 'rbspb_rel02_ect-mageis-L2_20140105_v3.0.0.cdf'
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
fnt = 'rbsp-b_WFR-spectral-matrix_emfisis-L2_20140105_v1.3.2.cdf'
cdf2tplot,file=pn+fnt
get_data,'BwBw',data=dd
store_data,'BwBw',data={x:dd.x,y:1000.*1000.*dd.y,v:reform(dd.v)}
options,'BwBw','spec',1
zlim,'BwBw',1d-6,100,1
ylim,'BwBw',20,1000,1

;------------------------------------------------------

rbspx = 'rbsp' + probe
;t0 = time_double('2014-01-06/20:00')
;t1 = time_double('2014-01-06/22:00')
t0 = time_double('2014-01-05/18:00')
t1 = time_double('2014-01-05/22:00')
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
tinterpol_mxn,'density'+probe,spec.x,newname='dens'
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

store_data,'mlt_both',data=[rbspx+'_state_mlt','mlt_2K']
store_data,'l_both',data=[rbspx+'_state_lshell','l_2K']
options,'mlt_both','colors',[0,250]
options,'l_both','colors',[0,250]

tplot,['density'+probe,'fesa_2mev','FESA','rbspb_state_lshell','rbspb_state_mlt','mlt_both','l_both','PeakDet_2K']
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



rbsp_detrend,'density'+probe,60.*10.
copy_data,'densityb_smoothed','densityb_smoothed1'      
rbsp_detrend,'density'+probe,60.*0.1667
tplot,['densityb_smoothed1','densityb_detrend'] 
   

get_data,'densityb_smoothed1',data=ds
get_data,'densityb_smoothed',data=d
dn_n = 100.*(d.y - ds.y)/ds.y

store_data,'dn_n',data={x:ds.x,y:dn_n}
tplot,['densityb_smoothed1','densityb_smoothed','dn_n']
rbsp_detrend,['Bfield_hissint','PeakDet_2K','LC1_2K','dn_n'],60.*20
rbsp_detrend,['Bfield_hissint','PeakDet_2K','LC1_2K','dn_n']+'_detrend',60.*0.7


options,'BwBw','ytitle','BwBw'
options,'BwBw','ysubtitle','[pT^2/Hz]'

store_data,'lboth',data=['rbspb_state_lshell','l_2I']
store_data,'mltboth',data=['rbspb_state_mlt','mlt_2I']


tlimit,t0,t1

zlim,'BwBw',1d-2,20,1
ylim,'BwBw',20,600,1
ylim,'PeakDet_2K',3000,20000
ylim,'PeakDet_2K_detrend_smoothed',-3000,3000
ylim,'Bfield_hissint_detrend_smoothed',-20,30
ylim,'dn_n_detrend_smoothed',-40,40
options,['rbspb_state_mlt-mlt_2K','rbspb_state_lshell-l_2K'],'panel_size',0.7

tplot,['BwBw','Bfield_hissint_detrend_smoothed','PeakDet_2K_detrend_smoothed','dn_n_detrend_smoothed','mltboth','lboth','rbspb_state_mlt-mlt_2K','rbspb_state_lshell-l_2K']




rbsp_detrend,'PeakDet_2K',60.*0.4
rbsp_detrend,'rbspb_emfisis_quicklook_Magnitude',60.*2.
rbsp_detrend,'rbspb_emfisis_quicklook_Magnitude_detrend',60.*0.5


ylim,'densityb',100,10000,1
ylim,'dn_n',-10,10
ylim,'Bfield_hissint',0,50
ylim,['PeakDet_2K_smoothed','PeakDet_2K'],3500,4500
ylim,'rbspb_emfisis_quicklook_Magnitude_detrend_smoothed',-0.5,0.5
tplot,['rbspb_efw_64_spec4','Bfield_hissint','PeakDet_2K_smoothed','dn_n','rbspb_emfisis_quicklook_Magnitude_detrend_smoothed','densityb']




;------------------------------------------------------------------
;Look for wave fluctuations in Bfield and Efield survey products
;------------------------------------------------------------------

rbsp_load_efw_waveform,probe=probe,type='calibrated',datatype='esvy'
rbsp_load_emfisis,probe=probe,coord='gse',cadence='1sec',level='l3'  ;load this for the mag model subtract

get_data,'rbspb_spinaxis_direction_gse',data=wsc
wsc_gse = reform(wsc.y[0,*])


rbsp_gse2mgse,'rbspb_emfisis_l3_1sec_gse_Mag',wsc_gse,newname='rbspb_emfisis_l3_1sec_mgse_Mag'

rbsp_uvw_to_mgse,probe,'rbspb_efw_esvy',/no_spice_load;,/nointerp,/no_offset	
split_vec,'rbspb_efw_esvy_mgse'
split_vec,'rbspb_emfisis_l3_1sec_mgse_Mag'


;Smooth the data over short timespan
rbsp_detrend,['rbspb_emfisis_l3_1sec_mgse_Mag_x','rbspb_emfisis_l3_1sec_mgse_Mag_y','rbspb_emfisis_l3_1sec_mgse_Mag_z'],60.*5.
rbsp_detrend,['rbspb_efw_esvy_mgse_y','rbspb_efw_esvy_mgse_z'],60.*0.2
rbsp_detrend,['rbspb_efw_esvy_mgse_y_smoothed','rbspb_efw_esvy_mgse_z_smoothed'],60.*2
join_vec,['rbspb_emfisis_l3_1sec_mgse_Mag_x_detrend','rbspb_emfisis_l3_1sec_mgse_Mag_y_detrend','rbspb_emfisis_l3_1sec_mgse_Mag_z_detrend'],'rbspb_emfisis_l3_1sec_mgse_Mag_detrend'
join_vec,['rbspb_emfisis_l3_1sec_mgse_Mag_x_smoothed','rbspb_emfisis_l3_1sec_mgse_Mag_y_smoothed','rbspb_emfisis_l3_1sec_mgse_Mag_z_smoothed'],'rbspb_emfisis_l3_1sec_mgse_Mag_smoothed'


;See if there's a FA component to E and B

;First see if the spin axis is mostly perp to Bo
tplot,'rbspb_emfisis_l3_1sec_mgse_Mag'
;yes, the x-MGSE component of Bo is very small compared to spinplane comps

get_data,'rbspb_efw_esvy_mgse',data=efield
efield.y[*,0] = 0.   ;zero out e56 comp
store_data,'rbspb_efw_esvy_mgse0',data=efield

rbsp_downsample,'rbspb_emfisis_l3_1sec_mgse_Mag_smoothed',0.1

fa = rbsp_rotate_field_2_vec('rbspb_emfisis_l3_1sec_mgse_Mag_detrend','rbspb_emfisis_l3_1sec_mgse_Mag_smoothed_DS')
fa = rbsp_rotate_field_2_vec('rbspb_efw_esvy_mgse0','rbspb_emfisis_l3_1sec_mgse_Mag_smoothed')


split_vec,'rbspb_emfisis_l3_1sec_mgse_Mag_detrend_FA_minvar'
split_vec,'rbspb_efw_esvy_mgse0_FA_minvar'

rbsp_detrend,['rbspb_efw_esvy_mgse0_FA_minvar_x','rbspb_efw_esvy_mgse0_FA_minvar_y','rbspb_efw_esvy_mgse0_FA_minvar_z'],60.*0.2


tplot,['rbspb_efw_esvy_mgse0_FA_minvar','rbspb_emfisis_l3_1sec_mgse_Mag_detrend_FA_minvar_x','rbspb_emfisis_l3_1sec_mgse_Mag_detrend_FA_minvar_y','rbspb_emfisis_l3_1sec_mgse_Mag_detrend_FA_minvar_z','dn_n','Bfield_hissint','PeakDet_2I']


tplot,['rbspb_efw_esvy_mgse0_FA_minvar_z_smoothed','rbspb_efw_esvy_mgse0_FA_minvar_y_smoothed','rbspb_efw_esvy_mgse0_FA_minvar_x_smoothed','densityb_smoothed']



tplot,['rbspb_emfisis_l3_1sec_mgse_Mag_detrend_FA_minvar_z','dn_n','Bfield_hissint','PeakDet_2I']






get_data,'FESA',data=fesa

store_data,'fesa30',data={x:fesa.x,y:fesa.y[*,3]}
store_data,'fesa54',data={x:fesa.x,y:fesa.y[*,4]}
store_data,'fesa80',data={x:fesa.x,y:fesa.y[*,5]}
store_data,'fesa108',data={x:fesa.x,y:fesa.y[*,6]}
store_data,'fesa144',data={x:fesa.x,y:fesa.y[*,8]}





;**********************************************************************
;SET UP VARIABLES FOR CROSS-CORRELATION
;**********************************************************************

t0z = '2014-01-05/18:00'
t1z = '2014-01-05/20:20'


tplot,['rbspb_emfisis_l3_1sec_mgse_Magnitude','densityb']
tlimit,t0z,t1z

;----------
;Background field direction
rbsp_detrend,'rbspb_emfisis_l3_1sec_mgse_Mag',60.*0.168
copy_data,'rbspb_emfisis_l3_1sec_mgse_Mag_smoothed','rbspb_emfisis_l3_1sec_mgse_Mag_sp'
rbsp_detrend,'rbspb_emfisis_l3_1sec_mgse_Mag_sp',60.*20.
rbsp_downsample,'rbspb_emfisis_l3_1sec_mgse_Mag_sp_smoothed',1/2.

rbsp_detrend,'rbspb_emfisis_l3_1sec_mgse_Mag_sp',60.*20.
tplot,['rbspb_emfisis_l3_1sec_mgse_Mag_sp','rbspb_emfisis_l3_1sec_mgse_Mag_sp_detrend']
rbsp_detrend,'rbspb_emfisis_l3_1sec_mgse_Mag_sp_detrend',60.*40.
tplot,['rbspb_emfisis_l3_1sec_mgse_Mag_sp_detrend','rbspb_emfisis_l3_1sec_mgse_Mag_sp_detrend_detrend']
store_data,'bcomb',data=['rbspb_emfisis_l3_1sec_mgse_Mag_sp_detrend','rbspb_emfisis_l3_1sec_mgse_Mag_sp_detrend_detrend']
options,'bcomb','colors',[0,250]
tplot,'bcomb'
fa = rbsp_rotate_field_2_vec('rbspb_emfisis_l3_1sec_mgse_Mag_sp_detrend_detrend','rbspb_emfisis_l3_1sec_mgse_Mag_sp_smoothed_DS')
tplot,'rbspb_emfisis_l3_1sec_mgse_Mag_sp_detrend_detrend_FA_minvar'
split_vec,'rbspb_emfisis_l3_1sec_mgse_Mag_sp_detrend_detrend'
;----------
;Density

rbsp_detrend,'densityb',60.*0.168
copy_data,'densityb','densityb_sp'
tplot,['densityb','densityb_sp']
rbsp_detrend,'densityb_sp',60.*20.
tplot,['densityb_sp','densityb_sp_detrend']
rbsp_detrend,'densityb_sp_detrend',60.*40.
tplot,['densityb_sp_detrend','densityb_sp_detrend_detrend']
store_data,'dcomb',data=['densityb_sp_detrend','densityb_sp_detrend_detrend']
options,'dcomb','colors',[0,250]
tplot,'dcomb'
;----------
;FESA30
rbsp_detrend,'fesa30',60.*0.168
copy_data,'fesa30','fesa30_sp'
tplot,['fesa30','fesa30_sp']
rbsp_detrend,'fesa30_sp',60.*20.
tplot,['fesa30_sp','fesa30_sp_detrend']
;----------
;FESA54
rbsp_detrend,'fesa54',60.*0.168
copy_data,'fesa54','fesa54_sp'
tplot,['fesa54','fesa54_sp']
rbsp_detrend,'fesa54_sp',60.*20.
tplot,['fesa54_sp','fesa54_sp_detrend']
;----------
;FESA80
rbsp_detrend,'fesa80',60.*0.168
copy_data,'fesa80','fesa80_sp'
tplot,['fesa80','fesa80_sp']
rbsp_detrend,'fesa80_sp',60.*20.
tplot,['fesa80_sp','fesa80_sp_detrend']
;----------
;FESA108
rbsp_detrend,'fesa108',60.*0.168
copy_data,'fesa108','fesa108_sp'
tplot,['fesa108','fesa108_sp']
rbsp_detrend,'fesa108_sp',60.*20.
tplot,['fesa108_sp','fesa108_sp_detrend']
;----------
;FESA144
rbsp_detrend,'fesa144',60.*0.168
copy_data,'fesa144','fesa144_sp'
tplot,['fesa144','fesa144_sp']
rbsp_detrend,'fesa144_sp',60.*20.
tplot,['fesa144_sp','fesa144_sp_detrend']
;----------
;Bfield hissint
rbsp_detrend,'Bfield_hissint',60.*0.168
copy_data,'Bfield_hissint','Bfield_hissint_sp'
tplot,['Bfield_hissint','Bfield_hissint_sp']
rbsp_detrend,'Bfield_hissint_sp',60.*20.
tplot,['Bfield_hissint_sp','Bfield_hissint_sp_detrend']
rbsp_detrend,'Bfield_hissint_sp_detrend',60.*40.
tplot,['Bfield_hissint_sp_detrend','Bfield_hissint_sp_detrend_detrend']
store_data,'hcomb',data=['Bfield_hissint_sp_detrend','Bfield_hissint_sp_detrend_detrend']
options,'hcomb','colors',[0,250]
tplot,'hcomb'
;----------
;PeakDet_2K
rbsp_detrend,'PeakDet_2K',60.*0.168
copy_data,'PeakDet_2K','PeakDet_2K_sp'
tplot,['PeakDet_2K','PeakDet_2K_sp']
rbsp_detrend,'PeakDet_2K_sp',60.*20.
tplot,['PeakDet_2K_sp','PeakDet_2K_sp_detrend']
rbsp_detrend,'PeakDet_2K_sp_detrend',60.*40.
tplot,['PeakDet_2K_sp_detrend','PeakDet_2K_sp_detrend_detrend']
store_data,'pcomb',data=['PeakDet_2K_sp_detrend','PeakDet_2K_sp_detrend_detrend']
options,'pcomb','colors',[0,250]
tplot,'pcomb'
;----------
;PeakDet_2I
rbsp_detrend,'PeakDet_2I',60.*0.168
copy_data,'PeakDet_2I','PeakDet_2I_sp'
tplot,['PeakDet_2I','PeakDet_2I_sp']
rbsp_detrend,'PeakDet_2I_sp',60.*20.
tplot,['PeakDet_2I_sp','PeakDet_2I_sp_detrend']
rbsp_detrend,'PeakDet_2I_sp_detrend',60.*40.
tplot,['PeakDet_2I_sp_detrend','PeakDet_2I_sp_detrend_detrend']
store_data,'pcomb',data=['PeakDet_2I_sp_detrend','PeakDet_2I_sp_detrend_detrend']
options,'pcomb','colors',[0,250]
tplot,'pcomb'
;----------
;PeakDet_2W
rbsp_detrend,'PeakDet_2W',60.*0.168
copy_data,'PeakDet_2W','PeakDet_2W_sp'
tplot,['PeakDet_2W','PeakDet_2W_sp']
rbsp_detrend,'PeakDet_2W_sp',60.*20.
tplot,['PeakDet_2W_sp','PeakDet_2W_sp_detrend']
rbsp_detrend,'PeakDet_2W_sp_detrend',60.*40.
tplot,['PeakDet_2W_sp_detrend','PeakDet_2W_sp_detrend_detrend']
store_data,'pcomb',data=['PeakDet_2W_sp_detrend','PeakDet_2W_sp_detrend_detrend']
options,'pcomb','colors',[0,250]
tplot,'pcomb'
;----------
;PeakDet_2X
rbsp_detrend,'PeakDet_2X',60.*0.168
copy_data,'PeakDet_2X','PeakDet_2X_sp'
tplot,['PeakDet_2X','PeakDet_2X_sp']
rbsp_detrend,'PeakDet_2X_sp',60.*20.
tplot,['PeakDet_2X_sp','PeakDet_2X_sp_detrend']
rbsp_detrend,'PeakDet_2X_sp_detrend',60.*40.
tplot,['PeakDet_2X_sp_detrend','PeakDet_2X_sp_detrend_detrend']
store_data,'pcomb',data=['PeakDet_2X_sp_detrend','PeakDet_2X_sp_detrend_detrend']
options,'pcomb','colors',[0,250]
tplot,'pcomb'




ylim,'Bfield_hissint_sp_detrend_detrend',-15,15
ylim,'densityb_sp_detrend_detrend',-20,40
ylim,'rbspb_emfisis_l3_1sec_mgse_Mag_sp_detrend_detrend_z',-1,1
ylim,'fesa30_sp_detrend',-2000,2000
ylim,'fesa54_sp_detrend',-1500,1000

tplot_options,'title','products for correlation...12sec to 20min periods allowed'
tplot,['PeakDet_2K_sp_detrend_detrend','PeakDet_2W_sp_detrend_detrend','Bfield_hissint_sp_detrend_detrend','densityb_sp_detrend_detrend','rbspb_emfisis_l3_1sec_mgse_Mag_sp_detrend_detrend_z','fesa30_sp_detrend','fesa54_sp_detrend','fesa80_sp_detrend']













