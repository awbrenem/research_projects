;LKX at ~16-22 UT on Jan 10, 2014

;Narrative: Substorm injections create sufficient precipitation to be observed on BARREL 
;after around 15 UT. During this time we see some modulations of precipitation related
;to SW pressure dynamic pressure and magnetic field. 
;May be SW “magic” freqs (25 min, 0.7 mHz)
;The VARIATION of the dynamic pressure occurs mainly due to density fluctuations

;also see Jan10_event.ppt


;pro event_analysis_jan10
  rbsp_efw_init
  tplot_options,'title','event_analysis_jan10.pro'

	tplot_options,'xmargin',[20.,16.]
	tplot_options,'ymargin',[3,9]
	tplot_options,'xticklen',0.08
	tplot_options,'yticklen',0.02
	tplot_options,'xthick',2
	tplot_options,'ythick',2
	tplot_options,'labflag',-1	
	
  pre = '2'
  timespan,'2014-01-10'

;Produce some useful tplot variables
;Set up this routine with the correct variables. 
args_manual = {combo:'LX',$
               pre:'2',$
               fspc:1,$
               datapath:'/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/',$
               folder_plots:'barrel_missionwide_plots',$
               folder_coh:'coh_vars_barrelmission2',$
               folder_singlepayload:'folder_singlepayload',$
               pmin:10*60.,$
               pmax:60*60.}

fntmp = 'all_coherence_plots_combined_omni_press_dyn.tplot'
tplot_restore,filenames='/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/'+'coh_vars_barrelmission'+pre+'/'+fntmp
fntmp = 'all_coherence_plots_combined.tplot'
tplot_restore,filenames='/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/'+'coh_vars_barrelmission'+pre+'/'+fntmp


;Restore individual payload FSPC data
path = args_manual.datapath + args_manual.folder_singlepayload + '/'
fn = 'barrel_2K_fspc_fullmission.tplot' & tplot_restore,filenames=path + fn
fn = 'barrel_2L_fspc_fullmission.tplot' &  tplot_restore,filenames=path + fn
fn = 'barrel_2X_fspc_fullmission.tplot' & tplot_restore,filenames=path + fn
fn = 'barrel_2W_fspc_fullmission.tplot' & tplot_restore,filenames=path + fn
fn = 'barrel_2T_fspc_fullmission.tplot' & tplot_restore,filenames=path + fn

;Restore individual coherence spectra
path = args_manual.datapath + args_manual.folder_coh + '/'
fn = 'KL_meanfilter.tplot' & tplot_restore,filenames=path + fn
fn = 'KX_meanfilter.tplot' & tplot_restore,filenames=path + fn
fn = 'WK_meanfilter.tplot' & tplot_restore,filenames=path + fn
fn = 'TK_meanfilter.tplot' & tplot_restore,filenames=path + fn
fn = 'LX_meanfilter.tplot' & tplot_restore,filenames=path + fn
fn = 'WL_meanfilter.tplot' & tplot_restore,filenames=path + fn
fn = 'TL_meanfilter.tplot' & tplot_restore,filenames=path + fn
fn = 'WX_meanfilter.tplot' & tplot_restore,filenames=path + fn
fn = 'TX_meanfilter.tplot' & tplot_restore,filenames=path + fn
fn = 'TW_meanfilter.tplot' & tplot_restore,filenames=path + fn


tnt = tnames('coh_??_meanfilter')
for i=0,n_elements(tnt)-1 do options,tnt[i],'ytitle', strmid(tnt[i],4,2)


fntmp = 'all_coherence_plots_combined_omni_press_dyn.tplot'
tplot_restore,filenames='/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/'+'coh_vars_barrelmission'+pre+'/'+fntmp
fntmp = 'all_coherence_plots_combined.tplot'
tplot_restore,filenames='/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/'+'coh_vars_barrelmission'+pre+'/'+fntmp


tplot,['coh_allcombos_meanfilter_normalized2','coh_allcombos_meanfilter_normalized2_OMNI_press_dyn','coh_??_meanfilter']





rbsp_detrend,'fspc_2?',5.*60.
rbsp_detrend,'fspc_2?_smoothed',60.*80.

tplot,'fspc_2?_smoothed_detrend'

stop


;--------------------------------------------------
;Load specific BARREL channels
;--------------------------------------------------

load_barrel_lc,'2X',type='fspc'

rbsp_detrend,['FSPC1a_2X','FSPC1b_2X','FSPC1c_2X','FSPC2_2X','FSPC3_2X','FSPC4_2X'],60.*5.
rbsp_detrend,['FSPC1a_2X','FSPC1b_2X','FSPC1c_2X','FSPC2_2X','FSPC3_2X','FSPC4_2X']+'_smoothed',60.*80.
tplot,['FSPC1a_2X','FSPC1b_2X','FSPC1c_2X','FSPC2_2X','FSPC3_2X','FSPC4_2X']+'_smoothed_detrend'

load_barrel_lc,'2X',type='rcnt'
load_barrel_lc,'2X',type='mspc'
load_barrel_lc,'2X',type='sspc'


;---------------------------------------------------
;Plot LANL sat observations
;---------------------------------------------------


pp = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/Analysis_major_events_campaign2/Jan10/'

tplot_restore,filenames=pp+'lanl_sat_1991-080_20140110.tplot'
tplot_restore,filenames=pp+'lanl_sat_1994-084_20140110.tplot'
tplot_restore,filenames=pp+'lanl_sat_LANL-01A_20140110.tplot'
tplot_restore,filenames=pp+'lanl_sat_LANL-02A_20140110.tplot'
tplot_restore,filenames=pp+'lanl_sat_LANL-04A_20140110.tplot'
tplot_restore,filenames=pp+'lanl_sat_LANL-97A_20140110.tplot'


split_vec,'1991-080_avg_flux_sopa_e'
split_vec,'1994-084_avg_flux_sopa_e'
split_vec,'LANL-01A_avg_flux_sopa_e'
split_vec,'LANL-02A_avg_flux_sopa_e'
split_vec,'LANL-04A_avg_flux_sopa_e'
split_vec,'LANL-97A_avg_flux_sopa_e'


rbsp_detrend,'*avg_flux_sopa_e_0',60.*5.
rbsp_detrend,'*avg_flux_sopa_e_0_smoothed',60.*80.

rbsp_detrend,'*avg_flux_sopa_e_?',60.*5.
rbsp_detrend,'*avg_flux_sopa_e_?_smoothed',60.*80.



ylim,'*avg_flux_sopa_e_0_smoothed',0,5d4,0
tplot,['*avg_flux_sopa_e_0_smoothed_detrend','fspc_'+pre+'L_smoothed']
tplot,['*avg_flux_sopa_e_0','fspc_'+pre+'L_smoothed']


split_vec,'1991-080_avg_flux_esp_e'
split_vec,'1994-084_avg_flux_esp_e'
split_vec,'LANL-01A_avg_flux_esp_e'
split_vec,'LANL-02A_avg_flux_esp_e'
split_vec,'LANL-04A_avg_flux_esp_e'
split_vec,'LANL-97A_avg_flux_esp_e'



