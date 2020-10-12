;Analysis of coherence event on Feb 1, 2013 during BARREL campaign 1. 
;Observed on balloons AHIQTUV


;Narrative: 


;also see Feb01_2013_event.ppt

  rbsp_efw_init
  timespan,'2013-02-05'
  tplot_options,'title','event_analysis_feb5_2013.pro'
  pre = '1'


	tplot_options,'xmargin',[20.,16.]
	tplot_options,'ymargin',[3,9]
	tplot_options,'xticklen',0.08
	tplot_options,'yticklen',0.02
	tplot_options,'xthick',2
	tplot_options,'ythick',2
	tplot_options,'labflag',-1



;Produce some useful tplot variables
;Set up this routine with the correct variables.
args_manual = {combo:'AT',$
               pre:pre,$
               fspc:1,$
               datapath:'/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/',$
               folder_plots:'barrel_missionwide_plots',$
               folder_coh:'coh_vars_barrelmission1',$
               folder_singlepayload:'folder_singlepayload',$
               pmin:10*60.,$
               pmax:60*60.}

fntmp = 'all_coherence_plots_combined.tplot'
tplot_restore,filenames='/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/'+'coh_vars_barrelmission'+pre+'/'+fntmp



;Restore individual payload FSPC data
path = args_manual.datapath + args_manual.folder_singlepayload + '/'
fn = 'barrel_'+pre+'A_fspc_fullmission.tplot' & tplot_restore,filenames=path + fn
fn = 'barrel_'+pre+'T_fspc_fullmission.tplot' & tplot_restore,filenames=path + fn
fn = 'barrel_'+pre+'U_fspc_fullmission.tplot' & tplot_restore,filenames=path + fn
fn = 'barrel_'+pre+'H_fspc_fullmission.tplot' & tplot_restore,filenames=path + fn
fn = 'barrel_'+pre+'Q_fspc_fullmission.tplot' & tplot_restore,filenames=path + fn
fn = 'barrel_'+pre+'I_fspc_fullmission.tplot' & tplot_restore,filenames=path + fn
fn = 'barrel_'+pre+'V_fspc_fullmission.tplot' & tplot_restore,filenames=path + fn


;Restore individual coherence spectra
path = args_manual.datapath + args_manual.folder_coh + '/'
fn = 'AT_meanfilter.tplot' & tplot_restore,filenames=path + fn
fn = 'AU_meanfilter.tplot' & tplot_restore,filenames=path + fn

fn = 'HA_meanfilter.tplot' & tplot_restore,filenames=path + fn
fn = 'AQ_meanfilter.tplot' & tplot_restore,filenames=path + fn
fn = 'IA_meanfilter.tplot' & tplot_restore,filenames=path + fn
fn = 'TU_meanfilter.tplot' & tplot_restore,filenames=path + fn
fn = 'HT_meanfilter.tplot' & tplot_restore,filenames=path + fn
fn = 'QT_meanfilter.tplot' & tplot_restore,filenames=path + fn
fn = 'IT_meanfilter.tplot' & tplot_restore,filenames=path + fn

fn = 'HU_meanfilter.tplot' & tplot_restore,filenames=path + fn
fn = 'QU_meanfilter.tplot' & tplot_restore,filenames=path + fn
fn = 'IU_meanfilter.tplot' & tplot_restore,filenames=path + fn

fn = 'HQ_meanfilter.tplot' & tplot_restore,filenames=path + fn
fn = 'IH_meanfilter.tplot' & tplot_restore,filenames=path + fn

fn = 'AV_meanfilter.tplot' & tplot_restore,filenames=path + fn
fn = 'UV_meanfilter.tplot' & tplot_restore,filenames=path + fn
fn = 'IV_meanfilter.tplot' & tplot_restore,filenames=path + fn
fn = 'HV_meanfilter.tplot' & tplot_restore,filenames=path + fn
fn = 'QV_meanfilter.tplot' & tplot_restore,filenames=path + fn
fn = 'TV_meanfilter.tplot' & tplot_restore,filenames=path + fn


