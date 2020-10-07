
;Narrative: 


pro event_analysis_jan6

rbsp_efw_init
tplot_options,'title','event_analysis_jan6.pro'

tplot_options,'xmargin',[20.,16.]
tplot_options,'ymargin',[3,9]
tplot_options,'xticklen',0.08
tplot_options,'yticklen',0.02
tplot_options,'xthick',2
tplot_options,'ythick',2
tplot_options,'labflag',-1	

pre = '2' 
timespan,'2014-01-06'

;Restore individual coherence spectra
;Produce some useful tplot variables
;Set up this routine with the correct variables. 
args_manual = {combo:'WK',$
               pre:'2',$
               fspc:1,$
               datapath:'/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/',$
               folder_plots:'barrel_missionwide_plots',$
               folder_coh:'coh_vars_barrelmission2',$
               folder_singlepayload:'folder_singlepayload',$
               pmin:10*60.,$
               pmax:60*60.}

fntmp = 'all_coherence_plots_combined.tplot'
tplot_restore,filenames='/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/'+'coh_vars_barrelmission'+pre+'/'+fntmp


;Restore individual payload FSPC data
path = args_manual.datapath + args_manual.folder_singlepayload + '/'
fn = 'barrel_2I_fspc_fullmission.tplot' & tplot_restore,filenames=path + fn
fn = 'barrel_2L_fspc_fullmission.tplot' & tplot_restore,filenames=path + fn
fn = 'barrel_2W_fspc_fullmission.tplot' & tplot_restore,filenames=path + fn
fn = 'barrel_2K_fspc_fullmission.tplot' & tplot_restore,filenames=path + fn
fn = 'barrel_2X_fspc_fullmission.tplot' & tplot_restore,filenames=path + fn

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
tplot,['coh_allcombos_meanfilter_normalized2','coh_??_meanfilter']





py_plot_coh_tplot,args_manual=args_manual,/noplot

p1 = strmid(args_manual.combo,0,1)
p2 = strmid(args_manual.combo,1,1)
pre = args_manual.pre
pmin = args_manual.pmin
pmax = args_manual.pmax
pmin /= 60.
pmax /= 60.
pminS = strtrim(floor(pmin),2)
pmaxS = strtrim(floor(pmax),2)
fspcS = 'fspc'

store_data,'fspcS_lowpass_comb',data=[fspcS+'_'+pre+p1+'_lowpass',fspcS+'_'+pre+p2+'_lowpass']
options,'fspcS_lowpass_comb','colors',[0,250]
ylim,'fspcS_lowpass_comb',30,60

store_data,'fspcS_lowpass_detrend_comb',data=[fspcS+'_'+pre+p1+'_'+pminS+'-'+pmaxS+'_min_lowpass_detrend',fspcS+'_'+pre+p2+'_'+pminS+'-'+pmaxS+'_min_lowpass_detrend']
options,'fspcS_lowpass_detrend_comb','colors',[0,250]

timespan,'2014-01-06/18:00',6,/hours
tplot,['coh_'+p1+p2+'_meanfilter',$
    'fspcS_lowpass_comb',$
    'fspcS_lowpass_detrend_comb',$
    'dL_'+p1+p2+'_both','dMLT_'+p1+p2+'_both',$
    'dist_pp_'+pre+p1+'_comb','dist_pp_'+pre+p2+'_comb']


rbsp_detrend,'fspc_2?',5.*60.
rbsp_detrend,'fspc_2?_smoothed',80.*60.


stop

;--------------------------------------------------------------
;Load OMNI SW data
;--------------------------------------------------------------


t0tmp = time_double('2014-01-06/00:00')
t1tmp = time_double('2014-01-07/00:00')
plot_omni_quantities,t0avg=t0tmp,t1avg=t1tmp

tplot,['kyoto_ae','coh_allcombos_meanfilter_normalized2','coh_WK_meanfilter','fspc_2W_smoothed','fspc_2K_smoothed','coh_KL_meanfilter','fspc_2L_smoothed'],/add

;tplot,['omni_Np','omni_elect_density']+'_smoothed_detrend'
tplot,['omni_press_dyn_smoothed_detrend']
tplot,['fspc_comb_KL'],/add


tplot,['IMF_orientation_comb','Bz_rat_comb','clockangle_comb','coneangle_comb']
tplot,['clockangle_comb','coneangle_comb','kyoto_ae','kyoto_dst','OMNI_HRO_1min_flow_speed']

tplot,['OMNI_HRO_1min_flow_speed','clockangle_comb','coneangle_comb']

tplot,['fspc_2?_smoothed_detrend','omni_press_dyn_smoothed_detrend','OMNI_HRO_1min_proton_density']


get_data,'OMNI_HRO_1min_BX_GSE',data=bx 
get_data,'OMNI_HRO_1min_BY_GSE',data=by 
get_data,'OMNI_HRO_1min_BZ_GSE',data=bz 
store_data,'OMNI_BGSE',data={x:bx.x,y:[[bx.y],[by.y],[bz.y]]}


;---------------------------------------------------
;Plot LANL sat observations
;---------------------------------------------------


pp = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/Analysis_major_events_campaign2/Jan6/'

tplot_restore,filenames=pp+'lanl_sat_1991-080_20140106.tplot'
tplot_restore,filenames=pp+'lanl_sat_1994-084_20140106.tplot'
tplot_restore,filenames=pp+'lanl_sat_LANL-01A_20140106.tplot'
tplot_restore,filenames=pp+'lanl_sat_LANL-02A_20140106.tplot'
tplot_restore,filenames=pp+'lanl_sat_LANL-04A_20140106.tplot'
tplot_restore,filenames=pp+'lanl_sat_LANL-97A_20140106.tplot'


split_vec,'1991-080_avg_flux_sopa_e'
split_vec,'1994-084_avg_flux_sopa_e'
split_vec,'LANL-01A_avg_flux_sopa_e'
split_vec,'LANL-02A_avg_flux_sopa_e'
split_vec,'LANL-04A_avg_flux_sopa_e'
split_vec,'LANL-97A_avg_flux_sopa_e'


