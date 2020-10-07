;KLX at end of day on Jan 8, 2014


;Narrative: 

;also see Jan8_event.ppt

;pro event_analysis_jan8
  rbsp_efw_init
  tplot_options,'title','event_analysis_jan8.pro'

	tplot_options,'xmargin',[20.,16.]
	tplot_options,'ymargin',[3,9]
	tplot_options,'xticklen',0.08
	tplot_options,'yticklen',0.02
	tplot_options,'xthick',2
	tplot_options,'ythick',2
	tplot_options,'labflag',-1	
	
    pre = '2' 
    timespan,'2014-01-08'

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
fn = 'barrel_2L_fspc_fullmission.tplot' & tplot_restore,filenames=path + fn
fn = 'barrel_2X_fspc_fullmission.tplot' & tplot_restore,filenames=path + fn
fn = 'barrel_2W_fspc_fullmission.tplot' & tplot_restore,filenames=path + fn


;Restore individual coherence spectra
path = args_manual.datapath + args_manual.folder_coh + '/'
fn = 'KX_meanfilter.tplot' & tplot_restore,filenames=path + fn
fn = 'WK_meanfilter.tplot' & tplot_restore,filenames=path + fn
fn = 'WX_meanfilter.tplot' & tplot_restore,filenames=path + fn
fn = 'KL_meanfilter.tplot' & tplot_restore,filenames=path + fn
fn = 'LX_meanfilter.tplot' & tplot_restore,filenames=path + fn
fn = 'WL_meanfilter.tplot' & tplot_restore,filenames=path + fn

tnt = tnames('coh_??_meanfilter')
for i=0,n_elements(tnt)-1 do options,tnt[i],'ytitle', strmid(tnt[i],4,2)


kyoto_load_ae
tplot,['coh_allcombos_meanfilter_normalized2','coh_allcombos_meanfilter_normalized2_OMNI_press_dyn','coh_??_meanfilter']





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

;timespan,'2014-01-08/15:00',9,/hours
;tplot,['coh_KL_meanfilter','coh_LX_meanfilter',$
;    'fspcS_lowpass_comb',$
;    'fspcS_lowpass_detrend_comb',$
;    'dL_KL_both','dMLT_KL_both',$
;    'dist_pp_2K_comb','dist_pp_2L_comb']


rbsp_detrend,'fspc_2?',5.*60.
rbsp_detrend,'fspc_2?_smoothed',80.*60.


stop

;--------------------------------------------------------------
;Load OMNI SW data
;--------------------------------------------------------------

t0tmp = time_double('2014-01-08/00:00')
t1tmp = time_double('2014-01-09/00:00')
;plot_omni_quantities,/noplot,t0avg=t0tmp,t1avg=t1tmp
plot_omni_quantities,t0avg=t0tmp,t1avg=t1tmp

rbsp_detrend,'OMNI_HRO_1min_proton_density',60.*5.
rbsp_detrend,'OMNI_HRO_1min_proton_density_smoothed',60.*80.


;tplot,['kyoto_ae','coh_allcombos_meanfilter_normalized2*','fspc_2K_smoothed_detrend','fspc_2X_smoothed_detrend','coh_KX_meanfilter'],/add
tplot,['kyoto_ae','coh_allcombos_meanfilter_normalized2','coh_allcombos_meanfilter_normalized_OMNI_press_dyn','fspc_2K_smoothed_detrend','fspc_2X_smoothed_detrend','coh_KX_meanfilter'],/add


