;Determines properties of chorus waves during FB/RBSP conjunctions.
;(formerly master_conjunction_list_part3.pro)


;This takes all the conjunction files produced from conjunction_create_sav_file.pro (which itself uses Mike Shumko's conjunction lists) 
;and determines how much burst data (EFW/EMFISIS) is nearby, and FBK amplitudes (both FBK7 and FBK13) near conjunction, etc.



;For each FB/RBSP combination, outputs one of the following .txt files:
;RBSP?_FU?_conjunction_values.txt     (all conjunctions)
;RBSP?_FU?_conjunction_values_hr.txt  (conjunctions that have hires FIREBIRD data)
;to  /github/research_projects/RBSP_FIREBIRD_conjunction_statistics/conjunction_values/immediate_conjunction_values/'


;Also saves a plot of the conjunction.
;--Change "zeroline" for dL, dMLT to the actual value at the minimum separation.


;NOTES:
    ;Even though the hires times have L and MLT values, I'm using the survey values. They match up essentially 
    ;identically and there's consistency b/t the hires and non hires versions. 

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

probe = 'b'
fb = 'FU4'
pmtime = 60.  ;plus/minus time (min) from closest conjunction for data consideration
dettime = 0.75 ;(sec)  Time for detrending the hires data in order to obtain microburst amplitudes.
;See firebird_subtract_tumble_from_hiresdata_testing.pro


;---------------------------------------------------------------





paths = get_project_paths()




;Grab local path to save data
homedir = (file_search('~',/expand_tilde))[0]+'/'
;pathoutput = homedir + 'Desktop/'



if hires then suffix = '_conjunctions_hr.sav' else suffix = '_conjunctions.sav'




;--------------
;Conjunction data for all the FIREBIRD passes with HiRes data
;path = homedir + 'Desktop/code/Aaron/github/research_projects/RBSP_Firebird_microburst_conjunctions_all/'


;pathoutput = '/'+strvals[0]+'/'+strvals[1]+'/Desktop/'


fn = fb+'_'+'RBSP'+strupcase(probe)+suffix
restore,path.breneman_conjunctions + fn




tfb0 = t0
tfb1 = t1

;Print list of times
for bb=0,n_elements(tfb0)-1 do print,bb,' ',time_string(tfb0[bb])
;for bb=1900,2200 do print,bb,' ',time_string(tfb0[bb]),'  ',time_string(tfb1[bb])


daytst = '0000-00-00'   ;used as a test to see if we need to load another day's data


;For every conjunction
for j=0.,n_elements(tfb0)-1 do begin

	;Make sure all the variables created by time_clip are deleted b/c if time_clip finds no data in requested timerange
	;then it won't overwrite previous values. 
	store_data,'*_tc',/del



	;Manually select the conjunction to start on.
	if j eq 0 then stop
	j = float(j)

	;Figure out if we have to load more than one day of data.
	tstart = time_string(tfb0[j])  ; - (pmtime+10.)*60.
	tend   = time_string(tfb0[j] + (pmtime+10.)*60.)
	ndays_load = (time_double(strmid(tend,0,10)) - time_double(strmid(tstart,0,10)))/86400 + 1

	;cal = firebird_get_calibration_counts2flux(strmid(tstart,0,10),strmid(fb,2,1))


	currday = strmid(time_string(tfb0[j]),0,10)
	timespan,currday,ndays_load,/days

	nextday = strmid(time_string(time_double(currday)+86400),0,10)
	trange = [currday,nextday]


	load_new_data = daytst ne currday


	;Load new data if required
	if load_new_data or ndays_load gt 1 then begin
		if testing then stop
		if ndays_load eq 1 then daytst = currday
		if ndays_load gt 1 then daytst = nextday


		;Need to do this each time or else the amplitudes can get filled in incorrectly.
		;***DON'T REMOVE!!!!
		store_data,'*',/delete



		;Load FIREBIRD hires data per day (if there is any)
		timespan,trange[0]

		;store_data,strlowcase(fb)+'_fb_col_hires_flux',/del

		;;Load hires data, if there is any
		;firebird_load_data,strmid(fb,2,1),fileexists=fb_hiresexists


		;load context data
		firebird_load_context_data_cdf_file,strmid(fb,2,1)



		if ndays_load eq 2 then begin
			copy_data,'flux_context_'+fb,'flux_context_'+fb + '1'
;			copy_data,'D1','D11'
			copy_data,'MLT','MLT1'
			copy_data,'McIlwainL','McIlwainL1'

			timespan,trange[1]
			firebird_load_context_data_cdf_file,strmid(fb,2,1)

			;Combine both days
			get_data,'flux_context_'+fb,vx,d & get_data,'flux_context_'+fb + '1',v1x,d1
			store_data,'flux_context_'+fb,[v1x,vx],[d1,d]
			;get_data,'D1',vx,d & get_data,'D11',v1x,d1
			;store_data,'D1',[v1x,vx],[d1,d]
			get_data,'MLT',vx,d & get_data,'MLT1',v1x,d1
			store_data,'MLT',[v1x,vx],[d1,d]
			get_data,'McIlwainL',vx,d & get_data,'McIlwainL1',v1x,d1
			store_data,'McIlwainL',[v1x,vx],[d1,d]
			store_data,['flux_context_'+fb + '1','MLT1','McIlwainL1'],/del
		endif

		;Lots of missing FIREBIRD data, so we'll test to see if it's been loaded.
		;If not, then skip to next data





		xtst1 = tsample('flux_context_'+fb,[time_double(trange[0]),time_double(trange[1])])

		missingdata = 0
		if n_elements(xtst1) eq 1 and finite(xtst1[0]) eq 0 then missingdata = 1



		if missingdata ne 1 then begin

			;These load multi days automatically
			timespan,trange[0],ndays_load
			rbsp_load_efw_spec_l2,probe=probe
			rbsp_load_efw_fbk_l2,probe=probe



			;load first (and maybe only) day of spice data
			timespan,trange[0]
			rbsp_load_spice_cdf_file,probe
			if ndays_load eq 2 then begin

				copy_data,'rbsp'+probe+'_state_lshell','rbsp'+probe+'_state_lshell1'
				copy_data,'rbsp'+probe+'_state_mlt','rbsp'+probe+'_state_mlt1'

				timespan,trange[1]
				rbsp_load_spice_cdf_file,probe

				;Combine both days
				get_data,'rbsp'+probe+'_state_lshell',vx,d & get_data,'rbsp'+probe+'_state_lshell1',v1x,d1
				store_data,'rbsp'+probe+'_state_lshell',[v1x,vx],[d1,d]
				get_data,'rbsp'+probe+'_state_mlt',vx,d & get_data,'rbsp'+probe+'_state_mlt1',v1x,d1
				store_data,'rbsp'+probe+'_state_mlt',[v1x,vx],[d1,d]
				store_data,['rbsp'+probe+'_state_mlt1','rbsp'+probe+'_state_lshell1'],/del

			endif




			;load EMFISIS data for one or two days
			timespan,trange[0]
			rbsp_load_emfisis,probe=probe,level='l3',coord='gsm'
			if ndays_load eq 2 then begin

				copy_data,'rbsp'+probe+'_emfisis_l3_4sec_gsm_Mag','rbsp'+probe+'_emfisis_l3_4sec_gsm_Mag1'
				copy_data,'rbsp'+probe+'_emfisis_l3_4sec_gsm_Magnitude','rbsp'+probe+'_emfisis_l3_4sec_gsm_Magnitude1'
				timespan,trange[1]
				rbsp_load_emfisis,probe=probe,level='l3',coord='gsm'
				;Combine both days
				get_data,'rbsp'+probe+'_emfisis_l3_4sec_gsm_Mag',magx,d
				get_data,'rbsp'+probe+'_emfisis_l3_4sec_gsm_Mag1',mag1x,d1
				store_data,'rbsp'+probe+'_emfisis_l3_4sec_gsm_Mag',[mag1x,magx],[d1,d]

				get_data,'rbsp'+probe+'_emfisis_l3_4sec_gsm_Magnitude',magx,d
				get_data,'rbsp'+probe+'_emfisis_l3_4sec_gsm_Magnitude1',mag1x,d1
				store_data,'rbsp'+probe+'_emfisis_l3_4sec_gsm_Magnitude',[mag1x,magx],[d1,d]
				store_data,'rbsp'+probe+'_emfisis_l3_4sec_gsm_Magnitude1',/del
				store_data,'rbsp'+probe+'_emfisis_l3_4sec_gsm_Mag1',/del

			endif

		endif  ;if not missingdata

	endif  ;load new data




	if missingdata ne 1 then begin


		;create artifical times array with 1-sec cadence for timerange requested.
	;	tr = timerange()
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


		get_data,'rbsp'+probe+'_emfisis_l3_4sec_gsm_Magnitude',ttt,magnit
		fce = 28.*magnit

		tinterpol_mxn,'rbsp'+probe+'_state_mlat',ttt
		get_data,'rbsp'+probe+'_state_mlat_interp',data=mlat
		fce_eq = fce*cos(2*mlat.y*!dtor)^3/sqrt(1+3*sin(mlat.y*!dtor)^2)


		store_data,'fce_eq',ttt,fce_eq
		store_data,'fce_eq_2',ttt,fce_eq/2.
		store_data,'fce_eq_10',ttt,fce_eq/10.
		store_data,'fci_eq',ttt,fce_eq/1836.
		store_data,'flh_eq',ttt,sqrt(fce_eq*fce_eq/1836.)

		store_data,'rbsp'+probe+'_efw_spec64_e12ac_comb',data=['rbsp'+probe+'_efw_spec64_e12ac','fce_eq','fce_eq_2','fce_eq_10'];,'fci_eq','flh_eq']
		store_data,'rbsp'+probe+'_efw_spec64_scmw_comb', data=['rbsp'+probe+'_efw_spec64_scmw','fce_eq','fce_eq_2','fce_eq_10'];,'fci_eq','flh_eq']

		ylim,'rbsp'+probe+'_efw_spec64_e12ac_comb',1,6000,1
		ylim,'rbsp'+probe+'_efw_spec64_scmw_comb',1,6000,1



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

		rbsp_load_emfisis_burst_times,currday,probe

		if ndays_load eq 2 then begin
			copy_data,'rbsp'+probe+'_emfisis_burst','rbsp'+probe+'_emfisis_burst1'
			rbsp_load_emfisis_burst_times,nextday,probe

			get_data,'rbsp'+probe+'_emfisis_burst1',dx0,d0
			get_data,'rbsp'+probe+'_emfisis_burst',dx1,d1
			store_data,'rbsp'+probe+'_emfisis_burst',[dx0,dx1],[d0,d1]
			store_data,'rbsp'+probe+'_emfisis_burst1',/del
		endif



		store_data,'lcomb',data=['rbsp'+probe+'_state_lshell','McIlwainL']
		store_data,'mltcomb',data=['rbsp'+probe+'_state_mlt','MLT']
		options,['MLT','McIlwainL',strlowcase(rb)+'_state_lshell_interp','MLT',strlowcase(rb)+'_state_mlt_interp'],'psym',-2

		options,'lcomb','colors',[0,250]
		options,'mltcomb','colors',[0,250]
