;also see Jan11_event.ppt


;pro event_analysis_jan11
  rbsp_efw_init
  tplot_options,'title','event_analysis_jan11.pro'

	tplot_options,'xmargin',[20.,16.]
	tplot_options,'ymargin',[3,9]
	tplot_options,'xticklen',0.08
	tplot_options,'yticklen',0.02
	tplot_options,'xthick',2
	tplot_options,'ythick',2
	tplot_options,'labflag',-1	
	
  pre = '2'
  timespan,'2014-01-11',2,/days

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
fn = 'barrel_2T_fspc_fullmission.tplot' & tplot_restore,filenames=path + fn
fn = 'barrel_2I_fspc_fullmission.tplot' & tplot_restore,filenames=path + fn

;Restore individual coherence spectra
path = args_manual.datapath + args_manual.folder_coh + '/'
fn = 'KL_meanfilter.tplot' & tplot_restore,filenames=path + fn
fn = 'KX_meanfilter.tplot' & tplot_restore,filenames=path + fn
fn = 'TK_meanfilter.tplot' & tplot_restore,filenames=path + fn
fn = 'LX_meanfilter.tplot' & tplot_restore,filenames=path + fn
fn = 'TL_meanfilter.tplot' & tplot_restore,filenames=path + fn
fn = 'TX_meanfilter.tplot' & tplot_restore,filenames=path + fn
fn = 'IK_meanfilter.tplot' & tplot_restore,filenames=path + fn
fn = 'IL_meanfilter.tplot' & tplot_restore,filenames=path + fn
fn = 'IX_meanfilter.tplot' & tplot_restore,filenames=path + fn
fn = 'IT_meanfilter.tplot' & tplot_restore,filenames=path + fn


tnt = tnames('coh_??_meanfilter')
for i=0,n_elements(tnt)-1 do options,tnt[i],'ytitle', strmid(tnt[i],4,2)
tplot,['coh_allcombos_meanfilter_normalized2','coh_allcombos_meanfilter_normalized2_OMNI_press_dyn','coh_??_meanfilter']


kyoto_load_ae
kyoto_load_dst


rbsp_detrend,'fspc_2?',5.*60.
rbsp_detrend,'fspc_2?_smoothed',60.*80.


;load BARREL rcnt data to see if gaps are filled. 

load_barrel_lc,['2X','2L','2K','2W','2T','2I'],type='rcnt'
rbsp_detrend,'PeakDet_2?',5.*60.
rbsp_detrend,'PeakDet_2?_smoothed',60.*80.

load_barrel_lc,['2X','2L','2K','2W','2T','2I'],type='ephm'
tplot,'MLT_Kp2_'+['2X','2L','2K','2W','2T','2I']



;***********************************************
;Survey plot with no detrending 
;***********************************************



path = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/Analysis_major_events_campaign2/Jan11/'

;THEMIS-E flux 
fn = 'the_l2s_mom_20140111160001_20140111235857.cdf'
cdf2tplot,path+fn
fn = 'the_l2s_esa_20140111160226_20140111235659.cdf'
cdf2tplot,path+fn

;THEMIS-A flux
fn = 'tha_l2s_esa_20140101000001_20140212235958.cdf'
cdf2tplot,path+fn

;THEMIS-A hires spectra (GMOM electrons, ESA + SST)
fn = 'tha_l2s_gmom_20140101000035_20140214235956.cdf'
cdf2tplot,path+fn

;THEMIS-A total electron pressure
fn = 'tha_l2s_mom_20140101000001_20140215235857.cdf'
cdf2tplot,path+fn


fn = 'tha_flux11deg_20140111_Xiaoxia_spec_plot.tplot'
tplot_restore,filename=path+fn
;Integrate THA flux > 20 keV 
get_data,'flux11deg_spec',data=d 
fluxtmp = d.y[*,10:26]
fluxtots = fltarr(n_elements(d.x))
for i=0,n_elements(d.x)-1 do fluxtots[i] = total(fluxtmp[i,*])
store_data,'fluxint_gt20keV',d.x,fluxtots
fluxtmp = d.y[*,15:26]
fluxtots = fltarr(n_elements(d.x))
for i=0,n_elements(d.x)-1 do fluxtots[i] = total(fluxtmp[i,*])
store_data,'fluxint_gt30keV',d.x,fluxtots
fluxtmp = d.y[*,18:26]
fluxtots = fltarr(n_elements(d.x))
for i=0,n_elements(d.x)-1 do fluxtots[i] = total(fluxtmp[i,*])
store_data,'fluxint_gt52keV',d.x,fluxtots
fluxtmp = d.y[*,15:18]
fluxtots = fltarr(n_elements(d.x))
for i=0,n_elements(d.x)-1 do fluxtots[i] = total(fluxtmp[i,*])
store_data,'fluxint_gt30-52keV',d.x,fluxtots

;Integrate hi-res THEMIS-A spectral e- flux (>20 keV)

get_data,'tha_pterf_en_eflux',data=d 
fluxtmp = d.y[*,29:45]
fluxtots = fltarr(n_elements(d.x))
for i=0,n_elements(d.x)-1 do fluxtots[i] = total(fluxtmp[i,*])
store_data,'tha_fluxhires_int_gt20keV',d.x,fluxtots

;>30 keV integrated
get_data,'tha_pterf_en_eflux',data=d 
fluxtmp = d.y[*,34:45]
fluxtots = fltarr(n_elements(d.x))
for i=0,n_elements(d.x)-1 do fluxtots[i] = total(fluxtmp[i,*])
store_data,'tha_fluxhires_int_gt30keV',d.x,fluxtots





;Average GOES flux at various pitch angles for energies 40, 75, 150, 275, 475
fn = 'goes15_eps-mageds_1min_20140101000000_20140214114500.cdf'
cdf2tplot,path+fn

tplot,['dtc_cor_eflux_t_stack1','dtc_cor_eflux_t_stack2','dtc_cor_eflux_t_stack3','dtc_cor_eflux_t_stack4','dtc_cor_eflux_t_stack5']

;fn = 'goes15_eps-mageds_5min_20140101000000_20140215000000.cdf'
fn = 'goes15_epead-science-electrons-e13ews_1min_20140101000000_20140214114500.cdf'
cdf2tplot,path+fn

