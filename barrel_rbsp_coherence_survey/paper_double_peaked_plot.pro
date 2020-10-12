;;Make the plot showing the double-peaked event on Jan 6th, 2014
;;starting in the SW on ACE, extending through the magnetosheath
;;(Cluster4), into the magnetosphere (RBSP-A), resulting in hiss
;;growth and enhanced X-rays on 2K.

rbsp_efw_init

tplot_options,'title','from paper_double_peaked_plot.pro'

smoothtime = 0.3

t0 = '2014-01-06/18:00'
t1 = '2014-01-06/24:00'

timespan,'2014-01-06'


;;--------------------------------------------------
;;load indices
;;--------------------------------------------------

kyoto_load_ae,datatype=['au','ae','al']



;;--------------------------------------------------
;;load THEMIS data
;;--------------------------------------------------

;;Artemis (~60 RE on evening side)
thm_load_esa,probe=['b','c']
thm_load_fgm,probe=['b','c']


path = '~/Desktop/Research/RBSP_hiss_precip/themis/'

fn = 'tha_l2_mom_20140106_v01.cdf'
cdf2tplot,files=path + fn
tplot,['tha_peim_density','tha_peem_density']
fn = 'thd_l2_mom_20140106_v01.cdf'
cdf2tplot,files=path + fn
tplot,['thd_peim_density','thd_peem_density']
fn = 'the_l2_mom_20140106_v01.cdf'
cdf2tplot,files=path + fn

tplot,['tha_peim_density','thd_peim_density']


path = '~/Desktop/Research/RBSP_hiss_precip/themis/'
fn = 'tha_l2_fgm_20140106_v01.cdf'
cdf2tplot,files=path + fn
fn = 'thd_l2_fgm_20140106_v01.cdf'
cdf2tplot,files=path + fn
fn = 'the_l2_fgm_20140106_v01.cdf'
cdf2tplot,files=path + fn


tplot,['tha_fgh_gsm','tha_fgl_gsm','tha_fgs_gsm']
tplot,['thd_fgh_gsm','thd_fgl_gsm','thd_fgs_gsm']

split_vec,'tha_fgs_gsm'
split_vec,'thd_fgs_gsm'


get_data,'tha_peim_mag',data=ma 
ma2 = sqrt(ma.y[*,0]^2 + ma.y[*,1]^2 + ma.y[*,2]^2)
store_data,'tha_bmag',data={x:ma.x,y:ma2}

get_data,'thd_peim_mag',data=ma                               
ma2 = sqrt(ma.y[*,0]^2 + ma.y[*,1]^2 + ma.y[*,2]^2)
store_data,'thd_bmag',data={x:ma.x,y:ma2}          
tplot,['tha_bmag','thd_bmag']



rbsp_detrend,['tha_peim_density','thd_peim_density'],60.*smoothtime
rbsp_detrend,['tha_peim_density','thd_peim_density']+'_smoothed',60.*20.






;;--------------------------------------------------
;;load GOES data
;;--------------------------------------------------

;; .compile /Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/IDL/get_goes_ncdf.pro
;; .compile /Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/IDL/get_ncdf_data.pro

;; .compile /Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip/GOES/goes_aaron
;; goes_aaron


rbsp_detrend,'g13_Bp',60.*smoothtime
rbsp_detrend,'g13_Bp_smoothed',60.*20.


;;--------------------------------------------------
;;load ACE data - event is at ~19:46 UT
;;--------------------------------------------------

path = '~/Desktop/Research/RBSP_hiss_precip/ace_wind/'

;fn = 'ac_h3s_mfi_20140106180000_20140106235959.cdf'
fn = 'ac_h3_mfi_20140106_v02.cdf'

cdf2tplot,files=path+fn
copy_data,'Magnitude','ace_bmag_h3s_mfi'
copy_data,'BGSM','ace_BGSM'
copy_data,'BRTN','ace_BRTN'
store_data,['Magnitude','BGSM','BGSEc','BRTN'],/delete