;		options,'rbsp'+probe+'_state_lshell','thick',2
;		options,'rbsp'+probe+'_state_mlt','thick',2
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
		get_data,'rbsp'+probe+'_emfisis_burst',t,d
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


		;...now do this for B1
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
		;Find the average spectral power in chorus freq range within
		;+/-1 hr of conjunction
		;-----------------------------------------------------------



		;First the Electric field
		get_data,'rbsp'+probe+'_efw_spec64_e12ac',data=dd,dlim=dlim,lim=lim
		spectmp = tsample('rbsp'+probe+'_efw_spec64_e12ac',[t0z,t1z],times=tt)
		tinterpol_mxn,'fce_eq','rbsp'+probe+'_efw_spec64_e12ac'
		fcetmp = tsample('fce_eq_interp',[t0z,t1z],times=tt)




channelnames = ['0','20','0.1fce','0.5fce','fce','7300Hz']



if finite(fcetmp) then begin 

  freq_lowlimit = replicate(20.,n_elements(fcetmp))
  
  ;frequency lines that will be used to divide up the spectra
  freqbands = [[freq_lowlimit],[fcetmp/10.],[fcetmp/2.],[fcetmp]]
  
  spectrum_split_by_band,spectmp,freqbands,chnames=channelnames,wv=wave_valsE
  
  ;****RENAME THE OUTPUT TPLOT VARIABLES TO  tmpL, tmpU, tmpO
  
  
  ;wv --> set to return wave values of final spectra. Size [nlines,4]. Includes:
  ;wave_vals[*,0] --> total spectral amp/power
  ;wave_vals[*,1] --> max value of spectral amp/power
  ;wave_vals[*,2] --> median value of spectral amp/power
  ;wave_vals[*,3] --> average value of spectral amp/power

