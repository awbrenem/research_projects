;Show that the chorus properties are similar over most of the apogee


rbsp_efw_init

;------
  sc = 'b'
  fb = '4'
  date = '2016-01-20'
  timespan,date


  t0 = time_double('2016-01-20/19:00:00')
  t1 = time_double('2016-01-20/21:00:00')

path = '~/Desktop/Research/RBSP_Firebird_microburst_conjunction_jan20/EMFISIS/'
cdf2tplot,path+'rbsp-'+sc+'_magnetometer_4sec-gse_emfisis-L3_20160120_v1.3.2.cdf'


;------
;Restore Scott's TS04 mapping of FB4 and RBSPa
path = '~/Desktop/Research/RBSP_Firebird_microburst_conjunction_jan20/TSY_files/'
tplot_restore,filenames=path+'FB4_T04s_L_and_MLTs_20160120.tplot'
; 1 fb4!CL-shell-t04s
; 2 fb4!Cequatorial-foot-MLT!Ct04s
; 3 fb4!Cnorth-foot-MLT!Ct04
; 4 fb4!Csouth-foot-MLT!Ct04

tplot_restore,filenames=path+'RBSP'+sc+'_T04s_L_and_MLTs_20160120.tplot'
; 5 RBSPa!CL-shell-t04s
; 6 RBSPa!Cequatorial-foot-MLT!Ct04s
; 7 RBSPa!Cnorth-foot-MLT!Ct04
; 8 RBSPa!Csouth-foot-MLT!Ct04


;tplot_restore,filenames=path+'RBSPb_T04s_L_and_MLTs_20160120.tplot'


;Interpolate these to a much higher cadence than once/min
times = dindgen(86400) + time_double('2016-01-20')

tinterpol_mxn,'fb4!CL-shell-t04s',times,newname='fb4!CL-shell-t04s'
tinterpol_mxn,'fb4!Cequatorial-foot-MLT!Ct04s',times,newname='fb4!Cequatorial-foot-MLT!Ct04s'
tinterpol_mxn,'RBSP'+sc+'!CL-shell-t04s',times,newname='RBSP'+sc+'!CL-shell-t04s'
tinterpol_mxn,'RBSP'+sc+'!Cequatorial-foot-MLT!Ct04s',times,newname='RBSP'+sc+'!Cequatorial-foot-MLT!Ct04s'


;get_data,'rbspa_state_lshell',fb_times,dtmp
zerolinefb = replicate(0.,n_elements(times))
store_data,'zerolinefb',times,zerolinefb


tplot,['fb4!Cequatorial-foot-MLT!Ct04s','RBSP'+sc+'!Cequatorial-foot-MLT!Ct04s']
tplot,['fb4!CL-shell-t04s','RBSP'+sc+'!CL-shell-t04s']


rbsp_efw_position_velocity_crib

;------
;First compare RBSP dipole with TS04 vals
dif_data,'rbsp'+sc+'_state_lshell','RBSP'+sc+'!CL-shell-t04s',newname='rbsp'+sc+'_ldiff'
dif_data,'rbsp'+sc+'_state_mlt','RBSP'+sc+'!Cequatorial-foot-MLT!Ct04s',newname='rbsp'+sc+'_mltdiff'
options,['rbsp'+sc+'_mltdiff','rbsp'+sc+'_ldiff'],constant=0
tplot,['rbsp'+sc+'_state_lshell','RBSP'+sc+'!CL-shell-t04s','rbsp'+sc+'_ldiff']
tplot,['rbsp'+sc+'_state_mlt','RBSP'+sc+'!Cequatorial-foot-MLT!Ct04s','rbsp'+sc+'_mltdiff']

tplot,['rbsp'+sc+'_ldiff','rbsp'+sc+'_mltdiff']


;------
;see how the FB4 MLT changes from the foot point to the equator
dif_data,'fb4!Cnorth-foot-MLT!Ct04','fb4!Cequatorial-foot-MLT!Ct04s',newname='fb4_mltdiff_foot2eq'
options,'fb4_mltdiff_foot2eq',constant=0
tplot,'fb4_mltdiff_foot2eq'

;------
;now compare FB4 values from Alex to our TS04 FB4 mapped values
dif_data,'fb4!CL-shell-t04s','alex_fb4_lshell',newname='fb4_ldiff'
dif_data,'fb4!Cnorth-foot-MLT!Ct04','alex_fb4_mlt',newname='fb4_mltdiff'
dif_data,'RBSP'+sc+'!Cequatorial-foot-MLT!Ct04s','alex_fb4_mlt',newname='fb4_mltdiff_mapped'


ylim,'fb4_ldiff',-5,5
options,['fb4_ldiff','fb4_mltdiff','fb4_mltdiff_mapped'],constant=0
tplot,['fb4!CL-shell-t04s','alex_fb4_lshell','fb4_ldiff']
ylim,['fb4_mltdiff','fb4_mltdiff_mapped'],-5,5
tplot,['fb4!Cnorth-foot-MLT!Ct04','alex_fb4_mlt','fb4_mltdiff','fb4_mltdiff_mapped']




