;WK at end of day on Jan 4, 2014

;Narrative: Good correlation b/t W and K at ~22 UT. Comparisons with GOES data 
;strongly suggests that the 60 min periodicity in precipitation is mirroring 
;structure seen in drift echoes. 
;Some probable assoc. b/t SW fluctuations and e- loss, but not direct. This may be b/c 
;W and K are inside of the plasmasphere. 


;also see Jan4_event.ppt


;pro event_analysis_jan4
 
  timespan,'2014-01-04'
  pre = '2'
  rbsp_efw_init
  tplot_options,'title','event_analysis_jan4.pro'

	tplot_options,'xmargin',[20.,16.]
	tplot_options,'ymargin',[3,9]
	tplot_options,'xticklen',0.08
	tplot_options,'yticklen',0.02
	tplot_options,'xthick',2
	tplot_options,'ythick',2
	tplot_options,'labflag',-1	
	

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
fn = 'barrel_2K_fspc_fullmission.tplot' & tplot_restore,filenames=path + fn
fn = 'barrel_2W_fspc_fullmission.tplot' & tplot_restore,filenames=path + fn
fn = 'barrel_2X_fspc_fullmission.tplot' & tplot_restore,filenames=path + fn
fn = 'barrel_2I_fspc_fullmission.tplot' & tplot_restore,filenames=path + fn


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



rbsp_detrend,'fspc_2?',2.*60.
rbsp_detrend,'fspc_2?_smoothed',80.*60.
tplot,'fspc_2?_smoothed_detrend'


stop
;--------------------------------------------------------------
;Load RBSP FFT data
;--------------------------------------------------------------
;path = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/'+'coh_vars_barrelmission'+pre+'/' + 'Jan4/'
path = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/Analysis_major_events_campaign2/Jan4/'

;Load density 
fn = 'rbspa_efw-l3_20140104_v01.cdf'
cdf2tplot,path+fn
copy_data,'density','rbspa_density'
fn = 'rbspb_efw-l3_20140104_v01.cdf'
cdf2tplot,path+fn
copy_data,'density','rbspb_density'

;Load EMFISIS 
rbsp_load_emfisis,probe='a',level='l3',coord='gsm'
rbsp_load_emfisis,probe='b',level='l3',coord='gsm'

;Remove data spikes 
get_data,'rbspa_emfisis_l3_4sec_gsm_Magnitude',data=tt 
goo = where(tt.y lt 0.) 
tt.y[goo] = !values.f_nan
store_data,'rbspa_emfisis_l3_4sec_gsm_Magnitude',data=tt 

get_data,'rbspb_emfisis_l3_4sec_gsm_Magnitude',data=tt 
goo = where(tt.y lt 0.) 
tt.y[goo] = !values.f_nan
store_data,'rbspb_emfisis_l3_4sec_gsm_Magnitude',data=tt 



fn = 'rbspa_efw-l2_spec_20140104_v01.cdf'
cdf2tplot,path+fn

copy_data,'spec64_scmw','rbspa_spec64_scmw'
trange = timerange()
fcals = rbsp_efw_get_gain_results()
fbinsL = fcals.cal_spec.freq_spec64L
fbinsH = fcals.cal_spec.freq_spec64H
bandw = fbinsH - fbinsL


