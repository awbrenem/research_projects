;Perform cross-correlations on the Jan 3 data


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

rbsp_load_efw_spec,probe='a',type='calibrated',/pt
rbsp_load_efw_spec,probe='b',type='calibrated',/pt
rbsp_efw_position_velocity_crib,/noplot,/notrace
rbsp_efw_vxb_subtract_crib,probe,/hires,/no_spice_load
rbsp_load_emfisis,probe=probe,coord='gse',cadence='1sec',level='l3'  ;load this for the mag model subtract

dif_data,'rbspa_state_lshell','rbspb_state_lshell',newname='rbsp_state_lshell_diff'


;-----------------------------------------------
rbsp_load_efw_waveform,probe='a',type='calibrated',datatype='vsvy'
split_vec,'rbspa_efw_vsvy', suffix='_V'+['1','2','3','4','5','6']
get_data,'rbspa_efw_vsvy_V1',data=v1
get_data,'rbspa_efw_vsvy_V2',data=v2
sum12 = (v1.y + v2.y)/2.
density = 7354.3897*exp(sum12*2.8454878)+96.123628*exp(sum12*0.43020781)
store_data,'densitya',data={x:v1.x,y:density}
ylim,'density?',1,10000,1
options,'densitya','ytitle','density'+strupcase(probe)+'!Ccm^-3'
;-----------------------------------------------
rbsp_load_efw_waveform,probe='b',type='calibrated',datatype='vsvy'
split_vec,'rbspb_efw_vsvy', suffix='_V'+['1','2','3','4','5','6']
get_data,'rbspb_efw_vsvy_V1',data=v1
get_data,'rbspb_efw_vsvy_V2',data=v2
sum12 = (v1.y + v2.y)/2.
density = 7354.3897*exp(sum12*2.8454878)+96.123628*exp(sum12*0.43020781)
store_data,'densityb',data={x:v1.x,y:density}
ylim,'density?',1,10000,1
options,'densityb','ytitle','density'+strupcase(probe)+'!Ccm^-3'
;-----------------------------------------------
get_data,'rbspa_efw_64_spec2',data=bu2
get_data,'rbspa_efw_64_spec3',data=bv2
get_data,'rbspa_efw_64_spec4',data=bw2
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
store_data,'Bfield_hissinta',data={x:bu2.x,y:bt}


get_data,'rbspb_efw_64_spec2',data=bu2
get_data,'rbspb_efw_64_spec3',data=bv2
get_data,'rbspb_efw_64_spec4',data=bw2
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
store_data,'Bfield_hissintb',data={x:bu2.x,y:bt}
tplot,['Bfield_hissinta','Bfield_hissintb']
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
payloads = ['2I','2W','2X']
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
;BARREL diffusion results
file = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip/barrel_cdfs/For_Aaron2014_01_03_193000.hdf5'
R2 = FILE_INFO(file)
help,r2,/st

print,H5F_IS_HDF5(file)
result = h5_parse(file,/READ_DATA)

avebounce = transpose(result.avebounce._DATA)
avelocal =  transpose(result.avelocal._DATA)
energy = 1000.*result.energy._DATA   ;keV
time = time_double(time_string(result.time._DATA)) + 30.  ;shift bins by 30 seconds

store_data,'2I_avebounce',data={x:time,y:avebounce,v:energy}
options,'2I_avebounce','spec',1
zlim,'2I_avebounce',1d-8,1d-2,1
tplot,'2I_avebounce'
store_data,'2I_avebounce30',data={x:time,y:avebounce[*,30]}
store_data,'2I_avebounce50',data={x:time,y:avebounce[*,50]}
store_data,'2I_avebounce75',data={x:time,y:avebounce[*,75]}
store_data,'2I_avebounce150',data={x:time,y:avebounce[*,150]}

tots = avebounce[*,30] + avebounce[*,50] + avebounce[*,75] + avebounce[*,150]
store_data,'2I_avebouncetots',data={x:time,y:tots}
tplot,['2I_avebounce','2I_avebounce30','2I_avebounce50','2I_avebounce75','2I_avebounce150','2I_avebouncetots']


store_data,'2I_avelocal',data={x:time,y:avelocal,v:energy}
options,'2I_avelocal','spec',1
zlim,'2I_avelocal',1d-8,1d-2,1
tplot,'2I_avelocal'
store_data,'2I_avelocal30',data={x:time,y:avelocal[*,30]}
store_data,'2I_avelocal50',data={x:time,y:avelocal[*,50]}
store_data,'2I_avelocal75',data={x:time,y:avelocal[*,75]}
store_data,'2I_avelocal150',data={x:time,y:avelocal[*,150]}

tots = avelocal[*,30] + avelocal[*,50] + avelocal[*,75] + avelocal[*,150]
store_data,'2I_avelocaltots',data={x:time,y:tots}
tplot,['2I_avelocal','2I_avelocal30','2I_avelocal50','2I_avelocal75','2I_avelocal150','2I_avelocaltots']
;--------------------------------------------------


get_data,'rbspa_efw_esvy_mgse_vxb_removed',data=esvy
times = esvy.x




;Transform Bfield into MGSE
get_data,'rbspa_spinaxis_direction_gse',data=wsc
wsc_gse = reform(wsc.y[0,*])
rbsp_gse2mgse,'rbspa_emfisis_l3_1sec_gse_Mag',wsc_gse,newname='rbspa_emfisis_l3_1sec_mgse_Mag'
tinterpol_mxn,'rbspa_emfisis_l3_1sec_mgse_Mag',times,newname='rbspa_emfisis_l3_1sec_mgse_Mag'


get_data,'FESA',data=fesa
store_data,'fesa30',data={x:fesa.x,y:fesa.y[*,3]}
store_data,'fesa54',data={x:fesa.x,y:fesa.y[*,4]}
store_data,'fesa80',data={x:fesa.x,y:fesa.y[*,5]}
store_data,'fesa108',data={x:fesa.x,y:fesa.y[*,6]}
store_data,'fesa144',data={x:fesa.x,y:fesa.y[*,8]}

get_data,'FPSA',data=fpsa
store_data,'fpsa58',data={x:fpsa.x,y:fpsa.y[*,0]}
store_data,'fpsa70',data={x:fpsa.x,y:fpsa.y[*,1]}
store_data,'fpsa83',data={x:fpsa.x,y:fpsa.y[*,2]}
store_data,'fpsa99',data={x:fpsa.x,y:fpsa.y[*,3]}
store_data,'fpsa118',data={x:fpsa.x,y:fpsa.y[*,4]}



;**********************************************************************
;SET UP VARIABLES FOR CROSS-CORRELATION
;**********************************************************************

t0z = '2014-01-03/19:30'
t1z = '2014-01-03/21:50'


;----------
;Background field direction
rbsp_detrend,'rbspa_emfisis_l3_1sec_mgse_Mag',60.*0.168
copy_data,'rbspa_emfisis_l3_1sec_mgse_Mag_smoothed','rbspa_emfisis_l3_1sec_mgse_Mag_sp'
rbsp_detrend,'rbspa_emfisis_l3_1sec_mgse_Mag_sp',60.*20.
rbsp_downsample,'rbspa_emfisis_l3_1sec_mgse_Mag_sp_smoothed',1/2.

rbsp_detrend,'rbspa_emfisis_l3_1sec_mgse_Mag_sp',60.*20
tplot,['rbspa_emfisis_l3_1sec_mgse_Mag_sp','rbspa_emfisis_l3_1sec_mgse_Mag_sp_detrend']
rbsp_detrend,'rbspa_emfisis_l3_1sec_mgse_Mag_sp_detrend',60.*40.
tplot,['rbspa_emfisis_l3_1sec_mgse_Mag_sp_detrend','rbspa_emfisis_l3_1sec_mgse_Mag_sp_detrend_detrend']
store_data,'bcomb',data=['rbspa_emfisis_l3_1sec_mgse_Mag_sp_detrend','rbspa_emfisis_l3_1sec_mgse_Mag_sp_detrend_detrend']
options,'bcomb','colors',[0,250]
tplot,'bcomb'
fa = rbsp_rotate_field_2_vec('rbspa_emfisis_l3_1sec_mgse_Mag_sp_detrend_detrend','rbspa_emfisis_l3_1sec_mgse_Mag_sp_smoothed_DS')
tplot,'rbspa_emfisis_l3_1sec_mgse_Mag_sp_detrend_detrend_FA_minvar'
split_vec,'rbspa_emfisis_l3_1sec_mgse_Mag_sp_detrend_detrend'
;-----------
;Background field using GSEz
rbsp_detrend,'rbspa_emfisis_l3_1sec_gse_Mag',60.*0.168
copy_data,'rbspa_emfisis_l3_1sec_gse_Mag_smoothed','rbspa_emfisis_l3_1sec_gse_Mag_sp'
rbsp_detrend,'rbspa_emfisis_l3_1sec_gse_Mag_sp',60.*20.
tplot,['rbspa_emfisis_l3_1sec_gse_Mag_sp','rbspa_emfisis_l3_1sec_gse_Mag_sp_detrend']
rbsp_detrend,'rbspa_emfisis_l3_1sec_gse_Mag_sp_detrend',60.*50.
tplot,['rbspa_emfisis_l3_1sec_gse_Mag_sp','rbspa_emfisis_l3_1sec_gse_Mag_sp_detrend_detrend']
split_vec,'rbspa_emfisis_l3_1sec_gse_Mag_sp_detrend_detrend'
 
;----------
;Density
rbsp_detrend,'densitya',60.*0.168
copy_data,'densitya','densitya_sp'
tplot,['densitya','densitya_sp']
rbsp_detrend,'densitya_sp',60.*20.
tplot,['densitya_sp','densitya_sp_detrend']
rbsp_detrend,'densitya_sp_detrend',60.*40.
tplot,['densitya_sp_detrend','densitya_sp_detrend_detrend']
store_data,'dcomb',data=['densitya_sp_detrend','densitya_sp_detrend_detrend']
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
;Bfield hissinta
rbsp_detrend,'Bfield_hissinta',60.*0.168
copy_data,'Bfield_hissinta','Bfield_hissinta_sp'
tplot,['Bfield_hissinta','Bfield_hissinta_sp']
rbsp_detrend,'Bfield_hissinta_sp',60.*20.
tplot,['Bfield_hissinta_sp','Bfield_hissinta_sp_detrend']
rbsp_detrend,'Bfield_hissinta_sp_detrend',60.*40.
tplot,['Bfield_hissinta_sp_detrend','Bfield_hissinta_sp_detrend_detrend']
store_data,'hcomb',data=['Bfield_hissinta_sp_detrend','Bfield_hissinta_sp_detrend_detrend']
options,'hcomb','colors',[0,250]
tplot,'hcomb'
;----------
;Bfield hissintb
rbsp_detrend,'Bfield_hissintb',60.*0.168
copy_data,'Bfield_hissintb','Bfield_hissintb_sp'
tplot,['Bfield_hissintb','Bfield_hissintb_sp']
rbsp_detrend,'Bfield_hissintb_sp',60.*20.
tplot,['Bfield_hissintb_sp','Bfield_hissintb_sp_detrend']
rbsp_detrend,'Bfield_hissintb_sp_detrend',60.*40.
tplot,['Bfield_hissintb_sp_detrend','Bfield_hissintb_sp_detrend_detrend']
store_data,'hcomb',data=['Bfield_hissintb_sp_detrend','Bfield_hissintb_sp_detrend_detrend']
options,'hcomb','colors',[0,250]
tplot,'hcomb'
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
;------------
;bounce averaged diffusion coefficients 30 keV
rbsp_detrend,'2I_avebounce30',60.*20.
rbsp_detrend,'2I_avebounce50',60.*20.
rbsp_detrend,'2I_avebounce75',60.*20.
rbsp_detrend,'2I_avebounce150',60.*20.
rbsp_detrend,'2I_avebouncetots',60.*20.
;local diffusion
rbsp_detrend,'2I_avelocal30',60.*20.
rbsp_detrend,'2I_avelocal50',60.*20.
rbsp_detrend,'2I_avelocal75',60.*20.
rbsp_detrend,'2I_avelocal150',60.*20.
rbsp_detrend,'2I_avelocaltots',60.*20.



tplot_options,'title','products for correlation...12sec to 20min periods allowed'

