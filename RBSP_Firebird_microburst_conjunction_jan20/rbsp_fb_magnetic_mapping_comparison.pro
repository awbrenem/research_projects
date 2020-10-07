;Use the TS04 model to find out the most accurate conjunction b/t RBSPA and FB4
;for the Jan20th chorus/microburst correlations at 19:44 UT

rbsp_efw_init

;------
  sc = 'a'
  fb = '4'
  date = '2016-01-20'
  timespan,date


  t0 = time_double('2016-01-20/19:00:00')
  t1 = time_double('2016-01-20/21:00:00')


;------
;Load Firebird ASCII files from Alex (Original version. Very preliminary and not accurate)
;These are just used for comparison with TS04 Results
;------
  fname = 'FU4_LLA_LShell_ToDate_2016-01-14_2016-02-14_1min.csv'
  path = '/Users/aaronbreneman/Desktop/Research/OTHER/Stuff_for_other_people/Crew_Alex/FIREBIRD_RBSP_campaign/'

  ft = [7,4,4,4,4]
  fn = ['time','lat','lon','alt','lshell']
  fl = [0,24,31,39,50]
  fg = [0,1,2,3,4]

  template = {version:1.,$
              datastart:1L,$
              delimiter:44B,$
              missingvalue:!values.f_nan,$
              commentsymbol:'',$
              fieldcount:5,$
              fieldtypes:ft,$
              fieldnames:fn,$
              fieldlocations:fl,$
              fieldgroups:fg}

  x = read_ascii(path + fname,template=template)

  glats = x.lat
  glons = x.lon
  times = time_double(x.time)

  xgeo = (x.alt + 6370.)*cos(!dtor*glats)*sin(!dtor*glons)
  ygeo = (x.alt + 6370.)*cos(!dtor*glats)*cos(!dtor*glons)
  zgeo = (x.alt + 6370.)*sin(!dtor*glats)


  store_data,'alex_fb4_lshell',data={x:times,y:x.lshell}
  store_data,'alex_fb4_geo',$
             data={x:times,y:[[xgeo],[ygeo],[zgeo]]}


;Calculate MLT
  cotrans,'alex_fb4_geo','alex_fb4_gei',/geo2gei
  cotrans,'alex_fb4_gei','alex_fb4_gse',/gei2gse
  get_data,'alex_fb4_gse',data=pos_gse_a

  angle_tmp = atan(pos_gse_a.y[*,1],pos_gse_a.y[*,0])/!dtor
  goo = where(angle_tmp lt 0.)
  if goo[0] ne -1 then angle_tmp[goo] = 360. - abs(angle_tmp[goo])
  angle_rad_a = angle_tmp * 12/180. + 12.
  goo = where(angle_rad_a ge 24.)
  if goo[0] ne -1 then angle_rad_a[goo] = angle_rad_a[goo] - 24

  store_data,'alex_fb4_mlt',pos_gse_a.x,angle_rad_a
  cotrans,'alex_fb4_geo','tmp',/geo2gei
  cotrans,'tmp','alex_fb4_gse',/gei2gse







;---------------------------------------------------------------
  rbsp_efw_position_velocity_crib

;For Lunjin
;  0fb4!CL-shell-t0:       2016-01-20/19:44:00      5.133
;  1fb4!Cequatorial MLT:       2016-01-20/19:44:00      10.78
;  2fb4!Cnorth-foot MLT:       2016-01-20/19:44:00      13.88
;  3fb4!Csouth-foot MLT:       2016-01-20/19:44:00      9.290

;------
;Restore Scott's TS04 mapping of FB4 and RBSPa
path = '~/Desktop/Research/RBSP_Firebird_microburst_conjunction_jan20/TSY_files/'
tplot_restore,filenames=path+'FB4_T04s_L_and_MLTs_20160120.tplot'
; 1 fb4!CL-shell-t04s
; 2 fb4!Cequatorial-foot-MLT!Ct04s
; 3 fb4!Cnorth-foot-MLT!Ct04
; 4 fb4!Csouth-foot-MLT!Ct04

tplot_restore,filenames=path+'RBSPa_T04s_L_and_MLTs_20160120.tplot'
; 5 RBSPa!CL-shell-t04s
; 6 RBSPa!Cequatorial-foot-MLT!Ct04s
; 7 RBSPa!Cnorth-foot-MLT!Ct04
; 8 RBSPa!Csouth-foot-MLT!Ct04