rbsp_detrend,['ace_bmag_h3s_mfi','ace_BGSM','ace_BRTN'],60.*smoothtime
tplot,['ace_bmag_h3s_mfi_smoothed','ace_BGSM_smoothed','ace_BRTN_smoothed']
;;Event is almost exclusively in the BR and BN directions



fn = 'ac_h0s_swe_20140106000037_20140106235933.cdf'
cdf2tplot,files=path+fn
copy_data,'Np','ace_Np'
copy_data,'Tpr','ace_Tpr'
store_data,['Np','Vp','Tpr','V_GSM'],/delete





;;--------------------------------------------------
;;Calculate dynamic pressure as n*v^2
;;--------------------------------------------------
;;From OMNIWeb
;; Flow pressure = (2*10**-6)*Np*Vp**2 nPa (Np in cm**-3, 
;; Vp in km/s, subscript "p" for "proton")

fn = 'ac_h0s_swe_20140106140005_20140106225949.cdf'
cdf2tplot,files=path+fn


split_vec,'V_GSE'
get_data,'V_GSE_x',data=vv

get_data,'Np',data=dd
tplot,['V_GSE_x','Np']

;change velocity to m/s
vsw = vv.y
;change number density to 1/m^3
dens = dd.y


vsw_mean = mean(vsw,/nan)
dens_mean = mean(dens,/nan)


;;Pressure in nPa (rho*v^2)
press_proxy = 2d-6 * dens * vsw^2
store_data,'ace_press_proxy',data={x:vv.x,y:press_proxy}
;;calculate pressure using averaged Vsw value
press_proxy = 2d-6 * dens * vsw_mean^2 
store_data,'ace_press_proxy_constant_vsw',data={x:vv.x,y:press_proxy}
;;calculate pressure using averaged density value
press_proxy = 2d-6 * dens_mean * vsw^2 
store_data,'ace_press_proxy_constant_dens',data={x:vv.x,y:press_proxy}

store_data,'ace_pressure_compare',$
           data=['ace_press_proxy','ace_press_proxy_constant_dens','ace_press_proxy_constant_vsw']


store_data,'ace_pressure_compare_dec',$
           data=['ace_press_proxy_dec','ace_press_proxy_constant_dens_dec','ace_press_proxy_constant_vsw_dec']

options,'ace_pressure_compare','colors',[0,50,250]
options,'ace_pressure_compare_dec','colors',[0,50,250]



;;--------------------------------------------------
;;load OMNI data
;;--------------------------------------------------

;;Note: OMNI data is heavily interpolated during Jan6
;;double-peaked event and, I believe, is not useable. 

path = '~/Desktop/Research/RBSP_hiss_precip/ace_wind/'
fn = 'omni_hros_1min_20140106180000_20140106230000.cdf'
cdf2tplot,files=path+fn

copy_data,'Timeshift','omni_Timeshift'
copy_data,'BX_GSE','omni_BX_GSE'
copy_data,'BY_GSE','omni_BY_GSE'
copy_data,'BZ_GSE','omni_BZ_GSE'
copy_data,'flow_speed','omni_flowspeed'
copy_data,'Vx','omni_Vx'
copy_data,'Vy','omni_Vy'
copy_data,'Vz','omni_Vz'
copy_data,'proton_density','omni_proton_density'
copy_data,'T','omni_T'
copy_data,'Pressure','omni_Pressure'
copy_data,'Beta','omni_Beta'

tplot,'*omni_*'

store_data,['Timeshift','BX_GSE','BY_GSE','BZ_GSE','flow_speed','Vx','Vy','Vz','proton_density','T','Pressure','Beta'],/delete

get_data,'omni_BX_GSE',data=dx
get_data,'omni_BY_GSE',data=dy
get_data,'omni_BZ_GSE',data=dz
d2 = [[dx.y],[dy.y],[dz.y]]
store_data,'omni_BGSE',data={x:dx.x,y:d2}


cotrans,'omni_BGSE','omni_BGSM',/gse2gsm
tplot,['omni_BGSE','omni_BGSM']



;;--------------------------------------------------
;;Cluster observations
;;--------------------------------------------------



;; ;Cluster 1 at 21 UT (magnetosheath)
;; L = 23.7
;; RE = 19.24
;; MLT = 16:08
;; pos_gse =[7.49,14.05,-10.79]
;; Bo = xxx
;; mlat = -25.8