rbsp_detrend,'*avg_flux_esp_e_0',60.*5.
rbsp_detrend,'*avg_flux_esp_e_0_smoothed',60.*80.

ylim,'*avg_flux_esp_e_0_smoothed',1d0,1d5,0
tplot,['*avg_flux_esp_e_0_smoothed_detrend','fspc_'+pre+'L_smoothed']
tplot,['*avg_flux_esp_e_0_smoothed','fspc_'+pre+'L_smoothed']


split_vec,'1991-080_avg_flux_i'
split_vec,'1994-084_avg_flux_i'
split_vec,'LANL-01A_avg_flux_i'
split_vec,'LANL-02A_avg_flux_i'
split_vec,'LANL-04A_avg_flux_i'
split_vec,'LANL-97A_avg_flux_i'

rbsp_detrend,'*flux_i_?',60.*2.
rbsp_detrend,'*flux_i_?_smoothed',60.*80.

ylim,'*flux_i_0_smoothed_detrend',-10000,10000
tplot,'*flux_i_0_smoothed_detrend'






;--------------------------------------------------------------
;Load RBSP FFT data
;--------------------------------------------------------------
path = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/Analysis_major_events_campaign2/Jan10/'



;Load density 
fn = 'rbspa_efw-l3_20140110_v01.cdf' & cdf2tplot,path+fn
copy_data,'density','rbspa_density10'
fn = 'rbspa_efw-l3_20140111_v01.cdf' & cdf2tplot,path+fn
copy_data,'density','rbspa_density11'

get_data,'rbspa_density10',data=d10
get_data,'rbspa_density11',data=d11
store_data,'rbspa_density',[d10.x,d11.x],[d10.y,d11.y]

fn = 'rbspb_efw-l3_20140110_v01.cdf' & cdf2tplot,path+fn
copy_data,'density','rbspb_density10'
fn = 'rbspb_efw-l3_20140111_v01.cdf' & cdf2tplot,path+fn
copy_data,'density','rbspb_density11'

get_data,'rbspb_density10',data=d10
get_data,'rbspb_density11',data=d11
store_data,'rbspb_density',[d10.x,d11.x],[d10.y,d11.y]



rbsp_detrend,'rbsp?_density',60.*smootime
;rbsp_detrend,'rbsp?_density_smoothed',60.*dettime
rbsp_detrend,'rbsp?_density_smoothed',60.*40

tlimit,'2014-01-10/19:30','2014-01-11/02:30'
tplot,['omni_press_dyn_smoothed_detrend','rbsp?_density_smoothed_detrend']

;Load EMFISIS B-Bmodel data
tplot_restore,filename=ptmp+'20140110-20140111_B-Bmodel_vars.tplot'
tplot,['rbspa_bmag_t89_diff','rbspb_bmag_t89_diff','rbspa_mag_mgse_t89_dif','rbspb_mag_mgse_t89_dif','rbspa_mag_gse_t89_dif','rbspb_mag_gse_t89_dif']
rbsp_detrend,'rbspa_bmag_t89_diff',60.*smootime & rbsp_detrend,'rbspa_bmag_t89_diff_smoothed',60.*dettime
rbsp_detrend,'rbspb_bmag_t89_diff',60.*smootime & rbsp_detrend,'rbspb_bmag_t89_diff_smoothed',60.*dettime
rbsp_detrend,'rbspa_mag_mgse_t89_dif',60.*smootime & rbsp_detrend,'rbspa_mag_mgse_t89_dif_smoothed',60.*dettime
rbsp_detrend,'rbspb_mag_mgse_t89_dif',60.*smootime & rbsp_detrend,'rbspb_mag_mgse_t89_dif_smoothed',60.*dettime
rbsp_detrend,'rbspa_mag_gse_t89_dif',60.*smootime & rbsp_detrend,'rbspa_mag_gse_t89_dif_smoothed',60.*dettime
rbsp_detrend,'rbspb_mag_gse_t89_dif',60.*smootime & rbsp_detrend,'rbspb_mag_gse_t89_dif_smoothed',60.*dettime



;;Load EMFISIS 
;rbsp_load_emfisis,probe='a',level='l3',coord='gsm'
;rbsp_load_emfisis,probe='b',level='l3',coord='gsm'


;;Remove data spikes 
;get_data,'rbspa_emfisis_l3_4sec_gsm_Magnitude',data=tt 
;goo = where(tt.y lt 0.) 
;tt.y[goo] = !values.f_nan
;store_data,'rbspa_emfisis_l3_4sec_gsm_Magnitude',data=tt 
;
;get_data,'rbspb_emfisis_l3_4sec_gsm_Magnitude',data=tt 
;goo = where(tt.y lt 0.) 
;tt.y[goo] = !values.f_nan
;store_data,'rbspb_emfisis_l3_4sec_gsm_Magnitude',data=tt 



fn = 'rbspa_efw-l2_spec_20140110_v01.cdf'
cdf2tplot,path+fn

copy_data,'spec64_scmu','rbspa_spec64_scmu'
copy_data,'spec64_scmv','rbspa_spec64_scmv'
copy_data,'spec64_scmw','rbspa_spec64_scmw'
trange = timerange()
fcals = rbsp_efw_get_gain_results()
fbinsL = fcals.cal_spec.freq_spec64L
fbinsH = fcals.cal_spec.freq_spec64H
bandw = fbinsH - fbinsL


