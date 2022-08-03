;(formerly master_conjunction_list_part5.pro)


;Part 5 in the process in determining list of FB/RBSP conjunctions.
;This computes statistics of chorus waves at set time intervals away from the closest conjunction. 
;This allows me to see the correlation b/t chorus and microbursts change as a function of separation. 

;2018 Feb 26th --test day for LH waves


;Things to add / Issues to address
;--E/B values 
;--Add a standard deviation measure to indicate how varied the amplitudes are? 


;Grab local path to save data
;homedir = (file_search('~',/expand_tilde))[0]+'/'



;*************************************
;*************************************
;POSSIBLE ISSUES

;NEED TO REMOVE DATES WITH WEIRD SPECTRAL ISSUES (E.G. THE EMFISIS ISSUE WE HAD B/C EFW WASN'T BIASING CORRECTLY (E.G. AUG 13, 2016 RBA, FU4) 
;--(1) BwBw data doesn't seem to be contaminated.
;--(2) EuEu data isn't that contamainated, but may be a problem. 
;ONE WAY TO (SOMETIMES) IDENTIFY THESE DATES IS WHEN THE MEDIAN IS << MAX AND AVERAGE VALUES IN THE LOW FREQUENCY SPECTRA. (E.G. AUG 29, 2016, RBA, FU4)
;HOWEVER, THIS DOESN'T ALWAYS WORK (E.G. 2016-08-30 RBA, FU4)
;-->THIS ALSO MEANS THAT I TRUST THE TOTAL, MAX, AND AVG VALUES MUCH MORE THAN THE MEDIAN. 
;-->IT DEFINITELY MEANS I CAN'T TRUST THE LOW FREQ VALUES UNLESS I REMOVE THESE DATES

;COMBINE BOTH UPPER AND LOWER BAND (AS WELL AS KEEPING THEM INDEPENDENT). BAND SEPARATION ISN'T ALWAYS GREAT (mostly an issue when fce is changing rapidly near perigee). 


;THERE'S A SPECTRAL LINE AT ~2 KHZ THAT IS AT 10^-12 V^2/M^2/HZ. DURING EXTREMELY QUIET TIMES THIS CREATES A FLAT PEAK/AVG/ETC POWER CURVE. 
;MAYBE THIS SHOULD BE CONSIDERED THE LOWER POWER CUTOFF FOR E-FIELD. 
;IT'S NOT PRESENT IN BwBw DATA

;*************************************
;*************************************





;--------------------------------------------------------
;input variables
;--------------------------------------------------------

testing = 1  ;test plots?
hires = 1   ;conjunctions w/ hires only?
probe = 'a'
fb = 'FU4'

minwavefreq = 60. ;(Hz) Lowest freq to be considered for nonchorus. Having too low (e.g. 20 Hz) exposes the analysis to the 
				;abnormally large power at the lowest spectral bins

tdelta = double(60.*10.)  ;(sec) Every time chunk of size tdelta will be separately analyzed for chorus properties, as well as 
						 ;separation b/t RBSP and FB relative to the location of closest approach. 
time_extent = 5.*3600. ;(sec) Total Max +/- time to consider from conjunction closest approach. (e.g. +/- 3 hrs on either side. This total time 
						;will be divided into chunks of size "tdelta")


minwavefreq = 60.  ;(Hz) Lowest freq to be considered for nonchorus. Having too low (e.g. 20 Hz) exposes the analysis to the
;abnormally large power at the lowest spectral bins


remove_chorus_when_concurrent_lowf = 1.
;ADVICE: KEEP THIS VARIABLE SET TO 1.  Broadband low freq power at <0.1 fce can sometimes extend into the chorus band and contaminate chorus id. 
;This can be very common in later mission when spectra are noisy. 
;By setting this keyword: I'll remove LB chorus if its max value is < the value of the low frequency power at the highest low frequency bin (just under 0.1*fce). 
;Here I'm assuming that broadband wave power in the low freq bin falls off as 1/f. 

;There are two ways to remove upper band power:
;(1) require UB power to exceed the low freq power at the highest freq in the low frequency (f<0.1fce) bin. 
;(2) require only the LB power to exceed it 
;The first is problematic b/c it removes nearly all the upper band power from consideration.
;The second is better b/c it retains this power, but here I'm assuming that broadband low frequency spikes are not significantly extending to the upper band. 




;--------------------------------------------------------
;Path to save data to
;--------------------------------------------------------

paths = get_project_paths()
pathoutput = paths.extended_conjunction_values + 'RBSP'+strupcase(probe)+'_'+fb



;-----------------------------------------------------------------
;Calculated quantities
;-----------------------------------------------------------------

nchunks = 2*time_extent/tdelta + 1.

rb = 'rbsp'+probe


;---------------------------------------------------------------------
;Load conjunction data for all the FIREBIRD passes with HiRes data
;---------------------------------------------------------------------


if hires then suffix = '_conjunctions_hr.sav' else suffix = '_conjunctions.sav'

fn = fb+'_'+'RBSP'+strupcase(probe)+suffix
restore,paths.breneman_conjunctions+fn


tfb0 = t0
tfb1 = t1



;Print list of times (since these are based on FB ephemeris data, they don't need a time correction)
for bb=0,n_elements(tfb0)-1 do print,bb,' ',time_string(tfb0[bb])



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


	datestart = strmid(tstart,0,10)
	dateend = strmid(tend,0,10)
	if datestart eq dateend then ndays_load = 1 else ndays_load = 2

	timespan,datestart,ndays_load,/days
	trange = timerange()




	;(***DON'T REMOVE!!!!) Need to do this each time or else the amplitudes can get filled in incorrectly. 
	store_data,'*',/delete




	;-----------------------------------------------------------------------
	;load FIREBIRD context data.
	;Lots of missing FIREBIRD data, so before we load all the other data we'll test to see if it's been loaded.
	;If not, then skip to next data
	;-----------------------------------------------------------------------

	firebird_load_context_data_cdf_file,strmid(fb,2,1)

	xtst1 = tsample('flux_context_'+fb,[time_double(trange[0]),time_double(trange[1])])

	missingdata = 0
	if n_elements(xtst1) eq 1 and finite(xtst1[0]) eq 0 then missingdata = 1


  ;----------------------------------------------------------------------
  ;If there's no missing FIREBIRD data, then proceed with loading other data and analysis
  ;----------------------------------------------------------------------

	if missingdata ne 1 then begin


    ;----------------------------------
    ;all additional data loading 
    ;----------------------------------

		rbsp_load_efw_cdf,probe,'l2','spec'
		rbsp_load_efw_cdf,probe,'l2','fbk'
		rbsp_load_ephem_cdf,probe
		rbsp_load_emfisis_cdf,probe,'l3','4sec/gsm'
		rbsp_load_emfisis_cdf,probe,'l2','wfr/spectral-matrix'


    rb = strlowcase(rb)  ;****NOT SURE WHERE THIS IS GETTING CHANGED TO CAPS


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
    

    ;---------------------------------------------------------------------------
    ;Create tplot variable of conjunction times 
    ;---------------------------------------------------------------------------

		ntimes = 86400.*ndays_load
		times_artificial = time_double(trange[0]) + dindgen(ndays_load*ntimes)
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



		;---------------------------------------------------------
		;Set tlimits for conjunction (used only for determining closest approach)
		;---------------------------------------------------------

		get_data,'fb_conjunction_times',ttmp,dtmp
		goo = where(dtmp eq 1)
		tmid = (ttmp[goo[0]] + ttmp[goo[n_elements(goo)-1]])/2.
		t0z = tmid - 3600.  
		t1z = tmid + 3600.



  	;---------------------------------------------------------
  	;Find the MLT, L, deltaMLT and deltaL of the closest pass
  	;---------------------------------------------------------

		tinterpol_mxn,rb+'_lshell','McIlwainL',newname=rb+'_lshell_interp'
		tinterpol_mxn,rb+'_mlt','MLT',newname=rb+'_mlt_interp'
		dif_data,rb+'_lshell_interp','McIlwainL',newname='ldiff'
		calculate_angle_difference,rb+'_mlt_interp','MLT',newname='mltdiff'


		options,['ldiff','mltdiff'],'psym',-2
		ylim,'ldiff',-20,20
    tplot,['ldiff','mltdiff']


		time_clip,'ldiff',t0z,t1z,newname='ldiff_tc'
		time_clip,'mltdiff',t0z,t1z,newname='mltdiff_tc'
		time_clip,rb+'_lshell_interp',t0z,t1z,newname=rb+'_lshell_interp_tc'
		time_clip,rb+'_mlt_interp',t0z,t1z,newname=rb+'_mlt_interp_tc'
		time_clip,'MLT',t0z,t1z,newname='fb_mlt_tc'
		time_clip,'McIlwainL',t0z,t1z,newname='fb_mcilwainL_tc'

		ylim,'fb_mcilwainL_tc',0,20
		ylim,'ldiff_tc',-20,20



    ;----------------------------------------------------------------------
		;Find absolute value of sc separation. We'll use the min value of this to define dLmin and dMLTmin
		;----------------------------------------------------------------------

		sc_absolute_separation,rb+'_lshell_interp_tc','fb_mcilwainL_tc',rb+'_mlt_interp_tc','fb_mlt_tc'

		ylim,'separation_absolute',-20,20
		options,['separation_absolute','ldiff_tc','mltdiff_tc',rb+'_lshell_interp_tc',rb+'_mlt_interp_tc','fb_mlt_tc','fb_mcilwainL_tc'],'psym',-2
		;timespan,datestart,ndays_load,/days
		tplot,['separation_absolute','ldiff_tc','mltdiff_tc',rb+'_lshell_interp_tc',rb+'_mlt_interp_tc','fb_mlt_tc','fb_mcilwainL_tc']


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


		tconj = min_sep_time
		t0z2 = tconj - time_extent
		t1z2 = tconj + time_extent


		tmpp = time_string(tconj)
		filenamestr = strmid(tmpp,0,4)+strmid(tmpp,5,2)+strmid(tmpp,8,2)+'_'+strmid(tmpp,11,2)+strmid(tmpp,14,2)+strmid(tmpp,17,2)



		;-----------------------------------------------------
		;Create final data arrays
		;-----------------------------------------------------


    bands = ['LF','LB','UB','HF']
    nbands = n_elements(bands)
    
;    types = ['total','max','avg','median','0.25quartile','0.5quartile','0.75quartile']
    types = ['total','max','median','avg','0.25quartile','0.5quartile','0.75quartile']
    ntypes = n_elements(types)
    
    dataspecE = fltarr(nchunks-1,ntypes,nbands)
    dataspecB = fltarr(nchunks-1,ntypes,nbands)
    freqpeakE = fltarr(nchunks-1,nbands)
    freqpeakB = fltarr(nchunks-1,nbands)



    ;The four channels that I use for FBK7 (50-100; 200-400; 0.8-1.6; 3.2-6.5)
    ;The seven channels that I use for FBK13 (50-100; 100-200; 200-400; 400-800; 0.8-1.6; 1.6-3.2; 3.2-6.5)

    fbk7E = fltarr(nchunks-1,7)
    fbk7B = fltarr(nchunks-1,7)
    fbk13E = fltarr(nchunks-1,13)
    fbk13B = fltarr(nchunks-1,13)


		d = fltarr(nchunks-1)


		sepmin = d & sepmax = d
		lmin = d & lmax = d & lmed = d & lavg = d
		mltmin = d & mltmax = d & mltmed = d & mltavg = d
		dlmin = d & dlmax = d & dlmed = d & dlavg = d
		dmltmin = d & dmltmax = d & dmltmed = d & dmltavg = d
		fcemin = d & fcemax = d
		tmin = d & tmax = d


		;-----------------------------------------------------------
		;Find L/MLT values in various time chunks surrounding the conjunction
		;-----------------------------------------------------------

		for ii=0,nchunks-2 do begin 

			tmin[ii] = t0z2 + ii*tdelta
			tmax[ii] = t0z2 + (ii+1)*tdelta

			lvals = tsample(rb+'_lshell',[tmin[ii],tmax[ii]],time=tms)
			mltvals = tsample(rb+'_mlt',[tmin[ii],tmax[ii]],time=tms)


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
		endfor  ;nchunks




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



    ;------------------------------------------------------------------
    ;Split up spectra into different bands for separate analysis
    ;------------------------------------------------------------------

    ;Names for splitting the spectra up
    mintmp = strtrim(floor(minwavefreq),2)
    channelnamesE = 'E_'+['0',mintmp+'Hz','0.1fce','0.5fce','fce','7300Hz']
    channelnamesB = 'B_'+['0',mintmp+'Hz','0.1fce','0.5fce','fce','7300Hz']


    ;get dlim structure
    get_data,'EuEu',data=dd,dlim=dlimE,lim=limE
    get_data,'BwBw',data=dd,dlim=dlimB,lim=limB

    spectmpE = tsample('EuEu',[t0z2,t1z2],times=ttspec)
    spectmpB = tsample('BwBw',[t0z2,t1z2],times=ttspec)
    tinterpol_mxn,'fce_eq','EuEu'
    fcetmp = tsample('fce_eq_interp',[t0z2,t1z2],times=ttfce)


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
      wave_valsE = replicate(!values.f_nan,n_elements(channelnames),4)
      wave_valsB = replicate(!values.f_nan,n_elements(channelnames),4)
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


    ;-------------------------------------------------------------------------------------
    ;A common problem is that low freq broadband spikes/noise leaks into the chorus bands.
    ;Here, remove chorus power if the broadband power at the highest frequency of the low frequency waves (f<0.1fce, typically) at each time is than the
    ;max power in the chorus bands. 
    ;-------------------------------------------------------------------------------------

    if remove_chorus_when_concurrent_lowf then begin
      get_data,'tmpLF_E',data=lf
      get_data,'tmpLB_E',data=lb
      get_data,'tmpUB_E',data=ub

      for w=0,n_elements(lf.x)-1 do begin 
        ;identify max freq of low band power with actual wave power (not NaN)
        goo = where((lf.v gt minwavefreq) and (finite(lf.y[w,*])))
        if goo[0] ne -1 then begin
          goomax = goo[n_elements(goo)-1]  
          if lf.y[w,goomax] gt max(lb.y[w,*],/nan) then begin
            lb.y[w,*] = !values.f_nan
            ub.y[w,*] = !values.f_nan
          endif
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
          if lf.y[w,goomax] gt max(lb.y[w,*],/nan) then begin
            lb.y[w,*] = !values.f_nan
            ub.y[w,*] = !values.f_nan
          endif
        endif
      endfor
      store_data,'tmpLB_B',data=lb
      store_data,'tmpUB_B',data=ub

    endif  ;remove_chorus_when_concurrent_lowf



    ;-----------------------------------------------------------
    ;E-field and B-field spectra: find wave statistics in various time chunks surrounding the conjunction
    ;-----------------------------------------------------------

  
		for ii=0,nchunks-2 do begin 

			tmin[ii] = t0z2 + ii*tdelta
			tmax[ii] = t0z2 + (ii+1)*tdelta


			fcetmp = tsample('fce_eq_interp',[tmin[ii],tmax[ii]],times=tt)
      spectmpE = [[[tsample('tmpLF_E',[tmin[ii],tmax[ii]])]],$
                 [[tsample('tmpLB_E',[tmin[ii],tmax[ii]],times=tt2)]],$
                 [[tsample('tmpUB_E',[tmin[ii],tmax[ii]])]],$
                 [[tsample('tmpHF_E',[tmin[ii],tmax[ii]])]]]
      spectmpB = [[[tsample('tmpLF_B',[tmin[ii],tmax[ii]])]],$
                 [[tsample('tmpLB_B',[tmin[ii],tmax[ii]],times=tt2)]],$
                 [[tsample('tmpUB_B',[tmin[ii],tmax[ii]])]],$
                 [[tsample('tmpHF_B',[tmin[ii],tmax[ii]])]]]

			fcemin[ii] = min(fcetmp,/nan)
			fcemax[ii] = max(fcetmp,/nan)





			if finite(fcetmp[0]) then begin

        for b=0,nbands-1 do begin
          dataspecE[ii,0,b] = total(spectmpE[*,*,b],/nan)
          dataspecB[ii,0,b] = total(spectmpB[*,*,b],/nan)
          if dataspecE[ii,0,b] eq 0. then dataspecE[ii,0,b] = !values.f_nan
          if dataspecB[ii,0,b] eq 0. then dataspecB[ii,0,b] = !values.f_nan
                
          dataspecE[ii,1,b] = max(spectmpE[*,*,b],/nan,wh) & if dataspecE[ii,1,b] eq 0. then dataspecE[ii,1,b] = !values.f_nan
          if finite(dataspecE[ii,1,b]) then begin
            dims=size(spectmpE[*,*,b],/dim)
            xind=wh mod dims[0]
            yind=wh / dims[0]
            ;sometimes yind gets set to zero. 
            if yind ne 0. then freqpeakE[ii,b] = dd.v[yind] else freqpeakE[ii,b] = !values.f_nan
          endif else freqpeakE[ii,b] = !values.f_nan

          dataspecB[ii,1,b] = max(spectmpB[*,*,b],/nan,wh) & if dataspecB[ii,1,b] eq 0. then dataspecB[ii,1,b] = !values.f_nan
          if finite(dataspecB[ii,1,b]) then begin
            dims=size(spectmpB[*,*,b],/dim)
            xind=wh mod dims[0]
            yind=wh / dims[0]
            ;sometimes yind gets set to zero.
            if yind ne 0. then freqpeakB[ii,b] = dd.v[yind] else freqpeakB[ii,b] = !values.f_nan
          endif else freqpeakB[ii,b] = !values.f_nan



          ;-------------------------------------------------------
          ;Need to take median and average of all the "max" values within current time block
          ;currently i'm taking the med/avg over everything in that block...and that includes all the freqs where the wave 
          ;power has fallen off from the peak. 
          ;-------------------------------------------------------

          maxtmpE = fltarr(n_elements(spectmpE[*,0,0]))
          maxtmpB = fltarr(n_elements(spectmpB[*,0,0]))
          for q=0,n_elements(spectmpE[*,0,0])-1 do maxtmpE[q] = max(spectmpE[q,*,b],/nan)
          for q=0,n_elements(spectmpB[*,0,0])-1 do maxtmpB[q] = max(spectmpB[q,*,b],/nan)

          dataspecE[ii,2,b] = median(maxtmpE) & if dataspecE[ii,2,b] eq 0. then dataspecE[ii,2,b] = !values.f_nan
          dataspecB[ii,2,b] = median(maxtmpB) & if dataspecB[ii,2,b] eq 0. then dataspecB[ii,2,b] = !values.f_nan
          dataspecE[ii,3,b] = mean(maxtmpE,/nan) & if dataspecE[ii,3,b] eq 0. then dataspecE[ii,3,b] = !values.f_nan
          dataspecB[ii,3,b] = mean(maxtmpB,/nan) & if dataspecB[ii,3,b] eq 0. then dataspecB[ii,3,b] = !values.f_nan


          ;------------------------------------------------------------------------
          ;Quartiles
          ;------------------------------------------------------------------------

          ;Get rid of NaN values when calculating quartiles
          goo = where(finite(maxtmpE) eq 1)
          if goo[0] ne -1 then begin
            pttmp = cgPercentiles(maxtmpE[goo],Percentiles=[0.25,0.5,0.75])
            dataspecE[ii,4,b] = pttmp[0]
            dataspecE[ii,5,b] = pttmp[1]
            dataspecE[ii,6,b] = pttmp[2]
          endif

          goo = where(finite(maxtmpB) eq 1)
          if goo[0] ne -1 then begin
            pttmp = cgPercentiles(maxtmpB[goo],Percentiles=[0.25,0.5,0.75])
            dataspecB[ii,4,b] = pttmp[0]
            dataspecB[ii,5,b] = pttmp[1]
            dataspecB[ii,6,b] = pttmp[2]
          endif



          ;---------------------------------------------------------------------
          ;Remove data values when the peak frequency is a NaN (usually at gaps)
          ;---------------------------------------------------------------------

          goo = where(finite(freqpeakE[*,b]) eq 0.)
          for q=0,ntypes-1 do dataspecE[goo,q,b] = !values.f_nan
          goo = where(finite(freqpeakB[*,b]) eq 0.)
          for q=0,ntypes-1 do dataspecB[goo,q,b] = !values.f_nan



        endfor ;b (each band)
			endif else begin
			  dataspecE[ii,*,*] = !values.f_nan
        dataspecB[ii,*,*] = !values.f_nan
			endelse	
		endfor  ;ii - each chunk



    rbsp_efw_init 
    loadct,39



	;**************************

    if testing then begin 
  	
  	;Testing: compare max determined values with spectral plot.
  		timespan,tmin[0],tmax[n_elements(tmax)-1]-tmin[0],/sec
  
  		get_data,'tmpLB_E',data=dd
  		maxspec = fltarr(n_elements(dd.x))
  		for i=0,n_elements(dd.x)-1 do maxspec[i] = max(dd.y[i,*],/nan)
  		store_data,'maxspecL',dd.x,maxspec & options,'maxspecL','psym',3
  		ylim,'maxspecL',min(maxspec,/nan),2*max(maxspec,/nan),1
  		store_data,'tstlb_tot',(tmin+tmax)/2.,dataspecE[*,0,1] 
  		store_data,'tstlb_max',(tmin+tmax)/2.,dataspecE[*,1,1] & options,'tstlb_max','colors',1
  		store_data,'tstlb_med',(tmin+tmax)/2.,dataspecE[*,2,1] & options,'tstlb_med','colors',100
  		store_data,'tstlb_avg',(tmin+tmax)/2.,dataspecE[*,3,1] & options,'tstlb_avg','colors',250
  		store_data,'fpeaklb',(tmin+tmax)/2.,freqpeakE[*,1] & options,'fpeaklb','psym',-4
  		options,'fpeaklb','colors',250
  		options,['tstlb_tot','tstlb_max','tstlb_med','tstlb_avg','fpeaklb'],'psym',-4
  		options,['tstlb_tot','tstlb_max','tstlb_med','tstlb_avg','fpeaklb'],'thick',2
      store_data,'specLcomb',data=['tmpLB_E','fces','fpeaklb'] & ylim,'specLcomb',minwavefreq,6000,1 & ylim,'specLcomb',minwavefreq,6000,1
  		options,'specLcomb','ytitle','Ew spec!Clowerband'
  		store_data,'loccombL',data=['maxspecL','tstlb_max','tstlb_med','tstlb_avg']
  		options,'loccombL','ytitle','max power!Clowerband'
  		ylim,'loccombL',min(maxspec,/nan),2*max(maxspec,/nan),1
      ylim,'EuEu_fces',minwavefreq,6000,1
  ;		ylim,'loccombL',0,max(maxspec,/nan),0
      tplot,['EuEu_fces','specLcomb','loccombL']
  	
  	stop	
  
  		get_data,'tmpUB_E',data=dd
  		maxspec = fltarr(n_elements(dd.x))
  		for i=0,n_elements(dd.x)-1 do maxspec[i] = max(dd.y[i,*],/nan)
  		store_data,'maxspecU',dd.x,maxspec & options,'maxspecU','psym',3
  		ylim,'maxspecU',min(maxspec,/nan),2*max(maxspec,/nan),1
  
  
  
  		store_data,'tstub_tot',(tmin+tmax)/2.,dataspecE[*,0,2]
  		store_data,'tstub_max',(tmin+tmax)/2.,dataspecE[*,1,2] & options,'tstub_max','colors',1
  		store_data,'tstub_med',(tmin+tmax)/2.,dataspecE[*,2,2] & options,'tstub_med','colors',100
  		store_data,'tstub_avg',(tmin+tmax)/2.,dataspecE[*,3,2] & options,'tstub_avg','colors',250
  		store_data,'fpeakub',(tmin+tmax)/2.,freqpeakE[*,2] & options,'fpeakub','psym',-4
  		options,'fpeakub','colors',250
  		options,['tstub_tot','tstub_max','tstub_med','tstub_avg','fpeakub'],'psym',-4
  		options,['tstub_tot','tstub_max','tstub_med','tstub_avg','fpeakub'],'thick',2
  		store_data,'specUcomb',data=['tmpUB_E','fces','fpeakub'] & ylim,'specUcomb',minwavefreq,6000,1
  		options,'specUcomb','ytitle','Ew spec!Cupperband'
  		store_data,'loccombU',data=['maxspecU','tstub_max','tstub_med','tstub_avg']
  		options,'loccombU','ytitle','max power!Cupperband'
  		ylim,'loccombU',min(maxspec,/nan),2*max(maxspec,/nan),1
  		ylim,'EuEu_fces',minwavefreq,6000,1
  ;		ylim,'loccombU',0,max(maxspec,/nan),0
  		tplot,['EuEu_fces','specUcomb','loccombU']
  
  	stop	
  
  		get_data,'tmpLF_E',data=dd
  		maxspec = fltarr(n_elements(dd.x))
  		for i=0,n_elements(dd.x)-1 do maxspec[i] = max(dd.y[i,*],/nan)
  		store_data,'maxspecO',dd.x,maxspec & options,'maxspecO','psym',3
  		ylim,'maxspecO',min(maxspec,/nan),2*max(maxspec,/nan),1
  		store_data,'tstlf_tot',(tmin+tmax)/2.,dataspecE[*,0,0]
  		store_data,'tstlf_max',(tmin+tmax)/2.,dataspecE[*,1,0] & options,'tstlf_max','colors',1
  		store_data,'tstlf_med',(tmin+tmax)/2.,dataspecE[*,2,0] & options,'tstlf_med','colors',100
  		store_data,'tstlf_avg',(tmin+tmax)/2.,dataspecE[*,3,0] & options,'tstlf_avg','colors',250
  		store_data,'fpeaklf',(tmin+tmax)/2.,freqpeakE[*,0] & options,'fpeaklf','psym',-4
  		options,'fpeaklf','colors',250
  		options,['tstlf_tot','tstlf_max','tstlf_med','tstlf_avg','fpeaklf'],'psym',-4
  		options,['tstlf_tot','tstlf_max','tstlf_med','tstlf_avg','fpeaklf'],'thick',2
  		store_data,'specOcomb',data=['tmpLF_E','fces','fpeaklf'] & ylim,'specOcomb',minwavefreq,6000,1
  		options,'specOcomb','ytitle','Ew spec!Clow freqs!C'+strtrim(floor(minwavefreq),2)+'Hz-fce/10'
  		store_data,'loccombO',data=['maxspecO','tstlf_max','tstlf_med','tstlf_avg']
  		options,'loccombO','ytitle','max power!Clow freqs!C'+strtrim(floor(minwavefreq),2)+'Hz-fce/10'
  		ylim,'loccombO',min(maxspec,/nan)/100.,2*max(maxspec,/nan),1
  		ylim,'EuEu_fces',minwavefreq,6000,1
  		;ylim,'loccombO',0,max(maxspec,/nan),0
  		tplot,['EuEu_fces','specOcomb','loccombO']
  
  stop
  
  		options,'loccomb?','panel_size',0.6
  		popen,'~/Desktop/'+filenamestr+'_RBSP'+probe+'_e12dc_wavepower'+'.ps'
  		!p.charsize = 0.6
  		tplot,['EuEu_fces',$
  		'specUcomb','loccombU',$
  		'specLcomb','loccombL',$
  		'specOcomb','loccombO',$
  		'lboth','mltboth','sep','dl','dmlt']
  		timebar,tconj
  ;		timebar,mb_list.time,color=250
  		pclose
  
  	
  
  	;**************************
  
  		get_data,'tmpLB_B',data=dd
  		maxspec = fltarr(n_elements(dd.x))
  		for i=0,n_elements(dd.x)-1 do maxspec[i] = max(dd.y[i,*],/nan)
  		store_data,'maxspecL',dd.x,maxspec & options,'maxspecL','psym',3
  		ylim,'maxspecL',min(maxspec,/nan),2*max(maxspec,/nan),1
  		store_data,'tstlb_tot',(tmin+tmax)/2.,dataspecB[*,0,1]
  		store_data,'tstlb_max',(tmin+tmax)/2.,dataspecB[*,1,1] & options,'tstlb_max','colors',1
  		store_data,'tstlb_med',(tmin+tmax)/2.,dataspecB[*,2,1] & options,'tstlb_med','colors',100
  		store_data,'tstlb_avg',(tmin+tmax)/2.,dataspecB[*,3,1] & options,'tstlb_avg','colors',250
  		store_data,'fpeaklb',(tmin+tmax)/2.,freqpeakB[*,1] & options,'fpeaklb','psym',-4
  		options,'fpeaklb','colors',250
  		options,['tstlb_tot','tstlb_max','tstlb_med','tstlb_avg','fpeaklb'],'psym',-4
  		options,['tstlb_tot','tstlb_max','tstlb_med','tstlb_avg','fpeaklb'],'thick',2
  		store_data,'specLcomb',data=['tmpLB_B','fces','fpeaklb'] & ylim,'specLcomb',minwavefreq,6000,1
  		options,'specLcomb','ytitle','Bw spec!Clowerband'
  		store_data,'loccombL',data=['maxspecL','tstlb_max','tstlb_med','tstlb_avg']
  		options,'loccombL','ytitle','max power!Clowerband'
  		ylim,'loccombL',min(maxspec,/nan),2*max(maxspec,/nan),1
  		ylim,'BwBw_fces',minwavefreq,6000,1
  		zlim,'tmpLB_B',1d-12,1d-5,1
  ;		ylim,'loccombL',0,max(maxspec,/nan),0
  		tplot,['BwBw_fces','specLcomb','loccombL']
  
  	stop	
  
  		get_data,'tmpUB_B',data=dd
  		maxspec = fltarr(n_elements(dd.x))
  		for i=0,n_elements(dd.x)-1 do maxspec[i] = max(dd.y[i,*],/nan)
  		store_data,'maxspecU',dd.x,maxspec & options,'maxspecU','psym',3
  		ylim,'maxspecU',min(maxspec,/nan),2*max(maxspec,/nan),1
  		store_data,'tstub_tot',(tmin+tmax)/2.,dataspecB[*,0,2]
  		store_data,'tstub_max',(tmin+tmax)/2.,dataspecB[*,1,2] & options,'tstub_max','colors',1
  		store_data,'tstub_med',(tmin+tmax)/2.,dataspecB[*,2,2] & options,'tstub_med','colors',100
  		store_data,'tstub_avg',(tmin+tmax)/2.,dataspecB[*,3,2] & options,'tstub_avg','colors',250
      store_data,'fpeakub',(tmin+tmax)/2.,freqpeakB[*,2] & options,'fpeakub','psym',-4
  		options,'fpeakub','colors',250
  		options,['tstub_tot','tstub_max','tstub_med','tstub_avg','fpeakub'],'psym',-4
  		options,['tstub_tot','tstub_max','tstub_med','tstub_avg','fpeakub'],'thick',2
  		store_data,'specUcomb',data=['tmpUB_B','fces','fpeakub'] & ylim,'specUcomb',minwavefreq,6000,1
  		options,'specUcomb','ytitle','Bw spec!Cupperband'
  		store_data,'loccombU',data=['maxspecU','tstub_max','tstub_med','tstub_avg']
  		options,'loccombU','ytitle','max power!Cupperband'
  		ylim,'loccombU',min(maxspec,/nan),2*max(maxspec,/nan),1
  		ylim,'BwBw_fces',minwavefreq,6000,1
  		zlim,'tmpUB_B',1d-12,1d-5,1
  		;ylim,'loccombU',0,max(maxspec,/nan),0
  		tplot,['BwBw_fces','specUcomb','loccombU']
  
  	stop	
  
  		get_data,'tmpLF_B',data=dd
  		maxspec = fltarr(n_elements(dd.x))
  		for i=0,n_elements(dd.x)-1 do maxspec[i] = max(dd.y[i,*],/nan)
  		store_data,'maxspecO',dd.x,maxspec & options,'maxspecO','psym',3
  		ylim,'maxspecO',min(maxspec,/nan),2*max(maxspec,/nan),1
  		store_data,'tstlf_tot',(tmin+tmax)/2.,dataspecB[*,0,0]
  		store_data,'tstlf_max',(tmin+tmax)/2.,dataspecB[*,1,0] & options,'tstlf_max','colors',1
  		store_data,'tstlf_med',(tmin+tmax)/2.,dataspecB[*,2,0] & options,'tstlf_med','colors',100
  		store_data,'tstlf_avg',(tmin+tmax)/2.,dataspecB[*,3,0] & options,'tstlf_avg','colors',250
  		store_data,'fpeaklf',(tmin+tmax)/2.,freqpeakB[*,0] & options,'fpeaklf','psym',-4
  		options,'fpeaklf','colors',250
  		options,['tstlf_tot','tstlf_max','tstlf_med','tstlf_avg','fpeaklf'],'psym',-4
  		options,['tstlf_tot','tstlf_max','tstlf_med','tstlf_avg','fpeaklf'],'thick',2
  		store_data,'specOcomb',data=['tmpLF_B','fces','fpeaklf'] & ylim,'specOcomb',minwavefreq,6000,1
  		options,'specOcomb','ytitle','Bw spec!Clow freqs!Clow freqs!C'+strtrim(floor(minwavefreq),2)+'Hz-fce/10'
  		store_data,'loccombO',data=['maxspecO','tstlf_max','tstlf_med','tstlf_avg']
  		options,'loccombO','ytitle','max power!Clow freqs!Clow freqs!C'+strtrim(floor(minwavefreq),2)+'Hz-fce/10'
  		ylim,'loccombO',min(maxspec,/nan)/100.,2*max(maxspec,/nan),1
  		ylim,'BwBw_fces',minwavefreq,6000,1
  		zlim,'tmpLF_B',1d-12,1d-5,1
  		;ylim,'loccombU',0,max(maxspec,/nan),0
  		;;		ylim,'loccombO',0,max(maxspec,/nan),0
  		tplot,['BwBw_fces','specOcomb','loccombO']
  
  	stop	
  
  		options,'loccomb?','panel_size',0.6
  		popen,'~/Desktop/'+filenamestr+'_RBSP'+probe+'_scmw_wavepower'+'.ps'
  		!p.charsize = 0.6
  		tplot,['BwBw_fces',$
  		'specUcomb','loccombU',$
  		'specLcomb','loccombL',$
  		'specOcomb','loccombO',$
  		'lboth','mltboth','sep','dl','dmlt']
  		timebar,tconj
  ;		timebar,mb_list.time,color=250
  		pclose
  
  
    endif ; testing
  
  


    ;-----------------------------------------------------------
    ;E-field and B-field filterbank: find wave statistics in various time chunks surrounding the conjunction
    ;-----------------------------------------------------------


		;Figure out if we're dealing with e12 or e34 for FBK data 
		e1234 = ''
		tstvar = tnames('fbk7_e??dc_pk')
		if tstvar ne '' then e1234 = strmid(tstvar,5,3)		
		tstvar = tnames('fbk13_e??dc_pk')
		if tstvar ne '' then e1234 = strmid(tstvar,6,3)


		;---------------------------------------------------------------
		;Find max filterbank value in various bins for FBK7 mode
		;---------------------------------------------------------------

		for ii=0d,nchunks-2 do begin 

			tmin[ii] = t0z2 + ii*tdelta
			tmax[ii] = t0z2 + (ii+1)*tdelta

			;print,time_string(tmin[ii]), ' - ', time_string(tmax[ii])
		
			fcetmp = tsample('fce_eq_interp',[tmin[ii],tmax[ii]],times=tt)


			undefine,fbktmp_7E, fbktmp_7B, fbktmp_13E, fbktmp_13B

			if tdexists('fbk7_'+e1234+'dc_pk',tmin[ii],tmax[ii]) then $
				fbktmp_7E = tsample('fbk7_'+e1234+'dc_pk',[tmin[ii],tmax[ii]])
			if tdexists('fbk7_scmw_pk',tmin[ii],tmax[ii]) then $
				fbktmp_7B = tsample('fbk7_scmw_pk',[tmin[ii],tmax[ii]])
			if tdexists('fbk13_'+e1234+'dc_pk',tmin[ii],tmax[ii]) then $
				fbktmp_13E = tsample('fbk13_'+e1234+'dc_pk',[tmin[ii],tmax[ii]])
			if tdexists('fbk13_scmw_pk',tmin[ii],tmax[ii]) then $
				fbktmp_13B = tsample('fbk13_scmw_pk',[tmin[ii],tmax[ii]])



			;Find max filterbank value in various bins for FBK7 mode
			if keyword_set(fbktmp_7E) then begin
        for ch=0,6 do fbk7E[ii,ch] = float(max(fbktmp_7E[*,ch],/nan))
			endif else for ch=0,6 do fbk7E[ii,ch] = !values.f_nan
			if keyword_set(fbktmp_7B) then begin
			  for ch=0,6 do fbk7B[ii,ch] = float(max(fbktmp_7B[*,ch],/nan))
			endif else for ch=0,6 do fbk7B[ii,ch] = !values.f_nan


			;Find max filterbank value in various bins for FBK13 mode
			if keyword_set(fbktmp_13E) then begin
			  for ch=0,12 do fbk13E[ii,ch] = float(max(fbktmp_13E[*,ch],/nan))
			endif else for ch=0,12 do fbk13E[ii,ch] = !values.f_nan
			if keyword_set(fbktmp_13B) then begin
			  for ch=0,12 do fbk13B[ii,ch] = float(max(fbktmp_13B[*,ch],/nan))
			endif else for ch=0,12 do fbk13B[ii,ch] = !values.f_nan


		endfor ;nchunks




		;****************************************************
		;Plots for testing FBK data

		if testing then begin 
			split_vec,'fbk7_'+e1234+'dc_pk'
			split_vec,'fbk7_scmw_pk'
			options,'fbk7_'+e1234+'dc_pk_?','spec',0
			options,'fbk7_scmw_pk_?','spec',0

			store_data,'fbk7_Ewmax_3',(tmin+tmax)/2.,fbk7E[*,3]
			store_data,'fbk7_Ewmax_4',(tmin+tmax)/2.,fbk7E[*,4]
			store_data,'fbk7_Ewmax_5',(tmin+tmax)/2.,fbk7E[*,5]
			store_data,'fbk7_Ewmax_6',(tmin+tmax)/2.,fbk7E[*,6]
			store_data,'fbk7_Ewmax_3_comb',data=['fbk7_'+e1234+'dc_pk_3','fbk7_Ewmax_3']
			store_data,'fbk7_Ewmax_4_comb',data=['fbk7_'+e1234+'dc_pk_4','fbk7_Ewmax_4']
			store_data,'fbk7_Ewmax_5_comb',data=['fbk7_'+e1234+'dc_pk_5','fbk7_Ewmax_5']
			store_data,'fbk7_Ewmax_6_comb',data=['fbk7_'+e1234+'dc_pk_6','fbk7_Ewmax_6']

			store_data,'fbk7_Bwmax_3',(tmin+tmax)/2.,fbk7B[*,3];*1000.
			store_data,'fbk7_Bwmax_4',(tmin+tmax)/2.,fbk7B[*,4];*1000.
			store_data,'fbk7_Bwmax_5',(tmin+tmax)/2.,fbk7B[*,5];*1000.
			store_data,'fbk7_Bwmax_6',(tmin+tmax)/2.,fbk7B[*,6];*1000.
			store_data,'fbk7_Bwmax_3_comb',data=['fbk7_scmw_pk_3','fbk7_Bwmax_3']
			store_data,'fbk7_Bwmax_4_comb',data=['fbk7_scmw_pk_4','fbk7_Bwmax_4']
			store_data,'fbk7_Bwmax_5_comb',data=['fbk7_scmw_pk_5','fbk7_Bwmax_5']
			store_data,'fbk7_Bwmax_6_comb',data=['fbk7_scmw_pk_6','fbk7_Bwmax_6']

			tplot,['fbk7_Ewmax_4_comb','fbk7_Ewmax_5_comb','fbk7_Ewmax_6_comb',$
					'fbk7_Bwmax_4_comb','fbk7_Bwmax_5_comb','fbk7_Bwmax_6_comb']
			stop

		endif




		;---------------------------------------------------
		;Normalize the frequencies to the min/max values of the entire range of fce's seen during each chunk. 
		;NOTE**** this can result in some, for example, lower band waves being outside of the lower band range. 
		;This happens most often fce is changing fairly rapidly and the time chunk is large (e.g. 10 min).
		;Another symptom is the peak in the lower band being at the same freq as the peak in the upper band. 
		;****I'VE CHECKED CAREFULLY AND THIS IS WORKING
		;---------------------------------------------------


		fceavg = (fcemin + fcemax)/2.

    f_fcemin_peakE = fltarr(nchunks-1,nbands)
    f_fcemin_peakB = fltarr(nchunks-1,nbands)
    f_fcemax_peakE = fltarr(nchunks-1,nbands)
    f_fcemax_peakB = fltarr(nchunks-1,nbands)

    for b=0,nbands-1 do f_fcemin_peakE[*,b] = freqpeakE[*,b]/fcemax
    for b=0,nbands-1 do f_fcemin_peakB[*,b] = freqpeakB[*,b]/fcemax
    for b=0,nbands-1 do f_fcemax_peakE[*,b] = freqpeakE[*,b]/fcemin
    for b=0,nbands-1 do f_fcemax_peakB[*,b] = freqpeakB[*,b]/fcemin



		;---------------------------------------------------
		;Output results to file
		;---------------------------------------------------

;		sc = strmid(fb,2,1)
;		print,currday

		result = FILE_TEST(pathoutput + 'RBSP'+probe+'_'+fb+'_conjunction_values_'+filenamestr+'.txt')


		;format statement for final output
		fmt = '(2(a16,2x),20(f7.2,2x),56(e8.2,2x),20(f6.1,2x),8(f8.0,2x),16(f5.3,2x))'




		openw,lun,pathoutput + 'RBSP'+probe+'_'+fb+'_conjunction_values_'+filenamestr+'.txt',/get_lun
		for qq=0,n_elements(tmin)-1 do begin
			printf,lun,time_string(tmin[qq])+' ',time_string(tmax[qq]), $
			Lref, MLTref, $
			lmin[qq], lmax[qq], lavg[qq], lmed[qq], $
			mltmin[qq], mltmax[qq], mltavg[qq], mltmed[qq], $
			dlmin[qq], dlmax[qq], dlavg[qq], dlmed[qq], $
			dmltmin[qq], dmltmax[qq], dmltavg[qq], dmltmed[qq], $
			sepmin[qq], sepmax[qq], $
      dataspecE[qq,0,0], dataspecE[qq,1,0], dataspecE[qq,2,0], dataspecE[qq,3,0], dataspecE[qq,4,0], dataspecE[qq,5,0], dataspecE[qq,6,0], $
      dataspecE[qq,0,1], dataspecE[qq,1,1], dataspecE[qq,2,1], dataspecE[qq,3,1], dataspecE[qq,4,1], dataspecE[qq,5,1], dataspecE[qq,6,1], $
      dataspecE[qq,0,2], dataspecE[qq,1,2], dataspecE[qq,2,2], dataspecE[qq,3,2], dataspecE[qq,4,2], dataspecE[qq,5,2], dataspecE[qq,6,2], $
      dataspecE[qq,0,3], dataspecE[qq,1,3], dataspecE[qq,2,3], dataspecE[qq,3,3], dataspecE[qq,4,3], dataspecE[qq,5,3], dataspecE[qq,6,3], $
      dataspecB[qq,0,0], dataspecB[qq,1,0], dataspecB[qq,2,0], dataspecB[qq,3,0], dataspecB[qq,4,0], dataspecB[qq,5,0], dataspecB[qq,6,0], $
      dataspecB[qq,0,1], dataspecB[qq,1,1], dataspecB[qq,2,1], dataspecB[qq,3,1], dataspecB[qq,4,1], dataspecB[qq,5,1], dataspecB[qq,6,1], $
      dataspecB[qq,0,2], dataspecB[qq,1,2], dataspecB[qq,2,2], dataspecB[qq,3,2], dataspecB[qq,4,2], dataspecB[qq,5,2], dataspecB[qq,6,2], $
      dataspecB[qq,0,3], dataspecB[qq,1,3], dataspecB[qq,2,3], dataspecB[qq,3,3], dataspecB[qq,4,3], dataspecB[qq,5,3], dataspecB[qq,6,3], $
      fbk7E[qq,3],fbk7E[qq,4],fbk7E[qq,5],fbk7E[qq,6],$
      fbk7B[qq,3],fbk7B[qq,4],fbk7B[qq,5],fbk7B[qq,6],$
      fbk13E[qq,7],fbk13E[qq,8],fbk13E[qq,9],fbk13E[qq,10],fbk13E[qq,11],fbk13E[qq,12],$
      fbk13B[qq,7],fbk13B[qq,8],fbk13B[qq,9],fbk13B[qq,10],fbk13B[qq,11],fbk13B[qq,12],$
      freqpeakE[qq,0],freqpeakE[qq,1],freqpeakE[qq,2],freqpeakE[qq,3],$
      freqpeakB[qq,0],freqpeakB[qq,1],freqpeakB[qq,2],freqpeakB[qq,3],$
			f_fcemin_peakE[qq,0], f_fcemax_peakE[qq,0], $
			f_fcemin_peakE[qq,1], f_fcemax_peakE[qq,1], $
			f_fcemin_peakE[qq,2], f_fcemax_peakE[qq,2], $
			f_fcemin_peakE[qq,3], f_fcemax_peakE[qq,3], $
			f_fcemin_peakB[qq,0], f_fcemax_peakB[qq,0], $
			f_fcemin_peakB[qq,1], f_fcemax_peakB[qq,1], $
			f_fcemin_peakB[qq,2], f_fcemax_peakB[qq,2], $
			f_fcemin_peakB[qq,3], f_fcemax_peakB[qq,3], format=fmt
		endfor 





;qq=0
;      print,time_string(tmin[qq])+' ',time_string(tmax[qq]), $
;      Lref, MLTref, $
;      lmin[qq], lmax[qq], lavg[qq], lmed[qq], $
;      mltmin[qq], mltmax[qq], mltavg[qq], mltmed[qq], $
;      dlmin[qq], dlmax[qq], dlavg[qq], dlmed[qq], $
;      dmltmin[qq], dmltmax[qq], dmltavg[qq], dmltmed[qq], $
;      sepmin[qq], sepmax[qq], $
;      dataspecE[qq,0,0], dataspecE[qq,1,0], dataspecE[qq,2,0], dataspecE[qq,3,0], dataspecE[qq,4,0], dataspecE[qq,5,0], dataspecE[qq,6,0], $
;      dataspecE[qq,0,1], dataspecE[qq,1,1], dataspecE[qq,2,1], dataspecE[qq,3,1], dataspecE[qq,4,1], dataspecE[qq,5,1], dataspecE[qq,6,1], $
;      dataspecE[qq,0,2], dataspecE[qq,1,2], dataspecE[qq,2,2], dataspecE[qq,3,2], dataspecE[qq,4,2], dataspecE[qq,5,2], dataspecE[qq,6,2], $
;      dataspecE[qq,0,3], dataspecE[qq,1,3], dataspecE[qq,2,3], dataspecE[qq,3,3], dataspecE[qq,4,3], dataspecE[qq,5,3], dataspecE[qq,6,3], $
;      dataspecB[qq,0,0], dataspecB[qq,1,0], dataspecB[qq,2,0], dataspecB[qq,3,0], dataspecB[qq,4,0], dataspecB[qq,5,0], dataspecB[qq,6,0], $
;      dataspecB[qq,0,1], dataspecB[qq,1,1], dataspecB[qq,2,1], dataspecB[qq,3,1], dataspecB[qq,4,1], dataspecB[qq,5,1], dataspecB[qq,6,1], $
;      dataspecB[qq,0,2], dataspecB[qq,1,2], dataspecB[qq,2,2], dataspecB[qq,3,2], dataspecB[qq,4,2], dataspecB[qq,5,2], dataspecB[qq,6,2], $
;      dataspecB[qq,0,3], dataspecB[qq,1,3], dataspecB[qq,2,3], dataspecB[qq,3,3], dataspecB[qq,4,3], dataspecB[qq,5,3], dataspecB[qq,6,3], $
;      fbk7E[qq,3],fbk7E[qq,4],fbk7E[qq,5],fbk7E[qq,6],$
;      fbk7B[qq,3],fbk7B[qq,4],fbk7B[qq,5],fbk7B[qq,6],$
;      fbk13E[qq,7],fbk13E[qq,8],fbk13E[qq,9],fbk13E[qq,10],fbk13E[qq,11],fbk13E[qq,12],$
;      fbk13B[qq,7],fbk13B[qq,8],fbk13B[qq,9],fbk13B[qq,10],fbk13B[qq,11],fbk13B[qq,12],$
;      freqpeakE[qq,0],freqpeakE[qq,1],freqpeakE[qq,2],freqpeakE[qq,3],$
;      freqpeakB[qq,0],freqpeakB[qq,1],freqpeakB[qq,2],freqpeakB[qq,3],$
;      f_fcemin_peakE[qq,0], f_fcemax_peakE[qq,0], $
;      f_fcemin_peakE[qq,1], f_fcemax_peakE[qq,1], $
;      f_fcemin_peakE[qq,2], f_fcemax_peakE[qq,2], $
;      f_fcemin_peakE[qq,3], f_fcemax_peakE[qq,3], $
;      f_fcemin_peakB[qq,0], f_fcemax_peakB[qq,0], $
;      f_fcemin_peakB[qq,1], f_fcemax_peakB[qq,1], $
;      f_fcemin_peakB[qq,2], f_fcemax_peakB[qq,2], $
;      f_fcemin_peakB[qq,3], f_fcemax_peakB[qq,3], format=fmt


		close,lun
		free_lun,lun
stop

	endif  ;for no missing data
endfor
end








;;**************************
;;**************************
;;Option: identify only conjunctions that contain microbursts
;NOTE: THIS IS FOR TESTIN ONLY AND
;I GENERALLY DON'T WANT TO DO THIS B/C I SHOULDN'T BE IDENTIFYING MICROBURSTS UNTIL AFTER THIS CODE IS RUN
;
;mb_list = firebird_load_shumko_microburst_list(strmid(fb,2,1))
;mbtimes = mb_list.time
;
;
;;****************************
;;TEMPORARY - ONLY ANALYZE CONJUNCTIONS THAT HAVE IDENTIFIED MICROBURSTS
;
;
;tfb0fin = tfb0
;
;
;;Make sure there is microburst at/near conjunction
;for i=0,n_elements(tfb0)-1 do begin $
; deltattmp = abs(time_double(tfb0[i]) - time_double(mbtimes)) & $
; if min(deltattmp) gt 5*60. then tfb0fin[i] = !values.f_nan
;endfor
;
;goo = where(finite(tfb0fin))
;
;tfb0 = tfb0[goo]
;tfb1 = tfb1[goo]
;t0 = t0[goo]
;t1 = t1[goo]
;vals = vals[goo,*]
;meanL = meanL[goo]
;meanMLT = meanMLT[goo]
;mindist = mindist[goo]
;strv = strv[goo]
;
;;stop
;;**************************
;;**************************