ylim,'dtc_cor_eflux_t_stack2',0,1d5,0
ylim,'E1W_COR_FLUX',0,20000,0

timespan,'2014-01-08',5,/days
load_barrel_lc,'2X',type='rcnt'
load_barrel_lc,'2X',type='fspc'
load_barrel_lc,'2X',type='ephm'
load_barrel_lc,'2X',type='sspc'

;Integrate SSPC flux for >30 keV
get_data,'SSPC_2X',data=d 
sspctmp = d.y[*,12:255]
sspctots = fltarr(n_elements(d.x))
for i=0,n_elements(d.x)-1 do sspctots[i] = total(sspctmp[i,*])
store_data,'sspc_gt30',d.x,sspctots

t0tmp = time_double('2014-01-08/00:00')
t1tmp = time_double('2014-01-13/24:00')
plot_omni_quantities,t0avg=t0tmp,t1avg=t1tmp

rbsp_detrend,'omni_press_dyn',60*80.

ylim,'L_Kp2_2X',0,12
ylim,'alt_2X',20,40

;Long duration plot. 
;BARREL sees flux when it is at large L, sufficient rad belt population, etc 
timespan,'2014-01-08',5,/days
tplot,['OMNI_HRO_1min_AE_INDEX','omni_press_dyn','omni_press_dyn_detrend','dtc_cor_eflux_t_stack1','dtc_cor_eflux_t_stack2','SSPC_2X','PeakDet_2X','MLT_Kp2_2X','alt_2X','L_Kp2_2X']

;Intermediate duration plot
ylim,'tha_pee?_en_eflux',1000,30000,1
ylim,'flux11deg_spec',1000,100000,0
ylim,'SSPC_2X',30,100,1
timespan,'2014-01-11/16:00',12,/hours

;Subtract off baseline of ~800 counts. 
get_data,'PeakDet_2X',data=d
d.y = d.y - 800.
store_data,'PeakDet_2X_basesubtracted',data=d
ylim,'PeakDet_2X_basesubtracted',0,4000

get_data,'sspc_gt30',data=d
d.y = d.y - 210.
store_data,'sspc_gt30_basesubtracted',data=d
ylim,'sspc_gt30_basesubtracted',0,1300




;Calculate fractional change as 1 - (x-dx)/x. 
;This indicates that the fractional change for integrated (SSPC) >30 keV X-ray flux 
;is greater than the >30 keV THEMIS-A flux.
;Suggests that there is a sudden-onset component to the hiss

;rbsp_detrend,'PeakDet_2X_basesubtracted',60.*30.
copy_data,'tha_fb_scm1_3pT','tha_fb_scm1_3pT_v2'
rbsp_detrend,'tha_fb_scm1_3pT',60.*1.
rbsp_detrend,'tha_fb_scm1_3pT_v2',60.*1.
ylim,'tha_fb_scm1_3pT_smoothed',0,25
ylim,'tha_fb_scm1_3pT_v2_smoothed',0,40

tplot,['omni_press_dyn','sspc_gt30_basesubtracted','fluxint_gt30keV','tha_fb_scm1_3pT_v2_smoothed']

options,['MLT_Kp2_2X','alt_2X','L_Kp2_2X'],'panel_size',0.5
options,'dtc_cor_eflux_t_stack1','ytitle','G15 flux >45 keV'
options,'sspc_gt30_basesubtracted','ytitle','BARREL 2X!CSSPC >30 keV integrated!Cbaseline subtracted'
options,'fluxint_gt30keV','THEMIS-A >30keV!Ce- flux'
options,'tha_fb_scm1_3pT_v2_smoothed','THEMIS-A FBK!C40 Hz SCM'


rbsp_detrend,'tha_fluxhires_int_gt30keV',60.*80.

ylim,'tha_fb_scm1_3pT_v2',0,40
ylim,'omni_press_dyn',0.5,3
zlim,'tha_pterf_en_eflux',1d0,1d8,1
ylim,'tha_pterf_en_eflux',30000,300000,0
ylim,'tha_fluxhires_int_gt30keV_detrend',-1d7,1d7


;*************************
;FIGURE 1 PLOT 
;*************************

tplot,['omni_press_dyn',$
;'wi_dens_hires_tshift',$
'OMNI_HRO_1min_AE_INDEX',$
;'dtc_cor_eflux_t_stack1',$        ;G15 geosync flux at >45 keV
'tha_pterf_en_eflux',$
'tha_fluxhires_int_gt30keV',$  ;THA >30 keV energy lux from hires ESA+SST GMOM
;'tha_fluxhires_int_gt30keV_detrend',$  ;THA >30 keV energy lux from hires ESA+SST GMOM
;'fluxint_gt30keV',$               ;THA >30 keV flux
'tha_fb_scm1_3pT_v2',$   ;40 Hz FBK channel, smoothed to THA particle data
'SSPC_2X',$
'sspc_gt30_basesubtracted'] ;,$      ;2X SSPC >30 keV flux, baseline subtracted, smoothed to THA particle data
;'MLT_Kp2_2X','alt_2X','L_Kp2_2X']

;*************************
;FIGURE 2 PLOT 
;*************************

tplot,['omni_press_dyn_detrend',$
'tha_fluxhires_int_gt30keV_detrend',$  ;THA >30 keV energy lux from hires ESA+SST GMOM
;'tha_fluxhires_int_gt30keV_detrend',$  ;THA >30 keV energy lux from hires ESA+SST GMOM
;'fluxint_gt30keV',$               ;THA >30 keV flux
'tha_fb_scm1_3pT_v2',$   ;40 Hz FBK channel, smoothed to THA particle data
'sspc_gt30_basesubtracted_detrend']  ;,$      ;2X SSPC >30 keV flux, baseline subtracted, smoothed to THA particle data














ts = time_double('2014-01-11/' + ['20:00','22:00','23:58'])
for i=0,2 do print,tsample('MLT_Kp2_2X',ts[i],times=tms)
for i=0,2 do print,tsample('L_Kp2_2X',ts[i],times=tms)
for i=0,2 do print,tsample('alt_2X',ts[i],times=tms)

ts = time_double('2014-01-12/' + ['02:00'])
for i=0,2 do print,tsample('MLT_Kp2_2X',ts[i],times=tms)
for i=0,2 do print,tsample('L_Kp2_2X',ts[i],times=tms)
for i=0,2 do print,tsample('alt_2X',ts[i],times=tms)


