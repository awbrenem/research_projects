;Reads the ASCII file outputted by rbsp_survey_fbk_create_ascii.pro
;Creates tplot variables of the data
;To plot these values see rbsp_survey_fbk_crib


;Aaron Breneman
;2013-01-12





pro rbsp_survey_fbk_read_ascii,info


	rbspx = 'rbsp' + info.probe


	rbsp_survey_set_filename,info,'downsampled_to_dt',/norename


	data = read_ascii(info.path + info.filename)

	times = reform(data.field1[0,*])
	fbk_pk = reform(data.field1[1,*])
	fbk_av = reform(data.field1[2,*])


	;add the times to the structure
	str_element,info,'times',times,/add_replace


	store_data,'fbk_pk',data={x:times,y:fbk_pk}
	store_data,'fbk_av',data={x:times,y:fbk_av}
	
	options,'fbk_pk','ytitle','FBK pk!C'+strtrim(floor(info.dt),2)+' !Csec avg'
	options,'fbk_av','ytitle','FBK av!C'+strtrim(floor(info.dt),2)+' !Csec avg'

	options,['fbk_pk','fbk_av'],'labels',rbspx
	


end