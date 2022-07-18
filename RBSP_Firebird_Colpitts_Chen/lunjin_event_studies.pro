;Code I use to test out events for Lunjin's ray tracing analysis. 



timespan,'2016-01-21'

rbsp_efw_init


;firebird_load_data,'3' 
firebird_load_data,'4'

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