;tplot_restore,filenames=path+'RBSPb_T04s_L_and_MLTs_20160120.tplot'


;Interpolate these to a much higher cadence than once/min
times = dindgen(86400) + time_double('2016-01-20')

tinterpol_mxn,'fb4!CL-shell-t04s',times,newname='fb4!CL-shell-t04s'
tinterpol_mxn,'fb4!Cequatorial-foot-MLT!Ct04s',times,newname='fb4!Cequatorial-foot-MLT!Ct04s'
tinterpol_mxn,'RBSPa!CL-shell-t04s',times,newname='RBSPa!CL-shell-t04s'
tinterpol_mxn,'RBSPa!Cequatorial-foot-MLT!Ct04s',times,newname='RBSPa!Cequatorial-foot-MLT!Ct04s'


;get_data,'rbspa_state_lshell',fb_times,dtmp
zerolinefb = replicate(0.,n_elements(times))
store_data,'zerolinefb',fb_times,zerolinefb



tplot,['fb4!Cequatorial-foot-MLT!Ct04s','RBSPa!Cequatorial-foot-MLT!Ct04s']
tplot,['fb4!CL-shell-t04s','RBSPa!CL-shell-t04s']



;------
;First compare RBSP dipole with TS04 vals
;store_data,'lcomp_dip_t04',data=['rbspa_state_lshell','RBSPa!CL-shell-t04s']
dif_data,'rbspa_state_lshell','RBSPa!CL-shell-t04s',newname='rbspa_ldiff'
dif_data,'rbspa_state_mlt','RBSPa!Cequatorial-foot-MLT!Ct04s',newname='rbspa_mltdiff'
options,['rbspa_mltdiff','rbspa_ldiff'],constant=0
tplot,['rbspa_state_lshell','RBSPa!CL-shell-t04s','rbspa_ldiff']
tplot,['rbspa_state_mlt','RBSPa!Cequatorial-foot-MLT!Ct04s','rbspa_mltdiff']

tplot,['rbspa_ldiff','rbspa_mltdiff']


;------
;see how the FB4 MLT changes from the foot point to the equator
dif_data,'fb4!Cnorth-foot-MLT!Ct04','fb4!Cequatorial-foot-MLT!Ct04s',newname='fb4_mltdiff_foot2eq'
options,'fb4_mltdiff_foot2eq',constant=0
tplot,'fb4_mltdiff_foot2eq'

;------
;now compare FB4 values from Alex to our TS04 FB4 mapped values
dif_data,'fb4!CL-shell-t04s','alex_fb4_lshell',newname='fb4_ldiff'
dif_data,'fb4!Cnorth-foot-MLT!Ct04','alex_fb4_mlt',newname='fb4_mltdiff'
dif_data,'RBSPa!Cequatorial-foot-MLT!Ct04s','alex_fb4_mlt',newname='fb4_mltdiff_mapped'


ylim,'fb4_ldiff',-5,5
options,['fb4_ldiff','fb4_mltdiff','fb4_mltdiff_mapped'],constant=0
tplot,['fb4!CL-shell-t04s','alex_fb4_lshell','fb4_ldiff']
ylim,['fb4_mltdiff','fb4_mltdiff_mapped'],-5,5
tplot,['fb4!Cnorth-foot-MLT!Ct04','alex_fb4_mlt','fb4_mltdiff','fb4_mltdiff_mapped']




;------
;Find conjunctions with dipole and TS04
;compare FB4 with RBSPa location
dif_data,'fb4!Cequatorial-foot-MLT!Ct04s','RBSPa!Cequatorial-foot-MLT!Ct04s',newname='mltdiff_tsy04'
dif_data,'fb4!CL-shell-t04s','RBSPa!CL-shell-t04s',newname='ldiff_tsy04'

dif_data,'alex_fb4_mlt','rbspa_state_mlt',newname='mltdiff_dipole'
dif_data,'alex_fb4_lshell','rbspa_state_lshell',newname='ldiff_dipole'

options,['mltdiff_tsy04','ldiff_tsy04',$
'mltdiff_dipole','ldiff_dipole'],constant=0

options,'ldiff_tsy04','ytitle','delta-lshell!CFB4-RBSPa!CTSY04'
options,'mltdiff_tsy04','ytitle','delta-MLT!CFB4-RBSPa!CTSY04'

