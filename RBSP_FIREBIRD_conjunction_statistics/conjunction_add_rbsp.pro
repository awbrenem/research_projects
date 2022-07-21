;Determines properties of chorus waves during FB/RBSP conjunctions.
;(formerly master_conjunction_list_part3.pro)


;This takes all the conjunction files produced from conjunction_create_sav_file.pro (which itself uses Mike Shumko's conjunction lists) 
;and determines how much burst data (EFW/EMFISIS) is nearby, and FBK amplitudes (both FBK7 and FBK13) near conjunction, etc.



;For each FB/RBSP combination, outputs one of the following .txt files:
;RBSP?_FU?_conjunction_values.txt     (all conjunctions)
;RBSP?_FU?_conjunction_values_hr.txt  (only conjunctions that have hires FIREBIRD data - 
;   NOTE: This program does not output any FIREBIRD hires values.
;   That's done with a separate program b/c it takes a long time to run)
;to  /github/research_projects/RBSP_FIREBIRD_conjunction_statistics/conjunction_values/immediate_conjunction_values/'





;Also saves a plot of the conjunction.
;--Change "zeroline" for dL, dMLT to the actual value at the minimum separation.


;NOTES:
    ;Header information for files produced is from file RBSP_FU_conjunction_header.fmt.txt




;Required external programs:
;SPEDAS software package 
;sample_rate.pro 










;---------------------------------------------------------------
;User input
;---------------------------------------------------------------

testing = 0
hires = 1   ;conjunctions w/ hires only?
noplot = 1

probe = 'a'
fb = 'FU4'
pmtime = 60.  ;plus/minus time (min) from closest conjunction for data consideration


;---------------------------------------------------------------





paths = get_project_paths()




;Grab local path to save data
homedir = (file_search('~',/expand_tilde))[0]+'/'
;pathoutput = homedir + 'Desktop/'

pathoutput = paths.IMMEDIATE_CONJUNCTION_VALUES

if hires then suffix = '_conjunctions_hr.sav' else suffix = '_conjunctions.sav'




;--------------
;Conjunction data for all the FIREBIRD passes with HiRes data


fn = fb+'_'+'RBSP'+strupcase(probe)+suffix
restore,paths.breneman_conjunctions + fn


rb = 'rbsp'+probe

tfb0 = t0
tfb1 = t1

;Print list of times
for bb=0,n_elements(tfb0)-1 do print,bb,' ',time_string(tfb0[bb])
;for bb=1900,2200 do print,bb,' ',time_string(tfb0[bb]),'  ',time_string(tfb1[bb])


;daytst = '0000-00-00'   ;used as a test to see if we need to load another day's data


;For every conjunction
for j=0.,n_elements(tfb0)-1 do begin

	;Make sure all the variables created by time_clip are deleted b/c if time_clip finds no data in requested timerange
	;then it won't overwrite previous values. 
	store_data,'*_tc',/del



	;Manually select the conjunction to start on.
	if j eq 0 then stop
	j = float(j)

	;Figure out if a conjunction crosses the day boundary (more than one day of data to load)
	tstart = time_string(tfb0[j])  ; - (pmtime+10.)*60.
	tend   = time_string(tfb0[j] + (pmtime+10.)*60.)
	ndays_load = floor((time_double(strmid(tend,0,10)) - time_double(strmid(tstart,0,10)))/86400 + 1)




	currday = strmid(time_string(tfb0[j]),0,10)
	timespan,currday,ndays_load,/days

	nextday = strmid(time_string(time_double(currday)+86400),0,10)
	trange = [currday,nextday]


;	load_new_data = daytst ne currday


	;Load new data if required
;	if load_new_data or ndays_load gt 1 then begin
;		if testing then stop
;		if ndays_load eq 1 then daytst = currday
;		if ndays_load gt 1 then daytst = nextday


		;Need to do this each time or else the amplitudes can get filled in incorrectly.
		;***DON'T REMOVE!!!!
		store_data,'*',/delete





		;load FIREBIRD context data
		firebird_load_context_data_cdf_file,strmid(fb,2,1)




    ;-----------------------------------------------------------------------
		;Lots of missing FIREBIRD data, so we'll test to see if it's been loaded.
		;If not, then skip to next data
		xtst1 = tsample('flux_context_'+fb,[time_double(trange[0]),time_double(trange[1])])
		missingdata = 0
		if n_elements(xtst1) eq 1 and finite(xtst1[0]) eq 0 then missingdata = 1




		if missingdata ne 1 then begin

			;These load multi days automatically
			timespan,trange[0],ndays_load,/days
			

      ;load EFW data
      rbsp_load_efw_cdf,probe,'l2','spec'
      rbsp_load_efw_cdf,probe,'l2','fbk'

			;load ephemeris data
			rbsp_load_ephem_cdf,probe

			;load EMFISIS data
      rbsp_load_emfisis_cdf,probe,'l3','4sec/gsm'
     

		endif  ;if not missingdata
;	endif  ;load new data



	if missingdata ne 1 then begin


		;create artifical times array with 1-sec cadence for timerange requested.
		ntimes = time_double(trange[1]) - time_double(trange[0])
		ndays = ntimes/86400.
		times_artificial = time_double(trange[0]) + dindgen(ndays*ntimes)
		vals = fltarr(n_elements(times_artificial))



		goo = where((times_artificial ge tfb0[j]) and (times_artificial le tfb1[j]))
		if goo[0] ne -1 then vals[goo] = 1.
		store_data,'fb_conjunction_times',times_artificial,vals
		ylim,'fb_conjunction_times',0,2
		options,'fb_conjunction_times','psym',0
		options,'fb_conjunction_times','ytitle','FB!Cconj'


		get_data,'Magnitude',ttt,magnit
		fce = 28.*magnit

		tinterpol_mxn,rb+'_mlat','Magnitude'
		get_data,rb+'_mlat_interp',data=mlat
		fce_eq = fce*cos(2*mlat.y*!dtor)^3/sqrt(1+3*sin(mlat.y*!dtor)^2)


		store_data,'fce_eq',ttt,fce_eq
		store_data,'fce_eq_2',ttt,fce_eq/2.
		store_data,'fce_eq_10',ttt,fce_eq/10.
		store_data,'fci_eq',ttt,fce_eq/1836.
		store_data,'flh_eq',ttt,sqrt(fce_eq*fce_eq/1836.)

		store_data,'spec64_e12ac_comb',data=['spec64_e12ac','fce_eq','fce_eq_2','fce_eq_10'];,'fci_eq','flh_eq']
		store_data,'spec64_scmw_comb', data=['spec64_scmw','fce_eq','fce_eq_2','fce_eq_10'];,'fci_eq','flh_eq']

		ylim,'spec64_e12ac_comb',1,6000,1
		ylim,'spec64_scmw_comb',1,6000,1



		;--------------------------------------------------
		;Get burst times
		;This is a bit complicated for spinperiod data b/c the short
		;B2 snippets can be less than the spinperiod.
		;So, I'm padding the B2 times by +/- a half spinperiod so that they don't
		;disappear upon interpolation to the spinperiod data.
		;--------------------------------------------------


		;get B1 times and rates from this routine
		b1t = ''
		b1t = rbsp_get_burst_times_rates_list(probe)

		;get B2 times from this routine
		b2t = ''
		b2t = rbsp_get_burst2_times_list(probe)



		options,'*','panel_size',1

		rbsp_load_emfisis_burst_times,probe




		store_data,'lcomb',data=[rb+'_lshell','McIlwainL']
		store_data,'mltcomb',data=[rb+'_mlt','MLT']
		options,['MLT','McIlwainL',strlowcase(rb)+'_lshell_interp','MLT',strlowcase(rb)+'_mlt_interp'],'psym',-2

		options,'lcomb','colors',[0,250]
		options,'mltcomb','colors',[0,250]
		ylim,'lcomb',0,10
		ylim,'mltcomb',0,24


		;Set tlimits for conjunction
		get_data,'fb_conjunction_times',ttmp,dtmp
		goo = where(dtmp eq 1)
		tmid = (ttmp[goo[0]] + ttmp[goo[n_elements(goo)-1]])/2.
		t0z = tmid - pmtime*60.
		t1z = tmid + pmtime*60.


		print,time_string(t0z)
		print,time_string(t1z)
		if testing then stop




  	;-------------------------------------------------------------------------
  	;Find how many seconds of burst availability there is in the timerange t0z to t1z
  	;-------------------------------------------------------------------------

		;First do this for EMFISIS burst data
		get_data,rb+'_emfisis_burst',t,d
		goo = where((t ge t0z) and (t le t1z))
		nsec_emf = !values.f_nan
		if goo[0] ne -1 then begin
			dtots = total(d[goo],/nan)
			sr = sample_rate(t)
			sr = median(sr)
			nsec_emf = dtots/sr  ;total time in sec
		endif


		;Now do this for EFW B2
		;...create artificial array of times.
		timestmp = time_double(currday) + dindgen(100.*86400.)/99.
		valstmp = fltarr(n_elements(timestmp))
		cadence = n_elements(timestmp)/86400.
		nsec_b2 = !values.f_nan
		if is_struct(b2t) then begin
			for i=0,n_elements(b2t.duration)-1 do begin
					goo = where((timestmp ge b2t.startb2[i]) and (timestmp le b2t.endb2[i]))
					if goo[0] ne -1 then valstmp[goo] = 1.
			endfor
			goo = where((timestmp ge t0z) and (timestmp le t1z))
			if goo[0] ne -1 then nsec_b2 = total(valstmp[goo])/cadence
		endif


		;...now do this for EFW B1
		timestmp = time_double(currday) + dindgen(100.*86400.)/99.
		valstmp = fltarr(n_elements(timestmp))
		cadence = n_elements(timestmp)/86400.
		nsec_b1 = !values.f_nan
		if is_struct(b1t) then begin
			for i=0,n_elements(b1t.duration)-1 do begin
					goo = where((timestmp ge b1t.startb1[i]) and (timestmp le b1t.endb1[i]))
					if goo[0] ne -1 then valstmp[goo] = 1.
			endfor
			goo = where((timestmp ge t0z) and (timestmp le t1z))
			if goo[0] ne -1 then nsec_b1 = total(valstmp[goo])/cadence
		endif






		;-----------------------------------------------------------
		;Find the average spectral power in various frequency bands within
		;+/-1 hr of conjunction
		;-----------------------------------------------------------


    ;Names for splitting the spectra up
		channelnames = ['0','20Hz','0.1fce','0.5fce','fce','7300Hz']


		get_data,'spec64_e12ac',data=dd,dlim=dlim,lim=lim
    spectmpE = tsample('spec64_e12ac',[t0z,t1z],times=ttspec)
    spectmpB = tsample('spec64_scmw',[t0z,t1z],times=ttspec)
		tinterpol_mxn,'fce_eq','spec64_e12ac'
		fcetmp = tsample('fce_eq_interp',[t0z,t1z],times=ttfce)


    if finite(fcetmp[0]) then begin 

      freq_lowlimit = replicate(20.,n_elements(fcetmp))
          
      ;frequency lines that will be used to divide up the spectra
      freqbands = [[freq_lowlimit],[fcetmp/10.],[fcetmp/2.],[fcetmp]]
      store_data,'fces',ttfce,freqbands

      store_data,'spectmpE',ttspec,spectmpE,dd.v,dlim=dlim,lim=lim
      store_data,'spectmpB',ttspec,spectmpB,dd.v,dlim=dlim,lim=lim
      
      spectrum_split_by_band,'spectmpE','fces',chnames=channelnames,wv=wave_valsE
      spectrum_split_by_band,'spectmpB','fces',chnames=channelnames,wv=wave_valsB
      
            
    endif else begin
      wave_valsE = replicate(!values.f_nan,n_elements(channelnames),4)
      wave_valsB = replicate(!values.f_nan,n_elements(channelnames),4)
    endelse


    goo = where(wave_valsE eq 0.)
    if goo[0] ne -1 then wave_valsE[goo] = !values.f_nan
    
    goo = where(wave_valsB eq 0.)
    if goo[0] ne -1 then wave_valsB[goo] = !values.f_nan













	;---------------------------------------------------------
	;Find the MLT, L, deltaMLT and deltaL of the closest pass
	;---------------------------------------------------------

		tinterpol_mxn,rb+'_lshell','McIlwainL',newname=rb+'_lshell_interp'
		tinterpol_mxn,rb+'_mlt','MLT',newname=rb+'_mlt_interp'
		dif_data,rb+'_lshell_interp','McIlwainL',newname='ldiff'
		calculate_angle_difference,rb+'_mlt_interp','MLT',newname='mltdiff'


		options,['ldiff','mltdiff'],'psym',-2
		ylim,'ldiff',-20,20
	;	tplot,['lcomb','ldiff','mltcomb','mltdiff']


		time_clip,'ldiff',t0z,t1z,newname='ldiff_tc'
		time_clip,'mltdiff',t0z,t1z,newname='mltdiff_tc'
		time_clip,rb+'_lshell_interp',t0z,t1z,newname=rb+'_lshell_interp_tc'
		time_clip,rb+'_mlt_interp',t0z,t1z,newname=rb+'_mlt_interp_tc'
		time_clip,'MLT',t0z,t1z,newname='fb_mlt_tc'
		time_clip,'McIlwainL',t0z,t1z,newname='fb_mcilwainL_tc'

		ylim,'fb_mcilwainL_tc',0,20
		ylim,'ldiff_tc',-20,20


		if testing then begin
		tplot,['ldiff','mltdiff','ldiff_tc','mltdiff_tc']
		stop
		endif

	;	;add zero line for difference plots
	;	get_data,rb+'_lshell',tt,dd
	;	store_data,'zeroline',data={x:tt,y:replicate(0.,n_elements(tt))}
	;	options,'zeroline','linestyle',2
	;	store_data,'ldiff_tc_comb',data=['ldiff_tc','zeroline']
	;	store_data,'mltdiff_tc_comb',data=['mltdiff_tc','zeroline']
	;	options,['ldiff_tc','mltdiff_tc'],'psym',-2

		;Find absolute value of sc separation. We'll use the min value of this to define
		;dLmin and dMLTmin
		sc_absolute_separation,rb+'_lshell_interp_tc','fb_mcilwainL_tc',$
			rb+'_mlt_interp_tc','fb_mlt_tc';,/km

		if testing then begin
			tplot,[rb+'_lshell_interp_tc','fb_mcilwainL_tc',rb+'_mlt_interp_tc','fb_mlt_tc']
		endif

		ylim,'separation_absolute',-20,20
		options,['separation_absolute','ldiff_tc','mltdiff_tc',rb+'_lshell_interp_tc',rb+'_mlt_interp_tc','fb_mlt_tc','fb_mcilwainL_tc'],'psym',-2