get_data,'rbspa_spec64_scmu',data=bu2
get_data,'rbspa_spec64_scmv',data=bv2
get_data,'rbspa_spec64_scmw',data=bw2
bu2.y[*,0:11] = 0.
bv2.y[*,0:11] = 0.
bw2.y[*,0:11] = 0.
bu2.y[*,45:63] = 0.
bv2.y[*,45:63] = 0.
bw2.y[*,45:63] = 0.
nelem = n_elements(bu2.x)
bt = fltarr(nelem)
;Add up amplitude in all 64 bins and multiply each bin by a bandwidth
ball = bu2.y + bv2.y + bw2.y
for j=0L,nelem-1 do bt[j] = sqrt(total(ball[j,*]*bandw))  ;RMS method (Malaspina's method)
store_data,'Bfield_hissinta',data={x:bu2.x,y:bt}
tplot,'Bfield_hissinta'



fn = 'rbspb_efw-l2_spec_20140110_v01.cdf'
cdf2tplot,path+fn
copy_data,'spec64_scmu','rbspb_spec64_scmu'
copy_data,'spec64_scmv','rbspb_spec64_scmv'
copy_data,'spec64_scmw','rbspb_spec64_scmw'

get_data,'rbspb_spec64_scmu',data=bu2
get_data,'rbspb_spec64_scmv',data=bv2
get_data,'rbspb_spec64_scmw',data=bw2
bu2.y[*,0:11] = 0.
bv2.y[*,0:11] = 0.
bw2.y[*,0:11] = 0.
bu2.y[*,45:63] = 0.
bv2.y[*,45:63] = 0.
bw2.y[*,45:63] = 0.
nelem = n_elements(bu2.x)
bt = fltarr(nelem)
;Add up amplitude in all 64 bins and multiply each bin by a bandwidth
ball = bu2.y + bv2.y + bw2.y
for j=0L,nelem-1 do bt[j] = sqrt(total(ball[j,*]*bandw))  ;RMS method (Malaspina's method)
store_data,'Bfield_hissintb',data={x:bu2.x,y:bt}
tplot,'Bfield_hissintb'


rbsp_detrend,'Bfield_hissint?',60.*2.
rbsp_detrend,'Bfield_hissint?_smoothed',60.*80.
options,'spec64_scm','spec',1
zlim,'rbsp?_spec64_scm?',1d-9,1d-5,1
ylim,'rbsp?_spec64_scmw',30,1000,1
ylim,'fspc_2W_smoothed',35,55
ylim,'fspc_2K_smoothed',30,80
ylim,'fspc_2X_smoothed',30,60
tplot,['coh_allcombos_meanfilter_normalized2','rbsp?_spec64_scmw','Bfield_hissint?_smoothed_detrend','fspc_2K_smoothed_detrend','fspc_2L_smoothed_detrend','fspc_2X_smoothed_detrend']
tplot,['coh_allcombos_meanfilter_normalized2','rbsp?_spec64_scmw','Bfield_hissint?_smoothed','fspc_2K_smoothed','fspc_2L_smoothed','fspc_2X_smoothed']


;Try to detrend the magnetic field data...tricky..
rbsp_detrend,'rbsp?_emfisis_l3_4sec_gsm_Magnitude',60.*80.
dif_data,'rbspa_emfisis_l3_4sec_gsm_Magnitude_smoothed','rbspa_emfisis_l3_4sec_gsm_Magnitude',newname='rbspa_mag_diff'
dif_data,'rbspb_emfisis_l3_4sec_gsm_Magnitude_smoothed','rbspb_emfisis_l3_4sec_gsm_Magnitude',newname='rbspb_mag_diff'


;get_data,'rbspa_mag_diff',data=tt
;goo = where(tt.x ge time_double('2014-01-04/19:10'))
;tt.y[0:goo[0]] = !values.f_nan
;store_data,'rbspa_mag_diff2',data=tt
;tplot,['rbspa_mag_diff2']

rbsp_detrend,'rbsp?_mag_diff',60.*2.
ylim,'rbsp?_mag_diff_smoothed',-10,30
tplot,'rbsp?_mag_diff_smoothed'




rbsp_detrend,'rbsp?_density',60.*5.
rbsp_detrend,'rbsp?_density_smoothed',60.*80.
ylim,'rbspa_density_smoothed_detrend',0,0;-50,30
ylim,'rbspb_density_smoothed_detrend',0,0;-50,50
ylim,'rbsp?_emfisis_l3_4sec_gsm_Magnitude_smoothed_detrend',-20,20
ylim,'rbsp?_emfisis_l3_4sec_gsm_Magnitude_smoothed',50,250
ylim,'rbsp?_emfisis_l3_4sec_gsm_Magnitude',150,200
ylim,'rbsp?_mag_diff_smoothed',-2,10
tplot,['Bfield_hissint?_smoothed_detrend','fspc_2?_smoothed','rbsp?_density_smoothed_detrend','rbsp?_mag_diff_smoothed']




;---------------------------------------------------------------------------------------
;Calculate ExB drift motion of plasma 
;---------------------------------------------------------------------------------------

;cdf2tplot,ptmp+'rbsp-b_magnetometer_4sec-gse_emfisis-L3_20140110_v1.3.2.cdf'

;Load EFW electric field to find the azimuthal Efield. Will use to calculate radial ExB motion 
;of particles. 

cdf2tplot,ptmp + 'rbspa_efw-l3_20140110_v01.cdf'
copy_data,'efield_inertial_frame_mgse','rbspa_efield_inertial_frame_mgse10'
cdf2tplot,ptmp + 'rbspa_efw-l3_20140111_v01.cdf'
copy_data,'efield_inertial_frame_mgse','rbspa_efield_inertial_frame_mgse11'
get_data,'rbspa_efield_inertial_frame_mgse10',data=d1
get_data,'rbspa_efield_inertial_frame_mgse11',data=d2
store_data,'rbspa_efield_inertial_frame_mgse',[d1.x,d2.x],[d1.y,d2.y]
rbsp_detrend,'rbspa_efield_inertial_frame_mgse',60.*smootime 
rbsp_detrend,'rbspa_efield_inertial_frame_mgse_smoothed',60.*dettime 

cdf2tplot,ptmp + 'rbspb_efw-l3_20140110_v01.cdf'
copy_data,'efield_inertial_frame_mgse','rbspb_efield_inertial_frame_mgse10'
cdf2tplot,ptmp + 'rbspb_efw-l3_20140111_v01.cdf'
copy_data,'efield_inertial_frame_mgse','rbspb_efield_inertial_frame_mgse11'
get_data,'rbspb_efield_inertial_frame_mgse10',data=d1
get_data,'rbspb_efield_inertial_frame_mgse11',data=d2
store_data,'rbspb_efield_inertial_frame_mgse',[d1.x,d2.x],[d1.y,d2.y]
rbsp_detrend,'rbspb_efield_inertial_frame_mgse',60.*smootime 
rbsp_detrend,'rbspb_efield_inertial_frame_mgse_smoothed',60.*dettime 

store_data,['rbsp?_efield_inertial_frame_mgse10','rbsp?_efield_inertial_frame_mgse11'],/del

tplot,['rbspa_efield_inertial_frame_mgse_smoothed_detrend','rbspb_efield_inertial_frame_mgse_smoothed_detrend']





;--------------------------------------------------------------
;Load OMNI SW data
;--------------------------------------------------------------


t0tmp = time_double('2014-01-10/00:00')
t1tmp = time_double('2014-01-11/00:00')
;plot_omni_quantities,/noplot,t0avg=t0tmp,t1avg=t1tmp
plot_omni_quantities,t0avg=t0tmp,t1avg=t1tmp

rbsp_detrend,'OMNI_HRO_1min_proton_density',60.*5.
rbsp_detrend,'OMNI_HRO_1min_proton_density_smoothed',60.*80.


tplot,['kyoto_ae','coh_allcombos_meanfilter_normalized2','coh_allcombos_meanfilter_normalized_OMNI_press_dyn','fspc_2L_smoothed_detrend','fspc_2X_smoothed_detrend','coh_LX_meanfilter'],/add




;Looks like the VARIATION of the dynamic pressure occurs because of the density fluctuations
tplot,'omni_pressure_dyn_compare'



;tplot,['omni_Np','omni_elect_density']+'_smoothed_detrend'
tplot,['coh_allcombos_meanfilter_normalized2','coh_allcombos_meanfilter_normalized_OMNI_press_dyn','omni_press_dyn_smoothed_detrend','fspc_2?_smoothed_detrend']


;^^Test IMF Bz 
tplot,['OMNI_HRO_1min_B?_GSM']
tplot,['fspc_comb_LX'],/add

;^^Check Vsw flow speed 
tplot,'OMNI_HRO_1min_flow_speed'
tplot,['fspc_comb_LX'],/add

;^^Check solar wind density
tplot,'OMNI_HRO_1min_proton_density'


tplot,['IMF_orientation_comb','Bz_rat_comb','clockangle_comb','coneangle_comb']
tplot,['clockangle_comb','coneangle_comb','kyoto_ae','kyoto_dst','OMNI_HRO_1min_flow_speed']
tplot,'coh_KL_meanfilter',/add

;---------------------------------------
;Plot location of balloon payloads
;---------------------------------------

plot_dial_payload_location_specific_time,'2014-01-10/23:00'
plot_dial_payload_location_specific_time,'2014-01-10/20:00'


;-----------------------------------------------
;LOAD THEMIS DATA 
;-----------------------------------------------

ptmp = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/Analysis_major_events_campaign2/Jan10/'

cdf2tplot,ptmp+'tha_l2s_scm_20140109120000_20140111115959.cdf'
cdf2tplot,ptmp+'tha_l2s_fgm_20140109120000_20140111115957.cdf'
cdf2tplot,ptmp+'the_l2s_fgm_20140110000000_20140111235957.cdf'
cdf2tplot,ptmp+'thd_l2s_fgm_20140110000001_20140111235957.cdf'
cdf2tplot,ptmp+'thc_l2s_fgm_20140110000002_20140111235956.cdf'
cdf2tplot,ptmp+'thb_l2s_fgm_20140110000000_20140111235959.cdf'
cdf2tplot,ptmp+'tha_l2s_fgm_20140110000001_20140110235958.cdf'


rbsp_detrend,'th?_fgs_btotalQ',60.*smootime
rbsp_detrend,'th?_fgs_btotalQ_smoothed',60.*50.

;;detrend THa at a shorter time b/c it's so close to perigee 
;rbsp_detrend,'tha_fgs_btotalQ',60.*smootime
;rbsp_detrend,'tha_fgs_btotalQ_smoothed',60.*50.

ylim,['thb_fgs_btotalQ_smoothed_detrend','thc_fgs_btotalQ_smoothed_detrend'],-1,1
ylim,['thd_fgs_btotalQ_smoothed_detrend'],-4,1
ylim,['tha_fgs_btotalQ_smoothed_detrend'],-10,3
tplot,['OMNI_HRO_1min_proton_density_smoothed_detrend',$
'tha_fgs_btotalQ_smoothed_detrend',$
'thb_fgs_btotalQ_smoothed_detrend',$
'thc_fgs_btotalQ_smoothed_detrend',$
'thd_fgs_btotalQ_smoothed_detrend',$
'the_fgs_btotalQ_smoothed_detrend']



;Filterbank data 
cdf2tplot,ptmp+'tha_l1_fbk_20140110_v01.cdf'
cdf2tplot,ptmp+'tha_l2_fbk_20140110_v01.cdf'
;tha_l2_fbk_20140111_v01.cdf


;Read THA FBK data (saved to a .dat file from Autoplot...cdf2tplot won't work for these)
fn = 'tha_l2_fbk_spec_20140110_edc12.dat'
read_themis_dat_spec_files,ptmp+fn,tvarname='tha_l2_fbk_spec_edc12'
tplot,'tha_l2_fbk_spec_edc12'




cdf2tplot,ptmp+'tha_l2_efi_20140110_v01.cdf'
cdf2tplot,ptmp+'tha_l2_fgm_20140110_v01.cdf'
cdf2tplot,ptmp+'tha_l2_mom_20140110_v01.cdf'
cdf2tplot,ptmp+'thb_l2_efi_20140110_v01.cdf'
cdf2tplot,ptmp+'thb_l2_fgm_20140110_v01.cdf'
cdf2tplot,ptmp+'thb_l2_mom_20140110_v01.cdf'
cdf2tplot,ptmp+'thc_l2_efi_20140110_v01.cdf'
cdf2tplot,ptmp+'thc_l2_fgm_20140110_v01.cdf'
cdf2tplot,ptmp+'thc_l2_mom_20140110_v01.cdf'
cdf2tplot,ptmp+'thd_l2_efi_20140110_v01.cdf'
cdf2tplot,ptmp+'thd_l2_fgm_20140110_v01.cdf'
cdf2tplot,ptmp+'thd_l2_mom_20140110_v01.cdf'
cdf2tplot,ptmp+'the_l2_efi_20140110_v01.cdf'
cdf2tplot,ptmp+'the_l2_fgm_20140110_v01.cdf'
cdf2tplot,ptmp+'the_l2_mom_20140110_v01.cdf'


rbsp_detrend,'th?_????_density',60.*5.
rbsp_detrend,'th?_????_density_smoothed',60.*30.
tplot,'thb_????_density_smoothed'


tplot,['thb_peim_density_smoothed','thb_peim_ptot_smoothed']+'_detrend'




rbsp_detrend,'th?_????_ptot',60.*5.
rbsp_detrend,['th?_????_ptot']+'_smoothed',60.*80.
tplot,['thc_peem_ptot','thc_peim_ptot']+'_smoothed_detrend'
tplot,'fspc_2?_smoothed_detrend',/add
tplot,'omni_press_dyn_smoothed_detrend',/add



tplot,['omni_press_dyn_smoothed_detrend','thb_peem_density_smoothed_detrend','thc_peem_density_smoothed_detrend',$
'fspc_2?_smoothed_detrend']


rbsp_detrend,['thb_fgs_btotal','thc_fgs_btotal'],60.*5.
rbsp_detrend,['thb_fgs_btotal','thc_fgs_btotal']+'_smoothed',60.*80.
tplot,['omni_press_dyn_smoothed_detrend','thb_fgs_btotal_smoothed_detrend','thc_fgs_btotal_smoothed_detrend','fspc_2X_smoothed_detrend']


;----------------------------------------------------
;Figure out if THEMIS is in SW or in magnetosheath 

get_data,'thc_peem_velocity_mag',tt,vv 
store_data,'thc_peem_velocity_magnitude',tt,sqrt(vv[*,0]^2 + vv[*,1]^2 + vv[*,2]^2)

;put on OMNI resolution 
rbsp_detrend,'thc_peem_velocity_magnitude',60.

tplot,['thc_peem_velocity_magnitude_smoothed','OMNI_HRO_1min_flow_speed']



get_data,'OMNI_HRO_1min_BX_GSE',tt,bx
get_data,'OMNI_HRO_1min_BY_GSE',tt,by
get_data,'OMNI_HRO_1min_BZ_GSE',tt,bz
store_data,'OMNI_HRO_1min_BGSE',tt,[[bx],[by],[bz]]

get_data,'OMNI_HRO_1min_Vx',tt,vx
get_data,'OMNI_HRO_1min_Vy',tt,vy
get_data,'OMNI_HRO_1min_Vz',tt,vz
store_data,'OMNI_HRO_1min_VGSE',tt,[[vx],[vy],[vz]]


ylim,['thc_eesa_solarwind_flag','thc_iesa_solarwind_flag'],-2,2
tplot,['omni_press_dyn','thc_peim_ptot','OMNI_HRO_1min_BGSE','thc_fgs_gse','thc_fgs_btotal','OMNI_HRO_1min_proton_density','thc_peim_density','OMNI_HRO_1min_VGSE','thc_peim_velocity_gse','thc_eesa_solarwind_flag','thc_iesa_solarwind_flag']

ylim,['thb_eesa_solarwind_flag','thb_iesa_solarwind_flag'],-2,2
tplot,['omni_press_dyn','thb_peim_ptot','OMNI_HRO_1min_BGSE','thb_fgs_gse','thb_fgs_btotal','OMNI_HRO_1min_proton_density','thb_peim_density','OMNI_HRO_1min_VGSE','thb_peim_velocity_gse','thb_eesa_solarwind_flag','thb_iesa_solarwind_flag']


tplot,['OMNI_HRO_1min_VGSE','thc_peim_velocity_gse']



;--------------------------------------------------
;Load Wind data. 
;--------------------------------------------------


;load Wind magnetic field data
wi_mfi_load
get_data,'wi_h0_mfi_B3GSE',ttmp,bo
bmag = sqrt(bo[*,0]^2+bo[*,1]^2+bo[*,2]^2)
store_data,'wi_h0_mfi_bmag',ttmp,bmag

;load Wind particle data
path = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip/wind/barrel_mission2/'
fn = 'wi_ems_3dp_20131225000000_20140214235958.cdf'
cdf2tplot,files=path+fn
fn = 'wi_k0s_3dp_20131225000105_20140214235952.cdf'
cdf2tplot,files=path+fn
fn = 'wi_k0s_3dp_20131225000105_20140214235952.cdf'
cdf2tplot,files=path+fn
fn = 'wi_k0s_swe_20131225000105_20140214235829.cdf'
cdf2tplot,files=path+fn
fn = 'wi_pms_3dp_20131225000002_20140215000000.cdf'
cdf2tplot,files=path+fn



paath = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/wind/'
cdf2tplot,paath+'wi_ems_3dp_20131225000000_20140220235958.cdf'
cdf2tplot,paath+'wi_pms_3dp_20131225000002_20140221000000.cdf'
cdf2tplot,paath+'wi_k0s_swe_20131225000105_20140220235837.cdf'

;; copy_data,'E_DENS','wi_dens_hires'
copy_data,'P_DENS','wi_dens_hires'
copy_data,'V_GSE','wi_swe_V_GSE'
copy_data,'Np','wi_Np'
copy_data,'elect_density','wi_elect_density'
copy_data,'SC_pos_gse','wi_SC_pos_gse'

;Wind is about ~195 RE upstream. Vsw is 400 km/s. Thus SW will take ~50 minutes to propagte to Earth.
;This is consistent with OMNI_HR0_1min_Timeshift, which shows values of ~3000 sec, or about 50 min. 
tplot,['wi_SC_pos_gse','wi_swe_V_GSE']
ttst = time_double('2014-01-10/22:00')
coord = tsample('wi_SC_pos_gse',ttst,times=t)
;gse = [1.23995e+06,-99419.8,-96729.1]/6370.



split_vec,'wi_swe_V_GSE'
store_data,['P_DENS','V_GSE','Np','elect_density','SC_pos_gse'],/delete

rbsp_detrend,['wi_dens_hires','wi_swe_V_GSE','wi_Np','wi_elect_density','wi_h0_mfi_bmag','wi_h0_mfi_B3GSE'],5.*60.
rbsp_detrend,['wi_dens_hires','wi_swe_V_GSE','wi_Np','wi_elect_density','wi_h0_mfi_bmag','wi_h0_mfi_B3GSE']+'_smoothed',80.*60.

;Apply the rough timeshift 
get_data,'wi_dens_hires_smoothed_detrend',data=d & store_data,'wi_dens_hires_smoothed_detrend',data={x:d.x+(50.*60.),y:d.y}
get_data,'wi_swe_V_GSE_smoothed_detrend',data=d & store_data,'wi_swe_V_GSE_smoothed_detrend',data={x:d.x+(50.*60.),y:d.y}
get_data,'wi_Np_smoothed_detrend',data=d & store_data,'wi_Np_smoothed_detrend',data={x:d.x+(50.*60.),y:d.y}
get_data,'wi_elect_density_smoothed_detrend',data=d & store_data,'wi_elect_density_smoothed_detrend',data={x:d.x+(50.*60.),y:d.y}
get_data,'wi_h0_mfi_bmag_smoothed_detrend',data=d & store_data,'wi_h0_mfi_bmag_smoothed_detrend',data={x:d.x+(50.*60.),y:d.y}
get_data,'wi_h0_mfi_B3GSE_smoothed_detrend',data=d & store_data,'wi_h0_mfi_B3GSE_smoothed_detrend',data={x:d.x+(50.*60.),y:d.y}




tplot,['wi_dens_hires','wi_Np','wi_elect_density','wi_h0_mfi_bmag','wi_h0_mfi_B3GSE']+'_smoothed_detrend'
tplot,['fspc_comb_LX'],/add


;--------------------------------------------------
;Calculate Wind dynamic pressure as n*v^2
;From OMNIWeb:
;Flow pressure = (2*10**-6)*Np*Vp**2 nPa (Np in cm**-3, 
;Vp in km/s, subscript "p" for "proton")
;(NOTE THAT THIS CAN DIFFER STRONGLY FROM OMNI DATA, PRESUMABLY DUE TO SW EVOLUTION)
;--------------------------------------------------

split_vec,'wi_swe_V_GSE'



;Use these to find average values for pressure comparison. 
t0tmp = time_double('2014-01-10/20:00')
t1tmp = time_double('2014-01-11/00:00')
vtmp = tsample('wi_swe_V_GSE_x',[t0tmp,t1tmp],times=ttt)
ntmp = tsample('wi_Np',[t0tmp,t1tmp],times=ttt)

get_data,'wi_swe_V_GSE_x',data=vv
get_data,'wi_Np',data=dd

;tplot,['wi_dens_hires','wi_Np','wi_elect_density']


vsw = vv.y ;change velocity to m/s
dens = dd.y ;change number density to 1/m^3


;Pressure in nPa (rho*v^2)
press_proxy = 2d-6 * dens * vsw^2
store_data,'wi_press_dyn',data={x:vv.x,y:press_proxy}
;calculate pressure using averaged Vsw value
vsw_mean = mean(vtmp,/nan)
press_proxy = 2d-6 * dens * vsw_mean^2 
store_data,'wi_press_dyn_constant_vsw',data={x:vv.x,y:press_proxy}
;calculate pressure using averaged density value
dens_mean = mean(ntmp,/nan)
press_proxy = 2d-6 * dens_mean * vsw^2 
store_data,'wi_press_dyn_constant_dens',data={x:vv.x,y:press_proxy}

store_data,'wi_pressure_dyn_compare',data=['wi_press_dyn','wi_press_dyn_constant_dens','wi_press_dyn_constant_vsw']
ylim,'wi_pressure_dyn_compare',0,0
options,'wi_pressure_dyn_compare','colors',[0,50,250]

;Looks like the VARIATION of the dynamic pressure occurs because of the density fluctuations
tplot,'wi_pressure_dyn_compare'


;Detrend and apply the timeshift
rbsp_detrend,'wi_press_dyn',60.*5.
rbsp_detrend,'wi_press_dyn_smoothed',80.*60.
get_data,'wi_press_dyn_smoothed_detrend',ttmp,dtmp 
store_data,'wi_press_dyn_smoothed_detrend',ttmp+(50.*60.),dtmp


;tplot,['wi_Np','wi_elect_density']+'_smoothed_detrend'
tplot,['wi_press_dyn_smoothed_detrend','wi_h0_mfi_bmag_smoothed_detrend','wi_h0_mfi_B3GSE_smoothed_detrend']
tplot,['fspc_comb_LX'],/add



;compare dynamic pressure from Wind and OMNI to payloads
;^^version that's not detrended
timespan,'2014-01-10/18:00',8,/hours
tplot,['wi_press_dyn_smoothed','omni_press_dyn_smoothed','fspc_2K_smoothed','fspc_2L_smoothed','fspc_2X_smoothed','fspc_2T_smoothed']
;^^detrended version0
tplot,['wi_press_dyn_smoothed','omni_press_dyn_smoothed','fspc_2K_smoothed','fspc_2L_smoothed','fspc_2X_smoothed','fspc_2T_smoothed']+'_detrend'



;---------------------------------------------
;LOAD ACE DATA 
;---------------------------------------------



paath = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/ace/'

;fn = 'ac_h0s_mfi_20140101000001_20140114235959.cdf' & cdf2tplot,paath+fn
fn = 'ac_h0s_swe_20140101000038_20140114235932.cdf' & cdf2tplot,paath+fn,prefix='ac_'
fn = 'ac_h3s_mfi_20140101000000_20140114235959.cdf' & cdf2tplot,paath+fn,prefix='ac_'
fn = 'ac_ors_def_20140101000000_20140115000000.cdf' & cdf2tplot,paath+fn,prefix='ac_'
fn = 'ac_ors_ssc_20140101000000_20140115000000.cdf' & cdf2tplot,paath+fn,prefix='ac_'

rbsp_detrend,'ac_'+['Np','Vp','Tpr','alpha_ratio','V_GSE','Magnitude','BGSEc'],60.*5.
rbsp_detrend,'ac_'+['Np','Vp','Tpr','alpha_ratio','V_GSE','Magnitude','BGSEc']+'_smoothed',60.*80.


;Apply timeshift. ACE is 242 RE upstream. Vsw~400 km/s. Corresponds to a 64 min timeshift
get_data,'ac_Np_smoothed_detrend',data=d & store_data,'ac_Np_smoothed_detrend',data={x:d.x+(64.*60.),y:d.y}
get_data,'ac_Vp_smoothed_detrend',data=d & store_data,'ac_Vp_smoothed_detrend',data={x:d.x+(64.*60.),y:d.y}
get_data,'ac_Tpr_smoothed_detrend',data=d & store_data,'ac_Tpr_smoothed_detrend',data={x:d.x+(64.*60.),y:d.y}
get_data,'ac_Magnitude_smoothed_detrend',data=d & store_data,'ac_Magnitude_smoothed_detrend',data={x:d.x+(64.*60.),y:d.y}
get_data,'ac_BGSEc_smoothed_detrend',data=d & store_data,'ac_BGSEc_smoothed_detrend',data={x:d.x+(64.*60.),y:d.y}





;---------------------------------------------
;LOAD GOES DATA
;---------------------------------------------

path = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/Analysis_major_events_campaign2/Jan11/'

;G14 data from Sam Califf 
tplot_restore,filename=path + 'G14_bfield.tplot'
rbsp_detrend,'G14_bmag',60.*5.
rbsp_detrend,'G14_bmag_smoothed',60.*80.


;GOES EPS-MAGEDS data (40 keV - 465 keV)
fn = 'goes13_eps-mageds_1min_20140110180000_20140111000000.cdf'
cdf2tplot,path+fn

get_data,'dtc_cor_eflux_stack9',dlim=dlim 
ysubtitle = dlim.ysubtitle

rbsp_detrend,'dtc_cor_eflux_stack9',60.*5.
rbsp_detrend,'dtc_cor_eflux_stack9_smoothed',60.*80.

split_vec,'dtc_cor_eflux_stack9_smoothed_detrend'
options,'dtc_cor_eflux_stack9_smoothed_detrend_0','ysubtitle','40 keV ' + ysubtitle 
options,'dtc_cor_eflux_stack9_smoothed_detrend_1','ysubtitle','75 keV ' + ysubtitle 
options,'dtc_cor_eflux_stack9_smoothed_detrend_2','ysubtitle','150 keV ' + ysubtitle 
options,'dtc_cor_eflux_stack9_smoothed_detrend_3','ysubtitle','275 keV ' + ysubtitle 
options,'dtc_cor_eflux_stack9_smoothed_detrend_4','ysubtitle','475 keV ' + ysubtitle 

tplot,'dtc_cor_eflux_stack9_smoothed_detrend_?'


path = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/goes/'
fn = 'goes13_epead-science-electrons-e13ews_1min_20140101000000_20140214114500.cdf' & cdf2tplot,path+fn,prefix='g13_'
fn = 'goes15_epead-science-electrons-e13ews_1min_20140101000000_20140214114500.cdf' & cdf2tplot,path+fn,prefix='g15_'
store_data,'g13_'+['E2E_COR_ERR','E1W_DQF','E1E_DQF','E1W_COR_FLUX','E1E_COR_FLUX','E2W_COR_FLUX','E2E_COR_FLUX',$
    'E1E_DTC_FLUX','E1W_DTC_FLUX','E2E_DTC_FLUX','E1W_COR_ERR','E1E_COR_ERR','E2W_COR_ERR','E1W_DQF','E2E_DQF','E2W_DQF'],/delete
store_data,'g15_'+['E2E_COR_ERR','E1W_DQF','E1E_DQF','E1W_COR_FLUX','E1E_COR_FLUX','E2W_COR_FLUX','E2E_COR_FLUX',$
    'E1E_DTC_FLUX','E1W_DTC_FLUX','E2E_DTC_FLUX','E1W_COR_ERR','E1E_COR_ERR','E2W_COR_ERR','E1W_DQF','E2E_DQF','E2W_DQF'],/delete
tplot,['g13_E2W_DTC_FLUX','g15_E2W_DTC_FLUX']


fn = 'goes13_eps-maged_5min_20140101_v01.cdf' & cdf2tplot,path+fn,prefix='g13_'
fn = 'goes15_eps-mageds_5min_20140101000000_20140215000000.cdf' & cdf2tplot,path+fn,prefix='g15_'
tplot,'g1?_dtc_cor_eflux'

fn = 'goes13_eps-mageds_1min_20140101000000_20140214114500.cdf' & cdf2tplot,path+fn,prefix='g13_'
fn = 'goes15_eps-mageds_1min_20140101000000_20140214114500.cdf' & cdf2tplot,path+fn,prefix='g15_'
tplot,'g1?_dtc_cor_eflux_t_stack1'

fn = 'goes13_eps-pitchs_angles_1min_20140101000000_20140214114500.cdf' & cdf2tplot,path+fn,prefix='g13_'
fn = 'goes15_eps-pitchs_angles_1min_20140101000000_20140214114500.cdf' & cdf2tplot,path+fn,prefix='g15_'
tplot,'g1?_pitch_angles'



split_vec,'g1?_dtc_cor_eflux'
split_vec,'g1?_dtc_cor_eflux_t_stack1'
rbsp_detrend,['g1?_dtc_cor_eflux_?'],60.*80.

tplot,'g15_dtc_cor_eflux_?_detrend'

tplot,['coh_allcombos_meanfilter_normalized2','g13_dtc_cor_eflux_0_detrend','g15_dtc_cor_eflux_0_detrend','fspc_2K_smoothed_detrend','fspc_2L_smoothed_detrend','fspc_2X_smoothed_detrend']
tplot,['coh_allcombos_meanfilter_normalized2','rbsp?_spec64_scmw','Bfield_hissint?_smoothed','fspc_2K_smoothed','fspc_2L_smoothed','fspc_2X_smoothed']

;g15_dtc_cor_eflux_t_stack1_0

;----------------------------------------------------
;Explore extent of VLF waves. 
;----------------------------------------------------


;Load RBSP FBK amplitudes
rbsp_load_efw_fbk,probe='a',type='calibrated',/pt
rbsp_split_fbk,'a'
store_data,'*7av*',/del
;Load RBSP spec 
rbsp_load_efw_spec,probe='a',type='calibrated',/pt
rbsp_load_efw_spec,probe='b',type='calibrated',/pt


trange = timerange()
fcals = rbsp_efw_get_gain_results()
fbinsL = fcals.cal_spec.freq_spec64L
fbinsH = fcals.cal_spec.freq_spec64H
bandw = fbinsH - fbinsL


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
rbsp_detrend,'Bfield_hissinta',60.*5.
rbsp_detrend,'Bfield_hissinta_smoothed',60.*80.



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
rbsp_detrend,'Bfield_hissintb',60.*5.
rbsp_detrend,'Bfield_hissintb_smoothed',60.*80.

split_vec,'g1?_dtc_cor_eflux'
rbsp_detrend,'g1?_dtc_cor_eflux_0',60.*80.
tplot,['omni_press_dyn_smoothed_detrend','fspc_2X_smoothed_detrend','Bfield_hissint?_smoothed_detrend','g1?_dtc_cor_eflux_0_detrend']

;Load THEMIS FFT data from tha, thd, the
tplot_restore,filenames='/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/Analysis_major_events/Jan10/tha_thd_the_scm2_spec.tplot'
tplot,['th?_fff_32_scm2','rbspa_efw_64_spec4']

;
;       Time       Sat.                GSE (RE)                  GSE        gseLT           
;yyyy ddd hh:mm:ss              X          Y          Z       Lat   Long  hh:mm:ss  DipL-Val
;
;2014  10 22:00:00 themisa       5.45       1.54       0.65   6.51  15.76 13:03:03       5.8
;2014  10 22:00:00 themisd       2.39       8.23      -0.34  -2.27  73.83 16:55:20       8.8
;2014  10 22:00:00 themise       7.18       8.81       0.42   2.11  50.80 15:23:11      11.4


;--------------------------------------------
;VARIOUS PLOTS 
;--------------------------------------------

;^^Interesting day b/c L and X are maybe outside of the PP entirely after 08:00 UT (mostly before this too)
tplot,['MLT_Kp2_2L','MLT_Kp2_2X','L_Kp2_2L','L_Kp2_2X','dist_pp_2L','dist_pp_2X']



;Strong relationship w/ OMNI dynamic pressure (density-driven) and precip. Later plot shows that Wind and OMNI pressures
;are nearly identical. 
;^^version that's not detrended
timespan,'2014-01-10/18:00',8,/hours
tplot,['omni_press_dyn_smoothed','fspc_2K_smoothed','fspc_2L_smoothed','fspc_2X_smoothed','fspc_2T_smoothed']
;^^detrended version0
tplot,['omni_press_dyn_smoothed','fspc_2K_smoothed','fspc_2L_smoothed','fspc_2X_smoothed','fspc_2T_smoothed']+'_detrend'



;^^Clear relation (inverse and direct) to SW macroscopic B-field changes
;^^non-detrended version
timespan,'2014-01-10/18:00',8,/hours
tplot,['OMNI_HRO_1min_bmag','OMNI_HRO_1min_BX_GSE','OMNI_HRO_1min_BY_GSE','OMNI_HRO_1min_BZ_GSE','fspc_2K','fspc_2L','fspc_2X','fspc_2T']+'_smoothed'
;^^detrended version
tplot,['OMNI_HRO_1min_bmag','OMNI_HRO_1min_BX_GSE','OMNI_HRO_1min_BY_GSE','OMNI_HRO_1min_BZ_GSE','fspc_2K','fspc_2L','fspc_2X','fspc_2T']+'_smoothed_detrend'




;^^No clear relation to SW macroscopic slow speed/direction changes
tplot,'OMNI_HRO_1min_'+['V?','flow_speed']+'_smoothed'
tplot,['fspc_2L_smoothed','fspc_2X_smoothed','fspc_comb_LX'],/add


;^^As anticipated, the OMNI dynamic pressure changes are driven by density fluctuations. 
tplot,'OMNI_HRO_1min_'+['proton_density','T','Pressure','E','Beta']+'_smoothed_detrend'
tplot,['fspc_2L_smoothed','fspc_2X_smoothed','fspc_comb_LX'],/add


;^^Enhanced precip and coherence seems to follow substorm. However, the overall trend
;^^follows the OMNI dynamic pressure more closely. This strongly suggests outside driving. 
timespan,'2014-01-10/10:00',16,/hours
;tplot,['OMNI_HRO_1min_AE_INDEX','omni_press_dyn_smoothed','fspc_2K_smoothed','fspc_2L_smoothed','fspc_2X_smoothed','fspc_2T_smoothed']
;tplot,['OMNI_HRO_1min_bmag','OMNI_HRO_1min_BX_GSE','OMNI_HRO_1min_BY_GSM','OMNI_HRO_1min_BZ_GSM']+'_smoothed',/add
tplot,['OMNI_HRO_1min_bmag_smoothed','OMNI_HRO_1min_BX_GSE_smoothed','OMNI_HRO_1min_BY_GSM_smoothed','OMNI_HRO_1min_BZ_GSM_smoothed','OMNI_HRO_1min_AE_INDEX','omni_press_dyn_smoothed','fspc_2K_smoothed','fspc_2L_smoothed','fspc_2X_smoothed','fspc_2T_smoothed']

;^^No clear connection with storm, although precip matches the "PC_N_index" decently.
tplot,'OMNI_HRO_1min_'+['SYM_D','SYM_H','ASY_D','ASY_H','PC_N_INDEX']
tplot,['fspc_2L_smoothed','fspc_2X_smoothed','fspc_comb_LX'],/add


;^^Detailed comparison of SW pressure and magnetic field. Lots of similar features
tlimit,'2014-01-10/20:00','2014-01-11/00:00'
tplot,'OMNI_HRO_1min_'+['proton_density','T','Pressure','E','Beta']+'_smoothed_detrend'
tplot,['fspc_comb_KLWX'],/add

;^^Not many similarities near 16 UT. 
tlimit,'2014-01-10/14:00','2014-01-10/20:00'
tplot,'OMNI_HRO_1min_'+['proton_density','T','Pressure','E','Beta']+'_smoothed_detrend'
tplot,['fspc_comb_LX'],/add


;^^Comparison with GOES flux. G13 is few hrs East of G15. Seems like the AE spike is a response to the enhanced GOES e- content. 
timespan,'2014-01-10/00:00',24,/hours
;tplot,['g1?_dtc_cor_eflux','OMNI_HRO_1min_AE_INDEX','omni_press_dyn_smoothed','fspc_2K_smoothed','fspc_2L_smoothed','fspc_2X_smoothed','fspc_2T_smoothed']
tplot,['omni_press_dyn_smoothed','g1?_dtc_cor_eflux','OMNI_HRO_1min_AE_INDEX','OMNI_HRO_1min_bmag','OMNI_HRO_1min_BX_GSE','OMNI_HRO_1min_BY_GSM','OMNI_HRO_1min_BZ_GSM','fspc_2X_smoothed']

timespan,'2014-01-10/06:00',8,/hours
tplot,['g13_dtc_cor_eflux_0','omni_press_dyn_smoothed']


;^^comparison with hiss and/or boundary chorus amplitudes 
;Modulation with hiss/chorus more likely to do with RBSPa coming out of perigee than anything to do with Pdyn SW. 
timespan,'2014-01-10/15:00',9,/hours
tplot,['g1?_dtc_cor_eflux','rbspa_fbk2_7pk_3','rbspa_fbk2_7pk_4','rbspa_fbk2_7pk_5','omni_press_dyn_smoothed','fspc_2K_smoothed','fspc_2L_smoothed','fspc_2X_smoothed','fspc_2T_smoothed']



;^^Compare LANL 70-700 keV flux to balloon precip 
tplot,['*avg_flux_sopa_e_0_smoothed_detrend','fspc_2?_smoothed']


;LANL 01A and 2X - closest pair 
tplot,['1991-080_avg_flux_sopa_e_0_smoothed_detrend','1994-084_avg_flux_sopa_e_0_smoothed_detrend','fspc_'+pre+'X_smoothed_detrend','fspc_'+pre+'L_smoothed_detrend']
;LANL 01A and 2X - close pair 
tplot,['LANL-01A_avg_flux_sopa_e_0_smoothed_detrend','fspc_'+pre+'X_smoothed_detrend']
;LANL 02A and 2X - very separated 
tplot,['LANL-02A_avg_flux_sopa_e_0_smoothed_detrend','fspc_'+pre+'X_smoothed_detrend']

tplot,['1991-080_avg_flux_sopa_e_0_smoothed_detrend','1994-084_avg_flux_sopa_e_0_smoothed_detrend','omni_press_dyn_smoothed_detrend','fspc_'+pre+'?_smoothed_detrend']


;^^LANL SOPA doesn't show quite the same high freq modulations as ESP and may be more similar to balloon observations 
tplot,['*avg_flux_sopa_e_0_smoothed_detrend','fspc_'+pre+'L_smoothed']


;^^check for LANL dispersion 
tplot,['fspc_'+pre+'X_smoothed_detrend','omni_press_dyn_smoothed_detrend','1994-084_avg_flux_sopa_e_?_smoothed_detrend']

;^^compare with GOES 

ylim,'g13_dtc_cor_eflux_0_detrend',-4000,4000
ylim,'g15_dtc_cor_eflux_0_detrend',-6000,6000
tplot,['g1?_dtc_cor_eflux_0_detrend','fspc_'+pre+'X_smoothed_detrend','omni_press_dyn_smoothed_detrend','1994-084_avg_flux_sopa_e_0_smoothed_detrend']


tplot,['g13_dtc_cor_eflux_?_detrend','dtc_cor_eflux_stack9_smoothed_detrend_?']


tplot,['dtc_cor_eflux_stack9_smoothed','fspc_'+pre+'X_smoothed']



;^^Compare RBSPb EFW EyMGSE to OMNI 
split_vec,'rbspb_efield_inertial_frame_mgse_smoothed_detrend'
tplot,['OMNI_HRO_1min_proton_density_smoothed_detrend','rbspb_efield_inertial_frame_mgse_smoothed_detrend_y']



;^^compare BARREL spectra to OMNI fluctuations. How energetic is the modulated precip? 
ylim,'SSPC_2X',30,500,1
ylim,'MSPC_2X',100,500,1
tplot,['FSPC1a_2X','FSPC1b_2X','FSPC1c_2X','FSPC2_2X','FSPC3_2X','FSPC4_2X']+'_smoothed_detrend'
tplot,['OMNI_HRO_1min_proton_density_smoothed_detrend','MSPC_2X','SSPC_2X'],/add


;^^analyze higher energy spec 
ylim,'MSPC_2X',100,500,0
ylim,'SSPC_2X',100,500,0
zlim,'MSPC_2X',0.1,3,1
zlim,'SSPC_2X',0.1,4,1
tplot,['OMNI_HRO_1min_proton_density_smoothed_detrend','MSPC_2X','SSPC_2X']

tplot,['OMNI_HRO_1min_proton_density_smoothed_detrend','fspc_2?_smoothed_detrend','MSPC_2X','SSPC_2X']


;^^Wind, ACE, OMNI comparison 
tplot,['wi_Np']+'_smoothed_detrend'
tplot,'ac_'+['Np']+'_smoothed_detrend',/add
tplot,'OMNI_HRO_1min_proton_density_smoothed_detrend',/add



end