;------
;Find conjunctions with dipole and TS04
;compare FB4 with RBSPa location
dif_data,'fb4!Cequatorial-foot-MLT!Ct04s','RBSP'+sc+'!Cequatorial-foot-MLT!Ct04s',newname='mltdiff_tsy04'
dif_data,'fb4!CL-shell-t04s','RBSP'+sc+'!CL-shell-t04s',newname='ldiff_tsy04'

dif_data,'alex_fb4_mlt','rbsp'+sc+'_state_mlt',newname='mltdiff_dipole'
dif_data,'alex_fb4_lshell','rbsp'+sc+'_state_lshell',newname='ldiff_dipole'

options,['mltdiff_tsy04','ldiff_tsy04',$
'mltdiff_dipole','ldiff_dipole'],constant=0

options,'ldiff_tsy04','ytitle','delta-lshell!CFB4-RBSP'+sc+'!CTSY04'
options,'mltdiff_tsy04','ytitle','delta-MLT!CFB4-RBSP'+sc+'!CTSY04'

options,'ldiff_dipole','ytitle','delta-lshell!CFB4-RBSP'+sc+'!Cdipole'
options,'mltdiff_dipole','ytitle','delta-MLT!CFB4-RBSP'+sc+'!Cdipole'

store_data,'lcomb',data=['ldiff_tsy04','ldiff_dipole']
store_data,'mltcomb',data=['mltdiff_tsy04','mltdiff_dipole']

options,'lcomb','colors',[0,250]
options,'mltcomb','colors',[0,250]

ylim,'*lcomb*',-6,6
ylim,'*mltcomb*',-5,5

options,'lcomb','ytitle','delta-lshell!CFB4-RBSP'+sc+'!CTSY04(black)!Cdipole(red)'
options,'mltcomb','ytitle','delta-MLT!CFB4-RBSP'+sc+'!CTSY04(black)!Cdipole(red)'


;Final plot showing Lshell and MLT separation
options,['mltdiff_tsy04','ldiff_tsy04'],'psym',-4
tplot,['mltdiff_tsy04','ldiff_tsy04']


path = '/Users/aaronbreneman/Desktop/Research/RBSP_Firebird_microburst_conjunction_jan20/EFW/'
fn = 'rbsp'+sc+'_efw-l2_spec_20160120_v01.cdf'
cdf2tplot,path+fn

options,'spec64_e12ac','spec',1
options,'spec64_scmw','spec',1
zlim,'spec64_e12ac',0.01,100,1
ylim,'spec64_e12ac',10,5000,1
ylim,'spec64_scmw',10,5000,1
zlim,'spec64_scmw',1d-6,1d-4,1

path = '/Users/aaronbreneman/Desktop/Research/RBSP_Firebird_microburst_conjunction_jan20/EMFISIS/'
;fn = 'rbsp-a_wna-survey_emfisis-L4_20140120_v1.5.1.cdf'
fn = 'rbsp-'+sc+'_wna-survey_emfisis-L4_20160120_v1.5.1.cdf'
cdf2tplot,path+fn

;min magnetic field value (used so I can see SVD plot values)
bmagmin = 5d-8

get_data,'bsum',t,d,v
store_data,'bsum',t,d,reform(v)
options,'bsum','spec',1
zlim,'bsum',1d-11,1d-5,1
bbad = where(d le bmagmin)


get_data,'esum',t,d,v
store_data,'esum',t,d,reform(v)
options,'esum','spec',1
zlim,'esum',1d-7,1d0,1

get_data,'thsvd',t,d,v
if bbad[0] ne -1 then d[bbad] = !values.f_nan
store_data,'thsvd2',t,d,reform(v)
options,'thsvd2','spec',1
zlim,'thsvd2',0,50,0

get_data,'phsvd',t,d,v
if bbad[0] ne -1 then d[bbad] = !values.f_nan
store_data,'phsvd2',t,d,reform(v)
options,'phsvd2','spec',1
zlim,'phsvd2',0,180,0


get_data,'bsum',tt,dd,vv
tinterpol_mxn,'Magnitude',tt,newname='Magnitude'
get_data,'Magnitude',t,b
store_data,'fce',t,28.*b
store_data,'fce_2',t,28.*b/2.
store_data,'fce_01',t,28.*b*0.1

options,['fce','fce_2','fce_01'],'spec',0
options,['fce','fce_2','fce_01'],'thick',3
store_data,'bcomb',data=['bsum','fce','fce_2','fce_01']

yspec = [10,4000]
ylim,['fce','fce_2','fce_01'],10,4000,1
ylim,'bsum',yspec,1
ylim,'esum',yspec,1
ylim,'thsvd2',yspec,1
ylim,'phsvd2',yspec,1
ylim,'mltdiff_tsy04',-5,5
ylim,'ldiff_tsy04',-2,2
ylim,'RBSP'+sc+'!CL-shell-t04s',5,6
ylim,'RBSP'+sc+'!Cequatorial-foot-MLT!Ct04s',10,12

ylim,'bcomb',yspec,1
zlim,'bcomb',1d-7,1d-4,1

tplot,['bcomb','thsvd2']
tplot,['RBSP'+sc+'!CL-shell-t04s','RBSP'+sc+'!Cequatorial-foot-MLT!Ct04s','bcomb','esum','thsvd2']
