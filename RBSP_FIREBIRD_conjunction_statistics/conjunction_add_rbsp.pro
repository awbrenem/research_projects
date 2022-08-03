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




;**********************************************
;POSSIBLE ISSUES 

;**********************************************




;---------------------------------------------------------------
;User input
;---------------------------------------------------------------

testing = 0
hires = 1   ;conjunctions w/ hires only?
noplot = 1

probe = 'a'
fb = 'FU4'
pmtime = 60.  ;plus/minus time (min) from closest conjunction for data consideration

minwavefreq = 60.  ;(Hz) Lowest freq to be considered for nonchorus. Having too low (e.g. 20 Hz) exposes the analysis to the 
				;abnormally large power at the lowest spectral bins


;ADVICE: KEEP THIS VARIABLE SET TO 1.  Broadband low freq power at <0.1 fce can sometimes extend into the chorus band and contaminate chorus id. 
;This can be very common in later mission when spectra are noisy. 
remove_chorus_when_concurrent_lowf = 1.


;---------------------------------------------------------------
;Load data and set output path
;---------------------------------------------------------------

paths = get_project_paths()


;Grab local path to save data
homedir = (file_search('~',/expand_tilde))[0]+'/'
pathoutput = paths.IMMEDIATE_CONJUNCTION_VALUES
if hires then suffix = '_conjunctions_hr.sav' else suffix = '_conjunctions.sav'




;------------------------------------------------------------
;Conjunction data for all the FIREBIRD passes with HiRes data
;------------------------------------------------------------


fn = fb+'_'+'RBSP'+strupcase(probe)+suffix
restore,paths.breneman_conjunctions + fn


rb = 'rbsp'+probe

tfb0 = t0
tfb1 = t1



;------------------------------------------------------------
;Print list of times so user can select conjunction to start on
;------------------------------------------------------------

for bb=0,n_elements(tfb0)-1 do print,bb,' ',time_string(tfb0[bb])



;---------------------------------------------------------------------------------
;Main loop for every conjunction
;---------------------------------------------------------------------------------