endif else wave_valsE = replicate(!values.f_nan,n_elements(channelnames),4)
  



;********************************************************************************************
;********************************************************************************************
;********************************************************************************************
;******THE BELOW SHOULD NOW BE OBFUSCATED BECAUSE OF spectrum_split_by_band.pro
;
;
;		;limit spectral data to chorus only (upper and lower band separately), and to
;		;values outside of chorus range ("other")
;		spectmpL = spectmp & spectmpU = spectmp & spectmpO = spectmp
;		;Remove zero values that screw up average and median calculation
;		goo = where(spectmp eq 0.)
;		if goo[0] ne -1 then spectmpL[goo] = !values.f_nan
;		if goo[0] ne -1 then spectmpU[goo] = !values.f_nan
;		if goo[0] ne -1 then spectmpO[goo] = !values.f_nan
;
;		if finite(fcetmp[0]) and is_struct(dd) then begin
;			for qq=0,n_elements(fcetmp)-1 do begin $
;					gooL = where((dd.v le fcetmp[qq]/10.) or (dd.v ge fcetmp[qq]/2.)) & $
;					gooU = where((dd.v lt fcetmp[qq]/2.)  or (dd.v gt fcetmp[qq])) & $
;					gooO = where((dd.v gt fcetmp[qq]/10.) or (dd.v lt 20.)) & $
;					if gooL[0] ne -1 then spectmpL[qq,gooL] = !values.f_nan & $
;					if gooU[0] ne -1 then spectmpU[qq,gooU] = !values.f_nan & $
;					if gooO[0] ne -1 then spectmpO[qq,gooO] = !values.f_nan
;			endfor
;		endif
;
;		if finite(fcetmp[0]) then begin
;			store_data,'tmpL',tt,spectmpL,dd.v,dlim=dlim,lim=lim
;			store_data,'tmpU',tt,spectmpU,dd.v,dlim=dlim,lim=lim
;			store_data,'tmpO',tt,spectmpO,dd.v,dlim=dlim,lim=lim
;
;			;vague idea of fill factor
;			totalchorusspecL_E = total(spectmpL,/nan)
;			totalchorusspecU_E = total(spectmpU,/nan)
;			totalnonchorusspec_E = total(spectmpO,/nan)
;
;			maxchorusspecL_E = max(spectmpL,/nan)
;			maxchorusspecU_E = max(spectmpU,/nan)
;			maxnonchorusspec_E = max(spectmpO,/nan)
;
;			avgchorusspecL_E = mean(spectmpL,/nan)
;			avgchorusspecU_E = mean(spectmpU,/nan)
;			avgnonchorusspec_E = mean(spectmpO,/nan)
;
;			medianchorusspecL_E = median(spectmpL)
;			medianchorusspecU_E = median(spectmpU)
;			mediannonchorusspec_E = median(spectmpO)
;
;			if totalchorusspecL_E eq 0. then totalchorusspecL_E = !values.f_nan
;			if totalchorusspecU_E eq 0. then totalchorusspecU_E = !values.f_nan
;			if totalnonchorusspec_E eq 0. then totalnonchorusspec_E = !values.f_nan
;			if maxchorusspecL_E eq 0. then maxchorusspecL_E = !values.f_nan
;			if maxchorusspecU_E eq 0. then maxchorusspecU_E = !values.f_nan
;			if maxnonchorusspec_E eq 0. then maxnonchorusspec_E = !values.f_nan
;			if avgchorusspecL_E eq 0. then avgchorusspecL_E = !values.f_nan
;			if avgchorusspecU_E eq 0. then avgchorusspecU_E = !values.f_nan
;			if avgnonchorusspec_E eq 0. then avgnonchorusspec_E = !values.f_nan
;			if medianchorusspecL_E eq 0. then medianchorusspecL_E = !values.f_nan
;			if medianchorusspecU_E eq 0. then medianchorusspecU_E = !values.f_nan
;			if mediannonchorusspec_E eq 0. then mediannonchorusspec_E = !values.f_nan
;
;
;			print,'Totals ',totalnonchorusspec_E,totalchorusspecL_E,totalchorusspecU_E
;			print,'Max ',maxnonchorusspec_E,maxchorusspecL_E,maxchorusspecU_E
;			print,'Avg ',avgnonchorusspec_E,avgchorusspecL_E,avgchorusspecU_E
;			print,'Median ',mediannonchorusspec_E,medianchorusspecL_E,medianchorusspecU_E
;
;		endif else begin
;			totalchorusspecL_E = !values.f_nan
;			totalchorusspecU_E = !values.f_nan
;			totalnonchorusspec_E = !values.f_nan
;
;			maxchorusspecL_E = !values.f_nan
;			maxchorusspecU_E = !values.f_nan
;			maxnonchorusspec_E = !values.f_nan
;
;			avgchorusspecL_E = !values.f_nan
;			avgchorusspecU_E = !values.f_nan
;			avgnonchorusspec_E = !values.f_nan
;
;			medianchorusspecL_E = !values.f_nan
;			medianchorusspecU_E = !values.f_nan
;			mediannonchorusspec_E = !values.f_nan
;
;
;		endelse