;tplot,['OMNI_HRO_1min_AE_INDEX','omni_press_dyn','omni_press_dyn_detrend','dtc_cor_eflux_t_stack1','dtc_cor_eflux_t_stack2','flux11deg_spec','fluxint_gt20keV','fluxint_gt30keV','fluxint_gt52keV','SSPC_2X','PeakDet_2X_basesubtracted','MLT_Kp2_2X','alt_2X','L_Kp2_2X']

;tplot,['dtc_cor_eflux_t_stack1','dtc_cor_eflux_t_stack2','dtc_cor_eflux_t_stack3','dtc_cor_eflux_t_stack4','dtc_cor_eflux_t_stack5']


;Only a few % modulation in GOES15 total flux at ~40 keV, however a significant modulation in the 
;e- flux lost.


;---------------------------------------------------------------------
;Figure out the energy range of precipitated electron


load_barrel_lc,'2X',type='sspc'
get_data,'SSPC_2X',data=d 
barbins = d.v


t0z = time_double('2014-01-11/23:10')
t1z = time_double('2014-01-11/23:20')

baryv = tsample('SSPC_2X',[t0z,t1z],times=tmsbar)

;Now compare this to the THEMIS A energy distribution during conjunction 
;first run crib sheet thm_crib_esa_dist2scpot.pro (first few lines only)

get_data,'tha_peer_en_counts',data=d
thayv = tsample('tha_peer_en_counts',[t0z,t1z],times=tmstha)
enbins = reform(d.v[0,*])




;normalize each energy spectrum to 40 keV count rate
good = where(barbins ge 40.) & good = good[0]
max40bar = max(baryv[*,good])

;....energies are in order of highest-lowest
good = where(enbins le 40.) & good = good[0]
max40tha = max(thayv[*,good])

!p.multi = [0,0,2]
plot,barbins,baryv[0,*]/max40bar,xrange=[20,150],xstyle=1,yrange=[0,1.5]
for i=0,n_elements(tmsbar)-1 do oplot,barbins,baryv[i,*]/max40bar
for i=0,n_elements(tmstha)-1 do oplot,enbins,thayv[i,*]/max40tha,color=250


;log scale shows these two have very similar slopes
plot,barbins,baryv[0,*]/max40bar,xrange=[20,150],xstyle=1,yrange=[0.03,2],/ylog,/ystyle
for i=0,n_elements(tmsbar)-1 do oplot,barbins,baryv[i,*]/max40bar
for i=0,n_elements(tmstha)-1 do oplot,enbins,thayv[i,*]/max40tha,color=250



;!p.multi = [0,0,2]
;plot,barbins,baryv[0,*],xrange=[20,150],xstyle=1,yrange=[0,100]
;for i=0,n_elements(tmsbar)-1 do oplot,barbins,baryv[i,*]
;plot,enbins,thayv[0,*],xrange=[20,150],xstyle=1,yrange=[0,8000]
;for i=0,n_elements(tmstha)-1 do oplot,enbins,thayv[i,*]


;------------------------------------------------------------------------

stop


;--------------------------------------------------------------
;Load RBSP data
;--------------------------------------------------------------






;---------------------------------------------------
;Plot LANL sat observations
;---------------------------------------------------


pp = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/Analysis_major_events_campaign2/Jan11/'

tplot_restore,filenames=pp+'lanl_sat_1991-080_20140111.tplot'
tplot_restore,filenames=pp+'lanl_sat_1994-084_20140111.tplot'
tplot_restore,filenames=pp+'lanl_sat_LANL-01A_20140111.tplot'
tplot_restore,filenames=pp+'lanl_sat_LANL-02A_20140111.tplot'
tplot_restore,filenames=pp+'lanl_sat_LANL-04A_20140111.tplot'
tplot_restore,filenames=pp+'lanl_sat_LANL-97A_20140111.tplot'


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
;Load OMNI SW data
;--------------------------------------------------------------


t0tmp = time_double('2014-01-11/00:00')
t1tmp = time_double('2014-01-12/24:00')
plot_omni_quantities,t0avg=t0tmp,t1avg=t1tmp

tplot,['kyoto_ae','coh_allcombos_meanfilter_normalized2','coh_allcombos_meanfilter_normalized2_OMNI_press_dyn','fspc_2L_smoothed_detrend','fspc_2X_smoothed_detrend','coh_LX_meanfilter'],/add



;tplot,['omni_Np','omni_elect_density']+'_smoothed_detrend'
tplot,['coh_allcombos_meanfilter_normalized2_OMNI_press_dyn','omni_press_dyn_smoothed','fspc_2?_smoothed']
tplot,['coh_allcombos_meanfilter_normalized2_OMNI_press_dyn','omni_press_dyn_smoothed_detrend','fspc_2?_smoothed_detrend']

tplot,['coh_allcombos_meanfilter_normalized2_OMNI_press_dyn','omni_press_dyn_smoothed']
tplot,['fspc_2L_smoothed','fspc_2X_smoothed','fspc_comb_LX'],/add


;^^Test IMF Bz 
tplot,['OMNI_HRO_1min_B?_GSM']
tplot,['fspc_comb_LX'],/add

;^^Check Vsw flow speed 
tplot,'OMNI_HRO_1min_flow_speed'
tplot,['fspc_comb_LX'],/add

;^^Check solar wind density
rbsp_detrend,'OMNI_HRO_1min_proton_density',60.*2.
rbsp_detrend,'OMNI_HRO_1min_proton_density_smoothed',60.*80.


tplot,'OMNI_HRO_1min_proton_density'


tplot,['IMF_orientation_comb','Bz_rat_comb','clockangle_comb','coneangle_comb']
tplot,['clockangle_comb','coneangle_comb','kyoto_ae','kyoto_dst','OMNI_HRO_1min_flow_speed']


;---------------------------------------
;Plot location of balloon payloads
;---------------------------------------

;plot_dial_payload_location_specific_time,'2014-01-11/14:00'
;plot_dial_payload_location_specific_time,'2014-01-11/19:00'
;plot_dial_payload_location_specific_time,'2014-01-11/23:30',/plotpp



;-----------------------------------------------
;LOAD GEOTAIL DATA (in upstream SW at 25 RE relatively close to subsolar point)
;--Doesn't really add anything not in OMNI. Density shows same fluctuations 
;--but there's an annoying dropout at 22:20. 
;-----------------------------------------------

path = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/Analysis_major_events_campaign2/Jan11/'
fn = 'ge_h0s_cpi_20140111160056_20140112232918.cdf'
cdf2tplot,path+fn
fn = 'ge_k0s_lep_20140111160032_20140112232936.cdf'
cdf2tplot,path+fn
fn = 'ge_k0s_mgf_20140111160016_20140112232952.cdf'
cdf2tplot,path+fn






;-----------------------------------------------
;LOAD THEMIS DATA 
;-----------------------------------------------


;For some reason the TDAS routines aren't loading the THEMIS FGM data properly. 
;So, I've exported the data from Autoplot and am loading it here. 

path = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/Analysis_major_events_campaign2/Jan11/'
fn = 'tha_l2_fgm_bmag_20140111_v01.ascii'
openr,lun,path+fn,/get_lun
jnk = '' 
times = '' 
bmag = ''
for i=0,4 do readf,lun,jnk
while not eof(lun) do begin $
  readf,lun,jnk & $
  dat = strsplit(jnk,',',/extract) & $
  times = [times,dat[0]] & $
  bmag = [bmag,dat[1]]
endwhile
close,lun & free_lun,lun
nelem = n_elements(times)
times = times[1:nelem-1]
bmag = bmag[1:nelem-1]
t2 = time_double(times)
store_data,'tha_bmag11',t2,float(bmag)

fn = 'tha_l2_fgm_bmag_20140112_v01.ascii'
openr,lun,path+fn,/get_lun
jnk = '' 
times = '' 
bmag = ''
for i=0,4 do readf,lun,jnk
while not eof(lun) do begin $
  readf,lun,jnk & $
  dat = strsplit(jnk,',',/extract) & $
  times = [times,dat[0]] & $
  bmag = [bmag,dat[1]]
endwhile
close,lun & free_lun,lun
nelem = n_elements(times)
times = times[1:nelem-1]
bmag = bmag[1:nelem-1]
t2 = time_double(times)
store_data,'tha_bmag12',t2,float(bmag)



;Load the B-vector data
fn = 'tha_l2_fgm_bvec_20140111_v01.ascii'
openr,lun,path+fn,/get_lun
jnk = '' 
times = '' 
bx = '' & by = '' & bz = ''
for i=0,4 do readf,lun,jnk
while not eof(lun) do begin $
  readf,lun,jnk & $
  dat = strsplit(jnk,',',/extract) & $
  times = [times,dat[0]] & $
  bx = [bx,dat[1]] & by = [by,dat[2]] & bz = [bz,dat[3]]
endwhile
close,lun & free_lun,lun

nelem = n_elements(times)
times = times[1:nelem-1]
bx = bx[1:nelem-1]
by = by[1:nelem-1]
bz = bz[1:nelem-1]
t2 = time_double(times)
store_data,'tha_bvec11',t2,[[float(bx)],[float(by)],[float(bz)]]


fn = 'tha_l2_fgm_bvec_20140112_v01.ascii'
openr,lun,path+fn,/get_lun
jnk = '' 
times = '' 
bx = '' & by = '' & bz = ''
for i=0,4 do readf,lun,jnk
while not eof(lun) do begin $
  readf,lun,jnk & $
  dat = strsplit(jnk,',',/extract) & $
  times = [times,dat[0]] & $
  bx = [bx,dat[1]] & by = [by,dat[2]] & bz = [bz,dat[3]]
endwhile
close,lun & free_lun,lun

nelem = n_elements(times)
times = times[1:nelem-1]
bx = bx[1:nelem-1]
by = by[1:nelem-1]
bz = bz[1:nelem-1]
t2 = time_double(times)
store_data,'tha_bvec12',t2,[[float(bx)],[float(by)],[float(bz)]]


get_data,'tha_bvec11',data=d11
get_data,'tha_bvec12',data=d12
store_data,'tha_bvec_gse',[d11.x,d12.x],[[reform(d11.y[*,0]),reform(d12.y[*,0])],[reform(d11.y[*,1]),reform(d12.y[*,1])],[reform(d11.y[*,2]),reform(d12.y[*,2])]]

get_data,'tha_bmag11',data=d11 
get_data,'tha_bmag12',data=d12
store_data,'tha_bmag',[d11.x,d12.x],[d11.y,d12.y]


;Look for EMIC waves in the THEMIS A EFI data 
;NOTE: the FGM data only has sample rate of ~0.34 S/sec, and therefore won't likely see them. 
;The SCM data stops at ~15 UT. 



fn = 'tha_l2_efi_20140111_v01.ascii'
openr,lun,path+fn,/get_lun
jnk = '' 
times = '' 
ex = '' & ey = '' & ez = ''
for i=0,4 do readf,lun,jnk
while not eof(lun) do begin $
  readf,lun,jnk & $
  dat = strsplit(jnk,',',/extract) & $
  times = [times,dat[0]] & $
  ex = [ex,dat[1]] & ey = [ey,dat[2]] & ez = [ez,dat[3]]
endwhile
close,lun & free_lun,lun

nelem = n_elements(times)
times = times[1:nelem-1]
ex = ex[1:nelem-1]
ey = ey[1:nelem-1]
ez = ez[1:nelem-1]
t2 = time_double(times)
store_data,'tha_evec11',t2,[[float(ex)],[float(ey)],[float(ez)]]


get_data,'tha_bmag',data=d
store_data,'tha_fce',d.x,28.*d.y 
store_data,'tha_fce_10',d.x,28.*d.y/10.
store_data,'tha_fce_2',d.x,28.*d.y/2.
store_data,'tha_fci',d.x,28.*d.y/1836.
store_data,'tha_fci_Hep',d.x,28.*d.y/(4*1836.)
store_data,'tha_fci_Op',d.x,28.*d.y/(16*1836.)
store_data,'tha_flh',d.x,sqrt(abs(28.*d.y)*(28.*d.y/1836.))


;Check out how flh varies in the low and high density limits. 
fci = 28.*d.y/1836.
fce = 28.*d.y
ntmp = 1.
fpe = 8980.*sqrt(ntmp)
fpi = replicate(fpe/sqrt(43.),n_elements(d.x))  ;Hz  (estimate from n=2 cm-3)
flhr2 = sqrt(fpi*fpi*fce*fci)/sqrt(fce*fci+(fpi^2))   ;Lower Hybrid Res freq (Hz)
store_data,'tha_flh2',d.x,flhr2
store_data,'flh_comp',data=['tha_flh','tha_flh2'] & options,'flh_comp','colors',[0,250]
tplot,'flh_comp'


