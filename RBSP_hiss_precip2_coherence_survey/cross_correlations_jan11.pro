;Need to get tplot variables from paper_plot_jan10.pro first.

;Use BARREL 2X as a reference to calculate time delays of various quantities for the Jan10th, 2014 event near 22 UT.
;These are used to:
;--time-shift the data for pretty overlap plots (to see obvious correlation)
;--time-shift the data for input into the coherence spectrogram plots.


;This is nice to see the cc coefficients. However, I can get different tshifts for the various
;quantities on RBSPa. Should I then use the highest one (RBSPa B-Bmodel) to time-shift the others?
;Probably the best not to use cc values for timeshifts in the plots I present.

rbsp_efw_init
timespan,'2014-01-11'

smootime = 5.
dettime = 80.


folder_singlepayload2 = 'artemis'
th_sc = 'b'    ;'c'    ;Which ARTEMIS?
datapath = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/'
file_singlepayload2 = 'thb_ptotQ_values_campaign2.tplot'
tplotvar = 'th'+th_sc+'_peem_ptotQ'
tplot_restore,filename=datapath + folder_singlepayload2 + '/' + file_singlepayload2


rbsp_detrend,'thb_peem_ptotQ',60.*smootime
rbsp_detrend,'thb_peem_ptotQ_smoothed',60.*dettime


path = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/Analysis_major_events_campaign2/Jan11/'
tplot_restore,filename=path + 'jan11_tplot.tplot'

store_data,'*state*',/delete
store_data,'*Hz*',/delete
store_data,'*fbk*',/delete
store_data,'*ffp*',/delete
store_data,'*stack*',/delete
store_data,'*vaf*',/delete
store_data,'*fff*',/delete
store_data,'*edc12*',/delete
store_data,'*scm1*',/delete
store_data,'*coh*',/delete
store_data,'*phase*',/delete
store_data,'*wi_*',/del

load_barrel_lc,['2L','2K','2X'],type='rcnt'
rbsp_detrend,'PeakDet_2X',60.*smootime
rbsp_detrend,'PeakDet_2X_smoothed',60.*dettime

;Load EMFISIS B-Bmodel data
ptmp = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/Analysis_major_events_campaign2/Jan10/'
tplot_restore,filename=ptmp+'20140110-20140111_B-Bmodel_vars.tplot'
tplot,['rbspa_bmag_t89_diff','rbspb_bmag_t89_diff','rbspa_mag_mgse_t89_dif','rbspb_mag_mgse_t89_dif','rbspa_mag_gse_t89_dif','rbspb_mag_gse_t89_dif']
rbsp_detrend,'rbspa_bmag_t89_diff',60.*smootime & rbsp_detrend,'rbspa_bmag_t89_diff_smoothed',60.*dettime
rbsp_detrend,'rbspb_bmag_t89_diff',60.*smootime & rbsp_detrend,'rbspb_bmag_t89_diff_smoothed',60.*dettime
rbsp_detrend,'rbspa_mag_mgse_t89_dif',60.*smootime & rbsp_detrend,'rbspa_mag_mgse_t89_dif_smoothed',60.*dettime
rbsp_detrend,'rbspb_mag_mgse_t89_dif',60.*smootime & rbsp_detrend,'rbspb_mag_mgse_t89_dif_smoothed',60.*dettime
rbsp_detrend,'rbspa_mag_gse_t89_dif',60.*smootime & rbsp_detrend,'rbspa_mag_gse_t89_dif_smoothed',60.*dettime
rbsp_detrend,'rbspb_mag_gse_t89_dif',60.*smootime & rbsp_detrend,'rbspb_mag_gse_t89_dif_smoothed',60.*dettime


path = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/Analysis_major_events_campaign2/Jan10/'




;G14 data from Sam Califf
tplot_restore,filename=path + 'G14_bfield.tplot'
rbsp_detrend,'G14_bmag',60.*5.
rbsp_detrend,'G14_bmag_smoothed',60.*80.

thm_load_fgm,probe='d'



path = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/Analysis_major_events_campaign2/Jan11/'
fn = 'the_l2s_fgm_20140111000001_20140112235859.cdf'
cdf2tplot,path+fn
fn = 'thd_l2s_fgm_20140111000001_20140112235858.cdf'
cdf2tplot,path+fn



