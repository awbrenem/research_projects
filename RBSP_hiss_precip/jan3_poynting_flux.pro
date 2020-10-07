tplot_options,'title','from jan3_zoomed_event.pro'

date = '2014-01-03'
probe = 'a'
rbspx = 'rbspa'
timespan,date

rbsp_efw_init

trange = timerange()
rbsp_efw_position_velocity_crib,/noplot,/notrace
;rbsp_load_emfisis,probe=probe,/quicklook
rbsp_load_emfisis,probe=probe,coord='gse',cadence='1sec',level='l3'  ;load this for the mag model subtract





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



t0 = time_double('2014-01-03/19:30')
t1 = time_double('2014-01-03/22:30')



get_data,'rbspa_efw_esvy_mgse_vxb_removed',data=esvy
times = esvy.x

rbsp_boom_directions_crib,times,'a',/no_spice_load
tplot,['vecu_gse','vecv_gse','vecw_gse']





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