ylim,'rbspa_emfisis_l3_1sec_mgse_Mag_sp_detrend_detrend_z',-4,4
tplot,['PeakDet_2I_sp_detrend_detrend','Bfield_hissinta_sp_detrend_detrend','densitya_sp_detrend_detrend','rbspa_emfisis_l3_1sec_mgse_Mag_sp_detrend_detrend_z','fesa30_sp_detrend','fesa54_sp_detrend','fesa80_sp_detrend','fesa108_sp_detrend','fesa144_sp_detrend']
tplot,['PeakDet_2I_sp_detrend_detrend','Bfield_hissinta_sp_detrend_detrend','densitya_sp_detrend_detrend','rbspa_emfisis_l3_1sec_mgse_Mag_sp_detrend_detrend_z','fesa30_sp_detrend','fesa54_sp_detrend']



;Run cross-correlations

tinterpol_mxn,'Bfield_hissinta_sp_detrend_detrend','PeakDet_2I_sp_detrend_detrend'
tinterpol_mxn,'Bfield_hissintb_sp_detrend_detrend','PeakDet_2I_sp_detrend_detrend'
tinterpol_mxn,'densitya_sp_detrend_detrend','PeakDet_2I_sp_detrend_detrend'
tinterpol_mxn,'rbspa_emfisis_l3_1sec_gse_Mag_sp_detrend_detrend_z','PeakDet_2I_sp_detrend_detrend'
tinterpol_mxn,'rbspa_emfisis_l3_1sec_mgse_Mag_sp_detrend_detrend_z','PeakDet_2I_sp_detrend_detrend'
tinterpol_mxn,'rbspa_emfisis_l3_1sec_mgse_Mag_sp_detrend_detrend_x','PeakDet_2I_sp_detrend_detrend'
tinterpol_mxn,'fesa30_sp_detrend','PeakDet_2I_sp_detrend_detrend'
tinterpol_mxn,'fesa54_sp_detrend','PeakDet_2I_sp_detrend_detrend'
tinterpol_mxn,'fesa80_sp_detrend','PeakDet_2I_sp_detrend_detrend'
tinterpol_mxn,'fesa108_sp_detrend','PeakDet_2I_sp_detrend_detrend'
tinterpol_mxn,'2I_avebounce30_detrend','PeakDet_2I_sp_detrend_detrend'
tinterpol_mxn,'2I_avebounce50_detrend','PeakDet_2I_sp_detrend_detrend'
tinterpol_mxn,'2I_avebounce75_detrend','PeakDet_2I_sp_detrend_detrend'
tinterpol_mxn,'2I_avebounce150_detrend','PeakDet_2I_sp_detrend_detrend'
tinterpol_mxn,'2I_avebouncetots_detrend','PeakDet_2I_sp_detrend_detrend'
tinterpol_mxn,'2I_avelocal30_detrend','PeakDet_2I_sp_detrend_detrend'
tinterpol_mxn,'2I_avelocal50_detrend','PeakDet_2I_sp_detrend_detrend'
tinterpol_mxn,'2I_avelocal75_detrend','PeakDet_2I_sp_detrend_detrend'
tinterpol_mxn,'2I_avelocal150_detrend','PeakDet_2I_sp_detrend_detrend'
tinterpol_mxn,'2I_avelocaltots_detrend','PeakDet_2I_sp_detrend_detrend'


T1='2014-01-03/19:00:00'	
T2='2014-01-03/22:00:00'	
;T1='2014-01-03/19:30:00'	
;T2='2014-01-03/21:00:00'	
tlimit,T1,T2
tplot,['PeakDet_2I_sp_detrend_detrend','Bfield_hissinta_sp_detrend_detrend',$
'Bfield_hissintb_sp_detrend_detrend',$
'densitya_sp_detrend_detrend','rbspa_emfisis_l3_1sec_gse_Mag_sp_detrend_detrend_z',$
'rbspa_emfisis_l3_1sec_mgse_Mag_sp_detrend_detrend_z',$
'rbspa_emfisis_l3_1sec_mgse_Mag_sp_detrend_detrend_x','fesa30_sp_detrend',$
'fesa54_sp_detrend','fesa80_sp_detrend','2I_avebouncetots_detrend'];,'fesa108_sp_detrend','fesa144_sp_detrend']


Results1=cross_spec_tplot('PeakDet_2I_sp_detrend_detrend',0,'Bfield_hissinta_sp_detrend_detrend_interp',0,T1,T2,sub_interval=3,overlap_index=4)
Results2=cross_spec_tplot('PeakDet_2I_sp_detrend_detrend',0,'densitya_sp_detrend_detrend_interp',0,T1,T2,sub_interval=3,overlap_index=4)
Results3=cross_spec_tplot('PeakDet_2I_sp_detrend_detrend',0,'rbspa_emfisis_l3_1sec_mgse_Mag_sp_detrend_detrend_z_interp',0,T1,T2,sub_interval=3,overlap_index=4)
Results4=cross_spec_tplot('PeakDet_2I_sp_detrend_detrend',0,'rbspa_emfisis_l3_1sec_mgse_Mag_sp_detrend_detrend_x_interp',0,T1,T2,sub_interval=3,overlap_index=4)
Results5=cross_spec_tplot('PeakDet_2I_sp_detrend_detrend',0,'fesa30_sp_detrend_interp',0,T1,T2,sub_interval=3,overlap_index=4)
Results6=cross_spec_tplot('PeakDet_2I_sp_detrend_detrend',0,'fesa54_sp_detrend_interp',0,T1,T2,sub_interval=3,overlap_index=4)
Results8=cross_spec_tplot('PeakDet_2I_sp_detrend_detrend',0,'fesa80_sp_detrend_interp',0,T1,T2,sub_interval=3,overlap_index=4)
Results9=cross_spec_tplot('PeakDet_2I_sp_detrend_detrend',0,'fesa108_sp_detrend_interp',0,T1,T2,sub_interval=3,overlap_index=4)
Results10=cross_spec_tplot('PeakDet_2I_sp_detrend_detrend',0,'rbspa_emfisis_l3_1sec_gse_Mag_sp_detrend_detrend_z',0,T1,T2,sub_interval=3,overlap_index=4)

Time_rbsp=strmid(T1,0,10)+'_'+strmid(T1,11,2)+strmid(T1,14,2)+'UT'+'_to_'+strmid(T2,0,10)+'_'+strmid(T2,11,2)+strmid(T2,14,2)+'UT'


;plot power spectra
!p.charsize = 1.8
!p.multi = [0,0,7]
Plot,Results1[*,0],Results1[*,3],xtitle='f, Hz', ytitle='Power precip (counts^2/Hz)',title=rbspx+time_rbsp,xrange=[0,0.01],yrange=[1d6,1d9],/ylog
oplot,[0.0013,0.0013],[1,10d9],thick=2
oplot,[0.0067,0.0067],[1,10d9],thick=2
Plot,Results1[*,0],Results1[*,4],xtitle='f, Hz', ytitle='Power hiss (nT^2/Hz)',xrange=[0,0.01],yrange=[1d2,1d5],/ylog
oplot,[0.0013,0.0013],[1,10d9],thick=2
oplot,[0.0067,0.0067],[1,10d9],thick=2
Plot,Results2[*,0],Results2[*,4],xtitle='f, Hz', ytitle='Power dens (dens^2/Hz)',xrange=[0,0.01],yrange=[1d2,1d6],/ylog
oplot,[0.0013,0.0013],[1,10d9],thick=2
oplot,[0.0067,0.0067],[1,10d9],thick=2
Plot,Results10[*,0],Results10[*,4],xtitle='f, Hz', ytitle='Power BzGSE (nT^2/Hz)',xrange=[0,0.01],yrange=[0,120]
oplot,[0.0013,0.0013],[0,10d9],thick=2
oplot,[0.0067,0.0067],[0,10d9],thick=2
Plot,Results3[*,0],Results3[*,4],xtitle='f, Hz', ytitle='Power Bz (nT^2/Hz)',xrange=[0,0.01],yrange=[0,120]
oplot,[0.0013,0.0013],[0,10d9],thick=2
oplot,[0.0067,0.0067],[0,10d9],thick=2
Plot,Results4[*,0],Results4[*,4],xtitle='f, Hz', ytitle='Power Bx (nT^2/Hz)',xrange=[0,0.01],yrange=[0,120]
oplot,[0.0013,0.0013],[0,10d9],thick=2
oplot,[0.0067,0.0067],[0,10d9],thick=2
Plot,Results5[*,0],Results5[*,4],xtitle='f, Hz', ytitle='Power FESA30 (counts^2/Hz)',xrange=[0,0.01],yrange=[1d6,1d10],/ylog
oplot,[0.0013,0.0013],[1,10d9],thick=2
oplot,[0.0067,0.0067],[1,10d9],thick=2


!p.multi = [0,0,2]
Plot,Results1[*,0],Results1[*,2],xtitle='f, Hz', ytitle='Coherence_Ey_Ez',title=rbspx+time_rbsp,xrange=[0,0.04],/nodata
oplot,[0.0013,0.0013],[0,1],thick=2
oplot,[0.0067,0.0067],[0,1],thick=2
oPlot,Results1[*,0],Results1[*,2],color=0	;precip and hiss  
oPlot,Results2[*,0],Results2[*,2],color=50  ;precip and dens
oPlot,Results10[*,0],Results10[*,2],color=80  ;precip and BzGSE
oPlot,Results3[*,0],Results3[*,2],color=100 ;precip and Bz
oPlot,Results4[*,0],Results4[*,2],color=150 ;precip and Bx
oPlot,Results5[*,0],Results5[*,2],color=200 ;precip and FESA30
oPlot,Results9[*,0],Results9[*,2],color=250 ;precip and FESA108

Plot,Results1[*,0],Results1[*,1]/!dtor,xtitle='f, Hz', ytitle='Phase_Ey_Ez',title=rbspx+time_rbsp,xrange=[0,0.04],yrange=[-180,180],ystyle=1,/nodata
oplot,[0.0013,0.0013],[-180,180],thick=2
oplot,[0.0067,0.0067],[-180,180],thick=2
oPlot,Results1[*,0],Results1[*,1]/!dtor,color=0	;precip and hiss  
oPlot,Results2[*,0],Results2[*,1]/!dtor,color=50  ;precip and dens
oPlot,Results10[*,0],Results10[*,1]/!dtor,color=50  ;precip and BzGSE
oPlot,Results3[*,0],Results3[*,1]/!dtor,color=100 ;precip and Bz
oPlot,Results4[*,0],Results4[*,1]/!dtor,color=150 ;precip and Bx
oPlot,Results5[*,0],Results5[*,1]/!dtor,color=200 ;precip and FESA30
oPlot,Results9[*,0],Results9[*,1]/!dtor,color=250 ;precip and FESA108







;window = length in seconds
;lag = seconds to slide window each time  
;coherence_time = larger than window length (2x window length)

window = 60.*30.
lag = window/4.
coherence_time = window*2.5
cormin = 0.7



v1 = 'PeakDet_2I_sp_detrend_detrend'
v2 = '2I_avebouncetots_detrend_interp'
dynamic_cross_spec_tplot,v1,0,v2,0,T1,T2,window,lag,coherence_time,new_name='Precip_diffusiontots'  
get_data,'Precip_diffusiontots_coherence',data=coh
get_data,'Precip_diffusiontots_phase',data=ph
goo = where(coh.y le cormin)
if goo[0] ne -1 then coh.y[goo] = !values.f_nan
if goo[0] ne -1 then ph.y[goo] = !values.f_nan
boo = where(finite(coh.y) eq 0)
if boo[0] ne -1 then ph.y[boo] = !values.f_nan
store_data,'Precip_diffusiontots_coherence',data=coh
store_data,'Precip_diffusiontots_phase',data=ph
options,'Precip_diffusiontots_coherence','ytitle','Precip vs bounceaveraged!CdiffusiontotskeV!CCoherence!Cfreq[Hz]'
options,'Precip_diffusiontots_phase','ytitle','Precip vs bounceaveraged!CdiffusiontotskeV!CPhase!Cfreq[Hz]'
ylim,['Precip_diffusiontots_coherence','Precip_diffusiontots_phase'],-0.001,0.01
tplot,['Precip_diffusiontots_coherence','Precip_diffusiontots_phase',v1,v2]
timebar,0.0013,varname='Precip_diffusiontots_coherence',/databar,thick=2
timebar,0.0067,varname='Precip_diffusiontots_coherence',/databar,thick=2
timebar,0.0013,varname='Precip_diffusiontots_phase',/databar,thick=2
timebar,0.0067,varname='Precip_diffusiontots_phase',/databar,thick=2