;		tplot,['separation_absolute','ldiff_tc','mltdiff_tc',rb+'_lshell_interp_tc',rb+'_mlt_interp_tc','fb_mlt_tc','fb_mcilwainL_tc']

		;define minimum dL and dMLT values by the time when the absolute separation is a minimum
		get_data,'separation_absolute',tt,dat


		whsep = -1
		min_sep = !values.f_nan
		min_sep_time = !values.f_nan
		min_dmlt = !values.f_nan
		min_dL = !values.f_nan








	  ;select conjunction times only. NOTE: there are some conjunctions with
		;missing FIREBIRD context data. These will trigger the NaN values below
		boo = where((tt ge t0[j]) and (tt le t1[j]))
		if boo[0] ne -1 then begin
			min_sep = min(dat[boo],/nan,whsep)
			min_sep_time = tt[boo[whsep]]
			get_data,'mltdiff_tc',tt,dat
			min_dmlt = dat[boo[whsep]]
			get_data,'ldiff_tc',tt,dat
			min_dL = dat[boo[whsep]]
		endif 


;		;Check to see if any hires data loaded near the conjunction
;		hires = 0
;		hires = tdexists(strlowcase(fb)+'_fb_col_hires_flux',t0[j],t1[j])
;		nsec_hires = !values.f_nan
;
;		if hires then begin 
;			tmpp = tsample(strlowcase(fb)+'_fb_col_hires_flux',[t0[j],t1[j]],times=tms)
	;		ttmp = tms - min(tms)
	;		nsec_hires = max(ttmp,/nan)
	;	endif