rbsp_detrend,'*avg_flux_sopa_e_0',60.*5.
rbsp_detrend,'*avg_flux_sopa_e_0_smoothed',60.*80.

ylim,'*avg_flux_sopa_e_0_smoothed',0,5d4,0
tplot,['*avg_flux_sopa_e_0_smoothed_detrend','fspc_2L_smoothed_detrend','omni_press_dyn_smoothed_detrend']
tplot,['*avg_flux_sopa_e_0','fspc_2L_smoothed']


split_vec,'1991-080_avg_flux_esp_e'
split_vec,'1994-084_avg_flux_esp_e'
split_vec,'LANL-01A_avg_flux_esp_e'
split_vec,'LANL-02A_avg_flux_esp_e'
split_vec,'LANL-04A_avg_flux_esp_e'
split_vec,'LANL-97A_avg_flux_esp_e'



rbsp_detrend,'*avg_flux_esp_e_0',60.*5.
rbsp_detrend,'*avg_flux_esp_e_0_smoothed',60.*80.

ylim,'*avg_flux_esp_e_0_smoothed',1d0,1d5,0
tplot,['*avg_flux_esp_e_0_smoothed_detrend','fspc_2L_smoothed']
tplot,['*avg_flux_esp_e_0_smoothed','fspc_2L_smoothed']


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

;---------------------------------------
;Plot location of balloon payloads
;---------------------------------------

plot_dial_payload_location_specific_time,'2014-01-06/21:00'

;--------------------------------------------------
;Load Wind data. 
;--------------------------------------------------

;cdf2tplot,'/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/wind/wi_em2_dens.cdf'



;Load Wind hires density from CDFs
;NEEDED TO SEE THE ~1min FEATURE OF THE NATURE PAPER
paath = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/wind/'
cdf2tplot,paath+'wi_ems_3dp_20131225000000_20140220235958.cdf'
cdf2tplot,paath+'wi_pms_3dp_20131225000002_20140221000000.cdf'

copy_data,'E_DENS','wi_hires_electron_density'
copy_data,'P_DENS','wi_hires_proton_density'

;tplot,['wi_hires_electron_density','wi_hires_proton_density']

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

;Wind is about ~195 RE upstream. Vsw is pretty constant through day (~357 km/s near 21UT). 
;Thus SW will take ~58 minutes to propagte to Earth.
;This is consistent with OMNI_HR0_1min_Timeshift, which shows values of ~3253 sec, or about 54 min. 
tplot,['wi_SC_pos_gse','wi_swe_V_GSE']
ttst = time_double('2014-01-06/21:00')
coord = tsample('wi_SC_pos_gse',ttst,times=t)




split_vec,'wi_swe_V_GSE'
store_data,['P_DENS','V_GSE','Np','elect_density','SC_pos_gse'],/delete


;Apply the rough timeshift 
get_data,'wi_dens_hires',data=d & store_data,'wi_dens_hires',data={x:d.x+(58.*60.),y:d.y}
get_data,'wi_swe_V_GSE',data=d & store_data,'wi_swe_V_GSE',data={x:d.x+(58.*60.),y:d.y}
get_data,'wi_Np',data=d & store_data,'wi_Np',data={x:d.x+(58.*60.),y:d.y}
get_data,'wi_elect_density',data=d & store_data,'wi_elect_density',data={x:d.x+(58.*60.),y:d.y}
get_data,'wi_h0_mfi_bmag',data=d & store_data,'wi_h0_mfi_bmag',data={x:d.x+(58.*60.),y:d.y}
get_data,'wi_h0_mfi_B3GSE',data=d & store_data,'wi_h0_mfi_B3GSE',data={x:d.x+(58.*60.),y:d.y}
get_data,'wi_hires_electron_density',data=d & store_data,'wi_hires_electron_density',data={x:d.x+(58.*60.),y:d.y}
get_data,'wi_hires_proton_density',data=d & store_data,'wi_hires_proton_density',data={x:d.x+(58.*60.),y:d.y}


rbsp_detrend,['wi_dens_hires','wi_swe_V_GSE','wi_Np','wi_elect_density','wi_h0_mfi_bmag','wi_h0_mfi_B3GSE'],1.*60.
rbsp_detrend,['wi_dens_hires','wi_swe_V_GSE','wi_Np','wi_elect_density','wi_h0_mfi_bmag','wi_h0_mfi_B3GSE']+'_smoothed',80.*60.
;Detrend the hires Wind variables
rbsp_detrend,'wi_hires_electron_density',60.*0.4
rbsp_detrend,'wi_hires_proton_density',60.*0.4






;tplot,['wi_dens_hires','wi_Np','wi_elect_density','wi_h0_mfi_bmag','wi_h0_mfi_B3GSE']+'_smoothed_detrend'
tplot,['wi_dens_hires','wi_Np','wi_elect_density','wi_h0_mfi_bmag','wi_h0_mfi_B3GSE']+'_smoothed'
tplot,['fspc_comb_KL'],/add





;--------------------------------------------------
;Calculate Wind dynamic pressure as n*v^2
;From OMNIWeb:
;Flow pressure = (2*10**-6)*Np*Vp**2 nPa (Np in cm**-3, 
;Vp in km/s, subscript "p" for "proton")
;(NOTE THAT THIS CAN DIFFER STRONGLY FROM OMNI DATA, PRESUMABLY DUE TO SW EVOLUTION)
;--------------------------------------------------

split_vec,'wi_swe_V_GSE'



;Use these to find average values for pressure comparison. 
t0tmp = time_double('2014-01-06/20:00')
t1tmp = time_double('2014-01-06/22:00')
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


;Detrend
rbsp_detrend,'wi_press_dyn',60.*1.
rbsp_detrend,'wi_press_dyn_smoothed',80.*60.


;tplot,['wi_Np','wi_elect_density']+'_smoothed_detrend'
tplot,['wi_press_dyn_smoothed_detrend','wi_h0_mfi_bmag_smoothed_detrend','wi_h0_mfi_B3GSE_smoothed_detrend']
tplot,['fspc_comb_KL'],/add



