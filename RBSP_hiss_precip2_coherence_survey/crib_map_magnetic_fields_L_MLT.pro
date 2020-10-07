;Crib sheet for mapping the locations of THEMIS A and BARREL 2X to L, MLT.
;uses aaron_map_with_t04.pro. This program takes GSM coordinates
;for a sc and traces the TS04 field line to the equator and footpoints.


timespan,'2014-01-11',2,/days
thm_load_state,probe='a'

;GEI coordinates
tplot,'tha_state_pos'

;Put into GSM coord
cotrans,'tha_state_pos','tha_state_pos_gse',/gei2gse
cotrans,'tha_state_pos_gse','tha_state_pos_gsm',/gse2gsm



ts = time_double(['2014-01-11/20:00','2014-01-11/23:59:59'])
timespan,ts[0],ts[1]-ts[0],/seconds
;model = 't04'
;model = 't96'
;model = 't01'

dur = ts[1]-ts[0]
storm_start = time_string(ts[0])



;------------------
;------------------
;------------------
;****UNDER CONSTRUCTION
;Get dipole tilt angle. Needed for the TSY08 model

get_data,'tha_state_pos_gsm',ut,dd
ts = time_string(ut)
yr = strmid(ts,0,4)
mo = strmid(ts,5,2)
dy = strmid(ts,8,2)
hr = strmid(ts,11,2)
mi = strmid(ts,14,2)
sec = strmid(ts,17,2)
msc = sec
msc[*] = 0.


tilt = fltarr(n_elements(sec))
for i=0,n_elements(ut)-1 do begin $
  geopack_recalc_08, yr[i], mo[i], dy[i], hr[i], mi[i], sec[i]+msc[i]*0.001d, /date,tilt=tt & $
  tilt[i] = tt
endfor

store_data,'tilt',ut,tilt

stop

;****UNDER CONSTRUCTION
;------------------
;------------------
;------------------

kp = 2.   ;https://www.spaceweatherlive.com/en/archive



;pro aaron_map_with_tsy,model,storm_start,dur,sc,gsm_coord,Kpval,R0=R0,rlim=rlim
timespan,'2014-01-11',2,/days



aaron_map_with_tsy,'t01',time_double('2014-01-11/20:00'),3600.*4.,'THA','tha_state_pos_gsm'
aaron_map_with_tsy,'t89',time_double('2014-01-11/20:00'),3600.*4.,'THA','tha_state_pos_gsm',kp
aaron_map_with_tsy,'none',time_double('2014-01-11/20:00'),3600.*4.,'THA','tha_state_pos_gsm',kp
aaron_map_with_tsy,'t04',time_double('2014-01-11/12:00'),24.*3600.,'THA','tha_state_pos_gsm'









;Now map the BARREL balloons to magnetic equator

load_barrel_lc,'2X',type='ephm'

get_data,'alt_2X',data=alts & alts = alts.y
get_data,'lat_2X',data=lats & lats = lats.y
get_data,'lon_2X',data=lons & lons = lons.y



fileroot = '/Users/aaronbreneman/Desktop/Research/RBSP_Firebird_microburst_conjunction_jan20/FIREBIRD/'
tplot_restore,filenames=fileroot+'fb4_coord_jan20_accurate.tplot'

gsm_coord = 'fb4_gsm'
get_data,gsm_coord,tt,dd

;Apply time shift
store_data,gsm_coord,tt + 4.1,dd*6370.
sc = 'fb4'


tinterpol_mxn,'fb4_gsm','rbspa_state_pos_gsm',newname='fb4_gsm'

aaron_map_with_tsy,model,storm_start,dur,'FB4',gsm_coord


tplot,['FB4!CL-shell-'+model,$
  'FB4!Cequatorial-foot-MLT!C'+model,$
  'FB4!Cnorth-foot-MLT!C'+model,$
  'FB4!Csouth-foot-MLT!C'+model]



  ;Save and restore specific files
fileroot = '~/Desktop/'
if model eq 't96' then tplot_save,['RBSPa!CL-shell-'+model,'FB4!CL-shell-'+model,$
  'FB4!Cequatorial-foot-MLT!C'+model,'RBSPa!Cequatorial-foot-MLT!C'+model],$
    filename=fileroot+'rbspa_fb4_ts96_lshell_MLT_hires'    ;don't add .tplot
if model eq 't04' then tplot_save,['RBSPa!CL-shell-'+model,'FB4!CL-shell-'+model,$
  'FB4!Cequatorial-foot-MLT!C'+model,'RBSPa!Cequatorial-foot-MLT!C'+model],$
    filename=fileroot+'rbspa_fb4_ts04_lshell_MLT_hires'    ;don't add .tplot