v1 = 'PeakDet_2I_sp_detrend_detrend'
v2 = '2I_avebounce30_detrend_interp'
dynamic_cross_spec_tplot,v1,0,v2,0,T1,T2,window,lag,coherence_time,new_name='Precip_diffusion30'  
get_data,'Precip_diffusion30_coherence',data=coh
get_data,'Precip_diffusion30_phase',data=ph
goo = where(coh.y le cormin)
if goo[0] ne -1 then coh.y[goo] = !values.f_nan
if goo[0] ne -1 then ph.y[goo] = !values.f_nan
boo = where(finite(coh.y) eq 0)
if boo[0] ne -1 then ph.y[boo] = !values.f_nan
store_data,'Precip_diffusion30_coherence',data=coh
store_data,'Precip_diffusion30_phase',data=ph
options,'Precip_diffusion30_coherence','ytitle','Precip vs bounceaverageddiffusion30keV!CCoherence!Cfreq[Hz]'
options,'Precip_diffusion30_phase','ytitle','Precip vs bounceaverageddiffusion30keV!CPhase!Cfreq[Hz]'
ylim,['Precip_diffusion30_coherence','Precip_diffusion30_phase'],-0.001,0.01
tplot,['Precip_diffusion30_coherence','Precip_diffusion30_phase',v1,v2]
timebar,0.0013,varname='Precip_diffusion30_coherence',/databar,thick=2
timebar,0.0067,varname='Precip_diffusion30_coherence',/databar,thick=2
timebar,0.0013,varname='Precip_diffusion30_phase',/databar,thick=2
timebar,0.0067,varname='Precip_diffusion30_phase',/databar,thick=2


v1 = 'PeakDet_2I_sp_detrend_detrend'
v2 = 'Bfield_hissinta_sp_detrend_detrend_interp'
dynamic_cross_spec_tplot,v1,0,v2,0,T1,T2,window,lag,coherence_time,new_name='Precip_hissa'  
get_data,'Precip_hissa_coherence',data=coh
get_data,'Precip_hissa_phase',data=ph
goo = where(coh.y le cormin)
if goo[0] ne -1 then coh.y[goo] = !values.f_nan
if goo[0] ne -1 then ph.y[goo] = !values.f_nan
boo = where(finite(coh.y) eq 0)
if boo[0] ne -1 then ph.y[boo] = !values.f_nan
store_data,'Precip_hissa_coherence',data=coh
store_data,'Precip_hissa_phase',data=ph
options,'Precip_hissa_coherence','ytitle','Precip vs hiss!CCoherence!Cfreq[Hz]'
options,'Precip_hissa_phase','ytitle','Precip vs hiss!CPhase!Cfreq[Hz]'
ylim,['Precip_hissa_coherence','Precip_hissa_phase'],-0.001,0.01
tplot,['Precip_hissa_coherence','Precip_hissa_phase',v1,v2]
timebar,0.0013,varname='Precip_hissa_coherence',/databar,thick=2
timebar,0.0067,varname='Precip_hissa_coherence',/databar,thick=2
timebar,0.0013,varname='Precip_hissa_phase',/databar,thick=2
timebar,0.0067,varname='Precip_hissa_phase',/databar,thick=2

v1 = 'PeakDet_2I_sp_detrend_detrend'
v2 = 'Bfield_hissintb_sp_detrend_detrend_interp'
dynamic_cross_spec_tplot,v1,0,v2,0,T1,T2,window,lag,coherence_time,new_name='Precip_hissb'  
get_data,'Precip_hissb_coherence',data=coh
get_data,'Precip_hissb_phase',data=ph
goo = where(coh.y le cormin)
if goo[0] ne -1 then coh.y[goo] = !values.f_nan
if goo[0] ne -1 then ph.y[goo] = !values.f_nan
boo = where(finite(coh.y) eq 0)
if boo[0] ne -1 then ph.y[boo] = !values.f_nan
store_data,'Precip_hissb_coherence',data=coh
store_data,'Precip_hissb_phase',data=ph
options,'Precip_hissb_coherence','ytitle','Precip vs hiss!CCoherence!Cfreq[Hz]'
options,'Precip_hissb_phase','ytitle','Precip vs hiss!CPhase!Cfreq[Hz]'
ylim,['Precip_hissb_coherence','Precip_hissb_phase'],-0.001,0.01
tplot,['Precip_hissb_coherence','Precip_hissb_phase',v1,v2]
timebar,0.0013,varname='Precip_hissb_coherence',/databar,thick=2
timebar,0.0067,varname='Precip_hissb_coherence',/databar,thick=2
timebar,0.0013,varname='Precip_hissb_phase',/databar,thick=2
timebar,0.0067,varname='Precip_hissb_phase',/databar,thick=2



v2 = 'densitya_sp_detrend_detrend_interp'
dynamic_cross_spec_tplot,v1,0,v2,0,T1,T2,window,lag,coherence_time,new_name='Precip_dens'  
get_data,'Precip_dens_coherence',data=coh
get_data,'Precip_dens_phase',data=ph
goo = where(coh.y le cormin)
if goo[0] ne -1 then coh.y[goo] = !values.f_nan
if goo[0] ne -1 then ph.y[goo] = !values.f_nan
boo = where(finite(coh.y) eq 0)
if boo[0] ne -1 then ph.y[boo] = !values.f_nan
store_data,'Precip_dens_coherence',data=coh
store_data,'Precip_dens_phase',data=ph
options,'Precip_dens_coherence','ytitle','Precip vs dens!CCoherence!Cfreq[Hz]'
options,'Precip_dens_phase','ytitle','Precip vs dens!CPhase!Cfreq[Hz]'
ylim,['Precip_dens_coherence','Precip_dens_phase'],-0.001,0.01
tplot,['Precip_dens_coherence','Precip_dens_phase',v1,v2]
timebar,0.0013,varname='Precip_dens_coherence',/databar,thick=2
timebar,0.0067,varname='Precip_dens_coherence',/databar,thick=2
timebar,0.0013,varname='Precip_dens_phase',/databar,thick=2
timebar,0.0067,varname='Precip_dens_phase',/databar,thick=2


v2 = 'rbspa_emfisis_l3_1sec_mgse_Mag_sp_detrend_detrend_z_interp'
dynamic_cross_spec_tplot,v1,0,v2,0,T1,T2,window,lag,coherence_time,new_name='Precip_BzFA'  
get_data,'Precip_BzFA_coherence',data=coh
get_data,'Precip_BzFA_phase',data=ph
goo = where(coh.y le cormin)
if goo[0] ne -1 then coh.y[goo] = !values.f_nan
if goo[0] ne -1 then ph.y[goo] = !values.f_nan
boo = where(finite(coh.y) eq 0)
if boo[0] ne -1 then ph.y[boo] = !values.f_nan
store_data,'Precip_BzFA_coherence',data=coh
store_data,'Precip_BzFA_phase',data=ph
options,'Precip_BzFA_coherence','ytitle','Precip vs BzFA!CCoherence!Cfreq[Hz]'
options,'Precip_BzFA_phase','ytitle','Precip vs BzFA!CPhase!Cfreq[Hz]'
ylim,['Precip_BzFA_coherence','Precip_BzFA_phase'],-0.001,0.01
tplot,['Precip_BzFA_coherence','Precip_BzFA_phase',v1,v2]
timebar,0.0013,varname='Precip_BzFA_coherence',/databar,thick=2
timebar,0.0067,varname='Precip_BzFA_coherence',/databar,thick=2
timebar,0.0013,varname='Precip_BzFA_phase',/databar,thick=2
timebar,0.0067,varname='Precip_BzFA_phase',/databar,thick=2


v2 = 'rbspa_emfisis_l3_1sec_mgse_Mag_sp_detrend_detrend_x_interp'
dynamic_cross_spec_tplot,v1,0,v2,0,T1,T2,window,lag,coherence_time,new_name='Precip_BxFA'  
get_data,'Precip_BxFA_coherence',data=coh
get_data,'Precip_BxFA_phase',data=ph
goo = where(coh.y le cormin)
if goo[0] ne -1 then coh.y[goo] = !values.f_nan
if goo[0] ne -1 then ph.y[goo] = !values.f_nan
boo = where(finite(coh.y) eq 0)
if boo[0] ne -1 then ph.y[boo] = !values.f_nan
store_data,'Precip_BxFA_coherence',data=coh
store_data,'Precip_BxFA_phase',data=ph
options,'Precip_BxFA_coherence','ytitle','Precip vs BxFA!CCoherence!Cfreq[Hz]'
options,'Precip_BxFA_phase','ytitle','Precip vs BxFA!CPhase!Cfreq[Hz]'
ylim,['Precip_BxFA_coherence','Precip_BxFA_phase'],-0.001,0.01
tplot,['Precip_BxFA_coherence','Precip_BxFA_phase',v1,v2]
timebar,0.0013,varname='Precip_BxFA_coherence',/databar,thick=2
timebar,0.0067,varname='Precip_BxFA_coherence',/databar,thick=2
timebar,0.0013,varname='Precip_BxFA_phase',/databar,thick=2
timebar,0.0067,varname='Precip_BxFA_phase',/databar,thick=2


v2 = 'rbspa_emfisis_l3_1sec_gse_Mag_sp_detrend_detrend_z'
dynamic_cross_spec_tplot,v1,0,v2,0,T1,T2,window,lag,coherence_time,new_name='Precip_BzGSE'  
get_data,'Precip_BzGSE_coherence',data=coh
get_data,'Precip_BzGSE_phase',data=ph
goo = where(coh.y le cormin)
if goo[0] ne -1 then coh.y[goo] = !values.f_nan
if goo[0] ne -1 then ph.y[goo] = !values.f_nan
boo = where(finite(coh.y) eq 0)
if boo[0] ne -1 then ph.y[boo] = !values.f_nan
store_data,'Precip_BzGSE_coherence',data=coh
store_data,'Precip_BzGSE_phase',data=ph
options,'Precip_BzGSE_coherence','ytitle','Precip vs BzGSE!CCoherence!Cfreq[Hz]'
options,'Precip_BzGSE_phase','ytitle','Precip vs BzGSE!CPhase!Cfreq[Hz]'
ylim,['Precip_BzGSE_coherence','Precip_BzGSE_phase'],-0.001,0.01
tplot,['Precip_BzGSE_coherence','Precip_BzGSE_phase',v1,v2]
timebar,0.0013,varname='Precip_BzGSE_coherence',/databar,thick=2
timebar,0.0067,varname='Precip_BzGSE_coherence',/databar,thick=2
timebar,0.0013,varname='Precip_BzGSE_phase',/databar,thick=2
timebar,0.0067,varname='Precip_BzGSE_phase',/databar,thick=2


v2 = 'fesa30_sp_detrend_interp'
dynamic_cross_spec_tplot,v1,0,v2,0,T1,T2,window,lag,coherence_time,new_name='Precip_fesa30'  
get_data,'Precip_fesa30_coherence',data=coh
get_data,'Precip_fesa30_phase',data=ph
goo = where(coh.y le cormin)
if goo[0] ne -1 then coh.y[goo] = !values.f_nan
if goo[0] ne -1 then ph.y[goo] = !values.f_nan
boo = where(finite(coh.y) eq 0)
if boo[0] ne -1 then ph.y[boo] = !values.f_nan
store_data,'Precip_fesa30_coherence',data=coh
store_data,'Precip_fesa30_phase',data=ph
options,'Precip_fesa30_coherence','ytitle','Precip vs FESA30!CCoherence!Cfreq[Hz]'
options,'Precip_fesa30_phase','ytitle','Precip vs FESA30!CPhase!Cfreq[Hz]'
ylim,['Precip_fesa30_coherence','Precip_fesa30_phase'],-0.001,0.01
tplot,['Precip_fesa30_coherence','Precip_fesa30_phase',v1,v2]
timebar,0.0013,varname='Precip_fesa30_coherence',/databar,thick=2
timebar,0.0067,varname='Precip_fesa30_coherence',/databar,thick=2
timebar,0.0013,varname='Precip_fesa30_phase',/databar,thick=2
timebar,0.0067,varname='Precip_fesa30_phase',/databar,thick=2