for j=0.,n_elements(tfb0)-1 do begin

	;Make sure all the variables created by time_clip are deleted b/c if time_clip finds no data in requested timerange
	;then it won't overwrite previous values. 
	store_data,'*_tc',/del


  ;--------------------------------------------
	;Manually select the conjunction to start on.
	if j eq 0 then stop
	j = float(j)
	;--------------------------------------------



  ;-----------------------------------------------------------------------
  ;Set timerange either to a single day, or two days if a conjunction crosses the day boundary
  ;-----------------------------------------------------------------------

	tstart = time_string(tfb0[j])  ; - (pmtime+10.)*60.
	tend   = time_string(tfb0[j] + (pmtime+10.)*60.)
	ndays_load = floor((time_double(strmid(tend,0,10)) - time_double(strmid(tstart,0,10)))/86400 + 1)


	currday = strmid(time_string(tfb0[j]),0,10)
	timespan,currday,ndays_load,/days

	nextday = strmid(time_string(time_double(currday)+86400),0,10)
	trange = [currday,nextday]



  ;-----------------------------------------------------------------------
	;***DON'T REMOVE!!!!  Need to do this each time or else the amplitudes can get filled in incorrectly.
	;-----------------------------------------------------------------------

	store_data,'*',/delete


	;-----------------------------------------------------------------------
	;load FIREBIRD context data. 
	;Lots of missing FIREBIRD data, so before we load all the other data we'll test to see if it's been loaded.
	;If not, then skip to next data
	;-----------------------------------------------------------------------


	firebird_load_context_data_cdf_file,strmid(fb,2,1)    ;(used to test for "missingdata" only)


	xtst1 = tsample('flux_context_'+fb,[time_double(trange[0]),time_double(trange[1])])
	missingdata = 0
	if n_elements(xtst1) eq 1 and finite(xtst1[0]) eq 0 then missingdata = 1



  ;-----------------------------------------------------------------------
  ;FIREBIRD context data loaded then load all other data and proceed with code 
  ;-----------------------------------------------------------------------

	if missingdata ne 1 then begin	

    rbsp_load_efw_cdf,probe,'l2','fbk'
    rbsp_load_ephem_cdf,probe
    rbsp_load_emfisis_cdf,probe,'l3','4sec/gsm'
    rbsp_load_emfisis_cdf,probe,'l2','wfr/spectral-matrix'

    ;--------------------------------------------------
    ;Get burst times
    ;This is a bit complicated for spinperiod data b/c the short
    ;B2 snippets can be less than the spinperiod.
    ;So, I'm padding the B2 times by +/- a half spinperiod so that they don't
    ;disappear upon interpolation to the spinperiod data.
    ;--------------------------------------------------

    ;B1 times and rates
    b1t = ''  ;make sure this is reset
    b1t = rbsp_get_burst_times_rates_list(probe)

    ;B2 times
    b2t = ''  ;make sure this is reset
    b2t = rbsp_get_burst2_times_list(probe)

    ;EMFISIS burst times
    rbsp_load_emfisis_burst_times,probe



    ;----------------------------------
    ;Get rid of negative Bo magnitude values
    ;----------------------------------

    get_data,'Magnitude',data=d,dlim=dlim
    goo = where(d.y lt 0.)
    if goo[0] ne -1 then d.y[goo] = !values.f_nan
    store_data,'Magnitude',data=d,dlim=dlim


    ;---------------------------------
    ;Change EMFISIS units of EuEu to (mV/m)^2/Hz
    ;---------------------------------

    get_data,'EuEu',data=d,dlim=dlim
    dlim.ysubtitle = '[mV^2/m^2/Hz]'
    dlim.cdf.vatt.units = 'mV^2/m^2/Hz'
    d.y *= 1000.*1000.
    store_data,'EuEu',data=d,dlim=dlim
    zlim,'EuEu',1d-6,1d0,1

    ;---------------------------------
    ;Change FBK scmw values to pT
    ;---------------------------------

    get_data,'fbk7_scmw_pk',data=d,dlim=dlim
    dlim.ysubtitle = '[pT]'
    dlim.cdf.vatt.units = 'pT'
    d.y *= 1000.
    store_data,'fbk7_scmw_pk',data=d,dlim=dlim



    ;----------------------------------------------------------------------
		;create conjunction times tplot variable (via artifical times array with 1-sec cadence for timerange requested)
		;----------------------------------------------------------------------

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



    ;----------------------------------------------------------------------
    ;create fce tplot variables
    ;----------------------------------------------------------------------


    fce_tplot_lines_create,'Magnitude',[1.,0.5,0.1,1/1836.],$
      tspectra=['EuEu','BwBw'],tmlat=rb+'_mlat',$
      fnames=['fce_eq','fce_eq_2','fce_eq_10','fci_eq']



    ;----------------------------------------------------------------------
		;Set tlimits for conjunction
		;----------------------------------------------------------------------

		get_data,'fb_conjunction_times',ttmp,dtmp
		goo = where(dtmp eq 1)
		tmid = (ttmp[goo[0]] + ttmp[goo[n_elements(goo)-1]])/2.
		t0z = tmid - pmtime*60.
		t1z = tmid + pmtime*60.


		print,time_string(t0z)
		print,time_string(t1z)



  	;-------------------------------------------------------------------------
  	;Find how many seconds of burst availability there is in the timerange t0z to t1z
  	;-------------------------------------------------------------------------

		;EMFISIS burst data
		get_data,rb+'_emfisis_burst',t,d
		goo = where((t ge t0z) and (t le t1z))
		nsec_emf = !values.f_nan
		if goo[0] ne -1 then begin
			dtots = total(d[goo],/nan)
			sr = sample_rate(t)
			sr = median(sr)
			nsec_emf = dtots/sr  ;total time in sec
		endif


		;EFW B2
		;...create artificial array of times.
    timestmp = time_double(currday) + dindgen(100.*86400.)/99.
		valstmp = fltarr(n_elements(timestmp))
		cadence = n_elements(timestmp)/86400.
		nsec_b2 = !values.f_nan
		if is_struct(b2t) then begin
			for i=0,n_elements(b2t.duration)-1 do begin $
					goo = where((timestmp ge b2t.startb2[i]) and (timestmp le b2t.endb2[i])) & $
					if goo[0] ne -1 then valstmp[goo] = 1.
			endfor
			goo = where((timestmp ge t0z) and (timestmp le t1z))
			if goo[0] ne -1 then nsec_b2 = total(valstmp[goo])/cadence
		endif


		;EFW B1
    timestmp = time_double(currday) + dindgen(100.*86400.)/99.
		valstmp = fltarr(n_elements(timestmp))
		cadence = n_elements(timestmp)/86400.
		nsec_b1 = !values.f_nan
		if is_struct(b1t) then begin
			for i=0,n_elements(b1t.duration)-1 do begin $
					goo = where((timestmp ge b1t.startb1[i]) and (timestmp le b1t.endb1[i])) & $
					if goo[0] ne -1 then valstmp[goo] = 1.
			endfor
			goo = where((timestmp ge t0z) and (timestmp le t1z))
			if goo[0] ne -1 then nsec_b1 = total(valstmp[goo])/cadence
		endif

	


		;-----------------------------------------------------------
		;Find the average spectral power in various frequency bands within +/-1 hr of conjunction
		;-----------------------------------------------------------


    ;Names for splitting the spectra up
		mintmp = strtrim(floor(minwavefreq),2)
		channelnamesE = 'E_'+['0',mintmp+'Hz','0.1fce','0.5fce','fce','7300Hz']
		channelnamesB = 'B_'+['0',mintmp+'Hz','0.1fce','0.5fce','fce','7300Hz']

    get_data,'EuEu',data=dd,dlim=dlimE,lim=limE
    get_data,'BwBw',data=dd,dlim=dlimB,lim=limB
		spectmpE = tsample('EuEu',[t0z,t1z],times=ttspec)
		spectmpB = tsample('BwBw',[t0z,t1z],times=ttspec)


    tinterpol_mxn,'fce_eq','EuEu'
		fcetmp = tsample('fce_eq_interp',[t0z,t1z],times=ttfce)


		if finite(fcetmp[0]) then begin 

		freq_lowlimit = replicate(minwavefreq,n_elements(fcetmp))
			
		;frequency lines that will be used to divide up the spectra
		freqbands = [[freq_lowlimit],[fcetmp/10.],[fcetmp/2.],[fcetmp]]
		store_data,'fces',ttfce,freqbands

		store_data,'spectmpE',ttspec,spectmpE,dd.v,dlim=dlimE,lim=limE
		store_data,'spectmpB',ttspec,spectmpB,dd.v,dlim=dlimB,lim=limB
		
		spectrum_split_by_band,'spectmpE','fces',chnames=channelnamesE,wv=wave_valsE
		spectrum_split_by_band,'spectmpB','fces',chnames=channelnamesB,wv=wave_valsB
		
				
		endif else begin
  		wave_valsE = replicate(!values.f_nan,n_elements(channelnames),7)
  		wave_valsB = replicate(!values.f_nan,n_elements(channelnames),7)
		endelse


		goo = where(wave_valsE eq 0.)
		if goo[0] ne -1 then wave_valsE[goo] = !values.f_nan    
		goo = where(wave_valsB eq 0.)
		if goo[0] ne -1 then wave_valsB[goo] = !values.f_nan


		copy_data,'spec_'+channelnamesE[1]+'-'+channelnamesE[2],'tmpLF_E'
		copy_data,'spec_'+channelnamesE[2]+'-'+channelnamesE[3],'tmpLB_E'
		copy_data,'spec_'+channelnamesE[3]+'-'+channelnamesE[4],'tmpUB_E'
		copy_data,'spec_'+channelnamesE[4]+'-'+channelnamesE[5],'tmpHF_E'

		copy_data,'spec_'+channelnamesB[1]+'-'+channelnamesB[2],'tmpLF_B'
		copy_data,'spec_'+channelnamesB[2]+'-'+channelnamesB[3],'tmpLB_B'
		copy_data,'spec_'+channelnamesB[3]+'-'+channelnamesB[4],'tmpUB_B'
		copy_data,'spec_'+channelnamesB[4]+'-'+channelnamesB[5],'tmpHF_B'



	;--------------------------------------------------------------------------------------------------
    ;A common problem is that low freq broadband spikes/noise leaks into the chorus bands.
    ;Here, remove chorus power if the broadband power at the highest frequency of the low frequency 
    ;waves (f<0.1fce, typically) at each time is than the max power in the chorus bands. 
	;--------------------------------------------------------------------------------------------------

    if remove_chorus_when_concurrent_lowf then begin
      get_data,'tmpLF_E',data=lf
      get_data,'tmpLB_E',data=lb
      get_data,'tmpUB_E',data=ub

      for w=0,n_elements(lf.x)-1 do begin 
        ;identify max freq of low band power with actual wave power (not NaN)
        goo = where((lf.v gt minwavefreq) and (finite(lf.y[w,*])))
        if goo[0] ne -1 then begin
          goomax = goo[n_elements(goo)-1]  
          if lf.y[w,goomax] gt max(lb.y[w,*],/nan) then lb.y[w,*] = !values.f_nan
          if lf.y[w,goomax] gt max(ub.y[w,*],/nan) then ub.y[w,*] = !values.f_nan
        endif
      endfor
      store_data,'tmpLB_E',data=lb
      store_data,'tmpUB_E',data=ub


      get_data,'tmpLF_B',data=lf
      get_data,'tmpLB_B',data=lb
      get_data,'tmpUB_B',data=ub

      for w=0,n_elements(lf.x)-1 do begin
        goo = where((lf.v gt minwavefreq) and (finite(lf.y[w,*])))
        if goo[0] ne -1 then begin
          goomax = goo[n_elements(goo)-1]
          if lf.y[w,goomax] gt max(lb.y[w,*],/nan) then lb.y[w,*] = !values.f_nan
          if lf.y[w,goomax] gt max(ub.y[w,*],/nan) then ub.y[w,*] = !values.f_nan
        endif
      endfor
      store_data,'tmpLB_B',data=lb
      store_data,'tmpUB_B',data=ub
    endif




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


    ;------------------------------------------------
		;Find absolute value of sc separation. We'll use the min value of this to define dLmin and dMLTmin
		;------------------------------------------------

		sc_absolute_separation,rb+'_lshell_interp_tc','fb_mcilwainL_tc',rb+'_mlt_interp_tc','fb_mlt_tc'



		if testing then begin
		  ylim,'separation_absolute',-20,20
		  options,['separation_absolute','ldiff_tc','mltdiff_tc',rb+'_lshell_interp_tc',rb+'_mlt_interp_tc','fb_mlt_tc','fb_mcilwainL_tc'],'psym',-2
		  tplot,[rb+'_lshell_interp_tc','fb_mcilwainL_tc',rb+'_mlt_interp_tc','fb_mlt_tc']
		  stop
		  tplot,['separation_absolute','ldiff_tc','mltdiff_tc',rb+'_lshell_interp_tc',rb+'_mlt_interp_tc','fb_mlt_tc','fb_mcilwainL_tc']
		  stop
		endif



