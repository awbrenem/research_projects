;WK at ~21 UT
;****MAY BE THE ONLY PAYLOAD COMBO WITH SIGNIFICANT CORRELATION ON THIS DAY, BUT NEED TO SEARCH FOR OTHER EVENTS. 

;Narrative: 
;Definite correlation b/t SW dynamic pressure and precipitation. 
;^^Looks like the VARIATION of the dynamic pressure occurs mostly because of the density fluctuations


;pro event_analysis_jan5

  rbsp_efw_init
  tplot_options,'title','event_analysis_jan5.pro'

	tplot_options,'xmargin',[20.,16.]
	tplot_options,'ymargin',[3,9]
	tplot_options,'xticklen',0.08
	tplot_options,'yticklen',0.02
	tplot_options,'xthick',2
	tplot_options,'ythick',2
	tplot_options,'labflag',-1	
	pre = '2'
  timespan,'2014-01-05'

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

fntmp = 'all_coherence_plots_combined_omni_press_dyn.tplot'
tplot_restore,filenames='/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/'+'coh_vars_barrelmission'+pre+'/'+fntmp
fntmp = 'all_coherence_plots_combined.tplot'
tplot_restore,filenames='/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/'+'coh_vars_barrelmission'+pre+'/'+fntmp


;Restore individual payload FSPC data
path = args_manual.datapath + args_manual.folder_singlepayload + '/'
fn = 'barrel_2I_fspc_fullmission.tplot' & tplot_restore,filenames=path + fn
fn = 'barrel_2K_fspc_fullmission.tplot' & tplot_restore,filenames=path + fn
fn = 'barrel_2W_fspc_fullmission.tplot' & tplot_restore,filenames=path + fn
fn = 'barrel_2X_fspc_fullmission.tplot' & tplot_restore,filenames=path + fn




;Restore individual coherence spectra
path = args_manual.datapath + args_manual.folder_coh + '/'
fn = 'KX_meanfilter.tplot' & tplot_restore,filenames=path + fn
fn = 'WK_meanfilter.tplot' & tplot_restore,filenames=path + fn
fn = 'WX_meanfilter.tplot' & tplot_restore,filenames=path + fn
fn = 'IK_meanfilter.tplot' & tplot_restore,filenames=path + fn
fn = 'IX_meanfilter.tplot' & tplot_restore,filenames=path + fn
fn = 'IW_meanfilter.tplot' & tplot_restore,filenames=path + fn

tnt = tnames('coh_??_meanfilter')
for i=0,n_elements(tnt)-1 do options,tnt[i],'ytitle', strmid(tnt[i],4,2)



tplot,['coh_allcombos_meanfilter_normalized2','coh_allcombos_meanfilter_normalized2_OMNI_press_dyn','coh_??_meanfilter']





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

timespan,'2014-01-05/18:00',6,/hours
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

kyoto_load_ae

t0tmp = time_double('2014-01-05/00:00')
t1tmp = time_double('2014-01-06/00:00')
plot_omni_quantities,t0avg=t0tmp,t1avg=t1tmp

tplot,['kyoto_ae','coh_allcombos_meanfilter_normalized2','coh_allcombos_meanfilter_normalized2_OMNI_press_dyn','coh_IW_meanfilter','fspc_2I_smoothed','fspc_2W_smoothed','coh_WK_meanfilter','fspc_2K_smoothed'],/add



;tplot,['omni_Np','omni_elect_density']+'_smoothed_detrend'
tplot,['coh_allcombos_meanfilter_normalized2','coh_allcombos_meanfilter_normalized_OMNI_press_dyn','omni_press_dyn_smoothed','fspc_2?_smoothed']
tplot,['coh_allcombos_meanfilter_normalized2','coh_allcombos_meanfilter_normalized_OMNI_press_dyn','omni_press_dyn_smoothed_detrend','fspc_2?_smoothed_detrend']