v2 = 'fesa54_sp_detrend_interp'
dynamic_cross_spec_tplot,v1,0,v2,0,T1,T2,window,lag,coherence_time,new_name='Precip_fesa54'  
get_data,'Precip_fesa54_coherence',data=coh
get_data,'Precip_fesa54_phase',data=ph
goo = where(coh.y le cormin)
if goo[0] ne -1 then coh.y[goo] = !values.f_nan
if goo[0] ne -1 then ph.y[goo] = !values.f_nan
boo = where(finite(coh.y) eq 0)
if boo[0] ne -1 then ph.y[boo] = !values.f_nan
store_data,'Precip_fesa54_coherence',data=coh
store_data,'Precip_fesa54_phase',data=ph
options,'Precip_fesa54_coherence','ytitle','Precip vs FESA54!CCoherence!Cfreq[Hz]'
options,'Precip_fesa54_phase','ytitle','Precip vs FESA54!CPhase!Cfreq[Hz]'
ylim,['Precip_fesa54_coherence','Precip_fesa54_phase'],-0.001,0.01
tplot,['Precip_fesa54_coherence','Precip_fesa54_phase',v1,v2]
timebar,0.0013,varname='Precip_fesa54_coherence',/databar,thick=2
timebar,0.0067,varname='Precip_fesa54_coherence',/databar,thick=2
timebar,0.0013,varname='Precip_fesa54_phase',/databar,thick=2
timebar,0.0067,varname='Precip_fesa54_phase',/databar,thick=2

v2 = 'fesa80_sp_detrend_interp'
dynamic_cross_spec_tplot,v1,0,v2,0,T1,T2,window,lag,coherence_time,new_name='Precip_fesa80'  
get_data,'Precip_fesa80_coherence',data=coh
get_data,'Precip_fesa80_phase',data=ph
goo = where(coh.y le cormin)
if goo[0] ne -1 then coh.y[goo] = !values.f_nan
if goo[0] ne -1 then ph.y[goo] = !values.f_nan
boo = where(finite(coh.y) eq 0)
if boo[0] ne -1 then ph.y[boo] = !values.f_nan
store_data,'Precip_fesa80_coherence',data=coh
store_data,'Precip_fesa80_phase',data=ph
options,'Precip_fesa80_coherence','ytitle','Precip vs FESA80!CCoherence!Cfreq[Hz]'
options,'Precip_fesa80_phase','ytitle','Precip vs FESA80!CPhase!Cfreq[Hz]'
ylim,['Precip_fesa80_coherence','Precip_fesa80_phase'],-0.001,0.01
tplot,['Precip_fesa80_coherence','Precip_fesa80_phase',v1,v2]
timebar,0.0013,varname='Precip_fesa80_coherence',/databar,thick=2
timebar,0.0067,varname='Precip_fesa80_coherence',/databar,thick=2
timebar,0.0013,varname='Precip_fesa80_phase',/databar,thick=2
timebar,0.0067,varname='Precip_fesa80_phase',/databar,thick=2


v2 = 'fesa108_sp_detrend_interp'
dynamic_cross_spec_tplot,v1,0,v2,0,T1,T2,window,lag,coherence_time,new_name='Precip_fesa108'  
get_data,'Precip_fesa108_coherence',data=coh
get_data,'Precip_fesa108_phase',data=ph
goo = where(coh.y le cormin)
if goo[0] ne -1 then coh.y[goo] = !values.f_nan
if goo[0] ne -1 then ph.y[goo] = !values.f_nan
boo = where(finite(coh.y) eq 0)
if boo[0] ne -1 then ph.y[boo] = !values.f_nan
store_data,'Precip_fesa108_coherence',data=coh
store_data,'Precip_fesa108_phase',data=ph
options,'Precip_fesa108_coherence','ytitle','Precip vs FESA108!CCoherence!Cfreq[Hz]'
options,'Precip_fesa108_phase','ytitle','Precip vs FESA108!CPhase!Cfreq[Hz]'
ylim,['Precip_fesa108_coherence','Precip_fesa108_phase'],-0.001,0.01
tplot,['Precip_fesa108_coherence','Precip_fesa108_phase',v1,v2]
timebar,0.0013,varname='Precip_fesa108_coherence',/databar,thick=2
timebar,0.0067,varname='Precip_fesa108_coherence',/databar,thick=2
timebar,0.0013,varname='Precip_fesa108_phase',/databar,thick=2
timebar,0.0067,varname='Precip_fesa108_phase',/databar,thick=2




ylim,['Precip_hissa_coherence','Precip_hissb_coherence'],0,0.01,0
zlim,'*_coherence*',0.6,1
tplot,['Precip_hissa_coherence','Precip_hissb_coherence','Precip_diffusiontots_coherence','Precip_dens_coherence','Precip_BzFA_coherence','Precip_BxFA_coherence','Precip_fesa30_coherence',v1]
timebar,0.0013,varname='Precip_hissa_coherence',/databar,thick=2
timebar,0.0067,varname='Precip_hissa_coherence',/databar,thick=2
timebar,0.0013,varname='Precip_hissb_coherence',/databar,thick=2
timebar,0.0067,varname='Precip_hissb_coherence',/databar,thick=2
timebar,0.0013,varname='Precip_diffusiontots_coherence',/databar,thick=2
timebar,0.0067,varname='Precip_diffusiontots_coherence',/databar,thick=2
;timebar,0.0013,varname='Precip_diffusion30_coherence',/databar,thick=2
;timebar,0.005,varname='Precip_diffusion30_coherence',/databar,thick=2
timebar,0.0013,varname='Precip_dens_coherence',/databar,thick=2
timebar,0.0067,varname='Precip_dens_coherence',/databar,thick=2
timebar,0.0013,varname='Precip_BzFA_coherence',/databar,thick=2
timebar,0.0067,varname='Precip_BzFA_coherence',/databar,thick=2
timebar,0.0013,varname='Precip_BxFA_coherence',/databar,thick=2
timebar,0.0067,varname='Precip_BxFA_coherence',/databar,thick=2
timebar,0.0013,varname='Precip_fesa30_coherence',/databar,thick=2
timebar,0.0067,varname='Precip_fesa30_coherence',/databar,thick=2




;zlim,'*_coherence*',0.5,1
tplot,['Precip_hiss_phase','Precip_dens_phase','Precip_BzFA_phase','Precip_BxFA_phase','Precip_fesa30_phase',v1]
timebar,0.0013,varname='Precip_hiss_phase',/databar,thick=2
timebar,0.0067,varname='Precip_hiss_phase',/databar,thick=2
timebar,0.0013,varname='Precip_dens_phase',/databar,thick=2
timebar,0.0067,varname='Precip_dens_phase',/databar,thick=2
timebar,0.0013,varname='Precip_BzFA_phase',/databar,thick=2
timebar,0.0067,varname='Precip_BzFA_phase',/databar,thick=2
timebar,0.0013,varname='Precip_BxFA_phase',/databar,thick=2
timebar,0.0067,varname='Precip_BxFA_phase',/databar,thick=2
timebar,0.0013,varname='Precip_fesa30_phase',/databar,thick=2
timebar,0.0067,varname='Precip_fesa30_phase',/databar,thick=2










;*****************************************************
;FIND CORRELATION LENGTH FOR HISS ON JAN 3
;*****************************************************


T1='2014-01-03/18:00:00'	
T2='2014-01-03/23:00:00'	


;window = length in seconds
;lag = seconds to slide window each time  
;coherence_time = larger than window length (2x window length)

window = 60.*30.
lag = window/4.
coherence_time = window*2.5
cormin = 0.4

v1 = 'Bfield_hissinta'
v2 = 'Bfield_hissintb'
dynamic_cross_spec_tplot,v1,0,v2,0,T1,T2,window,lag,coherence_time,new_name='hissa_hissb'
get_data,'hissa_hissb_coherence',data=coh
get_data,'hissa_hissb_phase',data=ph
goo = where(coh.y le cormin)
if goo[0] ne -1 then coh.y[goo] = !values.f_nan
if goo[0] ne -1 then ph.y[goo] = !values.f_nan
boo = where(finite(coh.y) eq 0)
if boo[0] ne -1 then ph.y[boo] = !values.f_nan
store_data,'hissa_hissb_coherence',data=coh
store_data,'hissa_hissb_phase',data=ph
options,'hissa_hissb_coherence','ytitle','Precip vs hiss!CCoherence!Cfreq[Hz]'
options,'hissa_hissb_phase','ytitle','Precip vs hiss!CPhase!Cfreq[Hz]'
ylim,['hissa_hissb_coherence','hissa_hissb_phase'],-0.001,0.01
tplot,['hissa_hissb_coherence','hissa_hissb_phase',v1,v2,'rbsp_state_sc_sep','rbsp_state_mlt_diff','rbsp_state_lshell_diff']
timebar,0.0013,varname='hissa_hissb_coherence',/databar,thick=2
timebar,0.0075,varname='hissa_hissb_coherence',/databar,thick=2
timebar,0.0067,varname='hissa_hissb_coherence',/databar,thick=2
timebar,0.0013,varname='hissa_hissb_phase',/databar,thick=2
timebar,0.0075,varname='hissa_hissb_phase',/databar,thick=2
timebar,0.0067,varname='hissa_hissb_phase',/databar,thick=2


;Total up the hiss coherence for each time
;****REMOVE DATA THAT ARE NOT HISS
;****
get_data,'hissa_hissb_coherence',data=hisscoh
hctot = fltarr(n_elements(hisscoh.x))

for i=0,n_elements(hisscoh.x)-1 do hctot[i] = total(hisscoh.y[i,*],/nan)
hctot = hctot/max(hctot,/nan)
store_data,'hctot',data={x:hisscoh.x,y:hctot}
;hiss_3min = hisscoh.y[*,9]
;hiss_3min = hisscoh.y[*,9]
;store_data,'hc3min',data={x:hisscoh.x,y:hiss_3min}


;ylim,'hc3min',0.5,1,1
;tplot,['hctot','hc3min','hissa_hissb_coherence','hissa_hissb_phase',v1,v2,'rbsp_state_sc_sep','rbsp_state_mlt_diff','rbsp_state_lshell_diff']

tinterpol_mxn,'rbsp_state_sc_sep','hctot'
tinterpol_mxn,'rbsp_state_lshell_diff','hctot'
;tinterpol_mxn,'Bfield_hissinta','hctot'
get_data,'rbsp_state_sc_sep_interp',data=sep
get_data,'rbsp_state_lshell_diff',data=dl

store_data,'rbsp_state_sc_sep_re',data={x:sep.x,y:1000.*sep.y/6370.}
tplot,'rbsp_state_sc_sep_re'


;get_data,'Bfield_hissinta_interp',data=hia


;Reduce to times of interest
tt0 = time_double('2014-01-03/18:00')
tt1 = time_double('2014-01-03/23:00')
goo = where((hisscoh.x ge tt0) and (hisscoh.x le tt1))


yv = tsample('Bfield_hissinta',[tt0,tt1],times=tms)
store_data,'Bfield_hissinta_reduced',data={x:tms,y:yv}
tinterpol_mxn,'Bfield_hissinta_reduced','hctot'
get_data,'Bfield_hissinta_reduced_interp',data=bi

;Wave periods
periods = 1/hisscoh.v[0:20]/60.


zlim,['dynamic_FFT_1','dynamic_FFT_2'],1d-2,1d0,1
ylim,['dynamic_FFT_1','dynamic_FFT_2'],-0.001,0.01,0
tplot,['dynamic_FFT_1','Bfield_hissinta','dynamic_FFT_2','Bfield_hissintb']
timebar,0.0075,varname='dynamic_FFT_1',/databar,thick=2
timebar,0.0055,varname='dynamic_FFT_1',/databar,thick=2
timebar,0.0075,varname='dynamic_FFT_2',/databar,thick=2
timebar,0.0055,varname='dynamic_FFT_2',/databar,thick=2

get_data,'dynamic_FFT_1',data=ffta
get_data,'dynamic_FFT_2',data=fftb


;twavpol,'Bfield_hissinta',nopfft=nfft,steplength=sl
;freqspec = 1/sp.v/60.


!p.multi = [0,0,3]
;PLOT COHERENCE FOR SELECT FREQUENCIES ON JAN 3rd
plot,1000.*sep.y[goo]/6370.,hisscoh.y[goo,9],xtitle='SC separation (RE)',ytitle='Coherence',$
	title='Coherence length of hiss b/t RBSP-A and RBSP-B!CBlack=15min,Red=3.33min,Green=1.5min waves',/nodata