;		;define minimum dL and dMLT values by the time when the absolute separation is a minimum
		get_data,'separation_absolute',tt,dat


		whsep = -1
		min_sep = !values.f_nan
		min_sep_time = !values.f_nan
		min_dmlt = !values.f_nan
		min_dL = !values.f_nan



		boo = where((tt ge t0[j]) and (tt le t1[j]))
		if boo[0] ne -1 then begin
			min_sep = min(dat[boo],/nan,whsep)
			min_sep_time = tt[boo[whsep]]
			get_data,'mltdiff_tc',tt,dat
			min_dmlt = dat[boo[whsep]]
			get_data,'ldiff_tc',tt,dat
			min_dL = dat[boo[whsep]]
		endif 



		get_data,rb+'_lshell',tforline,ddd
		store_data,'minsepline',data={x:tforline,y:replicate(min_sep,n_elements(tforline))}
		options,'minsepline','linestyle',2
		store_data,'minsep_tc_comb',data=['separation_absolute','minsepline']
		options,'separation_absolute','psym',-2
		ylim,'minsep_tc_comb',0.001,4,1






		if testing then begin
		  store_data,'mindmltline',data={x:ttt,y:replicate(min_dmlt,n_elements(ttt))}
		  store_data,'mltdiff_tc_comb',data=['mltdiff_tc','mindmltline']
		  store_data,'mindLline',data={x:ttt,y:replicate(min_dl,n_elements(ttt))}
		  store_data,'ldiff_tc_comb',data=['ldiff_tc','mindLline']

		  options,'mindmltline','linestyle',2
		  options,'mindLline','linestyle',2
		  options,['ldiff_tc','mltdiff_tc'],'psym',-2

		  ylim,'ldiff_tc_comb',-20,20

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

    ;-------------------------------------------------------------------------------------------
		;There are quite a number of orbits where there's no overlapping FB and RBSP ephemeris data. 
		;When this is the case, determine the RBSP L, MLT values as the average value during the start 
		;and stop of the conjunction. Nothing I can do about the missing FB data, but at least the RBSP
		;data will tell me where the conjunction took place.  
		;DON'T use the interpolated values for this b/c the FB gaps show up in the RBSP ephemeris data
		;-------------------------------------------------------------------------------------------


		if finite(lshell_min_rb) eq 0 then begin 
			l2_probe = tsample(rb+'_lshell',[t0[j],t1[j]],times=t)
			lshell_min_rb = mean(l2_probe,/nan)
			mlt2_probe = tsample(rb+'_mlt',[t0[j],t1[j]],times=t)
			mlt_min_rb = mean(mlt2_probe,/nan)
		endif

		;Sometimes the FB values are outrageous.
		if min_sep gt 100. then begin 
			min_sep = !values.f_nan
			min_dL = !values.f_nan
			lshell_min_fb = !values.f_nan
		endif




    ;---------------------------------------------------------------------
    ;Get the max value of the FIREBIRD context flux 
    ;---------------------------------------------------------------------

    time_clip,'flux_context_'+fb,t0[j],t1[j],newname='flux_context_'+fb+'_tc'

		get_data,'flux_context_'+fb+'_tc',tt,dat
		max_flux_context = max(dat,/nan)
		if max_flux_context eq 0 then max_flux_context = !values.f_nan


		;---------------------------------------------------------------------
    ;Figure out if we're dealing with e12 or e34 for FBK data 
    ;---------------------------------------------------------------------

    e1234 = ''
		tstvar = tnames('fbk7_e??dc_pk')
		if tstvar ne '' then e1234 = strmid(tstvar,5,3)
		tstvar = tnames('fbk13_e??dc_pk')
		if tstvar ne '' then e1234 = strmid(tstvar,6,3)


		;---------------------------------------------------------------
		;Find max filterbank value in various bins for FBK7/FBK13 modes
		;---------------------------------------------------------------------


		;The four channels that I use for FBK7 (50-100; 200-400; 0.8-1.6; 3.2-6.5)
		;The seven channels that I use for FBK13 (50-100; 100-200; 200-400; 400-800; 0.8-1.6; 1.6-3.2; 3.2-6.5)

		fbk7E = fltarr(7)
		fbk7B = fltarr(7)
		fbk13E = fltarr(13)
		fbk13B = fltarr(13)



		undefine,fbktmp_7E, fbktmp_7B, fbktmp_13E, fbktmp_13B

		if tdexists('fbk7_'+e1234+'dc_pk',t0z,t1z) then $
		  fbktmp_7E = tsample('fbk7_'+e1234+'dc_pk',[t0z,t1z])
		if tdexists('fbk7_scmw_pk',t0z,t1z) then $
		  fbktmp_7B = tsample('fbk7_scmw_pk',[t0z,t1z])
		if tdexists('fbk13_'+e1234+'dc_pk',t0z,t1z) then $
		  fbktmp_13E = tsample('fbk13_'+e1234+'dc_pk',[t0z,t1z])
		if tdexists('fbk13_scmw_pk',t0z,t1z) then $
		  fbktmp_13B = tsample('fbk13_scmw_pk',[t0z,t1z])



		;Find max filterbank value in various bins for FBK7 mode
		if keyword_set(fbktmp_7E) then begin
		  for ch=0,6 do fbk7E[ch] = float(max(fbktmp_7E[*,ch],/nan))
		endif else for ch=0,6 do fbk7E[ch] = !values.f_nan
		if keyword_set(fbktmp_7B) then begin
		  for ch=0,6 do fbk7B[ch] = float(max(fbktmp_7B[*,ch],/nan))
		endif else for ch=0,6 do fbk7B[ch] = !values.f_nan


		;Find max filterbank value in various bins for FBK13 mode
		if keyword_set(fbktmp_13E) then begin
		  for ch=0,12 do fbk13E[ch] = float(max(fbktmp_13E[*,ch],/nan))
		endif else for ch=0,12 do fbk13E[ch] = !values.f_nan
		if keyword_set(fbktmp_13B) then begin
		  for ch=0,12 do fbk13B[ch] = float(max(fbktmp_13B[*,ch],/nan))
		endif else for ch=0,12 do fbk13B[ch] = !values.f_nan




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


    ;---------------------------------------------------------------------
    ;Output file name
    ;---------------------------------------------------------------------


		if hires then fnopen = 'RBSP'+probe+'_'+fb+'_conjunction_values_hr.txt' $
		else fnopen = 'RBSP'+probe+'_'+fb+'_conjunction_values.txt'
		result = FILE_TEST(pathoutput + fnopen)



    ;------------------------------------------------------------------	
    ;If first time opening file, then print the header
    ;For detailed header info see RBSP_FU_conjunction_header.fmt
    ;------------------------------------------------------------------

		if not result then begin
			openw,lun,paths.immediate_conjunction_values + fnopen,/get_lun
						printf,lun,'Conjunction data for RBSP'+probe+' and '+fb + ' from Shumko file ' + fb+'_'+rb+'_conjunctions_dL10_dMLT10_final.txt'
			close,lun
			free_lun,lun
		endif


		;---------------------------------------------------------------------
    ;Format all of the variables for output
    ;---------------------------------------------------------------------


		tstart = time_string(t0[j])
		tend = time_string(t1[j])
		tminsep = time_string(min_sep_time,tformat='YYYY-MM-DD/hh:mm:ss')



    ;format statement for final output
