;;Plot the polarization of the ULF waves. 
;;A comparison of Li11 and Watt11 shows that density and magnetic
;;field must be out of phase in order for the enhanced precipitation
;;caused by ULF waves to be significant


date = '2014-01-03'
timespan,date
probe = 'a'
sc = probe
t0 = '2014-01-03/19:30'
t1 = '2014-01-03/22:30'

smoothtime = 0.5
dettime = 30.

path = '~/Desktop/Research/RBSP_hiss_precip/rbsp/'
fn = 'rbspa_efw-l3_20140103_v01.cdf'
;fn = 'rbspa_efw-l3_20140106_v01.cdf'
cdf2tplot,path+fn

;copy_data,'density','rbspa_density'
copy_data,'efield_inertial_frame_mgse','rbspa_efield_inertial_frame_mgse'
copy_data,'mlt_lshell_mlat','rbspa_mlt_lshell_mlat'


store_data,['density','pos_gse','vel_gse','efield_inertial_frame_mgse','efield_corotation_frame_mgse','VcoroxB_mgse','VscxB_mgse','spinaxis_gse','mlt_lshell_mlat'],/delete


rbsp_efw_density_fit_from_uh_line,'Vavg',$
                                  newname='rbsp'+sc+'_density',$
                                  dmin=10.,$
                                  dmax=3000.,$
                                  setval=-1.e31


y = tsample('rbspa_density',[time_double(t0)-3600.,time_double(t1)+3600.],times=tms)
store_data,'rbspa_density',data={x:tms,y:y}


rbsp_detrend,'rbspa_density',60.*smoothtime
copy_data,'rbspa_density_smoothed','rbspa_density'
rbsp_detrend,'rbspa_density',60.*dettime








;;--------------------
;;Get hiss RMS

fcals = rbsp_efw_get_gain_results()
fbinsL = fcals.cal_spec.freq_spec64L
fbinsH = fcals.cal_spec.freq_spec64H
bandw = fbinsH - fbinsL

rbsp_load_efw_spec,probe=sc,type='calibrated',/pt


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
;tplot,'Bfield_hissinta'

rbsp_detrend,'Bfield_hissinta',60.*dettime



;;--------------------------------------------------
;;BARREL
;;--------------------------------------------------

rbsp_load_barrel_lc,'2I',type='fspc'
rbsp_detrend,'FSPC*',60.*smoothtime


;;double-peaked event observed through FSPC2
;;total up the FSPC channels 

get_data,'FSPC1a_2I_smoothed',data=d1
get_data,'FSPC1b_2I_smoothed',data=d2
get_data,'FSPC1c_2I_smoothed',data=d3
get_data,'FSPC2_2I_smoothed',data=d4
dtots = d1.y + d2.y + d3.y + d4.y
store_data,'FSPC_totes',data={x:d1.x,y:dtots}

;tplot,'FSPC_totes'
rbsp_detrend,'FSPC_totes',60.*dettime


;;--------------------

rbsp_efw_dcfield_removal_crib,'a'

rbsp_detrend,'rbspa_mag_gsm_t96_omni_dif',60.*smoothtime
copy_data,'rbspa_mag_gsm_t96_omni_dif_smoothed','rbspa_mag_gsm_t96_omni_dif'
rbsp_detrend,'rbspa_mag_gsm_t96_omni_dif',60.*dettime

rbsp_detrend,'rbspa_mag_gsm',60.*smoothtime
copy_data,'rbspa_mag_gsm_smoothed','rbspa_mag_gsm'
rbsp_detrend,'rbspa_mag_gsm',60.*dettime

rbsp_detrend,'rbspa_efield_inertial_frame_mgse',60.*1.



get_data,'rbspa_mag_gsm_t96_omni_dif_detrend',data=bb
bmag = sqrt(bb.y[*,0]^2 + bb.y[*,1]^2 + bb.y[*,2]^2)
store_data,'rbspa_bmag',data={x:bb.x,y:bmag}



rbsp_decimate,'rbspa_mag_gsm',level=10
v = rbsp_rotate_field_2_vec('rbspa_mag_gsm_t96_omni_dif_detrend','rbspa_mag_gsm')


tplot,['rbspa_mag_gsm_detrend','rbspa_mag_gsm_t96_omni_dif',$
       'rbspa_mag_mgse_t96_omni','rbspa_bmag',$
       'rbspa_mag_gsm_t96_omni_dif_detrend_FA_minvar']


split_vec,'rbspa_mag_gsm_t96_omni_dif_detrend_FA_minvar'

ylim,'rbspa_mag_gsm_t96_omni_dif_detrend_FA_minvar',-5,5
ylim,'rbspa_density_detrend',-100,100
ylim,'rbspa_mag_gsm_detrend',-10,10

tplot,['rbspa_mag_gsm_t96_omni_dif_detrend_FA_minvar_z',$
       'rbspa_bmag',$
       'rbspa_density_detrend',$
       'rbspa_efield_inertial_frame_mgse_detrend',$
       'Bfield_hissinta_detrend','FSPC_totes_detrend',$
       'flags_charging_bias_eclipse']







stop

end