;oplot,1000.*sep.y[goo]/6370.,hisscoh.y[goo,1],psym=4,color=0 ;30 min
oplot,1000.*sep.y[goo]/6370.,hisscoh.y[goo,2],psym=0,color=0 ;15 min
oplot,1000.*sep.y[goo]/6370.,hisscoh.y[goo,3],psym=0,color=250 ;10 min
;oplot,1000.*sep.y[goo]/6370.,hisscoh.y[goo,4],psym=4 ;7.5 min
oplot,1000.*sep.y[goo]/6370.,hisscoh.y[goo,5],psym=0,color=150 ;6 min
;oplot,1000.*sep.y[goo]/6370.,hisscoh.y[goo,6],psym=4 ;5 min
;oplot,1000.*sep.y[goo]/6370.,hisscoh.y[goo,7],psym=4,color=100 ;4.3 min
;oplot,1000.*sep.y[goo]/6370.,hisscoh.y[goo,8],psym=0,color=200 ;3.75 min
;oplot,1000.*sep.y[goo]/6370.,hisscoh.y[goo,9],psym=0,color=250 ;3.33 min
;oplot,1000.*sep.y[goo]/6370.,hisscoh.y[goo,10],psym=4,color=175 ;3 min
;oplot,1000.*sep.y[goo]/6370.,hisscoh.y[goo,11],psym=4 ;2.7 min
oplot,1000.*sep.y[goo]/6370.,hisscoh.y[goo,12],psym=0,color=100 ;2.5 min
;oplot,1000.*sep.y[goo]/6370.,hisscoh.y[goo,20],psym=4,color=150 ;1.5 min
;oplot,1000.*sep.y[goo]/6370.,hisscoh.y[goo,19],psym=4,color=220 ;1.57 min
;oplot,1000.*sep.y[goo]/6370.,hisscoh.y[goo,18],psym=4,color=240 ;1.67 min
;oplot,1000.*sep.y[goo]/6370.,hisscoh.y[goo,15],psym=0,color=250 ;2 min
;oplot,1000.*sep.y[goo]/6370.,hisscoh.y[goo,17],psym=4 ;1.76 min
;oplot,1000.*sep.y[goo]/6370.,hisscoh.y[goo,16],psym=4 ;1.87 min
;oplot,1000.*sep.y[goo]/6370.,hisscoh.y[goo,14],psym=0 ;2.14 min


;PLOT POWER FOR SELECT FREQUENCIES ON JAN 3rd
plot,1000.*sep.y[goo]/6370.,1000.*ffta.y[goo,9],xtitle='SC separation (RE)',ytitle='PowerFFT',$
	title='Integrated Hiss power (pT) on RBSP-A',/nodata,yrange=[1.,1000.],/ylog
oplot,1000.*sep.y[goo]/6370.,sqrt(abs(1000.*ffta.y[goo,2])),psym=0,color=0 ;15 min
oplot,1000.*sep.y[goo]/6370.,sqrt(abs(1000.*ffta.y[goo,3])),psym=0,color=250 ;10 min
oplot,1000.*sep.y[goo]/6370.,sqrt(abs(1000.*ffta.y[goo,5])),psym=0,color=150 ;6 min
oplot,1000.*sep.y[goo]/6370.,sqrt(abs(1000.*ffta.y[goo,12])),psym=0,color=100 ;2.5 min
plot,1000.*sep.y[goo]/6370.,fftb.y[goo,9],xtitle='SC separation (RE)',ytitle='PowerFFT',$
	title='IntegratedHiss power (pT) on RBSP-B',/nodata,yrange=[1.,1000.],/ylog
oplot,1000.*sep.y[goo]/6370.,sqrt(abs(1000.*fftb.y[goo,2])),psym=0,color=0 ;15 min
oplot,1000.*sep.y[goo]/6370.,sqrt(abs(1000.*fftb.y[goo,3])),psym=0,color=250 ;10 min
oplot,1000.*sep.y[goo]/6370.,sqrt(abs(1000.*fftb.y[goo,5])),psym=0,color=150 ;6 min
oplot,1000.*sep.y[goo]/6370.,sqrt(abs(1000.*fftb.y[goo,12])),psym=0,color=100 ;2.5 min

;end jan3
;-----------------------------------------------------------





!p.multi = [0,0,3]
;PLOT COHERENCE FOR SELECT FREQUENCIES
ae = 12
print,periods[ae]
plot,1000.*sep.y[goo]/6370.,hisscoh.y[goo,ae],xtitle='SC separation (RE)',ytitle='Coherence',$
	title='Coherence length of hiss b/t RBSP-A and RBSP-B for '+strtrim(periods[ae],2)+' min period waves',yrange=[0,1]
plot,1000.*sep.y[goo]/6370.,sqrt(abs(1000.*ffta.y[goo,ae])),xtitle='SC separation (RE)',ytitle='PowerFFT',$
	title='Integrated Hiss power (pT) on RBSP-A for '+strtrim(periods[ae],2)+' min period waves',yrange=[1.,100.],/ylog
plot,1000.*sep.y[goo]/6370.,sqrt(abs(1000.*fftb.y[goo,ae])),xtitle='SC separation (RE)',ytitle='PowerFFT',$
	title='IntegratedHiss power (pT) on RBSP-B for '+strtrim(periods[ae],2)+' min period waves',yrange=[1.,100.],/ylog

!p.multi = [0,0,3]
ae = 3
print,periods[ae]
plot,1000.*sep.y[goo]/6370.,hisscoh.y[goo,ae],xtitle='SC separation (RE)',ytitle='Coherence',$
	title='Coherence length of hiss b/t RBSP-A and RBSP-B for '+strtrim(periods[ae],2)+' min period waves',yrange=[0,1]
plot,1000.*sep.y[goo]/6370.,sqrt(abs(1000.*ffta.y[goo,ae])),xtitle='SC separation (RE)',ytitle='PowerFFT',$
	title='Integrated Hiss power (pT) on RBSP-A for '+strtrim(periods[ae],2)+' min period waves',yrange=[1.,100.],/ylog
plot,1000.*sep.y[goo]/6370.,sqrt(abs(1000.*fftb.y[goo,ae])),xtitle='SC separation (RE)',ytitle='PowerFFT',$
	title='IntegratedHiss power (pT) on RBSP-B for '+strtrim(periods[ae],2)+' min period waves',yrange=[1.,100.],/ylog

!p.multi = [0,0,3]
ae = 5
print,periods[ae]
plot,1000.*sep.y[goo]/6370.,hisscoh.y[goo,ae],xtitle='SC separation (RE)',ytitle='Coherence',$
	title='Coherence length of hiss b/t RBSP-A and RBSP-B for '+strtrim(periods[ae],2)+' min period waves',yrange=[0,1]
plot,1000.*sep.y[goo]/6370.,sqrt(abs(1000.*ffta.y[goo,ae])),xtitle='SC separation (RE)',ytitle='PowerFFT',$
	title='Integrated Hiss power (pT) on RBSP-A for '+strtrim(periods[ae],2)+' min period waves',yrange=[1.,100.],/ylog
plot,1000.*sep.y[goo]/6370.,sqrt(abs(1000.*fftb.y[goo,ae])),xtitle='SC separation (RE)',ytitle='PowerFFT',$
	title='IntegratedHiss power (pT) on RBSP-B for '+strtrim(periods[ae],2)+' min period waves',yrange=[1.,100.],/ylog

!p.multi = [0,0,3]
;These are the 3min waves at 2000
ae = 10
print,periods[ae]
plot,1000.*sep.y[goo]/6370.,hisscoh.y[goo,ae],xtitle='SC separation (RE)',ytitle='Coherence',$
	title='Coherence length of hiss b/t RBSP-A and RBSP-B for '+strtrim(periods[ae],2)+' min period waves',yrange=[0,1]
plot,1000.*sep.y[goo]/6370.,sqrt(abs(1000.*ffta.y[goo,ae])),xtitle='SC separation (RE)',ytitle='PowerFFT',$
	title='Integrated Hiss power (pT) on RBSP-A for '+strtrim(periods[ae],2)+' min period waves',yrange=[1.,100.],/ylog
plot,1000.*sep.y[goo]/6370.,sqrt(abs(1000.*fftb.y[goo,ae])),xtitle='SC separation (RE)',ytitle='PowerFFT',$
	title='IntegratedHiss power (pT) on RBSP-B for '+strtrim(periods[ae],2)+' min period waves',yrange=[1.,100.],/ylog

!p.multi = [0,0,3]
;These are the 2min waves at 2000
ae = 14
print,periods[ae]
plot,1000.*sep.y[goo]/6370.,hisscoh.y[goo,ae],xtitle='SC separation (RE)',ytitle='Coherence',$
	title='Coherence length of hiss b/t RBSP-A and RBSP-B for '+strtrim(periods[ae],2)+' min period waves',yrange=[0,1]
plot,1000.*sep.y[goo]/6370.,sqrt(abs(1000.*ffta.y[goo,ae])),xtitle='SC separation (RE)',ytitle='PowerFFT',$
	title='Integrated Hiss power (pT) on RBSP-A for '+strtrim(periods[ae],2)+' min period waves',yrange=[1.,100.],/ylog
plot,1000.*sep.y[goo]/6370.,sqrt(abs(1000.*fftb.y[goo,ae])),xtitle='SC separation (RE)',ytitle='PowerFFT',$
	title='IntegratedHiss power (pT) on RBSP-B for '+strtrim(periods[ae],2)+' min period waves',yrange=[1.,100.],/ylog











;*******************************************************
;MAKE A GEOGRAPHICAL PLOT OF THE HISS SIZE CORRELATION
;*******************************************************


;Extend the correlation analysis time for the hiss

;The peak power near 2-3 min fluctuations is somewhere b/t
; 2.38, 2.48, 2.65 min periods. Corresponds to array elements
;11, 12 or 13. 

;T1='2014-01-03/13:00:00'	
;T2='2014-01-03/24:00:00'	
T1='2014-01-03/14:00:00'	
T2='2014-01-03/23:00:00'	
;T1='2014-01-03/20:00:00'	
;T2='2014-01-03/22:00:00'	


rad=findgen(101)
rad=rad*2*!pi/100.0
lval=findgen(7)
lval=lval+3.0
lshell1x=1.0*cos(rad)
lshell1y=1.0*sin(rad)
lshell3x=lval(0)*cos(rad)
lshell3y=lval(0)*sin(rad)
lshell5x=lval(2)*cos(rad)
lshell5y=lval(2)*sin(rad)
lshell7x=lval(4)*cos(rad)
lshell7y=lval(4)*sin(rad)
lshell9x=lval(6)*cos(rad)
lshell9y=lval(6)*sin(rad)
!x.margin=[5,5]
!y.margin=[5,5]
!y.tickname=[' 18:00',"  ", "  6:00"]
!y.ticks=2
!x.tickname=[' ', '5', ' 0', ' 5', '  ']
!x.ticks=4
;window,1, xsize = 600, ysize = 600
plot, lshell3x, lshell3y, xrange=[-10,10], yrange=[-10,10],XSTYLE=4, YSTYLE=4, $
  title="Jan. 3, 2014 (L vs MLT Kp=1)!Cfrom jan3_correlations.pro"
AXIS,0,0,XAX=0,/DATA
AXIS,0,0,0,YAX=0,/DATA
oplot, lshell5x, lshell5y
oplot, lshell7x, lshell7y
oplot, lshell9x,lshell9y

q=7.5*sin(!pi/4)
q2 = 7.5*cos(!pi/8)
q3 = 7.5*sin(!pi/8)
q4 = 7.5*cos(3.0*!pi/8)
q5 = 7.5*sin(3.0*!pi/8)
usersym, [0,q4,q,q2,7.5,q2,q,q4,0,0],[7.5,q5,q,q3,0,-q3,-q,-q5,-7.5,7.5],/fill
oplot, lshell1x,lshell1y
oplot, [0,0],[0,0],psym=8

xyouts, -10.5, -0.60, '12:00', /data
xyouts, 9.75, -0.60, '0:00', /data
xyouts, -7, -0.6, '7', /data
xyouts, -3, -0.6, '3',/data
xyouts, 7, -0.6, '7', /data
xyouts, 3, -0.6,'3', /data