;Compare Wind and OMNI dynamic pressure
tplot,['wi_press_dyn_smoothed_detrend','omni_press_dyn_smoothed_detrend']
tplot,['fspc_comb_KL'],/add




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
ylim,'g1?_dtc_cor_eflux',1d4,3d5,1
tplot,'g1?_dtc_cor_eflux'
tplot,['coh_'+p1+p2+'_meanfilter','fspc_2K_smoothed','fspc_2L_smoothed','fspc_comb_KL'],/add

fn = 'goes13_eps-mageds_1min_20140101000000_20140214114500.cdf' & cdf2tplot,path+fn,prefix='g13_'
fn = 'goes15_eps-mageds_1min_20140101000000_20140214114500.cdf' & cdf2tplot,path+fn,prefix='g15_'
tplot,'g1?_dtc_cor_eflux_t_stack1'

fn = 'goes13_eps-pitchs_angles_1min_20140101000000_20140214114500.cdf' & cdf2tplot,path+fn,prefix='g13_'
fn = 'goes15_eps-pitchs_angles_1min_20140101000000_20140214114500.cdf' & cdf2tplot,path+fn,prefix='g15_'
tplot,'g1?_pitch_angles'


;^^overview including GOES data
tplot,['g13_dtc_cor_eflux','omni_press_dyn','OMNI_HRO_1min_Bmag']
tplot,['coh_'+p1+p2+'_meanfilter','fspc_2K_smoothed','fspc_2L_smoothed','fspc_comb_KL'],/add


;^^overview plot with GOES data. This strongly suggests that the 60 min periodicity 
;with high coherence is triggered by drift echoes. 

rbsp_detrend,'g13_dtc_cor_eflux',60.*1.

split_vec,'g13_dtc_cor_eflux'
tplot,'g13_dtc_cor_eflux_?'
rbsp_detrend,'g13_dtc_cor_eflux_0',60.*1.
rbsp_detrend,'g13_dtc_cor_eflux_0_smoothed',80.*60.
split_vec,'g15_dtc_cor_eflux'
tplot,'g15_dtc_cor_eflux_?'
rbsp_detrend,'g15_dtc_cor_eflux_0',60.*1.
rbsp_detrend,'g15_dtc_cor_eflux_0_smoothed',80.*60.


ylim,'g1?_dtc_cor_eflux',1d3,1d5,1
tplot,['g13_dtc_cor_eflux_0_smoothed_detrend','OMNI_HRO_1min_Bmag','g13_dtc_cor_eflux']
tplot,['coh_'+p1+p2+'_meanfilter','fspc_2K_smoothed','fspc_2L_smoothed','fspc_comb_KL','omni_press_dyn_smoothed_detrend'],/add


timespan,'2014-01-06/16:00',8,/hours
tplot,['g1?_dtc_cor_eflux'] & timebar,'2014-01-06/21:00'

;------------------------------------------------------------
;Load ACE SW data 
;ACE is at 241 RE upstream
;Velocity SW is around 350 km/s near 21 UT.
;Timeshift is then 73 minutes
;------------------------------------------------------------

ptmp = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/solar_wind_data/'
fn = 'ac_h0s_mfi_20140101000001_20140214235954.cdf' & cdf2tplot,ptmp+fn
fn = 'ac_h0s_swe_20140101000038_20140214235927.cdf' & cdf2tplot,ptmp+fn
fn = 'ac_h3s_mfi_20140101000000_20140214235959.cdf' & cdf2tplot,ptmp+fn
fn = 'ac_h6s_swi_20140101000611_20140214235506.cdf' & cdf2tplot,ptmp+fn

copy_data,'Magnitude','ac_bmag' & copy_data,'BGSEc','ac_BGSEc' & copy_data,'Np','ac_Np'
copy_data,'Vp','ac_Vp' & copy_data,'V_GSE','ac_V_GSE' & copy_data,'Tpr','ac_Tpr'
copy_data,'BRTN','ac_BRTN' & copy_data,'nH','ac_Nh'
copy_data,'vthH','ac_vthH'



;Determine ACE timeshift 
get_data,'OMNI_HRO_1min_BX_GSE',data=bx
get_data,'OMNI_HRO_1min_BY_GSE',data=by
get_data,'OMNI_HRO_1min_BZ_GSE',data=bz
store_data,'OMNI_bmag',data={x:bx.x,y:sqrt(bx.y^2+by.y^2+bz.y^2)}
rbsp_detrend,'ac_bmag',60.*2.
get_data,'ac_bmag_smoothed',data=d
store_data,'ac_bmag_smoothed_tshift',data={x:d.x+55.*60.,y:d.y}
get_data,'ac_Np',data=d 
store_data,'ac_Np_tshift',data={x:d.x+55.*60.,y:d.y}
get_data,'ac_BGSEc',data=d 
store_data,'ac_BGSEc_tshift',data={x:d.x+55.*60.,y:d.y}



store_data,'bmagcomb',data=['ac_bmag_smoothed_tshift','OMNI_bmag']
store_data,'denscomb',data=['ac_Np_tshift','OMNI_HRO_1min_proton_density']
store_data,'bgsecomb',data=['ac_BGSEc_tshift','OMNI_BGSE']
options,'bmagcomb','colors',[0,250]
options,'denscomb','colors',[0,250]
tplot,['bmagcomb','denscomb','OMNI_BGSE','ac_BGSEc_tshift']


;apply timeshift
get_data,'ac_bmag',t,d & store_data,'ac_bmag',t+(73.*60.),d
get_data,'ac_Np',t,d & store_data,'ac_Np',t+(73.*60.),d
get_data,'ac_Nh',t,d & store_data,'ac_Nh',t+(73.*60.),d
get_data,'ac_BGSEc',t,d & store_data,'ac_BGSEc',t+(73.*60.),d
get_data,'ac_BRTN',t,d & store_data,'ac_BRTN',t+(73.*60.),d
get_data,'ac_vthH',t,d & store_data,'ac_vthH',t+(73.*60.),d