;******THE ABOVE SHOULD NOW BE OBFUSCATED BECAUSE OF spectrum_split_by_band.pro
;********************************************************************************************
;********************************************************************************************
;********************************************************************************************
;********************************************************************************************




;		if testing then begin
;			ylim,['tmpU','tmpL','tmpO'],1,6000,1
;			tplot,['rbsp'+probe+'_efw_spec64_e12ac_comb','tmpU','tmpL','tmpO'] & tlimit,t0z,t1z
;		stop
;		endif


		;Now the magnetic field
		get_data,'rbsp'+probe+'_efw_spec64_scmw',data=dd,dlim=dlim,lim=lim
		spectmp = tsample('rbsp'+probe+'_efw_spec64_scmw',[t0z,t1z],times=tt)
		fcetmp = tsample('fce_eq_interp',[t0z,t1z],times=tt)

		;limit spectral data to chorus only (upper and lower band separately), and to
		;values outside of chorus range ("other")
		spectmpL = spectmp & spectmpU = spectmp & spectmpO = spectmp
		;Remove zero values that screw up average and median calculation
		goo = where(spectmp eq 0.)
		if goo[0] ne -1 then spectmpL[goo] = !values.f_nan
		if goo[0] ne -1 then spectmpU[goo] = !values.f_nan
		if goo[0] ne -1 then spectmpO[goo] = !values.f_nan

		if finite(fcetmp[0]) and is_struct(dd) then begin
			for qq=0,n_elements(fcetmp)-1 do begin
					gooL = where((dd.v le fcetmp[qq]/10.) or (dd.v ge fcetmp[qq]/2.))
					gooU = where((dd.v lt fcetmp[qq]/2.)  or (dd.v gt fcetmp[qq]))
					gooO = where((dd.v gt fcetmp[qq]/10.) or (dd.v lt 20.))

					if gooL[0] ne -1 then spectmpL[qq,gooL] = !values.f_nan
					if gooU[0] ne -1 then spectmpU[qq,gooU] = !values.f_nan
					if gooO[0] ne -1 then spectmpO[qq,gooO] = !values.f_nan
			endfor
		endif

		if finite(fcetmp[0]) then begin

			store_data,'tmpL',tt,spectmpL,dd.v,dlim=dlim,lim=lim
			store_data,'tmpU',tt,spectmpU,dd.v,dlim=dlim,lim=lim
			store_data,'tmpO',tt,spectmpO,dd.v,dlim=dlim,lim=lim


			;vague idea of fill factor
			totalchorusspecL_B = total(spectmpL,/nan)
			totalchorusspecU_B = total(spectmpU,/nan)
			totalnonchorusspec_B = total(spectmpO,/nan)

			maxchorusspecL_B = max(spectmpL,/nan)
			maxchorusspecU_B = max(spectmpU,/nan)
			maxnonchorusspec_B = max(spectmpO,/nan)

			avgchorusspecL_B = mean(spectmpL,/nan)
			avgchorusspecU_B = mean(spectmpU,/nan)
			avgnonchorusspec_B = mean(spectmpO,/nan)

			medianchorusspecL_B = median(spectmpL)
			medianchorusspecU_B = median(spectmpU)
			mediannonchorusspec_B = median(spectmpO)

			if totalchorusspecL_B eq 0. then totalchorusspecL_B = !values.f_nan
			if totalchorusspecU_B eq 0. then totalchorusspecU_B = !values.f_nan
			if totalnonchorusspec_B eq 0. then totalnonchorusspec_B = !values.f_nan
			if maxchorusspecL_B eq 0. then maxchorusspecL_B = !values.f_nan
			if maxchorusspecU_B eq 0. then maxchorusspecU_B = !values.f_nan
			if maxnonchorusspec_B eq 0. then maxnonchorusspec_B = !values.f_nan
			if avgchorusspecL_B eq 0. then avgchorusspecL_B = !values.f_nan
			if avgchorusspecU_B eq 0. then avgchorusspecU_B = !values.f_nan
			if avgnonchorusspec_B eq 0. then avgnonchorusspec_B = !values.f_nan
			if medianchorusspecL_B eq 0. then medianchorusspecL_B = !values.f_nan
			if medianchorusspecU_B eq 0. then medianchorusspecU_B = !values.f_nan
			if mediannonchorusspec_B eq 0. then mediannonchorusspec_B = !values.f_nan



			print,'Totals ',totalnonchorusspec_B,totalchorusspecL_B,totalchorusspecU_B
			print,'Max ',maxnonchorusspec_B,maxchorusspecL_B,maxchorusspecU_B
			print,'Avg ',avgnonchorusspec_B,avgchorusspecL_B,avgchorusspecU_B
			print,'Median ',mediannonchorusspec_B,medianchorusspecL_B,medianchorusspecU_B

		endif else begin

			totalchorusspecL_B = !values.f_nan
			totalchorusspecU_B = !values.f_nan
			totalnonchorusspec_B = !values.f_nan

			maxchorusspecL_B = !values.f_nan
			maxchorusspecU_B = !values.f_nan
			maxnonchorusspec_B = !values.f_nan

			avgchorusspecL_B = !values.f_nan
			avgchorusspecU_B = !values.f_nan
			avgnonchorusspec_B = !values.f_nan

			medianchorusspecL_B = !values.f_nan
			medianchorusspecU_B = !values.f_nan
			mediannonchorusspec_B = !values.f_nan

		endelse
