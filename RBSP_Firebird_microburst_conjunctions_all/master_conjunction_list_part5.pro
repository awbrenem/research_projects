;Part 5 in the process in determining list of FB/RBSP conjunctions.
;This computes statistics of chorus waves at set time intervals away from the closest conjunction. 
;This allows me to see the correlation b/t chorus and microbursts change as a function of separation. 

;2018 Feb 26th --test day for LH waves


;Things to add / Issues to address
;--E/B values 
;--Double counting issue can occur on days (e.g. 2016-01-21 when uB are observed on consecutive conjunctions that are only a couple of hours apart...i.e. 
;		closer than the entire timerange considered. )
;--Add a standard deviation measure to indicate how varied the amplitudes are? 



;PROBLEM DAYS
;j=28 --> no Lvals (Event does have microbursts)
;min_sep_time = NaN


;**conjunction times (t0, t1, tfb0, tfb1) - CORRECT
;2017-12-07/01:55:42
;2017-12-07/01:56:56

;**INCORRECT
;**rough conjunction times (t0z, t1z;  used to find tconj via min_sep_time)
;2017-12-06/22:59:59
;RBSP_EFW> time_string(t1z)
;2017-12-07/00:59:59


;tfb1 values are wrong!!!!!
;--> they are initially correct around L112



;t0 and t1 have different values than the time clipped data

;2016-01-20  (FCE VALUES MESSED UP)
;2016-08-14/01:27:13 (code crashing - LVALS array is NaN)






;Grab local path to save data
homedir = (file_search('~',/expand_tilde))[0]+'/'


pathoutput = homedir + 'Desktop/'


;------------------------
;input vars
hires = 1   ;conjunctions w/ hires only?
probe = 'b'
fb = 'FU4'
dettime = 0.75 ;(sec)  Time for detrending the hires data in order to obtain microburst amplitudes. 
				;See firebird_subtract_tumble_from_hiresdata_testing.pro
minlowf = 60. ;(Hz) Lowest freq to be considered for nonchorus. Having too low (e.g. 20 Hz) exposes the analysis to the 
				;abnormally large power at the lowest spectral bins

tdelta = double(60.*20.)  ;(sec) Every time chunk of size tdelta will be separately analyzed for chorus properties, as well as 
						 ;separation b/t RBSP and FB relative to the location of closest approach. 
time_extent = 5.*3600. ;(sec) Total Max +/- time to consider from conjunction closest approach. (e.g. +/- 3 hrs on either side. This total time 
						;will be divided into chunks of size "tdelta")


;Conjunction data for all the FIREBIRD passes with HiRes data
path = homedir + 'Desktop/code/Aaron/github.umn.edu/research_projects/RBSP_Firebird_microburst_conjunctions_all/'


remove_lbchorus_when_concurrent_lowf = 0.
;------------------------


nchunks = 2*time_extent/tdelta + 1.


if hires then suffix = '_conjunctions_hr.sav' else suffix = '_conjunctions.sav'

;--------------


fn = fb+'_'+'RBSP'+strupcase(probe)+suffix
restore,path+'RBSP_FB_final_conjunction_lists/'+fn
tfb0 = t0
tfb1 = t1




;**************************
;**************************
;Option: identify only conjunctions that contain microbursts



mb_list = load_firebird_microburst_list(strmid(fb,2,1))

mbtimes = mb_list.time


;****************************
;TEMPORARY - ONLY ANALYZE CONJUNCTIONS THAT HAVE IDENTIFIED MICROBURSTS


tfb0fin = tfb0 


;Make sure there is microburst at/near conjunction
for i=0,n_elements(tfb0)-1 do begin $  
	deltattmp = abs(time_double(tfb0[i]) - time_double(mbtimes)) & $
	if min(deltattmp) gt 5*60. then tfb0fin[i] = !values.f_nan
endfor

goo = where(finite(tfb0fin))

tfb0 = tfb0[goo] 
tfb1 = tfb1[goo]
t0 = t0[goo] 
t1 = t1[goo]
vals = vals[goo,*]
meanL = meanL[goo]
meanMLT = meanMLT[goo] 
mindist = mindist[goo]
strv = strv[goo]

;stop
;**************************
;**************************