tplot,['ac_bmag','ac_BRTN']

;---------------------------------------------------
;Load Cluster 4 data 
;All Cluster sc are close together in the magnetosheath (I think) 
;---------------------------------------------------



ptmp = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/Analysis_major_events/Jan6/'
fn = 'cluster4_density_velocity.tplot'
tplot_restore,filenames=ptmp+fn

tplot,['c4_np','c4_VGSE']

split_vec,'c4_VGSE'

;;***TEMPORARY CODE FOR TURNING SOME CDFWEB CLUSTER 4 DATA INTO A TPLOT SAVE FILE
;fn = 'C4_PP_CIS_6849.txt'
;openr,lun,ptmp+fn,/get_lun 
;jnk = ''
;for i=0,69 do readf,lun,jnk
;datatmp = ''
;while not eof(lun) do begin $
;readf,lun,jnk & $
;datatmp = [datatmp,jnk]
;datatmp = datatmp[1:20829]
;vals = strarr(20829,6)
;for i=0L,n_elements(datatmp)-1 do vals[i,*] = strsplit(datatmp[i],/extract)
;times = time_double('2014-01-06/' + vals[*,1])
;store_data,'c4_np',times,vals[*,2]
;store_data,'c4_VGSE',times,[[vals[*,3]],[vals[*,4]],[vals[*,5]]]
;ylim,'c4_VGSE',-500,500
;tplot_save,['c4_np','c4_VGSE'],filename='~/Desktop/cluster4_density_velocity'


;-------------------------------------
;Load THEMIS data 
;THa and THd are in Msphere and clearly see the spike
;Thcb,c in foreshock or solar wind and don't see it. 
;The is in the inner magnetosphere and doesn't see it. 

;-------------------------------------
thprobes = ['a','b','c','d','e']


ptmp = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/Analysis_major_events/Jan6/'
cdf2tplot,ptmp+'thb_l2_fgm_20140106_v01.cdf'
cdf2tplot,ptmp+'thd_l2_fgm_20140106_v01.cdf'

;First survey the varous data products to see which see the 21UT event. 
ptmp = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/Analysis_major_events/Jan6/'
for i=0,4 do cdf2tplot,ptmp+'th'+thprobes[i]+'_l2_efi_20140106_v01.cdf'
tplot,'tha_ef?_*'  ;sees spike
tplot,'thb_ef?_*'  ;maybe sees dip
tplot,'thc_ef?_*'  ;data gap
tplot,'thd_ef?_*'  ;probably doesn't see
tplot,'the_ef?_*'  ;doesn't see

for i=0,4 do cdf2tplot,ptmp+'th'+thprobes[i]+'_l2_esa_20140106_v01.cdf'
tplot,'tha_peir*' ;sees spike
tplot,'thb_peir*' ;doesn't see spike
tplot,'thc_peir*' ;doesn't see spike
tplot,'thd_peir*' ;sees spike
tplot,'the_peir*' ;doesn't see spike

tplot,'tha_peer*' ;sees spike
tplot,'thb_peer*' ;doesn't see spike
tplot,'thc_peer*' ;doesn't see spike
tplot,'thd_peer*' ;sees spike
tplot,'the_peer*' ;doesn't see spike


tplot,'tha_peib*' ;nodata
tplot,'thb_peib*' ;nodata
tplot,'thc_peib*' ;nodata
tplot,'thd_peib*' ;sees spike
tplot,'the_peib*' ;nodata


tplot,'tha_peef*' ;sees spike
tplot,'thb_peef*' ;doesn't see spike
tplot,'thc_peef*' ;doesn't see spike
tplot,'thd_peef*' ;sees spike
tplot,'the_peef*' ;doesn't see spike


tplot,'tha_peeb*' ;nodata
tplot,'thb_peeb*' ;nodata
tplot,'thc_peeb*' ;nodata
tplot,'thd_peeb*' ;sees spike
tplot,'the_peeb*' ;nodata


for i=0,4 do cdf2tplot,ptmp+'th'+thprobes[i]+'_l2_fft_20140106_v01.cdf'
options,'th?_fff*','spec',0
tplot,'tha_fff*' ;sees spike
tplot,'thb_fff*' ;nodata
tplot,'thc_fff*' ;nodata
tplot,'thd_fff*' ;probably sees spike
tplot,'the_fff*' ;nodata



options,'th?_ffw*','spec',0
tplot,'tha_ffw*' ;nodata
tplot,'thb_ffw*' ;nodata
tplot,'thc_ffw*' ;nodata
tplot,'thd_ffw*' ;nodata
tplot,'the_ffw*' ;nodata

options,'th?_ffp*','spec',0
tplot,'tha_ffp*' ;nodata
tplot,'thb_ffp*' ;nodata
tplot,'thc_ffp*' ;nodata
tplot,'thd_ffp*' ;maybe sees spike
tplot,'the_ffp*' ;nodata


for i=0,4 do cdf2tplot,ptmp+'th'+thprobes[i]+'_l2_mom_20140106_v01.cdf'
tplot,'tha_pxxm*' ;probably sees spike
tplot,'thb_pxxm*' ;probably doesn't see spike
tplot,'thc_pxxm*' ;maybe sees spike
tplot,'thd_pxxm*' ;sees spike
tplot,'the_pxxm*' ;doesn't see spike


tplot,'tha_peem*' ;sees spike
tplot,'thb_peem*' ;doesn't see spike
tplot,'thc_peem*' ;probably doesn't see spike
tplot,'thd_peem*' ;sees spike
tplot,'the_peem*' ;doesn't see spike


for i=0,4 do cdf2tplot,ptmp+'th'+thprobes[i]+'_l2_scm_20140106_v01.cdf'
tplot,'tha_scp*' ;nodata
tplot,'thb_scp*' ;nodata
tplot,'thc_scp*' ;nodata
tplot,'thd_scp*' ;maybe sees spike
tplot,'the_scp*' ;nodata


tplot,'tha_scw*' ;nodata
tplot,'thb_scw*' ;nodata
tplot,'thc_scw*' ;nodata
tplot,'thd_scw*' ;probably doesn't see spike
tplot,'the_scw*' ;nodata

