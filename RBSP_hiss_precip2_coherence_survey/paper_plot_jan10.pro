;Make plot for the paper for the Jan 10th event.


smootime = 8.
dettime = 60.


rbsp_efw_init
tplot_options,'title','paper_plot_jan10.pro'
tplot_options,'xmargin',[20.,16.] & tplot_options,'ymargin',[3,9] & tplot_options,'xticklen',0.08
tplot_options,'yticklen',0.02 & tplot_options,'xthick',2 & tplot_options,'ythick',2 & tplot_options,'labflag',-1

pre = '2'
timespan,'2014-01-10',2,/days


fntmp = 'all_coherence_plots_combined_omni_press_dyn.tplot'
tplot_restore,filenames='/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/'+'coh_vars_barrelmission'+pre+'/'+fntmp
fntmp = 'all_coherence_plots_combined.tplot'
tplot_restore,filenames='/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/'+'coh_vars_barrelmission'+pre+'/'+fntmp

datapath = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/'
folder_singlepayload = 'folder_singlepayload'
folder_coh = 'coh_vars_barrelmission2'

;Restore individual payload FSPC data
path = datapath + folder_singlepayload + '/'
fn = 'barrel_2K_fspc_fullmission.tplot' & tplot_restore,filenames=path + fn
fn = 'barrel_2L_fspc_fullmission.tplot' &  tplot_restore,filenames=path + fn
fn = 'barrel_2X_fspc_fullmission.tplot' & tplot_restore,filenames=path + fn
fn = 'barrel_2W_fspc_fullmission.tplot' & tplot_restore,filenames=path + fn
fn = 'barrel_2T_fspc_fullmission.tplot' & tplot_restore,filenames=path + fn

;Restore individual coherence spectra
path = datapath + folder_coh + '/'
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

rbsp_detrend,'fspc_2?',smootime*60. & rbsp_detrend,'fspc_2?_smoothed',60.*dettime






load_barrel_lc,'2X',type='rcnt'

load_barrel_lc,'2X',type='sspc'






;Load OMNI SW data
t0tmp = time_double('2014-01-10/00:00')
t1tmp = time_double('2014-01-13/00:00')
plot_omni_quantities,t0avg=t0tmp,t1avg=t1tmp

get_data,'OMNI_HRO_1min_BX_GSE',x,bx
get_data,'OMNI_HRO_1min_BX_GSE',x,by
get_data,'OMNI_HRO_1min_BX_GSE',x,bz
store_data,'OMNI_bmag',x,sqrt(bx^2+by^2+bz^2)

rbsp_detrend,'OMNI_HRO_1min_proton_density',smootime*60.
rbsp_detrend,'OMNI_HRO_1min_proton_density_smoothed',dettime*60.

;load Wind particle data
path = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip/wind/barrel_mission2/'
fn = 'wi_ems_3dp_20131225000000_20140214235958.cdf'
cdf2tplot,files=path+fn
copy_data,'E_DENS','wi_dens_ems_3dp'
fn = 'wi_k0s_3dp_20131225000105_20140214235952.cdf'
cdf2tplot,files=path+fn
copy_data,'elect_density','wi_dens_k0s_3dp'
fn = 'wi_k0s_swe_20131225000105_20140214235829.cdf'
cdf2tplot,files=path+fn
copy_data,'Np','wi_dens_k0s_swe_proton'
fn = 'wi_pms_3dp_20131225000002_20140215000000.cdf'
cdf2tplot,files=path+fn
copy_data,'P_DENS','wi_dens_pms_3dp_proton'

split_vec,'wi_swe_V_GSE'
store_data,['P_DENS','V_GSE','Np','elect_density','SC_pos_gse'],/delete

;Apply the timeshift to Wind data
get_data,'wi_dens_ems_3dp',data=d & store_data,'wi_dens_ems_3dp_tshift',data={x:d.x+(50.*60.),y:d.y}
get_data,'wi_dens_k0s_3dp',data=d & store_data,'wi_dens_k0s_3dp_tshift',data={x:d.x+(50.*60.),y:d.y}
get_data,'wi_dens_k0s_swe_proton',data=d & store_data,'wi_dens_k0s_swe_proton_tshift',data={x:d.x+(50.*60.),y:d.y}
get_data,'wi_dens_pms_3dp_proton',data=d & store_data,'wi_dens_pms_3dp_proton_tshift',data={x:d.x+(50.*60.),y:d.y}

rbsp_detrend,['wi_dens_ems_3dp_tshift','wi_dens_k0s_3dp_tshift','wi_dens_k0s_swe_proton_tshift','wi_dens_pms_3dp_proton_tshift'],60.*smootime
rbsp_detrend,['wi_dens_ems_3dp_tshift','wi_dens_k0s_3dp_tshift','wi_dens_k0s_swe_proton_tshift','wi_dens_pms_3dp_proton_tshift']+'_smoothed',60.*dettime

;compare to OMNI to check timeshift
ylim,'OMNI_HRO_1min_proton_density_smoothed',1,6
ylim,'wi_dens_ems_3dp_tshift_smoothed',35,40
store_data,'denscomb',data=['wi_dens_k0s_swe_proton_tshift','OMNI_HRO_1min_proton_density_smoothed']
options,'denscomb','colors',[0,250]
;tplot,'denscomb'



;LOAD GOES DATA


;G14 data from Sam Califf
path = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/Analysis_major_events_campaign2/Jan10/'
tplot_restore,filename=path + 'G14_bfield.tplot'
get_data,'G14_bmag',t10,d10
path = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/Analysis_major_events_campaign2/Jan11/'
tplot_restore,filename=path + 'G14_bfield.tplot'
get_data,'G14_bmag',t11,d11

store_data,'G14_bmag',[t10,t11],[d10,d11]

rbsp_detrend,'G14_bmag',60.*smootime
rbsp_detrend,'G14_bmag_smoothed',60.*dettime

path = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/goes/'
fn = 'goes13_eps-mageds_1min_20140101000000_20140214114500.cdf' & cdf2tplot,path+fn,prefix='g13_'
fn = 'goes15_eps-mageds_1min_20140101000000_20140214114500.cdf' & cdf2tplot,path+fn,prefix='g15_'
tplot,['g1?_dtc_cor_eflux','g1?_dtc_cor_eflux_t_stack1']


split_vec,'g1?_dtc_cor_eflux'
;split_vec,'g1?_dtc_cor_eflux_t_stack1'
rbsp_detrend,'g1?_dtc_cor_eflux_?',60.*smootime
rbsp_detrend,'g1?_dtc_cor_eflux_?_smoothed',60.*dettime

;tplot,'g15_dtc_cor_eflux_?_detrend'





;---------------------------------------------------
;Plot LANL sat observations
;---------------------------------------------------


pp = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/Analysis_major_events_campaign2/Jan10/'

tplot_restore,filenames=pp+'lanl_sat_1991-080_20140110.tplot'
copy_data,'1991-080_avg_flux_sopa_esp_e','1991-080_avg_flux_sopa_esp_e_jan10'
tplot_restore,filenames=pp+'lanl_sat_1994-084_20140110.tplot'
copy_data,'1994-084_avg_flux_sopa_esp_e','1994-084_avg_flux_sopa_esp_e_jan10'
tplot_restore,filenames=pp+'lanl_sat_LANL-01A_20140110.tplot'
copy_data,'LANL-01A_avg_flux_sopa_esp_e','LANL-01A_avg_flux_sopa_esp_e_jan10'
tplot_restore,filenames=pp+'lanl_sat_LANL-02A_20140110.tplot'
copy_data,'LANL-02A_avg_flux_sopa_esp_e','LANL-02A_avg_flux_sopa_esp_e_jan10'
tplot_restore,filenames=pp+'lanl_sat_LANL-04A_20140110.tplot'
copy_data,'LANL-04A_avg_flux_sopa_esp_e','LANL-04A_avg_flux_sopa_esp_e_jan10'
tplot_restore,filenames=pp+'lanl_sat_LANL-97A_20140110.tplot'
copy_data,'LANL-97A_avg_flux_sopa_esp_e','LANL-97A_avg_flux_sopa_esp_e_jan10'

pp = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/Analysis_major_events_campaign2/Jan11/'

tplot_restore,filenames=pp+'lanl_sat_1991-080_20140111.tplot'
copy_data,'1991-080_avg_flux_sopa_esp_e','1991-080_avg_flux_sopa_esp_e_jan11'
tplot_restore,filenames=pp+'lanl_sat_1994-084_20140111.tplot'
copy_data,'1994-084_avg_flux_sopa_esp_e','1994-084_avg_flux_sopa_esp_e_jan11'
tplot_restore,filenames=pp+'lanl_sat_LANL-01A_20140111.tplot'
copy_data,'LANL-01A_avg_flux_sopa_esp_e','LANL-01A_avg_flux_sopa_esp_e_jan11'
tplot_restore,filenames=pp+'lanl_sat_LANL-02A_20140111.tplot'
copy_data,'LANL-02A_avg_flux_sopa_esp_e','LANL-02A_avg_flux_sopa_esp_e_jan11'
tplot_restore,filenames=pp+'lanl_sat_LANL-04A_20140111.tplot'
copy_data,'LANL-04A_avg_flux_sopa_esp_e','LANL-04A_avg_flux_sopa_esp_e_jan11'
tplot_restore,filenames=pp+'lanl_sat_LANL-97A_20140111.tplot'
copy_data,'LANL-97A_avg_flux_sopa_esp_e','LANL-97A_avg_flux_sopa_esp_e_jan11'

get_data,'1991-080_avg_flux_sopa_esp_e_jan10',data=d1 & get_data,'1991-080_avg_flux_sopa_esp_e_jan11',data=d2
store_data,'1991-080_avg_flux_sopa_esp_e',data={x:[d1.x,d2.x],y:[d1.y,d2.y]}
get_data,'1994-084_avg_flux_sopa_esp_e_jan10',data=d1 & get_data,'1994-084_avg_flux_sopa_esp_e_jan11',data=d2
store_data,'1994-084_avg_flux_sopa_esp_e',data={x:[d1.x,d2.x],y:[d1.y,d2.y]}
get_data,'LANL-01A_avg_flux_sopa_esp_e_jan10',data=d1 & get_data,'LANL-01A_avg_flux_sopa_esp_e_jan11',data=d2
store_data,'LANL-01A_avg_flux_sopa_esp_e',data={x:[d1.x,d2.x],y:[d1.y,d2.y]}
get_data,'LANL-02A_avg_flux_sopa_esp_e_jan10',data=d1 & get_data,'LANL-02A_avg_flux_sopa_esp_e_jan11',data=d2
store_data,'LANL-02A_avg_flux_sopa_esp_e',data={x:[d1.x,d2.x],y:[d1.y,d2.y]}
get_data,'LANL-04A_avg_flux_sopa_esp_e_jan10',data=d1 & get_data,'LANL-04A_avg_flux_sopa_esp_e_jan11',data=d2
store_data,'LANL-04A_avg_flux_sopa_esp_e',data={x:[d1.x,d2.x],y:[d1.y,d2.y]}
get_data,'LANL-97A_avg_flux_sopa_esp_e_jan10',data=d1 & get_data,'LANL-97A_avg_flux_sopa_esp_e_jan11',data=d2
store_data,'LANL-97A_avg_flux_sopa_esp_e',data={x:[d1.x,d2.x],y:[d1.y,d2.y]}

;tplot,['1991-080_avg_flux_sopa_esp_e','1994-084_avg_flux_sopa_esp_e','LANL-01A_avg_flux_sopa_esp_e','LANL-02A_avg_flux_sopa_esp_e','LANL-04A_avg_flux_sopa_esp_e','LANL-97A_avg_flux_sopa_esp_e']

rbsp_detrend,'*avg_flux_sopa_esp_e',60.*smootime
rbsp_detrend,'*avg_flux_sopa_esp_e_smoothed',60.*dettime


split_vec,'1991-080_avg_flux_sopa_esp_e'
split_vec,'1994-084_avg_flux_sopa_esp_e'
split_vec,'LANL-01A_avg_flux_sopa_esp_e'
split_vec,'LANL-02A_avg_flux_sopa_esp_e'
split_vec,'LANL-04A_avg_flux_sopa_esp_e'
split_vec,'LANL-97A_avg_flux_sopa_esp_e'


split_vec,'1991-080_avg_flux_sopa_esp_e_smoothed_detrend'
split_vec,'1994-084_avg_flux_sopa_esp_e_smoothed_detrend'
split_vec,'LANL-01A_avg_flux_sopa_esp_e_smoothed_detrend'
split_vec,'LANL-02A_avg_flux_sopa_esp_e_smoothed_detrend'
split_vec,'LANL-04A_avg_flux_sopa_esp_e_smoothed_detrend'
split_vec,'LANL-97A_avg_flux_sopa_esp_e_smoothed_detrend'








;--------------------------------------------------------------
;Load RBSP FFT data
;--------------------------------------------------------------
path = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/Analysis_major_events_campaign2/Jan10/'

;Load density and Efield
fn = 'rbspa_efw-l3_20140110_v01.cdf' & cdf2tplot,path+fn
copy_data,'density','rbspa_density10'
copy_data,'efield_inertial_frame_mgse','efield_inertial_frame_mgse10'
fn = 'rbspa_efw-l3_20140111_v01.cdf' & cdf2tplot,path+fn
copy_data,'density','rbspa_density11'
copy_data,'efield_inertial_frame_mgse','efield_inertial_frame_mgse11'

get_data,'rbspa_density10',data=d10
get_data,'rbspa_density11',data=d11
store_data,'rbspa_density',[d10.x,d11.x],[d10.y,d11.y]
get_data,'efield_inertial_frame_mgse10',data=d10
get_data,'efield_inertial_frame_mgse11',data=d11
store_data,'rbspa_efield_inertial_frame_mgse',[d10.x,d11.x],[d10.y,d11.y]


fn = 'rbspb_efw-l3_20140110_v01.cdf' & cdf2tplot,path+fn
copy_data,'density','rbspb_density10'
copy_data,'efield_inertial_frame_mgse','efield_inertial_frame_mgse10'
fn = 'rbspb_efw-l3_20140111_v01.cdf' & cdf2tplot,path+fn
copy_data,'density','rbspb_density11'
copy_data,'efield_inertial_frame_mgse','efield_inertial_frame_mgse11'