;		if testing then begin
;		ylim,['tmpU','tmpL','tmpO'],1,6000,1
;		tplot,['rbsp'+probe+'_efw_spec64_scmw_comb','tmpU','tmpL','tmpO'] & tlimit,t0z,t1z
;		stop
;		endif







	;---------------------------------------------------------
	;Find the MLT, L, deltaMLT and deltaL of the closest pass
	;---------------------------------------------------------

		tinterpol_mxn,'rbsp'+probe+'_state_lshell','McIlwainL',newname='rbsp'+probe+'_state_lshell_interp'
		tinterpol_mxn,'rbsp'+probe+'_state_mlt','MLT',newname='rbsp'+probe+'_state_mlt_interp'
		dif_data,'rbsp'+probe+'_state_lshell_interp','McIlwainL',newname='ldiff'
		calculate_angle_difference,'rbsp'+probe+'_state_mlt_interp','MLT',newname='mltdiff'


		options,['ldiff','mltdiff'],'psym',-2
		ylim,'ldiff',-20,20
	;	tplot,['lcomb','ldiff','mltcomb','mltdiff']


		time_clip,'ldiff',t0z,t1z,newname='ldiff_tc'
		time_clip,'mltdiff',t0z,t1z,newname='mltdiff_tc'
		time_clip,'rbsp'+probe+'_state_lshell_interp',t0z,t1z,newname='rbsp'+probe+'_state_lshell_interp_tc'
		time_clip,'rbsp'+probe+'_state_mlt_interp',t0z,t1z,newname='rbsp'+probe+'_state_mlt_interp_tc'
		time_clip,'MLT',t0z,t1z,newname='fb_mlt_tc'
		time_clip,'McIlwainL',t0z,t1z,newname='fb_mcilwainL_tc'

		ylim,'fb_mcilwainL_tc',0,20
		ylim,'ldiff_tc',-20,20


		if testing then begin
		tplot,['ldiff','mltdiff','ldiff_tc','mltdiff_tc']
		stop
		endif

	;	;add zero line for difference plots
	;	get_data,'rbsp'+probe+'_state_lshell',tt,dd
	;	store_data,'zeroline',data={x:tt,y:replicate(0.,n_elements(tt))}
	;	options,'zeroline','linestyle',2
	;	store_data,'ldiff_tc_comb',data=['ldiff_tc','zeroline']
	;	store_data,'mltdiff_tc_comb',data=['mltdiff_tc','zeroline']
	;	options,['ldiff_tc','mltdiff_tc'],'psym',-2

		;Find absolute value of sc separation. We'll use the min value of this to define
		;dLmin and dMLTmin
		sc_absolute_separation,'rbsp'+probe+'_state_lshell_interp_tc','fb_mcilwainL_tc',$
			'rbsp'+probe+'_state_mlt_interp_tc','fb_mlt_tc';,/km

		if testing then begin
			tplot,['rbsp'+probe+'_state_lshell_interp_tc','fb_mcilwainL_tc','rbsp'+probe+'_state_mlt_interp_tc','fb_mlt_tc']
		endif

		ylim,'separation_absolute',-20,20
		options,['separation_absolute','ldiff_tc','mltdiff_tc','rbsp'+probe+'_state_lshell_interp_tc','rbsp'+probe+'_state_mlt_interp_tc','fb_mlt_tc','fb_mcilwainL_tc'],'psym',-2