tplot,'tha_scf*' ;doesn't see spike
tplot,'thb_scf*' ;nodata
tplot,'thc_scf*' ;nodata
tplot,'thd_scf*' ;maybe sees spike
tplot,'the_scf*' ;nodata



;Summarize the plots that see the 21 UT event on each THEMIS sat

;THEMIS-A
tplot,'tha_'+['efs_dot0_gsm','eff_dot0_gsm','eff_q_mag','eff_q_pha','peir_density']

;THEMIS-B
;--DOESN'T OBSERVE SPIKE
;THEMIS-C
split_vec,'thc_peem_mag'
tplot,['thc_peem_mag_z','thc_pxxm_pot'] & timebar,'2014-01-06/21:00'

;THEMIS-D
tplot,'thd_'+['peir_data_quality','peir_density','peir_avgtemp','peir_vthermal','peir_sc_pot','peir_en_eflux','peir_flux','peir_magf','peir_velocity_gsm']


;thd_peer_data_quality
;thd_peer_density
;thd_peer_avgtemp
;thd_peer_vthermal
;thd_peer_en_eflux
;thd_peer_magf
;thd_peer_velocity_gsm

;thd_peib_data_quality
;thd_peib_density
;thd_peib_avgtemp
;thd_peib_vthermal
;thd_peib_en_eflux
;thd_peib_magf
;thd_peib_velocity_gsm

;thd_peef_data_quality
;thd_peef_density
;thd_peef_avgtemp
;thd_peef_vthermal
;thd_peef_en_eflux
;thd_peef_magf
;thd_peef_velocity_gsm

;thd_peeb_data_quality
;thd_peeb_density
;thd_peeb_avgtemp
;thd_peeb_vthermal
;thd_peeb_en_eflux
;thd_peeb_magf
;thd_peeb_velocity_gsm

;thd_peem_data_quality
;thd_peem_density
;thd_peem_avgtemp
;thd_peem_vthermal
;thd_peem_en_eflux
;thd_peem_magf
;thd_peem_velocity_gsm

;thd_fff_32_scm3
;thd_ffp_32_edc34
;thd_ffp_32_scm3

;thd_pxxm_pot
;thd_scf_gsm
;thd_scp_gsm


;THEMIS-E
;---Doesn't observe spike, but maybe sees some of the ULF modulation 
tplot,'the_efs_dot0_gse'



;COMBINED THEMIS PLOT FROM ALL THE SC THAT SEE THE SPIKE
tplot,['tha_eff_q_mag','tha_peef_density','thd_peef_density','thc_peem_density','tha_peir_velocity_gsm','thd_peim_velocity_gsm','thc_peim_velocity_gsm','thc_peem_mag_z','thc_pxxm_pot','tha_peer_magf','thd_peer_magf','thc_peer_magf']

rbsp_detrend,'the_peer_magf',60.*20.
tplot,'the_peer_magf_detrend'


split_vec,'th?_efs_dot0_gse'
tplot,['th?_efs_dot0_gse_x']



;----------------------------------------------
;Load CARISMA data
;----------------------------------------------

tplot_restore,filenames='/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip/carisma/carisma_jan6.tplot'
;.compile /Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip/carisma/carisma.pro
carisma

options,'ch_20140106FCHU.F01_detrend','ytitle','FCHU!Cdetrend'
options,'ch_20140106RANK.F01_detrend','ytitle','RANK!Cdetrend'
options,'ch_20140106RABB.F01_detrend','ytitle','RABB!Cdetrend'
options,'ch_20140106FSMI.F01_detrend','ytitle','FSMI!Cdetrend'
options,'ch_20140106MCMU.F01_detrend','ytitle','MCMU!Cdetrend'
options,'ch_20140106MSTK.F01_detrend','ytitle','MSTK!Cdetrend'
options,'ch_20140106VULC.F01_detrend','ytitle','VULC!Cdetrend'
options,'ch_20140106PINA.F01_detrend','ytitle','PINA!Cdetrend'
options,'ch_20140106POLS.F01_detrend','ytitle','POLS!Cdetrend'
options,'ch_20140106FSIM.F01_detrend','ytitle','FSIM!Cdetrend'
options,'ch_20140106NORM.F01_detrend','ytitle','NORM!Cdetrend'
options,'ch_20140106DAWS.F01_detrend','ytitle','DAWS!Cdetrend'
options,'ch_20140106LGRR.F01_detrend','ytitle','LGRR!Cdetrend'

;Color Stations that don't see event orange
options,['ch_20140106FSIM.F01_detrend','ch_20140106NORM.F01_detrend','ch_20140106DAWS.F01_detrend','ch_20140106LGRR.F01_detrend'],'color',200


ylim,'ch_20140106????.F01_detrend',0,0
tplot,['g1?_dtc_cor_eflux_0',$
'ch_20140106FCHU.F01_detrend',$
'ch_20140106RANK.F01_detrend',$
'ch_20140106RABB.F01_detrend',$
'ch_20140106FSMI.F01_detrend',$
'ch_20140106MCMU.F01_detrend',$
'ch_20140106MSTK.F01_detrend',$
'ch_20140106VULC.F01_detrend',$
'ch_20140106PINA.F01_detrend',$
'ch_20140106POLS.F01_detrend',$
'ch_20140106FSIM.F01_detrend',$
'ch_20140106NORM.F01_detrend',$
'ch_20140106DAWS.F01_detrend',$
'ch_20140106LGRR.F01_detrend'] ;& timebar,'2014-01-06/21:00'




;----------------------------------------------------------------------------
;VARIOUS INTERESTING PLOTS
;----------------------------------------------------------------------------


;^^overview of solar wind conditions
tplot,['omni_press_dyn','OMNI_HRO_1min_Bmag']
tplot,['coh_'+p1+p2+'_meanfilter','fspc_2K_smoothed','fspc_2L_smoothed','fspc_comb_KL'],/add


