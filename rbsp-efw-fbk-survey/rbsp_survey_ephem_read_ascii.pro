;Read the ASCII files created by the program
;rbsp_survey_create_ephem_ascii.pro
;Saves data as tplot files

;Written by Aaron Breneman
;2013-01-12



pro rbsp_survey_ephem_read_ascii,info


	rbspx = 'rbsp' + info.probe

	rbsp_survey_set_filename,info,/ephem,/norename


	fn = ['time','bo','beq','lstar','lshell','lshell_dipole','mlat','radius','mlt','mlt_dipole',$
		  'gsmx','gsmy','gsmz','gsex','gsey','gsez','smx','smy','smz',$
		  'ae','dst',$
		  'spinaxisx','spinaxisy','spinaxisz']
	fl = [0,14,22,30,37,44,50,58,65,73,80,89,98,104,113,121,128,137,144,152,158,164,172,180]
	ft = [3,3,3,4,4,4,4,4,4,4,3,3,3,3,3,3,3,3,3,3,3,4,4,4]	

	t = {version:1.,$
		datastart:0L,$
		delimiter:32B,$
		missingvalue:!values.f_nan,$
		commentsymbol:'',$
		fieldcount:24L,$
		fieldtypes:ft,$
		fieldnames:fn,$
		fieldlocations:fl,$
		fieldgroups:indgen(24)}

	d = read_ascii(info.path + info.filename_ephem,template=t)
	
	times = info.timesc


	store_data,rbspx+'_fce_ect',data={x:info.timesc,y:28.*d.bo}
	store_data,rbspx+'_fce_eq_ect',data={x:info.timesc,y:28.*d.beq}
	store_data,rbspx+'_mlt_ect',data={x:info.timesc,y:d.mlt}
	store_data,rbspx+'_mlt',data={x:info.timesc,y:d.mlt_dipole}
	store_data,rbspx+'_lstar_ect',data={x:info.timesc,y:d.lstar}
	store_data,rbspx+'_lshell_ect',data={x:info.timesc,y:d.lshell}
	store_data,rbspx+'_lshell',data={x:info.timesc,y:d.lshell_dipole}
	store_data,rbspx+'_mlat',data={x:info.timesc,y:d.mlat}
	store_data,rbspx+'_radius',data={x:info.timesc,y:d.radius}
	store_data,rbspx+'_ae',data={x:info.timesc,y:d.ae}
	store_data,rbspx+'_dst',data={x:info.timesc,y:d.dst}
	store_data,rbspx+'_pos_gsm',data={x:info.timesc,y:[[d.gsmx],[d.gsmy],[d.gsmz]]}
	store_data,rbspx+'_pos_gse',data={x:info.timesc,y:[[d.gsex],[d.gsey],[d.gsez]]}
	store_data,rbspx+'_pos_sm',data={x:info.timesc,y:[[d.smx],[d.smy],[d.smz]]}
	store_data,rbspx+'_spinaxis_gse',data={x:info.timesc,y:[[d.spinaxisx],[d.spinaxisy],[d.spinaxisz]]}




	;Create the tplot variable that shows the precession of the orbit in MLT
	get_data,rbspx+'_mlt_ect',data=mlt
	get_data,rbspx+'_radius',data=rad

	goo = where(rad.y ge 5.5)
	mltgood = mlt.y[goo]
	store_data,rbspx+'_mlt_apogee',data={x:mlt.x[goo],y:mltgood}
	options,rbspx+'_mlt_apogee','psym',4
	
	



	options,rbspx+'_'+['fce_ect','fce_eq_ect','mlt_ect','mlt','lstar_ect','lshell_ect','lshell','mlat','radius',$
					'ae','dst','pos_gsm','pos_gse','pos_sm','spinaxis_gse','_mlt_apogee'],'labels',rbspx


	
end