tplot,['omni_Np','omni_elect_density']
tplot,['omni_press_dyn']
tplot,['omni_press_dyn','omni_press_dyn_smoothed_detrend']
tplot,'fspc_2?_smoothed_detrend',/add


;^^Check Vsw flow speed 
tplot,'OMNI_HRO_1min_flow_speed'
tplot,['fspc_comb_LX'],/add

;^^Check solar wind density
tplot,'OMNI_HRO_1min_proton_density'



tplot,['IMF_orientation_comb','Bz_rat_comb','clockangle_comb','coneangle_comb']
tplot,['clockangle_comb','coneangle_comb','kyoto_ae','kyoto_dst','OMNI_HRO_1min_flow_speed']


tplot,['clockangle_comb','coneangle_comb','OMNI_HRO_1min_flow_speed','fspc_2W_smoothed_detrend','fspc_2K_smoothed_detrend']
tplot,['fspc_comb_WK'],/add



;-----------------------------------------------
;LOAD THEMIS DATA
;-----------------------------------------------

;THA
path = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/Analysis_major_events/jan5/'
cdf2tplot,path+'tha_l2_efi_20140105_v01.cdf'
cdf2tplot,path+'tha_l2_fgm_20140105_v01.cdf'
rbsp_detrend,'tha_fgs_btotal',60.*10.
rbsp_detrend,'tha_fgs_btotal_smoothed',60.*80.
tplot,['tha_fgs_btotal_smoothed_detrend','fspc_2W_smoothed_detrend']

;THB is in SW
cdf2tplot,path+'thb_l2_efi_20140105_v01.cdf'
cdf2tplot,path+'thb_l2_fgm_20140105_v01.cdf'
get_data,'thb_fgs_btotal',t,d 
store_data,'thb_fgs_btotal',t,abs(d)
rbsp_detrend,'thb_fgs_btotal',60.*10.
rbsp_detrend,'thb_fgs_btotal_smoothed',60.*80.

;THC is in SW
cdf2tplot,path+'thc_l2_efi_20140105_v01.cdf'
cdf2tplot,path+'thc_l2_fgm_20140105_v01.cdf'
get_data,'thc_fgs_btotal',t,d 
store_data,'thc_fgs_btotal',t,abs(d)
rbsp_detrend,'thc_fgs_btotal',60.*10.
rbsp_detrend,'thc_fgs_btotal_smoothed',60.*80.

;THD
cdf2tplot,path+'thd_l2_efi_20140105_v01.cdf'
cdf2tplot,path+'thd_l2_fgm_20140105_v01.cdf'
rbsp_detrend,'thd_fgs_btotal',60.*10.
rbsp_detrend,'thd_fgs_btotal_smoothed',60.*80.
;2W and THA/THD see same fluctuations
tplot,['thd_fgs_btotal_smoothed_detrend','tha_fgs_btotal_smoothed_detrend','fspc_2W_smoothed_detrend']
tplot,['thd_fgs_btotal_smoothed','tha_fgs_btotal_smoothed','fspc_2W_smoothed']





;2W and THB see some similar fluctuations
tplot,['thb_fgs_btotal_smoothed_detrend','thc_fgs_btotal_smoothed_detrend','fspc_2W_smoothed_detrend']
tplot,['thb_fgs_btotal_smoothed','thc_fgs_btotal_smoothed','fspc_2W_smoothed']



cdf2tplot,path+'the_l2_efi_20140105_v01.cdf'
cdf2tplot,path+'the_l2_fgm_20140105_v01.cdf'

;subtract off background field 
rbsp_detrend,'the_fgs_btotal',60.*2. 
rbsp_detrend,'the_fgs_btotal_smoothed',60.*5.
dif_data,'the_fgs_btotal','the_fgs_btotal_smoothed_smoothed',newname='the_bdiff'
rbsp_detrend,'the_bdiff',60.*5.
ylim,'the_bdiff_smoothed',-0.2,0.2
tplot,['the_bdiff_smoothed','fspc_2W_smoothed_detrend']


