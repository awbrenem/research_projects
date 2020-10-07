;Reads the ASCII file outputted by rbsp_survey_fbk_create_ascii.pro
;Creates tplot variables of the data
;To plot these values see rbsp_survey_fbk_crib

;Note: must have called one of the data reader programs first (like rbsp_survey_fbk_read_ascii.pro)
;These programs will populate the info structure with necessary data.

;Aaron Breneman
;2013-01-12





pro rbsp_survey_vxb_read_ascii,info



	rbspx = 'rbsp' + info.probe


;	if ~tag_exist(info,'path') then str_element,info,$
;		'path','~/Desktop/code/Aaron/datafiles/rbsp/survey_data/',/add_replace
;
;	if ~tag_exist(info,'ndays') then begin
;		ndays = floor((time_double(info.d1) - time_double(info.d0))/86400) + 1.
;		str_element,info,'ndays',ndays,/ADD_REPLACE
;	endif



;	d0tmp = strmid(info.d0,0,4)+strmid(info.d0,5,2)+strmid(info.d0,8,2)
;	d1tmp = strmid(info.d1,0,4)+strmid(info.d1,5,2)+strmid(info.d1,8,2)


;	if ~tag_exist(info,'filename') then str_element,info,'filename',$
;		rbspx + '_vxb_'+strtrim(floor(info.dt),2)+'sec'+'_'+d0tmp+'_'+d1tmp+'.txt',/ADD_REPLACE

	rbsp_survey_set_filename,info,'vxb',/norename






	data = read_ascii(info.path + info.filename)


	times = reform(data.field01[0,*])

	str_element,info,'times',times,/add_replace	
	vxb_x = reform(data.field01[1,*])
	vxb_y = reform(data.field01[2,*])
	vxb_z = reform(data.field01[3,*])

	Ex = reform(data.field01[4,*])
	Ey = reform(data.field01[5,*])
	Ez = reform(data.field01[6,*])

	Bx = reform(data.field01[7,*])
	By = reform(data.field01[8,*])
	Bz = reform(data.field01[9,*])



	store_data,'vxb',data={x:times,y:[[vxb_x],[vxb_y],[vxb_z]]}
	store_data,'Esvy',data={x:times,y:[[Ex],[Ey],[Ez]]}
	store_data,'Bsvy',data={x:times,y:[[Bx],[By],[Bz]]}


	
	options,'vxb','ytitle','vxB!C'+strtrim(floor(info.dt),2)+' !Csec avg'
	options,'Esvy','ytitle','Esvy!C'+strtrim(floor(info.dt),2)+' !Csec avg'
	options,'Bsvy','ytitle','Bsvy!C'+strtrim(floor(info.dt),2)+' !Csec avg'


	options,['vxb','Esvy','Bsvy'],'labels',rbspx
	


end