;Print list of times (since these are based on FB ephemeris data, they don't need a time correction)
for bb=0,n_elements(tfb0)-1 do print,bb,' ',time_string(tfb0[bb])
;for bb=1900,2200 do print,bb,' ',time_string(tfb0[bb]),'  ',time_string(tfb1[bb])


daytst = '0000-00-00'   ;used as a test to see if we need to load another day's data


;------------------------------------------------------------------------------------------------------------------------
;Master loop for every conjunction
;------------------------------------------------------------------------------------------------------------------------

for j=0.,n_elements(tfb0)-1 do begin



	;Make sure all the variables created by time_clip are deleted b/c if time_clip finds no data in requested timerange
	;then it won't overwrite previous values. 
	store_data,'*_tc',/del


	;Manually select the conjunction to start on.
	if j eq 0 then stop
	j = float(j)



	;Rough start and stop times for loading data
	tstart = time_string(tfb0[j] - time_extent)
	tend = time_string(tfb0[j] + time_extent)


	;Grab FIREBIRD calibration data
	cal = firebird_get_calibration_counts2flux(strmid(tstart,0,10),strmid(fb,2,1))


	;Figure out if we have to load more than one day of data.
	datestart = strmid(tstart,0,10)
	dateend = strmid(tend,0,10)
	if datestart eq dateend then ndays_load = 1 else ndays_load = 2
	currday = datestart
	timespan,datestart,ndays_load,/days


	;Find out if the new day to load should be previous or next day 
	nextday = dateend

	if datestart ne dateend then trange = [datestart,dateend]
	if datestart eq dateend then trange = [datestart,strmid(time_string(time_double(dateend)+86400),0,10)]


	load_new_data = daytst ne currday


	;Load new data if required
	if load_new_data or ndays_load gt 1 then begin
		if ndays_load eq 1 then daytst = currday
		if ndays_load gt 1 then daytst = nextday


		;Need to do this each time or else the amplitudes can get filled in incorrectly.
		;***DON'T REMOVE!!!!
		store_data,'*',/delete

		;Load FIREBIRD hires data per day (if there is any)
		timespan,trange[0]

		store_data,strlowcase(fb)+'_fb_col_hires_flux',/del

		;Load hires data, if there is any
		firebird_load_data,strmid(fb,2,1),fileexists=fb_hiresexists

		;load context data
		firebird_load_context_data_cdf_file,strmid(fb,2,1)


		if ndays_load eq 2 then begin
			copy_data,'flux_context_'+fb,'flux_context_'+fb + '1'
			copy_data,'MLT','MLT1'
			copy_data,'McIlwainL','McIlwainL1'

			timespan,trange[1]
			firebird_load_context_data_cdf_file,strmid(fb,2,1)

			;Combine both days
			get_data,'flux_context_'+fb,vx,d & get_data,'flux_context_'+fb + '1',v1x,d1
			store_data,'flux_context_'+fb,[v1x,vx],[d1,d]
			get_data,'MLT',vx,d & get_data,'MLT1',v1x,d1
			store_data,'MLT',[v1x,vx],[d1,d]
			get_data,'McIlwainL',vx,d & get_data,'McIlwainL1',v1x,d1
			store_data,'McIlwainL',[v1x,vx],[d1,d]
			store_data,['flux_context_'+fb + '1','MLT1','McIlwainL1'],/del
		endif




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

			rbsp_load_emfisis_l2,probe=probe,datatype='WFR-spectral-matrix'

			get_data,'BwBw',data=d
			store_data,'BwBw',data={x:d.x,y:d.y,v:reform(d.v)}
			zlim,'BwBw',1d-11,1d-4,1
			ylim,'BwBw',minlowf,12000,1

			get_data,'EuEu',data=d
			store_data,'EuEu',data={x:d.x,y:d.y*1000.*1000.,v:reform(d.v)}
			options,'EuEu','ytitle','EuEu!C[mV2/m2/Hz]'
			zlim,'EuEu',1d-10,1d-1,1
			ylim,'EuEu',minlowf,12000,1


			if ndays_load eq 2 then begin

				copy_data,'rbsp'+probe+'_emfisis_l3_4sec_gsm_Mag','rbsp'+probe+'_emfisis_l3_4sec_gsm_Mag1'
				copy_data,'rbsp'+probe+'_emfisis_l3_4sec_gsm_Magnitude','rbsp'+probe+'_emfisis_l3_4sec_gsm_Magnitude1'
				copy_data,'EuEu','EuEu1'
				copy_data,'BwBw','BwBw1'

				timespan,trange[1]
				rbsp_load_emfisis,probe=probe,level='l3',coord='gsm'
				rbsp_load_emfisis_l2,probe=probe,datatype='WFR-spectral-matrix'

				get_data,'BwBw',data=d
				store_data,'BwBw',data={x:d.x,y:d.y,v:reform(d.v)}
				zlim,'BwBw',1d-11,1d-4,1
				ylim,'BwBw',minlowf,12000,1

				get_data,'EuEu',data=d
				store_data,'EuEu',data={x:d.x,y:d.y*1000.*1000.,v:reform(d.v)}
				options,'EuEu','ytitle','EuEu!C[mV2/m2/Hz]'
				zlim,'EuEu',1d-7,1d-1,1
				ylim,'EuEu',minlowf,12000,1


				;Combine both days
				get_data,'rbsp'+probe+'_emfisis_l3_4sec_gsm_Mag',magx,d
				get_data,'rbsp'+probe+'_emfisis_l3_4sec_gsm_Mag1',mag1x,d1
				store_data,'rbsp'+probe+'_emfisis_l3_4sec_gsm_Mag',[mag1x,magx],[d1,d]

				get_data,'rbsp'+probe+'_emfisis_l3_4sec_gsm_Magnitude',magx,d
				get_data,'rbsp'+probe+'_emfisis_l3_4sec_gsm_Magnitude1',mag1x,d1
				store_data,'rbsp'+probe+'_emfisis_l3_4sec_gsm_Magnitude',[mag1x,magx],[d1,d]
				store_data,'rbsp'+probe+'_emfisis_l3_4sec_gsm_Magnitude1',/del
				store_data,'rbsp'+probe+'_emfisis_l3_4sec_gsm_Mag1',/del

				get_data,'EuEu',data=d 
				get_data,'EuEu1',data=d1
				store_data,'EuEu',data={x:[d1.x,d.x],y:[d1.y,d.y],v:d.v}
				store_data,'EuEu1',/del
				get_data,'BwBw',data=d 
				get_data,'BwBw1',data=d1
				store_data,'BwBw',data={x:[d1.x,d.x],y:[d1.y,d.y],v:d.v}
				store_data,'BwBw1',/del


			endif
		endif  ;if not missingdata
	endif  ;load new data






;---------------------------------------------------------
;Calculate E/B ratio
;---------------------------------------------------------

	;Calculate E/B ratio (E=VxB, where E(mV/m) = V(km/s) x B(nT)/1000)
	; V = 1000* (E/B)    km/s
	; n = B*c/E = c/vp
	
	
	
	get_data,'EuEu',data=Evals,dlimits=dlim,limits=lim
	get_data,'BwBw',data=Bvals
	

	E2B = 1000.*Evals.y/Bvals.y    ;Velocity=1000*E/B (km/s)
	boo = where(finite(E2B) eq 0)
	if boo[0] ne -1 then E2B[boo] = 0.
	
	store_data,'E2B',data={x:Evals.x,y:E2B,v:Evals.v},dlimits=dlim,limits=lim
	store_data,'E2B_C',data=['E2B','fce_eq','fce_eq_2','fce_eq_10','flh_eq']
	
	ylim,'E2B_C',3,10000,1
	zlim,'E2B_C',1d3,1d8,1
	options,'E2B_C','ztitle','km/s'
	options,'E2B_C','ytitle','1000*Eu/Bw!C[Hz]'
	options,'E2B_C','ysubtitle',''
	









	;-------------------------------
	;If we have all the data we need then continue 
	;-------------------------------

	if missingdata ne 1 then begin

		;create artifical times array with 1-sec cadence for timerange requested.
		ntimes = time_double(trange[1]) - time_double(trange[0])
		ndays = ntimes/86400.
		times_artificial = time_double(trange[0]) + dindgen(ndays*ntimes)
		vals = fltarr(n_elements(times_artificial))

;****NDAYS MAY BE INCORRECT 
STOP


		goo = where((times_artificial ge tfb0[j]) and (times_artificial le tfb1[j]))
		if goo[0] ne -1 then vals[goo] = 1.
		store_data,'fb_conjunction_times',times_artificial,vals
		ylim,'fb_conjunction_times',0,2
		options,'fb_conjunction_times','psym',0
		options,'fb_conjunction_times','ytitle','FB!Cconj'


		;--------------------------
		get_data,'rbsp'+probe+'_emfisis_l3_4sec_gsm_Magnitude',ttt,magnit
		fce = 28.*magnit

		tinterpol_mxn,'rbsp'+probe+'_state_mlat',ttt
		get_data,'rbsp'+probe+'_state_mlat_interp',data=mlat
		fce_eq = fce*cos(2*mlat.y*!dtor)^3/sqrt(1+3*sin(mlat.y*!dtor)^2)

		store_data,'fce_eq',ttt,fce_eq & store_data,'fce_eq_2',ttt,fce_eq/2. & store_data,'fce_eq_10',ttt,fce_eq/10.
		store_data,'fci_eq',ttt,fce_eq/1836. & store_data,'flh_eq',ttt,sqrt(fce_eq*fce_eq/1836.)
		options,'flh_eq','color',1
		options,'fce_eq','color',2

		store_data,'rbsp'+probe+'_efw_spec64_e12ac_comb',data=['rbsp'+probe+'_efw_spec64_e12ac','fce_eq','fce_eq_2','fce_eq_10','flh_eq']
		store_data,'rbsp'+probe+'_efw_spec64_scmw_comb', data=['rbsp'+probe+'_efw_spec64_scmw','fce_eq','fce_eq_2','fce_eq_10','flh_eq']
		ylim,'rbsp'+probe+'_efw_spec64_e12ac_comb',minlowf,6000,1
		ylim,'rbsp'+probe+'_efw_spec64_scmw_comb',minlowf,6000,1

		store_data,'EuEu_comb',data=['EuEu','fce_eq','fce_eq_2','fce_eq_10','flh_eq']
		store_data,'BwBw_comb',data=['BwBw','fce_eq','fce_eq_2','fce_eq_10','flh_eq']
		ylim,'EuEu_comb',minlowf,12000,1
		ylim,'BwBw_comb',minlowf,12000,1

		;--------------------------



		options,['MLT','McIlwainL',strlowcase(rb)+'_state_lshell_interp','MLT',strlowcase(rb)+'_state_mlt_interp'],'psym',-2


		;Set tlimits for conjunction (used only for determining closest approach)
		get_data,'fb_conjunction_times',ttmp,dtmp
		goo = where(dtmp eq 1)
		tmid = (ttmp[goo[0]] + ttmp[goo[n_elements(goo)-1]])/2.
		t0z = tmid - 3600.  
		t1z = tmid + 3600.




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




		;Find absolute value of sc separation. We'll use the min value of this to define
		;dLmin and dMLTmin
		sc_absolute_separation,'rbsp'+probe+'_state_lshell_interp_tc','fb_mcilwainL_tc','rbsp'+probe+'_state_mlt_interp_tc','fb_mlt_tc'


		ylim,'separation_absolute',-20,20
		options,['separation_absolute','ldiff_tc','mltdiff_tc','rbsp'+probe+'_state_lshell_interp_tc','rbsp'+probe+'_state_mlt_interp_tc','fb_mlt_tc','fb_mcilwainL_tc'],'psym',-2
		timespan,datestart,ndays_load,/days
		tplot,['separation_absolute','ldiff_tc','mltdiff_tc','rbsp'+probe+'_state_lshell_interp_tc','rbsp'+probe+'_state_mlt_interp_tc','fb_mlt_tc','fb_mcilwainL_tc']


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


;		get_data,'rbsp'+probe+'_state_lshell',tforline,ddd
;		store_data,'minsepline',data={x:tforline,y:replicate(min_sep,n_elements(tforline))}
;		options,'minsepline','linestyle',2
;		store_data,'minsep_tc_comb',data=['separation_absolute','minsepline']
;		options,'separation_absolute','psym',-2
;		ylim,'minsep_tc_comb',0.001,4,1


;		;add zero line for difference plots
;		get_data,'rbsp'+probe+'_state_lshell',ttt,ddd
;
;		store_data,'mindmltline',data={x:ttt,y:replicate(min_dmlt,n_elements(ttt))}
;		store_data,'mltdiff_tc_comb',data=['mltdiff_tc','mindmltline']
;		store_data,'mindLline',data={x:ttt,y:replicate(min_dl,n_elements(ttt))}
;		store_data,'ldiff_tc_comb',data=['ldiff_tc','mindLline']
;
;		options,'mindmltline','linestyle',2
;		options,'mindLline','linestyle',2
;		options,['ldiff_tc','mltdiff_tc'],'psym',-2
;
;		ylim,'ldiff_tc_comb',-20,20




		tconj = min_sep_time
		t0z2 = tconj - time_extent
		t1z2 = tconj + time_extent


		tmpp = time_string(tconj)
		filenamestr = strmid(tmpp,0,4)+strmid(tmpp,5,2)+strmid(tmpp,8,2)+'_'+strmid(tmpp,11,2)+strmid(tmpp,14,2)+strmid(tmpp,17,2)


		;-----------------------------------------------------
		;Create final data arrays
		;-----------------------------------------------------

		d = fltarr(nchunks-1)
		totalchorusspecL_E = d & totalchorusspecU_E = d & totalnonchorusspec_E = d
		maxchorusspecL_E = d & maxchorusspecU_E = d & maxnonchorusspec_E = d
		avgchorusspecL_E = d & avgchorusspecU_E = d & avgnonchorusspec_E = d
		medianchorusspecL_E = d & medianchorusspecU_E = d & mediannonchorusspec_E = d

		totalchorusspecL_B = d & totalchorusspecU_B = d & totalnonchorusspec_B = d
		maxchorusspecL_B = d & maxchorusspecU_B = d & maxnonchorusspec_B = d
		avgchorusspecL_B = d & avgchorusspecU_B = d & avgnonchorusspec_B = d
		medianchorusspecL_B = d & medianchorusspecU_B = d & mediannonchorusspec_B = d

		fbk7_Ewmax_3 = d & fbk7_Ewmax_4 = d & fbk7_Ewmax_5 = d & fbk7_Ewmax_6 = d
		fbk7_Bwmax_3 = d & fbk7_Bwmax_4 = d & fbk7_Bwmax_5 = d & fbk7_Bwmax_6 = d
		fbk13_Ewmax_6 = d & fbk13_Ewmax_7 = d & fbk13_Ewmax_8 = d & fbk13_Ewmax_9 = d & fbk13_Ewmax_10 = d & fbk13_Ewmax_11 = d & fbk13_Ewmax_12 = d
		fbk13_Bwmax_6 = d & fbk13_Bwmax_7 = d & fbk13_Bwmax_8 = d & fbk13_Bwmax_9 = d & fbk13_Bwmax_10 = d & fbk13_Bwmax_11 = d & fbk13_Bwmax_12 = d

		sepmin = d & sepmax = d
		lmin = d & lmax = d & lmed = d & lavg = d
		mltmin = d & mltmax = d & mltmed = d & mltavg = d
		dlmin = d & dlmax = d & dlmed = d & dlavg = d
		dmltmin = d & dmltmax = d & dmltmed = d & dmltavg = d

		freqpeakL_E = d & freqpeakU_E = d & freqpeakO_E = d
		freqpeakL_B = d & freqpeakU_B = d & freqpeakO_B = d
		fcemin = d & fcemax = d

		tmin = d & tmax = d



		;-----------------------------------------------------------
		;Find L/MLT values in various time chunks surrounding the conjunction
		;-----------------------------------------------------------

		for ii=0,nchunks-2 do begin 

			tmin[ii] = t0z2 + ii*tdelta
			tmax[ii] = t0z2 + (ii+1)*tdelta

			lvals = tsample('rbsp'+probe+'_state_lshell',[tmin[ii],tmax[ii]],time=tms)
			mltvals = tsample('rbsp'+probe+'_state_mlt',[tmin[ii],tmax[ii]],time=tms)


			;We'll reference dL, dMLT, and separation_absolute from the FIREBIRD values at closest approach
			Lref = tsample('McIlwainL',tconj)
			MLTref = tsample('MLT',tconj)
			dlvals = lvals - Lref
			dmltvals = mltvals - MLTref

			store_data,'tmp_fbL',tms,replicate(Lref,n_elements(tms))
			store_data,'tmp_fbMLT',tms,replicate(MLTref,n_elements(tms))
			store_data,'tmp_rbL',tms,lvals
			store_data,'tmp_rbMLT',tms,mltvals

			sc_absolute_separation,'tmp_rbL','tmp_fbL',$
				'tmp_rbMLT','tmp_fbMLT';,/km

			sepvals = tsample('separation_absolute',[tmin[ii],tmax[ii]],time=tms)

			lmin[ii] = min(lvals,/nan) & lmax[ii] = max(lvals,/nan)
			lmed[ii] = median(lvals) & lavg[ii] = mean(lvals,/nan)
			mltmin[ii] = min(mltvals,/nan) & mltmax[ii] = max(mltvals,/nan)
			mltmed[ii] = median(mltvals) & mltavg[ii] = mean(mltvals,/nan)

			dlmin[ii] = min(dlvals,/nan) & dlmax[ii] = max(dlvals,/nan)
			dlmed[ii] = median(dlvals) & dlavg[ii] = mean(dlvals,/nan)
			dmltmin[ii] = min(dmltvals,/nan) & dmltmax[ii] = max(dmltvals,/nan)
			dmltmed[ii] = median(dmltvals) & dmltavg[ii] = mean(dmltvals,/nan)

			sepmin[ii] = min(sepvals,/nan) & sepmax[ii] = max(sepvals,/nan)


			store_data,['tmp_fbL','tmp_fbMLT','tmp_rbL','tmp_rbMLT'],/del
		endfor

		Lrefarr = replicate(Lref,n_elements(tmin))
		MLTrefarr = replicate(MLTref,n_elements(tmin))

		lsep = (lmin + lmax)/2.
		mltsep = (mltmin + mltmax)/2.
		sepavg = (sepmin + sepmax)/2.
		dl = (dlmin + dlmax)/2.
		dmlt = (dmltmin + dmltmax)/2. 

		store_data,'lboth',(tmin+tmax)/2.,[[lsep],[Lrefarr]] & options,'lboth','ytitle','L!CRb=black!CFB=red'
		store_data,'mltboth',(tmin+tmax)/2.,[[mltsep],[MLTrefarr]] & options,'mltboth','ytitle','MLT!CRb=black!CFB=red'
		store_data,'sep',(tmin+tmax)/2.,sepavg & options,'sep','ytitle','Separation!CRE'
		store_data,'dl',(tmin+tmax)/2.,dl & options,'dl','ytitle','DeltaL!CRB-FB'
		store_data,'dmlt',(tmin+tmax)/2.,dmlt & options,'dmlt','ytitle','DeltaMLT!CRB-FB'

		options,['lboth','mltboth','sep','dl','dmlt'],'panel_size',0.3


		ylim,'lboth',min([lsep,Lrefarr]),min([lsep,Lrefarr]),0
		ylim,'mltboth',min([mltmin,mltmax,MLTrefarr]),min([mltmin,mltmax,MLTrefarr]),0
		ylim,'sep',min([sepmin,sepmax]),min([sepmin,sepmax]),0
		ylim,'dl',min([dlmin,dlmax]),min([dlmin,dlmax]),0
		ylim,'dmlt',min([dmltmin,dmltmax]),min([dmltmin,dmltmax]),0


		;-----------------------------------------------------------
		;Find wave statistics in various time chunks surrounding the conjunction
		;-----------------------------------------------------------


		;First the Electric field
		get_data,'EuEu',data=dd,dlim=dlim,lim=lim
		spectmp = tsample('EuEu',[t0z2,t1z2],times=tt)
		tinterpol_mxn,'fce_eq','EuEu'
		fcetmp = tsample('fce_eq_interp',[t0z2,t1z2],times=tt)

;		get_data,'rbsp'+probe+'_efw_spec64_e12ac',data=dd,dlim=dlim,lim=lim
;		spectmp = tsample('rbsp'+probe+'_efw_spec64_e12ac',[t0z2,t1z2],times=tt)
;		tinterpol_mxn,'fce_eq','rbsp'+probe+'_efw_spec64_e12ac'
;		fcetmp = tsample('fce_eq_interp',[t0z2,t1z2],times=tt)


		;limit spectral data to chorus only (upper and lower band separately), and to
		;values lower than the chorus range ("other")
		spectmpL = spectmp & spectmpU = spectmp & spectmpO = spectmp
		;Remove zero values that screw up average and median calculation
		goo = where(spectmp eq 0.)
		if goo[0] ne -1 then spectmpL[goo] = !values.f_nan
		if goo[0] ne -1 then spectmpU[goo] = !values.f_nan
		if goo[0] ne -1 then spectmpO[goo] = !values.f_nan

		;Remove bad values
		if finite(fcetmp[0]) and is_struct(dd) then begin
			for qq=0,n_elements(fcetmp)-1 do begin
					gooL = where((dd.v le fcetmp[qq]/10.) or (dd.v ge fcetmp[qq]/2.))
					gooU = where((dd.v lt fcetmp[qq]/2.)  or (dd.v gt fcetmp[qq]))
					gooO = where((dd.v gt fcetmp[qq]/10.) or (dd.v lt minlowf))
					if gooL[0] ne -1 then spectmpL[qq,gooL] = !values.f_nan
					if gooU[0] ne -1 then spectmpU[qq,gooU] = !values.f_nan
					if gooO[0] ne -1 then spectmpO[qq,gooO] = !values.f_nan
			endfor
		endif

		;A common problem is that low freq broadband spikes/noise leaks into the chorus lower band. 
		;Here, remove chorus lower band power if the broadband power at >100 Hz at that exact time is greater 
		if remove_lbchorus_when_concurrent_lowf then begin
			goodv = where(dd.v gt 100.)
			for bb=0,n_elements(spectmpL[*,0])-1 do if max(spectmpO[bb,goodv],/nan) gt max(spectmpL[bb,*],/nan) then spectmpL[bb,*] = !values.f_nan
		endif

		store_data,'tmpL',tt,spectmpL,dd.v,dlim=dlim,lim=lim
		store_data,'tmpU',tt,spectmpU,dd.v,dlim=dlim,lim=lim
		store_data,'tmpO',tt,spectmpO,dd.v,dlim=dlim,lim=lim


		for ii=0,nchunks-2 do begin 

			tmin[ii] = t0z2 + ii*tdelta
			tmax[ii] = t0z2 + (ii+1)*tdelta

		

			fcetmp = tsample('fce_eq_interp',[tmin[ii],tmax[ii]],times=tt)
			spectmpL = tsample('tmpL',[tmin[ii],tmax[ii]],times=tt2)
			spectmpU = tsample('tmpU',[tmin[ii],tmax[ii]])
			spectmpO = tsample('tmpO',[tmin[ii],tmax[ii]])

			fcemin[ii] = min(fcetmp,/nan) & fcemax[ii] = max(fcetmp,/nan)

			if finite(fcetmp[0]) then begin

				totalchorusspecL_E[ii] = total(spectmpL,/nan) & if totalchorusspecL_E[ii] eq 0. then totalchorusspecL_E[ii] = !values.f_nan
				totalchorusspecU_E[ii] = total(spectmpU,/nan) & if totalchorusspecU_E[ii] eq 0. then totalchorusspecU_E[ii] = !values.f_nan
				totalnonchorusspec_E[ii] = total(spectmpO,/nan) & if totalnonchorusspec_E[ii] eq 0. then totalnonchorusspec_E[ii] = !values.f_nan

				maxchorusspecL_E[ii] = max(spectmpL,/nan,wh) & if maxchorusspecL_E[ii] eq 0. then maxchorusspecL_E[ii] = !values.f_nan
				if finite(maxchorusspecL_E[ii]) then begin
					dims=size(spectmpL,/dim)
					xind=wh mod dims[0]
					yind=wh / dims[0]
					freqpeakL_E[ii] = dd.v[yind]
				endif else freqpeakL_E[ii] = !values.f_nan

				maxchorusspecU_E[ii] = max(spectmpU,/nan,wh) & if maxchorusspecU_E[ii] eq 0. then maxchorusspecU_E[ii] = !values.f_nan
				if finite(maxchorusspecU_E[ii]) then begin
					dims=size(spectmpU,/dim)
					xind=wh mod dims[0]
					yind=wh / dims[0]
					freqpeakU_E[ii] = dd.v[yind]
				endif else freqpeakU_E[ii] = !values.f_nan

				maxnonchorusspec_E[ii] = max(spectmpO,/nan,wh) & if maxnonchorusspec_E[ii] eq 0. then maxnonchorusspec_E[ii] = !values.f_nan
				if finite(maxnonchorusspec_E[ii]) then begin
					dims=size(spectmpO,/dim)
					xind=wh mod dims[0]
					yind=wh / dims[0]
					freqpeakO_E[ii] = dd.v[yind]
				endif else freqpeakO_E[ii] = !values.f_nan




				;NEED TO TAKE MEDIAN AND AVERAGE OF ALL THE "MAX" VALUES WITHIN CURRENT TIME BLOCK
				;CURRENTLY I'M TAKING THE MED/AVG OVER EVERYTHING IN THAT BLOCK...AND THAT INCLUDES ALL THE FREQS WHERE THE WAVE 
				;POWER HAS FALLEN OFF FROM THE PEAK. 
				maxtmpL = fltarr(n_elements(spectmpL[*,0]))
				for q=0,n_elements(spectmpL[*,0])-1 do maxtmpL[q] = max(spectmpL[q,*],/nan)
				maxtmpU = fltarr(n_elements(spectmpU[*,0]))
				for q=0,n_elements(spectmpU[*,0])-1 do maxtmpU[q] = max(spectmpU[q,*],/nan)
				maxtmpO = fltarr(n_elements(spectmpO[*,0]))
				for q=0,n_elements(spectmpO[*,0])-1 do maxtmpO[q] = max(spectmpO[q,*],/nan)

				avgchorusspecL_E[ii] = mean(maxtmpL,/nan) & if avgchorusspecL_E[ii] eq 0. then avgchorusspecL_E[ii] = !values.f_nan
				avgchorusspecU_E[ii] = mean(maxtmpU,/nan) & if avgchorusspecU_E[ii] eq 0. then avgchorusspecU_E[ii] = !values.f_nan
				avgnonchorusspec_E[ii] = mean(maxtmpO,/nan) & if avgnonchorusspec_E[ii] eq 0. then avgnonchorusspec_E[ii] = !values.f_nan

				medianchorusspecL_E[ii] = median(maxtmpL) & if medianchorusspecL_E[ii] eq 0. then medianchorusspecL_E[ii] = !values.f_nan
				medianchorusspecU_E[ii] = median(maxtmpU) & if medianchorusspecU_E[ii] eq 0. then medianchorusspecU_E[ii] = !values.f_nan
				mediannonchorusspec_E[ii] = median(maxtmpO) & if mediannonchorusspec_E[ii] eq 0. then mediannonchorusspec_E[ii] = !values.f_nan

			endif else begin
				totalchorusspecL_E[ii] = !values.f_nan & totalchorusspecU_E[ii] = !values.f_nan & totalnonchorusspec_E[ii] = !values.f_nan
				maxchorusspecL_E[ii] = !values.f_nan & maxchorusspecU_E[ii] = !values.f_nan & maxnonchorusspec_E[ii] = !values.f_nan
				avgchorusspecL_E[ii] = !values.f_nan & avgchorusspecU_E[ii] = !values.f_nan & avgnonchorusspec_E[ii] = !values.f_nan
				medianchorusspecL_E[ii] = !values.f_nan & medianchorusspecU_E[ii] = !values.f_nan & mediannonchorusspec_E[ii] = !values.f_nan
			endelse
		endfor


	;**************************
	;Testing: compare max determined values with spectral plot.
		timespan,tmin[0],tmax[n_elements(tmax)-1]-tmin[0],/sec

		get_data,'tmpL',data=dd
		maxspec = fltarr(n_elements(dd.x))
		for i=0,n_elements(dd.x)-1 do maxspec[i] = max(dd.y[i,*],/nan)
		store_data,'maxspecL',dd.x,maxspec & options,'maxspecL','psym',3
		ylim,'maxspecL',min(maxspec,/nan),2*max(maxspec,/nan),1
		store_data,'tstlb_tot',(tmin+tmax)/2.,totalchorusspecL_E
		store_data,'tstlb_max',(tmin+tmax)/2.,maxchorusspecL_E & options,'tstlb_max','colors',1
		store_data,'tstlb_med',(tmin+tmax)/2.,medianchorusspecL_E & options,'tstlb_med','colors',100
		store_data,'tstlb_avg',(tmin+tmax)/2.,avgchorusspecL_E & options,'tstlb_avg','colors',250
		store_data,'fpeaklb',(tmin+tmax)/2.,freqpeakL_E & options,'fpeaklb','psym',-4
		options,'fpeaklb','colors',250
		options,['tstlb_tot','tstlb_max','tstlb_med','tstlb_avg','fpeaklb'],'psym',-4
		options,['tstlb_tot','tstlb_max','tstlb_med','tstlb_avg','fpeaklb'],'thick',2
		store_data,'specLcomb',data=['tmpL','fce_eq','fce_eq_2','fce_eq_10','flh_eq','fpeaklb'] & ylim,'specLcomb',minlowf,6000,1
		options,'specLcomb','ytitle','Ew spec!Clowerband'
		store_data,'loccombL',data=['maxspecL','tstlb_max','tstlb_med','tstlb_avg']
		options,'loccombL','ytitle','max power!Clowerband'
		ylim,'loccombL',min(maxspec,/nan),2*max(maxspec,/nan),1
;		ylim,'loccombL',0,max(maxspec,/nan),0
;		tplot,['rbsp'+probe+'_efw_spec64_e12ac_comb','specLcomb','loccombL']
	
;	stop	

		get_data,'tmpU',data=dd
		maxspec = fltarr(n_elements(dd.x))
		for i=0,n_elements(dd.x)-1 do maxspec[i] = max(dd.y[i,*],/nan)
		store_data,'maxspecU',dd.x,maxspec & options,'maxspecU','psym',3
		ylim,'maxspecU',min(maxspec,/nan),2*max(maxspec,/nan),1
		store_data,'tstub_tot',(tmin+tmax)/2.,totalchorusspecU_E
		store_data,'tstub_max',(tmin+tmax)/2.,maxchorusspecU_E & options,'tstub_max','colors',1
		store_data,'tstub_med',(tmin+tmax)/2.,medianchorusspecU_E & options,'tstub_med','colors',100
		store_data,'tstub_avg',(tmin+tmax)/2.,avgchorusspecU_E & options,'tstub_avg','colors',250
		store_data,'fpeakub',(tmin+tmax)/2.,freqpeakU_E & options,'fpeakub','psym',-4
		options,'fpeakub','colors',250
		options,['tstub_tot','tstub_max','tstub_med','tstub_avg','fpeakub'],'psym',-4
		options,['tstub_tot','tstub_max','tstub_med','tstub_avg','fpeakub'],'thick',2
		store_data,'specUcomb',data=['tmpU','fce_eq','fce_eq_2','fce_eq_10','flh_eq','fpeakub'] & ylim,'specUcomb',minlowf,6000,1
		options,'specUcomb','ytitle','Ew spec!Cupperband'
		store_data,'loccombU',data=['maxspecU','tstub_max','tstub_med','tstub_avg']
		options,'loccombU','ytitle','max power!Cupperband'
		ylim,'loccombU',min(maxspec,/nan),2*max(maxspec,/nan),1
;		ylim,'loccombU',0,max(maxspec,/nan),0
;		tplot,['rbsp'+probe+'_efw_spec64_e12ac_comb','specUcomb','loccombU']

;	stop	

		get_data,'tmpO',data=dd
		maxspec = fltarr(n_elements(dd.x))
		for i=0,n_elements(dd.x)-1 do maxspec[i] = max(dd.y[i,*],/nan)
		store_data,'maxspecO',dd.x,maxspec & options,'maxspecO','psym',3
		ylim,'maxspecO',min(maxspec,/nan),2*max(maxspec,/nan),1
		store_data,'tstlf_tot',(tmin+tmax)/2.,totalnonchorusspec_E
		store_data,'tstlf_max',(tmin+tmax)/2.,maxnonchorusspec_E & options,'tstlf_max','colors',1
		store_data,'tstlf_med',(tmin+tmax)/2.,mediannonchorusspec_E & options,'tstlf_med','colors',100
		store_data,'tstlf_avg',(tmin+tmax)/2.,avgnonchorusspec_E & options,'tstlf_avg','colors',250
		store_data,'fpeaklf',(tmin+tmax)/2.,freqpeakO_E & options,'fpeaklf','psym',-4
		options,'fpeaklf','colors',250
		options,['tstlf_tot','tstlf_max','tstlf_med','tstlf_avg','fpeaklf'],'psym',-4
		options,['tstlf_tot','tstlf_max','tstlf_med','tstlf_avg','fpeaklf'],'thick',2
		store_data,'specOcomb',data=['tmpO','fce_eq','fce_eq_2','fce_eq_10','flh_eq','fpeaklf'] & ylim,'specOcomb',minlowf,6000,1
		options,'specOcomb','ytitle','Ew spec!Clow freqs!C'+strtrim(floor(minlowf),2)+'Hz-fce/10'
		store_data,'loccombO',data=['maxspecO','tstlf_max','tstlf_med','tstlf_avg']
		options,'loccombO','ytitle','max power!Clow freqs!C'+strtrim(floor(minlowf),2)+'Hz-fce/10'
		ylim,'loccombO',min(maxspec,/nan)/100.,2*max(maxspec,/nan),1
		;ylim,'loccombO',0,max(maxspec,/nan),0
;		tplot,['rbsp'+probe+'_efw_spec64_e12ac_comb','specOcomb','loccombO']

;	stop	

		options,'loccomb?','panel_size',0.6
;		popen,'~/Desktop/'+filenamestr+'_RBSP'+probe+'_e12dc_wavepower'+'.ps'
		!p.charsize = 0.6
		tplot,['E2B_C','EuEu_comb',$
		;'rbsp'+probe+'_efw_spec64_e12ac_comb',$
		'specUcomb','loccombU',$
		'specLcomb','loccombL',$
		'specOcomb','loccombO',$
		'lboth','mltboth','sep','dl','dmlt']
		timebar,tconj
		timebar,mb_list.time,color=250
;		pclose



stop

	;**************************
	;**************************
	;**************************


		;Now the magnetic field
		get_data,'BwBw',data=dd,dlim=dlim,lim=lim
		spectmp = tsample('BwBw',[t0z2,t1z2],times=tt)
		fcetmp = tsample('fce_eq_interp',[t0z2,t1z2],times=tt)

;		get_data,'rbsp'+probe+'_efw_spec64_scmw',data=dd,dlim=dlim,lim=lim
;		spectmp = tsample('rbsp'+probe+'_efw_spec64_scmw',[t0z2,t1z2],times=tt)
;		fcetmp = tsample('fce_eq_interp',[t0z2,t1z2],times=tt)

		;limit spectral data to chorus only (upper and lower band separately), and to
		;values outside of chorus range ("other")
		spectmpL = spectmp & spectmpU = spectmp & spectmpO = spectmp
		;Remove zero values that screw up average and median calculation
		goo = where(spectmp eq 0.)
		if goo[0] ne -1 then spectmpL[goo] = !values.f_nan
		if goo[0] ne -1 then spectmpU[goo] = !values.f_nan
		if goo[0] ne -1 then spectmpO[goo] = !values.f_nan

		;Remove bad values
		if finite(fcetmp[0]) and is_struct(dd) then begin
			for qq=0,n_elements(fcetmp)-1 do begin
					gooL = where((dd.v le fcetmp[qq]/10.) or (dd.v ge fcetmp[qq]/2.))
					gooU = where((dd.v lt fcetmp[qq]/2.)  or (dd.v gt fcetmp[qq]))
					gooO = where((dd.v gt fcetmp[qq]/10.) or (dd.v lt minlowf))
					if gooL[0] ne -1 then spectmpL[qq,gooL] = !values.f_nan
					if gooU[0] ne -1 then spectmpU[qq,gooU] = !values.f_nan
					if gooO[0] ne -1 then spectmpO[qq,gooO] = !values.f_nan
			endfor
		endif


		;A common problem is that low freq broadband spikes/noise leaks into the chorus lower band. 
		;Here, remove chorus lower band power if the broadband power at >100 Hz at that exact time is greater 
		if remove_lbchorus_when_concurrent_lowf then begin 
			goodv = where(dd.v gt 100.)
			for bb=0,n_elements(spectmpL[*,0])-1 do if max(spectmpO[bb,goodv],/nan) gt max(spectmpL[bb,*],/nan) then spectmpL[bb,*] = !values.f_nan
		endif

		store_data,'tmpL',tt,spectmpL,dd.v,dlim=dlim,lim=lim
		store_data,'tmpU',tt,spectmpU,dd.v,dlim=dlim,lim=lim
		store_data,'tmpO',tt,spectmpO,dd.v,dlim=dlim,lim=lim


		for ii=0,nchunks-2 do begin 

			tmin[ii] = t0z2 + ii*tdelta
			tmax[ii] = t0z2 + (ii+1)*tdelta

		
			fcetmp = tsample('fce_eq_interp',[tmin[ii],tmax[ii]],times=tt)
			spectmpL = tsample('tmpL',[tmin[ii],tmax[ii]],times=tt2)
			spectmpU = tsample('tmpU',[tmin[ii],tmax[ii]],times=tt2)
			spectmpO = tsample('tmpO',[tmin[ii],tmax[ii]],times=tt2)


			if finite(fcetmp[0]) then begin

				totalchorusspecL_B[ii] = total(spectmpL,/nan) & if totalchorusspecL_B[ii] eq 0. then totalchorusspecL_B[ii] = !values.f_nan
				totalchorusspecU_B[ii] = total(spectmpU,/nan) & if totalchorusspecU_B[ii] eq 0. then totalchorusspecU_B[ii] = !values.f_nan
				totalnonchorusspec_B[ii] = total(spectmpO,/nan) & if totalnonchorusspec_B[ii] eq 0. then totalnonchorusspec_B[ii] = !values.f_nan

				maxchorusspecL_B[ii] = max(spectmpL,/nan,wh) & if maxchorusspecL_B[ii] eq 0. then maxchorusspecL_B[ii] = !values.f_nan
				if finite(maxchorusspecL_B[ii]) then begin
					dims=size(spectmpL,/dim)
					xind=wh mod dims[0]
					yind=wh / dims[0]
					freqpeakL_B[ii] = dd.v[yind]
				endif else freqpeakL_B[ii] = !values.f_nan

				maxchorusspecU_B[ii] = max(spectmpU,/nan,wh) & if maxchorusspecU_B[ii] eq 0. then maxchorusspecU_B[ii] = !values.f_nan
				if finite(maxchorusspecU_B[ii]) then begin
					dims=size(spectmpU,/dim)
					xind=wh mod dims[0]
					yind=wh / dims[0]
					freqpeakU_B[ii] = dd.v[yind]
				endif else freqpeakU_B[ii] = !values.f_nan

				maxnonchorusspec_B[ii] = max(spectmpO,/nan,wh) & if maxnonchorusspec_B[ii] eq 0. then maxnonchorusspec_B[ii] = !values.f_nan
				if finite(maxnonchorusspec_B[ii]) then begin
					dims=size(spectmpO,/dim)
					xind=wh mod dims[0]
					yind=wh / dims[0]
					freqpeakO_B[ii] = dd.v[yind]
				endif else freqpeakO_B[ii] = !values.f_nan


				;NEED TO TAKE MEDIAN AND AVERAGE OF ALL THE "MAX" VALUES WITHIN CURRENT TIME BLOCK
				;CURRENTLY I'M TAKING THE MED/AVG OVER EVERYTHING IN THAT BLOCK...AND THAT INCLUDES ALL THE FREQS WHERE THE WAVE 
				;POWER HAS FALLEN OFF FROM THE PEAK. 
				maxtmpL = fltarr(n_elements(spectmpL[*,0]))
				for q=0,n_elements(spectmpL[*,0])-1 do maxtmpL[q] = max(spectmpL[q,*],/nan)
				maxtmpU = fltarr(n_elements(spectmpU[*,0]))
				for q=0,n_elements(spectmpU[*,0])-1 do maxtmpU[q] = max(spectmpU[q,*],/nan)
				maxtmpO = fltarr(n_elements(spectmpO[*,0]))
				for q=0,n_elements(spectmpO[*,0])-1 do maxtmpO[q] = max(spectmpO[q,*],/nan)


				avgchorusspecL_B[ii] = mean(maxtmpL,/nan) & if avgchorusspecL_B[ii] eq 0. then avgchorusspecL_B[ii] = !values.f_nan
				avgchorusspecU_B[ii] = mean(maxtmpU,/nan) & if avgchorusspecU_B[ii] eq 0. then avgchorusspecU_B[ii] = !values.f_nan
				avgnonchorusspec_B[ii] = mean(maxtmpO,/nan) & if avgnonchorusspec_B[ii] eq 0. then avgnonchorusspec_B[ii] = !values.f_nan

				medianchorusspecL_B[ii] = median(maxtmpL) & if medianchorusspecL_B[ii] eq 0. then medianchorusspecL_B[ii] = !values.f_nan
				medianchorusspecU_B[ii] = median(maxtmpU) & if medianchorusspecU_B[ii] eq 0. then medianchorusspecU_B[ii] = !values.f_nan
				mediannonchorusspec_B[ii] = median(maxtmpO) & if mediannonchorusspec_B[ii] eq 0. then mediannonchorusspec_B[ii] = !values.f_nan

			endif else begin
				totalchorusspecL_B[ii] = !values.f_nan & totalchorusspecU_B[ii] = !values.f_nan & totalnonchorusspec_B[ii] = !values.f_nan
				maxchorusspecL_B[ii] = !values.f_nan & maxchorusspecU_B[ii] = !values.f_nan & maxnonchorusspec_B[ii] = !values.f_nan
				avgchorusspecL_B[ii] = !values.f_nan & avgchorusspecU_B[ii] = !values.f_nan & avgnonchorusspec_B[ii] = !values.f_nan
				medianchorusspecL_B[ii] = !values.f_nan & medianchorusspecU_B[ii] = !values.f_nan & mediannonchorusspec_B[ii] = !values.f_nan
			endelse
		endfor



		get_data,'tmpL',data=dd
		maxspec = fltarr(n_elements(dd.x))
		for i=0,n_elements(dd.x)-1 do maxspec[i] = max(dd.y[i,*],/nan)
		store_data,'maxspecL',dd.x,maxspec & options,'maxspecL','psym',3
		ylim,'maxspecL',min(maxspec,/nan),2*max(maxspec,/nan),1
		store_data,'tstlb_tot',(tmin+tmax)/2.,totalchorusspecL_B
		store_data,'tstlb_max',(tmin+tmax)/2.,maxchorusspecL_B & options,'tstlb_max','colors',1
		store_data,'tstlb_med',(tmin+tmax)/2.,medianchorusspecL_B & options,'tstlb_med','colors',100
		store_data,'tstlb_avg',(tmin+tmax)/2.,avgchorusspecL_B & options,'tstlb_avg','colors',250
		store_data,'fpeaklb',(tmin+tmax)/2.,freqpeakL_B & options,'fpeaklb','psym',-4
		options,'fpeaklb','colors',250
		options,['tstlb_tot','tstlb_max','tstlb_med','tstlb_avg','fpeaklb'],'psym',-4
		options,['tstlb_tot','tstlb_max','tstlb_med','tstlb_avg','fpeaklb'],'thick',2
		store_data,'specLcomb',data=['tmpL','fce_eq','fce_eq_2','fce_eq_10','flh_eq','fpeaklb'] & ylim,'specLcomb',minlowf,6000,1
		options,'specLcomb','ytitle','Bw spec!Clowerband'
		store_data,'loccombL',data=['maxspecL','tstlb_max','tstlb_med','tstlb_avg']
		options,'loccombL','ytitle','max power!Clowerband'
		ylim,'loccombL',min(maxspec,/nan),2*max(maxspec,/nan),1
;		ylim,'loccombL',0,max(maxspec,/nan),0
;		tplot,['rbsp'+probe+'_efw_spec64_scmw_comb','specLcomb','loccombL']

;	stop	

		get_data,'tmpU',data=dd
		maxspec = fltarr(n_elements(dd.x))
		for i=0,n_elements(dd.x)-1 do maxspec[i] = max(dd.y[i,*],/nan)
		store_data,'maxspecU',dd.x,maxspec & options,'maxspecU','psym',3
		ylim,'maxspecU',min(maxspec,/nan),2*max(maxspec,/nan),1
		store_data,'tstub_tot',(tmin+tmax)/2.,totalchorusspecU_B
		store_data,'tstub_max',(tmin+tmax)/2.,maxchorusspecU_B & options,'tstub_max','colors',1
		store_data,'tstub_med',(tmin+tmax)/2.,medianchorusspecU_B & options,'tstub_med','colors',100
		store_data,'tstub_avg',(tmin+tmax)/2.,avgchorusspecU_B & options,'tstub_avg','colors',250
		store_data,'fpeakub',(tmin+tmax)/2.,freqpeakU_B & options,'fpeakub','psym',-4
		options,'fpeakub','colors',250
		options,['tstub_tot','tstub_max','tstub_med','tstub_avg','fpeakub'],'psym',-4
		options,['tstub_tot','tstub_max','tstub_med','tstub_avg','fpeakub'],'thick',2
		store_data,'specUcomb',data=['tmpU','fce_eq','fce_eq_2','fce_eq_10','flh_eq','fpeakub'] & ylim,'specUcomb',minlowf,6000,1
		options,'specUcomb','ytitle','Bw spec!Cupperband'
		store_data,'loccombU',data=['maxspecU','tstub_max','tstub_med','tstub_avg']
		options,'loccombU','ytitle','max power!Cupperband'
		ylim,'loccombU',min(maxspec,/nan),2*max(maxspec,/nan),1
;		ylim,'loccombU',0,max(maxspec,/nan),0
;		tplot,['rbsp'+probe+'_efw_spec64_scmw_comb','specUcomb','loccombU']

;	stop	

		get_data,'tmpO',data=dd
		maxspec = fltarr(n_elements(dd.x))
		for i=0,n_elements(dd.x)-1 do maxspec[i] = max(dd.y[i,*],/nan)
		store_data,'maxspecO',dd.x,maxspec & options,'maxspecO','psym',3
		ylim,'maxspecO',min(maxspec,/nan),2*max(maxspec,/nan),1
		store_data,'tstlf_tot',(tmin+tmax)/2.,totalnonchorusspec_B
		store_data,'tstlf_max',(tmin+tmax)/2.,maxnonchorusspec_B & options,'tstlf_max','colors',1
		store_data,'tstlf_med',(tmin+tmax)/2.,mediannonchorusspec_B & options,'tstlf_med','colors',100
		store_data,'tstlf_avg',(tmin+tmax)/2.,avgnonchorusspec_B & options,'tstlf_avg','colors',250
		store_data,'fpeaklf',(tmin+tmax)/2.,freqpeakO_B & options,'fpeaklf','psym',-4
		options,'fpeaklf','colors',250
		options,['tstlf_tot','tstlf_max','tstlf_med','tstlf_avg','fpeaklf'],'psym',-4
		options,['tstlf_tot','tstlf_max','tstlf_med','tstlf_avg','fpeaklf'],'thick',2
		store_data,'specOcomb',data=['tmpO','fce_eq','fce_eq_2','fce_eq_10','flh_eq','fpeaklf'] & ylim,'specOcomb',minlowf,6000,1
		options,'specOcomb','ytitle','Bw spec!Clow freqs!Clow freqs!C'+strtrim(floor(minlowf),2)+'Hz-fce/10'
		store_data,'loccombO',data=['maxspecO','tstlf_max','tstlf_med','tstlf_avg']
		options,'loccombO','ytitle','max power!Clow freqs!Clow freqs!C'+strtrim(floor(minlowf),2)+'Hz-fce/10'
		ylim,'loccombO',min(maxspec,/nan)/100.,2*max(maxspec,/nan),1
;		ylim,'loccombO',0,max(maxspec,/nan),0
;		tplot,['rbsp'+probe+'_efw_spec64_scmw_comb','specOcomb','loccombO']

;	stop	

		options,'loccomb?','panel_size',0.6
;		popen,'~/Desktop/'+filenamestr+'_RBSP'+probe+'_scmw_wavepower'+'.ps'
		!p.charsize = 0.6
		tplot,['E2B_C','BwBw_comb',$
;		'rbsp'+probe+'_efw_spec64_scmw_comb',$
		'specUcomb','loccombU',$
		'specLcomb','loccombL',$
		'specOcomb','loccombO',$
		'lboth','mltboth','sep','dl','dmlt']
		timebar,tconj
		timebar,mb_list.time,color=250
;		pclose
stop

		;---------------------------------------------------------------------
		;FILTERBANK DATA
		;---------------------------------------------------------------------

		;Figure out if we're dealing with e12 or e34 for FBK data 
		e1234 = ''
		tstvar = tnames('rbsp'+probe+'_efw_fbk7_e??dc_pk')
		if tstvar ne '' then e1234 = strmid(tstvar,15,3)		
		tstvar = tnames('rbsp'+probe+'_efw_fbk13_e??dc_pk')
		if tstvar ne '' then e1234 = strmid(tstvar,16,3)


		;---------------------------------------------------------------
		;Find max filterbank value in various bins for FBK7 mode



		for ii=0d,nchunks-2 do begin 

			tmin[ii] = t0z2 + ii*tdelta
			tmax[ii] = t0z2 + (ii+1)*tdelta

			;print,time_string(tmin[ii]), ' - ', time_string(tmax[ii])
		
			fcetmp = tsample('fce_eq_interp',[tmin[ii],tmax[ii]],times=tt)


			undefine,fbktmp_7E, fbktmp_7B, fbktmp_13E, fbktmp_13B

			if tdexists('rbsp'+probe+'_efw_fbk7_'+e1234+'dc_pk',tmin[ii],tmax[ii]) then $
				fbktmp_7E = tsample('rbsp'+probe+'_efw_fbk7_'+e1234+'dc_pk',[tmin[ii],tmax[ii]])
			if tdexists('rbsp'+probe+'_efw_fbk7_scmw_pk',tmin[ii],tmax[ii]) then $
				fbktmp_7B = tsample('rbsp'+probe+'_efw_fbk7_scmw_pk',[tmin[ii],tmax[ii]])
			if tdexists('rbsp'+probe+'_efw_fbk13_'+e1234+'dc_pk',tmin[ii],tmax[ii]) then $
				fbktmp_13E = tsample('rbsp'+probe+'_efw_fbk13_'+e1234+'dc_pk',[tmin[ii],tmax[ii]])
			if tdexists('rbsp'+probe+'_efw_fbk13_scmw_pk',tmin[ii],tmax[ii]) then $
				fbktmp_13B = tsample('rbsp'+probe+'_efw_fbk13_scmw_pk',[tmin[ii],tmax[ii]])



			;Find max filterbank value in various bins for FBK7 mode
			if keyword_set(fbktmp_7E) then begin
				fbk7_Ewmax_3[ii] = float(max(fbktmp_7E[*,3],/nan))   ;50-100 Hz
				fbk7_Ewmax_4[ii] = float(max(fbktmp_7E[*,4],/nan))   ;200-400 Hz
				fbk7_Ewmax_5[ii] = float(max(fbktmp_7E[*,5],/nan))   ;0.8-1.6 Hz
				fbk7_Ewmax_6[ii] = float(max(fbktmp_7E[*,6],/nan))   ;3.2-6.5 Hz
			endif else begin
				fbk7_Ewmax_3[ii] = !values.f_nan
				fbk7_Ewmax_4[ii] = !values.f_nan
				fbk7_Ewmax_5[ii] = !values.f_nan
				fbk7_Ewmax_6[ii] = !values.f_nan
			endelse
			if keyword_set(fbktmp_7B) then begin
				fbk7_Bwmax_3[ii] = 1000.*float(max(fbktmp_7B[*,3],/nan))
				fbk7_Bwmax_4[ii] = 1000.*float(max(fbktmp_7B[*,4],/nan))
				fbk7_Bwmax_5[ii] = 1000.*float(max(fbktmp_7B[*,5],/nan))
				fbk7_Bwmax_6[ii] = 1000.*float(max(fbktmp_7B[*,6],/nan))
			endif else begin
				fbk7_Bwmax_3[ii] = !values.f_nan
				fbk7_Bwmax_4[ii] = !values.f_nan
				fbk7_Bwmax_5[ii] = !values.f_nan
				fbk7_Bwmax_6[ii] = !values.f_nan
			endelse



			;Find max filterbank value in various bins for FBK13 mode
			if keyword_set(fbktmp_13E) then begin
				fbk13_Ewmax_6[ii] = float(max(fbktmp_13E[*,6],/nan))   ;50-100 Hz
				fbk13_Ewmax_7[ii] = float(max(fbktmp_13E[*,7],/nan))   ;100-200 Hz
				fbk13_Ewmax_8[ii] = float(max(fbktmp_13E[*,8],/nan))   ;200-400 Hz
				fbk13_Ewmax_9[ii] = float(max(fbktmp_13E[*,9],/nan))   ;400-800 Hz
				fbk13_Ewmax_10[ii] = float(max(fbktmp_13E[*,10],/nan)) ;0.8-1.6 kHz
				fbk13_Ewmax_11[ii] = float(max(fbktmp_13E[*,11],/nan)) ;1.6-3.2 kHz
				fbk13_Ewmax_12[ii] = float(max(fbktmp_13E[*,12],/nan)) ;3.2-6.5 kHz
			endif else begin
				fbk13_Ewmax_6[ii] = !values.f_nan
				fbk13_Ewmax_7[ii] = !values.f_nan
				fbk13_Ewmax_8[ii] = !values.f_nan
				fbk13_Ewmax_9[ii] = !values.f_nan
				fbk13_Ewmax_10[ii] = !values.f_nan
				fbk13_Ewmax_11[ii] = !values.f_nan
				fbk13_Ewmax_12[ii] = !values.f_nan
			endelse
			if keyword_set(fbktmp_13B) then begin
				fbk13_Bwmax_6[ii] = 1000.*float(max(fbktmp_13B[*,6],/nan))
				fbk13_Bwmax_7[ii] = 1000.*float(max(fbktmp_13B[*,7],/nan))
				fbk13_Bwmax_8[ii] = 1000.*float(max(fbktmp_13B[*,8],/nan))
				fbk13_Bwmax_9[ii] = 1000.*float(max(fbktmp_13B[*,9],/nan))
				fbk13_Bwmax_10[ii] = 1000.*float(max(fbktmp_13B[*,10],/nan))
				fbk13_Bwmax_11[ii] = 1000.*float(max(fbktmp_13B[*,11],/nan))
				fbk13_Bwmax_12[ii] = 1000.*float(max(fbktmp_13B[*,12],/nan))
			endif else begin
				fbk13_Bwmax_6[ii] = !values.f_nan
				fbk13_Bwmax_7[ii] = !values.f_nan
				fbk13_Bwmax_8[ii] = !values.f_nan
				fbk13_Bwmax_9[ii] = !values.f_nan
				fbk13_Bwmax_10[ii] = !values.f_nan
				fbk13_Bwmax_11[ii] = !values.f_nan
				fbk13_Bwmax_12[ii] = !values.f_nan
			endelse
		;----------------------------------------------
		endfor ;nchunks



		;****************************************************
		;Plots for testing FBK data

		skip = 1 
		if not skip then begin 
			split_vec,'rbsp'+probe+'_efw_fbk7_'+e1234+'dc_pk'
			split_vec,'rbsp'+probe+'_efw_fbk7_scmw_pk'
			options,'rbsp'+probe+'_efw_fbk7_'+e1234+'dc_pk_?','spec',0
			options,'rbsp'+probe+'_efw_fbk7_scmw_pk_?','spec',0

			store_data,'fbk7_Ewmax_3',(tmin+tmax)/2.,fbk7_Ewmax_3
			store_data,'fbk7_Ewmax_4',(tmin+tmax)/2.,fbk7_Ewmax_4
			store_data,'fbk7_Ewmax_5',(tmin+tmax)/2.,fbk7_Ewmax_5
			store_data,'fbk7_Ewmax_6',(tmin+tmax)/2.,fbk7_Ewmax_6
			store_data,'fbk7_Ewmax_3_comb',data=['rbsp'+probe+'_efw_fbk7_'+e1234+'dc_pk_3','fbk7_Ewmax_3']
			store_data,'fbk7_Ewmax_4_comb',data=['rbsp'+probe+'_efw_fbk7_'+e1234+'dc_pk_4','fbk7_Ewmax_4']
			store_data,'fbk7_Ewmax_5_comb',data=['rbsp'+probe+'_efw_fbk7_'+e1234+'dc_pk_5','fbk7_Ewmax_5']
			store_data,'fbk7_Ewmax_6_comb',data=['rbsp'+probe+'_efw_fbk7_'+e1234+'dc_pk_6','fbk7_Ewmax_6']

			store_data,'fbk7_Bwmax_3',(tmin+tmax)/2.,fbk7_Bwmax_3/1000.
			store_data,'fbk7_Bwmax_4',(tmin+tmax)/2.,fbk7_Bwmax_4/1000.
			store_data,'fbk7_Bwmax_5',(tmin+tmax)/2.,fbk7_Bwmax_5/1000.
			store_data,'fbk7_Bwmax_6',(tmin+tmax)/2.,fbk7_Bwmax_6/1000.
			store_data,'fbk7_Bwmax_3_comb',data=['rbsp'+probe+'_efw_fbk7_scmw_pk_3','fbk7_Bwmax_3']
			store_data,'fbk7_Bwmax_4_comb',data=['rbsp'+probe+'_efw_fbk7_scmw_pk_4','fbk7_Bwmax_4']
			store_data,'fbk7_Bwmax_5_comb',data=['rbsp'+probe+'_efw_fbk7_scmw_pk_5','fbk7_Bwmax_5']
			store_data,'fbk7_Bwmax_6_comb',data=['rbsp'+probe+'_efw_fbk7_scmw_pk_6','fbk7_Bwmax_6']


			tplot,['fbk7_Ewmax_4_comb','fbk7_Ewmax_5_comb','fbk7_Ewmax_6_comb',$
					'fbk7_Bwmax_4_comb','fbk7_Bwmax_5_comb','fbk7_Bwmax_6_comb']

		endif





		;---------------------------------------------------
		;Normalize the frequencies to the min/max values of the entire range of fce's seen during each chunk. 
		;Note that this can result in some, for example, lower band waves being outside of the lower band range. 
		;This happens most often fce is changing fairly rapidly and the time chunk is large (e.g. 10 min)
		;---------------------------------------------------


		fceavg = (fcemin + fcemax)/2.
		f_fcemin_peakL_B = freqpeakL_B/fcemax
		f_fcemax_peakL_B = freqpeakL_B/fcemin
		f_fcemin_peakL_E = freqpeakL_E/fcemax
		f_fcemax_peakL_E = freqpeakL_E/fcemin

		f_fcemin_peakU_B = freqpeakU_B/fcemax
		f_fcemax_peakU_B = freqpeakU_B/fcemin
		f_fcemin_peakU_E = freqpeakU_E/fcemax
		f_fcemax_peakU_E = freqpeakU_E/fcemin

		f_fcemin_peakO_B = freqpeakO_B/fcemax
		f_fcemax_peakO_B = freqpeakO_B/fcemin
		f_fcemin_peakO_E = freqpeakO_E/fcemax
		f_fcemax_peakO_E = freqpeakO_E/fcemin

;stop

		;---------------------------------------------------
		;Output results to file
		;---------------------------------------------------

;		sc = strmid(fb,2,1)
;		print,currday

		result = FILE_TEST(pathoutput + 'RBSP'+probe+'_'+fb+'_conjunction_values_'+filenamestr+'.txt')


		;format statement for final output
		fmt = '(a16,2x,a16,2x,20(f7.2,2x),24(e14.4,2x),22(f10.2,2x),6(f8.0,2x),12(f12.8,2x))'


		openw,lun,pathoutput + 'RBSP'+probe+'_'+fb+'_conjunction_values_'+filenamestr+'.txt',/get_lun
		for qq=0,n_elements(tmin)-1 do begin
			printf,lun,time_string(tmin[qq])+' ',time_string(tmax[qq]), $
			Lref, MLTref, $
			lmin[qq], lmax[qq], lavg[qq], lmed[qq], $
			mltmin[qq], mltmax[qq], mltavg[qq], mltmed[qq], $
			dlmin[qq], dlmax[qq], dlavg[qq], dlmed[qq], $
			dmltmin[qq], dmltmax[qq], dmltavg[qq], dmltmed[qq], $
			sepmin[qq], sepmax[qq], $
			totalnonchorusspec_E[qq], maxnonchorusspec_E[qq], avgnonchorusspec_E[qq], mediannonchorusspec_E[qq], $
			totalchorusspecL_E[qq], maxchorusspecL_E[qq], avgchorusspecL_E[qq], medianchorusspecL_E[qq], $
			totalchorusspecU_E[qq], maxchorusspecU_E[qq], avgchorusspecU_E[qq], medianchorusspecU_E[qq], $
			totalnonchorusspec_B[qq], maxnonchorusspec_B[qq], avgnonchorusspec_B[qq], mediannonchorusspec_B[qq], $
			totalchorusspecL_B[qq], maxchorusspecL_B[qq], avgchorusspecL_B[qq], medianchorusspecL_B[qq], $
			totalchorusspecU_B[qq], maxchorusspecU_B[qq], avgchorusspecU_B[qq], medianchorusspecU_B[qq], $
			fbk7_Ewmax_3[qq], fbk7_Ewmax_4[qq], fbk7_Ewmax_5[qq], fbk7_Ewmax_6[qq], $
			fbk7_Bwmax_3[qq], fbk7_Bwmax_4[qq], fbk7_Bwmax_5[qq], fbk7_Bwmax_6[qq], $
			fbk13_Ewmax_6[qq], fbk13_Ewmax_7[qq], fbk13_Ewmax_8[qq], fbk13_Ewmax_9[qq], fbk13_Ewmax_10[qq], fbk13_Ewmax_11[qq], fbk13_Ewmax_12[qq], $
			fbk13_Bwmax_6[qq], fbk13_Bwmax_7[qq], fbk13_Bwmax_8[qq], fbk13_Bwmax_9[qq], fbk13_Bwmax_10[qq], fbk13_Bwmax_11[qq], fbk13_Bwmax_12[qq], $
			freqpeakO_E[qq], freqpeakL_E[qq], freqpeakU_E[qq], $
			freqpeakO_B[qq], freqpeakL_B[qq], freqpeakU_B[qq], $
			f_fcemin_peakO_E[qq], f_fcemax_peakO_E[qq], $
			f_fcemin_peakL_E[qq], f_fcemax_peakL_E[qq], $
			f_fcemin_peakU_E[qq], f_fcemax_peakU_E[qq], $
			f_fcemin_peakO_B[qq], f_fcemax_peakO_B[qq], $
			f_fcemin_peakL_B[qq], f_fcemax_peakL_B[qq], $
			f_fcemin_peakU_B[qq], f_fcemax_peakU_B[qq], format=fmt


		endfor 

		close,lun
		free_lun,lun


stop

	endif  ;for no missing data
endfor
end