;------------------------------
;Look for EMIC waves
split_vec,'tha_evec11'
rbsp_spec,'tha_evec11_x',npts=64/2.,n_ave=2.
rbsp_spec,'tha_evec11_y',npts=64/2.,n_ave=2.
rbsp_spec,'tha_evec11_z',npts=64/2.,n_ave=2.
ylim,'tha_evec11_?_SPEC',0,0.2
zlim,'tha_evec11_x_SPEC',1d-3,1d1,1

split_vec,'tha_bvec11'
rbsp_spec,'tha_bvec11_x',npts=64/2.,n_ave=2.
rbsp_spec,'tha_bvec11_y',npts=64/2.,n_ave=2.
rbsp_spec,'tha_bvec11_z',npts=64/2.,n_ave=2.
ylim,'tha_bvec11_?_SPEC',0,0.2
zlim,'tha_bvec11_?_SPEC',1d-3,1d1,1
;zlim,'tha_bvec11_?_SPEC',1d-8,1d0,1

store_data,'Exspec',data=['tha_evec11_x_SPEC','tha_fci_Hep','tha_fci_Op']
store_data,'Eyspec',data=['tha_evec11_y_SPEC','tha_fci_Hep','tha_fci_Op']
store_data,'Ezspec',data=['tha_evec11_z_SPEC','tha_fci_Hep','tha_fci_Op']
ylim,'E?spec',0,0.5


store_data,'Bxspec',data=['tha_bvec11_x_SPEC','tha_fci_Hep','tha_fci_Op']
store_data,'Byspec',data=['tha_bvec11_y_SPEC','tha_fci_Hep','tha_fci_Op']
store_data,'Bzspec',data=['tha_bvec11_z_SPEC','tha_fci_Hep','tha_fci_Op']
ylim,'B?spec',0,0.5


;THEMIS A may show some EMIC waves...mostly after 23 UT
tplot,['tha_bvec11','B?spec']
tplot,['tha_evec11','E?spec']




;Find EMIC waves on GOES 
goes_load_data,datatype='fgm',probes=['13','15']

; we can transform the FGM data into other coordinate systems as well,
; first by making a transformation matrix, using the position data loaded from the load routine. 
; the new transformation matrix should be named 'g15_pos_gei_enp_mat'
enp_matrix_make, 'g15_pos_gei'

; rotate the FGM data from ENP coordinates to GEI coordinates
tvector_rotate, 'g15_pos_gei_enp_mat', 'g15_H_enp_1', /invert

; that rotation gives a tplot variable with the horrible name 'g15_b_enp_rot', we can copy
; it to a new variable with a better name, 'g15_H_gei'
copy_data, 'g15_H_enp_1_rot', 'g15_H_gei'

; and now we can set the labels and title appropriately
options,'g15_H_gei',labels=['x_gei','y_gei','z_gei'],ytitle='g15_H_gei'

;This should be the magnetometer data in GEI coord
tplot,'g15_H_gei'



get_data,'g15_BTSC_1',data=d
store_data,'g15_fce',d.x,28.*d.y 
store_data,'g15_fce_10',d.x,28.*d.y/10.
store_data,'g15_fce_2',d.x,28.*d.y/2.
store_data,'g15_fci',d.x,28.*d.y/1836.
store_data,'g15_fci_Hep',d.x,28.*d.y/(4*1836.)
store_data,'g15_fci_Op',d.x,28.*d.y/(16*1836.)
store_data,'g15_flh',d.x,sqrt(abs(28.*d.y)*(28.*d.y/1836.))




split_vec,'g15_H_gei'
rbsp_spec,'g15_H_gei_x',npts=64/2.,n_ave=2.
rbsp_spec,'g15_H_gei_y',npts=64/2.,n_ave=2.
rbsp_spec,'g15_H_gei_z',npts=64/2.,n_ave=2.
ylim,'g15_H_gei_?_SPEC',0,1
zlim,'g15_H_gei_?_SPEC',1d-3,1d1,1




store_data,'Bxspecg15',data=['g15_H_gei_x_SPEC','g15_fci_Hep','g15_fci_Op']
store_data,'Byspecg15',data=['g15_H_gei_y_SPEC','g15_fci_Hep','g15_fci_Op']
store_data,'Bzspecg15',data=['g15_H_gei_z_SPEC','g15_fci_Hep','g15_fci_Op']
ylim,'B?specg15',0.01,1,1

rbsp_detrend,'g15_H_gei_?',20.
tplot,['g15_H_gei_x_detrend','Bxspecg15','g15_H_gei_y_detrend','Byspecg15','g15_H_gei_z_detrend','Bzspecg15']
tplot,['g15_H_gei_x','Bxspecg15','g15_H_gei_y','Byspecg15','g15_H_gei_z','Bzspecg15']


tplot,['g15_BTSC_1','g15_H_gei']
get_data,'g15_H_gei',data=d



;split_vec,'g13_Bsc_2'







;------------------------------------------------------------






rbsp_detrend,'tha_bvec_gse',60.*2.
rbsp_detrend,'tha_bvec_gse_smoothed',60.*60.
split_vec,'tha_bvec_gse_smoothed_detrend'
ylim,'tha_bvec_gse_smoothed_detrend_?',-6,6
tplot,['tha_bvec_gse_smoothed','tha_bvec_gse_smoothed_detrend_?']




rbsp_detrend,['tha_bmag','tha_fce','tha_fce_10','tha_fci','tha_flh','tha_fce_2'],60.*2.
rbsp_detrend,['tha_bmag','tha_fce','tha_fce_10','tha_fci','tha_flh','tha_fce_2']+'_smoothed',60.*30.

get_data,'tha_fce',data=fce
get_data,'tha_fce_10',data=fce_10
get_data,'tha_fce_2',data=fce_2
get_data,'tha_fci',data=fci
get_data,'tha_flh',data=flh
dat = [[fce.y],[fce_10.y],[fce_2.y],[fci.y],[flh.y]]
store_data,'fces',fce.x,dat