;^^Looks like the VARIATION of the dynamic pressure occurs almost entirely because of the density fluctuations
tplot,'omni_pressure_dyn_compare'


;^^At higher L, but may actually be inside of PS. W may be on edge of PP
tplot,['MLT_Kp2_2K','MLT_Kp2_2L','L_Kp2_2K','L_Kp2_2L']

;^^Maybe some minor assoc. with Bo GSE fluctuations
ylim,'fspc_2K_smoothed',40,60
ylim,'fspc_2L_smoothed',30,60
tplot,'OMNI_HRO_1min_'+['B?_GSE']
tplot,['coh_'+p1+p2+'_meanfilter','fspc_2K_smoothed','fspc_2L_smoothed','fspc_comb_KL'],/add


;^^Maybe some minor assoc. with Bo GSE fluctuations
ylim,'OMNI_HRO_1min_flow_speed',350,450
tplot,['OMNI_HRO_1min_flow_speed','clockangle','coneangle']

tplot,['coh_'+p1+p2+'_meanfilter','fspc_2K_smoothed','fspc_2L_smoothed','fspc_comb_KL'],/add



;tplot,'OMNI_HRO_1min_'+['proton_density','T','Pressure','E','Beta']
;tplot,['coh_'+p1+p2+'_meanfilter','fspc_2K_smoothed','fspc_2L_smoothed','fspc_comb_KL'],/add


;
;^^Local AE activity, but nothing directly related to 21 UT event. 
tplot,'OMNI_HRO_1min_'+['AE_INDEX']
tplot,['coh_'+p1+p2+'_meanfilter','fspc_2K_smoothed','fspc_2L_smoothed','fspc_comb_KL'],/add


;^^Minor storm with some few hr fluctuations. No clear assoc. with precipitation
tplot,'OMNI_HRO_1min_'+['SYM_D','SYM_H','ASY_D','ASY_H','PC_N_INDEX']
tplot,['coh_'+p1+p2+'_meanfilter','fspc_2K_smoothed','fspc_2L_smoothed','fspc_comb_KL'],/add


;^^Some clear correlations of SW dynamic pressure and precipitation
rbsp_detrend,'OMNI_HRO_1min_'+['proton_density','T','Pressure','E','Beta'],1.*60.
rbsp_detrend,'OMNI_HRO_1min_'+['proton_density','T','Pressure','E','Beta']+'_smoothed',80.*60.
tlimit,'2014-01-06/16:00','2014-01-07/00:00'
ylim,'omni_press_dyn_smoothed_detrend',-0.25,0.25
;tplot,'OMNI_HRO_1min_'+['T','E','Beta']+'_smoothed_detrend'
tplot,'omni_press_dyn_smoothed_detrend';,/add
;tplot,['coh_'+p1+p2+'_meanfilter','fspc_2K_smoothed','fspc_2L_smoothed','fspc_comb_KL'],/add
tplot,['fspc_comb_KL'],/add


tplot,'omni_press_dyn_smoothed_detrend'
tplot,['fspc_comb_KL'],/add



;^^Comparison with GOES flux. 
timespan,'2014-01-06/00:00',24,/hours
tplot,['OMNI_HRO_1min_AE_INDEX','wi_press_dyn_smoothed','omni_press_dyn_smoothed','g1?_dtc_cor_eflux','OMNI_HRO_1min_AE_INDEX','OMNI_HRO_1min_bmag','OMNI_HRO_1min_BX_GSE','OMNI_HRO_1min_BY_GSM','OMNI_HRO_1min_BZ_GSM','fspc_2?_smoothed']



timespan,'2014-01-06/06:00',8,/hours
tplot,['g13_dtc_cor_eflux_0','omni_press_dyn_smoothed']


;^^comparison with hiss and/or boundary chorus amplitudes 
;Modulation with hiss/chorus more likely to do with RBSPa coming out of perigee than anything to do with Pdyn SW. 
timespan,'2014-01-10/15:00',9,/hours
tplot,['g1?_dtc_cor_eflux','rbspa_fbk2_7pk_3','rbspa_fbk2_7pk_4','rbspa_fbk2_7pk_5','omni_press_dyn_smoothed','fspc_2K_smoothed','fspc_2L_smoothed','fspc_2X_smoothed','fspc_2T_smoothed']



;^^Stack plot of various payloads that see the double-peaked event. 
    ;ACE --> BRTN components.
    ;Wind --> sees a tiny density blip spanning ~3 data points (NOT SURE I CAN BELIEVE IT) 
    ;Cluster 4 --> density and velocity in morning magnetosheath

timespan,'2014-01-06/18:00',5,/hours
tplot,['wi_h0_mfi_B3GSE','wi_hires_proton_density','ac_BRTN',$
'c4_np','c4_VGSE',$
'tha_peef_density','tha_peir_velocity_gsm','tha_peer_magf','thd_peef_density','thd_peim_velocity_gsm','thd_peer_magf','thc_peem_mag_z'] & timebar,'2014-01-06/21:00'
  stop

end

;Wind and ACE comparison show that a simple timeshift based on SC position and constant Vsw=350 km/s
;doesn't work well. Compare to THb and THc, which are either in sw or in foreshock.  
split_vec,'wi_h0_mfi_B3GSE'
split_vec,'ac_BGSEc'
split_vec,'thb_fgs_gse'

store_data,'omni_wi_xgse',data=['OMNI_HRO_1min_BX_GSE','wi_h0_mfi_B3GSE_x']
store_data,'omni_wi_ygse',data=['OMNI_HRO_1min_BY_GSE','wi_h0_mfi_B3GSE_y']
store_data,'omni_wi_zgse',data=['OMNI_HRO_1min_BZ_GSE','wi_h0_mfi_B3GSE_z']

timespan,'2014-01-06/19:00',3,/hours
tplot,['omni_wi_xgse','ac_BGSEc_x','thb_fgs_gse_x'] & timebar,'2014-01-06/21:00'
tplot,['omni_wi_ygse','ac_BGSEc_y','thb_fgs_gse_y'] & timebar,'2014-01-06/21:00'
tplot,['omni_wi_zgse','ac_BGSEc_z','thb_fgs_gse_z'] & timebar,'2014-01-06/21:00'


