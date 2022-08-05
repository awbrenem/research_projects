;Code I use to test out events for Lunjin's ray tracing analysis. 

;Outputs a .txt file with the calibrated FIREBIRD data. 

timespan,'2016-01-21'



vv = firebird_get_calibration_counts2flux('2016-01-21','4')

print,vv.energy_range_collimated

;IDL> print,vv.energy_range_collimated
;219.700      283.400      383.600      520.300      720.700      985.000
;283.400      383.600      520.300      720.700      985.000      985.000

;sc = 'a'
;lvl = 'l2'
;type = 'hfr/waveform'
rbsp_efw_init


firebird_load_data,'3' 

get_data,'fu3_fb_col_hires_flux',data=d1
get_data,'fu3_fb_geolat_from_hiresfile',data=d2
get_data,'fu3_fb_geolon_from_hiresfile',data=d3
get_data,'fu3_fb_alt_from_hiresfile',data=d4
get_data,'fu3_fb_mlt_from_hiresfile',data=d5
get_data,'fu3_fb_mcilwainL_from_hiresfile',data=d6


fmt = '(a23,6(f8.2,2x),5(f8.2,4x))'
openw,lun,'~/Desktop/fb3_hires_20160121.txt',/get_lun
printf,lun,'Times  flux219-283keV   flux283-383keV   flux383-520keV   flux520-720keV    flux720-985keV   flux>MeV          geolat         geolon           alt               MLT        L'
for i=0,n_elements(d1.x)-1 do printf,lun,time_string(d1.x[i],prec=3),d1.y[i,0],d1.y[i,1],d1.y[i,2],d1.y[i,3],d1.y[i,4],d1.y[i,5],d2.y[i,0],d3.y[i,0],d4.y[i,0],d5.y[i,0],d6.y[i,0],format=fmt
close,lun
free_lun,lun

;fmt = '(a23,6(f8.2,2x),5(f8.2,4x))'
;for i=0,1 do print,time_string(d1.x[i],prec=3),d1.y[i,0],d1.y[i,1],d1.y[i,2],d1.y[i,3],d1.y[i,4],d1.y[i,5],d2.y[i,0],d3.y[i,0],d4.y[i,0],d5.y[i,0],d6.y[i,0],format=fmt


firebird_load_data,'4'

get_data,'fu4_fb_col_hires_flux',data=d1
get_data,'fu4_fb_geolat_from_hiresfile',data=d2
get_data,'fu4_fb_geolon_from_hiresfile',data=d3
get_data,'fu4_fb_alt_from_hiresfile',data=d4
get_data,'fu4_fb_mlt_from_hiresfile',data=d5
get_data,'fu4_fb_mcilwainL_from_hiresfile',data=d6


fmt = '(a23, 6(f8.2,2x),5(f8.2,4x))'
openw,lun,'~/Desktop/fb4_hires_20160121.txt',/get_lun
printf,lun,'Times  flux219-283keV   flux283-383keV   flux383-520keV   flux520-720keV    flux720-985keV   flux>MeV          geolat         geolon           alt               MLT        L'
for i=0,n_elements(d1.x)-1 do printf,lun,time_string(d1.x[i],prec=3),d1.y[i,0],d1.y[i,1],d1.y[i,2],d1.y[i,3],d1.y[i,4],d1.y[i,5],d2.y[i,0],d3.y[i,0],d4.y[i,0],d5.y[i,0],d6.y[i,0],format=fmt
close,lun
free_lun,lun








rbsp_load_efw_cdf,'a','l3'

rbsp_load_emfisis_cdf,'a','l2','hfr/waveform'


rbsp_load_efw_cdf,'a','l2','fbk'
copy_data,'fbk7_scmw_pk','rbspa_fbk7_scmw_pk'
copy_data,'fbk7_e12dc_pk','rbspa_fbk7_e12dc_pk'

rbsp_load_efw_cdf,'b','l2','fbk'
copy_data,'fbk7_scmw_pk','rbspb_fbk7_scmw_pk'
copy_data,'fbk7_e12dc_pk','rbspb_fbk7_e12dc_pk'


split_vec,'rbspa_fbk7_scmw_pk'
split_vec,'rbspa_fbk7_e12dc_pk'
split_vec,'rbspb_fbk7_scmw_pk'
split_vec,'rbspb_fbk7_e12dc_pk'

options,'rbspa_fbk7_scmw_pk_?','spec',0
options,'rbspa_fbk7_e12dc_pk_?','spec',0
options,'rbspb_fbk7_scmw_pk_?','spec',0
options,'rbspb_fbk7_e12dc_pk_?','spec',0


;chorus overview 
tlimit,'2016-01-21/21:50','2016-01-21/23:59:59'
tplot,['rbspa_fbk7_scmw_pk_5','rbspa_fbk7_e12dc_pk_5']


;Comparison b/t the two RBSP
tplot,['rbspa_fbk7_scmw_pk_5','rbspb_fbk7_scmw_pk_5']





;------------------------------------------------------
;FU3 plots
;
;overall timespan
;t0 = time_double('2016-01-21/22:46:00')
;t1 = time_double('2016-01-21/22:47:40')
;
;tlimit,t0,t1
;
;ylim,'fu3_fb_mcilwainL_from_hiresfile',3,8
;tplot,['fu3_fb_col_hires_flux','fu3_fb_mcilwainL_from_hiresfile','fu3_fb_mlt_from_hiresfile']
;
;for i=0,20 do begin
;  t0z = t0+(i*10.)
;  t1z = t0z + 10.
;  t0zs = time_string(t0z,tformat='YYYYMMDD_hhmmss')
;  t1zs = time_string(t1z,tformat='YYYYMMDD_hhmmss')
;  tlimit,t0+(i*10.),t0+(i*10.)+10.
;  fn = 'fb3_rbsp_conjunction-'+t0zs+'-'+t1zs
;  popen,'~/Desktop/' + fn,/landscape
;  tplot
;  pclose
;  stop
;endfor

;-----------------------------------------------------
;FU4 plots 

;overall timespan
t0 = time_double('2016-01-21/22:42:00')
t1 = time_double('2016-01-21/22:43:20')

tlimit,t0,t1

ylim,'fu4_fb_mcilwainL_from_hiresfile',3,8
tplot,['fu4_fb_col_hires_flux','fu4_fb_mcilwainL_from_hiresfile','fu4_fb_mlt_from_hiresfile']
stop

for i=0,20 do begin
  t0z = t0+(i*10.)
  t1z = t0z + 10.
  t0zs = time_string(t0z,tformat='YYYYMMDD_hhmmss')
  t1zs = time_string(t1z,tformat='YYYYMMDD_hhmmss')
  tlimit,t0+(i*10.),t0+(i*10.)+10.
  fn = 'fb4_rbsp_conjunction-'+t0zs+'-'+t1zs
  popen,'~/Desktop/' + fn,/landscape
  tplot
  pclose
  stop
endfor











split_vec,'fu3_fb_col_hires_flux'

ylim,'fu3_fb_col_hires_flux_?',0,0,0
tplot,['fu3_fb_col_hires_flux_5','fu3_fb_col_hires_flux_4','fu3_fb_col_hires_flux_3','fu3_fb_col_hires_flux_2','fu3_fb_col_hires_flux_1','fu3_fb_col_hires_flux_0']


ylim,['fu3_fb_col_hires_flux','fu4_fb_col_hires_flux'],0,100,0


end 