get_data,'rbspb_density10',data=d10
get_data,'rbspb_density11',data=d11
store_data,'rbspb_density',[d10.x,d11.x],[d10.y,d11.y]
get_data,'efield_inertial_frame_mgse10',data=d10
get_data,'efield_inertial_frame_mgse11',data=d11
store_data,'rbspb_efield_inertial_frame_mgse',[d10.x,d11.x],[d10.y,d11.y]



rbsp_detrend,'rbsp?_efield_inertial_frame_mgse',60.*smootime
rbsp_detrend,'rbsp?_efield_inertial_frame_mgse_smoothed',60.*dettime

rbsp_detrend,'rbsp?_density',60.*smootime
rbsp_detrend,'rbsp?_density_smoothed',60.*dettime
;rbsp_detrend,'rbsp?_density_smoothed',60.*40.

tlimit,'2014-01-10/19:30','2014-01-11/02:30'
tplot,['omni_press_dyn_smoothed_detrend','rbsp?_density_smoothed_detrend']



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



;load spec data for RBSPa on the 10th and 11th
fn = 'rbspa_efw-l2_spec_20140110_v01.cdf' & cdf2tplot,path+fn
copy_data,'spec64_scmu','rbspa_spec64_scmu10'
copy_data,'spec64_scmv','rbspa_spec64_scmv10'
copy_data,'spec64_scmw','rbspa_spec64_scmw10'
fn = 'rbspa_efw-l2_spec_20140111_v01.cdf' & cdf2tplot,path+fn
copy_data,'spec64_scmu','rbspa_spec64_scmu11'
copy_data,'spec64_scmv','rbspa_spec64_scmv11'
copy_data,'spec64_scmw','rbspa_spec64_scmw11'
get_data,'rbspa_spec64_scmu10',data=d1 & get_data,'rbspa_spec64_scmu11',data=d2
store_data,'rbspa_spec64_scmu',data={x:[d1.x,d2.x],y:[d1.y,d2.y],v:d1.v}
get_data,'rbspa_spec64_scmv10',data=d1 & get_data,'rbspa_spec64_scmv11',data=d2
store_data,'rbspa_spec64_scmv',data={x:[d1.x,d2.x],y:[d1.y,d2.y],v:d1.v}
get_data,'rbspa_spec64_scmw10',data=d1 & get_data,'rbspa_spec64_scmw11',data=d2
store_data,'rbspa_spec64_scmw',data={x:[d1.x,d2.x],y:[d1.y,d2.y],v:d1.v}
;load spec data for RBSPb on the 10th and 11th
fn = 'rbspb_efw-l2_spec_20140110_v01.cdf' & cdf2tplot,path+fn
copy_data,'spec64_scmu','rbspb_spec64_scmu10'
copy_data,'spec64_scmv','rbspb_spec64_scmv10'
copy_data,'spec64_scmw','rbspb_spec64_scmw10'
fn = 'rbspb_efw-l2_spec_20140111_v01.cdf' & cdf2tplot,path+fn
copy_data,'spec64_scmu','rbspb_spec64_scmu11'
copy_data,'spec64_scmv','rbspb_spec64_scmv11'
copy_data,'spec64_scmw','rbspb_spec64_scmw11'
get_data,'rbspb_spec64_scmu10',data=d1 & get_data,'rbspb_spec64_scmu11',data=d2
store_data,'rbspb_spec64_scmu',data={x:[d1.x,d2.x],y:[d1.y,d2.y],v:d1.v}
get_data,'rbspb_spec64_scmv10',data=d1 & get_data,'rbspb_spec64_scmv11',data=d2
store_data,'rbspb_spec64_scmv',data={x:[d1.x,d2.x],y:[d1.y,d2.y],v:d1.v}
get_data,'rbspb_spec64_scmw10',data=d1 & get_data,'rbspb_spec64_scmw11',data=d2
store_data,'rbspb_spec64_scmw',data={x:[d1.x,d2.x],y:[d1.y,d2.y],v:d1.v}



trange = timerange()
fcals = rbsp_efw_get_gain_results()
fbinsL = fcals.cal_spec.freq_spec64L
fbinsH = fcals.cal_spec.freq_spec64H
bandw = fbinsH - fbinsL


