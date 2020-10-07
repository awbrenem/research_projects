;Read the FIREBIRD predict files for upcoming campaigns.
;Save data as....

path = '/Users/aaronbreneman/Desktop/Research/RBSP_Firebird_microburst_conjunctions_all/data/'
fn = 'FU3_LLA_camp17_2018-07-27_2018-08-31.csv'

openr,lun,path+fn,/get_lun

jnk = ''
readf,lun,jnk
;Time (ISO),Lat (deg),Lon (deg),Alt (km),Vel (km/s)


times = strarr(50400)
lat = times & lon = times & alt = times & velo = times
;lat = '' & lon = '' & alt = '' & velo = ''
;2018-07-27 00:00:00,-76.7561996544,-49.822269031,607.560041887,7.49573532692
;while not eof(lun) do begin ;$

for i=0,50399 do begin
  readf,lun,jnk ; & $
  vals = strsplit(jnk,',',/extract) ;& $
;  times = [times,time_string(vals[0])] ;& $
;  lat = [lat,vals[1]] ;& $
;  lon = [lon,vals[2]] ;& $
;  alt = [alt,vals[3]] ;& $
;  velo = [velo,vals[4]]

  times[i] = vals[0] ;& $
  lat[i] = vals[1] ;& $
  lon[i] = vals[2] ;& $
  alt[i] = vals[3] ;& $
  velo[i] = vals[4]
;stop
;endwhile
endfor
close,lun
free_lun,lun

stop

times = time_double(time_string(times))
lats = float(lat)
lons = float(lon)
alts = float(alt)
velo = float(velo)


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
fbsat = 'FB3'
storm_duration = 31*86400.
storm_start = time_string(times[0])
kp = 2.

model = 't89'
aaron_map_with_tsy,model,storm_start,storm_duration,'FB'+fbsat,'fb_gsm',Kp,R0=R0,rlim=rlim


tplot,['FBFB3!Cequatorial-foot-MLT!Ct89','FBFB3!CL-shell-t89']



;load RBSP data
t0 = ''

timespan,'2018-08-05',23,/days

rbsp_load_spice_predict
rbsp_efw_position_velocity_crib,/no_spice_load


model = 't89'
aaron_map_with_tsy,model,storm_start,storm_duration,'RBSP'+rbsp,'rbsp'+rbsp+'_state_pos_gsm',Kp,R0=R0,rlim=rlim
savevars = ['RBSP'+rbsp+'!CL-shell-t89','RBSP'+rbsp+'!Cnorth-foot-ILAT!Ct89',$
'RBSP'+rbsp+'!Cnorth-foot-MLT!Ct89','RBSP'+rbsp+'!Csouth-foot-ILAT!Ct89',$
'RBSP'+rbsp+'!Csouth-foot-MLT!Ct89','RBSP'+rbsp+'!Cequatorial-foot-ILAT!Ct89',$
'RBSP'+rbsp+'!Cequatorial-foot-MLT!Ct89']
tplot_save,savevars,filename=fileroot+'RBSP'+rbsp+'_'+model+'_Kp='+strtrim(Kp,2)+'_'+datestr+'_'+t0zstr+'-'+t1zstr
savevars = ''

















savevars = ['FB'+fbsat+'!CL-shell-t89','FB'+fbsat+'!Cnorth-foot-ILAT!Ct89',$
'FB'+fbsat+'!Cnorth-foot-MLT!Ct89','FB'+fbsat+'!Csouth-foot-ILAT!Ct89',$
'FB'+fbsat+'!Csouth-foot-MLT!Ct89','FB'+fbsat+'!Cequatorial-foot-ILAT!Ct89',$
'FB'+fbsat+'!Cequatorial-foot-MLT!Ct89']
tplot_save,savevars,filename=fileroot+'FB'+fbsat+'_'+model+'_Kp='+strtrim(Kp,2)+'_'+datestr+'_'+t0zstr+'-'+t1zstr
savevars = ''



;------------------------------------------------
;Now do the same for RBSP
;------------------------------------------------

store_data,tnames(),/delete


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