;; ;Cluster 2 at 21 UT (Intpl Med)
;; L = 24.2
;; RE = 19.76
;; MLT = 15:56
;; pos_gse = [8.51,14.22,-10.77]
;; Bo = xxx
;; mlat = -25.9

;; ;Cluster 3 at 21 UT (D Msheath)
;; L = 24.8
;; RE = 19.22
;; MLT = 16:05
;; pos_gse = [7.41,13.54,-11.46]
;; Bo = xxx
;; mlat = -28.3


;; ;Cluster 4 at 21 UT (D Msheath)
;; L = 24.8
;; RE = 19.2
;; MLT = 16:06
;; pos_gse = [7.37,13.52,-11.49]
;; Bo = xxx
;; mlat = -28.4



path = '~/Desktop/Research/RBSP_hiss_precip/Cluster/'
fn = 'c4_pps_cis_20140106000002_20140106235955.cdf'
cdf2tplot,files=path + fn
fn = 'c4_cps_fgm_spin_20140106000002_20140106235959.cdf'
cdf2tplot,files=path + fn


get_data,'V_p_xyz_gse__C4_PP_CIS',data=dd
vmag = sqrt(dd.y[*,0]^2 + dd.y[*,1]^2 + dd.y[*,2]^2)
store_data,'c4_vmag',data={x:dd.x,y:vmag}

options,'N_p__C4_PP_CIS','ytitle','Np C4!CCIS'
options,'V_p_xyz_gse__C4_PP_CIS','ytitle','Vp C4 GSE!CCIS'
options,'c4_vmag','ytitle','Vmag C4!C[km/s]'
options,'B_vec_xyz_gse__C4_CP_FGM_SPIN','ytitle','B C4 GSE!CFGM spin'
options,'B_mag__C4_CP_FGM_SPIN','ytitle','Bmag C4!CFGM spin'


copy_data,'N_p__C4_PP_CIS','c4_density'
copy_data,'V_p_xyz_gse__C4_PP_CIS','c4_velocity_gse'
copy_data,'c4_vmag','c4_vmag'
copy_data,'B_vec_xyz_gse__C4_CP_FGM_SPIN','c4_bgse'
copy_data,'B_mag__C4_CP_FGM_SPIN','c4_bmag'


cotrans,'c4_bgse_smoothed','c4_bgsm_smoothed',/gse2gsm
split_vec,'c4_bgsm_smoothed'


rbsp_detrend,'*c4*',60.*smoothtime

tplot,'c4*'+'_smoothed'


;; tplot,['N_p__C4_PP_CIS',$        ;proton density
;; 'V_p_xyz_gse__C4_PP_CIS',$       ;proton bulk velocity
;; 'c4_vmag',$
;; 'B_vec_xyz_gse__C4_CP_FGM_SPIN',$
;; 'B_mag__C4_CP_FGM_SPIN',$
;; 'sc_pos_xyz_gse__C4_CP_FGM_SPIN']


rbsp_detrend,'N_p__C4_PP_CIS',60.*20.

options,'N_p__C4_PP_CIS_detrend','ytitle','Np C4!CCIS detrend'
;OVERALL DENSITY PLOT




;;--------------------------------------------------
;;RBSP data
;;--------------------------------------------------

rbsp_efw_dcfield_removal_crib,'a'

rbsp_detrend,'rbspa_mag_gsm_t96_ace_dif',60.*smoothtime
rbsp_detrend,'rbspa_mag_gsm_t96_ace_dif_smoothed',60.*40

rbsp_detrend,'rbspa_mag_gsm',60.*smoothtime
rbsp_detrend,'rbspa_mag_gsm_smoothed',60.*40.
ylim,'rbspa_mag_gsm_smoothed_detrend',-10,10

get_data,'rbspa_mag_gsm_t96_ace_dif_smoothed_detrend',data=bb
bmag = sqrt(bb.y[*,0]^2 + bb.y[*,1]^2 + bb.y[*,2]^2)
store_data,'rbspa_bmag',data={x:bb.x,y:bmag}