get_data,'rbspa_spec64_scmu',data=bu2
get_data,'rbspa_spec64_scmv',data=bv2
get_data,'rbspa_spec64_scmw',data=bw2
bu2.y[*,0:5] = 0. & bv2.y[*,0:5] = 0. & bw2.y[*,0:5] = 0.
bu2.y[*,45:63] = 0. & bv2.y[*,45:63] = 0. & bw2.y[*,45:63] = 0.
nelem = n_elements(bu2.x)
bt = fltarr(nelem)
;Add up amplitude in all 64 bins and multiply each bin by a bandwidth
ball = bu2.y + bv2.y + bw2.y
for j=0L,nelem-1 do bt[j] = sqrt(total(ball[j,*]*bandw))  ;RMS method (Malaspina's method)
store_data,'Bfield_hissinta',data={x:bu2.x,y:bt}
tplot,'Bfield_hissinta'



get_data,'rbspb_spec64_scmu',data=bu2
get_data,'rbspb_spec64_scmv',data=bv2
get_data,'rbspb_spec64_scmw',data=bw2
bu2.y[*,0:5] = 0. & bv2.y[*,0:5] = 0. & bw2.y[*,0:5] = 0.
bu2.y[*,45:63] = 0. & bv2.y[*,45:63] = 0. & bw2.y[*,45:63] = 0.
nelem = n_elements(bu2.x)
bt = fltarr(nelem)
;Add up amplitude in all 64 bins and multiply each bin by a bandwidth
ball = bu2.y + bv2.y + bw2.y
for j=0L,nelem-1 do bt[j] = sqrt(total(ball[j,*]*bandw))  ;RMS method (Malaspina's method)
store_data,'Bfield_hissintb',data={x:bu2.x,y:bt}
tplot,'Bfield_hissintb'


rbsp_detrend,'Bfield_hissint?',60.*smootime
rbsp_detrend,'Bfield_hissint?_smoothed',60.*dettime
options,'spec64_scm','spec',1
zlim,'rbsp?_spec64_scm?',1d-9,1d-5,1
ylim,'rbsp?_spec64_scmw',30,1000,1
ylim,'fspc_2W_smoothed',35,55
ylim,'fspc_2K_smoothed',30,80
ylim,'fspc_2X_smoothed',30,60


;;Try to detrend the magnetic field data...tricky..
;rbsp_detrend,'rbsp?_emfisis_l3_4sec_gsm_Magnitude',60.*80.
;dif_data,'rbspa_emfisis_l3_4sec_gsm_Magnitude_smoothed','rbspa_emfisis_l3_4sec_gsm_Magnitude',newname='rbspa_mag_diff'
;dif_data,'rbspb_emfisis_l3_4sec_gsm_Magnitude_smoothed','rbspb_emfisis_l3_4sec_gsm_Magnitude',newname='rbspb_mag_diff'


;rbsp_detrend,'rbsp?_mag_diff',60.*2.
;ylim,'rbsp?_mag_diff_smoothed',-10,30
;tplot,'rbsp?_mag_diff_smoothed'

rbsp_detrend,'rbsp?_density',60.*smootime
rbsp_detrend,'rbsp?_density_smoothed',60.*dettime
ylim,'rbspa_density_smoothed_detrend',0,0;-50,30
ylim,'rbspb_density_smoothed_detrend',0,0;-50,50
ylim,'rbsp?_emfisis_l3_4sec_gsm_Magnitude_smoothed_detrend',-20,20
ylim,'rbsp?_emfisis_l3_4sec_gsm_Magnitude_smoothed',50,250
ylim,'rbsp?_emfisis_l3_4sec_gsm_Magnitude',150,200
ylim,'rbsp?_mag_diff_smoothed',-2,10
tplot,['Bfield_hissint?','fspc_2?_smoothed','rbsp?_density_smoothed_detrend','rbsp?_mag_diff_smoothed']



timespan,'2014-01-10',1,/days
rbsp_load_emfisis,probe='a',level='l3',coord='gsm'
get_data,'rbspa_emfisis_l3_4sec_gsm_Magnitude',data=d10
timespan,'2014-01-11',1,/days
rbsp_load_emfisis,probe='a',level='l3',coord='gsm'
get_data,'rbspa_emfisis_l3_4sec_gsm_Magnitude',data=d11
store_data,'rbspa_emfisis_l3_4sec_gsm_Magnitude',[d10.x,d11.x],[d10.y,d11.y]

timespan,'2014-01-10',1,/days
rbsp_load_emfisis,probe='b',level='l3',coord='gsm'
get_data,'rbspb_emfisis_l3_4sec_gsm_Magnitude',data=d10
timespan,'2014-01-11',1,/days
rbsp_load_emfisis,probe='b',level='l3',coord='gsm'
get_data,'rbspb_emfisis_l3_4sec_gsm_Magnitude',data=d11
store_data,'rbspb_emfisis_l3_4sec_gsm_Magnitude',[d10.x,d11.x],[d10.y,d11.y]



tinterpol_mxn,'rbspa_emfisis_l3_4sec_gsm_Magnitude','Bfield_hissinta_smoothed'
tinterpol_mxn,'rbspb_emfisis_l3_4sec_gsm_Magnitude','Bfield_hissintb_smoothed'
rbsp_detrend,'rbspa_emfisis_l3_4sec_gsm_Magnitude_interp',60.*smootime
rbsp_detrend,'rbspa_emfisis_l3_4sec_gsm_Magnitude_interp_smoothed',60.*dettime
rbsp_detrend,'rbspb_emfisis_l3_4sec_gsm_Magnitude_interp',60.*smootime
rbsp_detrend,'rbspb_emfisis_l3_4sec_gsm_Magnitude_interp_smoothed',60.*dettime
tplot,['rbspa_emfisis_l3_4sec_gsm_Magnitude_interp_smoothed','rbspa_bmag_t89_diff_smoothed_detrend','Bfield_hissinta_smoothed']
tplot,['rbspb_emfisis_l3_4sec_gsm_Magnitude_interp_smoothed','rbspb_bmag_t89_diff_smoothed_detrend','Bfield_hissintb_smoothed']


;;Create a faux diffusion coefficient as Bw^2/Bo
get_data,'rbspa_emfisis_l3_4sec_gsm_Magnitude_interp_smoothed',data=boa
get_data,'Bfield_hissinta_smoothed',data=bwa

daa = (bwa.y^2)/boa.y
store_data,'rbspa_Daa_smoothed',boa.x,daa
rbsp_detrend,'rbspa_Daa_smoothed',60.*dettime

tplot,['fspc_2X_smoothed_detrend','rbspa_Daa_smoothed_detrend','rbspa_bmag_t89_diff_smoothed_detrend','rbspa_emfisis_l3_4sec_gsm_Magnitude_interp_smoothed_detrend','Bfield_hissinta_smoothed_detrend']
tplot,['rbspa_emfisis_l3_4sec_gsm_Magnitude_interp_smoothed_detrend','rbspa_mag_mgse_t89_dif_smoothed_detrend_bmag_interp']


;Faux diffusion coeff from Mourenas14 eqn 1.
get_data,'rbspa_emfisis_l3_4sec_gsm_Magnitude_interp_smoothed',data=boa
get_data,'Bfield_hissinta_smoothed',data=bwa

tinterpol_mxn,'rbspa_density_smoothed','Bfield_hissinta_smoothed'
tplot,['rbspa_density_smoothed_interp','Bfield_hissinta_smoothed','rbspa_emfisis_l3_4sec_gsm_Magnitude_interp_smoothed']
get_data,'rbspa_density_smoothed_interp',data=dens


daa = (bwa.y^2)*(boa.y^(4/3.))/dens.y^(28./9.)
store_data,'rbspa_Daa2_smoothed',boa.x,daa
rbsp_detrend,'rbspa_Daa2_smoothed',60.*dettime
tplot,['rbspa_Daa2_smoothed_detrend','rbspa_Daa_smoothed_detrend']
tplot,['fspc_2X_smoothed_detrend','rbspa_Daa2_smoothed_detrend','rbspa_bmag_t89_diff_smoothed_detrend','rbspa_emfisis_l3_4sec_gsm_Magnitude_interp_smoothed_detrend','Bfield_hissinta_smoothed_detrend']



get_data,'rbspb_emfisis_l3_4sec_gsm_Magnitude_interp_smoothed',data=boa
get_data,'Bfield_hissintb_smoothed',data=bwa

tinterpol_mxn,'rbspb_density_smoothed','Bfield_hissintb_smoothed'
tplot,['rbspb_density_smoothed_interp','Bfield_hissintb_smoothed','rbspb_emfisis_l3_4sec_gsm_Magnitude_interp_smoothed']
get_data,'rbspb_density_smoothed_interp',data=dens


daa = (bwa.y^2)*(boa.y^(4/3.))/dens.y^(28./9.)
store_data,'rbspb_Daa2_smoothed',boa.x,daa
rbsp_detrend,'rbspb_Daa2_smoothed',60.*dettime
tplot,['rbspb_Daa2_smoothed_detrend','rbspb_Daa_smoothed_detrend']
tplot,['fspc_2X_smoothed_detrend','rbspb_Daa2_smoothed_detrend','rbspb_bmag_t89_diff_smoothed_detrend','rbspb_emfisis_l3_4sec_gsm_Magnitude_interp_smoothed_detrend','Bfield_hissintb_smoothed_detrend']



;-----------------------------------------------------------
;Load THEMIS data
;-----------------------------------------------------------

;.compile /Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/IDL/read_themis_dat_spec_files.pro
;  fbins = [2689.0, 572.0, 144.20, 36.200, 9.05, 2.26] ;Hz
;  fbins = '3072 Hz','768 Hz','192 Hz','48 Hz','12 Hz', '3 Hz'

thm_load_fbk,probe='a'

split_vec,'tha_fb_scm1'
get_data,'tha_fb_scm1_0',data=d & store_data,'tha_fb_scm1_0pT',d.x,1000.*d.y & options,'tha_fb_scm1_0pT','ytitle','THA FBK [pT]!Cscm1 2689Hz'
get_data,'tha_fb_scm1_1',data=d & store_data,'tha_fb_scm1_1pT',d.x,1000.*d.y & options,'tha_fb_scm1_1pT','ytitle','THA FBK [pT]!Cscm1 572Hz'
get_data,'tha_fb_scm1_2',data=d & store_data,'tha_fb_scm1_2pT',d.x,1000.*d.y & options,'tha_fb_scm1_2pT','ytitle','THA FBK [pT]!Cscm1 144Hz'
get_data,'tha_fb_scm1_3',data=d & store_data,'tha_fb_scm1_3pT',d.x,1000.*d.y & options,'tha_fb_scm1_3pT','ytitle','THA FBK [pT]!Cscm1 36Hz'
get_data,'tha_fb_scm1_4',data=d & store_data,'tha_fb_scm1_4pT',d.x,1000.*d.y & options,'tha_fb_scm1_4pT','ytitle','THA FBK [pT]!Cscm1 9Hz'
get_data,'tha_fb_scm1_5',data=d & store_data,'tha_fb_scm1_5pT',d.x,1000.*d.y & options,'tha_fb_scm1_5pT','ytitle','THA FBK [pT]!Cscm1 2Hz'

tplot,'tha_fb_scm1_?pT'

split_vec,'tha_fb_edc12'
get_data,'tha_fb_edc12_0',data=d & store_data,'tha_fb_edc12_0mV_m',d.x,d.y & options,'tha_fb_edc12_0mV_m','ytitle','THA FBK [mV/m]!Cedc12 2689Hz'
get_data,'tha_fb_edc12_1',data=d & store_data,'tha_fb_edc12_1mV_m',d.x,d.y & options,'tha_fb_edc12_1mV_m','ytitle','THA FBK [mV/m]!Cedc12 572Hz'
get_data,'tha_fb_edc12_2',data=d & store_data,'tha_fb_edc12_2mV_m',d.x,d.y & options,'tha_fb_edc12_2mV_m','ytitle','THA FBK [mV/m]!Cedc12 144Hz'
get_data,'tha_fb_edc12_3',data=d & store_data,'tha_fb_edc12_3mV_m',d.x,d.y & options,'tha_fb_edc12_3mV_m','ytitle','THA FBK [mV/m]!Cedc12 36Hz'
get_data,'tha_fb_edc12_4',data=d & store_data,'tha_fb_edc12_4mV_m',d.x,d.y & options,'tha_fb_edc12_4mV_m','ytitle','THA FBK [mV/m]!Cedc12 9Hz'
get_data,'tha_fb_edc12_5',data=d & store_data,'tha_fb_edc12_5mV_m',d.x,d.y & options,'tha_fb_edc12_5mV_m','ytitle','THA FBK [mV/m]!Cedc12 2Hz'

;rbsp_detrend,'tha_fb_scm1_?pT',60.*.1
rbsp_detrend,'tha_fb_scm1_?pT',60.*.8
rbsp_detrend,'tha_fb_scm1_?pT_smoothed',60.*80.

ylim,'tha_fb_scm1_?pT_smoothed_detrend',0,20
ylim,'tha_fb_scm1_?mV_m_smoothed_detrend',0,10

rbsp_detrend,'fspc_2X',60.*8.
rbsp_detrend,'fspc_2X_smoothed',60.*80.

rbsp_detrend,'tha_fb_scm1_?pT',60.*8.   ;smooth over spin period
rbsp_detrend,'tha_fb_scm1_?pT_smoothed',60.*80.

tplot,'tha_fb_scm1_?pT_smoothed_detrend'

div_data,'tha_fb_scm1_3pT','tha_fb_scm1_2pT'
div_data,'tha_fb_scm1_3pT_smoothed','tha_fb_scm1_2pT_smoothed'

ylim,'tha_fb_scm1_3pT_smoothed/tha_fb_scm1_2pT_smoothed',0,10
ylim,'tha_fb_scm1_3pT/tha_fb_scm1_2pT',0,10


tplot,['OMNI_HRO_1min_proton_density','fspc_2X_smoothed_detrend','tha_fb_scm1_1pT_smoothed','tha_fb_scm1_2pT_smoothed','tha_fb_scm1_3pT_smoothed','tha_fb_scm1_3pT_smoothed/tha_fb_scm1_2pT_smoothed','g15_dtc_cor_eflux','g15_dtc_cor_eflux_t_stack1']
tplot,['OMNI_HRO_1min_proton_density','fspc_2X_smoothed_detrend','tha_fb_scm1_1pT','tha_fb_scm1_2pT','tha_fb_scm1_3pT','tha_fb_scm1_3pT/tha_fb_scm1_2pT','g15_dtc_cor_eflux','g15_dtc_cor_eflux_t_stack1']
tplot,['OMNI_HRO_1min_proton_density_detrend','PeakDet_2X_smoothed_detrend','tha_fb_scm1_2pT_smoothed_detrend','g15_dtc_cor_eflux','g15_dtc_cor_eflux_t_stack1']





thm_load_efi,probe='a'

;pro thm_load_efi, probe = probe, datatype = datatype, trange = trange, $
;                  level = level, verbose = verbose, downloadonly = downloadonly, $
;                  no_download = no_download, type = type, coord = coord, varformat = varformat, $
;                  cdf_data = cdf_data, get_support_data = get_support_data, $
;                  varnames = varnames, valid_names = valid_names, files = files, $
;                  relpathnames_all = relpathnames_all, $
;                  suffix = suffix, progobj = progobj, test = test, $
;                  no_time_clip = no_time_clip, $
;                  use_eclipse_corrections = use_eclipse_corrections, $
;                  onthefly_edc_offset = onthefly_edc_offset, $
;                  _extra = _extra







ptmp = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/Analysis_major_events_campaign2/Jan10/'


;;Read THA FBK data (saved to a .dat file (e.g. tha_l2_fbk_20140110_v01.cdf) from Autoplot...cdf2tplot won't work for these)
;fn = 'tha_l2_fbk_spec_20140110_edc12.dat'
;read_themis_dat_spec_files,ptmp+fn,tvarname='tha_l2_fbk_spec_edc12_10'
;fn = 'tha_l2_fbk_spec_20140111_edc12.dat'
;read_themis_dat_spec_files,ptmp+fn,tvarname='tha_l2_fbk_spec_edc12_11'
;fn = 'tha_l2_fbk_spec_20140112_edc12.dat'
;read_themis_dat_spec_files,ptmp+fn,tvarname='tha_l2_fbk_spec_edc12_12'
;get_data,'tha_l2_fbk_spec_edc12_10',data=d1
;get_data,'tha_l2_fbk_spec_edc12_11',data=d2
;get_data,'tha_l2_fbk_spec_edc12_12',data=d3
;store_data,'tha_l2_fbk_spec_edc12',[d1.x,d2.x,d3.x],[d1.y,d2.y,d3.y],d1.v

;zlim,'tha_l2_fbk_spec_edc12',0.001,1,1
;tplot,'tha_l2_fbk_spec_edc12'
;get_data,'tha_l2_fbk_spec_edc12',data=dd
;store_data,'tha_l2_fbk_spec_edc12_2689Hz',dd.x,dd.y[*,0]
;store_data,'tha_l2_fbk_spec_edc12_572Hz',dd.x,dd.y[*,1]
;store_data,'tha_l2_fbk_spec_edc12_144Hz',dd.x,dd.y[*,2]
;store_data,'tha_l2_fbk_spec_edc12_36Hz',dd.x,dd.y[*,3]
;store_data,'tha_l2_fbk_spec_edc12_9Hz',dd.x,dd.y[*,4]
;store_data,'tha_l2_fbk_spec_edc12_2Hz',dd.x,dd.y[*,5]


;fn = 'tha_l2_fbk_spec_20140110_scm1.dat'
;read_themis_dat_spec_files,ptmp+fn,tvarname='tha_l2_fbk_spec_scm1_10'
;fn = 'tha_l2_fbk_spec_20140111_scm1.dat'
;read_themis_dat_spec_files,ptmp+fn,tvarname='tha_l2_fbk_spec_scm1_11'
;fn = 'tha_l2_fbk_spec_20140112_scm1.dat'
;read_themis_dat_spec_files,ptmp+fn,tvarname='tha_l2_fbk_spec_scm1_12'
;get_data,'tha_l2_fbk_spec_scm1_10',data=d1
;get_data,'tha_l2_fbk_spec_scm1_11',data=d2
;get_data,'tha_l2_fbk_spec_scm1_12',data=d3
;store_data,'tha_l2_fbk_spec_scm1',[d1.x,d2.x,d3.x],[d1.y,d2.y,d3.y],d1.v

;zlim,'tha_l2_fbk_spec_scm1',0.001,1,1
;tplot,'tha_l2_fbk_spec_scm1'
;get_data,'tha_l2_fbk_spec_scm1',data=dd
;store_data,'tha_l2_fbk_spec_scm1_2689Hz',dd.x,dd.y[*,0]
;store_data,'tha_l2_fbk_spec_scm1_572Hz',dd.x,dd.y[*,1]
;store_data,'tha_l2_fbk_spec_scm1_144Hz',dd.x,dd.y[*,2]
;store_data,'tha_l2_fbk_spec_scm1_36Hz',dd.x,dd.y[*,3]
;store_data,'tha_l2_fbk_spec_scm1_9Hz',dd.x,dd.y[*,4]
;store_data,'tha_l2_fbk_spec_scm1_2Hz',dd.x,dd.y[*,5]

;store_data,'tha_l2_fbk_spec_scm1_combHz',dd.x,dd.y[*,1]+dd.y[*,2]



;tplot,['tha_l2_fbk_spec_edc12_2689Hz','tha_l2_fbk_spec_edc12_572Hz','tha_l2_fbk_spec_scm1_572Hz']
;rbsp_detrend,['tha_l2_fbk_spec_edc12_???Hz','tha_l2_fbk_spec_scm1_???Hz','tha_l2_fbk_spec_scm1_combHz'],60.*smootime
;rbsp_detrend,['tha_l2_fbk_spec_edc12_???Hz','tha_l2_fbk_spec_scm1_???Hz','tha_l2_fbk_spec_scm1_combHz']+'_smoothed',60.*dettime

;tplot,['tha_l2_fbk_spec_edc12_572Hz','tha_l2_fbk_spec_scm1_572Hz']+'_smoothed_detrend'


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


;-----------------------------------------------------------
;Plot showing general correspondence with solar wind
;-----------------------------------------------------------



timespan,'2014-01-10/14:00',15,/hours
ylim,'OMNI_HRO_1min_flow_speed',350,450
ylim,'denscomb',1,7
ylim,'OMNI_bmag',0,10

tplot,['OMNI_HRO_1min_flow_speed','denscomb','OMNI_bmag','fspc_2L_smoothed','g13_dtc_cor_eflux_0']



;-----------------------------------------------------------
;Plot scale size of various quantities
;-----------------------------------------------------------

tplot,[826,827,879]
;Good conjunction b/t RBSPb and THA from ~20-22:30 UT. Hiss is pretty different b/t them.
tplot,['Bfield_hissinta','Bfield_hissintb','tha_l2_fbk_spec_edc12_572Hz']

rbsp_detrend,'tha_fgs_btotal',60.*5.
rbsp_detrend,'tha_fgs_btotal_smoothed',60.*30.

tplot,['tha_fgs_btotal_smoothed_detrend','rbsp?_bmag_t89_diff_smoothed_detrend']

;------------------------------------------------------------
;Plot showing extensive nature of e- populations.
;Overall, these seem to be driven by a substorm injection with subsequent
;population drift
;------------------------------------------------------------


timespan,'2014-01-10/12:00',15,/hours
ylim,'*avg_flux_sopa_esp_e_0',1d3,1d5,0
tplot,['OMNI_HRO_1min_proton_density_smoothed',$
'LANL-01A_avg_flux_sopa_esp_e_0',$
'1991-080_avg_flux_sopa_esp_e_0',$
'g15_dtc_cor_eflux_0',$
'fspc_'+pre+'L_smoothed',$
'1994-084_avg_flux_sopa_esp_e_0',$
'g13_dtc_cor_eflux_0',$
'LANL-97A_avg_flux_sopa_esp_e_0',$
'LANL-04A_avg_flux_sopa_esp_e_0',$
'LANL-02A_avg_flux_sopa_esp_e_0']



;-----------------------------------------------------
;Look at detrended data to see effect of SW pressure fluctuations
;-----------------------------------------------------

timespan,'2014-01-10/19:30',5,/hours
ylim,'LANL-01A_avg_flux_sopa_esp_e_smoothed_detrend_0',-2000,2000
ylim,'1991-080_avg_flux_sopa_esp_e_smoothed_detrend_0',-5000,8000
ylim,'1991-080_avg_flux_sopa_esp_e_smoothed_detrend_0',3000,7000
ylim,'LANL-02A_avg_flux_sopa_esp_e_smoothed_detrend_0',-2000,2000
ylim,'g15_dtc_cor_eflux_0_smoothed_detrend',-3000,3000
ylim,'OMNI_HRO_1min_proton_density_smoothed',1.5,6
ylim,'fspc_'+pre+'L_smoothed',20,70
tplot,['OMNI_HRO_1min_proton_density_smoothed_detrend',$
'LANL-01A_avg_flux_sopa_esp_e_smoothed_detrend_0',$
'1991-080_avg_flux_sopa_esp_e_smoothed_detrend_0',$
'g15_dtc_cor_eflux_0_smoothed_detrend',$
'fspc_'+pre+'L_smoothed_detrend',$
'fspc_'+pre+'X_smoothed_detrend',$
'1994-084_avg_flux_sopa_esp_e_smoothed_detrend_0',$
'g13_dtc_cor_eflux_0_smoothed_detrend',$
'LANL-97A_avg_flux_sopa_esp_e_smoothed_detrend_0',$
'LANL-04A_avg_flux_sopa_esp_e_smoothed_detrend_0',$
'LANL-02A_avg_flux_sopa_esp_e_smoothed_detrend_0']


tplot,['G14_bmag','G14_bmag_smoothed_detrend'],/add


ylim,'rbspa_density_smoothed_detrend',-50,50
ylim,'rbspb_density_smoothed_detrend',-50,50
ylim,'rbsp?_bmag_t89_diff_smoothed_detrend',-2,2
tplot,['OMNI_HRO_1min_proton_density_smoothed_detrend',$
'LANL-01A_avg_flux_sopa_esp_e_smoothed_detrend_0',$
'fspc_2X_smoothed_detrend',$
'rbspa_bmag_t89_diff_smoothed_detrend',$
'rbspa_sloshing_distance_km_detrend',$
'Bfield_hissinta_smoothed_detrend',$
'rbspa_density_smoothed_detrend',$
'rbspa_Daa2_smoothed_detrend',$
'tha_l2_fbk_spec_edc12_572Hz_smoothed_detrend']


;-----------------------------------------------------
;Determine scale size of fluctuations and precipitation
;-----------------------------------------------------

timespan,'2014-01-10/20:00',6,/hours
ylim,'LANL-01A_avg_flux_sopa_esp_e_smoothed_detrend_0',-2000,2000
ylim,'1991-080_avg_flux_sopa_esp_e_smoothed_detrend_0',-5000,8000
ylim,'1991-080_avg_flux_sopa_esp_e_smoothed_detrend_0',3000,7000
ylim,'LANL-02A_avg_flux_sopa_esp_e_smoothed_detrend_0',-2000,2000
ylim,'g15_dtc_cor_eflux_0_smoothed_detrend',-3000,3000
ylim,'OMNI_HRO_1min_proton_density_smoothed',1.5,6
ylim,'fspc_'+pre+'L_smoothed',20,70
ylim,'rbsp?_bmag_t89_diff_smoothed_detrend',-2,2

tplot,['OMNI_HRO_1min_proton_density_smoothed_detrend',$
'LANL-01A_avg_flux_sopa_esp_e_smoothed_detrend_0',$
'fspc_'+pre+'X_smoothed_detrend',$
'Bfield_hissinta_smoothed_detrend',$
'Bfield_hissintb_smoothed_detrend',$
'rbspb_density_smoothed_detrend',$
'rbspb_bmag_t89_diff_smoothed_detrend',$
'tha_l2_fbk_spec_scm1_???Hz_smoothed_detrend',$
'tha_fgs_btotalQ_smoothed_detrend']

;'tha_l2_fbk_spec_edc12_572Hz_smoothed_detrend',$

;tplot,['Bfield_hissint?','fspc_2?_smoothed','rbsp?_density_smoothed_detrend','rbsp?_mag_diff_smoothed']

tplot,['OMNI_HRO_1min_proton_density_smoothed_detrend',$
'LANL-01A_avg_flux_sopa_esp_e_smoothed_detrend_0',$
'fspc_'+pre+'X_smoothed_detrend',$
'rbspa_bmag_t89_diff_smoothed_detrend',$
;'tha_l2_fbk_spec_scm1_2689Hz_smoothed_detrend',$
'tha_l2_fbk_spec_scm1_???Hz_smoothed_detrend',$
'tha_fgs_btotalQ_smoothed_detrend']



;---------------------------------------------------------------------------------------
;Calculate ExB drift motion of plasma
;---------------------------------------------------------------------------------------

ptmp = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/Analysis_major_events_campaign2/Jan10/'

tplot_restore,filename=ptmp+'exb_20140110_rbspa.tplot'
copy_data,'Vx!CExB-drift!Ckm/s','rbspa_Vx!CExB-drift!Ckm/s10'
copy_data,'Bfield_for_ExB','Bfield_for_ExB10'
copy_data,'Efield_for_ExB','Efield_for_ExB10'
tplot_restore,filename=ptmp+'exb_20140111_rbspa.tplot'
copy_data,'Vx!CExB-drift!Ckm/s','rbspa_Vx!CExB-drift!Ckm/s11'
copy_data,'Bfield_for_ExB','Bfield_for_ExB11'
copy_data,'Efield_for_ExB','Efield_for_ExB11'

;combine 10 and 11 values
get_data,'rbspa_Vx!CExB-drift!Ckm/s10',data=d10
get_data,'rbspa_Vx!CExB-drift!Ckm/s11',data=d11
store_data,'rbspa_Vx!CExB-drift!Ckm/s',[d10.x,d11.x],[d10.y,d11.y]
get_data,'Bfield_for_ExB10',data=d10
get_data,'Bfield_for_ExB11',data=d11
store_data,'rbspa_Bfield_for_ExB',[d10.x,d11.x],[d10.y,d11.y]
get_data,'Efield_for_ExB10',data=d10
get_data,'Efield_for_ExB11',data=d11
store_data,'rbspa_Efield_for_ExB',[d10.x,d11.x],[d10.y,d11.y]


tplot_restore,filename=ptmp+'exb_20140110_rbspb.tplot'
copy_data,'Vx!CExB-drift!Ckm/s','rbspb_Vx!CExB-drift!Ckm/s10'
copy_data,'Bfield_for_ExB','Bfield_for_ExB10'
copy_data,'Efield_for_ExB','Efield_for_ExB10'
tplot_restore,filename=ptmp+'exb_20140111_rbspb.tplot'
copy_data,'Vx!CExB-drift!Ckm/s','rbspb_Vx!CExB-drift!Ckm/s11'
copy_data,'Bfield_for_ExB','Bfield_for_ExB11'
copy_data,'Efield_for_ExB','Efield_for_ExB11'


;combine 10 and 11 values
get_data,'rbspb_Vx!CExB-drift!Ckm/s10',data=d10
get_data,'rbspb_Vx!CExB-drift!Ckm/s11',data=d11
store_data,'rbspb_Vx!CExB-drift!Ckm/s',[d10.x,d11.x],[d10.y,d11.y]
get_data,'Bfield_for_ExB10',data=d10
get_data,'Bfield_for_ExB11',data=d11
store_data,'rbspb_Bfield_for_ExB',[d10.x,d11.x],[d10.y,d11.y]
get_data,'Efield_for_ExB10',data=d10
get_data,'Efield_for_ExB11',data=d11
store_data,'rbspb_Efield_for_ExB',[d10.x,d11.x],[d10.y,d11.y]


rbsp_detrend,'rbsp?_?field_for_ExB',60.*smootime
rbsp_detrend,'rbsp?_?field_for_ExB_smoothed',60.*dettime


options,'rbspa_Vx!CExB-drift!Ckm/s','ytitle','ExB-drift(xMGSE)!CRBSPa!C[km/s]'
options,'rbspb_Vx!CExB-drift!Ckm/s','ytitle','ExB-drift(xMGSE)!CRBSPb!C[km/s]'


rbsp_detrend,'rbsp?_Vx!CExB-drift!Ckm/s',60.*dettime
options,'rbspa_Vx!CExB-drift!Ckm/s_detrend','ytitle','ExB-drift(xMGSE)!CRBSPa!Cdetrend!C[km/s]'
options,'rbspb_Vx!CExB-drift!Ckm/s_detrend','ytitle','ExB-drift(xMGSE)!CRBSPb!Cdetrend!C[km/s]'

get_data,'rbspa_mag_mgse_t89_dif_smoothed_detrend',data=dd
store_data,'rbspa_mag_mgse_t89_dif_smoothed_detrend_bmag',dd.x,sqrt(dd.y[*,0]^2+dd.y[*,1]^2+dd.y[*,2]^2)


split_vec,'rbspa_mag_mgse_t89_dif_smoothed_detrend'
split_vec,'rbsp?_efield_inertial_frame_mgse_smoothed'
split_vec,'rbsp?_Efield_for_ExB_smoothed_detrend'
split_vec,'rbsp?_Bfield_for_ExB_smoothed_detrend'


;Model the cumulative sloshing motion.

t0z = time_double('2014-01-10/18:30')
t1z = time_double('2014-01-11/01:30')
yv = tsample('rbspa_Vx!CExB-drift!Ckm/s_detrend',[t0z,t1z],times=tms)
dt = 10.88
vals = total(-1*yv*dt,/cumulative)
store_data,'rbspa_sloshing_distance_km',tms,vals
options,'rbspa_sloshing_distance_km','ytitle','-1*radial sloshing distance!Crbspa[km]'
ylim,'rbspa_sloshing_distance_km',-100,300,0

yv = tsample('rbspb_Vx!CExB-drift!Ckm/s_detrend',[t0z,t1z],times=tms)
dt = 10.88
vals = total(-1*yv*dt,/cumulative,/nan)
store_data,'rbspb_sloshing_distance_km',tms,vals
options,'rbspb_sloshing_distance_km','ytitle','-1*radial sloshing distance!Crbspb[km]'
ylim,'rbspb_sloshing_distance_km',-200,400,0


tplot,['OMNI_HRO_1min_proton_density_smoothed_detrend','fspc_2X_smoothed_detrend','rbspa_Bfield_for_ExB_smoothed_detrend_z','rbspa_Efield_for_ExB_smoothed_detrend_y','rbspa_Vx!CExB-drift!Ckm/s_detrend','rbspa_sloshing_distance_km','rbspa_state_lshell']
tplot,['OMNI_HRO_1min_proton_density_smoothed_detrend','fspc_2X_smoothed_detrend','rbspb_Bfield_for_ExB_smoothed_detrend_z','rbspb_Efield_for_ExB_smoothed_detrend_y','rbspb_Vx!CExB-drift!Ckm/s_detrend','rbspb_sloshing_distance_km','rbspb_state_lshell']



tplot,['OMNI_HRO_1min_proton_density_smoothed_detrend',$
'fspc_2X_smoothed_detrend',$
'rbspa_bmag_t89_diff_smoothed_detrend',$
'rbspa_sloshing_distance_km',$
'rbspb_bmag_t89_diff_smoothed_detrend',$
'rbspb_sloshing_distance_km']




;Maybe the most straight forward test is b/t THA and 2X at 23 UT. This is where
;the two are on the same Lshell and this offers the most direct comparison of
;VLF waves, Bo, and precip.

tplot,['tha_fgs_btotalQ_smoothed_detrend',$
'fspc_2X_smoothed_detrend',$
'tha_l2_fbk_spec_edc12_572Hz_smoothed_detrend']



;At 22UT on RBSPa Bo = 160 nT
;dB from sloshing is about 1 nT
;RBSPa is at L=5.7

;First calculate loss cone size at L=5.7
alt = 500.   ;km
L = 5.7
;Bo_mageq = 160.  ;nT
Bo_mageq = 161.  ;nT
;Bo_mageq = 159.  ;nT

dip = dipole(L)
radius = dip.r - 6370.
boo = where(radius le alt)
boo = boo[0]
Bo_km = dip.b[boo]
Bratio = Bo_km/Bo_mageq
;Bmax = Bratio*Bo_mageq

;sin(alpha)^2 = Bo/Bmax    ;Gurnett eqn 3.4.23
alpha = asin(sqrt(1/Bratio))/!dtor
;alpha = 3.44 deg for normal Bo_mageq = 160 nT
;alpha = 3.45 deg for perturbed Bo_mageq = 161 nT








;------------------------------------------------
;Dynamic coherence
;Notes:
;--there's clearly a dynamic tshift that's not properly accounted
;for in the OMNI data. The coherence changes significantly depending on the amount
;of tshift added. For ex, tshift=3 min creates high coherence for the humps at
;~22 UT, but removes it for the prior humps at 21UT. No tshift is the opposite.
;So, I'm going to ignore the coherence here in comparison to the OMNI data and
;instead calculating it wrt LANL-01A.
;--The reason I chose LANL-01A is b/c I used this as my "stable reference" when calculating
;the cross correlation values. Here I'll use the time-shifts determined from the cc
;to align the variables properly. This will allow a proper calculation of the coherence.

;OMNI also has missing data, which removes coherence data before ~21 UT.


;;calculate the cross spectra
;window = 60.*window_minutes   ;seconds
;lag = window/lag_factor
;coherence_time = window*coherence_multiplier


t0z = '2014-01-10/15:00'
t1z = '2014-01-11/02:59'




stop
;Now run cross_correlations_wrt_BARREL_2X.pro
stop
;Now run cross_correlations_wrt_BARREL_2X.pro
stop
;Now run cross_correlations_wrt_BARREL_2X.pro
stop














;;tshift OMNI data
;ts = 60.*3.
;get_data,'OMNI_HRO_1min_proton_density_smoothed_detrend',data=ddd
;store_data,'OMNI_HRO_1min_proton_density_smoothed_detrend_ts',ddd.x+ts,ddd.y


;var1 = 'fspc_2X_smoothed_detrend'
;var2 = ['fspc_'+pre+'L_smoothed_detrend',$
;'LANL-01A_avg_flux_sopa_esp_e_smoothed_detrend_0',$
;'LANL-97A_avg_flux_sopa_esp_e_smoothed_detrend_0',$
;'OMNI_HRO_1min_proton_density_smoothed_detrend',$
;'fspc_'+pre+'K_smoothed_detrend',$
;'1994-084_avg_flux_sopa_esp_e_smoothed_detrend_0',$
;'rbspa_bmag_t89_diff_smoothed_detrend',$
;'g13_dtc_cor_eflux_0_smoothed_detrend',$
;'LANL-04A_avg_flux_sopa_esp_e_smoothed_detrend_0',$
;'rbspa_sloshing_distance_km',$
;'rbspb_bmag_t89_diff_smoothed_detrend',$
;'Bfield_hissinta_smoothed_detrend',$
;'Bfield_hissintb_smoothed_detrend',$
;'rbspa_Vx!CExB-drift!Ckm/s_detrend',$
;'rbspa_density_smoothed_detrend',$
;'tha_l2_fbk_spec_scm1_572Hz_smoothed_detrend',$
;'LANL-02A_avg_flux_sopa_esp_e_smoothed_detrend_0',$
;'rbspa_Daa2_smoothed_detrend']


;Vars I'm ignoring b/c of missing data
;var2 = 'g15_dtc_cor_eflux_0_smoothed_detrend'
;var2 = 'rbspb_density_smoothed_detrend'
;var2 = '1991-080_avg_flux_sopa_esp_e_smoothed_detrend_0'




;for i=0,n_elements(var2)-1 do cross_correlation_normalized_plot,var1,var2[i],t0z,t1z




;shift the time values by the times determined from the cross correlation to get better coherence plots.
;Time shifts relative to LANL-01A
;tshift = [50.,-36.,-67.,395.,237.,208.,108.,108.,567.,-22.,266.,323.,108.,0.,0.,0.,0.]

;Time shifts relative to 2X
;time-shifts and cc values relative to 2X
tshift = [37,34,-46,392,113,246,217,118,597,-58,253,60,537,161,-522,597,106,108]
;cc = [0.83,0.8,0.69,0.65,0.62,0.58,0.51,0.46,0.39,0.33,0.29,0.17,0.16,0.1,0.07,0.37]


;for i=0,n_elements(var2)-1 do begin $
;get_data,var2[i],data=dd & $
;store_data,var2[i]+'_ts',dd.x-tshift[i],dd.y & $
;dynamic_cross_spec_plot,var1,var2[i]+'_ts',window_minutes=50.,lag_factor=8.,coherence_multiplier=1.5,periodmin=1.,mincc=0.6 & $
;if i eq 0 then add = 0 else add = 1 & $
;tplot,'coh_'+var1+'_'+var2[i]+'_ts',add=add,trange=time_double(['2014-01-10/19:30','2014-01-11/00:30'])

for i=0,n_elements(var2)-1 do begin
    get_data,var2[i],data=dd
    store_data,var2[i]+'_ts',dd.x-tshift[i],dd.y
    dynamic_cross_spec_plot,var1,var2[i]+'_ts',window_minutes=50.,lag_factor=8.,coherence_multiplier=1.5,periodmin=1.,mincc=0.6
    if i eq 0 then add = 0 else add = 1
    tplot,'coh_'+var1+'_'+var2[i]+'_ts',add=add,trange=time_double(['2014-01-10/19:30','2014-01-11/00:30'])
endfor


ylim,'coh_'+var1+'_'+var2[*]+'_ts',10,50,1
tplot,'coh_'+var1+'_'+var2[*]+'_ts'


;for i=0,13 do ylim,'coh_'+var1+'_'+var2[i],10,70,1
;for i=0,13 do zlim,'coh_'+var1+'_'+var2[i],0.5,1


tplot,[var1,var2[6]],/add






;--------------------------------------------------------------------------
;At this point I've used LANL-01A as a reference for determining the correct time-shifts to align
;all the quantities. However, for the paper I really want to plot each quantity alongside the OMNI data.
;So, here's I'll create these plots.

t0z = '2014-01-10/19:48:30'
;t0z = '2014-01-10/20:00:00'  ;special for OMNI data
t1z = '2014-01-11/00:30'


;In order to overplot quantities with OMNI data I've normalized each of them.
;However, here I'll determine the amount to adjust the amplitude for the y-axis in the final plot.


div_data,'LANL-01A_avg_flux_sopa_esp_e_smoothed_detrend_0_N','LANL-01A_avg_flux_sopa_esp_e_smoothed_detrend_0',newname='tmpp' & get_data,'tmpp',data=d & print,median(d.y)
div_data,'OMNI_HRO_1min_proton_density_smoothed_detrend_N','OMNI_HRO_1min_proton_density_smoothed_detrend',newname='tmpp' & get_data,'tmpp',data=d & print,median(d.y)
div_data,'fspc_'+pre+'L_smoothed_detrend_N','fspc_'+pre+'L_smoothed_detrend',newname='tmpp' & get_data,'tmpp',data=d & print,median(d.y)
div_data,'fspc_'+pre+'X_smoothed_detrend_N','fspc_'+pre+'X_smoothed_detrend',newname='tmpp' & get_data,'tmpp',data=d & print,median(d.y)
div_data,'LANL-97A_avg_flux_sopa_esp_e_smoothed_detrend_0_N','LANL-97A_avg_flux_sopa_esp_e_smoothed_detrend_0',newname='tmpp' & get_data,'tmpp',data=d & print,median(d.y)
div_data,'1994-084_avg_flux_sopa_esp_e_smoothed_detrend_0_N','1994-084_avg_flux_sopa_esp_e_smoothed_detrend_0',newname='tmpp' & get_data,'tmpp',data=d & print,median(d.y)
div_data,'rbspa_bmag_t89_diff_smoothed_detrend_N','rbspa_bmag_t89_diff_smoothed_detrend',newname='tmpp' & get_data,'tmpp',data=d & print,median(d.y)
div_data,'g13_dtc_cor_eflux_0_smoothed_detrend_N','g13_dtc_cor_eflux_0_smoothed_detrend',newname='tmpp' & get_data,'tmpp',data=d & print,median(d.y)
div_data,'fspc_'+pre+'K_smoothed_detrend_N','fspc_'+pre+'K_smoothed_detrend',newname='tmpp' & get_data,'tmpp',data=d & print,median(d.y)
div_data,'LANL-04A_avg_flux_sopa_esp_e_smoothed_detrend_0_N','LANL-04A_avg_flux_sopa_esp_e_smoothed_detrend_0',newname='tmpp' & get_data,'tmpp',data=d & print,median(d.y)
div_data,'rbspa_sloshing_distance_km_N','rbspa_sloshing_distance_km',newname='tmpp' & get_data,'tmpp',data=d & print,median(d.y)
div_data,'rbspb_bmag_t89_diff_smoothed_detrend_N','rbspb_bmag_t89_diff_smoothed_detrend',newname='tmpp' & get_data,'tmpp',data=d & print,median(d.y)
div_data,'rbspa_Vx!CExB-drift!Ckm/s_detrend_N','rbspa_Vx!CExB-drift!Ckm/s_detrend',newname='tmpp' & get_data,'tmpp',data=d & print,median(d.y)
div_data,'LANL-02A_avg_flux_sopa_esp_e_smoothed_detrend_0_N','LANL-02A_avg_flux_sopa_esp_e_smoothed_detrend_0',newname='tmpp' & get_data,'tmpp',data=d & print,median(d.y)
div_data,'Bfield_hissinta_smoothed_detrend_N','Bfield_hissinta_smoothed_detrend',newname='tmpp' & get_data,'tmpp',data=d & print,median(d.y)
div_data,'rbspa_density_smoothed_detrend_N','rbspa_density_smoothed_detrend',newname='tmpp' & get_data,'tmpp',data=d & print,median(d.y)
div_data,'tha_l2_fbk_spec_scm1_572Hz_smoothed_detrend_N','tha_l2_fbk_spec_scm1_572Hz_smoothed_detrend',newname='tmpp' & get_data,'tmpp',data=d & print,median(d.y)
div_data,'Bfield_hissintb_smoothed_detrend_N','Bfield_hissintb_smoothed_detrend',newname='tmpp' & get_data,'tmpp',data=d & print,median(d.y)


ampadj = 1/[0.00068976202,2.1443220,0.116,0.272,0.000999,0.00091889572,1.3183515,0.00073078889,0.26621049,0.00095094535,0.0034624437,0.75877210,1.6272247,0.00072471393,55.524715,0.052535973,54.397731,50.276033]


get_data,'LANL-01A_avg_flux_sopa_esp_e_smoothed_detrend_0_N',data=dd & store_data,'LANL-01A_avg_flux_sopa_esp_e_smoothed_detrend_0_N_ts_aa',dd.x,dd.y*ampadj[0]
get_data,'OMNI_HRO_1min_proton_density_smoothed_detrend_N_ts',data=dd & store_data,'OMNI_HRO_1min_proton_density_smoothed_detrend_N_ts_aa',dd.x,dd.y*ampadj[1]
get_data,'fspc_'+pre+'L_smoothed_detrend_N_ts',data=dd & store_data,'fspc_'+pre+'L_smoothed_detrend_N_ts_aa',dd.x,dd.y*ampadj[2]
get_data,'fspc_'+pre+'X_smoothed_detrend_N_ts',data=dd & store_data,'fspc_'+pre+'X_smoothed_detrend_N_ts_aa',dd.x,dd.y*ampadj[3]
get_data,'LANL-97A_avg_flux_sopa_esp_e_smoothed_detrend_0_N_ts',data=dd & store_data,'LANL-97A_avg_flux_sopa_esp_e_smoothed_detrend_0_N_ts_aa',dd.x,dd.y*ampadj[4]
get_data,'1994-084_avg_flux_sopa_esp_e_smoothed_detrend_0_N_ts',data=dd & store_data,'1994-084_avg_flux_sopa_esp_e_smoothed_detrend_0_N_ts_aa',dd.x,dd.y*ampadj[5]
get_data,'rbspa_bmag_t89_diff_smoothed_detrend_N_ts',data=dd & store_data,'rbspa_bmag_t89_diff_smoothed_detrend_N_ts_aa',dd.x,dd.y*ampadj[6]
get_data,'g13_dtc_cor_eflux_0_smoothed_detrend_N_ts',data=dd & store_data,'g13_dtc_cor_eflux_0_smoothed_detrend_N_ts_aa',dd.x,dd.y*ampadj[7]
get_data,'fspc_'+pre+'K_smoothed_detrend_N_ts',data=dd & store_data,'fspc_'+pre+'K_smoothed_detrend_N_ts_aa',dd.x,dd.y*ampadj[8]
get_data,'LANL-04A_avg_flux_sopa_esp_e_smoothed_detrend_0_N_ts',data=dd & store_data,'LANL-04A_avg_flux_sopa_esp_e_smoothed_detrend_0_N_ts_aa',dd.x,dd.y*ampadj[9]
get_data,'rbspa_sloshing_distance_km_N_ts',data=dd & store_data,'rbspa_sloshing_distance_km_N_ts_aa',dd.x,dd.y*ampadj[10]
get_data,'rbspb_bmag_t89_diff_smoothed_detrend_N_ts',data=dd & store_data,'rbspb_bmag_t89_diff_smoothed_detrend_N_ts_aa',dd.x,dd.y*ampadj[11]
get_data,'rbspa_Vx!CExB-drift!Ckm/s_detrend_N_ts',data=dd & store_data,'rbspa_Vx!CExB-drift!Ckm/s_detrend_N_ts_aa',dd.x,dd.y*ampadj[12]
get_data,'LANL-02A_avg_flux_sopa_esp_e_smoothed_detrend_0_N_ts',data=dd & store_data,'LANL-02A_avg_flux_sopa_esp_e_smoothed_detrend_0_N_ts_aa',dd.x,dd.y*ampadj[13]
get_data,'Bfield_hissinta_smoothed_detrend_N_ts',data=dd & store_data,'Bfield_hissinta_smoothed_detrend_N_ts_aa',dd.x,dd.y*ampadj[14]
get_data,'rbspa_density_smoothed_detrend_N_ts',data=dd & store_data,'rbspa_density_smoothed_detrend_N_ts_aa',dd.x,dd.y*ampadj[15]
get_data,'tha_l2_fbk_spec_scm1_572Hz_smoothed_detrend_N_ts',data=dd & store_data,'tha_l2_fbk_spec_scm1_572Hz_smoothed_detrend_N_ts_aa',dd.x,dd.y*ampadj[16]
get_data,'Bfield_hissintb_smoothed_detrend_N_ts',data=dd & store_data,'Bfield_hissintb_smoothed_detrend_N_ts_aa',dd.x,dd.y*ampadj[17]

ylim,'rbspb_bmag_t89_diff_smoothed_detrend_N_ts_aa',-2,2
ylim,'LANL-02A_avg_flux_sopa_esp_e_smoothed_detrend_0_N_ts_aa',-2000,2000

tplot,['LANL-01A_avg_flux_sopa_esp_e_smoothed_detrend_0_N_ts_aa',$
'OMNI_HRO_1min_proton_density_smoothed_detrend_N_ts_aa',$
'fspc_'+pre+'L_smoothed_detrend_N_ts_aa',$
'fspc_'+pre+'X_smoothed_detrend_N_ts_aa',$
'LANL-97A_avg_flux_sopa_esp_e_smoothed_detrend_0_N_ts_aa',$
'1994-084_avg_flux_sopa_esp_e_smoothed_detrend_0_N_ts_aa',$
'rbspa_bmag_t89_diff_smoothed_detrend_N_ts_aa',$
'g13_dtc_cor_eflux_0_smoothed_detrend_N_ts_aa',$
'fspc_'+pre+'K_smoothed_detrend_N_ts_aa',$
'LANL-04A_avg_flux_sopa_esp_e_smoothed_detrend_0_N_ts_aa',$
'rbspa_sloshing_distance_km_N_ts_aa',$
'rbspb_bmag_t89_diff_smoothed_detrend_N_ts_aa',$
'rbspa_Vx!CExB-drift!Ckm/s_detrend_N_ts_aa',$
'LANL-02A_avg_flux_sopa_esp_e_smoothed_detrend_0_N_ts_aa',$
'Bfield_hissinta_smoothed_detrend',$   ;no tshift b/c cc values are too low and tshift obviously absurd
'rbspa_density_smoothed_detrend',$   ;no tshift b/c cc values are too low and tshift obviously absurd
'tha_l2_fbk_spec_scm1_572Hz_smoothed_detrend',$   ;no tshift b/c cc values are too low and tshift obviously absurd
'Bfield_hissintb_smoothed_detrend']   ;no tshift b/c cc values are too low and tshift obviously absurd

;store_data,'v01',data=['fspc_'+pre+'L_smoothed_detrend_N_ts','OMNI_HRO_1min_proton_density_smoothed_detrend_N_ts'] & options,'v01','colors',[0,250]
;store_data,'v02',data=['fspc_2X_smoothed_detrend_N_ts','OMNI_HRO_1min_proton_density_smoothed_detrend_N_ts'] & options,'v02','colors',[0,250]
;store_data,'v03',data=['LANL-97A_avg_flux_sopa_esp_e_smoothed_detrend_0_N_ts','OMNI_HRO_1min_proton_density_smoothed_detrend_N_ts'] & options,'v03','colors',[0,250]
;store_data,'v04',data=['1994-084_avg_flux_sopa_esp_e_smoothed_detrend_0_N_ts','OMNI_HRO_1min_proton_density_smoothed_detrend_N_ts'] & options,'v04','colors',[0,250]
;store_data,'v05',data=['rbspa_bmag_t89_diff_smoothed_detrend_N_ts','OMNI_HRO_1min_proton_density_smoothed_detrend_N_ts'] & options,'v05','colors',[0,250]
;store_data,'v06',data=['g13_dtc_cor_eflux_0_smoothed_detrend_N_ts','OMNI_HRO_1min_proton_density_smoothed_detrend_N_ts'] & options,'v06','colors',[0,250]
;store_data,'v07',data=['fspc_'+pre+'K_smoothed_detrend_N_ts','OMNI_HRO_1min_proton_density_smoothed_detrend_N_ts'] & options,'v07','colors',[0,250]
;store_data,'v08',data=['LANL-04A_avg_flux_sopa_esp_e_smoothed_detrend_0_N_ts','OMNI_HRO_1min_proton_density_smoothed_detrend_N_ts'] & options,'v08','colors',[0,250]
;store_data,'v09',data=['rbspa_sloshing_distance_km_N_ts','OMNI_HRO_1min_proton_density_smoothed_detrend_N_ts'] & options,'v09','colors',[0,250]
;store_data,'v10',data=['rbspb_bmag_t89_diff_smoothed_detrend_N_ts','OMNI_HRO_1min_proton_density_smoothed_detrend_N_ts'] & options,'v10','colors',[0,250]
;store_data,'v11',data=['rbspa_Vx!CExB-drift!Ckm/s_detrend_N_ts','OMNI_HRO_1min_proton_density_smoothed_detrend_N_ts'] & options,'v11','colors',[0,250]
;store_data,'v12',data=['LANL-02A_avg_flux_sopa_esp_e_smoothed_detrend_0_N_ts','OMNI_HRO_1min_proton_density_smoothed_detrend_N_ts'] & options,'v12','colors',[0,250]
;store_data,'v13',data=['Bfield_hissinta_smoothed_detrend_N_ts','OMNI_HRO_1min_proton_density_smoothed_detrend_N_ts'] & options,'v13','colors',[0,250]
;store_data,'v14',data=['rbspa_density_smoothed_detrend_N_ts','OMNI_HRO_1min_proton_density_smoothed_detrend_N_ts'] & options,'v14','colors',[0,250]
;store_data,'v15',data=['tha_l2_fbk_spec_scm1_572Hz_smoothed_detrend_N_ts','OMNI_HRO_1min_proton_density_smoothed_detrend_N_ts'] & options,'v15','colors',[0,250]
;store_data,'v16',data=['Bfield_hissintb_smoothed_detrend_N_ts','OMNI_HRO_1min_proton_density_smoothed_detrend_N_ts'] & options,'v16','colors',[0,250]

;options,'v01','ytitle','FSPC 2L'
;options,'v02','ytitle','FSPC 2X'
;options,'v03','ytitle','LANL-97A'
;options,'v04','ytitle','1994-084'
;options,'v05','ytitle','RBSPA |B-Bmodel|'
;options,'v06','ytitle','G13'
;options,'v07','ytitle','FSPC 2K'
;options,'v08','ytitle','LANL-04A'
;options,'v09','ytitle','RBSPA sloshing!Cdist'
;options,'v10','ytitle','RBSPB |B-Bmodel|'
;options,'v11','ytitle','RBSPA VxB'
;options,'v12','ytitle','LANL-02A'
;options,'v13','ytitle','RBSPA hiss amp'
;options,'v14','ytitle','RBSPA density'
;options,'v15','ytitle','THEMISA FBK 572 Hz'
;options,'v16','ytitle','RBSPB hiss amp'
;
;tplot,['v01','v02','v03','v04','v05','v06','v07','v08','v09','v10','v11','v12','v13','v14','v15','v16']





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












;-------------------------------------------------------------------
;FFT comparison b/t different quantities/payloads
;-------------------------------------------------------------------

;First let's find out what timerange to use from the dial plots




;magic freqs (mHz) [from Villante et al., 2016]
fmagicL = [0.7,1.3,3.3,4.4,5.9]
fmagicH = [0.7,1.5,3.6,4.6,6.2]
colormag = [0,50,100,150,200]

tinterpol_mxn,'LANL-01A_avg_flux_sopa_esp_e_0','OMNI_HRO_1min_proton_density'
;tinterpol_mxn,'1991-080_avg_flux_sopa_esp_e_0','OMNI_HRO_1min_proton_density'    ;crappy data
tinterpol_mxn,'G14_bmag','OMNI_HRO_1min_proton_density'
tinterpol_mxn,'wi_dens_pms_3dp_proton_tshift','OMNI_HRO_1min_proton_density'
tinterpol_mxn,'fspc_'+pre+'X','OMNI_HRO_1min_proton_density'
tinterpol_mxn,'fspc_'+pre+'L','OMNI_HRO_1min_proton_density'
tinterpol_mxn,'rbspa_bmag_t89_diff','OMNI_HRO_1min_proton_density'
tinterpol_mxn,'rbspb_bmag_t89_diff','OMNI_HRO_1min_proton_density'
tinterpol_mxn,'Bfield_hissinta','OMNI_HRO_1min_proton_density'
tinterpol_mxn,'Bfield_hissintb','OMNI_HRO_1min_proton_density'
tinterpol_mxn,'tha_l2_fbk_spec_scm1_572Hz','OMNI_HRO_1min_proton_density'

vars_plot  = ['OMNI_HRO_1min_proton_density',$
'LANL-01A_avg_flux_sopa_esp_e_0',$
'G14_bmag',$
'wi_dens_pms_3dp_proton_tshift',$
'fspc_'+pre+'X',$
'fspc_'+pre+'L',$
'rbspa_bmag_t89_diff',$
'rbspb_bmag_t89_diff',$
'Bfield_hissinta',$
'Bfield_hissintb',$
'tha_l2_fbk_spec_scm1_572Hz']



vars = ['OMNI_HRO_1min_proton_density',$
'LANL-01A_avg_flux_sopa_esp_e_0_interp',$
'G14_bmag_interp',$
'wi_dens_pms_3dp_proton_tshift_interp',$
'fspc_'+pre+'X_interp',$
'fspc_'+pre+'L_interp',$
'rbspa_bmag_t89_diff_interp',$
'rbspb_bmag_t89_diff_interp',$
'Bfield_hissinta_interp',$
'Bfield_hissintb_interp',$
'tha_l2_fbk_spec_scm1_572Hz_interp']

;rbsp_detrend,vars,60.*80.
;vars = vars + '_detrend'

;Remove NaN values from arrays
store_data,vars+'_nonan',/del
for i=0,n_elements(vars)-1 do begin
    get_data,vars[i],data=d & goo = where(finite(d.y) ne 0.)
    yv = d.y[goo] & xv = d.x[goo] & store_data,vars[i]+'_nonan',xv,yv
endfor

;for i=0,n_elements(vars)-1 do begin $
;get_data,vars[i],data=d & goo = where(finite(d.y) ne 0.) & $
;yv = d.y[goo] & xv = d.x[goo] & store_data,vars[i]+'_nonan',xv,yv


;pro get_fft_comparison,var1,var2
t0z = '2014-01-10/17:30'
t1z = '2014-01-11/02:00'

;OMNI and LANL-01A comparison
;t0z = time_double('2014-01-10/18:00')
;t1z = time_double('2014-01-11/06:00')
;t0z = time_double('2014-01-10/20:00')
;;t1z = time_double('2014-01-10/23:59')
;t1z = time_double('2014-01-11/24:00')
;t0z = time_double('2014-01-11/18:00')
;t1z = time_double('2014-01-12/02:00')

;Normalize each timeseries and window
store_data,vars+'_nonanN',/del
for i=0,n_elements(vars)-1 do begin
    get_data,vars[i]+'_nonan',data=d
    yv = tsample(vars[i]+'_nonan',[t0z,t1z],times=tms)
    zm_timeseries = yv - mean(yv) & norm_timeseries = zm_timeseries/stddev(yv)
    store_data,vars[i]+'_nonanN',tms,norm_timeseries*hanning(n_elements(tms))
endfor

;for i=0,n_elements(vars)-1 do begin $
;get_data,vars[i]+'_nonan',data=d & $
;yv = tsample(vars[i]+'_nonan',[t0z,t1z],times=tms) & $
;zm_timeseries = yv - mean(yv) & norm_timeseries = zm_timeseries/stddev(yv) & $
;store_data,vars[i]+'_nonanN',tms,norm_timeseries*hanning(n_elements(tms))





;;Remove THEMISa Bo times before this time.
;get_data,var7,data=d
;goo = where(finite(d.y) ne 0.) & yv = d.y[goo] & xv = d.x[goo]
;goo = where(xv le time_double('2014-01-10/21:55')) & yv[goo] = 0. & xv[goo] = 0.
;store_data,var7+'_nonan',xv,yv


tlimit,t0z,t1z
tplot,vars+'_nonanN'




vtmp = tsample(vars[0]+'_nonanN',[t0z,t1z],times=tt) & store_data,vars[0]+'_nonanN'+'_tmp',tt,vtmp
power_x = fft_power_calc(tt,vtmp,/read_win) & freqsmHz1 = power_x.freq*1000.  ;mHz
power1n = power_x.power_x

vtmp = tsample(vars[1]+'_nonanN',[t0z,t1z],times=tt) & store_data,vars[1]+'_nonanN'+'_tmp',tt,vtmp
power_x = fft_power_calc(tt,vtmp,/read_win) & freqsmHz2 = power_x.freq*1000.  ;mHz
power2n = power_x.power_x

vtmp = tsample(vars[2]+'_nonanN',[t0z,t1z],times=tt) & store_data,vars[2]+'_nonanN'+'_tmp',tt,vtmp
power_x = fft_power_calc(tt,vtmp,/read_win) & freqsmHz3 = power_x.freq*1000.  ;mHz
power3n = power_x.power_x

vtmp = tsample(vars[3]+'_nonanN',[t0z,t1z],times=tt) & store_data,vars[3]+'_nonanN'+'_tmp',tt,vtmp
power_x = fft_power_calc(tt,vtmp,/read_win) & freqsmHz4 = power_x.freq*1000.  ;mHz
power4n = power_x.power_x

vtmp = tsample(vars[4]+'_nonanN',[t0z,t1z],times=tt) & store_data,vars[4]+'_nonanN'+'_tmp',tt,vtmp
power_x = fft_power_calc(tt,vtmp,/read_win) & freqsmHz5 = power_x.freq*1000.  ;mHz
power5n = power_x.power_x

vtmp = tsample(vars[5]+'_nonanN',[t0z,t1z],times=tt) & store_data,vars[5]+'_nonanN'+'_tmp',tt,vtmp
power_x = fft_power_calc(tt,vtmp,/read_win) & freqsmHz6 = power_x.freq*1000.  ;mHz
power6n = power_x.power_x

vtmp = tsample(vars[6]+'_nonanN',[t0z,t1z],times=tt) & store_data,vars[6]+'_nonanN'+'_tmp',tt,vtmp
power_x = fft_power_calc(tt,vtmp,/read_win) & freqsmHz7 = power_x.freq*1000.  ;mHz
power7n = power_x.power_x

vtmp = tsample(vars[7]+'_nonanN',[t0z,t1z],times=tt) & store_data,vars[7]+'_nonanN'+'_tmp',tt,vtmp
power_x = fft_power_calc(tt,vtmp,/read_win) & freqsmHz8 = power_x.freq*1000.  ;mHz
power8n = power_x.power_x

vtmp = tsample(vars[8]+'_nonanN',[t0z,t1z],times=tt) & store_data,vars[8]+'_nonanN'+'_tmp',tt,vtmp
power_x = fft_power_calc(tt,vtmp,/read_win) & freqsmHz9 = power_x.freq*1000.  ;mHz
power9n = power_x.power_x

vtmp = tsample(vars[9]+'_nonanN',[t0z,t1z],times=tt) & store_data,vars[9]+'_nonanN'+'_tmp',tt,vtmp
power_x = fft_power_calc(tt,vtmp,/read_win) & freqsmHz10 = power_x.freq*1000.  ;mHz
power10n = power_x.power_x

vtmp = tsample(vars[10]+'_nonanN',[t0z,t1z],times=tt) & store_data,vars[10]+'_nonanN'+'_tmp',tt,vtmp
power_x = fft_power_calc(tt,vtmp,/read_win) & freqsmHz11 = power_x.freq*1000.  ;mHz
power11n = power_x.power_x


;Smooth each to find the mean value.
power1ns = smooth(power1n,5)
power2ns = smooth(power2n,5)
power3ns = smooth(power3n,5)
power4ns = smooth(power4n,5)
power5ns = smooth(power5n,5)
power6ns = smooth(power6n,5)
power7ns = smooth(power7n,5)
power8ns = smooth(power8n,5)
power9ns = smooth(power9n,5)
power10ns = smooth(power10n,5)
power11ns = smooth(power11n,5)



;Calculate mean and 2 and 3 sigma standard deviations
sigma3 = 5.9 ;for 3 sigma
sigma2 = 3.1 ;for 2 sigma

width = 80.
goo1 = where(freqsmHz1 ge 0.05) & meanv1 = ts_smooth(power1ns[goo1],width) & sig31 = 10.*alog10(sigma3) + meanv1 & sig21 = 10.*alog10(sigma2) + meanv1
goo2 = where(freqsmHz2 ge 0.05) & meanv2 = ts_smooth(power2ns[goo2],width) & sig32 = 10.*alog10(sigma3) + meanv2 & sig22 = 10.*alog10(sigma2) + meanv2
goo3 = where(freqsmHz3 ge 0.05) & meanv3 = ts_smooth(power3ns[goo3],width) & sig33 = 10.*alog10(sigma3) + meanv3 & sig23 = 10.*alog10(sigma2) + meanv3
goo4 = where(freqsmHz4 ge 0.05) & meanv4 = ts_smooth(power4ns[goo4],width) & sig34 = 10.*alog10(sigma3) + meanv4 & sig24 = 10.*alog10(sigma2) + meanv4
goo5 = where(freqsmHz5 ge 0.05) & meanv5 = ts_smooth(power5ns[goo5],width) & sig35 = 10.*alog10(sigma3) + meanv5 & sig25 = 10.*alog10(sigma2) + meanv5
goo6 = where(freqsmHz6 ge 0.05) & meanv6 = ts_smooth(power6ns[goo6],width) & sig36 = 10.*alog10(sigma3) + meanv6 & sig26 = 10.*alog10(sigma2) + meanv6
goo7 = where(freqsmHz7 ge 0.05) & meanv7 = ts_smooth(power7ns[goo7],width) & sig37 = 10.*alog10(sigma3) + meanv7 & sig27 = 10.*alog10(sigma2) + meanv7
goo8 = where(freqsmHz8 ge 0.05) & meanv8 = ts_smooth(power8ns[goo8],width) & sig38 = 10.*alog10(sigma3) + meanv8 & sig28 = 10.*alog10(sigma2) + meanv8
goo9 = where(freqsmHz9 ge 0.05) & meanv9 = ts_smooth(power9ns[goo9],width) & sig39 = 10.*alog10(sigma3) + meanv9 & sig29 = 10.*alog10(sigma2) + meanv9
goo10 = where(freqsmHz10 ge 0.05) & meanv10 = ts_smooth(power10ns[goo10],width) & sig310 = 10.*alog10(sigma3) + meanv10 & sig210 = 10.*alog10(sigma2) + meanv10
goo11 = where(freqsmHz11 ge 0.05) & meanv11 = ts_smooth(power11ns[goo11],width) & sig311 = 10.*alog10(sigma3) + meanv11 & sig211 = 10.*alog10(sigma2) + meanv11


yr1 = [min(power1ns[goo1]),max(power1ns[goo1])]
yr2 = [min(power2ns[goo2]),max(power2ns[goo2])]
yr3 = [min(power3ns[goo3]),max(power3ns[goo3])]
yr4 = [min(power4ns[goo4]),max(power4ns[goo4])]
yr5 = [min(power5ns[goo5]),max(power5ns[goo5])]
yr6 = [min(power6ns[goo6]),max(power6ns[goo6])]
yr7 = [min(power7ns[goo7]),max(power7ns[goo7])]
yr8 = [min(power8ns[goo8]),max(power8ns[goo8])]
yr9 = [min(power9ns[goo9]),max(power9ns[goo9])]
yr10 = [min(power10ns[goo10]),max(power10ns[goo10])]
yr11 = [min(power11ns[goo11]),max(power11ns[goo11])]



!p.multi = [0,3,4] & !p.charsize = 1.
xr = [0.05,3] & yr = [1,60]
xlog = 1 & ylog = 0
plot,freqsmHz1,power1ns,xrange=xr,xlog=xlog,ylog=ylog,yrange=yr1,xstyle=1,ystyle=1,title='FFT OMNI density' & oplot,freqsmHz1[goo1],meanv1[goo1],color=50 & oplot,freqsmHz1[goo1],sig31[goo1],linestyle=2 & oplot,freqsmHz1[goo1],sig21[goo1],linestyle=2
plot,freqsmHz2,power2ns,xrange=xr,xlog=xlog,ylog=ylog,yrange=yr2,xstyle=1,ystyle=1,title='FFT LANL-01A_avg_flux_sopa_esp_e' & oplot,freqsmHz2[goo2],meanv2[goo2],color=50 & oplot,freqsmHz2[goo2],sig32[goo2],linestyle=2 & oplot,freqsmHz2[goo2],sig22[goo2],linestyle=2
plot,freqsmHz3,power3ns,xrange=xr,xlog=xlog,ylog=ylog,yrange=yr3,xstyle=1,ystyle=1,title='FFT G14 |B|' & oplot,freqsmHz3[goo3],meanv3[goo3],color=50 & oplot,freqsmHz3[goo3],sig33[goo3],linestyle=2 & oplot,freqsmHz3[goo3],sig23[goo3],linestyle=2
plot,freqsmHz4,power4ns,xrange=xr,xlog=xlog,ylog=ylog,yrange=yr4,xstyle=1,ystyle=1,title='FFT Wind 3dp density' & oplot,freqsmHz4[goo4],meanv4[goo4],color=50 & oplot,freqsmHz4[goo4],sig34[goo4],linestyle=2 & oplot,freqsmHz4[goo4],sig24[goo4],linestyle=2
plot,freqsmHz5,power5ns,xrange=xr,xlog=xlog,ylog=ylog,yrange=yr5,xstyle=1,ystyle=1,title='FFT fspc 2X' & oplot,freqsmHz5[goo5],meanv5[goo5],color=50 & oplot,freqsmHz5[goo5],sig35[goo5],linestyle=2 & oplot,freqsmHz5[goo5],sig25[goo5],linestyle=2
plot,freqsmHz6,power6ns,xrange=xr,xlog=xlog,ylog=ylog,yrange=yr6,xstyle=1,ystyle=1,title='FFT fspc 2L' & oplot,freqsmHz6[goo6],meanv6[goo6],color=50 & oplot,freqsmHz6[goo6],sig36[goo6],linestyle=2 & oplot,freqsmHz6[goo6],sig26[goo6],linestyle=2
plot,freqsmHz7,power7ns,xrange=xr,xlog=xlog,ylog=ylog,yrange=yr7,xstyle=1,ystyle=1,title='FFT RBSPa |B|' & oplot,freqsmHz7[goo7],meanv7[goo7],color=50 & oplot,freqsmHz7[goo7],sig37[goo7],linestyle=2 & oplot,freqsmHz7[goo7],sig27[goo7],linestyle=2
plot,freqsmHz8,power8ns,xrange=xr,xlog=xlog,ylog=ylog,yrange=yr8,xstyle=1,ystyle=1,title='FFT RBSPb |B|' & oplot,freqsmHz8[goo8],meanv8[goo8],color=50 & oplot,freqsmHz8[goo8],sig38[goo8],linestyle=2 & oplot,freqsmHz8[goo8],sig28[goo8],linestyle=2
plot,freqsmHz9,power9ns,xrange=xr,xlog=xlog,ylog=ylog,yrange=yr9,xstyle=1,ystyle=1,title='FFT RBSPa hiss RMS' & oplot,freqsmHz9[goo9],meanv9[goo9],color=50 & oplot,freqsmHz9[goo9],sig39[goo9],linestyle=2 & oplot,freqsmHz9[goo9],sig29[goo9],linestyle=2
plot,freqsmHz10,power10ns,xrange=xr,xlog=xlog,ylog=ylog,yrange=yr10,xstyle=1,ystyle=1,title='FFT RBSPb hiss RMS' & oplot,freqsmHz10[goo10],meanv10[goo10],color=50 & oplot,freqsmHz10[goo10],sig310[goo10],linestyle=2 & oplot,freqsmHz10[goo10],sig210[goo10],linestyle=2
plot,freqsmHz11,power11ns,xrange=xr,xlog=xlog,ylog=ylog,yrange=yr11,xstyle=1,ystyle=1,title='FFT THEMISa FBK scm1 572Hz' & oplot,freqsmHz11[goo11],meanv11[goo11],color=50 & oplot,freqsmHz11[goo11],sig311[goo11],linestyle=2 & oplot,freqsmHz11[goo11],sig211[goo11],linestyle=2



!p.multi = [0,3,4] & !p.charsize = 1.
xr = [0.,3] & yr = [1,60]
;xr = [0.,3] & yr = [0,40]
xlog = 0 & ylog = 0
plot,freqsmHz1,power1ns,xrange=xr,xlog=xlog,ylog=ylog,yrange=yr1,xstyle=1,ystyle=1,title='FFT OMNI density' & oplot,freqsmHz1[goo1],meanv1[goo1],color=50 & oplot,freqsmHz1[goo1],sig31[goo1],linestyle=2 & oplot,freqsmHz1[goo1],sig21[goo1],linestyle=2
plot,freqsmHz2,power2ns,xrange=xr,xlog=xlog,ylog=ylog,yrange=yr2,xstyle=1,ystyle=1,title='FFT LANL-01A_avg_flux_sopa_esp_e' & oplot,freqsmHz2[goo2],meanv2[goo2],color=50 & oplot,freqsmHz2[goo2],sig32[goo2],linestyle=2 & oplot,freqsmHz2[goo2],sig22[goo2],linestyle=2
plot,freqsmHz3,power3ns,xrange=xr,xlog=xlog,ylog=ylog,yrange=yr3,xstyle=1,ystyle=1,title='FFT G14 |B|' & oplot,freqsmHz3[goo3],meanv3[goo3],color=50 & oplot,freqsmHz3[goo3],sig33[goo3],linestyle=2 & oplot,freqsmHz3[goo3],sig23[goo3],linestyle=2
plot,freqsmHz4,power4ns,xrange=xr,xlog=xlog,ylog=ylog,yrange=yr4,xstyle=1,ystyle=1,title='FFT Wind 3dp density' & oplot,freqsmHz4[goo4],meanv4[goo4],color=50 & oplot,freqsmHz4[goo4],sig34[goo4],linestyle=2 & oplot,freqsmHz4[goo4],sig24[goo4],linestyle=2
plot,freqsmHz5,power5ns,xrange=xr,xlog=xlog,ylog=ylog,yrange=yr5,xstyle=1,ystyle=1,title='FFT fspc 2X' & oplot,freqsmHz5[goo5],meanv5[goo5],color=50 & oplot,freqsmHz5[goo5],sig35[goo5],linestyle=2 & oplot,freqsmHz5[goo5],sig25[goo5],linestyle=2
plot,freqsmHz6,power6ns,xrange=xr,xlog=xlog,ylog=ylog,yrange=yr6,xstyle=1,ystyle=1,title='FFT fspc 2L' & oplot,freqsmHz6[goo6],meanv6[goo6],color=50 & oplot,freqsmHz6[goo6],sig36[goo6],linestyle=2 & oplot,freqsmHz6[goo6],sig26[goo6],linestyle=2
plot,freqsmHz7,power7ns,xrange=xr,xlog=xlog,ylog=ylog,yrange=yr7,xstyle=1,ystyle=1,title='FFT RBSPa |B|' & oplot,freqsmHz7[goo7],meanv7[goo7],color=50 & oplot,freqsmHz7[goo7],sig37[goo7],linestyle=2 & oplot,freqsmHz7[goo7],sig27[goo7],linestyle=2
plot,freqsmHz8,power8ns,xrange=xr,xlog=xlog,ylog=ylog,yrange=yr8,xstyle=1,ystyle=1,title='FFT RBSPb |B|' & oplot,freqsmHz8[goo8],meanv8[goo8],color=50 & oplot,freqsmHz8[goo8],sig38[goo8],linestyle=2 & oplot,freqsmHz8[goo8],sig28[goo8],linestyle=2
plot,freqsmHz9,power9ns,xrange=xr,xlog=xlog,ylog=ylog,yrange=yr9,xstyle=1,ystyle=1,title='FFT RBSPa hiss RMS' & oplot,freqsmHz9[goo9],meanv9[goo9],color=50 & oplot,freqsmHz9[goo9],sig39[goo9],linestyle=2 & oplot,freqsmHz9[goo9],sig29[goo9],linestyle=2
plot,freqsmHz10,power10ns,xrange=xr,xlog=xlog,ylog=ylog,yrange=yr10,xstyle=1,ystyle=1,title='FFT RBSPb hiss RMS' & oplot,freqsmHz10[goo10],meanv10[goo10],color=50 & oplot,freqsmHz10[goo10],sig310[goo10],linestyle=2 & oplot,freqsmHz10[goo10],sig210[goo10],linestyle=2
plot,freqsmHz11,power11ns,xrange=xr,xlog=xlog,ylog=ylog,yrange=yr11,xstyle=1,ystyle=1,title='FFT THEMISa FBK scm1 572Hz' & oplot,freqsmHz11[goo11],meanv11[goo11],color=50 & oplot,freqsmHz11[goo11],sig311[goo11],linestyle=2 & oplot,freqsmHz11[goo11],sig211[goo11],linestyle=2






for i=0,n_elements(fmagicL)-1 do oplot,[fmagicL[i],fmagicL[i]],[0.001,120],color=colormag[i]
for i=0,n_elements(fmagicL)-1 do oplot,[fmagicH[i],fmagicH[i]],[0.001,120],color=colormag[i]








;--------------------------------------------------------------------------
;Jan 11th event
;--------------------------------------------------------------------------


load_barrel_lc,'2X',type='rcnt'

;No THEMIS A FFT data from ~18-24 UT on 10th and 11th


file = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/Analysis_major_events_campaign2/Jan10/tha_l2_fgm_20140110_v01.dat'
read_themis_dat_mag_files,file,tvarname='tha_bmag10'
file = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/Analysis_major_events_campaign2/Jan10/tha_l2_fgm_20140111_v01.dat'
read_themis_dat_mag_files,file,tvarname='tha_bmag11'
file = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/Analysis_major_events_campaign2/Jan10/tha_l2_fgm_20140112_v01.dat'
read_themis_dat_mag_files,file,tvarname='tha_bmag12'

get_data,'tha_bmag10',data=d10
get_data,'tha_bmag11',data=d11
get_data,'tha_bmag12',data=d12
store_data,'tha_bmag',[d10.x,d11.x,d12.x],[d10.y,d11.y,d12.y]

;Need to first detrend this one b/c the DC power is so large here
rbsp_detrend,'tha_bmag',60.*80.


vars = ['PeakDet_2X',$
'OMNI_HRO_1min_proton_density',$
'tha_bmag_detrend',$
'tha_l2_fbk_spec_edc12_144Hz',$
'tha_l2_fbk_spec_edc12_36Hz',$
'tha_l2_fbk_spec_edc12_9Hz',$
'tha_l2_fbk_spec_edc12_2Hz',$
'tha_l2_fbk_spec_scm1_572Hz',$
'tha_l2_fbk_spec_scm1_144Hz',$
'tha_l2_fbk_spec_scm1_36Hz',$
'tha_l2_fbk_spec_scm1_9Hz',$
'tha_l2_fbk_spec_scm1_2Hz']



for i=0,n_elements(vars)-1 do tinterpol_mxn,vars[i],'OMNI_HRO_1min_proton_density'
vars = vars + '_interp'



;Remove NaN values from arrays
store_data,vars+'_nonan',/del
for i=0,n_elements(vars)-1 do begin $
    get_data,vars[i],data=d & $
    goo = where(finite(d.y) ne 0.) & $
    yv = d.y[goo] & $
    xv = d.x[goo] & $
    store_data,vars[i]+'_nonan',xv,yv
endfor


t0z = time_double('2014-01-11/19:00')
t1z = time_double('2014-01-12/02:00')

;Normalize each timeseries and window
store_data,vars+'_nonanN',/del
for i=0,n_elements(vars)-1 do begin $
    get_data,vars[i]+'_nonan',data=d & $
    yv = tsample(vars[i]+'_nonan',[t0z,t1z],times=tms) & $
    zm_timeseries = yv - mean(yv) & norm_timeseries = zm_timeseries/stddev(yv) & $
    store_data,vars[i]+'_nonanN',tms,norm_timeseries*hanning(n_elements(tms))
endfor



tlimit,t0z,t1z
tplot,vars+'_nonanN'

;test for size
vtmp = tsample(vars[1]+'_nonanN',[t0z,t1z],times=tt)
power_x = fft_power_calc(tt,vtmp,/read_win)

powern = fltarr(n_elements(power_x.power_x),n_elements(vars))
freqsmHzn = fltarr(n_elements(power_x.power_x),n_elements(vars))

for i=0,n_elements(vars)-1 do begin $
    print,i & $
    vtmp = tsample(vars[i]+'_nonanN',[t0z,t1z],times=tt) & $
    store_data,vars[i]+'_nonanN'+'_tmp',tt,vtmp & $
    power_x = fft_power_calc(tt,vtmp,/read_win) & $
    freqsmHzn[*,i] = power_x.freq*1000. & $  ;mHz
    powern[*,i] = power_x.power_x
endfor


;Smooth each to find the mean value.
powerns = fltarr(n_elements(power_x.power_x),n_elements(vars))
for i=0,n_elements(vars)-1 do powerns[*,i] = smooth(powern[*,i],5)


;Calculate mean and 2 and 3 sigma standard deviations
sigma3 = 5.9 ;for 3 sigma
sigma2 = 3.1 ;for 2 sigma

width = 80.
meanv = fltarr(n_elements(power_x.power_x),n_elements(vars))
sig2 = fltarr(n_elements(power_x.power_x),n_elements(vars))
sig3 = fltarr(n_elements(power_x.power_x),n_elements(vars))


goodfreqs = where(freqsmHzn[*,0] ge 0.05) & $
for i=0,n_elements(vars)-1 do begin $
    meanv[goodfreqs,i] = ts_smooth(powerns[goodfreqs,i],width) & $
    sig3[goodfreqs,i] = 10.*alog10(sigma3) + meanv[goodfreqs,i] & $
    sig2[goodfreqs,i] = 10.*alog10(sigma2) + meanv[goodfreqs,i]
endfor

yrmin = fltarr(n_elements(vars))
yrmax = fltarr(n_elements(vars))
for i=0,n_elements(vars)-1 do yrmin[i] = min(powerns[goodfreqs,i])
for i=0,n_elements(vars)-1 do yrmax[i] = max(powerns[goodfreqs,i])



!p.multi = [0,3,4] & !p.charsize = 1.
xr = [0.05,3] & yr = [1,60]
xlog = 1 & ylog = 0
for i=0,n_elements(vars)-1 do begin $
    plot,freqsmHzn[*,i],powerns[*,i],xrange=xr,xlog=xlog,ylog=ylog,yrange=[yrmin[i],yrmax[i]],xstyle=1,ystyle=1,title=vars[i] & $
    oplot,freqsmHzn[goodfreqs,i],meanv[goodfreqs,i],color=50 & $
    oplot,freqsmHzn[goodfreqs,i],sig3[goodfreqs,i],linestyle=2 & $
    oplot,freqsmHzn[goodfreqs,i],sig2[goodfreqs,i],linestyle=2
endfor


plot,freqsmHz2,power2ns,xrange=xr,xlog=xlog,ylog=ylog,yrange=yr2,xstyle=1,ystyle=1,title='FFT LANL-01A_avg_flux_sopa_esp_e' & oplot,freqsmHz2[goo2],meanv2[goo2],color=50 & oplot,freqsmHz2[goo2],sig32[goo2],linestyle=2 & oplot,freqsmHz2[goo2],sig22[goo2],linestyle=2
plot,freqsmHz3,power3ns,xrange=xr,xlog=xlog,ylog=ylog,yrange=yr3,xstyle=1,ystyle=1,title='FFT G14 |B|' & oplot,freqsmHz3[goo3],meanv3[goo3],color=50 & oplot,freqsmHz3[goo3],sig33[goo3],linestyle=2 & oplot,freqsmHz3[goo3],sig23[goo3],linestyle=2
plot,freqsmHz4,power4ns,xrange=xr,xlog=xlog,ylog=ylog,yrange=yr4,xstyle=1,ystyle=1,title='FFT Wind 3dp density' & oplot,freqsmHz4[goo4],meanv4[goo4],color=50 & oplot,freqsmHz4[goo4],sig34[goo4],linestyle=2 & oplot,freqsmHz4[goo4],sig24[goo4],linestyle=2
plot,freqsmHz5,power5ns,xrange=xr,xlog=xlog,ylog=ylog,yrange=yr5,xstyle=1,ystyle=1,title='FFT fspc 2X' & oplot,freqsmHz5[goo5],meanv5[goo5],color=50 & oplot,freqsmHz5[goo5],sig35[goo5],linestyle=2 & oplot,freqsmHz5[goo5],sig25[goo5],linestyle=2
plot,freqsmHz6,power6ns,xrange=xr,xlog=xlog,ylog=ylog,yrange=yr6,xstyle=1,ystyle=1,title='FFT fspc 2L' & oplot,freqsmHz6[goo6],meanv6[goo6],color=50 & oplot,freqsmHz6[goo6],sig36[goo6],linestyle=2 & oplot,freqsmHz6[goo6],sig26[goo6],linestyle=2
plot,freqsmHz7,power7ns,xrange=xr,xlog=xlog,ylog=ylog,yrange=yr7,xstyle=1,ystyle=1,title='FFT RBSPa |B|' & oplot,freqsmHz7[goo7],meanv7[goo7],color=50 & oplot,freqsmHz7[goo7],sig37[goo7],linestyle=2 & oplot,freqsmHz7[goo7],sig27[goo7],linestyle=2
plot,freqsmHz8,power8ns,xrange=xr,xlog=xlog,ylog=ylog,yrange=yr8,xstyle=1,ystyle=1,title='FFT RBSPb |B|' & oplot,freqsmHz8[goo8],meanv8[goo8],color=50 & oplot,freqsmHz8[goo8],sig38[goo8],linestyle=2 & oplot,freqsmHz8[goo8],sig28[goo8],linestyle=2
plot,freqsmHz9,power9ns,xrange=xr,xlog=xlog,ylog=ylog,yrange=yr9,xstyle=1,ystyle=1,title='FFT RBSPa hiss RMS' & oplot,freqsmHz9[goo9],meanv9[goo9],color=50 & oplot,freqsmHz9[goo9],sig39[goo9],linestyle=2 & oplot,freqsmHz9[goo9],sig29[goo9],linestyle=2
plot,freqsmHz10,power10ns,xrange=xr,xlog=xlog,ylog=ylog,yrange=yr10,xstyle=1,ystyle=1,title='FFT RBSPb hiss RMS' & oplot,freqsmHz10[goo10],meanv10[goo10],color=50 & oplot,freqsmHz10[goo10],sig310[goo10],linestyle=2 & oplot,freqsmHz10[goo10],sig210[goo10],linestyle=2
plot,freqsmHz11,power11ns,xrange=xr,xlog=xlog,ylog=ylog,yrange=yr11,xstyle=1,ystyle=1,title='FFT THEMISa FBK scm1 572Hz' & oplot,freqsmHz11[goo11],meanv11[goo11],color=50 & oplot,freqsmHz11[goo11],sig311[goo11],linestyle=2 & oplot,freqsmHz11[goo11],sig211[goo11],linestyle=2



!p.multi = [0,3,4] & !p.charsize = 1.
xr = [0.,3] & yr = [1,60]
;xr = [0.,3] & yr = [0,40]
xlog = 0 & ylog = 0
plot,freqsmHz1,power1ns,xrange=xr,xlog=xlog,ylog=ylog,yrange=yr1,xstyle=1,ystyle=1,title='FFT OMNI density' & oplot,freqsmHz1[goo1],meanv1[goo1],color=50 & oplot,freqsmHz1[goo1],sig31[goo1],linestyle=2 & oplot,freqsmHz1[goo1],sig21[goo1],linestyle=2
plot,freqsmHz2,power2ns,xrange=xr,xlog=xlog,ylog=ylog,yrange=yr2,xstyle=1,ystyle=1,title='FFT LANL-01A_avg_flux_sopa_esp_e' & oplot,freqsmHz2[goo2],meanv2[goo2],color=50 & oplot,freqsmHz2[goo2],sig32[goo2],linestyle=2 & oplot,freqsmHz2[goo2],sig22[goo2],linestyle=2
plot,freqsmHz3,power3ns,xrange=xr,xlog=xlog,ylog=ylog,yrange=yr3,xstyle=1,ystyle=1,title='FFT G14 |B|' & oplot,freqsmHz3[goo3],meanv3[goo3],color=50 & oplot,freqsmHz3[goo3],sig33[goo3],linestyle=2 & oplot,freqsmHz3[goo3],sig23[goo3],linestyle=2
plot,freqsmHz4,power4ns,xrange=xr,xlog=xlog,ylog=ylog,yrange=yr4,xstyle=1,ystyle=1,title='FFT Wind 3dp density' & oplot,freqsmHz4[goo4],meanv4[goo4],color=50 & oplot,freqsmHz4[goo4],sig34[goo4],linestyle=2 & oplot,freqsmHz4[goo4],sig24[goo4],linestyle=2
plot,freqsmHz5,power5ns,xrange=xr,xlog=xlog,ylog=ylog,yrange=yr5,xstyle=1,ystyle=1,title='FFT fspc 2X' & oplot,freqsmHz5[goo5],meanv5[goo5],color=50 & oplot,freqsmHz5[goo5],sig35[goo5],linestyle=2 & oplot,freqsmHz5[goo5],sig25[goo5],linestyle=2
plot,freqsmHz6,power6ns,xrange=xr,xlog=xlog,ylog=ylog,yrange=yr6,xstyle=1,ystyle=1,title='FFT fspc 2L' & oplot,freqsmHz6[goo6],meanv6[goo6],color=50 & oplot,freqsmHz6[goo6],sig36[goo6],linestyle=2 & oplot,freqsmHz6[goo6],sig26[goo6],linestyle=2
plot,freqsmHz7,power7ns,xrange=xr,xlog=xlog,ylog=ylog,yrange=yr7,xstyle=1,ystyle=1,title='FFT RBSPa |B|' & oplot,freqsmHz7[goo7],meanv7[goo7],color=50 & oplot,freqsmHz7[goo7],sig37[goo7],linestyle=2 & oplot,freqsmHz7[goo7],sig27[goo7],linestyle=2
plot,freqsmHz8,power8ns,xrange=xr,xlog=xlog,ylog=ylog,yrange=yr8,xstyle=1,ystyle=1,title='FFT RBSPb |B|' & oplot,freqsmHz8[goo8],meanv8[goo8],color=50 & oplot,freqsmHz8[goo8],sig38[goo8],linestyle=2 & oplot,freqsmHz8[goo8],sig28[goo8],linestyle=2
plot,freqsmHz9,power9ns,xrange=xr,xlog=xlog,ylog=ylog,yrange=yr9,xstyle=1,ystyle=1,title='FFT RBSPa hiss RMS' & oplot,freqsmHz9[goo9],meanv9[goo9],color=50 & oplot,freqsmHz9[goo9],sig39[goo9],linestyle=2 & oplot,freqsmHz9[goo9],sig29[goo9],linestyle=2
plot,freqsmHz10,power10ns,xrange=xr,xlog=xlog,ylog=ylog,yrange=yr10,xstyle=1,ystyle=1,title='FFT RBSPb hiss RMS' & oplot,freqsmHz10[goo10],meanv10[goo10],color=50 & oplot,freqsmHz10[goo10],sig310[goo10],linestyle=2 & oplot,freqsmHz10[goo10],sig210[goo10],linestyle=2
plot,freqsmHz11,power11ns,xrange=xr,xlog=xlog,ylog=ylog,yrange=yr11,xstyle=1,ystyle=1,title='FFT THEMISa FBK scm1 572Hz' & oplot,freqsmHz11[goo11],meanv11[goo11],color=50 & oplot,freqsmHz11[goo11],sig311[goo11],linestyle=2 & oplot,freqsmHz11[goo11],sig211[goo11],linestyle=2


for i=0,n_elements(fmagicL)-1 do oplot,[fmagicL[i],fmagicL[i]],[0.001,120],color=colormag[i]
for i=0,n_elements(fmagicL)-1 do oplot,[fmagicH[i],fmagicH[i]],[0.001,120],color=colormag[i]































;;Calculate local dR/dt (Wygant94)
;
;;;Load EMFISIS
;timespan,'2014-01-10',2,/days
;rbsp_load_emfisis,probe='a',level='l3',coord='gsm'
;rbsp_efw_position_velocity_crib
;;rbsp_load_emfisis,probe='b',level='l3',coord='gsm'

;tinterpol_mxn,'rbspa_emfisis_l3_4sec_gsm_Magnitude','efield_inertial_frame_mgse'
;tinterpol_mxn,'rbspa_state_lshell','efield_inertial_frame_mgse'

;get_data,'rbspa_emfisis_l3_4sec_gsm_Magnitude_interp',data=bmag
;get_data,'rbspa_state_lshell_interp',data=la

;Bo = 886000./28.  ;Earth's field at surface
;Br = Bo/la.y^3
;store_data,'Br',la.x,Br

;get_data,'rbspa_efield_inertial_frame_mgse_smoothed_y',data=ey
;dR_dt = ey.y/Br
;store_data,'dR_dt',la.x,dR_dt*6370.
;tplot,'dR_dt'

;tplot,['OMNI_HRO_1min_proton_density_smoothed_detrend','rbspa_efield_inertial_frame_mgse_smoothed_y','rbspa_mag_mgse_t89_dif_smoothed_interp_z','minus_vxb_x_proxy_detrend']







end