;		if testing then begin
;			tplot,['separation_absolute','ldiff_tc',rb+'_lshell_interp_tc','fb_mcilwainL_tc','mltdiff_tc',rb+'_mlt_interp_tc','fb_mlt_tc']
;			if whsep ne -1 then timebar,tt[boo[whsep]]
;			timebar,t0[j],color=250
;;			timebar,t1[j],color=250
	;	stop
	;	endif


		get_data,rb+'_lshell',tforline,ddd
		store_data,'minsepline',data={x:tforline,y:replicate(min_sep,n_elements(tforline))}
		options,'minsepline','linestyle',2
		store_data,'minsep_tc_comb',data=['separation_absolute','minsepline']
		options,'separation_absolute','psym',-2
		ylim,'minsep_tc_comb',0.001,4,1



		;add zero line for difference plots
		get_data,rb+'_lshell',ttt,ddd

		store_data,'mindmltline',data={x:ttt,y:replicate(min_dmlt,n_elements(ttt))}
		store_data,'mltdiff_tc_comb',data=['mltdiff_tc','mindmltline']
		store_data,'mindLline',data={x:ttt,y:replicate(min_dl,n_elements(ttt))}
		store_data,'ldiff_tc_comb',data=['ldiff_tc','mindLline']

		options,'mindmltline','linestyle',2
		options,'mindLline','linestyle',2
		options,['ldiff_tc','mltdiff_tc'],'psym',-2

		ylim,'ldiff_tc_comb',-20,20

		if testing then begin
			timespan,t0[j]-20,(t1[j]-t0[j])+40,/seconds
			tplot,['minsep_tc_comb','ldiff_tc_comb','mltdiff_tc_comb','lcomb','ldiff','mltcomb','mltdiff']
			if whsep ne -1 then timebar,tt[boo[whsep]]
			timebar,t0[j],color=250
			timebar,t1[j],color=250
			stop			
		endif


		lshell_min_rb = !values.f_nan
		lshell_min_fb = !values.f_nan
		mlt_min_rb = !values.f_nan
		mlt_min_fb = !values.f_nan

		if whsep ne -1 then begin
			l2_probe = tsample(rb+'_lshell_interp_tc',tt[boo[whsep]],times=t)
			lshell_min_rb = l2_probe
			mlt2_probe = tsample(rb+'_mlt_interp_tc',tt[boo[whsep]],times=t)
			mlt_min_rb = mlt2_probe

			l2_fb = tsample('fb_mcilwainL_tc',tt[boo[whsep]],times=t)
			lshell_min_fb = l2_fb
			mlt2_fb = tsample('fb_mlt_tc',tt[boo[whsep]],times=t)
			mlt_min_fb = mlt2_fb
		endif


		;There are quite a number of orbits where there's no overlapping FB and RBSP ephemeris data. 
		;When this is the case, determine the RBSP L, MLT values as the average value during the start 
		;and stop of the conjunction. Nothing I can do about the missing FB data, but at least the RBSP
		;data will tell me where the conjunction took place.  
		;DON'T use the interpolated values for this b/c the FB gaps show up in the RBSP ephemeris data

		if finite(lshell_min_rb) eq 0 then begin 
			l2_probe = tsample(rb+'_lshell',[t0[j],t1[j]],times=t)
			lshell_min_rb = mean(l2_probe,/nan)
			mlt2_probe = tsample(rb+'_mlt',[t0[j],t1[j]],times=t)
			mlt_min_rb = mean(mlt2_probe,/nan)
		endif

		;Sometimes the FB values are outrageous. Fix them here. 
		if min_sep gt 100. then begin 
			min_sep = !values.f_nan
			min_dL = !values.f_nan
			lshell_min_fb = !values.f_nan
		endif








