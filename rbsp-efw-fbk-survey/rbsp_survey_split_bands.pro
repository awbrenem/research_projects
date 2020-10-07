

;Keywords: 
	;lb_low -> lower freq limit for lower band chorus (lb_low*fce_eq) 
	;lb_high-> upper freq limit for lower band chorus (lb_high*fce_eq) 
	;ub_low -> lower freq limit for upper band chorus (ub_low*fce_eq) 
	;ub_high-> upper freq limit for upper band chorus (ub_high*fce_eq) 


;Written by Aaron W Breneman 03/12/2013



;CURRENT TESTING
;---I've set the threshold amplitude to 0 mV/m and the return results indicate that each
;	freq in each sector has a 100% duty cycle which is good! This may not be true for
;	the upper and lower band though. LOOK INTO THIS!!!



pro rbsp_survey_split_bands,info,lb_low=lblow,lb_high=lbhigh,ub_low=ublow,ub_high=ubhigh


	if ~keyword_set(lblow) then lblow = 0.1
	if ~keyword_set(lbhigh) then lbhigh = 0.4
	if ~keyword_set(ublow) then ublow = 0.6
	if ~keyword_set(ubhigh) then ubhigh = 0.9
	if ~keyword_set(padding) then padding = 0.9

	loadct,39
	!p.charsize = 1.5


	get_data,'fbk_pk',data=pk
	get_data,'fbk_av',data=av
	get_data,'fbk_npk',data=npk
	get_data,'fbk_nav',data=nav
	get_data,'radius',data=radius
	get_data,'mlt',data=mlt
	get_data,'lshell',data=lshell
	get_data,'mlat',data=mlat
	get_data,'fce_eq',data=fce_eq



	;Separate values into upper and lower band chorus
	pk_banded = fltarr(n_elements(pk.x),2)
	av_banded = fltarr(n_elements(av.x),2)
	

	
	freq_pk_actual = fltarr(n_elements(pk.x))  ;"exact" peak freq of the top four FBK bins each dt
	freq_av_actual = fltarr(n_elements(av.x))  ;"exact" peak freq of the top four FBK bins each dt
	pk_banded_vals = fltarr(n_elements(pk.x))		
	av_banded_vals = fltarr(n_elements(av.x))		

	;stop
	
	for i=0L,n_elements(pk.x)-1 do begin
		
		;Find what freq bin the max value occurs in
		mvpk = max(pk.y[i,*],whpk,/nan)
		mvav = max(av.y[i,*],whav,/nan)



		if info.fbk_mode eq '13' then begin
			;Find value in adjacent bins
			if (whpk-1) ge 0 then mvLpk = pk.y[i,whpk-1] else mvLpk = 0
			if (whpk+1) le 3 then mvHpk = pk.y[i,whpk+1] else mvHpk = 0

			if (whav-1) ge 0 then mvLav = av.y[i,whav-1] else mvLav = 0
			if (whav+1) le 3 then mvHav = av.y[i,whav+1] else mvHav = 0
		endif

		if info.fbk_mode eq '7' then begin
			if (whpk-1) ge 0 then mvLpk = pk.y[i,whpk-1] else mvLpk = 0
			if (whpk+1) le 2 then mvHpk = pk.y[i,whpk+1] else mvHpk = 0

			if (whav-1) ge 0 then mvLav = av.y[i,whav-1] else mvLav = 0
			if (whav+1) le 2 then mvHav = av.y[i,whav+1] else mvHav = 0
		endif

			
		;Interpolate using FBK gain curves to find more exact frequency.
	
		
	
		if info.fbk_mode eq '13' then begin
			bin = 9 + whpk + 1
			freq_pk_actual[i] = rbsp_efw_fbk_freq_interpolate(bin,mvpk,mvLpk,mvHpk,/noplot)
			pk_banded_vals[i] = mvpk
			bin = 9 + whav + 1
			freq_av_actual[i] = rbsp_efw_fbk_freq_interpolate(bin,mvav,mvLav,mvHav,/noplot)
			av_banded_vals[i] = mvav
		endif

		if info.fbk_mode eq '7' then begin
			if info.fbk_type eq 'Ew' then begin
				bin = 10 + whpk + 1
				freq_pk_actual[i] = rbsp_efw_fbk_freq_interpolate(bin,mvpk,mvLpk,mvHpk,/noplot)
				pk_banded_vals[i] = mvpk
				bin = 10 + whav + 1
				freq_av_actual[i] = rbsp_efw_fbk_freq_interpolate(bin,mvav,mvLav,mvHav,/noplot)
				av_banded_vals[i] = mvav
			endif
			if info.fbk_type eq 'Bw' then begin
				bin = 3 + whpk + 1
				freq_pk_actual[i] = rbsp_efw_fbk_freq_interpolate(bin,mvpk,mvLpk,mvHpk,/noplot)
				pk_banded_vals[i] = mvpk
				bin = 3 + whav + 1
				freq_av_actual[i] = rbsp_efw_fbk_freq_interpolate(bin,mvav,mvLav,mvHav,/noplot)
				av_banded_vals[i] = mvav
			endif
		endif
	endfor


	;Now separate into lower and upper band					
	
	lb_pk_bool = (freq_pk_actual le lbhigh*fce_eq.y) and (freq_pk_actual ge lblow*fce_eq.y)
	ub_pk_bool = (freq_pk_actual ge ublow*fce_eq.y) and (freq_pk_actual le ubhigh*fce_eq.y)
	lb_av_bool = (freq_av_actual le lbhigh*fce_eq.y) and (freq_av_actual ge lblow*fce_eq.y)
	ub_av_bool = (freq_av_actual ge ublow*fce_eq.y) and (freq_av_actual le ubhigh*fce_eq.y)



	pk_banded[*,0] = pk_banded_vals * lb_pk_bool
	pk_banded[*,1] = pk_banded_vals * ub_pk_bool
	av_banded[*,0] = av_banded_vals * lb_av_bool
	av_banded[*,1] = av_banded_vals * ub_av_bool

	chorus_limits = {lb_low:string(lblow,format='(F3.1)')+'*fce_eq',$
					 lb_high:string(lbhigh,format='(F3.1)')+'*fce_eq',$
					 up_low:string(ublow,format='(F3.1)')+'*fce_eq',$
					 up_high:string(ubhigh,format='(F3.1)')+'*fce_eq'}


	str_element,info,'chorus_limits',chorus_limits,/add_replace




	;What do we have at this point?
	;pk_banded -> max amplitude for lower [*,0] upper [*,1] band chorus
	;freq_actual -> interpolated frqeuencies using FBK gain curves


	store_data,'pk_lowerband',data={x:pk.x,y:pk_banded[*,0]}
	store_data,'pk_upperband',data={x:pk.x,y:pk_banded[*,1]}
	store_data,'av_lowerband',data={x:av.x,y:av_banded[*,0]}
	store_data,'av_upperband',data={x:av.x,y:av_banded[*,1]}
	store_data,'pk_lb_ub',data=['pk_lowerband','pk_upperband']
	store_data,'av_lb_ub',data=['av_lowerband','av_upperband']
	store_data,'freq_pk_actual',data={x:pk.x,y:freq_pk_actual}
	store_data,'freq_av_actual',data={x:pk.x,y:freq_av_actual}


	tplot,['pk_lb_ub','pk_lowerband','pk_upperband']
	tplot,['av_lb_ub','av_lowerband','av_upperband']
	options,'pk_lb_ub','colors',[1,4]
	options,'av_lb_ub','colors',[1,4]

	
	store_data,'fce_eq_2',data={x:pk.x,y:fce_eq.y/2.}
	store_data,'freq_compare',data=['fce_eq_2','freq_pk_actual']

	
	if info.fbk_type eq 'Ew' then ylim,['fce_eq_2','freq_pk_actual'],0,5000.
	if info.fbk_type eq 'Bw' then ylim,['fce_eq_2','freq_pk_actual'],0,100.
	tplot,['fce_eq_2','freq_pk_actual','pk_upperband','pk_lowerband']
	
	
	
end