tnt = tnames('coh_??_meanfilter')
for i=0,n_elements(tnt)-1 do options,tnt[i],'ytitle', strmid(tnt[i],4,2)

tplot,['coh_allcombos_meanfilter_normalized2','coh_??_meanfilter']



rbsp_detrend,'fspc_'+pre+'?',5.*60.
rbsp_detrend,'fspc_'+pre+'?_smoothed',80.*60.


tplot,'fspc_'+pre+'?'+'_smoothed_detrend'
stop
;-----------------------------------------------------------------
;Load THEMIS data 
;-----------------------------------------------------------------

path = '~/Desktop/Research/RBSP_hiss_precip/themis/'
fn = 'tha_l2_fgm_20140103_v01.cdf' & cdf2tplot,files=path + fn
fn = 'thd_l2_fgm_20140103_v01.cdf' & cdf2tplot,files=path + fn
fn = 'the_l2_fgm_20140103_v01.cdf' & cdf2tplot,files=path + fn

;NO DATA
;fn = 'thb_l2_fgm_20140103_v01.cdf' & cdf2tplot,files=path + fn  
;fn = 'thc_l2_fgm_20140103_v01.cdf' & cdf2tplot,files=path + fn

rbsp_detrend,'th?_fgl_btotal',60.*2.
rbsp_detrend,'th?_fgl_btotal_smoothed',20.*60.
tplot,['fspc_'+pre+'I_smoothed_detrend','th?_fgl_btotal_smoothed_detrend'];,'tha_fgl_gse','tha_fgs_btotal','tha_fgs_gse']




;tplot,['thd_fgl_btotal','thd_fgl_gse','thd_fgs_btotal','thd_fgs_gse']
;rbsp_detrend,['the_fgl_btotal','the_fgl_gse','the_fgs_btotal','the_fgs_gse'],60.*10.
;tplot,['the_fgl_btotal','the_fgl_gse','the_fgs_btotal','the_fgs_gse']+'_detrend'


fn = 'tha_l2_efi_20140103_v01.cdf'
cdf2tplot,files=path + fn
fn = 'thd_l2_efi_20140103_v01.cdf'
cdf2tplot,files=path + fn

tplot,['tha_efs_dot0_gse','tha_eff_dot0_gse','tha_eff_e12_efs','tha_eff_q_mag']
tplot,['thd_efs_dot0_gse','thd_eff_dot0_gse','thd_eff_e12_efs','thd_eff_q_mag']

fn = 'tha_l2_mom_20140103_v01.cdf'
cdf2tplot,files=path + fn
tplot,['tha_peim_density','tha_peem_density']
fn = 'thd_l2_mom_20140103_v01.cdf'
cdf2tplot,files=path + fn
tplot,['thd_peim_density','thd_peem_density']
fn = 'the_l2_mom_20140103_v01.cdf'
cdf2tplot,files=path + fn


;tplot_save,'th?_p??m_'+['density*','velocity*'],filename='th_mom'
;tplot_save,'thd_p??m_'+['density*','velocity*'],filename='thd_mom'
;tplot_save,'the_p??m_'+['density*','velocity*'],filename='the_mom'

rbsp_detrend,['th?_peim_density','th?_peem_density'],2.*60.
rbsp_detrend,['th?_peim_density_smoothed','th?_peem_density_smoothed'],20.*60.

ylim,'tha_peim_density_smoothed_detrend',-1,1
ylim,'thd_peim_density_smoothed_detrend',-3,2
ylim,'the_peim_density_smoothed_detrend',-2,2
tplot,['fspc_'+pre+'I_smoothed_detrend','th?_peim_density_smoothed_detrend']
ylim,'tha_peem_density_smoothed_detrend',-0.5,0.5
ylim,'thd_peem_density_smoothed_detrend',-2,2
ylim,'the_peem_density_smoothed_detrend',-0.2,0.2
tplot,['fspc_'+pre+'I_smoothed_detrend','th?_peem_density_smoothed_detrend']






;***************************************
;EXTRA STUFF I HAVEN'T LOOKED INTO YET
;***************************************