fci = fce*Z/(1836.*muu)                              ;ion cyclotron freq (Hz)
debye = 7.43e2*sqrt(Te)/sqrt(n)/100./1000.           ;Debye length (km) (for e- and ions)
flhr = sqrt(fpi*fpi*fce*fci)/sqrt(fce*fci+(fpi^2))   ;Lower Hybrid Res freq (Hz)
flhr2 = sqrt(abs(fce)*fci)							 						 ;Lower Hybrid Res freq (Hz) --> high dens limit - no plasma freq terms (Gurnett 4.4.51)


;thm_load_fgm,probe='a',type='calibrated'
;get_data,'tha_fge',data=d 
;bmag_tha = sqrt(d.y[*,0]^2 + d.y[*,1]^2 + d.y[*,2]^2)
;tha_l2_fbk_20140112_v01.cdf

thm_load_fbk,probe='a'

split_vec,'tha_fb_scm1'
get_data,'tha_fb_scm1_0',data=d & store_data,'tha_fb_scm1_0pT',d.x,1000.*d.y & options,'tha_fb_scm1_0pT','ytitle','THA FBK [pT]!Cscm1 2689Hz'
get_data,'tha_fb_scm1_1',data=d & store_data,'tha_fb_scm1_1pT',d.x,1000.*d.y & options,'tha_fb_scm1_1pT','ytitle','THA FBK [pT]!Cscm1 670Hz'
get_data,'tha_fb_scm1_2',data=d & store_data,'tha_fb_scm1_2pT',d.x,1000.*d.y & options,'tha_fb_scm1_2pT','ytitle','THA FBK [pT]!Cscm1 160Hz'
get_data,'tha_fb_scm1_3',data=d & store_data,'tha_fb_scm1_3pT',d.x,1000.*d.y & options,'tha_fb_scm1_3pT','ytitle','THA FBK [pT]!Cscm1 40Hz'
get_data,'tha_fb_scm1_4',data=d & store_data,'tha_fb_scm1_4pT',d.x,1000.*d.y & options,'tha_fb_scm1_4pT','ytitle','THA FBK [pT]!Cscm1 9Hz'
get_data,'tha_fb_scm1_5',data=d & store_data,'tha_fb_scm1_5pT',d.x,1000.*d.y & options,'tha_fb_scm1_5pT','ytitle','THA FBK [pT]!Cscm1 2Hz'

split_vec,'tha_fb_edc12'
get_data,'tha_fb_edc12_0',data=d & store_data,'tha_fb_edc12_0mV_m',d.x,d.y & options,'tha_fb_edc12_0mV_m','ytitle','THA FBK [mV/m]!Cedc12 2689Hz'
get_data,'tha_fb_edc12_1',data=d & store_data,'tha_fb_edc12_1mV_m',d.x,d.y & options,'tha_fb_edc12_1mV_m','ytitle','THA FBK [mV/m]!Cedc12 670Hz'
get_data,'tha_fb_edc12_2',data=d & store_data,'tha_fb_edc12_2mV_m',d.x,d.y & options,'tha_fb_edc12_2mV_m','ytitle','THA FBK [mV/m]!Cedc12 160Hz'
get_data,'tha_fb_edc12_3',data=d & store_data,'tha_fb_edc12_3mV_m',d.x,d.y & options,'tha_fb_edc12_3mV_m','ytitle','THA FBK [mV/m]!Cedc12 40Hz'
get_data,'tha_fb_edc12_4',data=d & store_data,'tha_fb_edc12_4mV_m',d.x,d.y & options,'tha_fb_edc12_4mV_m','ytitle','THA FBK [mV/m]!Cedc12 9Hz'
get_data,'tha_fb_edc12_5',data=d & store_data,'tha_fb_edc12_5mV_m',d.x,d.y & options,'tha_fb_edc12_5mV_m','ytitle','THA FBK [mV/m]!Cedc12 2Hz'

rbsp_detrend,'tha_fb_scm1_?pT',60.*.1
rbsp_detrend,'tha_fb_scm1_?pT_smoothed',60.*80.

ylim,'tha_fb_scm1_?pT_smoothed_detrend',0,20
ylim,'tha_fb_scm1_?mV_m_smoothed_detrend',0,10


;smooth to OMNI 1 min cadence
rbsp_detrend,'PeakDet_2X',60.*2. 
rbsp_detrend,'PeakDet_2X_smoothed',60.*80. 


rbsp_detrend,'tha_fb_scm1_2pT',60.*2.   ;smooth over spin period
rbsp_detrend,'tha_fb_scm1_2pT_smoothed',60.*80.

div_data,'tha_fb_scm1_3pT','tha_fb_scm1_2pT'
div_data,'tha_fb_scm1_2pT','tha_fb_scm1_1pT'
div_data,'tha_fb_scm1_3pT_smoothed','tha_fb_scm1_2pT_smoothed'
div_data,'tha_fb_scm1_2pT_smoothed','tha_fb_scm1_1pT_smoothed'

ylim,'tha_fb_scm1_3pT_smoothed/tha_fb_scm1_2pT_smoothed',0,15
ylim,'tha_fb_scm1_2pT_smoothed/tha_fb_scm1_1pT_smoothed',0,15
ylim,'tha_fb_scm1_3pT/tha_fb_scm1_2pT',0,15
ylim,'tha_fb_scm1_2pT/tha_fb_scm1_1pT',0,15
ylim,['tha_fb_scm1_1pT_smoothed','tha_fb_scm1_2pT_smoothed','tha_fb_scm1_3pT_smoothed'],0,60
ylim,['tha_fb_scm1_1pT','tha_fb_scm1_2pT','tha_fb_scm1_3pT'],0,50

ylim,'fces',10,10000,1