;    fmt = '(3(a19,2x),7(f7.2,1x),1(I10,2x),3(I5,2x),24(f17.11,2x),20(f5.1,2x))'
    fmt = '(3(a19,2x),7(f7.2,1x),1(I10,2x),3(I5,2x),56(e8.2,2x),20(f6.1,2x))'


;		if finite(min_sep) ne 0 then begin

		openw,lun,paths.immediate_conjunction_values + fnopen,/get_lun,/append
		printf,lun,tstart,tend,tminsep,$
		lshell_min_rb,lshell_min_fb,$
		mlt_min_rb,mlt_min_fb,$
		min_sep,min_dL,min_dMLT,$
		max_flux_context,nsec_emf,nsec_b1,nsec_b2,$
    wave_valsE[1,0], wave_valsE[1,1], wave_valsE[1,2], wave_valsE[1,3], wave_valsE[1,4], wave_valsE[1,5], wave_valsE[1,6], $
    wave_valsE[2,0], wave_valsE[2,1], wave_valsE[2,2], wave_valsE[2,3], wave_valsE[2,4], wave_valsE[2,5], wave_valsE[2,6], $
    wave_valsE[3,0], wave_valsE[3,1], wave_valsE[3,2], wave_valsE[3,3], wave_valsE[3,4], wave_valsE[3,5], wave_valsE[3,6], $
    wave_valsE[4,0], wave_valsE[4,1], wave_valsE[4,2], wave_valsE[4,3], wave_valsE[4,4], wave_valsE[4,5], wave_valsE[4,6], $
    wave_valsB[1,0], wave_valsB[1,1], wave_valsB[1,2], wave_valsB[1,3], wave_valsB[1,4], wave_valsB[1,5], wave_valsB[1,6], $
    wave_valsB[2,0], wave_valsB[2,1], wave_valsB[2,2], wave_valsB[2,3], wave_valsB[2,4], wave_valsB[2,5], wave_valsB[2,6], $
    wave_valsB[3,0], wave_valsB[3,1], wave_valsB[3,2], wave_valsB[3,3], wave_valsB[3,4], wave_valsB[3,5], wave_valsB[3,6], $
    wave_valsB[4,0], wave_valsB[4,1], wave_valsB[4,2], wave_valsB[4,3], wave_valsB[4,4], wave_valsB[4,5], wave_valsB[4,6], $
		fbk7E[3],fbk7E[4],fbk7E[5],fbk7E[6],$
		fbk7B[3],fbk7B[4],fbk7B[5],fbk7B[6],$
		fbk13E[7],fbk13E[8],fbk13E[9],fbk13E[10],fbk13E[11],fbk13E[12],$
		fbk13B[7],fbk13B[8],fbk13B[9],fbk13B[10],fbk13B[11],fbk13B[12],format=fmt
		close,lun
    free_lun,lun

 