;**********************************************
;**********************************************
;**********************************************
;**********************************************
;**********************************************


    time_clip,'flux_context_'+fb,t0[j],t1[j],newname='flux_context_'+fb+'_tc'

		get_data,'flux_context_'+fb+'_tc',tt,dat
		max_flux_context = max(dat,/nan)

		if max_flux_context eq 0 then max_flux_context = !values.f_nan




	;	rbsp_detrend,'fb_col_flux_tc',0.2
	;	tplot,['fb_col_flux_tc','fb_col_flux_tc_detrend']
		
		;Figure out if we're dealing with e12 or e34 for FBK data 
    e1234 = ''
		tstvar = tnames('fbk7_e??dc_pk')
		if tstvar ne '' then e1234 = strmid(tstvar,5,3)
		tstvar = tnames('fbk13_e??dc_pk')
		if tstvar ne '' then e1234 = strmid(tstvar,6,3)


		;---------------------------------------------------------------

		;Find max filterbank value in various bins for FBK7 mode

		get_data,'fbk7_'+e1234+'dc_pk',data=dat
		if is_struct(dat) then time_clip,'fbk7_'+e1234+'dc_pk',t0z,t1z,newname='fbk7_'+e1234+'dc_pk_tc'
		get_data,'fbk7_scmw_pk',data=dat
		if is_struct(dat) then time_clip,'fbk7_scmw_pk',t0z,t1z,newname='fbk7_scmw_pk_tc'
		;Find max filterbank value in various bins for FBK13 mode
		get_data,'fbk13_'+e1234+'dc_pk',data=dat
		if is_struct(dat) then time_clip,'fbk13_'+e1234+'dc_pk',t0z,t1z,newname='fbk13_'+e1234+'dc_pk_tc'
		get_data,'fbk13_scmw_pk',data=dat
		if is_struct(dat) then time_clip,'fbk13_scmw_pk',t0z,t1z,newname='fbk13_scmw_pk_tc'

		get_data,'fbk7_'+e1234+'dc_pk_tc',data=dat
		if is_struct(dat) then begin
			fbk7_Ewmax_3 = float(max(dat.y[*,3],/nan))  ;50-100 Hz
			fbk7_Ewmax_4 = float(max(dat.y[*,4],/nan))  ;200-400 Hz
			fbk7_Ewmax_5 = float(max(dat.y[*,5],/nan))  ;0.8-1.6 kHz
			fbk7_Ewmax_6 = float(max(dat.y[*,6],/nan))  ;3.2-6.5 kHz
		endif else begin
			fbk7_Ewmax_3 = !values.f_nan
			fbk7_Ewmax_4 = !values.f_nan
			fbk7_Ewmax_5 = !values.f_nan
			fbk7_Ewmax_6 = !values.f_nan
		endelse
		get_data,'fbk7_scmw_pk_tc',data=dat
		if is_struct(dat) then begin
			fbk7_Bwmax_3 = 1000.*float(max(dat.y[*,3],/nan))  ;50-100 Hz
			fbk7_Bwmax_4 = 1000.*float(max(dat.y[*,4],/nan))  ;200-400 Hz
			fbk7_Bwmax_5 = 1000.*float(max(dat.y[*,5],/nan))  ;0.8-1.6 kHz
			fbk7_Bwmax_6 = 1000.*float(max(dat.y[*,6],/nan))  ;3.2-6.5 kHz
		endif else begin
			fbk7_Bwmax_3 = !values.f_nan
			fbk7_Bwmax_4 = !values.f_nan
			fbk7_Bwmax_5 = !values.f_nan
			fbk7_Bwmax_6 = !values.f_nan
		endelse

