;Save an ASCII file of max and min FBK data in each timechunk dt
;from days d0 to d1


;Called from rbsp_survey_fbk_crib

;Example input structure:
		;info = {probe:'a',$
		;	   d0:'2012-10-13',$
		;	   d1:'2012-10-16',$
		;	   dt:60.}

;Aaron Breneman
;2013-01-12
;Changes
;	2013-03-07 - loads EMFISIS data and stores fce


pro rbsp_survey_fbk_maxvals_create_ascii,info


	if ~tag_exist(info,'path') then str_element,info,$
		'path','~/Desktop/code/Aaron/datafiles/rbsp/survey_data/',/add_replace

	ndays = floor((time_double(info.d1) - time_double(info.d0))/86400) + 1.
	if ~tag_exist(info,'ndays') then str_element,info,'ndays',ndays,/ADD_REPLACE


	days = time_string(indgen(info.ndays)*86400. + time_double(info.d0))
	days = strmid(days,0,10)



	store_data,'*fbk*',/delete

	rbspx = 'rbsp' + info.probe

	d0tmp = strmid(info.d0,0,4)+strmid(info.d0,5,2)+strmid(info.d0,8,2)
	d1tmp = strmid(info.d1,0,4)+strmid(info.d1,5,2)+strmid(info.d1,8,2)


	if ~tag_exist(info,'filename') then str_element,info,'filename',$
		rbspx + '_fbk_max_pkav_'+strtrim(floor(info.dt),2)+'sec'+'_'+d0tmp+'_'+d1tmp+'.txt',/ADD_REPLACE




	for dd=0,n_elements(days)-1 do begin


		store_data,'*fbk*',/delete

		date = days[dd]
		timespan,date



		rbsp_load_efw_fbk,probe=info.probe,type='calibrated'
		rbsp_load_emfisis,probe=info.probe,coord='gse',cadence='4sec',level='l3'  

		get_data,rbspx+'_emfisis_l3_4sec_gse_Magnitude',data=mag
		

		get_data,rbspx+'_efw_fbk_13_fb1_av',data=av
		get_data,rbspx+'_efw_fbk_13_fb1_pk',data=pk

		if is_struct(pk) then begin
	
	
			;number of times with timestep dt
			ntimes = floor((max(pk.x,/nan) - min(pk.x,/nan))/info.dt)
	
			t0 = pk.x[0]
			t1 = pk.x[0] + info.dt
	
			peaks = fltarr(ntimes,13)
			avgs = fltarr(ntimes,13)
			timesb = dblarr(ntimes)   ;time at beginning of bin
			timese = dblarr(ntimes)	  ;time at end of bin
			fce = fltarr(ntimes)



	
			for i=0d,ntimes-1 do begin
	
				;All data in timechunk dt
				goo = where((pk.x ge t0) and (pk.x le t1))
		
				if goo[0] ne -1 then begin

					for n=0,12 do peaks[i,n] = max(pk.y[goo,n])
					for n=0,12 do avgs[i,n] = max(av.y[goo,n])


					timesb[i] = pk.x[goo[0]]
					timese[i] = pk.x[goo[n_elements(goo)-1]]
				endif

				boo = where((mag.x ge t0) and (mag.x le t1))
				;Find the average fce for all the times b/t t0 and t1
				
				if boo[0] ne -1 then fce[i] = 28.*average(mag.y[boo])				
					
									
				t0 = t0 + info.dt
				t1 = t1 + info.dt
				
			endfor
	
	
	
			openw,lun,info.path + info.filename,/get_lun,/append
				for zz=0L,ntimes-1 do printf,lun,format='(I10,5x,I10,26f10.3,5x,f8.0)',$
					timesb[zz],timese[zz],peaks[zz,0],peaks[zz,1],peaks[zz,2],peaks[zz,3],$
					peaks[zz,4],peaks[zz,5],peaks[zz,6],peaks[zz,7],peaks[zz,8],$
					peaks[zz,9],peaks[zz,10],peaks[zz,11],peaks[zz,12],avgs[zz,0],$
					avgs[zz,1],avgs[zz,2],avgs[zz,3],avgs[zz,4],avgs[zz,5],avgs[zz,6],$
					avgs[zz,7],avgs[zz,8],avgs[zz,9],avgs[zz,10],avgs[zz,11],avgs[zz,12],$
					fce[zz]
			free_lun,lun
		
	
			store_data,'*fbk*',/delete
	
		endif

	endfor

close,lun

end