rbsp_detrend,'the_fgs_btotal',60.*10.
rbsp_detrend,'the_fgs_btotal_smoothed',60.*80.
ylim,'the_fgs_btotal_smoothed_detrend',-30,30
tplot,['the_fgs_btotal_smoothed_detrend','fspc_2W_smoothed_detrend']



cdf2tplot,path+'tha_l2_mom_20140105_v01.cdf'
cdf2tplot,path+'thb_l2_efi_20140105_v01.cdf'
cdf2tplot,path+'thb_l2_fgm_20140105_v01.cdf'
cdf2tplot,path+'thb_l2_mom_20140105_v01.cdf'
cdf2tplot,path+'thc_l2_efi_20140105_v01.cdf'
cdf2tplot,path+'thc_l2_fgm_20140105_v01.cdf'
cdf2tplot,path+'thc_l2_mom_20140105_v01.cdf'
cdf2tplot,path+'thd_l2_efi_20140105_v01.cdf'
cdf2tplot,path+'thd_l2_fgm_20140105_v01.cdf'
cdf2tplot,path+'thd_l2_mom_20140105_v01.cdf'
cdf2tplot,path+'the_l2_efi_20140105_v01.cdf'
cdf2tplot,path+'the_l2_fgm_20140105_v01.cdf'
cdf2tplot,path+'the_l2_mom_20140105_v01.cdf'








;---------------------------------------
;Plot location of balloon payloads
;---------------------------------------

plot_dial_payload_location_specific_time,'2014-01-05/21:00'



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

;Wind is about ~195 RE upstream. Vsw is 400 km/s. Thus SW will take ~52 minutes to propagte to Earth.
;This is consistent with OMNI_HR0_1min_Timeshift, which shows values of ~3000 sec, or about 50 min. 
tplot,['wi_SC_pos_gse','wi_swe_V_GSE']
ttst = time_double('2014-01-05/22:00')
coord = tsample('wi_SC_pos_gse',ttst,times=t)


split_vec,'wi_swe_V_GSE'
store_data,['P_DENS','V_GSE','Np','elect_density','SC_pos_gse'],/delete


;Apply the rough timeshift 
get_data,'wi_dens_hires',data=d & store_data,'wi_dens_hires',data={x:d.x+(52.*60.),y:d.y}
get_data,'wi_swe_V_GSE',data=d & store_data,'wi_swe_V_GSE',data={x:d.x+(52.*60.),y:d.y}
get_data,'wi_Np',data=d & store_data,'wi_Np',data={x:d.x+(52.*60.),y:d.y}
get_data,'wi_elect_density',data=d & store_data,'wi_elect_density',data={x:d.x+(52.*60.),y:d.y}
get_data,'wi_h0_mfi_bmag',data=d & store_data,'wi_h0_mfi_bmag',data={x:d.x+(52.*60.),y:d.y}
get_data,'wi_h0_mfi_B3GSE',data=d & store_data,'wi_h0_mfi_B3GSE',data={x:d.x+(52.*60.),y:d.y}


rbsp_detrend,['wi_dens_hires','wi_swe_V_GSE','wi_Np','wi_elect_density','wi_h0_mfi_bmag','wi_h0_mfi_B3GSE'],15.*100.
rbsp_detrend,['wi_dens_hires','wi_swe_V_GSE','wi_Np','wi_elect_density','wi_h0_mfi_bmag','wi_h0_mfi_B3GSE']+'_smoothed',60.*80.





tplot,['wi_dens_hires','wi_h0_mfi_bmag','wi_h0_mfi_B3GSE']+'_smoothed'
tplot,['fspc_2W_smoothed','fspc_2K_smoothed'],/add