;tplot,[rb+'_efw_fbk7_e??dc_pk_tc',rb+'_efw_fbk7_scmw_pk_tc']
;stop

		;Find max filterbank value in various bins for FBK13 mode
		get_data,'fbk13_'+e1234+'dc_pk_tc',data=dat
		if is_struct(dat) then begin
			fbk13_Ewmax_6 = float(max(dat.y[*,6],/nan))   ;50-100 Hz
			fbk13_Ewmax_7 = float(max(dat.y[*,7],/nan))   ;100-200 Hz
			fbk13_Ewmax_8 = float(max(dat.y[*,8],/nan))   ;200-400 Hz
			fbk13_Ewmax_9 = float(max(dat.y[*,9],/nan))   ;400-800 Hz
			fbk13_Ewmax_10 = float(max(dat.y[*,10],/nan)) ;0.8-1.6 kHz
			fbk13_Ewmax_11 = float(max(dat.y[*,11],/nan)) ;1.6-3.2 kHz
			fbk13_Ewmax_12 = float(max(dat.y[*,12],/nan)) ;3.2-6.5 kHz
		endif else begin
			fbk13_Ewmax_6 = !values.f_nan
			fbk13_Ewmax_7 = !values.f_nan
			fbk13_Ewmax_8 = !values.f_nan
			fbk13_Ewmax_9 = !values.f_nan
			fbk13_Ewmax_10 = !values.f_nan
			fbk13_Ewmax_11 = !values.f_nan
			fbk13_Ewmax_12 = !values.f_nan
		endelse
		get_data,'fbk13_scmw_pk_tc',data=dat
		if is_struct(dat) then begin
			fbk13_Bwmax_6 = 1000.*float(max(dat.y[*,6],/nan))
			fbk13_Bwmax_7 = 1000.*float(max(dat.y[*,7],/nan))
			fbk13_Bwmax_8 = 1000.*float(max(dat.y[*,8],/nan))
			fbk13_Bwmax_9 = 1000.*float(max(dat.y[*,9],/nan))
			fbk13_Bwmax_10 = 1000.*float(max(dat.y[*,10],/nan))
			fbk13_Bwmax_11 = 1000.*float(max(dat.y[*,11],/nan))
			fbk13_Bwmax_12 = 1000.*float(max(dat.y[*,12],/nan))
		endif else begin
			fbk13_Bwmax_6 = !values.f_nan
			fbk13_Bwmax_7 = !values.f_nan
			fbk13_Bwmax_8 = !values.f_nan
			fbk13_Bwmax_9 = !values.f_nan
			fbk13_Bwmax_10 = !values.f_nan
			fbk13_Bwmax_11 = !values.f_nan
			fbk13_Bwmax_12 = !values.f_nan
		endelse
	;-----------------------------------------------

		options,'ldiff_tc_comb','ytitle','Lshell!CRBSP'+probe+'-'+fb
		options,'mltdiff_tc_comb','ytitle','MLT!CRBSP'+probe+'-'+fb
		options,'minsep_tc_comb','ytitle','Separation[RE]!CRBSP'+probe+'-'+fb
		options,['fb_conjunction_times',rb+'_efw_mscb1_available',rb+'_efw_mscb2_available',$
		rb+'_emfisis_burst'],'panel_size',0.5

		ylim,'mltdiff_tc_comb',-2,2
		ylim,'ldiff_tc_comb',-2,2



		print,currday
		print,'Ttime EMFISIS = ',nsec_emf
		print,'Ttime EFWb1 = ',nsec_b1
		print,'Ttime EFWb2 = ',nsec_b2
		print,'----------------------'


		if hires then fnopen = 'RBSP'+probe+'_'+fb+'_conjunction_values_hr.txt' $
		else fnopen = 'RBSP'+probe+'_'+fb+'_conjunction_values.txt'

		result = FILE_TEST(pathoutput + fnopen)



	;If first time opening file, then print the header
	;For detailed header info see RBSP_FU_conjunction_header.fmt

		if not result then begin
			openw,lun,paths.immediate_conjunction_values + fnopen,/get_lun
						printf,lun,'Conjunction data for RBSP'+probe+' and '+fb + ' from Shumko file ' + fb+'_'+rb+'_conjunctions_dL10_dMLT10_final.txt'
						close,lun
						free_lun,lun
		endif





		tstart = time_string(t0[j])
		tend = time_string(t1[j])
		tminsep = time_string(min_sep_time,tformat='YYYY-MM-DD/hh:mm:ss')
		lshell_min_rb = string(lshell_min_rb,format='(f9.2)')
		lshell_min_fb = string(lshell_min_fb,format='(f9.2)')
		mlt_min_rb = string(mlt_min_rb,format='(f9.2)')
		mlt_min_fb = string(mlt_min_fb,format='(f9.2)')
		min_sep = string(min_sep,format='(f10.5)')
		min_dL = string(min_dL,format='(f9.3)')
		min_dMLT = string(min_dMLT,format='(f9.3)')
		max_flux_context = string(max_flux_context,format='(F12.2)')
		nsec_emf = string(nsec_emf,format='(f8.1)')
		nsec_b1 = string(nsec_b1,format='(f8.1)')
		nsec_b2 = string(nsec_b2,format='(f8.1)')


		print,tstart,'  ',tend
		print,tminsep,'   ',min_sep
		print,lshell_min_rb,'  ',lshell_min_fb,'   ',min_dl
		print,mlt_min_rb,'   ',mlt_min_fb,'   ',min_dmlt


		;********************************************************************************************
		;********************************************************************************************
		;********************************************************************************************
		;chnames=['0','20','0.1fce','0.5fce','fce','7300Hz']
		;wave_vals[*,0] --> total spectral amp/power
		;wave_vals[*,1] --> max value of spectral amp/power
		;wave_vals[*,2] --> median value of spectral amp/power
		;wave_vals[*,3] --> average value of spectral amp/power