;		tplot,['separation_absolute','ldiff_tc','mltdiff_tc','rbsp'+probe+'_state_lshell_interp_tc','rbsp'+probe+'_state_mlt_interp_tc','fb_mlt_tc','fb_mcilwainL_tc']

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


		;Check to see if any hires data loaded near the conjunction
		hires = 0
		hires = tdexists(strlowcase(fb)+'_fb_col_hires_flux',t0[j],t1[j])
		nsec_hires = !values.f_nan

		if hires then begin 
			tmpp = tsample(strlowcase(fb)+'_fb_col_hires_flux',[t0[j],t1[j]],times=tms)
			ttmp = tms - min(tms)
			nsec_hires = max(ttmp,/nan)
		endif

;		if testing then begin
;			tplot,['separation_absolute','ldiff_tc','rbsp'+probe+'_state_lshell_interp_tc','fb_mcilwainL_tc','mltdiff_tc','rbsp'+probe+'_state_mlt_interp_tc','fb_mlt_tc']
;			if whsep ne -1 then timebar,tt[boo[whsep]]
;			timebar,t0[j],color=250
;;			timebar,t1[j],color=250
	;	stop
	;	endif


		get_data,'rbsp'+probe+'_state_lshell',tforline,ddd
		store_data,'minsepline',data={x:tforline,y:replicate(min_sep,n_elements(tforline))}
		options,'minsepline','linestyle',2
		store_data,'minsep_tc_comb',data=['separation_absolute','minsepline']
		options,'separation_absolute','psym',-2
		ylim,'minsep_tc_comb',0.001,4,1



		;add zero line for difference plots
		get_data,'rbsp'+probe+'_state_lshell',ttt,ddd

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
			tplot,[strlowcase(fb)+'_fb_col_hires_flux','minsep_tc_comb','ldiff_tc_comb','mltdiff_tc_comb','lcomb','ldiff','mltcomb','mltdiff']
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
			l2_probe = tsample('rbsp'+probe+'_state_lshell_interp_tc',tt[boo[whsep]],times=t)
			lshell_min_rb = l2_probe
			mlt2_probe = tsample('rbsp'+probe+'_state_mlt_interp_tc',tt[boo[whsep]],times=t)
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
			l2_probe = tsample('rbsp'+probe+'_state_lshell',[t0[j],t1[j]],times=t)
			lshell_min_rb = mean(l2_probe,/nan)
			mlt2_probe = tsample('rbsp'+probe+'_state_mlt',[t0[j],t1[j]],times=t)
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