;Best bet for correlation w/ SW
tplot,['wi_dens_hires_smoothed_detrend','fspc_2W_smoothed_detrend']
tplot,['wi_dens_hires_smoothed','fspc_2W_smoothed'],/add



;--------------------------------------------------
;Calculate Wind dynamic pressure as n*v^2
;From OMNIWeb:
;Flow pressure = (2*10**-6)*Np*Vp**2 nPa (Np in cm**-3, 
;Vp in km/s, subscript "p" for "proton")
;(NOTE THAT THIS CAN DIFFER STRONGLY FROM OMNI DATA, PRESUMABLY DUE TO SW EVOLUTION)
;--------------------------------------------------

split_vec,'wi_swe_V_GSE'



;Use these to find average values for pressure comparison. 
t0tmp = time_double('2014-01-05/20:00')
t1tmp = time_double('2014-01-05/21:00')
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

rbsp_detrend,'wi_press_dyn',60.*5.
rbsp_detrend,'wi_press_dyn_smoothed',80.*60.


;tplot,['wi_Np','wi_elect_density']+'_smoothed_detrend'
tplot,['wi_press_dyn_smoothed_detrend','wi_h0_mfi_bmag_smoothed_detrend','wi_h0_mfi_B3GSE_smoothed_detrend']
tplot,['fspc_comb_WK'],/add



;Compare Wind and OMNI dynamic pressure
tplot,['wi_press_dyn_smoothed_detrend','omni_press_dyn_smoothed_detrend']
tplot,['fspc_comb_WK'],/add


;Comparison of Wind and 2W precip 
tplot,['wi_press_dyn_smoothed','fspc_2W_smoothed']+'_detrend'



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
tplot,['coh_KW_meanfilter','fspc_2W_smoothed','fspc_2K_smoothed','fspc_comb_WK'],/add

fn = 'goes13_eps-mageds_1min_20140101000000_20140214114500.cdf' & cdf2tplot,path+fn,prefix='g13_'
fn = 'goes15_eps-mageds_1min_20140101000000_20140214114500.cdf' & cdf2tplot,path+fn,prefix='g15_'
tplot,'g1?_dtc_cor_eflux_t_stack1'

fn = 'goes13_eps-pitchs_angles_1min_20140101000000_20140214114500.cdf' & cdf2tplot,path+fn,prefix='g13_'
fn = 'goes15_eps-pitchs_angles_1min_20140101000000_20140214114500.cdf' & cdf2tplot,path+fn,prefix='g15_'
tplot,'g1?_pitch_angles'


;^^overview including GOES data
tplot,['g13_dtc_cor_eflux','omni_press_dyn','OMNI_HRO_1min_Bmag']
tplot,['coh_KW_meanfilter','fspc_2W_smoothed','fspc_2K_smoothed','fspc_comb_WK'],/add


split_vec,'g1?_dtc_cor_eflux'
rbsp_detrend,'g1?_dtc_cor_eflux_?',60.*80.
ylim,['g1?_dtc_cor_eflux_?_detrend'],-5000,5000
tplot,['g13_dtc_cor_eflux_?']+'_detrend'

tplot,['g1?_dtc_cor_eflux_0_detrend','fspc_2W_smoothed_detrend','fspc_2K_smoothed_detrend']


;^^overview plot with GOES data. This strongly suggests that the 60 min periodicity 
;with high coherence is triggered by drift echoes. 
split_vec,'g15_dtc_cor_eflux'
tplot,'g15_dtc_cor_eflux_?'
rbsp_detrend,'g15_dtc_cor_eflux_0',60.*5.
rbsp_detrend,'g1?_dtc_cor_eflux_0_smoothed',60.*60.

ylim,'g1?_dtc_cor_eflux',1d4,1d6,1
tplot,['g1?_dtc_cor_eflux_0_smoothed_detrend','omni_press_dyn','OMNI_HRO_1min_Bmag']
tplot,['coh_'+p1+p2+'_meanfilter','fspc_2W_smoothed','fspc_2K_smoothed','fspc_comb_WK','omni_press_dyn_smoothed_detrend'],/add