;*************MODIFY THE BELOW TO TAKE VALUES FROM WAVE_VALUESE ARRAY
;********************************************************************************************
;********************************************************************************************


    ;------------------------------------------------------------------------------
    ;Final string format of spectral E-field and B-field values
    ;------------------------------------------------------------------------------


    ;20 Hz to 0.1*fce (freqs lower than chorus)
    totallowfspec_E = string(wave_valsE[1,0],format='(F27.11)')
    maxlowfspec_E = string(wave_valsE[1,1],format='(F20.11)')
    medianlowfspec_E = string(wave_valsE[1,2],format='(F20.11)')
    avglowfspec_E = string(wave_valsE[1,3],format='(F20.11)')

    totallowfspec_B = string(wave_valsB[1,0],format='(F27.11)')
    maxlowfspec_B = string(wave_valsB[1,1],format='(F20.11)')
    medianlowfspec_B = string(wave_valsB[1,2],format='(F20.11)')
    avglowfspec_B = string(wave_valsB[1,3],format='(F20.11)')

    ;0.1-0.5*fce (lower band chorus)
    totalchorusspecL_E = string(wave_valsE[2,0],format='(F27.11)')
    maxchorusspecL_E = string(wave_valsE[2,1],format='(F20.11)')
    medianchorusspecL_E = string(wave_valsE[2,2],format='(F20.11)')
    avgchorusspecL_E = string(wave_valsE[2,3],format='(F20.11)')

    totalchorusspecL_B = string(wave_valsB[2,0],format='(F27.11)')
    maxchorusspecL_B = string(wave_valsB[2,1],format='(F20.11)')
    medianchorusspecL_B = string(wave_valsB[2,2],format='(F20.11)')
    avgchorusspecL_B = string(wave_valsB[2,3],format='(F20.11)')

    ;0.5-1*fce (upper band chorus)
    totalchorusspecU_E = string(wave_valsE[3,0],format='(F27.11)')
    maxchorusspecU_E = string(wave_valsE[3,1],format='(F20.11)')
    medianchorusspecU_E = string(wave_valsE[3,2],format='(F20.11)')
    avgchorusspecU_E = string(wave_valsE[3,3],format='(F20.11)')

    totalchorusspecU_B = string(wave_valsB[3,0],format='(F27.11)')
    maxchorusspecU_B = string(wave_valsB[3,1],format='(F20.11)')
    medianchorusspecU_B = string(wave_valsB[3,2],format='(F20.11)')
    avgchorusspecU_B = string(wave_valsB[3,3],format='(F20.11)')

    ;<1*fce (freqs higher than chorus)
    totalhighfspec_E = string(wave_valsE[4,0],format='(F27.11)')
    maxhighfspec_E = string(wave_valsE[4,1],format='(F20.11)')
    medianhighfspec_E = string(wave_valsE[4,2],format='(F20.11)')
    avghighfspec_E = string(wave_valsE[4,3],format='(F20.11)')

    totalhighfspec_B = string(wave_valsB[4,0],format='(F27.11)')
    maxhighfspec_B = string(wave_valsB[4,1],format='(F20.11)')
    medianhighfspec_B = string(wave_valsB[4,2],format='(F20.11)')
    avghighfspec_B = string(wave_valsB[4,3],format='(F20.11)')






		fbk7_Ewmax_3 = string(fbk7_Ewmax_3,format='(f8.1)')
		fbk7_Ewmax_4 = string(fbk7_Ewmax_4,format='(f8.1)')
		fbk7_Ewmax_5 = string(fbk7_Ewmax_5,format='(f8.1)')
		fbk7_Ewmax_6 = string(fbk7_Ewmax_6,format='(f8.1)')

		fbk7_Bwmax_3 = string(fbk7_Bwmax_3,format='(f8.1)')
		fbk7_Bwmax_4 = string(fbk7_Bwmax_4,format='(f8.1)')
		fbk7_Bwmax_5 = string(fbk7_Bwmax_5,format='(f8.1)')
		fbk7_Bwmax_6 = string(fbk7_Bwmax_6,format='(f8.1)')

		fbk13_Ewmax_6 = string(fbk13_Ewmax_6,format='(f8.1)')
		fbk13_Ewmax_7 = string(fbk13_Ewmax_7,format='(f8.1)')
		fbk13_Ewmax_8 = string(fbk13_Ewmax_8,format='(f8.1)')
		fbk13_Ewmax_9 = string(fbk13_Ewmax_9,format='(f8.1)')
		fbk13_Ewmax_10 = string(fbk13_Ewmax_10,format='(f8.1)')
		fbk13_Ewmax_11 = string(fbk13_Ewmax_11,format='(f8.1)')
		fbk13_Ewmax_12 = string(fbk13_Ewmax_12,format='(f8.1)')

		fbk13_Bwmax_6 = string(fbk13_Bwmax_6,format='(f8.1)')
		fbk13_Bwmax_7 = string(fbk13_Bwmax_7,format='(f8.1)')
		fbk13_Bwmax_8 = string(fbk13_Bwmax_8,format='(f8.1)')
		fbk13_Bwmax_9 = string(fbk13_Bwmax_9,format='(f8.1)')
		fbk13_Bwmax_10 = string(fbk13_Bwmax_10,format='(f8.1)')
		fbk13_Bwmax_11 = string(fbk13_Bwmax_11,format='(f8.1)')
		fbk13_Bwmax_12 = string(fbk13_Bwmax_12,format='(f8.1)')