path = '~/Desktop/Research/RBSP_hiss_precip/themis/'
fn = 'tha_l2_fbk_20140103_v01.cdf'
cdf2tplot,files=path + fn
zlim,['tha_fb_edc12','tha_fb_scm1'],1d-5,100,1
tplot,['tha_fb_edc12','tha_fb_scm1']
get_data,'tha_fb_edc12',data=fbk
store_data,'fbk_tha_36_144Hz',data={x:fbk.x,y:fbk.y[*,3]}


fn = 'tha_l2_fft_20140103_v01.cdf'
cdf2tplot,files=path + fn

zlim,['tha_fff_32_edc12','tha_fff_32_edc34'],1d-10,1d-7,1
zlim,['tha_fff_32_scm2','tha_fff_32_scm3'],1d-9,1d-5,1
ylim,['tha_fff_32_edc12','tha_fff_32_edc34','tha_fff_32_scm2','tha_fff_32_scm3'],1,1000.,1
tplot,['tha_fff_32_edc12','tha_fff_32_edc34','tha_fff_32_scm2','tha_fff_32_scm3']




ylim,['tha_peim_density','thd_peim_density','the_peim_density'] + '_detrend',-20,20
tplot,['tha_peim_density_detrend','thd_peim_density_detrend','the_peim_density_detrend']

;***************************************
;***************************************
;***************************************


;---------------------------------------------------
;Plot LANL sat observations
;---------------------------------------------------


pp = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/Analysis_major_events/Jan3/'

tplot_restore,filenames=pp+'lanl_sat_1991-080_20140103.tplot'
tplot_restore,filenames=pp+'lanl_sat_1994-084_20140103.tplot'
tplot_restore,filenames=pp+'lanl_sat_LANL-01A_20140103.tplot'
tplot_restore,filenames=pp+'lanl_sat_LANL-02A_20140103.tplot'
tplot_restore,filenames=pp+'lanl_sat_LANL-04A_20140103.tplot'
tplot_restore,filenames=pp+'lanl_sat_LANL-97A_20140103.tplot'


split_vec,'1991-080_avg_flux_sopa_e'
split_vec,'1994-084_avg_flux_sopa_e'
split_vec,'LANL-01A_avg_flux_sopa_e'
split_vec,'LANL-02A_avg_flux_sopa_e'
split_vec,'LANL-04A_avg_flux_sopa_e'
split_vec,'LANL-97A_avg_flux_sopa_e'


rbsp_detrend,'*avg_flux_sopa_e_0',60.*5.
rbsp_detrend,'*avg_flux_sopa_e_0_smoothed',60.*80.

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



;---------------------------------------------------
;Load Cluster data 
;All Cluster sc are close together in the magnetosheath (I think) 
;---------------------------------------------------

ptmp = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/Analysis_major_events/Jan3/'

fn = 'c4_pps_pea_20140103000003_20140103235829.cdf' & cdf2tplot,ptmp+fn
fn = 'c3_pps_pea_20140103000002_20140103235317.cdf' & cdf2tplot,ptmp+fn
fn = 'c2_pps_pea_20140103000004_20140103235858.cdf' & cdf2tplot,ptmp+fn
fn = 'c1_pps_pea_20140103000009_20140103235652.cdf' & cdf2tplot,ptmp+fn
fn = 'c4_cps_fgm_spin_20140103000003_20140103235858.cdf' & cdf2tplot,ptmp+fn
fn = 'c3_cps_fgm_spin_20140103000002_20140103235857.cdf' & cdf2tplot,ptmp+fn
fn = 'c2_cps_fgm_spin_20140103000000_20140103235858.cdf' & cdf2tplot,ptmp+fn
fn = 'c1_cps_fgm_spin_20140103000003_20140103235859.cdf' & cdf2tplot,ptmp+fn
fn = 'c4_pps_cis_20140103000003_20140103235858.cdf' & cdf2tplot,ptmp+fn



;Test Cluster density
rbsp_detrend,'N_p__C?_PP_CIS',60.*2.
rbsp_detrend,'N_e_den__C?_PP_PEA',60.*2.
tplot,['N_e_den__C?_PP_PEA_smoothed','N_p__C4_PP_CIS_smoothed']

