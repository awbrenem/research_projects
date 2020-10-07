;calls aaron_map_with_tsy to create Tsyganenko field mapped L, MLT, ilat, etc,
;for FIREBIRD and RBSP conjunctions.
;Uses the FIREBIRD official L2 files.


;pro tplot_save_tsy_mapping_firebird_rbsp

rbsp_efw_init



;--------------
;input for various TSY models
;--------------

;--------------
;;FIREBIRD APPEARS TO BE ON OPEN FIELD LINES
;date = '2017-12-04'
;timespan,date
;fbsat = '3'
;rbsp = 'a'
;;http://wdc.kugi.kyoto-u.ac.jp/cgi-bin/kp-cgi
;;20171204 0 0 2-1 2+3 3+4 15+  0  0  6  4  9 15 18 27 10
;Kp=1 ;for T89 model
;storm_start = '2017-12-04/16:00'
;storm_duration = 12.*3600.
;t0z = '2017-12-04/12:00:10'
;t1z = '2017-12-04/12:06:00'
;--------------
;date = '2016-01-20'
;timespan,date
;fbsat = '4'
;rbsp = 'a'
;http://wdc.kugi.kyoto-u.ac.jp/cgi-bin/kp-cgi
;20160120 0+2 3+4+5-5-5-4+28+  2  7 18 32 39 39 39 32 26
;Kp=5 ;for T89 model
;storm_start = '2016-01-20/' + '/06:00'
;storm_duration = 3600.*18.
;t0z = date + '/19:43:20'
;t1z = date + '/19:44:40'
;--------------------
;date = '2017-11-21'
;timespan,date
;fbsat = '3'
;rbsp = 'a'
;;20171121 4+5 5-3+3 4-4-4-31+ 32 48 39 18 15 22 22 22 27
;Kp = 4.
;storm_start = '2017-11-21/02:00'
;storm_duration = 86400.*2.
;;t0z = date + '/20:01'
;;t1z = date + '/20:05'
;t0z = date + '/19:59'
;t1z = date + '/20:08'
;--------------
;date = '2017-11-21'
;timespan,date
;fbsat = '4'
;rbsp = 'a'
;;20171121 4+5 5-3+3 4-4-4-31+ 32 48 39 18 15 22 22 22 27
;Kp = 4.
;storm_start = '2017-11-21/02:00'
;storm_duration = 86400.*2.
;t0z = date + '/19:47'
;t1z = date + '/19:54'
;--------------
;date = '2017-12-05'
;timespan,date
;fbsat = '4'
;rbsp = 'a'
;;http://wdc.kugi.kyoto-u.ac.jp/cgi-bin/kp-cgi
;;20160120 0+2 3+4+5-5-5-4+28+  2  7 18 32 39 39 39 32 26
;Kp=5 ;for T89 model
;;storm_start = '2017-12-04/' + '/16:00'
;;storm_duration = 3600.*33.
;storm_start = '2017-12-05/' + '/04:00'
;storm_duration = 3600.*23.
;t0z = date + '/22:45:00'
;t1z = date + '/22:49:40'
;--------------
;date = '2017-07-09'
;timespan,date
;fbsat = '4'
;rbsp = 'a'
;;20170709 5 3 2 5+2 3 4 3+28- 48 15  7 56  7 15 27 18 24
;Kp = 4.
;storm_start = '2017-07-09/00:00'
;storm_duration = 86400.
;t0z = date + '/21:27'
;t1z = date + '/21:31'
;----------------
date = '2016-01-21'
timespan,date
fbsat = '3'
rbsp = 'b'
;20170709 5 3 2 5+2 3 4 3+28- 48 15  7 56  7 15 27 18 24
Kp = 4.
storm_start = '2016-01-21/00:00'
storm_duration = 86400.
t0z = date + '/22:44'
t1z = date + '/22:49'



;Extended for RBSPa and RBSPb comparison
;date = '2017-11-21'
;timespan,date
;rbsp = 'a'
;;20171121 4+5 5-3+3 4-4-4-31+ 32 48 39 18 15 22 22 22 27
;Kp = 4.
;storm_start = '2017-11-21/02:00'
;storm_duration = 86400.*2.
;t0z = date + '/18:30'
;t1z = date + '/20:40'