;tplot,['omni_Np','omni_elect_density']+'_smoothed_detrend'
tplot,['coh_allcombos_meanfilter_normalized2','coh_allcombos_meanfilter_normalized_OMNI_press_dyn','omni_press_dyn_smoothed','fspc_2?_smoothed']
tplot,['coh_allcombos_meanfilter_normalized2','coh_allcombos_meanfilter_normalized_OMNI_press_dyn','omni_press_dyn_smoothed_detrend','OMNI_HRO_1min_proton_density_smoothed_detrend','fspc_2?_smoothed_detrend']
;tplot,['coh_allcombos_meanfilter_normalized_OMNI_press_dyn','omni_press_dyn','fspc_2K_smoothed']


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
tplot,['OMNI_HRO_1min_flow_speed','clockangle_comb','coneangle_comb','fspc_2?_smoothed','kyoto_ae']







;--------------------------------------------------------------
;Load RBSP FFT data
;--------------------------------------------------------------
;path = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/'+'coh_vars_barrelmission'+pre+'/' + 'Jan4/'
path = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/Analysis_major_events_campaign2/Jan8/'

;Load density 
fn = 'rbspa_efw-l3_20140108_v01.cdf'
cdf2tplot,path+fn
copy_data,'density','rbspa_density'
fn = 'rbspb_efw-l3_20140108_v01.cdf'
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



fn = 'rbspa_efw-l2_spec_20140108_v01.cdf'
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
bu2.y[*,0:9] = 0.
bv2.y[*,0:9] = 0.
bw2.y[*,0:9] = 0.
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



fn = 'rbspb_efw-l2_spec_20140108_v01.cdf'
cdf2tplot,path+fn
copy_data,'spec64_scmw','rbspb_spec64_scmw'

get_data,'spec64_scmu',data=bu2
get_data,'spec64_scmv',data=bv2
get_data,'spec64_scmw',data=bw2
bu2.y[*,0:9] = 0.
bv2.y[*,0:9] = 0.
bw2.y[*,0:9] = 0.
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


rbsp_detrend,'Bfield_hissint?',60.*5.
rbsp_detrend,'Bfield_hissint?_smoothed',60.*80.
options,'spec64_scm','spec',1
zlim,'spec64_scm?',1d-6,1d-3,1
ylim,'spec64_scm?',30,800,1
ylim,'fspc_2W_smoothed',35,55
ylim,'fspc_2K_smoothed',30,80
ylim,'fspc_2X_smoothed',30,60
tplot,['coh_allcombos_meanfilter_normalized2','spec64_scmw','Bfield_hissint?_smoothed_detrend','fspc_2?_smoothed_detrend']
tplot,['coh_allcombos_meanfilter_normalized2','rbsp?_spec64_scmw','Bfield_hissint?_smoothed','fspc_2?_smoothed']


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
ylim,'rbspa_density_smoothed_detrend',-50,30
ylim,'rbspb_density_smoothed_detrend',-50,50
ylim,'rbsp?_emfisis_l3_4sec_gsm_Magnitude_smoothed_detrend',-20,20
ylim,'rbsp?_emfisis_l3_4sec_gsm_Magnitude_smoothed',50,250
ylim,'rbsp?_emfisis_l3_4sec_gsm_Magnitude',150,200
ylim,'rbsp?_mag_diff_smoothed',-2,10
tplot,['Bfield_hissint?_smoothed_detrend','fspc_2?_smoothed','rbsp?_density_smoothed_detrend','rbsp?_mag_diff_smoothed']






















;-----------------------------------------------
;LOAD THEMIS DATA 
;-----------------------------------------------

thm_load_fft,probe='e'
ylim,['the_fff_32_edc12','the_fff_32_edc34','the_fff_32_scm2','the_fff_32_scm3'],30,1000,1

tplot,['coh_KL_meanfilter','fspc_2K_smoothed_detrend','fspc_2L_smoothed_detrend','fspc_2X_smoothed_detrend']
tplot,['the_fff_32_edc12','the_fff_32_edc34','the_fff_32_scm2','the_fff_32_scm3'],/add

;Calculate RMS hiss amplitudes for Ew and Bw (single channel)

tplot,'the_fff_32_edc12'
get_data,'the_fff_32_edc12',data=dd