;Cluster Bmag
;rbsp_detrend,'B_mag__C?_CP_FGM_SPIN',60.*2.
rbsp_detrend,'B_mag__C?_CP_FGM_SPIN',60.*60.
tplot,'B_mag__C?_CP_FGM_SPIN_detrend'

;Cluster velocity - identify boundary crossings
rbsp_detrend,'V_e_xyz_gse__C?_PP_PEA',60.*2.
rbsp_detrend,'V_e_xyz_gse__C?_PP_PEA_smoothed',60.*20.
tplot,['T_e_perp__C?_PP_PEA','V_e_xyz_gse__C?_PP_PEA_smoothed']

;Cluster - look for signatures of dipolarizations
rbsp_cotrans,'B_vec_xyz_gse__C1_CP_FGM_SPIN','C1_Bgsm',/gse2gsm
rbsp_cotrans,'B_vec_xyz_gse__C2_CP_FGM_SPIN','C2_Bgsm',/gse2gsm
rbsp_cotrans,'B_vec_xyz_gse__C3_CP_FGM_SPIN','C3_Bgsm',/gse2gsm
rbsp_cotrans,'B_vec_xyz_gse__C4_CP_FGM_SPIN','C4_Bgsm',/gse2gsm
rbsp_detrend,'C?_Bgsm',60.*60.
tplot,'C?_Bgsm_detrend'

get_data,'B_mag__C2_CP_FGM_SPIN_detrend',ttmp,dtmp 
store_data,'C2_Bmag',ttmp,abs(dtmp)
tplot,['C2_Bgsm_detrend','C2_Bmag']



;--------------------------------------------------------------
;Load OMNI SW data
;--------------------------------------------------------------

t0tmp = time_double('2013-02-01/00:00')
t1tmp = time_double('2013-02-02/00:00')
;plot_omni_quantities,/noplot,t0avg=t0tmp,t1avg=t1tmp
plot_omni_quantities,t0avg=t0tmp,t1avg=t1tmp

tplot,['kyoto_ae','coh_allcombos_meanfilter_normalized2','fspc_'+pre+'A'+'_smoothed_detrend','fspc_'+pre+'U'+'_smoothed_detrend','coh_AU_meanfilter'],/add


;tplot,['kyoto_ae','coh_allcombos_meanfilter_normalized2']



;tplot,['omni_Np','omni_elect_density']+'_smoothed_detrend'
tplot,['omni_press_dyn_smoothed','omni_press_dyn_smoothed_detrend']
tplot,['fspc_'+pre+'?_smoothed'],/add


;^^Test IMF Bz
tplot,['OMNI_HRO_1min_B?_GSM']
tplot,['fspc_'+pre+'?_smoothed'],/add

;^^Check Vsw flow speed
tplot,'OMNI_HRO_1min_flow_speed'
tplot,['fspc_'+pre+'?_smoothed'],/add

;^^Check solar wind density
tplot,'OMNI_HRO_1min_proton_density'

tplot,['IMF_orientation_comb','Bz_rat_comb','clockangle_comb','coneangle_comb']
tplot,'coh_AT_meanfilter',/add


;tplot,['clockangle_comb','coneangle_comb','kyoto_ae','kyoto_dst','OMNI_HRO_1min_flow_speed']

stop
;---------------------------------------
;Plot location of balloon payloads
;---------------------------------------

plot_dial_payload_location_specific_time,'2013-02-01/15:00'
plot_dial_payload_location_specific_time,'2013-02-01/20:00'



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

;Wind is about ~196 RE upstream. Vsw is a steady 500 km/s throughout day. Thus SW will take ~42 minutes to propagte to Earth.
tplot,['wi_SC_pos_gse','wi_swe_V_GSE']
ttst = time_double('2013-01-28/16:00')
coord = tsample('wi_SC_pos_gse',ttst,times=t)
;gseX = [1.252e+06]/6370.




split_vec,'wi_swe_V_GSE'
store_data,['P_DENS','V_GSE','Np','elect_density','SC_pos_gse'],/delete