;    print,tstart,tend,tminsep,$
;    lshell_min_rb,lshell_min_fb,$
;    mlt_min_rb,mlt_min_fb,$
;    min_sep,min_dL,min_dMLT,$
;    max_flux_context,nsec_emf,nsec_b1,nsec_b2,$
;    wave_valsE[1,0], wave_valsE[1,1], wave_valsE[1,2], wave_valsE[1,3], wave_valsE[1,4], wave_valsE[1,5], wave_valsE[1,6], $
;    wave_valsE[2,0], wave_valsE[2,1], wave_valsE[2,2], wave_valsE[2,3], wave_valsE[2,4], wave_valsE[2,5], wave_valsE[2,6], $
;    wave_valsE[3,0], wave_valsE[3,1], wave_valsE[3,2], wave_valsE[3,3], wave_valsE[3,4], wave_valsE[3,5], wave_valsE[3,6], $
;    wave_valsE[4,0], wave_valsE[4,1], wave_valsE[4,2], wave_valsE[4,3], wave_valsE[4,4], wave_valsE[4,5], wave_valsE[4,6], $
;    wave_valsB[1,0], wave_valsB[1,1], wave_valsB[1,2], wave_valsB[1,3], wave_valsB[1,4], wave_valsB[1,5], wave_valsB[1,6], $
;    wave_valsB[2,0], wave_valsB[2,1], wave_valsB[2,2], wave_valsB[2,3], wave_valsB[2,4], wave_valsB[2,5], wave_valsB[2,6], $
;    wave_valsB[3,0], wave_valsB[3,1], wave_valsB[3,2], wave_valsB[3,3], wave_valsB[3,4], wave_valsB[3,5], wave_valsB[3,6], $
;    wave_valsB[4,0], wave_valsB[4,1], wave_valsB[4,2], wave_valsB[4,3], wave_valsB[4,4], wave_valsB[4,5], wave_valsB[4,6], $
;    fbk7E[3],fbk7E[4],fbk7E[5],fbk7E[6],$
;    fbk7B[3],fbk7B[4],fbk7B[5],fbk7B[6],$
;    fbk13E[7],fbk13E[8],fbk13E[9],fbk13E[10],fbk13E[11],fbk13E[12],$
;    fbk13B[7],fbk13B[8],fbk13B[9],fbk13B[10],fbk13B[11],fbk13B[12],format=fmt
;
;
;stop




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


		endif   ;Resulting data not NaNs
endfor
end