window = 60.*30.
lag = window/4.
coherence_time = window*2.5
cormin = 0.4

v1 = 'Bfield_hissinta'
v2 = 'Bfield_hissintb'
dynamic_cross_spec_tplot,v1,0,v2,0,T1,T2,window,lag,coherence_time,new_name='hissa_hissb'



var = 'hissa_hissb_coherence'
get_data,var,data=dat
hc3m = dat.y[*,9]
print,1/dat.v[9]/60.
;for i=0,100 do print,i,1/dat.v[i]/60.

;Find the max coherence for periods b/t 0.333 and 1.667
;hc3m = fltarr(n_elements(dat.x))
;for i=0,n_elements(dat.x)-1 do hc3m[i] = max(dat.y[i,8:12],/nan)


get_data,'rbspa_state_lshell',data=la

tinterpol_mxn,'rbspa_state_lshell','hissa_hissb_coherence'
tinterpol_mxn,'rbspa_state_mlt','hissa_hissb_coherence'
tinterpol_mxn,'rbspb_state_lshell','hissa_hissb_coherence'
tinterpol_mxn,'rbspb_state_mlt','hissa_hissb_coherence'
get_data,'rbspa_state_lshell_interp',data=la
get_data,'rbspa_state_mlt_interp',data=mlta
get_data,'rbspb_state_lshell_interp',data=lb
get_data,'rbspb_state_mlt_interp',data=mltb

;plot hiss correlations for A and B
xva = la.y*cos(mlta.y*360.*!dtor/24.)
yva = la.y*sin(mlta.y*360.*!dtor/24.)
xvb = lb.y*cos(mltb.y*360.*!dtor/24.)
yvb = lb.y*sin(mltb.y*360.*!dtor/24.)

datavals = hc3m
datavals[*] = 0.
goo = where((hc3m ge 0.9) and (hc3m lt 1))
if goo[0] ne -1 then datavals[goo] = 254
goo = where((hc3m ge 0.8) and (hc3m lt 0.9))
if goo[0] ne -1 then datavals[goo] = 205
goo = where((hc3m ge 0.7) and (hc3m lt 0.8))
if goo[0] ne -1 then datavals[goo] = 75
goo = where((hc3m ge 0.0) and (hc3m lt 0.7))
if goo[0] ne -1 then datavals[goo] = 1


;Plot straight line connections b/t each sc with the color of the line indicating the correlation
;Sort by color so that the best correlations plot over the weaker ones
st = sort(datavals)
datavals2 = (datavals[st])
xva2 = xva[st]
xvb2 = xvb[st]
yva2 = yva[st]
yvb2 = yvb[st]
for i=0,n_elements(hc3m)-1 do begin  $
	print,datavals[i] & $
	if finite(hc3m[i]) then oplot,[xva2[i],xvb2[i]],[yva2[i],yvb2[i]],color=datavals2[i]
;oplot,[xva2,xva2],[yva2,yva2],psym=4
;oplot,[xvb2,xvb2],[yvb2,yvb2],psym=4,color=220








rbsp_load_emfisis,probe='b',coord='gse',cadence='1sec',level='l3'  ;load this for the mag model subtract
split_vec,'rbspb_emfisis_l3_1sec_gse_Mag'
split_vec,'rbspa_emfisis_l3_1sec_gse_Mag'


window = 60.*30.
lag = window/4.
coherence_time = window*2.5
cormin = 0.4


rbsp_detrend,['rbspa_emfisis_l3_1sec_gse_Mag_z','rbspb_emfisis_l3_1sec_gse_Mag_z'],60.*10.

v1 = 'rbspa_emfisis_l3_1sec_gse_Mag_z_detrend'
v2 = 'rbspb_emfisis_l3_1sec_gse_Mag_z_detrend'
dynamic_cross_spec_tplot,v1,0,v2,0,T1,T2,window,lag,coherence_time,new_name='bza_bzb'


get_data,'bza_bzb_coherence',data=coh
get_data,'bza_bzb_phase',data=ph
goo = where(coh.y le cormin)
if goo[0] ne -1 then coh.y[goo] = !values.f_nan
if goo[0] ne -1 then ph.y[goo] = !values.f_nan
boo = where(finite(coh.y) eq 0)
if boo[0] ne -1 then ph.y[boo] = !values.f_nan
store_data,'bza_bzb_coherence',data=coh
store_data,'bza_bzb_phase',data=ph
options,'bza_bzb_coherence','ytitle','Bza vs Bzb GSE!CCoherence!Cfreq[Hz]'
options,'bza_bzb_phase','ytitle','Bza vs Bzb GSE!CPhase!Cfreq[Hz]'
ylim,['bza_bzb_coherence','bza_bzb_phase'],-0.001,0.04
zlim,'bza_bzb_coherence',0.4,1
;tplot,['bza_bzb_coherence','bza_bzb_phase',v1,v2,'rbsp_state_sc_sep','rbsp_state_mlt_diff','rbsp_state_lshell_diff']
;tplot,['bza_bzb_coherence',v1,v2,'rbsp_state_sc_sep','rbsp_state_mlt_diff','rbsp_state_lshell_diff']
;timebar,0.0013,varname='bza_bzb_coherence',/databar,thick=2
;timebar,0.0075,varname='bza_bzb_coherence',/databar,thick=2
;timebar,0.0067,varname='bza_bzb_coherence',/databar,thick=2
;timebar,0.0013,varname='bza_bzb_phase',/databar,thick=2
;timebar,0.0075,varname='bza_bzb_phase',/databar,thick=2
;timebar,0.0067,varname='bza_bzb_phase',/databar,thick=2



var = 'bza_bzb_coherence'
get_data,var,data=dat
hc3m = dat.y[*,7]
periods = 1/dat.v/60.
print,1/dat.v[7]/60.
;for i=0,100 do print,i,1/dat.v[i]/60.

;18:89

;Find the max coherence for periods b/t 0.333 and 1.667
hc3m = fltarr(n_elements(dat.x))
for i=0,n_elements(dat.x)-1 do hc3m[i] = max(dat.y[i,7:11],/nan)
;minv = 0.333
;maxv = 1.667



get_data,'rbspa_state_lshell',data=la

tinterpol_mxn,'rbspa_state_lshell','hissa_hissb_coherence'
tinterpol_mxn,'rbspa_state_mlt','hissa_hissb_coherence'
tinterpol_mxn,'rbspb_state_lshell','hissa_hissb_coherence'
tinterpol_mxn,'rbspb_state_mlt','hissa_hissb_coherence'
get_data,'rbspa_state_lshell_interp',data=la
get_data,'rbspa_state_mlt_interp',data=mlta
get_data,'rbspb_state_lshell_interp',data=lb
get_data,'rbspb_state_mlt_interp',data=mltb

;plot hiss correlations for A and B
xva = la.y*cos(mlta.y*360.*!dtor/24.)
yva = la.y*sin(mlta.y*360.*!dtor/24.)
xvb = lb.y*cos(mltb.y*360.*!dtor/24.)
yvb = lb.y*sin(mltb.y*360.*!dtor/24.)

datavals = hc3m
datavals[*] = 0.
goo = where((hc3m ge 0.9) and (hc3m lt 1))
if goo[0] ne -1 then datavals[goo] = 254
goo = where((hc3m ge 0.8) and (hc3m lt 0.9))
if goo[0] ne -1 then datavals[goo] = 205
goo = where((hc3m ge 0.7) and (hc3m lt 0.8))
if goo[0] ne -1 then datavals[goo] = 75
goo = where((hc3m ge 0.0) and (hc3m lt 0.7))
if goo[0] ne -1 then datavals[goo] = 1


;Plot straight line connections b/t each sc with the color of the line indicating the correlation
;Sort by color so that the best correlations plot over the weaker ones
st = sort(datavals)
datavals2 = (datavals[st])
xva2 = xva[st]
xvb2 = xvb[st]
yva2 = yva[st]
yvb2 = yvb[st]
for i=0,n_elements(hc3m)-1 do begin  $
	print,datavals[i] & $
	if finite(hc3m[i]) then oplot,[xva2[i],xvb2[i]],[yva2[i],yvb2[i]],color=datavals2[i]
;oplot,[xva2,xva2],[yva2,yva2],psym=4
;oplot,[xvb2,xvb2],[yvb2,yvb2],psym=4,color=220



;--------------------------------------------------------------------------

tinterpol_mxn,'densitya','rbspa_emfisis_l3_1sec_gse_Mag'
tinterpol_mxn,'densityb','rbspa_emfisis_l3_1sec_gse_Mag'

window = 60.*30.
lag = window/4.
coherence_time = window*2.5
cormin = 0.4

rbsp_detrend,['densitya_interp','densityb_interp'],60.*10.

v1 = 'densitya_interp_detrend'
v2 = 'densityb_interp_detrend'
dynamic_cross_spec_tplot,v1,0,v2,0,T1,T2,window,lag,coherence_time,new_name='da_db'


get_data,'da_db_coherence',data=coh
get_data,'da_db_phase',data=ph
goo = where(coh.y le cormin)
if goo[0] ne -1 then coh.y[goo] = !values.f_nan
if goo[0] ne -1 then ph.y[goo] = !values.f_nan
boo = where(finite(coh.y) eq 0)
if boo[0] ne -1 then ph.y[boo] = !values.f_nan
store_data,'da_db_coherence',data=coh
store_data,'da_db_phase',data=ph
options,'da_db_coherence','ytitle','Bza vs Bzb GSE!CCoherence!Cfreq[Hz]'
options,'da_db_phase','ytitle','Bza vs Bzb GSE!CPhase!Cfreq[Hz]'
ylim,['da_db_coherence','da_db_phase'],-0.001,0.04
zlim,'da_db_coherence',0.4,1
;tplot,['da_db_coherence','da_db_phase',v1,v2,'rbsp_state_sc_sep','rbsp_state_mlt_diff','rbsp_state_lshell_diff']
;tplot,['da_db_coherence',v1,v2,'rbsp_state_sc_sep','rbsp_state_mlt_diff','rbsp_state_lshell_diff']
;timebar,0.0013,varname='da_db_coherence',/databar,thick=2
;timebar,0.0075,varname='da_db_coherence',/databar,thick=2
;timebar,0.0067,varname='da_db_coherence',/databar,thick=2
;timebar,0.0013,varname='da_db_phase',/databar,thick=2
;timebar,0.0075,varname='da_db_phase',/databar,thick=2
;timebar,0.0067,varname='da_db_phase',/databar,thick=2



var = 'da_db_coherence'
get_data,var,data=dat
hc3m = dat.y[*,9]
periods = 1/dat.v/60.
print,1/dat.v[9]/60.
;for i=0,100 do print,i,1/dat.v[i]/60.

;18:89

;Find the max coherence for periods b/t 0.333 and 1.667
hc3m = fltarr(n_elements(dat.x))
for i=0,n_elements(dat.x)-1 do hc3m[i] = max(dat.y[i,7:11],/nan)
;minv = 0.333
;maxv = 1.667



get_data,'rbspa_state_lshell',data=la

tinterpol_mxn,'rbspa_state_lshell','hissa_hissb_coherence'
tinterpol_mxn,'rbspa_state_mlt','hissa_hissb_coherence'
tinterpol_mxn,'rbspb_state_lshell','hissa_hissb_coherence'
tinterpol_mxn,'rbspb_state_mlt','hissa_hissb_coherence'
get_data,'rbspa_state_lshell_interp',data=la
get_data,'rbspa_state_mlt_interp',data=mlta
get_data,'rbspb_state_lshell_interp',data=lb
get_data,'rbspb_state_mlt_interp',data=mltb

;plot hiss correlations for A and B
xva = la.y*cos(mlta.y*360.*!dtor/24.)
yva = la.y*sin(mlta.y*360.*!dtor/24.)
xvb = lb.y*cos(mltb.y*360.*!dtor/24.)
yvb = lb.y*sin(mltb.y*360.*!dtor/24.)

datavals = hc3m
datavals[*] = 0.
goo = where((hc3m ge 0.9) and (hc3m lt 1))
if goo[0] ne -1 then datavals[goo] = 254
goo = where((hc3m ge 0.8) and (hc3m lt 0.9))
if goo[0] ne -1 then datavals[goo] = 205
goo = where((hc3m ge 0.7) and (hc3m lt 0.8))
if goo[0] ne -1 then datavals[goo] = 75
goo = where((hc3m ge 0.0) and (hc3m lt 0.7))
if goo[0] ne -1 then datavals[goo] = 1