time_clip,'flux_context_'+fb,t0[j],t1[j],newname='fb_col_flux_tc'

		get_data,'fb_col_flux_tc',tt,dat
		max_flux_col = max(dat,/nan)

		if max_flux_col eq 0 then max_flux_col = !values.f_nan
		if max_HRflux_col eq 0 then max_HRflux_col = !values.f_nan




	;	rbsp_detrend,'fb_col_flux_tc',0.2
	;	tplot,[strlowcase(fb)+'_fb_col_hires_flux','fb_col_flux_tc','fb_col_flux_tc_detrend']
		
		;Figure out if we're dealing with e12 or e34 for FBK data 
    e1234 = ''
		tstvar = tnames('rbsp'+probe+'_efw_fbk7_e??dc_pk')
		if tstvar ne '' then e1234 = strmid(tstvar,15,3)		
		tstvar = tnames('rbsp'+probe+'_efw_fbk13_e??dc_pk')
		if tstvar ne '' then e1234 = strmid(tstvar,16,3)

		;---------------------------------------------------------------

		;Find max filterbank value in various bins for FBK7 mode

		get_data,'rbsp'+probe+'_efw_fbk7_'+e1234+'dc_pk',data=dat
		if is_struct(dat) then time_clip,'rbsp'+probe+'_efw_fbk7_'+e1234+'dc_pk',t0z,t1z,newname='rbsp'+probe+'_efw_fbk7_'+e1234+'dc_pk_tc'
		get_data,'rbsp'+probe+'_efw_fbk7_scmw_pk',data=dat
		if is_struct(dat) then time_clip,'rbsp'+probe+'_efw_fbk7_scmw_pk',t0z,t1z,newname='rbsp'+probe+'_efw_fbk7_scmw_pk_tc'
		;Find max filterbank value in various bins for FBK13 mode
		get_data,'rbsp'+probe+'_efw_fbk13_'+e1234+'dc_pk',data=dat
		if is_struct(dat) then time_clip,'rbsp'+probe+'_efw_fbk13_'+e1234+'dc_pk',t0z,t1z,newname='rbsp'+probe+'_efw_fbk13_'+e1234+'dc_pk_tc'
		get_data,'rbsp'+probe+'_efw_fbk13_scmw_pk',data=dat
		if is_struct(dat) then time_clip,'rbsp'+probe+'_efw_fbk13_scmw_pk',t0z,t1z,newname='rbsp'+probe+'_efw_fbk13_scmw_pk_tc'

		get_data,'rbsp'+probe+'_efw_fbk7_'+e1234+'dc_pk_tc',data=dat
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
		get_data,'rbsp'+probe+'_efw_fbk7_scmw_pk_tc',data=dat
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

;tplot,['rbsp'+probe+'_efw_fbk7_e??dc_pk_tc','rbsp'+probe+'_efw_fbk7_scmw_pk_tc']
;stop

		;Find max filterbank value in various bins for FBK13 mode
		get_data,'rbsp'+probe+'_efw_fbk13_'+e1234+'dc_pk_tc',data=dat
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
		get_data,'rbsp'+probe+'_efw_fbk13_scmw_pk_tc',data=dat
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
		options,['fb_conjunction_times','rbsp'+probe+'_efw_mscb1_available','rbsp'+probe+'_efw_mscb2_available',$
		'rbsp'+probe+'_emfisis_burst'],'panel_size',0.5

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
						printf,lun,'Conjunction data for RBSP'+probe+' and '+fb + ' from Shumko file ' + fb+'_'+rb+'_conjunctions_dL10_dMLT10_hr_final.txt'
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
		max_flux_col = string(max_flux_col,format='(F12.2)')
		max_HRflux_col = string(max_HRflux_col,format='(F12.2)')
		nsec_hires = string(nsec_hires,format='(f8.1)')
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
    totallowf_E = string(wave_valsE[1,0],format='(F27.11)')
    maxlowf_E = string(wave_valsE[1,1],format='(F20.11)')
    medianlowf_E = string(wave_valsE[1,2],format='(F20.11)')
    avglowf_E = string(wave_valsE[1,3],format='(F20.11)')

    totallowf_B = string(wave_valsB[1,0],format='(F27.11)')
    maxlowf_B = string(wave_valsB[1,1],format='(F20.11)')
    medianlowf_B = string(wave_valsB[1,2],format='(F20.11)')
    avglowf_B = string(wave_valsB[1,3],format='(F20.11)')

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
    totalhighf_E = string(wave_valsE[4,0],format='(F27.11)')
    maxhighf_E = string(wave_valsE[4,1],format='(F20.11)')
    medianhighf_E = string(wave_valsE[4,2],format='(F20.11)')
    avghighf_E = string(wave_valsE[4,3],format='(F20.11)')

    totalhighf_B = string(wave_valsB[4,0],format='(F27.11)')
    maxhighf_B = string(wave_valsB[4,1],format='(F20.11)')
    medianhighf_B = string(wave_valsB[4,2],format='(F20.11)')
    avghighf_B = string(wave_valsB[4,3],format='(F20.11)')



