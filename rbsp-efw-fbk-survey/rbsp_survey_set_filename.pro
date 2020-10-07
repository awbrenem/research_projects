;Set the filename in the info structure for each filterbank survey ascii file
;Ignores if already set

;Aaron W Breneman  2013-08-20

;input:    info -> info array 

;keyword:  ephem -> set if naming an ephemeris file rather than a FBK data file
;		   ampdist -> set if naming an amplitude distribution file rather than a FBK data file
;		   freqdist -> set if naming a freq distibution file
;		   hsk ->  set if naming a HSK file
;		   norename -> don't rename file if it already exists. Set this keyword 
;					in the "...read_ascii" routines but not in the "...create_ascii" ones


pro rbsp_survey_set_filename,info,ephem=ephem,ampdist=ampdist,freqdist=freqdist,hsk=hsk,norename=norename

	rbspx = 'rbsp' + info.probe


	;Extract number of days
	ndays = floor((time_double(info.d1) - time_double(info.d0))/86400) + 1.
	if ~tag_exist(info,'ndays') then str_element,info,'ndays',ndays,/ADD_REPLACE

	;Add actual days to structure
	days = time_string(indgen(info.ndays)*86400. + time_double(info.d0))
	days = strmid(days,0,10)
	if ~tag_exist(info,'days') then str_element,info,'days',days,/ADD_REPLACE

	


	;Extract and format the dates
	d0tmp = strmid(info.d0,0,4)+strmid(info.d0,5,2)+strmid(info.d0,8,2)
	d1tmp = strmid(info.d1,0,4)+strmid(info.d1,5,2)+strmid(info.d1,8,2)



	;Extract and format the peak and average amplitude thresholds
	if info.fbk_type eq 'Ew' then begin
		a0 = strtrim(floor(info.minamp_pk),2)
		a1 = strtrim(floor(info.maxamp_pk),2)
		if double(a1) gt 1000d then a1 = 'inf'
		b0 = strtrim(string(info.minamp_av,format='(f3.1)'),2)
		b1 = strtrim(floor(info.maxamp_av),2)
		if double(b1) gt 1000d then b1 = 'inf'
	endif
	;Change Bw to pT for the filename
	if info.fbk_type eq 'Bw' then begin
		a0 = strtrim(floor(1000.*info.minamp_pk),2)
		a1 = strtrim(floor(1000.*info.maxamp_pk),2)
		if double(a1) gt 1000d then a1 = 'inf'
		b0 = strtrim(string(1000.*info.minamp_av,format='(f3.1)'),2)
		b1 = strtrim(floor(1000.*info.maxamp_av),2)
		if double(b1) gt 1000d then b1 = 'inf'
	endif
	
	f0 = string(info.minfreq,format='(F4.2)')
	f1 = string(info.maxfreq,format='(F4.2)')


	;Determine the units
	if info.fbk_type eq 'Ew' then str_element,info,'units','mVm',/add_replace
	if info.fbk_type eq 'Bw' then str_element,info,'units','pT',/add_replace




	;Add the filename to info structure
	if ~keyword_set(ephem) and ~keyword_set(ampdist) and ~keyword_set(freqdist) and ~keyword_set(hsk) then begin
		str_element,info,'filename',$
			rbspx + $												;rbspa
			'_fbk'+ info.fbk_mode + $								;fbk13
			'_' + info.fbk_type + '_' + $							;Ew or Bw
			'pk>'+a0+'_and_pk<'+a1 + '_' + $						;pk>x_and_pk<y
			'av>'+b0+'_and_av<'+b1 + '_' + $						;av>x_and_av<y
			'fmin='+f0+'fce'+'_and_fmax='+f1+'fce' + '_' + $		;fmin=0.1fce_and_fmax=1.00fce	
			info.units + $											;mV/m or nT
			'_each_' + strtrim(floor(info.dt),2) + 'sec_' + $		;each_60_sec
			'from_' + d0tmp + '_' + d1tmp + '.txt',/ADD_REPLACE		;from_20121013_20121113
	endif
	if keyword_set(ephem) then begin	
		str_element,info,'filename_ephem',$
			rbspx + '_' + $
			'ephem_' + $
			strtrim(floor(info.dt),2) + 'sec_' + $ 
			d0tmp + '_' + d1tmp + $
			'.txt',/ADD_REPLACE
	endif
	if keyword_set(ampdist) then begin	
	
		;peak values file
		str_element,info,'filename_ampdist',$
			rbspx + $												;rbspa
			'_fbk'+ info.fbk_mode + $								;fbk13
			'_' + info.fbk_type + '_' + $							;Ew or Bw
			'fmin='+f0+'fce'+'_and_fmax='+f1+'fce' + '_' + $		;fmin=0.1fce_and_fmax=1.00fce	
			info.units + $											;mV/m or nT
			'_each_' + strtrim(floor(info.dt),2) + 'sec_' + $		;each_60_sec
			'from_' + d0tmp + '_' + d1tmp + '_ampdist.txt',/ADD_REPLACE		;from_20121013_20121113

		;average values (1/8s) file
		str_element,info,'filename_ampdist_avg',$
			rbspx + $												;rbspa
			'_fbk'+ info.fbk_mode + $								;fbk13
			'_' + info.fbk_type + '_' + $							;Ew or Bw
			'fmin='+f0+'fce'+'_and_fmax='+f1+'fce' + '_' + $		;fmin=0.1fce_and_fmax=1.00fce	
			info.units + $											;mV/m or nT
			'_each_' + strtrim(floor(info.dt),2) + 'sec_' + $		;each_60_sec
			'from_' + d0tmp + '_' + d1tmp + '_ampdist_avg.txt',/ADD_REPLACE		;from_20121013_20121113

		;average values (4s) file
		str_element,info,'filename_ampdist_avg4s',$
			rbspx + $												;rbspa
			'_fbk'+ info.fbk_mode + $								;fbk13
			'_' + info.fbk_type + '_' + $							;Ew or Bw
			'fmin='+f0+'fce'+'_and_fmax='+f1+'fce' + '_' + $		;fmin=0.1fce_and_fmax=1.00fce	
			info.units + $											;mV/m or nT
			'_each_' + strtrim(floor(info.dt),2) + 'sec_' + $		;each_60_sec
			'from_' + d0tmp + '_' + d1tmp + '_ampdist_avg4s.txt',/ADD_REPLACE		;from_20121013_20121113


		;peak/average ratio file (using 1/8s averages)
		str_element,info,'filename_ampdist_ratio',$
			rbspx + $												;rbspa
			'_fbk'+ info.fbk_mode + $								;fbk13
			'_' + info.fbk_type + '_' + $							;Ew or Bw
			'fmin='+f0+'fce'+'_and_fmax='+f1+'fce' + '_' + $		;fmin=0.1fce_and_fmax=1.00fce	
			info.units + $											;mV/m or nT
			'_each_' + strtrim(floor(info.dt),2) + 'sec_' + $		;each_60_sec
			'from_' + d0tmp + '_' + d1tmp + '_ampdist_ratio.txt',/ADD_REPLACE		;from_20121013_20121113

		;peak/average ratio file (using 4s averages)
		str_element,info,'filename_ampdist_ratio4s',$
			rbspx + $												;rbspa
			'_fbk'+ info.fbk_mode + $								;fbk13
			'_' + info.fbk_type + '_' + $							;Ew or Bw
			'fmin='+f0+'fce'+'_and_fmax='+f1+'fce' + '_' + $		;fmin=0.1fce_and_fmax=1.00fce	
			info.units + $											;mV/m or nT
			'_each_' + strtrim(floor(info.dt),2) + 'sec_' + $		;each_60_sec
			'from_' + d0tmp + '_' + d1tmp + '_ampdist_ratio4s.txt',/ADD_REPLACE		;from_20121013_20121113


	endif
	if keyword_set(freqdist) then begin	
		str_element,info,'filename_freqdist',$
			rbspx + $												;rbspa
			'_fbk'+ info.fbk_mode + $								;fbk13
			'_' + info.fbk_type + '_' + $							;Ew or Bw
			'pk>'+a0+'_and_pk<'+a1 + '_' + $						;pk>x_and_pk<y
			'av>'+b0+'_and_av<'+b1 + '_' + $						;av>x_and_av<y
			'fmin='+f0+'fce'+'_and_fmax='+f1+'fce' + '_' + $		;fmin=0.1fce_and_fmax=1.00fce	
			info.units + $											;mV/m or nT
			'_each_' + strtrim(floor(info.dt),2) + 'sec_' + $		;each_60_sec
			'from_' + d0tmp + '_' + d1tmp + '_freqdist.txt',/ADD_REPLACE		;from_20121013_20121113
	endif
	if keyword_set(hsk) then begin	
		str_element,info,'filename_hsk',$
			rbspx + '_' + $
			'hsk_' + $
			strtrim(floor(info.dt),2) + 'sec_' + $ 
			d0tmp + '_' + d1tmp + $
			'.txt',/ADD_REPLACE
	endif
	



	;Add path info 
	if ~tag_exist(info,'path') then str_element,info,$
		'path','~/Desktop/code/Aaron/datafiles/rbsp/survey_data/',/add_replace



	if ~keyword_set(norename) then begin
		;Check to see if file already exists. If so, then add suffix so that new file
		;does not append onto old one
		if ~keyword_set(ephem) and ~keyword_set(ampdist) and ~keyword_set(freqdist) and ~keyword_set(hsk) then fn = info.path + info.filename 
		if keyword_set(ephem) then fn = info.path + info.filename_ephem 
		if keyword_set(ampdist) then fn = info.path + [info.filename_ampdist,info.filename_ampdist_avg,info.filename_ampdist_avg4s,info.filename_ampdist_ratio,info.filename_ampdist_ratio4s]
;		if keyword_set(ampdist) then fn = info.path + info.filename_ampdist_avg
;		if keyword_set(ampdist) then fn = info.path + info.filename_ampdist_avg4s
;		if keyword_set(ampdist) then fn = info.path + info.filename_ampdist_ratio
;		if keyword_set(ampdist) then fn = info.path + info.filename_ampdist_ratio4s
		if keyword_set(freqdist) then fn = info.path + info.filename_freqdist
		if keyword_set(hsk) then fn = info.path + info.filename_hsk
		file_exists = file_info(fn)
		
		for qq=0,n_elements(fn)-1 do begin
			if file_exists[qq].exists then file_move,fn[qq],fn[qq] + '_RENAMED_BY_RBSP_SURVEY_SET_FILENAME_' + systime() 
		endfor
	endif

end