;Plot straight line connections b/t each sc with the color of the line indicating the correlation
;Sort by color so that the best correlations plot over the weaker ones
st = sort(datavals)
datavals2 = (datavals[st])
xva2 = xva[st]
xvb2 = xvb[st]
yva2 = yva[st]
yvb2 = yvb[st]
for i=0,n_elements(hc3m)-1 do begin  $
	print,datavals[i] & $
	if finite(hc3m[i]) then oplot,[xva2[i],xvb2[i]],[yva2[i],yvb2[i]],color=datavals2[i]
;oplot,[xva2,xva2],[yva2,yva2],psym=4
;oplot,[xvb2,xvb2],[yvb2,yvb2],psym=4,color=220














;-----------------------------------------------
;NOW PLOT GEOPHYSICAL CORRELATIONS WITH 2I


v1 = 'PeakDet_2I_sp_detrend_detrend'
v2 = 'Bfield_hissinta_sp_detrend_detrend_interp'
dynamic_cross_spec_tplot,v1,0,v2,0,T1,T2,window,lag,coherence_time,new_name='Precip_hissa'  
var = 'Precip_hissa_coherence'

;v1 = 'PeakDet_2I_sp_detrend_detrend'
;v2 = 'densitya_sp_detrend_detrend_interp'
;dynamic_cross_spec_tplot,v1,0,v2,0,T1,T2,window,lag,coherence_time,new_name='Precip_dens'  
;var = 'Precip_dens_coherence'

;v1 = 'PeakDet_2I_sp_detrend_detrend'
;v2 = '2I_avebounce30_detrend_interp'
;dynamic_cross_spec_tplot,v1,0,v2,0,T1,T2,window,lag,coherence_time,new_name='Precip_diffusion30'  
;var = 'Precip_diffusion30_coherence'

;v1 = 'PeakDet_2I_sp_detrend_detrend'
;v2 = 'rbspa_emfisis_l3_1sec_gse_Mag_sp_detrend_detrend_z_interp'
;dynamic_cross_spec_tplot,v1,0,v2,0,T1,T2,window,lag,coherence_time,new_name='Precip_BzGSE_coherence'  
;var = 'Precip_BzGSE_coherence'

;v1 = 'PeakDet_2I_sp_detrend_detrend'
;v2 = 'fesa30_sp_detrend_detrend_interp'
;dynamic_cross_spec_tplot,v1,0,v2,0,T1,T2,window,lag,coherence_time,new_name='Precip_fesa30'  
;var = 'Precip_fesa30_coherence'

;v1 = 'PeakDet_2W_sp_detrend_detrend'
;v2 = 'Bfield_hissinta_sp_detrend_detrend_interp'
;dynamic_cross_spec_tplot,v1,0,v2,0,T1,T2,window,lag,coherence_time,new_name='Precip2w_hiss'  
;var = 'Precip2w_hiss_coherence'


get_data,var,data=dat
hc3m = dat.y[*,13]
hc3mt = dat.x[*]
print,1/dat.v[13]/60.

payload = '2I'

restore,'~/Desktop/Research/RBSP_hiss_precip/barrel_mapping/BARREL_RBSP_Kp3/barrel_template.sav'
;myfile = '~/Desktop/Research/RBSP_hiss_precip/barrel_mapping/BARREL_RBSP_Kp1/bar_2I_mag.dat'
myfile = '~/Desktop/Research/RBSP_hiss_precip/barrel_mapping/BARREL_RBSP_Kp3/BAR_'+payload+'_140103_mag.dat'
data = read_ascii(myfile, template = res)

data.mlt = data.mlt*360.0/24.0
x = abs(data.l)*cos(data.mlt*!pi/180.0)
y = abs(data.l)*sin(data.mlt*!pi/180.0)
tms = time_double('2014-01-03') + data.utsec
store_data,'xv_'+payload,data={x:tms,y:x}
store_data,'yv_'+payload,data={x:tms,y:y}
xtmp = tsample('xv_'+payload,time_double([T1,T2]),times=tmssx)
ytmp = tsample('yv_'+payload,time_double([T1,T2]),times=tmssy)
store_data,'xv_'+payload,data={x:tmssx,y:xtmp}
store_data,'yv_'+payload,data={x:tmssy,y:ytmp}

tinterpol_mxn,'rbspa_state_lshell',var
tinterpol_mxn,'rbspa_state_mlt',var
tinterpol_mxn,'xv_'+payload,var
tinterpol_mxn,'yv_'+payload,var

get_data,'rbspa_state_lshell_interp',data=la
get_data,'rbspa_state_mlt_interp',data=mlta
get_data,'xv_'+payload+'_interp',data=x2I
get_data,'yv_'+payload+'_interp',data=y2I

;plot hiss correlations for A and B
xva = la.y*cos(mlta.y*360.*!dtor/24.)
yva = la.y*sin(mlta.y*360.*!dtor/24.)
x2I = x2I.y
y2I = y2I.y

datavals = hc3m
datavals[*] = 0.
goo = where((hc3m ge 0.9) and (hc3m lt 1))
if goo[0] ne -1 then datavals[goo] = 254
goo = where((hc3m ge 0.8) and (hc3m lt 0.9))
if goo[0] ne -1 then datavals[goo] = 205
goo = where((hc3m ge 0.7) and (hc3m lt 0.8))
if goo[0] ne -1 then datavals[goo] = 75
goo = where((hc3m ge 0.0) and (hc3m lt 0.7))
if goo[0] ne -1 then datavals[goo] = 1

;diamonds
dX = [-2, 0, 2, 0, -2]
dY = [0, 2, 0, -2, 0]
USERSYM, dX, dY,/fill,color=250


;Plot straight line connections b/t each sc with the color of the line indicating the correlation
;Sort by color so that the best correlations plot over the weaker ones
st = sort(datavals)
datavals2 = (datavals[st])
xva2 = xva[st]
xvb2 = x2I[st]
yva2 = yva[st]
yvb2 = y2I[st]
for i=0,n_elements(hc3m)-1 do begin  $
	print,time_string(hc3mt[i]),'  ',datavals[i] & $	
	if finite(hc3m[i]) then oplot,[xva2[i],xvb2[i]],[yva2[i],yvb2[i]],color=datavals2[i]

oplot,[xva2,xva2],[yva2,yva2],psym=4
oplot,[xvb2,xvb2],[yvb2,yvb2],psym=4,color=220






;**********************************************************************


;*****************************************************
;FIND CORRELATION LENGTH FOR HISS ON JAN 3
;*****************************************************


;T1='2014-01-03/18:00:00'	
;T2='2014-01-03/23:00:00'	
T1='2014-01-03/19:30:00'	
T2='2014-01-03/22:30:00'	

rbsp_load_emfisis,probe='b',coord='gse',cadence='1sec',level='l3'  ;load this for the mag model subtract
split_vec,'rbspb_emfisis_l3_1sec_gse_Mag'
split_vec,'rbspa_emfisis_l3_1sec_gse_Mag'


;--------------------------------------------------
;Settle on FFT properties
;--------------------------------------------------

window = 60.*10.
lag = window/4.
coherence_time = window*2.5
cormin = 0.4

v1 = 'Bfield_hissinta'
v2 = 'Bfield_hissintb'
dynamic_cross_spec_tplot,v1,0,v2,0,T1,T2,window,lag,coherence_time,new_name='hissa_hissb'
get_data,'hissa_hissb_coherence',data=coh
get_data,'hissa_hissb_phase',data=ph

help,coh,/st

var = 'hissa_hissb_coherence'
get_data,var,data=dat
periods = 1/dat.v/60.
for i=0,100 do print,i,periods[i]

;--------------------------------------------------




ae1 = 4
ae2 = 10

print,1/dat.v[ae1:ae2]/60.

v1 = 'Bfield_hissinta'
v2 = 'Bfield_hissintb'
dynamic_cross_spec_tplot,v1,0,v2,0,T1,T2,window,lag,coherence_time,new_name='hissa_hissb'

var = 'hissa_hissb_coherence'
get_data,var,data=dat

for i=0,n_elements(dat.x)-1 do hc3m_hiss[i] = max(dat.y[i,ae1:ae2],/nan)

get_data,'rbspa_state_lshell',data=la

tinterpol_mxn,'rbspa_state_lshell','hissa_hissb_coherence'
tinterpol_mxn,'rbspa_state_mlt','hissa_hissb_coherence'
tinterpol_mxn,'rbspb_state_lshell','hissa_hissb_coherence'
tinterpol_mxn,'rbspb_state_mlt','hissa_hissb_coherence'
get_data,'rbspa_state_lshell_interp',data=la
get_data,'rbspa_state_mlt_interp',data=mlta
get_data,'rbspb_state_lshell_interp',data=lb
get_data,'rbspb_state_mlt_interp',data=mltb

tinterpol_mxn,'rbsp_state_sc_sep','hissa_hissb_coherence'
get_data,'rbsp_state_sc_sep_interp',data=sep







v1 = 'densitya'
v2 = 'densityb'
dynamic_cross_spec_tplot,v1,0,v2,0,T1,T2,window,lag,coherence_time,new_name='densitya_densityb'
var = 'densitya_densityb_coherence'
get_data,var,data=dat
;hc3m_dens = dat.y[*,ae]
for i=0,n_elements(dat.x)-1 do hc3m_dens[i] = max(dat.y[i,ae1:ae2],/nan)



v1 = 'rbspa_emfisis_l3_1sec_gse_Mag_z_detrend'
v2 = 'rbspb_emfisis_l3_1sec_gse_Mag_z_detrend'
dynamic_cross_spec_tplot,v1,0,v2,0,T1,T2,window,lag,coherence_time,new_name='bza_bzb'
var = 'bza_bzb_coherence'
get_data,var,data=dat
;hc3m_mag = dat.y[*,ae]
for i=0,n_elements(dat.x)-1 do hc3m_mag[i] = max(dat.y[i,ae1:ae2],/nan)




!p.multi = [0,0,3]
plot,1000.*sep.y/6370.,hc3m_hiss,xtitle='SC separation (RE)',ytitle='Coherence',$
	title='Coherence length of hiss(black), density(blue), BzGSE(red) b/t RBSP-A and RBSP-B for '+strtrim(periods[ae2],2)+'-'+strtrim(periods[ae1],2)+' min period waves',yrange=[0.4,1],xrange=[0,3.5]
oplot,1000.*sep.y/6370.,hc3m_dens,color=50
oplot,1000.*sep.y/6370.,hc3m_mag,color=250


plot,abs(la.y-lb.y),hc3m_hiss,xtitle='Delta Lshell',ytitle='Coherence',$
	title='Coherence length of hiss(black), density(blue), BzGSE(red) b/t RBSP-A and RBSP-B for '+strtrim(periods[ae2],2)+'-'+strtrim(periods[ae1],2)+' min period waves',yrange=[0.4,1],xrange=[0,2.5]
oplot,abs(la.y-lb.y),hc3m_dens,color=50
oplot,abs(la.y-lb.y),hc3m_mag,color=250


plot,abs(mlta.y-mltb.y),hc3m_hiss,xtitle='Delta MLT',ytitle='Coherence',$
	title='Coherence length of hiss(black), density(blue), BzGSE(red) b/t RBSP-A and RBSP-B for '+strtrim(periods[ae2],2)+'-'+strtrim(periods[ae1],2)+' min period waves',yrange=[0.4,1],xrange=[0,3.5],xstyle=1
oplot,abs(mlta.y-mltb.y),hc3m_dens,color=50
oplot,abs(mlta.y-mltb.y),hc3m_mag,color=250





;histogram the results to simplify plots
cormin = 0.5
goo = where(hc3m_hiss le cormin)
hc3m_hiss[goo] = !values.f_nan