;tinterpol_mxn,'RBSPa!CL-shell-'+model,'rbspa_fbk1_7pk_5_smoothed',newname='rbspaL_tmp',/spline
;tinterpol_mxn,'FB4!CL-shell-'+model,'rbspa_fbk1_7pk_5_smoothed',newname='fb4L_tmp',/spline
;tplot,['rbspaL_tmp','fb4L_tmp']

;tt = time_double('2016-01-20/19:43:54.600')
;tt = time_double('2016-01-20/19:43:58.000')
;tt = time_double('2016-01-20/19:44:00.800')
;tt = time_double('2016-01-20/19:44:06.200')
;tt = time_double('2016-01-20/19:44:07.000')
;tt = time_double('2016-01-20/19:44:08.000')
;print,tsample('fb4L_tmp',tt,times=tms)



;La = 5.770
;Lf = 5.248, 5.150, 4.902, 4.876
;dLf = 0.098, 0.248, 0.026

tt = time_double('2016-01-20/19:43:54.600')
tt = time_double('2016-01-20/19:44:08.000')
;0.372 max

tt = time_double('2016-01-20/19:43:58.000')
tt = time_double('2016-01-20/19:44:07.000')
;0.248 mid

;min
tt = time_double('2016-01-20/19:44:00.800')
tt = time_double('2016-01-20/19:44:06.200')
;5.072 - 4.922 = 0.15




;Load dipole Lshell
rbsp_efw_position_velocity_crib



dif_data,'rbspa_state_lshell','alex_fb4_lshell',newname='deltaLsimple'
dif_data,'rbspa_state_mlt','alex_fb4_mlt',newname='deltaMLTsimple'


dif_data,'RBSPa!CL-shell-'+model,'FB4!CL-shell-'+model,newname='deltaL_'+model
dif_data,'RBSPa!Cequatorial-foot-MLT!C'+model,'FB4!Cequatorial-foot-MLT!C'+model,newname='deltaMLT_'+model
if model eq 't04' then options,'deltaL_'+model,'ytitle','RBSPaL-FB4L (TS04)'
if model eq 't96' then options,'deltaL_'+model,'ytitle','RBSPaL-FB4L (T96)'
if model eq 't04' then options,'deltaMLT_'+model,'ytitle','RBSPaMLT-FB4MLT!C(Equatorial_mapped!C'+'_TS04)'
if model eq 't96' then options,'deltaMLT_'+model,'ytitle','RBSPaMLT-FB4MLT!C(Equatorial_mapped!C'+'_TS96)'





options,['deltaMLT_'+model,'deltaL_'+model],'constant',0
if model eq 't04' then tplot_options,'title','from call_aaron_map_with_t04.pro'
if model eq 't96' then tplot_options,'title','from call_aaron_map_with_t96.pro'
tplot,['deltaL_'+model,'deltaMLT_'+model]
timebar,['2016-01-20/19:43:55','2016-01-20/19:44:05']

store_data,'deltaLcomb_'+model,data=['deltaL_'+model,'deltaLsimple']
options,'deltaLcomb_'+model,'colors',[0,250]
;tplot,'deltaLcomb'
store_data,'deltaMLTcomb_'+model,data=['deltaMLT_'+model,'deltaMLTsimple']
options,'deltaMLTcomb_'+model,'colors',[0,250]
tplot,['deltaLcomb_'+model,'deltaMLTcomb_'+model]
timebar,['2016-01-20/19:43:55','2016-01-20/19:44:05']


tplot,['RBSPa!CL-shell-'+model,'FB4!CL-shell-'+model,'deltaL_'+model]


tplot,['RBSPa!CL-shell-'+model,'RBSPa!CMLT-'+model,'FB4!CL-shell-'+model,$
  'deltaL_'+model,'deltaMLT_'+model]


  store_data,'deltaL_comb',data=['deltaL_t04s','deltaL_t96']
  store_data,'deltaMLT_comb',data=['deltaMLT_t04s','deltaMLT_t96']
  options,'deltaL_comb','colors',[0,250,50]
  options,'deltaMLT_comb','colors',[0,250,50]

ylim,'deltaL_comb',-3,2
ylim,'deltaMLT_comb',-0.2,0.2
options,'deltaL_comb','ytitle','RBSPa deltaL!CRBSPa-FB4!CBlack=TSY04, Red=T96'
options,'deltaMLT_comb','ytitle','RBSPa deltaMLT!CRBSPa-FB4!CBlack=TSY04, Red=T96'
tplot,['deltaL_comb','deltaMLT_comb']
timebar,['2016-01-20/19:43:55','2016-01-20/19:44:05']




;0.34 - 0.89 = 0.55
stop

end