;---------------------------------------------------
;Load Cluster 4 data 
;All Cluster sc are close together in the magnetosheath (I think) 
;---------------------------------------------------

ptmp = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/Analysis_major_events/Jan5/'

cdf2tplot,ptmp+'c1_cps_fgm_spin_20140105000002_20140105235858.cdf'
cdf2tplot,ptmp+'c1_pps_efw_20140105000002_20140105235858.cdf'
cdf2tplot,ptmp+'c1_pps_pea_20140105000002_20140105235501.cdf'
rbsp_detrend,['T_e_par__C1_PP_PEA','N_e_den__C1_PP_PEA'],60.*5.
rbsp_detrend,['T_e_par__C1_PP_PEA_smoothed','N_e_den__C1_PP_PEA_smoothed'],60.*80.

tplot,['E_dusk__C1_PP_EFW_smoothed_detrend','fspc_2W_smoothed_detrend']

cdf2tplot,ptmp+'c2_cps_fgm_spin_20140105000000_20140105235858.cdf'
cdf2tplot,ptmp+'c2_pps_efw_20140105000002_20140105235858.cdf'
cdf2tplot,ptmp+'c2_pps_pea_20140105000004_20140105235858.cdf'
cdf2tplot,ptmp+'c3_cps_fgm_spin_20140105000003_20140105235859.cdf'
cdf2tplot,ptmp+'c3_pps_efw_20140105000002_20140105235858.cdf'
cdf2tplot,ptmp+'c3_pps_pea_20140105000008_20140105235838.cdf'
cdf2tplot,ptmp+'c4_cps_fgm_spin_20140105000000_20140105235856.cdf'
cdf2tplot,ptmp+'c4_pps_efw_20140105000002_20140105235858.cdf'
cdf2tplot,ptmp+'c4_pps_pea_20140105000005_20140105235619.cdf'

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


;------------------------------------------------------------------
;LOAD RBSP DATA 
;------------------------------------------------------------------

;       type  ->  'hope','mageis','rept'

ptmp = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/Analysis_major_events/Jan5/'
cdf2tplot,ptmp+'rbspa_efw-l2_e-spinfit-mgse_20140105_v01.cdf',prefix='rbspa_'
cdf2tplot,ptmp+'rbspb_efw-l2_e-spinfit-mgse_20140105_v01.cdf',prefix='rbspb_'

cdf2tplot,ptmp+'rbspa_efw-l3_20140105_v01.cdf',prefix='rbspa_'
cdf2tplot,ptmp+'rbspb_efw-l3_20140105_v01.cdf',prefix='rbspb_'
rbsp_detrend,'rbsp?_density',60.*5.
rbsp_detrend,'rbsp?_density_smoothed',60.*20.


tplot,['fspc_2W_smoothed_detrend','rbspa_density_smoothed_detrend','rbspb_density_smoothed_detrend']


rbsp_load_ect_l3,'a','hope'







;----------------------------------------------------------------------------
;VARIOUS INTERESTING PLOTS
;----------------------------------------------------------------------------


;^^overview of solar wind conditions
tplot,['omni_press_dyn','OMNI_HRO_1min_Bmag']
tplot,['fspc_2W_smoothed','fspc_2K_smoothed','fspc_comb_WK'],/add


;^^Looks like the VARIATION of the dynamic pressure occurs mostly because of the density fluctuations
tplot,'omni_pressure_dyn_compare'


;^^At higher L, but may actually be inside of PS. W may be on edge of PP
tplot,['MLT_Kp2_2W','MLT_Kp2_2K','L_Kp2_2W','L_Kp2_2K']

