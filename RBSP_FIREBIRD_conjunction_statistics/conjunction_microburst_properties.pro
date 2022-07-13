;(formerly master_conjunction_list_microbursts.pro)

;Part 6 in the process in determining list of FB/RBSP conjunctions.
;This finds properties of the microbursts during the conjunctions. 

;This is kept separately from code that identifies chorus properties near conjunctions (master_conjunction_list_part3) because 
;the identification of microbursts isn't so simple, and it's nice to have the flexibility to re-identify without having to rerun the 
;aforementioned programs. 

;For each FB/RBSP combination (identified from master_conjunction_list_part3.pro output file RBSP?_FU?_conjunction_values_hr.txt, 
;outputs a text file to
;~/Desktop/Research/RBSP_Firebird_microburst_conjunctions_all/RBSP_FB_final_conjunction_lists/RBSP?_FU?_conjunction_microbursts.txt'
;Only conjunctions with hires FIREBIRD data are included b/c this is needed to identify the microbursts.  

;Microbursts are identified using Shumko's microburst id code 


;Properties identified include:
;max, median, average amplitude
;Total number of microbursts 
;Duty cycle 
;Duration

;Header information for files produced is at RBSP_FU_conjunction_microbursts_header.fmt


;Required external programs:
;SPEDAS software package 
;sample_rate.pro 


rbsp_efw_init


;datetime = '2016-08-24'


;Grab local path to save data
homedir = (file_search('~',/expand_tilde))[0]+'/'


pathoutput = homedir + 'Desktop/'


testing = 0
noplot = 1

rb = 'b'
fb = '4'

;dettime = 0.75 ;(sec)  Time for detrending the hires data in order to obtain microburst amplitudes. 
;				;See firebird_subtract_tumble_from_hiresdata_testing.pro




;--------------
;Conjunction data for all the FIREBIRD passes with HiRes data
path = homedir + 'Desktop/code/Aaron/github/research_projects/RBSP_Firebird_microburst_conjunctions_all/'




fbtmp = fb 
rbtmp = rb

;Load the data from all identified conjunctions (from master_conjunction_list_part3.pro)

conj = read_rbsp_fb_conjunction_lists(rbtmp,fbtmp,hires=1)
nconj = n_elements(conj.tstart)



;;Print list of times (since these are based on FB ephemeris data, they don't need a time correction)
for bb=0,nconj-1 do print,bb,' ',time_string(conj.tstart[bb])




;-----------------------------------------------------
;Find microburst properties based on Shumko list. 
;This list now has flux values!
;-----------------------------------------------------

;ub = load_firebird_microburst_list(fbtmp,filename='FU4_microbursts_bw=0.75sec.csv')
ub = load_firebird_microburst_list(fbtmp,filename='FU4_microburst_catalog_01.csv')



;Remove any microbursts that are flagged or have too many nearby zeros. 
bad1 = where(ub.n_zeros gt 3.)
bad2 = where(ub.saturated eq 1)
bad3 = where(ub.time_gap eq 1) 

bad = [bad1, bad2, bad3] 

flux = ub.flux_0
flux[bad] = !values.f_nan

goodv = where(finite(flux) ne 0.)

ubtimes = ub.time[goodv]
ubflux = ub.flux_0[goodv]
ubtimes_bad = ub.time[bad]
ubflux_bad = ub.flux_0[bad]



store_data,'ub_shumko_flux',data={x:time_double(ubtimes),y:ubflux}
options,'ub_shumko_flux','psym',4
options,'ub_shumko_flux','symsize',1
options,'ub_shumko_flux','thick',2
options,'ub_shumko_flux','color',250


store_data,'ub_shumko_flux_bad',data={x:time_double(ubtimes_bad),y:ubflux_bad}
options,'ub_shumko_flux_bad','psym',4
options,'ub_shumko_flux_bad','symsize',1
options,'ub_shumko_flux_bad','thick',2
options,'ub_shumko_flux_bad','color',100

ylim,['ub_shumko_flux','ub_shumko_flux_bad'],0,150
tplot,['ub_shumko_flux','ub_shumko_flux_bad']


stop





;For every conjunction
for j=0.,nconj-1 do begin



  currday = strmid(conj.tstart[j],0,10)

  t0 = time_double(conj.tstart[j])
  t1 = time_double(conj.tend[j])

  print,conj.tstart[j],'  ', conj.tend[j]


  fbtmp = fb



;*****
;add padding to the conjunction times for finding microbursts.
padsec = 100.
;*****
  
  goo = where((time_double(ubtimes) ge t0-padsec) and (time_double(ubtimes) le t1+padsec))
  

  ;Calculate flux properties during the conjunction
  if goo[0] ne -1 then begin
    max_HRflux_col = max(ubflux[goo],/nan)
  endif else max_HRflux_col = !values.f_nan
  
  





		;---------------------------------------------------------------


	;If first time opening file, then print the header
	;For detailed header info see RBSP_FU_conjunction_microburst_list_header.fmt

	fn_save = 'RBSP'+rb+'_'+'fu'+fb+'_conjunction_microbursts.txt'

	result = FILE_TEST(pathoutput + fn_save)


	if not result then begin
		openw,lun,pathoutput + fn_save,/get_lun
		printf,lun,'Conjunction microburst data for RBSP'+rb+' and '+'fu'+fb + ' based on RBSP'+rb+'_fu'+fb+'_conjunction_values_hr.txt'
		close,lun
		free_lun,lun
	endif





	tstart = time_string(t0)
	tend = time_string(t1)
	max_HRflux_col = string(max_HRflux_col,format='(F12.2)')


	print,tstart,'  ',tend








	openw,lun,pathoutput + fn_save,/get_lun,/append
	printf,lun,tstart+' '+tend+' '+max_HRflux_col
	close,lun
	free_lun,lun




endfor
end











;********************;**********************
;********************;**********************
;********************;**********************
;OLD CODE WHERE I DETERMINE MICROBURST AMPLITUDE MANUALLY USING DETRENDING.
;NEW VERSION ABOVE USES SHUMKO'S LIST. 
;********************;**********************
;********************;**********************
;********************;**********************




;
;;Load FIREBIRD hires data per day (if there is any)
;timespan,currday
;
;store_data,'fu'+fb+'_fb_col_hires_flux',/del
;
;;Load hires (time-corrected) data, if there is any
;fbtmp = fb
;firebird_load_data,fbtmp,fileexists=fb_hiresexists
;
;
;;load context data
;fbtmp = fb
;firebird_load_context_data_cdf_file,fbtmp
;
;
;
;
;;---------------------------------------------------------------
;;Find max FB flux - Use detrended version to get rid of the sc roll
;
;;   if hires then begin
;;     time_clip,'fu'+fb+'_fb_col_hires_flux',t0z,t1z,newname='fb_col_flux_tc'
;;     rbsp_detrend,'fb_col_flux_tc',0.1
;;     get_data,'fb_col_flux_tc_detrend',tt,dat
;;     max_HRflux_col = max(dat,/nan)
;;   endif else begin
;;     time_clip,'D0',t0z,t1z,newname='fb_col_flux_tc'
;;     get_data,'fb_col_flux_tc',tt,dat
;;     max_HRflux_col = max(dat,/nan)
;;   endelse
;
;
;
;hires = tdexists('fu'+fb+'_fb_col_hires_flux',t0,t1)
;
;max_HRflux_col = !values.f_nan
;
;
;;Limit to times of conjunction only (t0 to t1)
;if hires then begin
;  ;Determine the hires flux ABOVE background level by subtracting off a boxcar average.
;  ;NOTE: it is critical to remove data surrounding data gaps as these can throw off the fit line
;  ;significantly.
;  ;FOR TESTING RESULTS SEE "firebird_subtract_tumble_from_hiresdata_testing.pro"
;
;  ;   time_clip,'fu'+fb+'_fb_col_hires_flux',t0,t1,newname='fb_col_flux_tc'
;
;  copy_data,'fu'+fb+'_fb_col_hires_flux','fb_col_flux_tc'
;
;  rbsp_detrend,'fb_col_flux_tc',dettime
;  rbsp_detrend,'fu'+fb+'_fb_col_hires_flux',dettime ;for later comparison plotting only
;  get_data,'fb_col_flux_tc_detrend',data=d_det
;
;
;  tder = deriv(d_det.x)
;  store_data,'datagap_test',d_det.x,tder
;  options,'datagap_test','ytitle','time!Cderiv!C(data gaps)'
;  ylim,'datagap_test',0.01,20,1
;
;
;  ;set gap limit based on hires data cadence
;  gaplim = 2*cal.cadence/1000.    ;sec
;  goo = where(tder gt gaplim)
;  data = d_det.y
;
;  datcadence = sample_rate(d_det.x,/average)
;  npts_pad = ceil(datcadence * dettime/2.)  ;number of hires data points to remove about each data point that is a gap
;
;  ;remove data near dropouts
;  for i=0,n_elements(goo)-1 do begin
;    ;Make sure the gap doesn't extend beyond the last data point
;    if goo[i]+npts_pad ge n_elements(d_det.x)-1 then maxindex = n_elements(d_det.x)-1 else maxindex = goo[i]+npts_pad
;    boo = where((d_det.x ge d_det.x[goo[i]-npts_pad]) and (d_det.x le d_det.x[maxindex]))
;    if boo[0] ne -1 then data[boo,*] = !values.f_nan
;  endfor
;
;
;  ;store_data,'fb_corr',d.x,data
;
;
;  ;When determining max value, ONLY use positive values. Large negative values usually due to data dropouts
;  max_HRflux_col = max(data,/nan)
;
;  store_data,'fb_col_flux_tc_detrend_gapsremoved',d_det.x,data
;  store_data,'detcomb',data=['fu'+fb+'_fb_col_hires_flux_0_detrend','fb_corr'] & options,'detcomb','colors',[0,250]
;  options,'detcomb','ytitle','full detrended data vs!Cgap-reduced version'
;  store_data,'comb',data=['fb_col_flux_tc','fb_col_flux_tc_smoothed']
;  options,'comb','colors',[0,250]
;  options,'comb','ytitle','Hires flux!Cvs smoothed'
;
;
;
;  ylim,'fu4_fb_mlt_from_hiresfile',0,24
;
;
;
;  tplot_options,'xmargin',[20.,15.] & tplot_options,'ymargin',[3,6]
;  tplot_options,'xticklen',0.08 & tplot_options,'yticklen',0.02
;  tplot_options,'xthick',2 & tplot_options,'ythick',2
;  tplot_options,'labflag',-1
;
;  copy_data,'fu'+fb+'_fb_col_hires_flux_detrend','fu'+fb+'_fb_col_hires_flux_detrend_v2'
;  ylim,'fu'+fb+'_fb_col_hires_flux_detrend_v2',-10,10
;  options,'fu'+fb+'_fb_col_hires_flux_detrend_v2','ytitle','FB col!Cdetrendflux!Cexpanded!Cyscale'
;  options,'fu'+fb+'_fb_col_hires_flux_detrend','ytitle','FB col!Cdetrendflux'
;  options,'fb_col_flux_tc_detrend_gapsremoved','ytitle','FB col!Cdetrendflux!Cgaps!Cremoved'
;
;
;
;  store_data,'detcomb',data=['fu'+fb+'_fb_col_hires_flux_detrend','ub_shumko_flux']
;  options,'detcomb','colors',[0,150,250,250]
;  options,'detcomb','ytitle','full detrended data vs!Cgap-reduced version'
;  ylim,'detcomb',0,0,0
;
;  store_data,'detcomb2',data=['fu'+fb+'_fb_col_hires_flux_detrend_v2','ub_shumko_flux']
;  options,'detcomb2','colors',[0,150,250,250]
;  options,'detcomb2','ytitle','full detrended data vs!Cgap-reduced version'
;  ylim,'detcomb2',0,0,0
;
;
;  ;timespan,t0-120,t1-t0 + 240,/sec
;  ;tplot,['comb','datagap_test','detcomb','fu4_fb_col_hires_counts']
;
;
;  ;stop
;
;  ;***************************
;
;
;  ;Look at overview plot for the ENTIRE time hires data is available. Compare this to the time when
;  ;the conjunction is within dL and dMLT <= +/- 1
;
;  timeS = strmid(conj.tstart[j],0,4)+strmid(conj.tstart[j],5,2)+strmid(conj.tstart[j],8,2)+'_'+strmid(conj.tstart[j],11,2)+strmid(conj.tstart[j],14,2)+strmid(conj.tstart[j],17,2)
;  options,['MLT','McIlwainL'],'panel_size',2
;
;  ;if not noplot then begin
;  ;     popen,'~/Desktop/'+'RBSP'+rb+'_'+fb + '_'+timeS+'_conjunction_hr.ps'
;  timespan,t0-120,t1-t0 + 3*120,/sec
;  tplot,['fu'+fb+'_fb_col_hires_flux',$
;    ;'comb',$
;    'datagap_test',$
;    'detcomb',$
;    'detcomb2',$
;    ; 'fu'+fb+'_fb_col_hires_flux_detrend_v2',$
;    'fb_col_flux_tc_detrend_gapsremoved',$
;    'MLT','McIlwainL']
;  timebar,[t0,t1]
;
;  ;     pclose
;  ;endif
;
;  ;stop
;
;endif
;
;
;;time_clip,'flux_context_'+fb,t0,t1,newname='fb_col_flux_tc'
;
;;get_data,'fb_col_flux_tc',tt,dat
;;max_flux_col = max(dat,/nan)
;
;;if max_flux_col eq 0 then max_flux_col = !values.f_nan
;if max_HRflux_col eq 0 then max_HRflux_col = !values.f_nan
;
;