;Apply the rough timeshift
get_data,'wi_dens_hires',data=d & store_data,'wi_dens_hires',data={x:d.x+(42.*60.),y:d.y}
get_data,'wi_swe_V_GSE',data=d & store_data,'wi_swe_V_GSE',data={x:d.x+(42.*60.),y:d.y}
get_data,'wi_Np',data=d & store_data,'wi_Np',data={x:d.x+(42.*60.),y:d.y}
get_data,'wi_elect_density',data=d & store_data,'wi_elect_density',data={x:d.x+(42.*60.),y:d.y}
get_data,'wi_h0_mfi_bmag',data=d & store_data,'wi_h0_mfi_bmag',data={x:d.x+(42.*60.),y:d.y}
get_data,'wi_h0_mfi_B3GSE',data=d & store_data,'wi_h0_mfi_B3GSE',data={x:d.x+(42.*60.),y:d.y}



;^^Check the SW clock angle (GSE coord)
;Clockangle: zero deg is along zGSE, 90 deg is along yGSE 
;Coneangle: zero deg is along xGSE, 90 along r=sqrt(yGSE^2+zGSE^2)
split_vec,'wi_h0_mfi_B3GSE'
get_data,'wi_h0_mfi_B3GSE_x',ttmp,bx
get_data,'wi_h0_mfi_B3GSE_y',ttmp,by
get_data,'wi_h0_mfi_B3GSE_z',ttmp,bz
bmag = sqrt(bx^2 + by^2 + bz^2)

store_data,'wi_clockangle',ttmp,atan(by,bz)/!dtor
store_data,'wi_coneangle',ttmp,acos(bx/bmag)/!dtor

store_data,'wi_clockangle_comb',data=['wi_clockangle','90line','0line1','m90line','180line']
store_data,'wi_coneangle_comb',data=['wi_coneangle','90line','0line2','m90line','180line','135line']
options,['90line','m90line','180line','0line2'],'color',250
options,['0line1','135line'],'color',50
tplot,['fspc_'+pre+'I_smoothed_detrend','wi_clockangle_comb','clockangle_comb','wi_coneangle_comb','coneangle_comb']
tplot,['fspc_'+pre+'I_smoothed_detrend','wi_clockangle_comb','wi_coneangle_comb']



stop



rbsp_detrend,['wi_dens_hires','wi_swe_V_GSE','wi_Np','wi_elect_density','wi_h0_mfi_bmag','wi_h0_mfi_B3GSE'],2.*60.
rbsp_detrend,['wi_dens_hires','wi_swe_V_GSE','wi_Np','wi_elect_density','wi_h0_mfi_bmag','wi_h0_mfi_B3GSE']+'_smoothed',80.*60.


tplot,['wi_dens_hires','wi_Np','wi_elect_density','wi_h0_mfi_bmag','wi_h0_mfi_B3GSE']+'_smoothed_detrend'
tplot,['fspc_'+pre+'?_smoothed'],/add





;--------------------------------------------------
;Calculate Wind dynamic pressure as n*v^2
;From OMNIWeb:
;Flow pressure = (2*10**-6)*Np*Vp**2 nPa (Np in cm**-3,
;Vp in km/s, subscript "p" for "proton")
;(NOTE THAT THIS CAN DIFFER STRONGLY FROM OMNI DATA, PRESUMABLY DUE TO SW EVOLUTION)
;--------------------------------------------------

split_vec,'wi_swe_V_GSE'



;Use these to find average values for pressure comparison.
t0tmp = time_double('2013-01-28/20:00')
t1tmp = time_double('2013-01-29/00:00')
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


rbsp_detrend,'wi_press_dyn',60.*2.
rbsp_detrend,'wi_press_dyn_smoothed',80.*60.



;tplot,['wi_Np','wi_elect_density']+'_smoothed_detrend'
tplot,['wi_press_dyn_smoothed_detrend','wi_h0_mfi_bmag_smoothed_detrend','wi_h0_mfi_B3GSE_smoothed_detrend']
tplot,['fspc_'+pre+'?_smoothed'],/add



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
split_vec,'g13_dtc_cor_eflux'
split_vec,'g15_dtc_cor_eflux'
tplot,['g13_dtc_cor_eflux_?','fspc_'+pre+'?_smoothed_detrend']
rbsp_detrend,'g1?_dtc_cor_eflux_0',60.*5.
rbsp_detrend,'g1?_dtc_cor_eflux_0_smoothed',80.*60.