get_data,'spec64_scmu',data=bu2
get_data,'spec64_scmv',data=bv2
get_data,'spec64_scmw',data=bw2
bu2.y[*,0:2] = 0.
bv2.y[*,0:2] = 0.
bw2.y[*,0:2] = 0.
bu2.y[*,37:63] = 0.
bv2.y[*,37:63] = 0.
bw2.y[*,37:63] = 0.
nelem = n_elements(bu2.x)
bt = fltarr(nelem)
;Add up amplitude in all 64 bins and multiply each bin by a bandwidth
ball = bu2.y + bv2.y + bw2.y
for j=0L,nelem-1 do bt[j] = sqrt(total(ball[j,*]*bandw))  ;RMS method (Malaspina's method)
store_data,'Bfield_hissinta',data={x:bu2.x,y:bt}
tplot,'Bfield_hissinta'



fn = 'rbspb_efw-l2_spec_20140104_v01.cdf'
cdf2tplot,path+fn
copy_data,'spec64_scmw','rbspb_spec64_scmw'

get_data,'spec64_scmu',data=bu2
get_data,'spec64_scmv',data=bv2
get_data,'spec64_scmw',data=bw2
bu2.y[*,0:2] = 0.
bv2.y[*,0:2] = 0.
bw2.y[*,0:2] = 0.
bu2.y[*,37:63] = 0.
bv2.y[*,37:63] = 0.
bw2.y[*,37:63] = 0.
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
zlim,'rbsp?_spec64_scm?',1d-6,1d-3,1
ylim,'rbsp?_spec64_scm?',30,800,1
ylim,'fspc_2W_smoothed',35,55
ylim,'fspc_2K_smoothed',30,80
ylim,'fspc_2X_smoothed',30,60
tplot,['coh_allcombos_meanfilter_normalized2','rbsp?_spec64_scmw','Bfield_hissint?_smoothed_detrend','fspc_2?_smoothed_detrend']
tplot,['coh_allcombos_meanfilter_normalized2','rbsp?_spec64_scmw','Bfield_hissint?_smoothed','fspc_2?_smoothed']




;*****************************
;Try to detrend the magnetic field data by subtracting off background field
;...Normal smoothing and detrending doesn't work very well. Impossible to get rid of all background. 
;...IDL's gaussfit doesn't work. The Bo variation is not a gaussian 
;...IDL's polyfit doesn't even come close. 



rbsp_efw_dcfield_removal_crib,'a'

get_data,'rbspa_mag_gsm_t96_omni_dif',data=dd
bmag = sqrt(dd.y[*,0]^2+dd.y[*,1]^2+dd.y[*,2]^2)
goo = where(bmag le 1d2)
timesnew = dd.x[goo] 
bmagnew = bmag[goo]
store_data,'bmag',data={x:timesnew,y:bmagnew}
rbsp_detrend,'bmag',60.*2.
rbsp_detrend,'bmag_smoothed',60.*80.


ylim,['bmag'],0,100
ylim,'bmag_smoothed_detrend',-4,4
tplot,['bmag','bmag_smoothed_detrend']








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
ylim,'rbspa_density_smoothed_detrend',-50,30
ylim,'rbspb_density_smoothed_detrend',-50,50
ylim,'rbsp?_emfisis_l3_4sec_gsm_Magnitude_smoothed_detrend',-20,20
ylim,'rbsp?_emfisis_l3_4sec_gsm_Magnitude_smoothed',50,250
ylim,'rbsp?_emfisis_l3_4sec_gsm_Magnitude',150,200
ylim,'rbsp?_mag_diff_smoothed',-2,10
tplot,['Bfield_hissint?_smoothed_detrend','fspc_2?_smoothed','rbsp?_density_smoothed_detrend','rbsp?_mag_diff_smoothed']












;--------------------------------------------------------------
;Load RBSP MagEIS and HOPE data 
;--------------------------------------------------------------
path = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/Analysis_major_events_campaign2/Jan4/'
fn = 'rbspa_rel04_ect-mageis-L2_20140104_v8.1.0.cdf'
cdf2tplot,file=path+fn
get_data,'FESA',data=dd
store_data,'mFESA_0',data={x:dd.x,y:dd.y[*,3]}   ;50 keV

rbsp_detrend,'mFESA_0',60.*5.
rbsp_detrend,'mFESA_0_smoothed',60.*80.


path = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/Analysis_major_events_campaign2/Jan4/'
fn = 'rbspa_rel04_ect-hope-sci-L2SA_20140104_v6.2.0.cdf'
cdf2tplot,file=path+fn
get_data,'FESA',data=dd
;store_data,'hFESA_0',data={x:dd.x,y:dd.y[*,71]}   ;50 keV
store_data,'hFESA_0',data={x:dd.x,y:dd.y[*,57]}   ;10 keV

rbsp_detrend,'hFESA_0',60.*5.
rbsp_detrend,'hFESA_0_smoothed',60.*80.


;Compare RBSPa MagEIS and waves 
tplot,['hFESA_0_smoothed','mFESA_0_smoothed','FESA_0_smoothed_detrend','Bfield_hissinta_smoothed_detrend','fspc_2W_smoothed','rbspa_density_smoothed_detrend','rbspa_mag_diff_smoothed_detrend']




;--------------------------------------------------------------
;Load OMNI SW data
;--------------------------------------------------------------
kyoto_load_ae

t0tmp = time_double('2014-01-04/00:00')
t1tmp = time_double('2014-01-05/00:00')
plot_omni_quantities,t0avg=t0tmp,t1avg=t1tmp

tplot,['kyoto_ae','coh_allcombos_meanfilter_normalized2','coh_allcombos_meanfilter_normalized2_OMNI_press_dyn','fspc_2W_smoothed','fspc_2I_smoothed','coh_IW_meanfilter'],/add

;tplot,['omni_Np','omni_elect_density']+'_smoothed_detrend'
tplot,['coh_allcombos_meanfilter_normalized2','coh_allcombos_meanfilter_normalized2_OMNI_press_dyn','omni_press_dyn_smoothed','fspc_2?_smoothed']
tplot,['coh_allcombos_meanfilter_normalized2','coh_allcombos_meanfilter_normalized2_OMNI_press_dyn','omni_press_dyn_smoothed_detrend','fspc_2?_smoothed_detrend']


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



stop

;---------------------------------------
;Plot location of balloon payloads
;---------------------------------------

;t1 = time_double('2014-01-04/23:00')
;t2 = time_double('2014-01-04/23:20')

;dial_plot_balloon_location,'L_Kp2_2K','L_Kp2_2W','MLT_Kp2_2K','MLT_Kp2_2W',t1,t2,'coh_KW_meanfilter',payload1='K',payload2='W',color=0;,/oplot
;dial_plot_balloon_location,'L_Kp2_2K','L_Kp2_2X','MLT_Kp2_2K','MLT_Kp2_2X',t1,t2,'coh_KX_meanfilter',payload1='K',payload2='X',color=50,/oplot

plot_dial_payload_location_specific_time,'2014-01-04/20:00'
plot_dial_payload_location_specific_time,'2014-01-04/22:30'




;---------------------------------------------------
;Plot LANL sat observations
;---------------------------------------------------


pp = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/Analysis_major_events_campaign2/Jan4/'

tplot_restore,filenames=pp+'lanl_sat_1991-080_20140104.tplot'
tplot_restore,filenames=pp+'lanl_sat_1994-084_20140104.tplot'
tplot_restore,filenames=pp+'lanl_sat_LANL-01A_20140104.tplot'
tplot_restore,filenames=pp+'lanl_sat_LANL-02A_20140104.tplot'
tplot_restore,filenames=pp+'lanl_sat_LANL-04A_20140104.tplot'
tplot_restore,filenames=pp+'lanl_sat_LANL-97A_20140104.tplot'


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

;Wind is about ~195 RE upstream. Vsw is 500 km/s (pretty consistent throughout day). Thus SW will take ~42 minutes to propagte to Earth.
tplot,['wi_SC_pos_gse','wi_swe_V_GSE']
ttst = time_double('2014-01-10/22:00')
coord = tsample('wi_SC_pos_gse',ttst,times=t)
;gse = [1.23995e+06,-99419.8,-96729.1]/6370.



split_vec,'wi_swe_V_GSE'
store_data,['P_DENS','V_GSE','Np','elect_density','SC_pos_gse'],/delete


;Apply the rough timeshift 
get_data,'wi_dens_hires',data=d & store_data,'wi_dens_hires',data={x:d.x+(42.*60.),y:d.y}
get_data,'wi_swe_V_GSE',data=d & store_data,'wi_swe_V_GSE',data={x:d.x+(42.*60.),y:d.y}
get_data,'wi_Np',data=d & store_data,'wi_Np',data={x:d.x+(42.*60.),y:d.y}
get_data,'wi_elect_density',data=d & store_data,'wi_elect_density',data={x:d.x+(42.*60.),y:d.y}
get_data,'wi_h0_mfi_bmag',data=d & store_data,'wi_h0_mfi_bmag',data={x:d.x+(42.*60.),y:d.y}
get_data,'wi_h0_mfi_B3GSE',data=d & store_data,'wi_h0_mfi_B3GSE',data={x:d.x+(42.*60.),y:d.y}


rbsp_detrend,['wi_dens_hires','wi_swe_V_GSE','wi_Np','wi_elect_density','wi_h0_mfi_bmag','wi_h0_mfi_B3GSE'],5.*60.
rbsp_detrend,['wi_dens_hires','wi_swe_V_GSE','wi_Np','wi_elect_density','wi_h0_mfi_bmag','wi_h0_mfi_B3GSE']+'_smoothed',80.*60.





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



;tplot,['wi_Np','wi_elect_density']+'_smoothed_detrend'
tplot,['wi_press_dyn_smoothed_detrend','wi_h0_mfi_bmag_smoothed_detrend','wi_h0_mfi_B3GSE_smoothed_detrend']
tplot,['fspc_comb_LX'],/add



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
tplot,'g15_dtc_cor_eflux_?'
rbsp_detrend,'g1?_dtc_cor_eflux_0',60.*5.
rbsp_detrend,'g1?_dtc_cor_eflux_0_smoothed',80.*60.

ylim,'g1?_dtc_cor_eflux',1d4,1d6,1
tplot,['g1?_dtc_cor_eflux_0_smoothed_detrend','omni_press_dyn','OMNI_HRO_1min_Bmag','kyoto_ae']
tplot,['fspc_2W_smoothed','fspc_2K_smoothed'],/add






;----------------------------------------------------------------------------
;VARIOUS INTERESTING PLOTS
;----------------------------------------------------------------------------

;^^overview of solar wind conditions
timespan,'2014-01-04'
tplot,['omni_press_dyn','OMNI_HRO_1min_Bmag']
tplot,['coh_'+p1+p2+'_meanfilter','fspc_2W_smoothed','fspc_2K_smoothed','fspc_2X_smoothed','fspc_2I_smoothed'],/add


;^^Looks like the VARIATION of the dynamic pressure occurs mostly because of the density fluctuations
tplot,['omni_pressure_dyn_compare','wi_press_dyn_smoothed']


;tplot,['wi_Np','wi_elect_density']+'_smoothed_detrend'
tplot,['wi_press_dyn_smoothed','wi_h0_mfi_bmag_smoothed','wi_h0_mfi_B3GSE_smoothed','fspc_2?_smoothed']


;^^At higher L, but may actually be inside of PS
tplot,['MLT_Kp2_2W','MLT_Kp2_2K','L_Kp2_2W','L_Kp2_2K']

;^^Possible assoc. with BxGSE increases
tplot,'OMNI_HRO_1min_'+['B?_GSE','B?_GSM']
tplot,['coh_'+p1+p2+'_meanfilter','fspc_2W_smoothed','fspc_2K_smoothed','fspc_comb_WK'],/add


;^^No clear relation to SW macroscopic slow speed/direction changes
tplot,'OMNI_HRO_1min_'+['V?','flow_speed']
tplot,['coh_'+p1+p2+'_meanfilter','fspc_2W_smoothed','fspc_2K_smoothed','fspc_comb_WK'],/add


;^^No clear assoc. with pressure changes
tplot,'OMNI_HRO_1min_'+['proton_density','T','Pressure','E','Beta']
tplot,['coh_'+p1+p2+'_meanfilter','fspc_2W_smoothed','fspc_2K_smoothed','fspc_comb_WK'],/add


;^^Moderate substorm activity starting midday and continuing for rest of day
;tplot,'OMNI_HRO_1min_'+['AE_INDEX','AL_INDEX','AU_INDEX']
tplot,'OMNI_HRO_1min_'+['AE_INDEX']
tplot,['coh_'+p1+p2+'_meanfilter','fspc_2W_smoothed','fspc_2K_smoothed','fspc_comb_WK'],/add


;^^Minor storm with some few hr fluctuations
tplot,'OMNI_HRO_1min_'+['SYM_D','SYM_H','ASY_D','ASY_H','PC_N_INDEX']
tplot,['coh_'+p1+p2+'_meanfilter','fspc_2W_smoothed','fspc_2K_smoothed','fspc_comb_WK'],/add


;^^Detailed comparison of SW pressure and magnetic field. Lots of similar features
rbsp_detrend,'OMNI_HRO_1min_'+['proton_density','T','Pressure','E','Beta'],5.*60.
rbsp_detrend,'OMNI_HRO_1min_'+['proton_density','T','Pressure','E','Beta']+'_smoothed',80.*60.
tlimit,'2014-01-04/16:00','2014-01-05/00:00'
tplot,'OMNI_HRO_1min_'+['T','E','Beta']+'_smoothed_detrend'
tplot,'omni_press_dyn_smoothed_detrend',/add
tplot,['coh_'+p1+p2+'_meanfilter','fspc_2W_smoothed','fspc_2K_smoothed','fspc_comb_WK'],/add


tplot,'omni_press_dyn_smoothed_detrend'
tplot,['fspc_comb_WK'],/add



;^^GOES flux comparison
tplot,['OMNI_HRO_1min_AE_INDEX','g1?_dtc_cor_eflux','wi_press_dyn_smoothed','wi_h0_mfi_bmag_smoothed','wi_h0_mfi_B3GSE_smoothed','fspc_2?_smoothed']

split_vec,'g13_dtc_cor_eflux'
split_vec,'g15_dtc_cor_eflux'
rbsp_detrend,'g15_dtc_cor_eflux_?',60.*80.
rbsp_detrend,'rbsp?_mag_diff_smoothed',60.*80.
rbsp_detrend,'rbspa_emfisis_l3_4sec_gsm_Magnitude',60.*80
ylim,'rbspa_mag_diff_smoothed_detrend',-5,3
ylim,'rbspb_mag_diff_smoothed_detrend',-5,3
tplot,['g15_dtc_cor_eflux_0_detrend','fspc_2W_smoothed_detrend','rbspa_mag_diff_smoothed_detrend','rbspa_density_smoothed_detrend']
ylim,'g13_dtc_cor_eflux_0',2d4,7d4,0
ylim,'g15_dtc_cor_eflux_0',4d4,3d5,0
tplot,['g1?_dtc_cor_eflux_0','fspc_2W_smoothed','rbsp?_mag_diff_smoothed','rbspa_density_smoothed']



;tplot,['omni_Np','omni_elect_density']+'_smoothed_detrend'
tplot,['omni_press_dyn_smoothed_detrend','g15_dtc_cor_eflux_0_smoothed_detrend','fspc_2W_smoothed_detrend']
tplot,['omni_press_dyn_smoothed','g15_dtc_cor_eflux_0_smoothed','fspc_2W_smoothed']


;shorter detrend time 
copy_data,'g15_dtc_cor_eflux_0','g15_dtc_cor_eflux_0_v2'
copy_data,'fspc_2W_smoothed','fspc_2W_smoothed_v2'
copy_data,'rbspa_mag_diff_smoothed','rbspa_mag_diff_smoothed_v2'

rbsp_detrend,'g15_dtc_cor_eflux_0_v2',60.*30.
rbsp_detrend,'fspc_2W_smoothed_v2',60.*30.
rbsp_detrend,'rbspa_mag_diff_smoothed_v2',60.*30.
ylim,'rbsp?_mag_diff_smoothed_v2_detrend',-5,5

tplot,['g15_dtc_cor_eflux_0_v2_detrend','fspc_2W_smoothed_v2_detrend','rbsp?_mag_diff_smoothed_v2_detrend']


;^^Plot that hopefully shows that precipitation is not hiss-driven 

rbsp_detrend,'rbspa_density',60.*2.
rbsp_detrend,'rbspa_density_smoothed',60.*40.
ylim,'rbspa_density_smoothed_detrend',-50,50
tplot,['coh_allcombos_meanfilter_normalized2','rbspa_spec64_scmw','Bfield_hissinta_smoothed','fspc_2I_smoothed','fspc_2W_smoothed','bmag_smoothed','rbspa_density_smoothed_detrend']
tplot,['coh_allcombos_meanfilter_normalized2','rbspa_spec64_scmw','Bfield_hissinta_smoothed_detrend','fspc_2I_smoothed_detrend','fspc_2W_smoothed_detrend','bmag_smoothed_detrend','rbspa_density_smoothed_detrend']



;tplot,['hFESA_0_smoothed','mFESA_0_smoothed','FESA_0_smoothed_detrend','Bfield_hissinta_smoothed_detrend','fspc_2W_smoothed']
;tplot,['IMF_orientation_comb','Bz_rat_comb','clockangle_comb','coneangle_comb']
;tplot,['clockangle_comb','coneangle_comb','kyoto_ae','kyoto_dst','OMNI_HRO_1min_flow_speed']

zlim,'rbsp?_spec64_scmw',1d-9,1d-3,1

rbsp_detrend,['Bfield_hissinta','fspc_2?','bmag','rbspa_density','g15_dtc_cor_eflux_0','*avg_flux_sopa_e_0'],60.*10.
rbsp_detrend,['Bfield_hissinta','fspc_2?','bmag','rbspa_density','g15_dtc_cor_eflux_0','*avg_flux_sopa_e_0']+'_smoothed',60.*30.
ylim,'*avg_flux_sopa_e_0_smoothed_detrend',-5000,5000
ylim,'LANL-97A_avg_flux_sopa_e_0_smoothed_detrend',-2000,2000
ylim,'1994-084_avg_flux_sopa_e_0_smoothed_detrend',-2000,2000

tplot,['rbsp?_spec64_scmw','Bfield_hissinta_smoothed_detrend','fspc_2I_smoothed_detrend','fspc_2W_smoothed_detrend','fspc_2K_smoothed_detrend','fspc_2X_smoothed_detrend','bmag_smoothed_detrend','rbspa_density_smoothed_detrend','g15_dtc_cor_eflux_0_smoothed_detrend']
tplot,['*avg_flux_sopa_e_0_smoothed_detrend','mFESA_0_smoothed_detrend'],/add

tplot,['rbsp?_spec64_scmw','Bfield_hissinta_smoothed','fspc_2I_smoothed','fspc_2W_smoothed','fspc_2K_smoothed','fspc_2X_smoothed','bmag_smoothed','rbspa_density_smoothed','g15_dtc_cor_eflux_0_smoothed']


  stop

end