tplot,['OMNI_HRO_1min_proton_density','PeakDet_2X_smoothed_detrend','tha_fce','tha_fce_2','tha_fce_10','tha_flh','tha_bmag_smoothed','tha_bmag_smoothed_detrend','tha_fb_scm1_1pT_smoothed','tha_fb_scm1_2pT_smoothed','tha_fb_scm1_3pT_smoothed','tha_fb_scm1_3pT_smoothed/tha_fb_scm1_2pT_smoothed','tha_fb_scm1_2pT_smoothed/tha_fb_scm1_1pT_smoothed','g15_dtc_cor_eflux','g15_dtc_cor_eflux_t_stack1']
tplot,['OMNI_HRO_1min_proton_density','PeakDet_2X_smoothed','tha_fce','tha_fce_2','tha_fce_10','tha_flh','tha_bmag_smoothed','tha_bmag_smoothed_detrend','tha_fb_scm1_1pT','tha_fb_scm1_2pT','tha_fb_scm1_3pT','tha_fb_scm1_3pT/tha_fb_scm1_2pT','tha_fb_scm1_2pT/tha_fb_scm1_1pT','g15_dtc_cor_eflux','g15_dtc_cor_eflux_t_stack1']
tplot,['OMNI_HRO_1min_proton_density_smoothed_detrend','PeakDet_2X_smoothed_detrend','tha_fce','tha_fce_2','tha_fce_10','tha_flh','tha_bmag_smoothed','tha_bmag_smoothed_detrend','tha_fb_scm1_1pT','tha_fb_scm1_2pT','tha_fb_scm1_3pT','tha_fb_scm1_4pT','tha_fb_scm1_3pT/tha_fb_scm1_2pT','tha_fb_scm1_2pT/tha_fb_scm1_1pT','g15_dtc_cor_eflux','g15_dtc_cor_eflux_t_stack1']

;tplot,['OMNI_HRO_1min_proton_density','PeakDet_2X_smoothed','tha_fb_scm1_2pT_smoothed','g15_dtc_cor_eflux','g15_dtc_cor_eflux_t_stack1']
;tplot,['OMNI_HRO_1min_proton_density_detrend','PeakDet_2X_smoothed_detrend','tha_fb_scm1_2pT_smoothed_detrend','g15_dtc_cor_eflux','g15_dtc_cor_eflux_t_stack1']



tplot,['PeakDet_2X_smoothed_detrend','tha_fb_edc12_?mV_m','g15_dtc_cor_eflux','g15_dtc_cor_eflux_t_stack1']




thm_load_fft,probe='e'
ylim,['the_fff_32_edc12','the_fff_32_edc34','the_fff_32_scm2','the_fff_32_scm3'],30,1000,1


thm_load_fft,probe='d'
ylim,['thd_fff_32_edc12','thd_fff_32_edc34','thd_fff_32_scm2','thd_fff_32_scm3'],30,1000,1


;Determine if the THD waves near end of day are magnetosonic. They 
;look very similar to the THA waves during time of the conjunction. 

get_data,'thd_fff_32_edc12',data=es,dlim=dlim  ;(V/m)^2/Hz
get_data,'thd_fff_32_scm2',data=bs   ;nT^2/Hz

store_data,'e_b_rat',es.x,es.y/bs.y,es.v,dlim=dlim
tplot,['e_b_rat','thd_fff_32_edc12','thd_fff_32_scm2']
options,'e_b_rat','ztitle','E/B'
options,'e_b_rat','ytitle','E/B'
ylim,'e_b_rat',10,300,1

;;From Boardsen16, Fig 10, 11
;alog10(nT^2/Hz)=-6.        --> 1d-6 ;nT^2/Hz
;alog10((V/m)^2/Hz) = -10   --> 1d-10  ;(V/m)^2/Hz

;;From THD spectra
;Ew --> 2d-11   ;(V/m)^2/Hz
;Bw --> 5d-6    ;nT^2/Hz

;Typical E2/B2 ratio from THD is 1d-5
;From Boardsen paper typical ratio is ~1d-4. 
;GOOD EVIDENCE THAT THESE ARE MAGNETOSONIC WAVES ON THD. THIS MEANS 
;THIS IS FURTHER PROOF THAT THE WAVES WE'RE SEEING IN THE FBK ON THA 
;ARE MAGNETOSONIC. 

;From Chaston15 (KAWs) Fig3 at 40 Hz I'm finding a E2/B2 ratio of 
;0.02, which is too high for what we observe. 









tplot,['coh_LX_meanfilter','fspc_2L_smoothed_detrend','fspc_2X_smoothed_detrend']
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


thm_load_efi,probe='e'
thm_load_fgm,probe='e'

split_vec,'the_fgl'
split_vec,'the_vaf'
rbsp_detrend,['the_fgl_x'],5.*60.
rbsp_detrend,['the_vaf_0'],5.*60.
rbsp_detrend,['the_fgl_x_smoothed'],80.*60.
rbsp_detrend,['the_vaf_0_smoothed'],80.*60.
;rbsp_detrend,['tha_fge','tha_fgl']+'_smoothed',80.*60.
tplot,['the_fgl_x_smoothed_detrend','the_vaf_0_smoothed_detrend','fspc_2L_smoothed_detrend','fspc_2X_smoothed_detrend']
tplot,['the_fgl_x_smoothed','the_vaf_0_smoothed','fspc_2L_smoothed_detrend','fspc_2X_smoothed_detrend']



;ptmp = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/Analysis_major_events_campaign2/Jan11/'
;cdf2tplot,ptmp+'tha_l2_efi_20140111_v01.cdf'
;cdf2tplot,ptmp+'tha_l2_fgm_20140111_v01.cdf'
;cdf2tplot,ptmp+'tha_l2_mom_20140111_v01.cdf'
;cdf2tplot,ptmp+'thb_l2_efi_20140111_v01.cdf'
;cdf2tplot,ptmp+'thb_l2_fgm_20140111_v01.cdf'
;cdf2tplot,ptmp+'thb_l2_mom_20140111_v01.cdf'
;cdf2tplot,ptmp+'thc_l2_efi_20140111_v01.cdf'
;cdf2tplot,ptmp+'thc_l2_fgm_20140111_v01.cdf'
;cdf2tplot,ptmp+'thc_l2_mom_20140111_v01.cdf'
;cdf2tplot,ptmp+'thd_l2_efi_20140111_v01.cdf'
;cdf2tplot,ptmp+'thd_l2_fgm_20140111_v01.cdf'
;cdf2tplot,ptmp+'thd_l2_mom_20140111_v01.cdf'
;cdf2tplot,ptmp+'the_l2_efi_20140111_v01.cdf'
;cdf2tplot,ptmp+'the_l2_fgm_20140111_v01.cdf'
;cdf2tplot,ptmp+'the_l2_mom_20140111_v01.cdf'



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