ylim,'g1?_dtc_cor_eflux',1d4,1d6,1
tplot,['g1?_dtc_cor_eflux_0_smoothed_detrend','omni_press_dyn','OMNI_HRO_1min_Bmag']
tplot,['fspc_'+pre+'?_smoothed'],/add





;------------------------------------------------------------------------
;LOAD RBSP DATA
;------------------------------------------------------------------------


;Load RBSP hiss data
fcals = rbsp_efw_get_gain_results()
fbinsL = fcals.cal_spec.freq_spec64L
fbinsH = fcals.cal_spec.freq_spec64H
bandw = fbinsH - fbinsL


t0 = time_double('2013-01-28/20:00')
t1 = time_double('2013-01-28/22:00')

rbsp_load_efw_spec,probe='a',type='calibrated',/pt
rbsp_load_efw_spec,probe='b',type='calibrated',/pt
rbsp_efw_position_velocity_crib,/noplot,/notrace
rbsp_efw_vxb_subtract_crib,'a',/no_spice_load;,/hires
rbsp_load_emfisis,probe='a',coord='gse',cadence='1sec',level='l3'  ;load this for the mag model subtract
rbsp_efw_vxb_subtract_crib,'b',/no_spice_load;,/hires
rbsp_load_emfisis,probe='b',coord='gse',cadence='1sec',level='l3'  ;load this for the mag model subtract


;DON'T BOTHER. CAN'T USE E*B=0 DURING THIS TIME. 
rbsp_efw_edotb_to_zero_crib,'2013-01-28','a'


;-----------------------------------------------
rbsp_load_efw_waveform,probe='a',type='calibrated',datatype='vsvy'
split_vec,'rbspa_efw_vsvy', suffix='_V'+['1','2','3','4','5','6']
get_data,'rbspa_efw_vsvy_V1',data=v1
get_data,'rbspa_efw_vsvy_V2',data=v2
sum12 = (v1.y + v2.y)/2.
density = 7354.3897*exp(sum12*2.8454878)+96.123628*exp(sum12*0.43020781)
store_data,'densitya',data={x:v1.x,y:density}
ylim,'density?',1,10000,1
options,'densitya','ytitle','density'+strupcase('a')+'!Ccm^-3'

;-----------------------------------------------
rbsp_load_efw_waveform,probe='b',type='calibrated',datatype='vsvy'
split_vec,'rbspb_efw_vsvy', suffix='_V'+['1','2','3','4','5','6']
get_data,'rbspb_efw_vsvy_V1',data=v1
get_data,'rbspb_efw_vsvy_V2',data=v2
sum12 = (v1.y + v2.y)/2.
density = 7354.3897*exp(sum12*2.8454878)+96.123628*exp(sum12*0.43020781)
store_data,'densityb',data={x:v1.x,y:density}
ylim,'density?',1,10000,1
options,'densityb','ytitle','density'+strupcase('b')+'!Ccm^-3'
;-----------------------------------------------