;		totalnonchorusspec_E = string(totalnonchorusspec_E,format='(F27.11)')
;		maxnonchorusspec_E = string(maxnonchorusspec_E,format='(F20.11)')
;		avgnonchorusspec_E = string(avgnonchorusspec_E,format='(F20.11)')
;		mediannonchorusspec_E = string(mediannonchorusspec_E,format='(F20.11)')
;
;		totalchorusspecL_E = string(totalchorusspecL_E,format='(F27.11)')
;		maxchorusspecL_E = string(maxchorusspecL_E,format='(F20.11)')
;		avgchorusspecL_E = string(avgchorusspecL_E,format='(F20.11)')
;		medianchorusspecL_E = string(medianchorusspecL_E,format='(F20.11)')
;
;		totalchorusspecU_E = string(totalchorusspecU_E,format='(F27.11)')
;		maxchorusspecU_E = string(maxchorusspecU_E,format='(F20.11)')
;		avgchorusspecU_E = string(avgchorusspecU_E,format='(F20.11)')
;		medianchorusspecU_E = string(medianchorusspecU_E,format='(F20.11)')
;
;		totalnonchorusspec_B = string(totalnonchorusspec_B,format='(F27.11)')
;		maxnonchorusspec_B = string(maxnonchorusspec_B,format='(F20.11)')
;		avgnonchorusspec_B = string(avgnonchorusspec_B,format='(F20.11)')
;		mediannonchorusspec_B = string(mediannonchorusspec_B,format='(F20.11)')
;
;		totalchorusspecL_B = string(totalchorusspecL_B,format='(F27.11)')
;		maxchorusspecL_B = string(maxchorusspecL_B,format='(F20.11)')
;		avgchorusspecL_B = string(avgchorusspecL_B,format='(F20.11)')
;		medianchorusspecL_B = string(medianchorusspecL_B,format='(F20.11)')
;
;		totalchorusspecU_B = string(totalchorusspecU_B,format='(F27.11)')
;		maxchorusspecU_B = string(maxchorusspecU_B,format='(F20.11)')
;		avgchorusspecU_B = string(avgchorusspecU_B,format='(F20.11)')
;		medianchorusspecU_B = string(medianchorusspecU_B,format='(F20.11)')



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
	;	printf,lun,tmidtmp+lshell_min+mlt_min+min_sep+min_dL+min_dMLT+max_flux_col+max_counts_sur+nsec_emf+nsec_b1+nsec_b2+fbk7_Ewmax_4+fbk7_Ewmax_5+fbk7_Ewmax_6+fbk7_Bwmax_4+fbk7_Bwmax_5+fbk7_Bwmax_6+fbk13_Ewmax_7+fbk13_Ewmax_8+fbk13_Ewmax_9+fbk13_Ewmax_10+fbk13_Ewmax_11+fbk13_Ewmax_12+fbk13_Bwmax_7+fbk13_Bwmax_8+fbk13_Bwmax_9+fbk13_Bwmax_10+fbk13_Bwmax_11+fbk13_Bwmax_12
		printf,lun,tstart+' '+tend+' '+tminsep+lshell_min_rb+lshell_min_fb+$
		mlt_min_rb+mlt_min_fb+min_sep+min_dL+min_dMLT+max_flux_col+max_HRflux_col+$
		nsec_hires+nsec_emf+nsec_b1+nsec_b2+$
		totalnonchorusspec_E+maxnonchorusspec_E+avgnonchorusspec_E+mediannonchorusspec_E+$
		totalchorusspecL_E+maxchorusspecL_E+avgchorusspecL_E+medianchorusspecL_E+$
		totalchorusspecU_E+maxchorusspecU_E+avgchorusspecU_E+medianchorusspecU_E+$
		totalnonchorusspec_B+maxnonchorusspec_B+avgnonchorusspec_B+mediannonchorusspec_B+$
		totalchorusspecL_B+maxchorusspecL_B+avgchorusspecL_B+medianchorusspecL_B+$
		totalchorusspecU_B+maxchorusspecU_B+avgchorusspecU_B+medianchorusspecU_B+$
		fbk7_Ewmax_3+fbk7_Ewmax_4+fbk7_Ewmax_5+fbk7_Ewmax_6+fbk7_Bwmax_3+fbk7_Bwmax_4+fbk7_Bwmax_5+fbk7_Bwmax_6+$
		fbk13_Ewmax_6+fbk13_Ewmax_7+fbk13_Ewmax_8+fbk13_Ewmax_9+fbk13_Ewmax_10+fbk13_Ewmax_11+fbk13_Ewmax_12+$
		fbk13_Bwmax_6+fbk13_Bwmax_7+fbk13_Bwmax_8+fbk13_Bwmax_9+fbk13_Bwmax_10+fbk13_Bwmax_11+fbk13_Bwmax_12
		close,lun
		free_lun,lun





			;tcenter = (t0z + t1z)/2.
			;ttmp = strmid(time_string(t0z),11,2)+strmid(time_string(t0z),14,2)+strmid(time_string(t0z),17,2)
			;daystr = strmid(currday,0,4)+strmid(currday,5,2)+strmid(currday,8,2)
			;	popen,'~/Desktop/'+'RBSP'+probe+'_'+fb+'_'+daystr+'_'+ttmp+'_conjunction.ps'
			;		!p.charsize = 0.8
			;		timespan,t0z,(t1z-t0z),/sec
			;		tplot_options,'title','find_rbsp_burst_availability_for_conjunctions.pro'
			;		tplot,['fb_conjunction_times',strlowcase(fb)+'_fb_col_hires_flux',strlowcase(fb)+'_fb_sur_hires_flux',$
			;		;'rbsp'+probe+'_state_lshell','rbsp'+probe+'_state_mlt',$
			;		'lcomb','mltcomb','minsep_tc_comb','ldiff_tc_comb','mltdiff_tc_comb',$
			;		'rbsp'+probe+'_efw_64_spec0_comb','rbsp'+probe+'_efw_64_spec4_comb',$
			;		'rbsp'+probe+'_efw_mscb1_available','rbsp'+probe+'_efw_mscb2_available',$
			;		'rbsp'+probe+'_emfisis_burst']
			;		timebar,min_sep_time
			;	pclose


;		endif   ;Resulting data not NaNs

	endif  ;for no missing data
endfor
end