;Can't have Kp=0
if Kp eq 0. then Kp = 1.



;times near conjunction
datestr = strmid(date,0,4)+strmid(date,5,2)+strmid(date,8,2)
t0zstr = strmid(t0z,11,2)+strmid(t0z,14,2)+strmid(t0z,17,2)
t1zstr = strmid(t1z,11,2)+strmid(t1z,14,2)+strmid(t1z,17,2)


fbsatgoo = fbsat
fileroot = '~/Desktop/Research/RBSP_Firebird_microburst_conjunctions_all/data/'
firebird_load_data,fbsatgoo


;Get reduced dataset
lats = tsample('fu'+fbsat+'_fb_geolat_from_hiresfile',time_double([t0z,t1z]),times=times)
lons = tsample('fu'+fbsat+'_fb_geolon_from_hiresfile',time_double([t0z,t1z]))
alts = tsample('fu'+fbsat+'_fb_alt_from_hiresfile',time_double([t0z,t1z]))
;lats = tsample('fb_lat',time_double([t0z,t1z]),times=times)
;lons = tsample('fb_lon',time_double([t0z,t1z]))
;alts = tsample('fb_alt',time_double([t0z,t1z]))


;Calculate geographic x,y,z coord. These are used as input to
;cotrans to get GSM coord, required for TSY mapping.

  xgeo = (alts + 6370.)*cos(!dtor*lats)*cos(!dtor*lons)
  ygeo = (alts + 6370.)*cos(!dtor*lats)*sin(!dtor*lons)
  zgeo = (alts + 6370.)*sin(!dtor*lats)

  store_data,'fb_geo',data={x:times,y:[[xgeo],[ygeo],[zgeo]]}



;Calculate MLT
  cotrans,'fb_geo','fb_gei',/geo2gei
  cotrans,'fb_gei','fb_gse',/gei2gse
  cotrans,'fb_gse','fb_gsm',/gse2gsm
  cotrans,'fb_gsm','fb_sm',/gsm2sm



;Altitude of FIREBIRD
R0 = (6370.+500.)   ;/6370.
rlim = 10.*6370.

model = 't89'
aaron_map_with_tsy,model,storm_start,storm_duration,'FB'+fbsat,'fb_gsm',Kp,R0=R0,rlim=rlim
savevars = ['FB'+fbsat+'!CL-shell-t89','FB'+fbsat+'!Cnorth-foot-ILAT!Ct89',$
'FB'+fbsat+'!Cnorth-foot-MLT!Ct89','FB'+fbsat+'!Csouth-foot-ILAT!Ct89',$
'FB'+fbsat+'!Csouth-foot-MLT!Ct89','FB'+fbsat+'!Cequatorial-foot-ILAT!Ct89',$
'FB'+fbsat+'!Cequatorial-foot-MLT!Ct89']
tplot_save,savevars,filename=fileroot+'FB'+fbsat+'_'+model+'_Kp='+strtrim(Kp,2)+'_'+datestr+'_'+t0zstr+'-'+t1zstr
savevars = ''


model = 't01'
aaron_map_with_tsy,model,storm_start,storm_duration,'FB'+fbsat,'fb_gsm',R0=R0,rlim=rlim
savevars = ['FB'+fbsat+'!CL-shell-t01','FB'+fbsat+'!Cnorth-foot-ILAT!Ct01',$
'FB'+fbsat+'!Cnorth-foot-MLT!Ct01','FB'+fbsat+'!Csouth-foot-ILAT!Ct01',$
'FB'+fbsat+'!Csouth-foot-MLT!Ct01','FB'+fbsat+'!Cequatorial-foot-ILAT!Ct01',$
'FB'+fbsat+'!Cequatorial-foot-MLT!Ct01']
tplot_save,savevars,filename=fileroot+'FB'+fbsat+'_'+model+'_'+datestr+'_'+t0zstr+'-'+t1zstr
savevars = ''