;		if finite(min_sep) ne 0 then begin

		openw,lun,paths.immediate_conjunction_values + fnopen,/get_lun,/append
		printf,lun,tstart+' '+tend+' '+tminsep+lshell_min_rb+lshell_min_fb+$
		mlt_min_rb+mlt_min_fb+min_sep+min_dL+min_dMLT+max_flux_context+$
		nsec_emf+nsec_b1+nsec_b2+$
		totallowfspec_E+maxlowfspec_E+avglowfspec_E+medianlowfspec_E+$
		totalchorusspecL_E+maxchorusspecL_E+avgchorusspecL_E+medianchorusspecL_E+$
		totalchorusspecU_E+maxchorusspecU_E+avgchorusspecU_E+medianchorusspecU_E+$
		totalhighfspec_E+maxhighfspec_E+avghighfspec_E+medianhighfspec_E+$
		totallowfspec_B+maxlowfspec_B+avglowfspec_B+medianlowfspec_B+$
		totalchorusspecL_B+maxchorusspecL_B+avgchorusspecL_B+medianchorusspecL_B+$
		totalchorusspecU_B+maxchorusspecU_B+avgchorusspecU_B+medianchorusspecU_B+$
		totalhighfspec_B+maxhighfspec_B+avghighfspec_B+medianhighfspec_B+$
		fbk7_Ewmax_3+fbk7_Ewmax_4+fbk7_Ewmax_5+fbk7_Ewmax_6+$
		fbk7_Bwmax_3+fbk7_Bwmax_4+fbk7_Bwmax_5+fbk7_Bwmax_6+$
		fbk13_Ewmax_6+fbk13_Ewmax_7+fbk13_Ewmax_8+fbk13_Ewmax_9+fbk13_Ewmax_10+fbk13_Ewmax_11+fbk13_Ewmax_12+$
		fbk13_Bwmax_6+fbk13_Bwmax_7+fbk13_Bwmax_8+fbk13_Bwmax_9+fbk13_Bwmax_10+fbk13_Bwmax_11+fbk13_Bwmax_12
		close,lun
		free_lun,lun



    print,tstart+' '+tend+' '+tminsep+lshell_min_rb+lshell_min_fb+$
    mlt_min_rb+mlt_min_fb+min_sep+min_dL+min_dMLT+max_flux_context+$
    nsec_emf+nsec_b1+nsec_b2+$
    totallowfspec_E+maxlowfspec_E+avglowfspec_E+medianlowfspec_E+$
    totalchorusspecL_E+maxchorusspecL_E+avgchorusspecL_E+medianchorusspecL_E+$
    totalchorusspecU_E+maxchorusspecU_E+avgchorusspecU_E+medianchorusspecU_E+$
    totalhighfspec_E+maxhighfspec_E+avghighfspec_E+medianhighfspec_E+$
    totallowfspec_B+maxlowfspec_B+avglowfspec_B+medianlowfspec_B+$
    totalchorusspecL_B+maxchorusspecL_B+avgchorusspecL_B+medianchorusspecL_B+$
    totalchorusspecU_B+maxchorusspecU_B+avgchorusspecU_B+medianchorusspecU_B+$
    totalhighfspec_B+maxhighfspec_B+avghighfspec_B+medianhighfspec_B+$
    fbk7_Ewmax_3+fbk7_Ewmax_4+fbk7_Ewmax_5+fbk7_Ewmax_6+$
    fbk7_Bwmax_3+fbk7_Bwmax_4+fbk7_Bwmax_5+fbk7_Bwmax_6+$
    fbk13_Ewmax_6+fbk13_Ewmax_7+fbk13_Ewmax_8+fbk13_Ewmax_9+fbk13_Ewmax_10+fbk13_Ewmax_11+fbk13_Ewmax_12+$
    fbk13_Bwmax_6+fbk13_Bwmax_7+fbk13_Bwmax_8+fbk13_Bwmax_9+fbk13_Bwmax_10+fbk13_Bwmax_11+fbk13_Bwmax_12





			;tcenter = (t0z + t1z)/2.
			;ttmp = strmid(time_string(t0z),11,2)+strmid(time_string(t0z),14,2)+strmid(time_string(t0z),17,2)
			;daystr = strmid(currday,0,4)+strmid(currday,5,2)+strmid(currday,8,2)
			;	popen,'~/Desktop/'+rb+'_'+fb+'_'+daystr+'_'+ttmp+'_conjunction.ps'
			;		!p.charsize = 0.8
			;		timespan,t0z,(t1z-t0z),/sec
			;		tplot_options,'title','find_rbsp_burst_availability_for_conjunctions.pro'
			;		tplot,['fb_conjunction_times',strlowcase(fb)+'_fb_col_hires_flux',strlowcase(fb)+'_fb_sur_hires_flux',$
			;		;rb+'_lshell',rb+'_mlt',$
			;		'lcomb','mltcomb','minsep_tc_comb','ldiff_tc_comb','mltdiff_tc_comb',$
			;		rb+'_efw_64_spec0_comb',rb+'_efw_64_spec4_comb',$
			;		rb+'_efw_mscb1_available',rb+'_efw_mscb2_available',$
			;		rb+'_emfisis_burst']
			;		timebar,min_sep_time
			;	pclose


;		endif   ;Resulting data not NaNs

	endif  ;for no missing data
endfor
end