;^^Maybe some minor assoc. with Bo GSE fluctuations
ylim,'fspc_2W_smoothed',40,60
ylim,'fspc_2K_smoothed',30,60
tplot,'OMNI_HRO_1min_'+['B?_GSE']
tplot,['fspc_2W_smoothed','fspc_2K_smoothed','fspc_comb_WK'],/add


;^^Maybe some minor assoc. with Bo GSE fluctuations
ylim,'OMNI_HRO_1min_flow_speed',350,450
tplot,'OMNI_HRO_1min_'+['V?','flow_speed']
tplot,['fspc_2W_smoothed','fspc_2K_smoothed','fspc_comb_WK'],/add


;;
;tplot,'OMNI_HRO_1min_'+['proton_density','T','Pressure','E','Beta']
;tplot,['coh_'+p1+p2+'_meanfilter','fspc_2W_smoothed','fspc_2K_smoothed','fspc_comb_WK'],/add


;^^Some similar periodicities with AE index on ULF timescales
;^^For full day, 3 AE spikes and 3 precipitation spikes. 
tplot,'OMNI_HRO_1min_'+['AE_INDEX']
tplot,['fspc_2W_smoothed','fspc_2K_smoothed','fspc_comb_WK'],/add


;^^Minor storm with some few hr fluctuations. No clear assoc. with precipitation
tplot,'OMNI_HRO_1min_'+['SYM_D','SYM_H','ASY_D','ASY_H','PC_N_INDEX']
tplot,['fspc_2W_smoothed','fspc_2K_smoothed','fspc_comb_WK'],/add


;^^Very clear correlation of SW dynamic pressure and precipitation
rbsp_detrend,'OMNI_HRO_1min_'+['proton_density','T','Pressure','E','Beta'],10.*60.
rbsp_detrend,'OMNI_HRO_1min_'+['proton_density','T','Pressure','E','Beta']+'_smoothed',60.*60.
tlimit,'2014-01-05/16:00','2014-01-06/00:00'
;tplot,'OMNI_HRO_1min_'+['T','E','Beta']+'_smoothed_detrend'
tplot,'omni_press_dyn_smoothed_detrend';,/add
;tplot,['coh_'+p1+p2+'_meanfilter','fspc_2W_smoothed','fspc_2K_smoothed','fspc_comb_WK'],/add
tplot,['fspc_comb_WK'],/add


;^^Also look at 2X near 16-17 UT, to see if it can see SW pressure fluctuations. 
;At this time it's in the same position K is about 2 hrs later, when IT sees the fluctuations. 

rbsp_detrend,['fspc_2W','fspc_2K','fspc_2X'],60.*5.
;rbsp_detrend,['fspc_2W','fspc_2K','fspc_2X']+'_smoothed',60.*80.

store_data,'WKX_comb',data=['fspc_2W','fspc_2K','fspc_2X'] + '_smoothed'
ylim,'WKX_comb',30,60
options,'WKX_comb','colors',[0,50,250]
tplot,'WKX_comb'
tplot,'omni_press_dyn_smoothed_detrend',/add

ylim,'fspc_2W_smoothed',40,60
ylim,'fspc_2K_smoothed',35,60
ylim,'fspc_2X_smoothed',30,40
rbsp_detrend,['fspc_2W','fspc_2K','fspc_2X']+'_smoothed',60.*60.
tplot,['fspc_2W','fspc_2K','fspc_2X'] + '_smoothed_detrend'
tplot,'omni_press_dyn_smoothed_detrend',/add



tplot,'omni_press_dyn_smoothed_detrend'
tplot,['fspc_comb_WK'],/add



;^^See how large-scale the coherence is. 
tplot,['thd_fgs_btotal_smoothed_detrend','tha_fgs_btotal_smoothed_detrend','fspc_2W_smoothed_detrend']
tplot,['thd_fgs_btotal_smoothed','tha_fgs_btotal_smoothed','fspc_2W_smoothed','g13_dtc_cor_eflux_0_detrend']
;C4?
;RBSPb
;RBSPa





  stop

end