tplot,['rbspa_mag_gsm_smoothed_detrend','rbspa_mag_gsm_t96_ace_dif_smoothed']
tplot,'rbspa_mag_gsm_t96_ace_dif_smoothed_detrend'



path = '~/Desktop/Research/RBSP_hiss_precip/rbsp/'
fn = 'rbspa_efw-l3_20140106_v01.cdf'
cdf2tplot,path+fn

copy_data,'density','rbspa_density'
copy_data,'efield_inertial_frame_mgse','rbspa_efield_inertial_frame_mgse'
copy_data,'mlt_lshell_mlat','rbspa_mlt_lshell_mlat'


store_data,['density','flags_all','pos_gse','vel_gse','efield_inertial_frame_mgse','efield_corotation_frame_mgse','VcoroxB_mgse','VscxB_mgse','spinaxis_gse','Vavg','mlt_lshell_mlat','flags_charging_bias_eclipse'],/delete

rbsp_detrend,'rbspa_density',60.*smoothtime
rbsp_detrend,'rbspa_density_smoothed',60.*40.

tplot,['rbspa_density_smoothed_detrend',$
       'rbspa_efield_inertial_frame_mgse','rbspa_mlt_lshell_mlat',$
      'rbspa_mag_gsm_t96_ace_dif_smoothed_detrend','rbspa_bmag']



;;----------------
;;Find polarization of the double-peaked event

rbsp_detrend,'rbspa_mag_gsm_t96_ace_dif',60.*0.3
copy_data,'rbspa_mag_gsm_t96_ace_dif_smoothed','rbspa_mag_gsm_t96_ace_dif'
rbsp_detrend,'rbspa_mag_gsm_t96_ace_dif',60.*40.


get_data,'rbspa_mag_gsm_t96_ace_dif_detrend',data=bmag
store_data,'rbspa_mag_gsm_t96_ace_dif_detrend_MAG',$
           data={x:bmag.x,y:sqrt(bmag.y[*,0]^2+bmag.y[*,1]^2+bmag.y[*,2]^2)}

tplot,['rbspa_mag_gsm','rbspa_mag_gsm_t96_ace_dif_detrend','rbspa_density_smoothed_detrend','rbspa_mag_gsm_t96_ace_dif_detrend_MAG']

;;rotate to FA coord
rbsp_decimate,'rbspa_mag_gsm',level=4
v = rbsp_rotate_field_2_vec('rbspa_mag_gsm_t96_ace_dif_detrend','rbspa_mag_gsm')

tplot,'rbspa_mag_gsm_t96_ace_dif_detrend_FA_minvar'

;;----------------


fcals = rbsp_efw_get_gain_results()
fbinsL = fcals.cal_spec.freq_spec64L
fbinsH = fcals.cal_spec.freq_spec64H
bandw = fbinsH - fbinsL

rbsp_load_efw_spec,probe='a',type='calibrated',/pt


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
tplot,'Bfield_hissinta'







;;--------------------------------------------------
;;BARREL
;;--------------------------------------------------

date = '2014-01-06'
payloads = ['2K']
probe = 'a'

timespan, date
rbspx = 'rbsp' + probe

rbsp_load_barrel_lc,'2K',type='fspc'
rbsp_detrend,'FSPC*',60.*smoothtime

;;double-peaked event observed through FSPC2
;;total up the FSPC channels 

get_data,'FSPC1a_2K_smoothed',data=d1
get_data,'FSPC1b_2K_smoothed',data=d2
get_data,'FSPC1c_2K_smoothed',data=d3
get_data,'FSPC2_2K_smoothed',data=d4
dtots = d1.y + d2.y + d3.y + d4.y
store_data,'FSPC_totes',data={x:d1.x,y:dtots}

tplot,'FSPC_totes'





;;--------------------------------------------------
;;master plot
;;--------------------------------------------------

  tplot_options,'xmargin',[20.,16.]
  tplot_options,'ymargin',[3,9]
  tplot_options,'xticklen',0.08
  tplot_options,'yticklen',0.02
  tplot_options,'xthick',2
  tplot_options,'ythick',2
  tplot_options,'labflag',-1	