;freqs from 52 - 956 Hz
print,dd.v[10:23]
bandw = dd.v - shift(dd.v,1)
bandw = bandw[1:n_elements(bandw)-1]
bandw = bandw[10:23]

edcv = dd.y[*,10:23]
nelem = n_elements(dd.x)
edcvfin = edcv & edcvfin[*] = 0.

for j=0L,nelem-1 do edcvfin[j] = 1000.*sqrt(total(edcv[j,*]*bandw))

store_data,'edcv_rms',data={x:dd.x,y:edcvfin}
options,'edcv_rms','ytitle','RMS E12DC!CmV/m!C52-1000 Hz'


;RMS for SCM
get_data,'the_fff_32_scm3',data=dd

scm3 = dd.y[*,10:23]
nelem = n_elements(dd.x)
scm3fin = scm3 & scm3fin[*] = 0.

for j=0L,nelem-1 do scm3fin[j] = 1000.*sqrt(total(scm3[j,*]*bandw))

store_data,'scm3_rms',data={x:dd.x,y:scm3fin}
options,'scm3_rms','ytitle','RMS SCM3!CpT!C52-1000 Hz'



ylim,['the_fff_32_scm3','the_fff_32_edc12'],50,1000,0
tplot,['the_fff_32_scm3','scm3_rms','the_fff_32_edc12','edcv_rms']

rbsp_detrend,'scm3_rms',60.*5.
rbsp_detrend,'edcv_rms',60.*5.

ylim,'edcv_rms',0,0.2
ylim,'scm3_rms',0,30
tplot,['the_fff_32_scm3','scm3_rms_smoothed','edcv_rms_smoothed','fspc_2K_smoothed_detrend','fspc_2L_smoothed_detrend','fspc_2X_smoothed_detrend']
tplot,['the_fff_32_scm3','scm3_rms_smoothed','edcv_rms_smoothed','fspc_2K_smoothed','fspc_2L_smoothed','fspc_2X_smoothed']




thm_load_fgm,probe='a'
split_vec,'tha_fgl'
rbsp_detrend,['tha_fgl*'],30.*60.
;rbsp_detrend,['tha_fge','tha_fgl']+'_smoothed',80.*60.
tplot,['tha_fgl_detrend','tha_vaf_0_smoothed']
tplot,['tha_fgl','tha_vaf_0_smoothed']




thm_load_efi,probe='a'




ptmp = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/Analysis_major_events/Jan8/'
cdf2tplot,ptmp+'tha_l2_efi_20140108_v01.cdf'
cdf2tplot,ptmp+'tha_l2_fgm_20140108_v01.cdf'
cdf2tplot,ptmp+'tha_l2_mom_20140108_v01.cdf'
cdf2tplot,ptmp+'thb_l2_efi_20140108_v01.cdf'
cdf2tplot,ptmp+'thb_l2_fgm_20140108_v01.cdf'
cdf2tplot,ptmp+'thb_l2_mom_20140108_v01.cdf'
cdf2tplot,ptmp+'thc_l2_efi_20140108_v01.cdf'
cdf2tplot,ptmp+'thc_l2_fgm_20140108_v01.cdf'
cdf2tplot,ptmp+'thc_l2_mom_20140108_v01.cdf'
cdf2tplot,ptmp+'thd_l2_efi_20140108_v01.cdf'
cdf2tplot,ptmp+'thd_l2_fgm_20140108_v01.cdf'
cdf2tplot,ptmp+'thd_l2_mom_20140108_v01.cdf'
cdf2tplot,ptmp+'the_l2_efi_20140108_v01.cdf'
cdf2tplot,ptmp+'the_l2_fgm_20140108_v01.cdf'
cdf2tplot,ptmp+'the_l2_mom_20140108_v01.cdf'



;---------------------------------------
;Plot location of balloon payloads
;---------------------------------------

plot_dial_payload_location_specific_time,'2014-01-08/17:30'



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