tplot,['thb_fgs_gse','thd_fgs_gse']


tplot,'thb_peif_magt3'
tplot,'thb_peif_magf'
tplot,'thb_peef_magt3'
tplot,'thb_peef_magf'
tplot,'thb_peir_magt3'
tplot,'thb_peir_magf'
tplot,'thb_peer_magt3'
tplot,'thb_scf_gse'





;^^TEST TO SEE IF CLUSTER 4 IS SEEING A FLAPPING MAGNETOPAUSE 
;First plot SW characteristics (Vsw = 350 km/s; n = 2.5 cm-3)
tplot,['OMNI_HRO_1min_flow_speed','OMNI_HRO_1min_proton_density']  
tplot,['c4_np','c4_vmag','c4_VGSE','thd_peim_velocity_gse','tha_peim_velocity_gse']
tplot,['c4_VGSE','thd_peim_velocity_gse','tha_peim_velocity_gse']
;Plot velocity magnitudes. This clearly shows that C4 sees event first. 
get_data,'c4_VGSE',t,d  & store_data,'c4_vmag',t,sqrt(d[*,0]^2 + d[*,1]^2 + d[*,2]^2)
get_data,'thd_peim_velocity_mag',t,d  & store_data,'thd_peim_velocity_mag',t,sqrt(d[*,0]^2 + d[*,1]^2 + d[*,2]^2)
get_data,'tha_peim_velocity_mag',t,d  & store_data,'tha_peim_velocity_mag',t,sqrt(d[*,0]^2 + d[*,1]^2 + d[*,2]^2)
tplot,['c4_vmag','thd_peim_velocity_mag','tha_peim_velocity_mag']
;Plot densities. Shows that THD sees event before THA. C4 sees a different density modification - due 
;to being pushed into SW - but we know it sees it first b/c of velocity fluctuations. 
tplot,['c4_np','tha_peir_density','tha_peir_density']


;^^Attempt to establish timing of the double-peaked signal. 
;NOTE: we're not going to use C4 here. It definitely sees the signal first, but it sees
;a different signal due to being pushed into the SW.
split_vec,'tha_peim_velocity_gse'
split_vec,'thd_peim_velocity_gse'

ylim,'ch_20140106????.F01_detrend',0,0
tplot,['thd_peim_velocity_mag','tha_peim_velocity_mag',$
'thd_peir_density','tha_peir_density',$
'g13_dtc_cor_eflux_0',$
'fspc_2L_smoothed']
;^^Best comparison seems to be b/t THD and 2L. They share the most features. 
rbsp_detrend,'thd_peim_velocity_mag',60.*1.
rbsp_detrend,'thd_peim_velocity_gse_?',60.*1.
rbsp_detrend,'tha_peim_velocity_mag',60.*1.
rbsp_detrend,'tha_peim_velocity_gse_?',60.*1.
split_vec,'thd_peim_velocity_gsm'
split_vec,'tha_peim_velocity_gsm'
rbsp_detrend,'thd_peim_velocity_gsm_?',60.*1.
rbsp_detrend,'tha_peim_velocity_gsm_?',60.*1.
tplot,['fspc_2L_smoothed','thd_peim_velocity_mag_smoothed','thd_peim_velocity_gse_?_smoothed']
tplot,['fspc_2L_smoothed','thd_peim_velocity_mag_smoothed','thd_peim_velocity_gsm_?_smoothed']
;Times of double peaks in THD data
;2014-01-06/20:56:55.773734
;2014-01-06/20:58:32.281195
;Times of double peaks in 2L data
;2014-01-06/20:57:42.958832
;2014-01-06/20:59:30.944573
;Delta times for the two peaks 
dt1 = 47 ;sec 
dt2 = 58 ;sec

;Now try to determine delay b/t THD and THA
tlag = 130.
get_data,'thd_peim_velocity_gse_x_smoothed',t,d & store_data,'thd_peim_velocity_gse_x_smoothed_lagged',t+tlag,d/2.
get_data,'thd_peim_velocity_gse_y_smoothed',t,d & store_data,'thd_peim_velocity_gse_y_smoothed_lagged',t+tlag,d/2.
get_data,'thd_peim_velocity_gse_z_smoothed',t,d & store_data,'thd_peim_velocity_gse_z_smoothed_lagged',t+tlag,d/2.
get_data,'thd_peim_velocity_mag_smoothed',t,d & store_data,'thd_peim_velocity_mag_smoothed_lagged',t+tlag,d/2.
store_data,'gsexcomb',data=['thd_peim_velocity_gse_x_smoothed_lagged','tha_peim_velocity_gse_x_smoothed'] & options,'gsexcomb','colors',[0,250]
store_data,'gseycomb',data=['thd_peim_velocity_gse_y_smoothed_lagged','tha_peim_velocity_gse_y_smoothed'] & options,'gseycomb','colors',[0,250]
store_data,'gsezcomb',data=['thd_peim_velocity_gse_z_smoothed_lagged','tha_peim_velocity_gse_z_smoothed'] & options,'gsezcomb','colors',[0,250]
store_data,'gsemagcomb',data=['thd_peim_velocity_mag_smoothed_lagged','tha_peim_velocity_mag_smoothed'] & options,'gsemagcomb','colors',[0,250]
tplot,['gsexcomb','gseycomb','gsezcomb','gsemagcomb'] & timebar,['2014-01-06/21:00:30','2014-01-06/21:01:30']
;Aligning by the big peak, the lag b/t THD and THA seems to be about 120 sec. 

;THD-THA separation is almost entirely in XGSE direction 
thagse = [2.79, 9.15, -1.14]
thdgse = [6.99, 8.81, 0.94]
difftmp = thdgse-thagse
sep_tha_thd = difftmp[0]
;separation = 4.7 RE
vel_straight_line = sep_tha_thd*6370./130.
;velocity = 205 km/s --> This is more than twice the average xGSE velocity of 105 km/s as measured from 
;THD (150 km/s) and THA (60 km/s). This suggests that the velocity is mostly NOT in the xGSE direction. 







