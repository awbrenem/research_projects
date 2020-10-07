;Reads the ASCII file outputted by rbsp_survey_fbk_maxvals_create_ascii.pro
;Creates tplot variables of the data
;To plot these values see rbsp_survey_fbk_crib


;Aaron Breneman
;2013-01-12



pro rbsp_survey_fbk_maxvals_read_ascii,info


	rbspx = 'rbsp' + info.probe

	rbsp_survey_set_filename,info,'max_over_pk',/norename


	if info.fbk_mode eq '13' then begin

		fn = ['timesb','timese','pk1','pk2','pk3','pk4','pk5','pk6','pk7','pk8',$
					'pk9','pk10','pk11','pk12','pk13','av1','av2','av3','av4','av5',$
					'av6','av7','av8','av9','av10','av11','av12','av13','fce']

		fl = [0,15,30,40,50,60,70,80,90,100,110,120,130,140,150,160,170,180,190,$
					200,210,220,230,240,250,260,270,280,293]

		ft = replicate(4,29)
		ft[0:1] = 14   ;make sure the times read in as 64 bit longs


		t = {version:1.,$
			datastart:0L,$
			delimiter:32B,$
			missingvalue:!values.f_nan,$
			commentsymbol:'',$
			fieldcount:29L,$
			fieldtypes:ft,$
			fieldnames:fn,$
			fieldlocations:fl,$
			fieldgroups:indgen(29)}


		d = read_ascii(info.path + info.filename,template=t)



		fbk_pk = [[d.pk1],[d.pk2],[d.pk3],[d.pk4],[d.pk5],[d.pk6],[d.pk7],$
							[d.pk8],[d.pk9],[d.pk10],[d.pk11],[d.pk12],[d.pk13]]
		fbk_av = [[d.av1],[d.av2],[d.av3],[d.av4],[d.av5],[d.av6],[d.av7],$
							[d.av8],[d.av9],[d.av10],[d.av11],[d.av12],[d.av13]]

		times = (d.timesb + d.timese)/2    ;middle time

	endif




	if info.fbk_mode eq '7' then begin
		fn = ['timesb','timese','pk1','pk2','pk3','pk4','pk5','pk6','pk7',$
				'av1','av2','av3','av4','av5','av6','av7','pk_top4','av_top4','fce']

		;THIS IS WRONG!!!!
		fl = [0,15,30,40,50,60,70,80,90,100,110,120,130,140,150,160,170,180,190]

		ft = replicate(4,19)
		ft[0:1] = 14   ;make sure the times read in as 64 bit longs


		;THIS IS WRONG!!!
		t = {version:1.,$
			datastart:0L,$
			delimiter:32B,$
			missingvalue:!values.f_nan,$
			commentsymbol:'',$
			fieldcount:19L,$
			fieldtypes:ft,$
			fieldnames:fn,$
			fieldlocations:fl,$
			fieldgroups:indgen(19)}


		d = read_ascii(info.path + info.filename,template=t)

		fbk_pk = [[d.pk1],[d.pk2],[d.pk3],[d.pk4],[d.pk5],[d.pk6],[d.pk7]]
		fbk_av = [[d.av1],[d.av2],[d.av3],[d.av4],[d.av5],[d.av6],[d.av7]]


		fbk_pk_topfew = d.pk_topfew
		fbk_av_topfew = d.av_topfew

		times = (d.timesb + d.timese)/2    ;middle time
	endif







	;add the times to the structure
	str_element,info,'timesb',d.timesb,/add_replace
	str_element,info,'timese',d.timese,/add_replace
	str_element,info,'times',times,/add_replace


	store_data,'fbk_pk',data={x:d.timesb,y:fbk_pk}
	store_data,'fbk_av',data={x:d.timesb,y:fbk_av}

	store_data,'fce',data={x:d.timesb,y:d.fce}

	options,'fbk_pk','ytitle','FBK pk!C'+strtrim(floor(info.dt),2)+' !Csec max'
	options,'fbk_av','ytitle','FBK av!C'+strtrim(floor(info.dt),2)+' !Csec max'

	options,['fbk_pk','fbk_av'],'labels',rbspx

end