model = 't04'
aaron_map_with_tsy,model,storm_start,storm_duration,'FB'+fbsat,'fb_gsm',R0=R0,rlim=rlim
savevars = ['FB'+fbsat+'!CL-shell-t04s','FB'+fbsat+'!Cnorth-foot-ILAT!Ct04s',$
'FB'+fbsat+'!Cnorth-foot-MLT!Ct04s','FB'+fbsat+'!Csouth-foot-ILAT!Ct04s',$
'FB'+fbsat+'!Csouth-foot-MLT!Ct04s','FB'+fbsat+'!Cequatorial-foot-ILAT!Ct04s',$
'FB'+fbsat+'!Cequatorial-foot-MLT!Ct04s']
tplot_save,savevars,filename=fileroot+'FB'+fbsat+'_'+model+'_'+datestr+'_'+t0zstr+'-'+t1zstr
savevars = ''


;------------------------------------------------
;Now do the same for RBSP
;------------------------------------------------

store_data,tnames(),/delete
rbsp_efw_position_velocity_crib


model = 't89'
aaron_map_with_tsy,model,storm_start,storm_duration,'RBSP'+rbsp,'rbsp'+rbsp+'_state_pos_gsm',Kp,R0=R0,rlim=rlim
savevars = ['RBSP'+rbsp+'!CL-shell-t89','RBSP'+rbsp+'!Cnorth-foot-ILAT!Ct89',$
'RBSP'+rbsp+'!Cnorth-foot-MLT!Ct89','RBSP'+rbsp+'!Csouth-foot-ILAT!Ct89',$
'RBSP'+rbsp+'!Csouth-foot-MLT!Ct89','RBSP'+rbsp+'!Cequatorial-foot-ILAT!Ct89',$
'RBSP'+rbsp+'!Cequatorial-foot-MLT!Ct89']
tplot_save,savevars,filename=fileroot+'RBSP'+rbsp+'_'+model+'_Kp='+strtrim(Kp,2)+'_'+datestr+'_'+t0zstr+'-'+t1zstr
savevars = ''


model = 't01'
aaron_map_with_tsy,model,storm_start,storm_duration,'RBSP'+rbsp,'rbsp'+rbsp+'_state_pos_gsm',R0=R0,rlim=rlim
savevars = ['RBSP'+rbsp+'!CL-shell-t01','RBSP'+rbsp+'!Cnorth-foot-ILAT!Ct01',$
'RBSP'+rbsp+'!Cnorth-foot-MLT!Ct01','RBSP'+rbsp+'!Csouth-foot-ILAT!Ct01',$
'RBSP'+rbsp+'!Csouth-foot-MLT!Ct01','RBSP'+rbsp+'!Cequatorial-foot-ILAT!Ct01',$
'RBSP'+rbsp+'!Cequatorial-foot-MLT!Ct01']
tplot_save,savevars,filename=fileroot+'RBSP'+rbsp+'_'+model+'_'+datestr+'_'+t0zstr+'-'+t1zstr
savevars = ''

model = 't04'
aaron_map_with_tsy,model,storm_start,storm_duration,'RBSP'+rbsp,'rbsp'+rbsp+'_state_pos_gsm',R0=R0,rlim=rlim
savevars = ['RBSP'+rbsp+'!CL-shell-t04s','RBSP'+rbsp+'!Cnorth-foot-ILAT!Ct04s',$
'RBSP'+rbsp+'!Cnorth-foot-MLT!Ct04s','RBSP'+rbsp+'!Csouth-foot-ILAT!Ct04s',$
'RBSP'+rbsp+'!Csouth-foot-MLT!Ct04s','RBSP'+rbsp+'!Cequatorial-foot-ILAT!Ct04s',$
'RBSP'+rbsp+'!Cequatorial-foot-MLT!Ct04s']
tplot_save,savevars,filename=fileroot+'RBSP'+rbsp+'_'+model+'_'+datestr+'_'+t0zstr+'-'+t1zstr
savevars = ''




end