;Wind is about ~195 RE upstream. Vsw is 360 km/s. Thus SW will take ~57 minutes to propagate to Earth.
;This is consistent with OMNI_HR0_1min_Timeshift, which shows value of 52.5 min. 
;tplot,['wi_SC_pos_gse','wi_swe_V_GSE']
;ttst = time_double('2014-01-10/22:00')
;coord = tsample('wi_SC_pos_gse',ttst,times=t)
;;gse = [1.23995e+06,-99419.8,-96729.1]/6370.


;Apply the rough timeshift 
get_data,'wi_dens_hires',data=d & store_data,'wi_dens_hires',data={x:d.x+(52.5*60.),y:d.y}
get_data,'wi_swe_V_GSE',data=d & store_data,'wi_swe_V_GSE',data={x:d.x+(52.5*60.),y:d.y}
get_data,'wi_Np',data=d & store_data,'wi_Np',data={x:d.x+(52.5*60.),y:d.y}
get_data,'wi_elect_density',data=d & store_data,'wi_elect_density',data={x:d.x+(52.5*60.),y:d.y}
get_data,'wi_h0_mfi_bmag',data=d & store_data,'wi_h0_mfi_bmag',data={x:d.x+(52.5*60.),y:d.y}
get_data,'wi_h0_mfi_B3GSE',data=d & store_data,'wi_h0_mfi_B3GSE',data={x:d.x+(52.5*60.),y:d.y}



split_vec,'wi_swe_V_GSE'
store_data,['P_DENS','V_GSE','Np','elect_density','SC_pos_gse'],/delete

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
t0tmp = time_double('2014-01-08/21:00')
t1tmp = time_double('2014-01-08/22:00')
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


;Test Wind timeshift by comparison to OMNI data. 
tplot,['wi_pressure_dyn_compare','omni_press_dyn_smoothed']



;Detrend and apply the timeshift
rbsp_detrend,'wi_press_dyn',60.*5.
rbsp_detrend,'wi_press_dyn_smoothed',60.*80.


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
tplot,'g1?_dtc_cor_eflux_?'
rbsp_detrend,'g1?_dtc_cor_eflux_0',60.*5.
rbsp_detrend,'g1?_dtc_cor_eflux_0_smoothed',80.*60.

ylim,'g1?_dtc_cor_eflux',1d4,1d6,1
tplot,['g1?_dtc_cor_eflux_0_smoothed','omni_press_dyn','OMNI_HRO_1min_Bmag','fspc_2K_smoothed']
;tplot,['fspc_2W_smoothed','fspc_2K_smoothed','fspc_comb_WK'],/add



;----------------------------------------------------------------------------
;CALCULATE COHERENCE B/T THB (UPSTREAM, IN SW) AND PRECIP
;----------------------------------------------------------------------------

;Load 2 days worth of THEMIS data 

ptmp = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/Analysis_major_events/Jan8/'
cdf2tplot,ptmp+'thb_l2_mom_20140108_v01.cdf'
copy_data,'thb_peim_density','thb_peim_density_jan8'
copy_data,'thb_peem_density','thb_peem_density_jan8'
ptmp = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/Analysis_major_events/Jan9/'
cdf2tplot,ptmp+'thb_l2_mom_20140109_v01.cdf'
copy_data,'thb_peem_density','thb_peem_density_jan9'
copy_data,'thb_peim_density','thb_peim_density_jan9'

get_data,'thb_peem_density_jan8',x1,y1
get_data,'thb_peem_density_jan9',x2,y2
store_data,'thb_peem_density',[x1,x2],[y1,y2]
get_data,'thb_peim_density_jan8',x1,y1
get_data,'thb_peim_density_jan9',x2,y2
store_data,'thb_peim_density',[x1,x2],[y1,y2]



;Remove NaN values 
get_data,'thb_peim_density',t,d 
goo = where(finite(d) ne 0.)
store_data,'thb_peim_density',t[goo],d[goo]