t0z = '2014-01-06/20:00'
t1z = '2014-01-06/22:00'
tlimit,t0z,t1z


;;time shift the ACE data
tshift = 60.*65

get_data,'ace_bmag_h3s_mfi_smoothed',data=dd
store_data,'ace_bmag_h3s_mfi_smoothed_shift',data={x:dd.x+tshift,y:dd.y}
get_data,'ace_BGSM_smoothed',data=dd
store_data,'ace_BGSM_smoothed_shift',data={x:dd.x+tshift,y:dd.y}
get_data,'ace_BRTN_smoothed',data=dd
store_data,'ace_BRTN_smoothed_shift',data={x:dd.x+tshift,y:dd.y}

get_data,'ace_Np',data=dd
store_data,'ace_Np_shift',data={x:dd.x+tshift,y:dd.y}
get_data,'ace_Tpr',data=dd
store_data,'ace_Tpr_shift',data={x:dd.x+tshift,y:dd.y}
get_data,'ace_press_proxy',data=dd
store_data,'ace_press_proxy_shift',data={x:dd.x+tshift,y:dd.y}


split_vec,'rbspa_mag_gsm_t96_ace_dif_smoothed_detrend'

split_vec,'ace_BGSM_smoothed_shift'
split_vec,'omni_BGSM'

ylim,'FSPC_totes',30,55
ylim,'omni_Timeshift',2000,4000
ylim,['tha_peim_density_smoothed','thd_peim_density_smoothed'],0.1,20,1



;;--------------------
;;see if the double-peaked event is originally a pressure-balanced
;;structure
;;--------------------


tlimit,'2014-01-06/15:00','2014-01-06/24:00'

ylim,'ace_press_proxy_shift',0.4,0.8
ylim,'ace_bmag_h3s_mfi_smoothed_shift',0,3
ylim,'ace_Np_shift',1,4
ylim,'ace_Tpr_shift',1d4,5d4
tplot,['ace_press_proxy_shift','ace_bmag_h3s_mfi_smoothed_shift','ace_Np_shift','ace_Tpr_shift']


stop




tplot,['ace_BGSM_smoothed_shift_z',$
       ;'ace_Np_shift',$
       'ace_Tpr_shift',$
       'c4_density_smoothed',$
       'tha_peim_density','thd_peim_density',$
       'g13_Bp_detrend',$
       'rbspa_mag_gsm_t96_ace_dif_smoothed_detrend_z',$
       'rbspa_density_smoothed_detrend',$
       'FSPC_totes',$
       'Bfield_hissinta',$
       'kyoto*']
timebar,['2014-01-06/20:51:40','2014-01-06/20:54:45','2014-01-06/20:57:40',$
         '2014-01-06/21:02:00']



;;Plot only Bz GSM components
ylim,'g13_Bp_smoothed_detrend',-3,3
tplot,['ace_BGSM_smoothed_shift_z',$
       'c4_bgsm_smoothed_z',$
       'thd_fgs_gsm_z',$
       'tha_fgs_gsm_z',$
       'g13_Bp_smoothed_detrend',$
       'rbspa_mag_gsm_t96_ace_dif_smoothed_detrend_z',$
       'FSPC_totes',$
       'Bfield_hissinta']


timebar,['2014-01-06/20:51:40','2014-01-06/20:54:45','2014-01-06/20:57:40',$
         '2014-01-06/21:02:00']


;;Plot only density
tplot,['ace_Np_shift',$
       'c4_density_smoothed',$
       'thd_peim_density',$
       'tha_peim_density',$
       'rbspa_density_smoothed_detrend',$
       'FSPC_totes',$
       'Bfield_hissinta']
timebar,['2014-01-06/20:51:40','2014-01-06/20:54:45','2014-01-06/20:57:40',$
         '2014-01-06/21:02:00']


tplot,['tha_peim_density_smoothed','thd_peim_density_smoothed',$
       'g13_Bp_smoothed_detrend']

timebar,['2014-01-06/20:51:40','2014-01-06/20:54:45','2014-01-06/20:57:40',$
         '2014-01-06/21:02:00']



end