hc3m_hiss_Lshell = fltarr(5)
hc3m_hiss_cnt = fltarr(5)
ladiff = abs(la.y - lb.y)
goo = where((ladiff ge 0 ) and (ladiff le 0.5))
n = where(finite(hc3m_hiss[goo]) ne 0,cnt)
hc3m_hiss_lshell[0] = total(hc3m_hiss[goo],/nan)/cnt
hc3m_hiss_cnt[0] = cnt
goo = where((ladiff ge 0.5 ) and (ladiff le 1))
n = where(finite(hc3m_hiss[goo]) ne 0,cnt)
hc3m_hiss_lshell[1] = total(hc3m_hiss[goo],/nan)/cnt
hc3m_hiss_cnt[1] = cnt
goo = where((ladiff ge 1 ) and (ladiff le 1.5))
n = where(finite(hc3m_hiss[goo]) ne 0,cnt)
hc3m_hiss_lshell[2] = total(hc3m_hiss[goo],/nan)/cnt
hc3m_hiss_cnt[2] = cnt
goo = where((ladiff ge 1.5 ) and (ladiff le 2.0))
n = where(finite(hc3m_hiss[goo]) ne 0,cnt)
hc3m_hiss_lshell[3] = total(hc3m_hiss[goo],/nan)/cnt
hc3m_hiss_cnt[3] = cnt
goo = where((ladiff ge 2 ) and (ladiff le 2.5))
n = where(finite(hc3m_hiss[goo]) ne 0,cnt)
hc3m_hiss_lshell[4] = total(hc3m_hiss[goo],/nan)/cnt
hc3m_hiss_cnt[4] = cnt
;-----
cormin = 0.5
goo = where(hc3m_dens le cormin)
hc3m_dens[goo] = !values.f_nan

hc3m_dens_Lshell = fltarr(5)
hc3m_dens_cnt = fltarr(5)
ladiff = abs(la.y - lb.y)
goo = where((ladiff ge 0 ) and (ladiff le 0.5))
n = where(finite(hc3m_dens[goo]) ne 0,cnt)
hc3m_dens_lshell[0] = total(hc3m_dens[goo],/nan)/cnt
hc3m_dens_cnt[0] = cnt
goo = where((ladiff ge 0.5 ) and (ladiff le 1))
n = where(finite(hc3m_dens[goo]) ne 0,cnt)
hc3m_dens_lshell[1] = total(hc3m_dens[goo],/nan)/cnt
hc3m_dens_cnt[1] = cnt
goo = where((ladiff ge 1 ) and (ladiff le 1.5))
n = where(finite(hc3m_dens[goo]) ne 0,cnt)
hc3m_dens_lshell[2] = total(hc3m_dens[goo],/nan)/cnt
hc3m_dens_cnt[2] = cnt
goo = where((ladiff ge 1.5 ) and (ladiff le 2.0))
n = where(finite(hc3m_dens[goo]) ne 0,cnt)
hc3m_dens_lshell[3] = total(hc3m_dens[goo],/nan)/cnt
hc3m_dens_cnt[3] = cnt
goo = where((ladiff ge 2 ) and (ladiff le 2.5))
n = where(finite(hc3m_dens[goo]) ne 0,cnt)
hc3m_dens_lshell[4] = total(hc3m_dens[goo],/nan)/cnt
hc3m_dens_cnt[4] = cnt
;---------
cormin = 0.5
goo = where(hc3m_mag le cormin)
hc3m_mag[goo] = !values.f_nan

hc3m_mag_Lshell = fltarr(5)
hc3m_mag_cnt = fltarr(5)
ladiff = abs(la.y - lb.y)
goo = where((ladiff ge 0 ) and (ladiff le 0.5))
n = where(finite(hc3m_mag[goo]) ne 0,cnt)
hc3m_mag_lshell[0] = total(hc3m_mag[goo],/nan)/cnt
hc3m_mag_cnt[0] = cnt
goo = where((ladiff ge 0.5 ) and (ladiff le 1))
n = where(finite(hc3m_mag[goo]) ne 0,cnt)
hc3m_mag_lshell[1] = total(hc3m_mag[goo],/nan)/cnt
hc3m_mag_cnt[1] = cnt
goo = where((ladiff ge 1 ) and (ladiff le 1.5))
n = where(finite(hc3m_mag[goo]) ne 0,cnt)
hc3m_mag_lshell[2] = total(hc3m_mag[goo],/nan)/cnt
hc3m_mag_cnt[2] = cnt
goo = where((ladiff ge 1.5 ) and (ladiff le 2.0))
n = where(finite(hc3m_mag[goo]) ne 0,cnt)
hc3m_mag_lshell[3] = total(hc3m_mag[goo],/nan)/cnt
hc3m_mag_cnt[3] = cnt
goo = where((ladiff ge 2 ) and (ladiff le 2.5))
n = where(finite(hc3m_mag[goo]) ne 0,cnt)
hc3m_mag_lshell[4] = total(hc3m_mag[goo],/nan)/cnt
hc3m_mag_cnt[4] = cnt
;-------------------------------------------------------



;histogram the results to simplify plots
cormin = 0.5
goo = where(hc3m_hiss le cormin)
hc3m_hiss[goo] = !values.f_nan

hc3m_hiss_mlt = fltarr(6)
hc3m_hiss_cnt = fltarr(6)
mltdiff = abs(mlta.y - mltb.y)
goo = where((mltdiff ge 0.5 ) and (mltdiff le 1))
n = where(finite(hc3m_hiss[goo]) ne 0,cnt)
hc3m_hiss_mlt[0] = total(hc3m_hiss[goo],/nan)/cnt
hc3m_hiss_cnt[0] = cnt
goo = where((mltdiff ge 1 ) and (mltdiff le 1.5))
n = where(finite(hc3m_hiss[goo]) ne 0,cnt)
hc3m_hiss_mlt[1] = total(hc3m_hiss[goo],/nan)/cnt
hc3m_hiss_cnt[1] = cnt
goo = where((mltdiff ge 1.5 ) and (mltdiff le 2.0))
n = where(finite(hc3m_hiss[goo]) ne 0,cnt)
hc3m_hiss_mlt[2] = total(hc3m_hiss[goo],/nan)/cnt
hc3m_hiss_cnt[2] = cnt
goo = where((mltdiff ge 2 ) and (mltdiff le 2.5))
n = where(finite(hc3m_hiss[goo]) ne 0,cnt)
hc3m_hiss_mlt[3] = total(hc3m_hiss[goo],/nan)/cnt
hc3m_hiss_cnt[3] = cnt
goo = where((mltdiff ge 2.5 ) and (mltdiff le 3))
n = where(finite(hc3m_hiss[goo]) ne 0,cnt)
hc3m_hiss_mlt[4] = total(hc3m_hiss[goo],/nan)/cnt
hc3m_hiss_cnt[4] = cnt
goo = where((mltdiff ge 3 ) and (mltdiff le 3.5))
n = where(finite(hc3m_hiss[goo]) ne 0,cnt)
hc3m_hiss_mlt[5] = total(hc3m_hiss[goo],/nan)/cnt
hc3m_hiss_cnt[5] = cnt


;-----
cormin = 0.5
goo = where(hc3m_dens le cormin)
hc3m_dens[goo] = !values.f_nan

hc3m_dens_mlt = fltarr(6)
hc3m_dens_cnt = fltarr(6)
mltdiff = abs(mlta.y - mltb.y)
goo = where((mltdiff ge 0.5 ) and (mltdiff le 1))
n = where(finite(hc3m_dens[goo]) ne 0,cnt)
hc3m_dens_mlt[0] = total(hc3m_dens[goo],/nan)/cnt
hc3m_dens_cnt[0] = cnt
goo = where((mltdiff ge 1 ) and (mltdiff le 1.5))
n = where(finite(hc3m_dens[goo]) ne 0,cnt)
hc3m_dens_mlt[1] = total(hc3m_dens[goo],/nan)/cnt
hc3m_dens_cnt[1] = cnt
goo = where((mltdiff ge 1.5 ) and (mltdiff le 2.0))
n = where(finite(hc3m_dens[goo]) ne 0,cnt)
hc3m_dens_mlt[2] = total(hc3m_dens[goo],/nan)/cnt
hc3m_dens_cnt[2] = cnt
goo = where((mltdiff ge 2 ) and (mltdiff le 2.5))
n = where(finite(hc3m_dens[goo]) ne 0,cnt)
hc3m_dens_mlt[3] = total(hc3m_dens[goo],/nan)/cnt
hc3m_dens_cnt[3] = cnt
goo = where((mltdiff ge 2.5 ) and (mltdiff le 3))
n = where(finite(hc3m_dens[goo]) ne 0,cnt)
hc3m_dens_mlt[4] = total(hc3m_dens[goo],/nan)/cnt
hc3m_dens_cnt[4] = cnt
goo = where((mltdiff ge 3 ) and (mltdiff le 3.5))
n = where(finite(hc3m_dens[goo]) ne 0,cnt)
hc3m_dens_mlt[5] = total(hc3m_dens[goo],/nan)/cnt
hc3m_dens_cnt[5] = cnt

;-----
cormin = 0.5
goo = where(hc3m_mag le cormin)
hc3m_mag[goo] = !values.f_nan

hc3m_mag_mlt = fltarr(6)
hc3m_mag_cnt = fltarr(6)
mltdiff = abs(mlta.y - mltb.y)
goo = where((mltdiff ge 0.5 ) and (mltdiff le 1))
n = where(finite(hc3m_mag[goo]) ne 0,cnt)
hc3m_mag_mlt[0] = total(hc3m_mag[goo],/nan)/cnt
hc3m_mag_cnt[0] = cnt
goo = where((mltdiff ge 1 ) and (mltdiff le 1.5))
n = where(finite(hc3m_mag[goo]) ne 0,cnt)
hc3m_mag_mlt[1] = total(hc3m_mag[goo],/nan)/cnt
hc3m_mag_cnt[1] = cnt
goo = where((mltdiff ge 1.5 ) and (mltdiff le 2.0))
n = where(finite(hc3m_mag[goo]) ne 0,cnt)
hc3m_mag_mlt[2] = total(hc3m_mag[goo],/nan)/cnt
hc3m_mag_cnt[2] = cnt
goo = where((mltdiff ge 2 ) and (mltdiff le 2.5))
n = where(finite(hc3m_mag[goo]) ne 0,cnt)
hc3m_mag_mlt[3] = total(hc3m_mag[goo],/nan)/cnt
hc3m_mag_cnt[3] = cnt
goo = where((mltdiff ge 2.5 ) and (mltdiff le 3))
n = where(finite(hc3m_mag[goo]) ne 0,cnt)
hc3m_mag_mlt[4] = total(hc3m_mag[goo],/nan)/cnt
hc3m_mag_cnt[4] = cnt
goo = where((mltdiff ge 3 ) and (mltdiff le 3.5))
n = where(finite(hc3m_mag[goo]) ne 0,cnt)
hc3m_mag_mlt[5] = total(hc3m_mag[goo],/nan)/cnt
hc3m_mag_cnt[5] = cnt






!p.multi = [0,0,3]
plot,1000.*sep.y/6370.,hc3m_hiss,xtitle='SC separation (RE)',ytitle='Coherence',$
	title='Avg Coherence of hiss(black), density(blue), BzGSE(red) b/t RBSP-A and RBSP-B for '+strtrim(periods[ae2],2)+'-'+strtrim(periods[ae1],2)+' min period waves',yrange=[0.4,1],xrange=[0,3.5]
oplot,1000.*sep.y/6370.,hc3m_dens,color=50
oplot,1000.*sep.y/6370.,hc3m_mag,color=250


lshells = [0.5,1,1.5,2,2.5] - 0.25
plot,lshells,hc3m_hiss_lshell,xtitle='Delta Lshell',ytitle='Coherence',$
	title='Avg Coherence of hiss(black), density(blue), BzGSE(red) b/t RBSP-A and RBSP-B for '+strtrim(periods[ae2],2)+'-'+strtrim(periods[ae1],2)+' min period waves',yrange=[0.4,1],xrange=[0,2.5]
oplot,lshells,hc3m_dens_lshell,color=50
oplot,lshells,hc3m_mag_lshell,color=250

mlts = [1,1.5,2,2.5,3,3.5] - 0.5
plot,mlts,hc3m_hiss_mlt,xtitle='Delta MLT',ytitle='Coherence',$
	title='Avg Coherence of hiss(black), density(blue), BzGSE(red) b/t RBSP-A and RBSP-B for '+strtrim(periods[ae2],2)+'-'+strtrim(periods[ae1],2)+' min period waves',yrange=[0.4,1],xrange=[0,3.5],xstyle=1
oplot,mlts,hc3m_dens_mlt,color=50
oplot,mlts,hc3m_mag_mlt,color=250




