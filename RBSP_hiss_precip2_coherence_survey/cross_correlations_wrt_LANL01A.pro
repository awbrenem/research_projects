;Need to get tplot variables from paper_plot_jan10.pro first. 

;Use LANL-01A as a reference to calculate time delays of various quantities for the Jan10th, 2014 event near 22 UT. 
;These are used to:
;--time-shift the data for pretty overlap plots (to see obvious correlation)
;--time-shift the data for input into the coherence spectrogram plots. 



;------------------------------------------------
;Normal Cross-correlation calculation with respect to LANL01A flux. 
;This is a more stable reference than the OMNI density. 
;I'm also limiting the max tshift to +/-10 min


t0z = '2014-01-10/19:48:30'
;t0z = '2014-01-10/20:00:00'  ;special for OMNI data
t1z = '2014-01-11/00:30'

;get_data,var1,data=dd 
;store_data,'tst',dd.x+(60.*5.),dd.y
;var2 = 'tst'


var1 = 'LANL-01A_avg_flux_sopa_esp_e_smoothed_detrend_0'

var2 = ['fspc_'+pre+'L_smoothed_detrend',$
'fspc_2X_smoothed_detrend',$
'OMNI_HRO_1min_proton_density_smoothed_detrend',$
'LANL-97A_avg_flux_sopa_esp_e_smoothed_detrend_0',$
'1994-084_avg_flux_sopa_esp_e_smoothed_detrend_0',$
'rbspa_bmag_t89_diff_smoothed_detrend',$
'g13_dtc_cor_eflux_0_smoothed_detrend',$
'fspc_'+pre+'K_smoothed_detrend',$
'LANL-04A_avg_flux_sopa_esp_e_smoothed_detrend_0',$
'rbspa_sloshing_distance_km',$
'rbspb_bmag_t89_diff_smoothed_detrend',$
'rbspa_Vx!CExB-drift!Ckm/s_detrend',$
'LANL-02A_avg_flux_sopa_esp_e_smoothed_detrend_0',$
'Bfield_hissinta_smoothed_detrend']
'rbspa_density_smoothed_detrend',$
'tha_l2_fbk_spec_scm1_572Hz_smoothed_detrend',$
'Bfield_hissintb_smoothed_detrend']
;Vars I'm ignoring b/c of missing data
;var2 = 'g15_dtc_cor_eflux_0_smoothed_detrend'
;var2 = 'rbspb_density_smoothed_detrend'
;var2 = '1991-080_avg_flux_sopa_esp_e_smoothed_detrend_0'

for i=0,n_elements(var2)-1 do cross_correlation_normalized_plot,var1,var2[i],t0z,t1z


;Plot all the time-shifted quantities relative to LANL01A flux
;plotted in order of maxcc value
tplot,['comb_tshift_LANL-01A_avg_flux_sopa_esp_e_smoothed_detrend_0_fspc_2L_smoothed_detrend',$
'comb_tshift_LANL-01A_avg_flux_sopa_esp_e_smoothed_detrend_0_fspc_2X_smoothed_detrend',$
'comb_tshift_LANL-01A_avg_flux_sopa_esp_e_smoothed_detrend_0_OMNI_HRO_1min_proton_density_smoothed_detrend',$
'comb_tshift_LANL-01A_avg_flux_sopa_esp_e_smoothed_detrend_0_LANL-97A_avg_flux_sopa_esp_e_smoothed_detrend_0',$
'comb_tshift_LANL-01A_avg_flux_sopa_esp_e_smoothed_detrend_0_1994-084_avg_flux_sopa_esp_e_smoothed_detrend_0',$
'comb_tshift_LANL-01A_avg_flux_sopa_esp_e_smoothed_detrend_0_rbspa_bmag_t89_diff_smoothed_detrend',$
'comb_tshift_LANL-01A_avg_flux_sopa_esp_e_smoothed_detrend_0_g13_dtc_cor_eflux_0_smoothed_detrend',$
'comb_tshift_LANL-01A_avg_flux_sopa_esp_e_smoothed_detrend_0_fspc_2K_smoothed_detrend',$
'comb_tshift_LANL-01A_avg_flux_sopa_esp_e_smoothed_detrend_0_LANL-04A_avg_flux_sopa_esp_e_smoothed_detrend_0',$
'comb_tshift_LANL-01A_avg_flux_sopa_esp_e_smoothed_detrend_0_rbspa_sloshing_distance_km',$
'comb_tshift_LANL-01A_avg_flux_sopa_esp_e_smoothed_detrend_0_rbspb_bmag_t89_diff_smoothed_detrend',$
'comb_tshift_LANL-01A_avg_flux_sopa_esp_e_smoothed_detrend_0_rbspa_Vx!CExB-drift!Ckm/s_detrend',$
'comb_tshift_LANL-01A_avg_flux_sopa_esp_e_smoothed_detrend_0_LANL-02A_avg_flux_sopa_esp_e_smoothed_detrend_0',$
'comb_tshift_LANL-01A_avg_flux_sopa_esp_e_smoothed_detrend_0_Bfield_hissinta_smoothed_detrend',$
'comb_tshift_LANL-01A_avg_flux_sopa_esp_e_smoothed_detrend_0_rbspa_density_smoothed_detrend',$
'comb_tshift_LANL-01A_avg_flux_sopa_esp_e_smoothed_detrend_0_tha_l2_fbk_spec_scm1_572Hz_smoothed_detrend',$
'comb_tshift_LANL-01A_avg_flux_sopa_esp_e_smoothed_detrend_0_Bfield_hissintb_smoothed_detrend']