;Limiting the max tshift to +/-10 min

goes_load_data,datatype='fgm',probes='15'


;t0z = '2014-01-11/19:00:00'
;t1z = '2014-01-12/00:00'
t0z = '2014-01-11/21:00:00'
t1z = '2014-01-11/23:59'


split_vec,'LANL-01A_avg_flux_sopa_esp_e'
split_vec,'LANL-97A_avg_flux_sopa_esp_e'
split_vec,'LANL-04A_avg_flux_sopa_esp_e'
split_vec,'LANL-02A_avg_flux_sopa_esp_e'
split_vec,'1994-084_avg_flux_sopa_esp_e'
split_vec,'1991-080_avg_flux_sopa_esp_e'
split_vec,'g13_dtc_cor_eflux'
split_vec,'g15_dtc_cor_eflux'


rbsp_detrend,'LANL-01A_avg_flux_sopa_esp_e_0',60.*smootime
rbsp_detrend,'LANL-97A_avg_flux_sopa_esp_e_0',60.*smootime
rbsp_detrend,'LANL-04A_avg_flux_sopa_esp_e_0',60.*smootime
rbsp_detrend,'LANL-02A_avg_flux_sopa_esp_e_0',60.*smootime
rbsp_detrend,'1994-084_avg_flux_sopa_esp_e_0',60.*smootime
rbsp_detrend,'1991-080_avg_flux_sopa_esp_e_0',60.*smootime
rbsp_detrend,'g13_dtc_cor_eflux_0',60.*smootime
rbsp_detrend,'g15_dtc_cor_eflux_0',60.*smootime
rbsp_detrend,'thd_fgl_btotalQ',60.*smootime
rbsp_detrend,'the_fgl_btotalQ',60.*smootime

rbsp_detrend,'LANL-01A_avg_flux_sopa_esp_e_0_smoothed',60.*dettime
rbsp_detrend,'LANL-97A_avg_flux_sopa_esp_e_0_smoothed',60.*dettime
rbsp_detrend,'LANL-04A_avg_flux_sopa_esp_e_0_smoothed',60.*dettime
rbsp_detrend,'LANL-02A_avg_flux_sopa_esp_e_0_smoothed',60.*dettime
rbsp_detrend,'1994-084_avg_flux_sopa_esp_e_0_smoothed',60.*dettime
rbsp_detrend,'1991-080_avg_flux_sopa_esp_e_0',60.*dettime
rbsp_detrend,'g13_dtc_cor_eflux_0_smoothed',60.*dettime
rbsp_detrend,'g15_dtc_cor_eflux_0_smoothed',60.*dettime
rbsp_detrend,'thd_fgl_btotalQ_smoothed',60.*smootime
rbsp_detrend,'the_fgl_btotalQ_smoothed',60.*smootime





vars = ['OMNI_HRO_1min_proton_density_smoothed_detrend',$
'LANL-97A_avg_flux_sopa_esp_e_0_smoothed_detrend',$
'PeakDet_2X_smoothed_detrend',$
'thb_peem_ptotQ_smoothed_detrend',$
'PeakDet_2L_smoothed_detrend',$
'PeakDet_2K_smoothed_detrend',$
'LANL-01A_avg_flux_sopa_esp_e_0_smoothed_detrend',$
'1994-084_avg_flux_sopa_esp_e_0_smoothed_detrend',$
'1991-080_avg_flux_sopa_esp_e_0_smoothed_detrend',$
'LANL-04A_avg_flux_sopa_esp_e_0_smoothed_detrend',$
'LANL-02A_avg_flux_sopa_esp_e_0_smoothed_detrend',$
'g13_dtc_cor_eflux_0_smoothed_detrend',$
'g15_dtc_cor_eflux_0_smoothed_detrend',$
'G14_bmag_smoothed_detrend',$
'rbspa_bmag_t89_diff_smoothed_detrend',$
'rbspb_bmag_t89_diff_smoothed_detrend',$
'thd_fgl_btotalQ_smoothed_detrend',$
'the_fgl_btotalQ_smoothed_detrend']




ccvals = fltarr(n_elements(vars))
tshiftv = fltarr(n_elements(vars))
tshift = 0.
maxcc = 0.