options,'ldiff_dipole','ytitle','delta-lshell!CFB4-RBSPa!Cdipole'
options,'mltdiff_dipole','ytitle','delta-MLT!CFB4-RBSPa!Cdipole'

store_data,'lcomb',data=['ldiff_tsy04','ldiff_dipole']
store_data,'mltcomb',data=['mltdiff_tsy04','mltdiff_dipole']

options,'lcomb','colors',[0,250]
options,'mltcomb','colors',[0,250]

ylim,'*lcomb*',-6,6
ylim,'*mltcomb*',-5,5

options,'lcomb','ytitle','delta-lshell!CFB4-RBSPa!CTSY04(black)!Cdipole(red)'
options,'mltcomb','ytitle','delta-MLT!CFB4-RBSPa!CTSY04(black)!Cdipole(red)'


;Final plot showing Lshell and MLT separation
options,['mltdiff_tsy04','ldiff_tsy04'],'psym',-4
tplot,['mltdiff_tsy04','ldiff_tsy04']


path = '/Users/aaronbreneman/Desktop/Research/RBSP_Firebird_microburst_conjunction_jan20/EFW/'
fn = 'rbspa_efw-l2_spec_20160120_v01.cdf'
cdf2tplot,path+fn

options,'spec64_e12ac','spec',1
options,'spec64_scmw','spec',1
zlim,'spec64_e12ac',0.01,100,1
ylim,'spec64_e12ac',10,5000,1
ylim,'spec64_scmw',10,5000,1
zlim,'spec64_scmw',1d-6,1d-4,1

path = '/Users/aaronbreneman/Desktop/Research/RBSP_Firebird_microburst_conjunction_jan20/EMFISIS/'
;fn = 'rbsp-a_wna-survey_emfisis-L4_20140120_v1.5.1.cdf'
fn = 'rbsp-a_wna-survey_emfisis-L4_20160120_v1.5.1.cdf'
cdf2tplot,path+fn

get_data,'bsum',t,d,v
store_data,'bsum',t,d,reform(v)
ylim,'bsum',10,10000,1
options,'bsum','spec',1
zlim,'bsum',1d-10,1d-5,1

get_data,'esum',t,d,v
store_data,'esum',t,d,reform(v)
ylim,'esum',10,10000,1
options,'esum','spec',1
zlim,'esum',1d-8,1d4,1

get_data,'thsvd',t,d,v
store_data,'thsvd',t,d,reform(v)
ylim,'thsvd',10,10000,1
options,'thsvd','spec',1
zlim,'thsvd',0,90,0

ylim,'mltdiff_tsy04',-5,5
ylim,'ldiff_tsy04',-2,2

tplot,['RBSPa!CL-shell-t04s','RBSPa!Cequatorial-foot-MLT!Ct04s','bsum','esum','thsvd']

stop


;Compare model magnetic field to actual magnetic field to see how accurate it is
cdf2tplot,'~/Desktop/Research/RBSP_Firebird_microburst_conjunction_jan20/EMFISIS/rbsp-a_magnetometer_4sec-gse_emfisis-L3_20160120_v1.3.2.cdf'



sc = 'a'
ts = time_double(['2016-01-19/22:00','2016-01-20/23:59:59'])
timespan,ts[0],ts[1]-ts[0],/seconds
;model = 't04s'
model = 't04s'
;model = 't96'


;load RBSP gse positions
rbsp_load_spice_state,probe=sc,coord='gse';,/no_spice_load
cotrans,'rbsp'+sc+'_state_pos_gse','rbsp'+sc+'_state_pos_gsm',/GSE2GSM
pos_gsm = 'rbsp'+sc+'_state_pos_gsm'


get_field_model, pos_gsm, model, ts, source='wind'








;Compare the vector Bo
tplot,['B_t04s_gse','Mag']
;Compare the magnitude_minus_modelmagnitude
get_data,'B_t04s_gse',data=bo
bmag = sqrt(bo.y[*,0]^2 + bo.y[*,1]^2 + bo.y[*,2]^2)
store_data,'B_t04s_mag',bo.x,bmag

store_data,'Bmag_comb',data=['B_t04s_mag','Magnitude']
options,'Bmag_comb','colors',[0,250]
tplot,'Bmag_comb'


stop

end