get_data,'rbspa_efw_64_spec2',data=bu2 & get_data,'rbspa_efw_64_spec3',data=bv2 & get_data,'rbspa_efw_64_spec4',data=bw2
bu2.y[*,0:2] = 0. & bv2.y[*,0:2] = 0. & bw2.y[*,0:2] = 0. & bu2.y[*,45:63] = 0.
bv2.y[*,45:63] = 0. & bw2.y[*,45:63] = 0.
nelem = n_elements(bu2.x)
bt = fltarr(nelem)
;Add up amplitude in all 64 bins and multiply each bin by a bandwidth
ball = bu2.y + bv2.y + bw2.y
for j=0L,nelem-1 do bt[j] = sqrt(total(ball[j,*]*bandw))  ;RMS method (Malaspina's method)
store_data,'Bfield_hissinta',data={x:bu2.x,y:bt}
tplot,'Bfield_hissinta'
;-----------------------------------------------
get_data,'rbspb_efw_64_spec2',data=bu2 & get_data,'rbspb_efw_64_spec3',data=bv2 & get_data,'rbspb_efw_64_spec4',data=bw2
bu2.y[*,0:2] = 0. & bv2.y[*,0:2] = 0. & bw2.y[*,0:2] = 0.
bu2.y[*,45:63] = 0. & bv2.y[*,45:63] = 0. & bw2.y[*,45:63] = 0.
nelem = n_elements(bu2.x)
bt = fltarr(nelem)
;Add up amplitude in all 64 bins and multiply each bin by a bandwidth
ball = bu2.y + bv2.y + bw2.y
for j=0L,nelem-1 do bt[j] = sqrt(total(ball[j,*]*bandw))  ;RMS method (Malaspina's method)
store_data,'Bfield_hissintb',data={x:bu2.x,y:bt}
tplot,'Bfield_hissintb'



timespan,'2013-01-28/19:30',3,/hours
rbsp_detrend,['fspc_'+pre+'?','Bfield_hissint?','g1?_dtc_cor_eflux_0','wi_h0_mfi_bmag'],60.*1.
rbsp_detrend,['fspc_'+pre+'?_smoothed','Bfield_hissint?_smoothed','g1?_dtc_cor_eflux_0_smoothed','wi_h0_mfi_bmag_smoothed'],20.*60.
tplot,['fspc_'+pre+'?_smoothed_detrend','Bfield_hissint?_smoothed_detrend','g1?_dtc_cor_eflux_0_smoothed_detrend','wi_h0_mfi_bmag_smoothed_detrend']


timespan,'2013-01-28/17:00',7,/hours
;additional smoothing for rougher SW comparison
rbsp_detrend,['fspc_'+pre+'I_smoothed_detrend','wi_h0_mfi_bmag_smoothed_detrend'],60.*5.
tplot,['fspc_'+pre+'I_smoothed_detrend','wi_h0_mfi_bmag_smoothed_detrend']+'_smoothed'



split_vec,'g13_dtc_cor_eflux'
split_vec,'g15_dtc_cor_eflux'
rbsp_detrend,'g1?_dtc_cor_eflux_?',60.*20.

tplot,'g13_dtc_cor_eflux_?_detrend'
tplot,'g15_dtc_cor_eflux_?_detrend'
tplot,'g1?_dtc_cor_eflux_8_detrend'


;Background subtract the magnetic field 
rbsp_detrend,'rbsp?_emfisis_l3_1sec_gse_Magnitude',60.*20.
copy_data,'rbspa_emfisis_l3_1sec_gse_Magnitude_smoothed','rbspa_emfisis_l3_1sec_gse_Magnitude_bkg'
rbsp_detrend,'rbsp?_emfisis_l3_1sec_gse_Magnitude',60.*1.
rbsp_detrend,'rbsp?_emfisis_l3_1sec_gse_Magnitude_smoothed',60.*20.
dif_data,'rbspa_emfisis_l3_1sec_gse_Magnitude_bkg','rbspa_emfisis_l3_1sec_gse_Magnitude_smoothed',newname='difftst'
ylim,'rbsp?_emfisis_l3_1sec_gse_Mag_smoothed_detrend',-2,2
ylim,'rbsp?_emfisis_l3_1sec_gse_Magnitude_smoothed_detrend',-2,2
tplot,['rbspa_emfisis_l3_1sec_gse_Magnitude_bkg','rbspa_emfisis_l3_1sec_gse_Magnitude_smoothed','difftst']


rbsp_detrend,'rbsp?_efw_esvy_mgse_vxb_removed_?',60.*1.
rbsp_detrend,'rbsp?_efw_esvy_mgse_vxb_removed_?_smoothed',60.*20.
rbsp_detrend,'rbsp?_emfisis_l3_1sec_gse_Mag',60.*1.
rbsp_detrend,'rbsp?_emfisis_l3_1sec_gse_Mag_smoothed',60.*20.
rbsp_detrend,'difftst',60.*1.
rbsp_detrend,'difftst_smoothed',60.*20.
rbsp_detrend,'density?',60.*1.
rbsp_detrend,'density?_smoothed',60.*20.

ylim,['rbspa_efw_esvy_mgse_vxb_removed_y','rbspa_efw_esvy_mgse_vxb_removed_z'],-2,2
tplot,['fspc_'+pre+'I','rbspa_efw_esvy_mgse_vxb_removed_y','rbspa_efw_esvy_mgse_vxb_removed_z','rbspa_emfisis_l3_1sec_gse_Mag','rbsp?_emfisis_l3_1sec_gse_Magnitude','difftst','densitya']+'_smoothed_detrend





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
split_vec,'FESA'






;----------------------------------------------------------------------------
;VARIOUS INTERESTING PLOTS
;----------------------------------------------------------------------------

;^^overview of solar wind conditions
timespan,'2013-01-28'
tplot,['wi_press_dyn_smoothed','wi_h0_mfi_bmag_smoothed','wi_h0_mfi_B3GSE_smoothed','fspc_'+pre+'?_smoothed']

;^^Looks like the VARIATION of the dynamic pressure occurs mostly because of the density fluctuations
tplot,['omni_pressure_dyn_compare','wi_press_dyn_smoothed']




;^^OMNI DATA GAP
tplot,['omni_press_dyn','OMNI_HRO_1min_Bmag']
tplot,['coh_'+p1+p2+'_meanfilter','fspc_'+pre+'?_smoothed'],/add
;^^OMNI DATA GAP
tplot,'OMNI_HRO_1min_'+['B?_GSE','B?_GSM']
tplot,['coh_'+p1+p2+'_meanfilter','fspc_'+pre+'?_smoothed'],/add
;^^OMNI DATA GAP
tplot,'OMNI_HRO_1min_'+['V?','flow_speed']
tplot,['coh_'+p1+p2+'_meanfilter','fspc_'+pre+'?_smoothed'],/add
;^^OMNI DATA GAP
tplot,'OMNI_HRO_1min_'+['proton_density','T','Pressure','E','Beta']
tplot,['coh_'+p1+p2+'_meanfilter','fspc_'+pre+'?_smoothed'],/add


;^^Moderate substorm activity few hrs before ~22UT coherence
tplot,'OMNI_HRO_1min_'+['AE_INDEX']
tplot,['coh_'+p1+p2+'_meanfilter','fspc_'+pre+'?_smoothed'],/add


;^^No storm correlation
tplot,'OMNI_HRO_1min_'+['SYM_D','SYM_H','ASY_D','ASY_H','PC_N_INDEX']
tplot,['coh_'+p1+p2+'_meanfilter','fspc_'+pre+'?_smoothed'],/add



;^^GOES flux comparison
tplot,['OMNI_HRO_1min_AE_INDEX','g1?_dtc_cor_eflux','wi_press_dyn_smoothed','wi_h0_mfi_bmag_smoothed','wi_h0_mfi_B3GSE_smoothed','fspc_'+pre+'?_smoothed']


tplot,['g1?_dtc_cor_eflux_0_smoothed_detrend','fspc_'+pre+'?_smoothed_detrend']
tplot,['g1?_dtc_cor_eflux_0_smoothed','fspc_'+pre+'?_smoothed']



;^^DENSITY COMPARISON
tplot,['fspc_'+pre+'I_smoothed_detrend','thd_peem_density_smoothed_detrend','density?_smoothed_detrend','N_e_den__C1_PP_PEA_smoothed','N_e_den__C2_PP_PEA_smoothed','N_p__C4_PP_CIS_smoothed']
tplot,['C2_Bgsm_detrend','C2_Bmag'],/add


;^^WIND DENSITY COMPARISON 
rbsp_detrend,'wi_dens_hires',2.*60.
rbsp_detrend,'wi_dens_hires_smoothed',30.*60.

tplot,['wi_dens_hires']+'_smoothed_detrend'
tplot,['fspc_'+pre+'?_smoothed'],/add






  stop

end