get_data,'fspc_2K',t,d 
goo = where(finite(d) ne 0.)
store_data,'fspc_2K',t[goo],d[goo]


;ptmp = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/Analysis_major_events/Jan8/'
;cdf2tplot,ptmp+'thb_l2_fgm_20140108_v01.cdf'
;copy_data,'thb_fgs_btotal','thb_fgs_btotal_jan8'
;ptmp = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/Analysis_major_events/Jan9/'
;cdf2tplot,ptmp+'thb_l2_fgm_20140109_v01.cdf'
;copy_data,'thb_fgs_btotal','thb_fgs_btotal_jan9'

;get_data,'thb_fgs_btotal_jan8',x1,y1
;get_data,'thb_fgs_btotal_jan9',x2,y2
;store_data,'thb_fgs_btotal',[x1,x2],[y1,y2]





      window_minutes = 90.
        lag_factor = 8.
        coherence_multiplier = 2.5
 
    ;calculate the cross spectra
    window = 60.*window_minutes   ;seconds
    lag = window/lag_factor
    coherence_time = window*coherence_multiplier

    ;Tshift THB data 
    get_data,'thb_peim_density',data=v2
    store_data,'thb_peim_density_tshift',v2.x+(60.*10.),v2.y    
    tplot,['fspc_2K_smoothed','thb_peim_density_tshift']


    get_data,'thb_peim_density',data=v2
    store_data,'thb_peim_density_tshift',v2.x+(60.*10.),v2.y    
    tplot,['fspc_2K_smoothed','thb_peim_density_tshift']
    get_data,'thb_peim_density',data=v2
    store_data,'thb_peim_density_tshift',v2.x+(60.*10.),v2.y    
    tplot,['fspc_2K_smoothed','thb_peim_density_tshift']
;    get_data,'thb_peim_density_tshift',data=v2

    v1 = 'fspc_2K'
    ;v2 = 'thb_fgs_btotal_tshift'
    v2 = 'thb_peim_density_tshift'

    ;Find T1 and T2 based on common times in tplot variables v1 and v2

    T1 = time_double('2014-01-08/00:00')
    T2 = time_double('2014-01-09/23:59')
;    T1 = v1.x[0] > v2.x[0]
;    T2 = v1.x[n_elements(v1.x)-1] < v2.x[n_elements(v2.x)-1]
    timespan,T1,(T2-T1),/seconds



    dynamic_cross_spec_tplot,v1,0,v2,0,T1,T2,window,lag,coherence_time,$
            new_name='Precip'

    copy_data,'Precip_coherence','coh_2K_THB_peim_density'
    get_data,'coh_2K_THB_peim_density',data=d
    ;get_data,'coh_2K_THB_peem_dens',data=d
    periods = 1/d.v/60.
    periodmin = 1.
    goodperiods = where(periods gt periodmin)



    ;Set NaN values to a really low coherence value
    goo = where(finite(d.y) eq 0)
    if goo[0] ne -1 then d.y[goo] = 0.1



    ;Store coherence data so that it plots in a nice way
    store_data,'coh_2K_THB_peim_density',d.x,d.y[*,goodperiods],1/d.v[goodperiods]/60.
    options,'coh_2K_THB_peim_density','spec',1
    ylim,['coh_2K_THB_peim_density','phase_2K_THB_peim_density'],5,60,1
    zlim,'coh_2K_THB_peim_density',0.2,0.9,0
    options,'coh_2K_THB_peim_density','ytitle','Coherence(2K_THB_peim_density)!C[Period (min)]'

    copy_data,'Precip_phase','phase_2K_THB_peim_density'
    store_data,['Precip_coherence','dynamic_FFT_?','Precip_phase'],/delete
    get_data,'phase_2K_THB_peim_density',data=d
    store_data,'phase_2K_THB_peim_density',d.x,d.y[*,goodperiods],1/d.v[goodperiods]/60.
    options,'phase_2K_THB_peim_density','spec',1
    options,'phase_2K_THB_peim_density','ytitle','Phase(2K_THB_peim_dens)!C[Period (min)]'
    ylim,'phase_2K_THB_peim_density',5,60,1
    zlim,'phase_2K_THB_peim_density',-180,180,0




    tplot,['coh_2K_THB_peim_density','fspc_2K_smoothed',v2]


        meanfilterwidth = 5.
        meanfilterheight = 5.
    mincoh = 0.6
    threshold = 0.0001 
    ratiomax = 1.2 
    periodmin = 10. 
    periodmax = 40. 

    lshell1 = 'L_Kp2_2K' & lshell2 = 'L_Kp2_2K'
    mlt1 = 'MLT_Kp2_2K' & mlt2 = 'MLT_Kp2_2K'


    copy_data,'coh_2K_THB_peim_density','coh_2K_THB_peim_density2'
    copy_data,'phase_2K_THB_peim_density','phase_2K_THB_peim_density2'

    filter_coherence_spectra,'coh_2K_THB_peim_density2',$
    lshell1,lshell2,$
    mlt1,mlt2,$
    mincoh,$
    periodmin,periodmax,$
    ratiomax=ratiomax,$
    anglemax=45.,$
    winsize=winsize,$
    remove_mincoh=1,$
    remove_slidingwindow=1,$
    phase_tplotvar='phase_2K_THB_peim_density2'

