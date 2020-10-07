;Need to get tplot variables from paper_plot_jan10.pro first. 

;Use BARREL 2X as a reference to calculate time delays of various quantities for the Jan10th, 2014 event near 22 UT. 
;These are used to:
;--time-shift the data for pretty overlap plots (to see obvious correlation)
;--time-shift the data for input into the coherence spectrogram plots. 


;This is nice to see the cc coefficients. However, I can get different tshifts for the various
;quantities on RBSPa. Should I then use the highest one (RBSPa B-Bmodel) to time-shift the others? 
;Probably the best not to use cc values for timeshifts in the plots I present. 



;Limiting the max tshift to +/-10 min


t0z = '2014-01-10/20:00:00'
t1z = '2014-01-11/00:30'

vars = ['fspc_2X_smoothed_detrend',$
'fspc_'+pre+'L_smoothed_detrend',$
'LANL-01A_avg_flux_sopa_esp_e_smoothed_detrend_0',$
'LANL-97A_avg_flux_sopa_esp_e_smoothed_detrend_0',$
'OMNI_HRO_1min_proton_density_smoothed_detrend',$
'fspc_'+pre+'K_smoothed_detrend',$
'1994-084_avg_flux_sopa_esp_e_smoothed_detrend_0',$
'rbspa_bmag_t89_diff_smoothed_detrend',$
'g13_dtc_cor_eflux_0_smoothed_detrend',$
'LANL-04A_avg_flux_sopa_esp_e_smoothed_detrend_0',$
'rbspa_Daa2_smoothed_detrend',$
'rbspa_sloshing_distance_km',$
'rbspb_bmag_t89_diff_smoothed_detrend',$
'Bfield_hissinta_smoothed_detrend',$
'Bfield_hissintb_smoothed_detrend',$
'rbspa_Vx!CExB-drift!Ckm/s_detrend',$
'rbspa_density_smoothed_detrend',$
'tha_l2_fbk_spec_scm1_572Hz_smoothed_detrend',$
'LANL-02A_avg_flux_sopa_esp_e_smoothed_detrend_0',$
'G14_bmag_smoothed_detrend']


vars = ['fspc_2X_smoothed_detrend',$
'G14_bmag_smoothed_detrend']


;Vars I'm ignoring b/c of missing data
;var2 = 'g15_dtc_cor_eflux_0_smoothed_detrend'
;var2 = 'rbspb_density_smoothed_detrend'
;var2 = '1991-080_avg_flux_sopa_esp_e_smoothed_detrend_0'



ccvals = fltarr(n_elements(vars))
tshiftv = fltarr(n_elements(vars))
tshift = 0.
maxcc = 0.


;First interpolate all the times to the reference variable (2X) 
for i=0,n_elements(vars)-1 do tinterpol_mxn,vars[i],vars[0]


for i=0,n_elements(vars)-1 do begin cross_correlation_normalized_plot,vars[0]+'_interp',vars[i]+'_interp',t0z,t1z,mincc=0.,tshift=tshift,maxcc=maxcc & tshiftv[i] = tshift & ccvals[i] = maxcc


for i=0,n_elements(vars)-1 do print,vars[i], ccvals[i], tshiftv[i],format='(A50,10x,f8.4,10x,f10.4)'
;Output from cross-correlation                                  cc              tshift
;                          fspc_2X_smoothed_detrend            1.0000              0.0000
;                          fspc_2L_smoothed_detrend            0.8282             45.7315
;   LANL-01A_avg_flux_sopa_esp_e_smoothed_detrend_0            0.7982             33.6969
;   LANL-97A_avg_flux_sopa_esp_e_smoothed_detrend_0            0.6939            392.3278
;     OMNI_HRO_1min_proton_density_smoothed_detrend            0.6457            -45.7315
;                          fspc_2K_smoothed_detrend            0.6245            113.1251
;   1994-084_avg_flux_sopa_esp_e_smoothed_detrend_0            0.5811            245.5057
;              rbspa_bmag_t89_diff_smoothed_detrend            0.5094            216.6226
;              g13_dtc_cor_eflux_0_smoothed_detrend            0.4604            117.9390
;                         G14_bmag_smoothed_detrend            0.4586            269.5749
;   LANL-04A_avg_flux_sopa_esp_e_smoothed_detrend_0            0.3933            596.9158
;                       rbspa_Daa2_smoothed_detrend            0.3504            117.9390
;                        rbspa_sloshing_distance_km            0.3278            -57.7662
;              rbspb_bmag_t89_diff_smoothed_detrend            0.2886            252.7265
;                  Bfield_hissinta_smoothed_detrend            0.2453             60.1728
;                  Bfield_hissintb_smoothed_detrend            0.2515            536.7429
;                 rbspa_Vx!CExB-drift!Ckm/s_detrend            0.1731            161.2636
;                    rbspa_density_smoothed_detrend            0.1613           -522.3013
;       tha_l2_fbk_spec_scm1_572Hz_smoothed_detrend            0.0983            596.9158
;   LANL-02A_avg_flux_sopa_esp_e_smoothed_detrend_0            0.0678            105.9044


