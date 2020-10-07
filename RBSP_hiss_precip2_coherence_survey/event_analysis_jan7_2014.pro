;KLW at end of day on Jan 7, 2014


;Narrative: 

;also see Jan7_event.ppt

;pro event_analysis_jan7
  rbsp_efw_init
  tplot_options,'title','event_analysis_jan7.pro'

	tplot_options,'xmargin',[20.,16.]
	tplot_options,'ymargin',[3,9]
	tplot_options,'xticklen',0.08
	tplot_options,'yticklen',0.02
	tplot_options,'xthick',2
	tplot_options,'ythick',2
	tplot_options,'labflag',-1	

  pre = '2'
  timespan,'2014-01-07'

;Produce some useful tplot variables
;Set up this routine with the correct variables. 
args_manual = {combo:'KL',$
               pre:'2',$
               fspc:1,$
               datapath:'/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/',$
               folder_plots:'barrel_missionwide_plots',$
               folder_coh:'coh_vars_barrelmission2',$
               folder_singlepayload:'folder_singlepayload',$
               pmin:10*60.,$
               pmax:60*60.}

args_manual = {combo:'LW',$
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
fn = 'barrel_2L_fspc_fullmission.tplot' & tplot_restore,filenames=path + fn
fn = 'barrel_2X_fspc_fullmission.tplot' & tplot_restore,filenames=path + fn
fn = 'barrel_2W_fspc_fullmission.tplot' & tplot_restore,filenames=path + fn
fn = 'barrel_2I_fspc_fullmission.tplot' & tplot_restore,filenames=path + fn

;Restore individual coherence spectra
path = args_manual.datapath + args_manual.folder_coh + '/'
fn = 'KX_meanfilter.tplot' & tplot_restore,filenames=path + fn
fn = 'WK_meanfilter.tplot' & tplot_restore,filenames=path + fn
fn = 'WX_meanfilter.tplot' & tplot_restore,filenames=path + fn
fn = 'IK_meanfilter.tplot' & tplot_restore,filenames=path + fn
fn = 'IX_meanfilter.tplot' & tplot_restore,filenames=path + fn
fn = 'IW_meanfilter.tplot' & tplot_restore,filenames=path + fn
fn = 'IL_meanfilter.tplot' & tplot_restore,filenames=path + fn
fn = 'WL_meanfilter.tplot' & tplot_restore,filenames=path + fn
fn = 'KL_meanfilter.tplot' & tplot_restore,filenames=path + fn
fn = 'LX_meanfilter.tplot' & tplot_restore,filenames=path + fn


tnt = tnames('coh_??_meanfilter')
for i=0,n_elements(tnt)-1 do options,tnt[i],'ytitle', strmid(tnt[i],4,2)

kyoto_load_ae
tplot,['coh_allcombos_meanfilter_normalized2','coh_allcombos_meanfilter_normalized_OMNI_press_dyn','coh_??_meanfilter']





;py_plot_coh_tplot,args_manual=args_manual,/noplot

;p1 = strmid(args_manual.combo,0,1)
;p2 = strmid(args_manual.combo,1,1)
;pre = args_manual.pre
;pmin = args_manual.pmin
;pmax = args_manual.pmax
;pmin /= 60.
;pmax /= 60.
;pminS = strtrim(floor(pmin),2)
;pmaxS = strtrim(floor(pmax),2)
;fspcS = 'fspc'

;store_data,'fspcS_lowpass_comb',data=[fspcS+'_'+pre+p1+'_lowpass',fspcS+'_'+pre+p2+'_lowpass']
;options,'fspcS_lowpass_comb','colors',[0,250]
;ylim,'fspcS_lowpass_comb',30,60

;store_data,'fspcS_lowpass_detrend_comb',data=[fspcS+'_'+pre+p1+'_'+pminS+'-'+pmaxS+'_min_lowpass_detrend',fspcS+'_'+pre+p2+'_'+pminS+'-'+pmaxS+'_min_lowpass_detrend']
;options,'fspcS_lowpass_detrend_comb','colors',[0,250]

;timespan,'2014-01-07/15:00',9,/hours
;tplot,['coh_KL_meanfilter','coh_LX_meanfilter',$
;    'fspcS_lowpass_comb',$
;    'fspcS_lowpass_detrend_comb',$
;    'dL_KL_both','dMLT_KL_both',$
;    'dist_pp_2K_comb','dist_pp_2L_comb']


rbsp_detrend,'fspc_2?',5.*60.
rbsp_detrend,'fspc_2?_smoothed',80.*60.


store_data,'fspc_comb_KL',data=['fspc_2K','fspc_2L']+'_smoothed_detrend'
;store_data,'fspc_comb_LX',data=['fspc_2L','fspc_2X']+'_smoothed_detrend'
options,['fspc_comb_KL','fspc_comb_LX'],'colors',[0,250]
;tplot,['fspc_comb_KL','fspc_comb_LX']

stop



;--------------------------------------------------------------
;Load OMNI SW data
;--------------------------------------------------------------


t0tmp = time_double('2014-01-07/00:00')
t1tmp = time_double('2014-01-08/00:00')
plot_omni_quantities,t0avg=t0tmp,t1avg=t1tmp

tplot,['kyoto_ae','coh_allcombos_meanfilter_normalized2','coh_allcombos_meanfilter_normalized_OMNI_press_dyn','fspc_2K_smoothed_detrend','fspc_2L_smoothed_detrend','coh_KL_meanfilter'],/add


;tplot,['omni_Np','omni_elect_density']+'_smoothed_detrend'
;tplot,['omni_press_dyn_smoothed_detrend','fspc_2K_smoothed','fspc_2W_smoothed','fspc_2L_smoothed','fspc_2X_smoothed']
tplot,['coh_allcombos_meanfilter_normalized_OMNI_press_dyn','omni_press_dyn_smoothed','fspc_2?_smoothed']
tplot,['coh_allcombos_meanfilter_normalized_OMNI_press_dyn','omni_press_dyn_smoothed_detrend','fspc_2?_smoothed_detrend']



;^^Test IMF Bz 
tplot,['OMNI_HRO_1min_B?_GSM']
tplot,['fspc_comb_KL','fspc_comb_LX'],/add

;^^Check Vsw flow speed 
tplot,'OMNI_HRO_1min_flow_speed'
tplot,['fspc_comb_KL','fspc_comb_LX'],/add

;^^Check solar wind density
tplot,'OMNI_HRO_1min_proton_density'
tplot,['fspc_comb_KL','fspc_comb_LX'],/add


tplot,['IMF_orientation_comb','Bz_rat_comb','clockangle_comb','coneangle_comb']
tplot,['clockangle_comb','coneangle_comb','kyoto_ae','kyoto_dst','OMNI_HRO_1min_flow_speed']
tplot,['OMNI_HRO_1min_flow_speed','clockangle_comb','coneangle_comb','fspc_2?_smoothed']



;---------------------------------------
;Plot location of balloon payloads
;---------------------------------------

plot_dial_payload_location_specific_time,'2014-01-07/15:00'



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
rbsp_detrend,['wi_dens_hires','wi_swe_V_GSE','wi_Np','wi_elect_density','wi_h0_mfi_bmag','wi_h0_mfi_B3GSE']+'_smoothed',60.*60.

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
rbsp_detrend,'wi_press_dyn_smoothed',60.*60.
get_data,'wi_press_dyn_smoothed_detrend',ttmp,dtmp 
store_data,'wi_press_dyn_smoothed_detrend',ttmp+(50.*60.),dtmp


;tplot,['wi_Np','wi_elect_density']+'_smoothed_detrend'
tplot,['wi_press_dyn_smoothed_detrend','wi_h0_mfi_bmag_smoothed_detrend','wi_h0_mfi_B3GSE_smoothed_detrend']
tplot,['fspc_comb_LX'],/add




;---------------------------------------------
;LOAD THEMIS DATA
;---------------------------------------------

thm_load_fft,probe='a'
tplot,['coh_KL_meanfilter','fspc_2K_smoothed_detrend','fspc_2L_smoothed_detrend','fspc_2X_smoothed_detrend']
tplot,['tha_fff_32_edc12','tha_fff_32_edc34','tha_fff_32_scm2','tha_fff_32_scm3'],/add

;Calculate RMS hiss amplitudes for Ew and Bw (single channel)

tplot,'tha_fff_32_edc12'
get_data,'tha_fff_32_edc12',data=dd

;freqs from 52 - 956 Hz
print,dd.v[3:23]
bandw = dd.v - shift(dd.v,1)
bandw = bandw[1:n_elements(bandw)-1]
bandw = bandw[3:23]

edcv = dd.y[*,3:23]
nelem = n_elements(dd.x)
edcvfin = edcv & edcvfin[*] = 0.

for j=0L,nelem-1 do edcvfin[j] = 1000.*sqrt(total(edcv[j,*]*bandw))

store_data,'edcv_rms',data={x:dd.x,y:edcvfin}
options,'edcv_rms','ytitle','RMS E12DC!CmV/m!C52-1000 Hz'


;RMS for SCM
get_data,'tha_fff_32_scm3',data=dd

scm3 = dd.y[*,3:23]
nelem = n_elements(dd.x)
scm3fin = scm3 & scm3fin[*] = 0.

for j=0L,nelem-1 do scm3fin[j] = 1000.*sqrt(total(scm3[j,*]*bandw))

store_data,'scm3_rms',data={x:dd.x,y:scm3fin}
options,'scm3_rms','ytitle','RMS SCM3!CpT!C52-1000 Hz'



ylim,['tha_fff_32_scm3','tha_fff_32_edc12'],50,1000,0
tplot,['tha_fff_32_scm3','scm3_rms','tha_fff_32_edc12','edcv_rms']


ylim,'edcv_rms',0,0.2
ylim,'scm3_rms',0,30
tplot,['fspc_1A_smoothed_detrend','fspc_1T_smoothed_detrend','fspc_1U_smoothed_detrend','scm3_rms','edcv_rms']
tplot,['fspc_1A_smoothed','fspc_1T_smoothed','fspc_1U_smoothed','scm3_rms','edcv_rms']




thm_load_fgm,probe='a'
split_vec,'tha_fgl'
rbsp_detrend,['tha_fgl*'],30.*60.
;rbsp_detrend,['tha_fge','tha_fgl']+'_smoothed',80.*60.
tplot,['tha_fgl_detrend','tha_vaf_0_smoothed']
tplot,['tha_fgl','tha_vaf_0_smoothed']




thm_load_efi,probe='a'







ptmp = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/Analysis_major_events/Jan7/'
cdf2tplot,ptmp+'tha_l2_efi_20140107_v01.cdf'
cdf2tplot,ptmp+'tha_l2_fgm_20140107_v01.cdf'
cdf2tplot,ptmp+'tha_l2_mom_20140107_v01.cdf'
cdf2tplot,ptmp+'thb_l2_efi_20140107_v01.cdf'
cdf2tplot,ptmp+'thb_l2_fgm_20140107_v01.cdf'
cdf2tplot,ptmp+'thb_l2_mom_20140107_v01.cdf'
cdf2tplot,ptmp+'thc_l2_efi_20140107_v01.cdf'
cdf2tplot,ptmp+'thc_l2_fgm_20140107_v01.cdf'
cdf2tplot,ptmp+'thc_l2_mom_20140107_v01.cdf'
cdf2tplot,ptmp+'thd_l2_efi_20140107_v01.cdf'
cdf2tplot,ptmp+'thd_l2_fgm_20140107_v01.cdf'
cdf2tplot,ptmp+'thd_l2_mom_20140107_v01.cdf'
cdf2tplot,ptmp+'the_l2_efi_20140107_v01.cdf'
cdf2tplot,ptmp+'the_l2_fgm_20140107_v01.cdf'
cdf2tplot,ptmp+'the_l2_mom_20140107_v01.cdf'



;---------------------------------------------
;LOAD GOES DATA
;---------------------------------------------

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


;^^overview plot with GOES data. This strongly suggests that the 60 min periodicity 
;with high coherence is triggered by drift echoes. 
split_vec,'g1?_dtc_cor_eflux'
rbsp_detrend,'g1?_dtc_cor_eflux_0',60.*5.
rbsp_detrend,'g1?_dtc_cor_eflux_0_smoothed',60.*80.

ylim,'g1?_dtc_cor_eflux',1d4,1d6,1
tplot,['omni_press_dyn','OMNI_HRO_1min_Bmag','g1?_dtc_cor_eflux_0_smoothed',$
'fspc_2W_smoothed','fspc_2L_smoothed','fspc_2K_smoothed','fspc_2X_smoothed']






;----------------------------------------------------------------------------
;VARIOUS INTERESTING PLOTS
;----------------------------------------------------------------------------

;^^overview of solar wind conditions
tplot,['omni_press_dyn','OMNI_HRO_1min_Bmag']
tplot,['coh_KL_meanfilter','coh_LX_meanfilter','fspc_2K_smoothed','fspc_2L_smoothed','fspc_2X_smoothed','fspc_comb_KL','fspc_comb_LX'],/add


;^^Looks like the VARIATION of the dynamic pressure occurs mostly because of the density fluctuations
tplot,'omni_pressure_dyn_compare'


;^^At higher L, but may actually be inside of PS
tplot,['MLT_Kp2_2K','MLT_Kp2_2L','MLT_Kp2_2X','L_Kp2_2K','L_Kp2_2L','L_Kp2_2X']

;^^Possible assoc. with BxGSE increases
tplot,'OMNI_HRO_1min_'+['B?_GSE','B?_GSM']
tplot,['coh_KL_meanfilter','coh_LX_meanfilter','fspc_2K_smoothed','fspc_2L_smoothed','fspc_2X_smoothed','fspc_comb_KL','fspc_comb_LX'],/add


;^^No clear relation to SW macroscopic slow speed/direction changes
tplot,'OMNI_HRO_1min_'+['V?','flow_speed']
tplot,['coh_KL_meanfilter','coh_LX_meanfilter','fspc_2K_smoothed','fspc_2L_smoothed','fspc_2X_smoothed','fspc_comb_KL','fspc_comb_LX'],/add


;^^Clear assoc. with pressure changes
tplot,'OMNI_HRO_1min_'+['proton_density','T','Pressure','E','Beta']
tplot,['coh_KL_meanfilter','coh_LX_meanfilter','fspc_2K_smoothed','fspc_2L_smoothed','fspc_2X_smoothed','fspc_comb_KL','fspc_comb_LX'],/add


;^^Moderate substorm activity 
;tplot,'OMNI_HRO_1min_'+['AE_INDEX','AL_INDEX','AU_INDEX']
tplot,'OMNI_HRO_1min_'+['AE_INDEX']
tplot,['coh_KL_meanfilter','coh_LX_meanfilter','fspc_2K_smoothed','fspc_2L_smoothed','fspc_2X_smoothed','fspc_comb_KL','fspc_comb_LX'],/add


;^^Minor storm with some few hr fluctuations
tplot,'OMNI_HRO_1min_'+['SYM_D','SYM_H','ASY_D','ASY_H','PC_N_INDEX']
tplot,['coh_KL_meanfilter','coh_LX_meanfilter','fspc_2K_smoothed','fspc_2L_smoothed','fspc_2X_smoothed','fspc_comb_KL','fspc_comb_LX'],/add


;^^Detailed comparison of SW pressure and magnetic field. Lots of similar features
rbsp_detrend,'OMNI_HRO_1min_'+['proton_density','T','Pressure','E','Beta'],5.*60.
rbsp_detrend,'OMNI_HRO_1min_'+['proton_density','T','Pressure','E','Beta']+'_smoothed',60.*60.
tlimit,'2014-01-07/15:00','2014-01-08/00:00'
tplot,'OMNI_HRO_1min_'+['T','E','Beta']+'_smoothed_detrend'
tplot,'omni_press_dyn_smoothed_detrend',/add
tplot,['coh_KL_meanfilter','coh_LX_meanfilter','fspc_2K_smoothed','fspc_2L_smoothed','fspc_2X_smoothed','fspc_comb_KL','fspc_comb_LX'],/add


tplot,'omni_press_dyn_smoothed_detrend'
tplot,['fspc_comb_KL','fspc_comb_LX'],/add





  stop

end