;First interpolate all the times to the reference variable (2X)
for i=0,n_elements(vars)-1 do tinterpol_mxn,vars[i],vars[0],/ignore_nans
;tinterpol_mxn,vars[2],vars[0],/ignore_nans


for i=0,n_elements(vars)-1 do begin cross_correlation_normalized_plot,vars[0]+'_interp',vars[i]+'_interp',t0z,t1z,mincc=0.,tshift=tshift,maxcc=maxcc & tshiftv[i] = tshift & ccvals[i] = maxcc
;cross_correlation_normalized_plot,vars[0]+'_interp',vars[0]+'_interp',t0z,t1z,mincc=0.,tshift=tshift,maxcc=maxcc

ccgoo = sort(ccvals)
ccvals2 = reverse(ccvals[ccgoo])
tshiftv2 = reverse(tshiftv[ccgoo])
vars2 = reverse(vars[ccgoo])

for i=0,n_elements(vars)-1 do print,vars2[i], ccvals2[i], tshiftv2[i]/60.,format='(A50,10x,f8.4,10x,f10.4)'
;Output from cross-correlation                                  cc              tshift

;OMNI_HRO_1min_proton_density_smoothed_detrend            0.9018             -2.0000
;LANL-02A_avg_flux_sopa_esp_e_0_smoothed_detrend            0.7181           -154.0000
;LANL-01A_avg_flux_sopa_esp_e_0_smoothed_detrend            0.7159           -130.0000
;                    G14_bmag_smoothed_detrend            0.6878              2.0000
;              thb_peem_ptotQ_smoothed_detrend            0.6688             18.0000
;LANL-04A_avg_flux_sopa_esp_e_0_smoothed_detrend            0.6441           -166.0000
;                  PeakDet_2X_smoothed_detrend            0.6271             -6.0000
;                  PeakDet_2L_smoothed_detrend            0.5745             -2.0000
;LANL-97A_avg_flux_sopa_esp_e_0_smoothed_detrend            0.5012              6.0000
;         rbspb_bmag_t89_diff_smoothed_detrend            0.4888              6.0000
;                  PeakDet_2K_smoothed_detrend            0.4781           -114.0000
         rbspa_bmag_t89_diff_smoothed_detrend            0.4513           -186.0000
         g13_dtc_cor_eflux_0_smoothed_detrend            0.4470            -54.0000
         g15_dtc_cor_eflux_0_smoothed_detrend            0.4281           -174.0000
1994-084_avg_flux_sopa_esp_e_0_smoothed_detrend            0.2975              6.0000
             thd_fgl_btotalQ_smoothed_detrend            0.2782             10.0000
             the_fgl_btotalQ_smoothed_detrend            0.1489              2.0000

             OMNI_HRO_1min_proton_density_smoothed_detrend            1.0000              0.0000
                           thb_peem_ptotQ_smoothed_detrend            0.8024             16.0000
                                 G14_bmag_smoothed_detrend            0.7927              4.0000
                               PeakDet_2X_smoothed_detrend            0.6544             -8.0000
                               PeakDet_2L_smoothed_detrend            0.5987              0.0000
           LANL-97A_avg_flux_sopa_esp_e_0_smoothed_detrend            0.5798              4.0000
                      rbspa_bmag_t89_diff_smoothed_detrend            0.5425            -72.0000
                      rbspb_bmag_t89_diff_smoothed_detrend            0.5400              4.0000
                      g13_dtc_cor_eflux_0_smoothed_detrend            0.4982              4.0000
                      g15_dtc_cor_eflux_0_smoothed_detrend            0.4756             -4.0000
                               PeakDet_2K_smoothed_detrend            0.4704            -60.0000
           LANL-01A_avg_flux_sopa_esp_e_0_smoothed_detrend            0.4697            -64.0000
           LANL-02A_avg_flux_sopa_esp_e_0_smoothed_detrend            0.4679            -84.0000
           LANL-04A_avg_flux_sopa_esp_e_0_smoothed_detrend            0.4562            -88.0000
           1994-084_avg_flux_sopa_esp_e_0_smoothed_detrend            0.3750              4.0000
                          thd_fgl_btotalQ_smoothed_detrend            0.2684              8.0000
                          the_fgl_btotalQ_smoothed_detrend            0.2109              0.0000






















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