;Adjust absurd tshift values based on other measurements 

;---RBSPa radial sloshing distance --> make the same as RBSPa |B-Bmodel|
tshiftv[10] = 216.6   
;---RBSPa hiss --> make same as RBSPa |B-Bmodel|
tshiftv[12] = 216.6 
;---RBSPb hiss --> make same as RBSPb |B-Bmodel| 
tshiftv[13] = 252. 
;---RBSPa inverted VxB motion --> make same as RBSPa |B-Bmodel|
tshiftv[14] = 216.6
;---RBSPa density --> make same as RBSPa |B-Bmodel|
tshiftv[15] = 216.6
;---THEMISa FBK --> set to zero. I have no good reference for what this should be. 
tshiftv[16] = 0. 



get_data,vars[0]+'_interp',tms,v1


;Time-shift the data
for i=0,n_elements(vars)-1 do begin $
    get_data,vars[i]+'_interp',tt,v2 & $
    store_data,vars[i]+'_ts',tt-tshiftv[i],v2



;store_data,'comb_tshift_'+var1+'_'+var2,data=[var1+'_N',var2+'_N_ts'] & options,'comb_tshift_'+var1+'_'+var2,'colors',[0,250] & ylim,'comb_tshift_'+var1+'_'+var2,0,0,0

;varname = 'comb_tshift_'+var1+'_'+var2
;    tplot,['comb_notshift_'+var1+'_'+var2,'comb_tshift_'+var1+'_'+var2]



;Plot in order of cc value
ylim,'LANL-01A_avg_flux_sopa_esp_e_smoothed_detrend_0_ts',-1500,1500
ylim,'rbspb_bmag_t89_diff_smoothed_detrend_ts',-2,2
ylim,'LANL-97A_avg_flux_sopa_esp_e_smoothed_detrend_0_ts',-1000,1000
ylim,'g13_dtc_cor_eflux_0_smoothed_detrend_ts',-2000,2000
ylim,'LANL-04A_avg_flux_sopa_esp_e_smoothed_detrend_0_ts',-1200,1200
ylim,'1994-084_avg_flux_sopa_esp_e_smoothed_detrend_0_ts',-1000,1500
ylim,'rbspa_bmag_t89_diff_smoothed_detrend_ts',-1,1
ylim,'LANL-02A_avg_flux_sopa_esp_e_smoothed_detrend_0_ts',-2000,2000
tplot,vars[*]+'_ts'




;Plot in order of type of payload 


vars_plot = ['OMNI_HRO_1min_proton_density_smoothed_detrend',$
'fspc_2X_smoothed_detrend',$
'fspc_'+pre+'L_smoothed_detrend',$
'fspc_'+pre+'K_smoothed_detrend',$
'LANL-01A_avg_flux_sopa_esp_e_smoothed_detrend_0',$
'LANL-97A_avg_flux_sopa_esp_e_smoothed_detrend_0',$
'1994-084_avg_flux_sopa_esp_e_smoothed_detrend_0',$
'g13_dtc_cor_eflux_0_smoothed_detrend',$
'LANL-04A_avg_flux_sopa_esp_e_smoothed_detrend_0',$
'LANL-02A_avg_flux_sopa_esp_e_smoothed_detrend_0',$
'rbspa_bmag_t89_diff_smoothed_detrend',$
'Bfield_hissinta_smoothed_detrend',$
'rbspa_Daa2_smoothed_detrend',$
'rbspa_density_smoothed_detrend',$
'rbspa_sloshing_distance_km',$
;'rbspa_Vx!CExB-drift!Ckm/s_detrend',$
'rbspb_bmag_t89_diff_smoothed_detrend',$
'Bfield_hissintb_smoothed_detrend',$
'tha_l2_fbk_spec_scm1_572Hz_smoothed_detrend'] + '_ts'


tplot,vars_plot





Bfield_hissinta_smoothed_detrend_ts
rbspa_Daa