;---------------------------------
;Sorted in order of max cc value
;fspc_2L_smoothed_detrend
;tshift =        50.269165 sec for maxcc value of       0.81528609

;fspc_2X_smoothed_detrend
;tshift =       -35.906372 sec for maxcc value of       0.79154383

;OMNI_HRO_1min_proton_density_smoothed_detrend
;tshift =       -67.402289 sec for maxcc value of       0.73432005

;LANL-97A_avg_flux_sopa_esp_e_smoothed_detrend_0
;tshift =        394.97314 sec for maxcc value of       0.68819623

;1994-084_avg_flux_sopa_esp_e_smoothed_detrend_0
;tshift =        236.98364 sec for maxcc value of       0.64877064

;rbspa_bmag_t89_diff_smoothed_detrend
;tshift =        208.25867 sec for maxcc value of       0.58319749

;g13_dtc_cor_eflux_0_smoothed_detrend
;tshift =        107.71973 sec for maxcc value of       0.55231323

;fspc_2K_smoothed_detrend
;tshift =        107.71973 sec for maxcc value of       0.54311518

;LANL-04A_avg_flux_sopa_esp_e_smoothed_detrend_0
;tshift =        567.32483 sec for maxcc value of       0.34314475

;rbspa_sloshing_distance_km
;tshift =       -21.544189 sec for maxcc value of       0.32582497

;rbspb_bmag_t89_diff_smoothed_detrend
;tshift =        265.70923 sec for maxcc value of       0.29323947

;rbspa_Vx!CExB-drift!Ckm/s_detrend
;tshift =        323.15979 sec for maxcc value of       0.24134476

;LANL-02A_avg_flux_sopa_esp_e_smoothed_detrend_0
;tshift =        107.71973 sec for maxcc value of       0.16472097

;Bfield_hissinta_smoothed_detrend
;tshift =       -179.53308 sec for maxcc value of      0.080947256

;rbspa_density_smoothed_detrend
;tshift =       -596.05042 sec for maxcc value of      0.069781811

;tha_l2_fbk_spec_scm1_572Hz_smoothed_detrend
;tshift =        208.25867 sec for maxcc value of      0.057971118

;Bfield_hissintb_smoothed_detrend
;tshift =        481.14929 sec for maxcc value of      0.036020994



;---------------------------------
;Sorted in order of delay (only those with significant cc values)

;OMNI_HRO_1min_proton_density_smoothed_detrend
;tshift =       -67.402289 sec for maxcc value of       0.73432005

;rbspa_sloshing_distance_km
;tshift =       -21.544189 sec for maxcc value of       0.32582497

;fspc_2L_smoothed_detrend
;tshift =        50.269165 sec for maxcc value of       0.81528609

;g13_dtc_cor_eflux_0_smoothed_detrend
;tshift =        107.71973 sec for maxcc value of       0.55231323
;fspc_2K_smoothed_detrend
;tshift =        107.71973 sec for maxcc value of       0.54311518
;LANL-02A_avg_flux_sopa_esp_e_smoothed_detrend_0
;tshift =        107.71973 sec for maxcc value of       0.16472097

;rbspa_bmag_t89_diff_smoothed_detrend
;tshift =        208.25867 sec for maxcc value of       0.58319749

;1994-084_avg_flux_sopa_esp_e_smoothed_detrend_0
;tshift =        236.98364 sec for maxcc value of       0.64877064

;rbspb_bmag_t89_diff_smoothed_detrend
;tshift =        265.70923 sec for maxcc value of       0.29323947

;rbspa_Vx!CExB-drift!Ckm/s_detrend
;tshift =        323.15979 sec for maxcc value of       0.24134476

;LANL-97A_avg_flux_sopa_esp_e_smoothed_detrend_0
;tshift =        394.97314 sec for maxcc value of       0.68819623

;LANL-04A_avg_flux_sopa_esp_e_smoothed_detrend_0
;tshift =        567.32483 sec for maxcc value of       0.34314475



;------------------------------------------------------------
;Use the time delays to determine propagation speed at L~6.6 

plds = ['01A','2X','G13','L084','L97A','L04A']
MLT_22UT = [10.7,14.2,16,18.4,22.2,2+24.]
L_22UT = [6.6,6.8,6.7,6.6,6.6,6.6]

;time delays relative to LANL-01A
dt = [0.,-36.,107.,237.,395.,567.]

;MLT hours relative to LANL-01A
MLT_rel = MLT_22UT - 10.7

;Arc length at 6.7 RE 
thetav = !dtor*360.*MLT_rel/24.
s = 6.6*thetav

plot,dt,s,psym=2


;From this I find max and min slopes of 
slope_max = 0.047  ;RE/sec
slope_min = 0.034  ;RE/sec

;In km/sec this is 
slope_max = 300  ;km/sec 
slope_min = 216  ;km/sec 