;---------------------------------------------------------------------------------------------------
;Wind is about ~195 RE upstream. Vsw is 400 km/s. Thus SW will take ~50 minutes to propagte to Earth.
;This is consistent with OMNI_HR0_1min_Timeshift, which shows values of ~3000 sec, or about 50 min. 
tplot,['wi_SC_pos_gse','wi_swe_V_GSE']
ttst = time_double('2014-01-10/22:00')
coord = tsample('wi_SC_pos_gse',ttst,times=t)
;gse = [1.23995e+06,-99419.8,-96729.1]/6370.


rbsp_detrend,'wi_dens_hires',60.*2.
rbsp_detrend,'wi_dens_hires_smoothed',60.*80.
rbsp_detrend,'OMNI_HRO_1min_proton_density_smoothed',60.*80.

get_data,'wi_dens_hires',data=d 
store_data,'wi_dens_hires_tshift',data={x:d.x+(60.*56.),y:d.y}
get_data,'wi_dens_hires_smoothed_detrend',data=d 
store_data,'wi_dens_hires_smoothed_detrend_tshift',data={x:d.x+(60.*56.),y:d.y}


store_data,'dens_comb',data=['wi_dens_hires_smoothed_detrend_tshift','OMNI_HRO_1min_proton_density_smoothed_detrend']
options,'dens_comb','colors',[0,250]
options,'dens_comb','ytitle','Wind density [black]!COMNI density [red]'
tplot,['dens_comb','wi_dens_hires_smoothed_detrend_tshift','OMNI_HRO_1min_proton_density_smoothed_detrend']
;---------------------------------------------------------------------------------------------------





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
;LOAD GOES DATA
;---------------------------------------------


goes_load_data, trange=['2014-01-11', '2014-01-12'], datatype='epead', probes='15', /avg_1m
ylim,'g15_elec_4MeV_uncor_flux',0,100,0
tplot,['g15_elec_0.6MeV_uncor_flux','g15_elec_2MeV_uncor_flux','g15_elec_4MeV_uncor_flux']






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


;--------------------------------------------
;Load RBSP FBK amplitudes
;--------------------------------------------

rbsp_load_efw_fbk,probe='a',type='calibrated',/pt
rbsp_split_fbk,'a'
store_data,'*7av*',/del

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




tplot,['OMNI_HRO_1min_proton_density','fspc_2X','fspc_2L','PeakDet_2X']+'_smoothed_detrend'
tplot,['OMNI_HRO_1min_proton_density','fspc_2X','fspc_2L','PeakDet_2X']+'_smoothed'



;Compare THEMIS A FBK VLF activity to precip 

load_barrel_lc,'2X',type='rcnt'


get_data,'tha_fb_edc12',data=dd
store_data,'tha_edc12_2689Hz',dd.x,reform(dd.y[*,0])
store_data,'tha_edc12_572Hz',dd.x,reform(dd.y[*,1])
store_data,'tha_edc12_144Hz',dd.x,reform(dd.y[*,2])
store_data,'tha_edc12_36Hz',dd.x,reform(dd.y[*,3])
store_data,'tha_edc12_9Hz',dd.x,reform(dd.y[*,4])
store_data,'tha_edc12_3Hz',dd.x,reform(dd.y[*,5])
get_data,'tha_fb_scm1',data=dd
store_data,'tha_scm1_2689Hz',dd.x,reform(dd.y[*,1])
store_data,'tha_scm1_572Hz',dd.x,reform(dd.y[*,1])
store_data,'tha_scm1_144Hz',dd.x,reform(dd.y[*,2])
store_data,'tha_scm1_36Hz',dd.x,reform(dd.y[*,3])
store_data,'tha_scm1_9Hz',dd.x,reform(dd.y[*,4])
store_data,'tha_scm1_3Hz',dd.x,reform(dd.y[*,5])



rbsp_detrend,['tha_scm1_*Hz','tha_edc12_*Hz','PeakDet_2X'],60.*2.
rbsp_detrend,['tha_scm1_*Hz','tha_edc12_*Hz','PeakDet_2X']+'_smoothed',60.*80.



tplot,['OMNI_HRO_1min_proton_density','tha_edc12_*','PeakDet_2X']+'_smoothed_detrend'


tplot,'OMNI_HRO_1min_proton_density',/add
tplot,['OMNI_HRO_1min_proton_density','tha_scm1_*','PeakDet_2X']+'_smoothed_detrend'



tplot,['tha_fb_edc12','tha_edc12_572Hz','tha_scm1_572Hz','fspc_2X']



;Determine which payloads see the modulation
tplot,['g13_E2W_DTC_FLUX','g15_E2W_DTC_FLUX','PeakDet_2[L,X]'] + '_smoothed_detrend'




;THE sees chorus at earlier time 
zlim,['the_fff_32_scm2','thd_fff_32_scm2'],1d-8,1d-4,1
ylim,['the_fff_32_scm2','thd_fff_32_scm2'],100,1000,0
tplot,['OMNI_HRO_1min_AE_INDEX','OMNI_HRO_1min_proton_density_smoothed_detrend','tha_fff_32_scm2','tha_fb_scm1','the_fff_32_scm2','thd_fff_32_scm2','thd_fb_scm1']



;THD at ~15:23
power_hz = 1d-6 
binsz = 16 ;hz 
amp = 1000.*sqrt(power_hz*binsz)   ;pT
;amp = 4 pT  (typical "max" chorus amplitude seen on THD during this time)



;      FFT freqs     bin size
;      4.00000     -16.0000
;      20.0000     -16.0000
;      36.0000     -16.0000
;      52.0000     -16.0000
;      68.0000     -16.0000
;      84.0000     -16.0000
;      100.000     -16.0000
;      116.000     -16.0000
;      132.000     -16.0000
;      148.000     -16.0000
;      164.000     -16.0000
;      180.000     -16.0000
;      196.000     -16.0000
;      212.000     -16.0000
;      228.000     -16.0000
;      244.000     -40.0000
;      284.000     -64.0000
;      348.000     -64.0000
;      412.000     -64.0000
;      476.000     -96.0000
;      572.000     -128.000
;      700.000     -128.000
;      828.000     -128.000
;      956.000     -192.000
;      1148.00     -256.000
;      1404.00     -256.000
;      1660.00     -256.000
;      1916.00     -384.000
;      2300.00     -512.000
;      2812.00     -512.000
;      3324.00     -512.000;

  stop

end