tplot,['coh_2K_THB_peim_density2','coh_2K_THB_peim_density2_orig','fspc_2K_smoothed',v2]





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
rbsp_detrend,'OMNI_HRO_1min_'+['proton_density','T','Pressure','E','Beta']+'_smoothed',80.*60.
tlimit,'2014-01-08/15:00','2014-01-09/00:00'
tplot,'OMNI_HRO_1min_'+['T','E','Beta']+'_smoothed_detrend'
tplot,'omni_press_dyn_smoothed_detrend',/add
tplot,['coh_KL_meanfilter','coh_LX_meanfilter','fspc_2K_smoothed','fspc_2L_smoothed','fspc_2X_smoothed','fspc_comb_KL','fspc_comb_LX'],/add


tplot,'omni_press_dyn_smoothed_detrend'
tplot,['fspc_comb_KL','fspc_comb_LX'],/add



tplot,['omni_press_dyn_smoothed','wi_dens_hires','fspc_2?_smoothed','MLT_Kp2_2K','L_Kp2_2K']

tplot,['g1?_dtc_cor_eflux_0_smoothed','omni_press_dyn','wi_dens_hires','OMNI_HRO_1min_Bmag','fspc_2K_smoothed']


;THEMIS b,c see the ~21:40 UT event in upstream solar wind 
;It may be a pressure-balanced structure. Density decrease, Bo increase. 
tplot,['thb_fgs_btotal','thb_fgs_gse','thb_peim_density','thb_peim_velocity_gse','thb_peim_velocity_mag','fspc_2K_smoothed']
tplot,['omni_press_dyn','thb_fgs_btotal','thb_peem_density','fspc_2?_smoothed','g1?_dtc_cor_eflux_0_smoothed']

tplot,['thb_fgs_btotal','thb_peem_density','fspc_2K_smoothed']


;^^Comparison with RBSPb hiss 
zlim,'rbspb_spec64_scmw',1d-9,1d-5,1
rbsp_detrend,'Bfield_hissintb',60.*2.
tplot,['rbspb_spec64_scmw','Bfield_hissintb_smoothed','fspc_2L_smoothed_detrend','fspc_2K_smoothed_detrend','fspc_2X_smoothed_detrend','fspc_2W_smoothed_detrend']
tplot,['rbspb_spec64_scmw','Bfield_hissintb_smoothed','fspc_2L','fspc_2L_smoothed']
end