;same plot but with CARISMA payloads
tplot,['tha_peim_velocity_gse_x','tha_peir_density',$
'thd_peim_velocity_gse_x','thd_peir_density',$
'g13_dtc_cor_eflux_0',$
'fspc_2L_smoothed',$
'ch_20140106FCHU.F01_detrend',$
'ch_20140106RANK.F01_detrend',$
'ch_20140106RABB.F01_detrend',$
'ch_20140106POLS.F01_detrend']


;'ch_20140106FSMI.F01_detrend',$
;'ch_20140106MCMU.F01_detrend',$
;'ch_20140106MSTK.F01_detrend',$
;'ch_20140106VULC.F01_detrend',$
;'ch_20140106PINA.F01_detrend',$







;-----------------------------------------------------------------------
;-----------------------------------------------------------------------
;Make a dial plot of all relevant payload locations. 
;********IN PROGRESS*********
;-----------------------------------------------------------------------
;-----------------------------------------------------------------------



;Plot RBSPa,b locations
plot_plasmapause_goldstein_boundary,'2014-01-06/21:00',15.8,4.5,payloadname='RBa'
plot_plasmapause_goldstein_boundary,'2014-01-06/21:00',14.4,5.6,/oplot,payloadname='RBb'

;Plot Carisma locations
;; Surviving list of stations with observations on Jan 6th at 21 UT
;; DAWS  L = 6.09000  MLT = 12.0217
;; FCHU  L = 7.44000  MLT = 15.7792
;; FSIM  L = 6.78000  MLT = 13.6275
;; FSMI  L = 6.81000  MLT = 14.4316
;; LGRR  L = 4.55000  MLT = 15.9792
;; MCMU  L = 5.35000  MLT = 14.6164
;; MSTK  L = 4.22000  MLT = 14.6168
;; NORM  L = 8.31000  MLT = 13.0814
;; PINA  L = 4.06000  MLT = 16.0319
;; POLS  L = 3.04000  MLT = 14.8075
;; RABB  L = 6.57000  MLT = 15.1244
;; RANK  L = 10.8900  MLT = 15.7600
;; VULC  L = 3.55000  MLT = 14.7606
plot_plasmapause_goldstein_boundary,'2014-01-06/21:00',12.02,6.09,/oplot,payloadname='DAWS'
plot_plasmapause_goldstein_boundary,'2014-01-06/21:00',15.77,7.44,/oplot,payloadname='FCHU'
plot_plasmapause_goldstein_boundary,'2014-01-06/21:00',13.63,6.78,/oplot,payloadname='FSIM'
plot_plasmapause_goldstein_boundary,'2014-01-06/21:00',14.43,6.81,/oplot,payloadname='FSMI'
plot_plasmapause_goldstein_boundary,'2014-01-06/21:00',15.98,4.55,/oplot,payloadname='LGRR'
plot_plasmapause_goldstein_boundary,'2014-01-06/21:00',14.62,5.35,/oplot,payloadname='MCMU'
plot_plasmapause_goldstein_boundary,'2014-01-06/21:00',14.62,4.22,/oplot,payloadname='MSTK'
plot_plasmapause_goldstein_boundary,'2014-01-06/21:00',13.08,8.31,/oplot,payloadname='NORM'
plot_plasmapause_goldstein_boundary,'2014-01-06/21:00',16.03,4.06,/oplot,payloadname='PINA'
plot_plasmapause_goldstein_boundary,'2014-01-06/21:00',14.80,3.04,/oplot,payloadname='POLS'
plot_plasmapause_goldstein_boundary,'2014-01-06/21:00',15.12,6.57,/oplot,payloadname='RABB'
plot_plasmapause_goldstein_boundary,'2014-01-06/21:00',15.76,10.89,/oplot,payloadname='RANK'
plot_plasmapause_goldstein_boundary,'2014-01-06/21:00',14.76,3.55,/oplot,payloadname='VULC'

;Plot Cluster locations (via C4, which is representative of all of them)
plot_plasmapause_goldstein_boundary,'2014-01-06/21:00',16.,24.9,/oplot,payloadname='C4'
;2014   6 21:00:30 cluster1 16:07:40      23.8
;2014   6 21:00:30 cluster2 15:56:23      24.5
;2014   6 21:00:30 cluster3 16:05:07      24.9
;2014   6 21:00:30 cluster4 16:05:33      24.9
;2014   6 21:00:30 cluster1       7.50      14.06     -10.79 16:07:40      23.8
;2014   6 21:00:30 cluster2       8.51      14.22     -10.76 15:56:23      24.5
;2014   6 21:00:30 cluster3       7.42      13.54     -11.45 16:05:07      24.9
;2014   6 21:00:30 cluster4       7.38      13.52     -11.48 16:05:33      24.9

c1 = [7.5,14.06,-10.79]
c4 = [7.38,13.52,-11.48]

c41 = c4 - c1
c41sep = sqrt(c41[0]^2 + c41[1]^2 + c41[2]^2)

;Plot GOES locations
plot_plasmapause_goldstein_boundary,'2014-01-06/21:00',16.1,6.7,/oplot,payloadname='G13'
plot_plasmapause_goldstein_boundary,'2014-01-06/21:00',12.1,6.6,/oplot,payloadname='G15'

;Plot THEMIS locations
plot_plasmapause_goldstein_boundary,'2014-01-06/21:00',16.87,9.6,payloadname='THA',xrange=[-60,60],yrange=[-60,60]
plot_plasmapause_goldstein_boundary,'2014-01-06/21:00',16.95,64.1,/oplot,payloadname='THB'
plot_plasmapause_goldstein_boundary,'2014-01-06/21:00',16.78,62.2,/oplot,payloadname='THC'
plot_plasmapause_goldstein_boundary,'2014-01-06/21:00',15.43,11.3,/oplot,payloadname='THD'
plot_plasmapause_goldstein_boundary,'2014-01-06/21:00',13.07,5.3,/oplot,payloadname='THE'






end






