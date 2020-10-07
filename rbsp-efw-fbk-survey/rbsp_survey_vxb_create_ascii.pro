;Save an ASCII file of Esvy (vxB subtracted) and Bsvy data for x number of days.
;Used for loading long durations of RBSP data
;Called from rbsp_survey_vxb_crib

;Example input structure:
;		info = {probe:'a',$
;			   d0:'2012-10-13',$
;			   d1:'2012-10-16',$
;			   dt:60.}

;Aaron Breneman
;2013-01-12



pro rbsp_survey_vxb_create_ascii,info


	store_data,'*vxb*',/delete

	rbspx = 'rbsp' + info.probe
	rbsp_survey_set_filename,info,'vxb'


	for i=0,info.ndays-1 do begin

		date = info.days[i]
		timespan,date


		rbsp_efw_spinfit_vxb_subtract_crib,info.probe,/no_spice_load,/noplot
		;right now this only uses EMFISIS quicklook data


		;Load EMFISIS data L3 data
		rbsp_load_emfisis,probe=info.probe,coord='gse',cadence='4sec'



		;Transform the data to MGSE coordinates
		get_data,rbspx+'_emfisis_l3_4sec_gse_Mag',data=tmpp
		get_data,rbspx+'_spinaxis_direction_gse',data=wsc_GSE	
		wsc_GSE_tmp = [[interpol(wsc_GSE.y[*,0],wsc_GSE.x,tmpp.x)],$
					   [interpol(wsc_GSE.y[*,1],wsc_GSE.x,tmpp.x)],$
					   [interpol(wsc_GSE.y[*,2],wsc_GSE.x,tmpp.x)]]
		rbsp_gse2mgse,rbspx+'_emfisis_l3_4sec_gse_Mag',reform(wsc_GSE_tmp),newname=rbspx+'_emfisis_l3_4sec_mgse_Mag'


		get_data,rbspx+'_efw_esvy_mgse_vxb_removed_spinfit',data=E2
		
		;Interpolate the Bsvy data to the times of vxb data
		tinterpol_mxn,rbspx+'_emfisis_l3_4sec_mgse_Mag',E2.x
		get_data,rbspx+'_emfisis_l3_4sec_mgse_Mag_interp',data=B2
		
		
		ntimes = n_elements(E2.x)


;************************
;STOP: NEED TO INTERPOLATE SAVED DATA TO INFO.TIMES
;************************





		openw,lun,info.path + info.filename,/get_lun,/append
			for zz=0L,ntimes-1 do printf,lun,format='(f11.0,9f10.3)',$
				E2.x[zz],E2.y[zz,0],E2.y[zz,1],E2.y[zz,2],$
				B2.y[zz,0],B2.y[zz,1],B2.y[zz,2]				
		free_lun,lun


		store_data,'*vxb*',/delete
		store_data,'*state*',/delete
		store_data,'*quicklook*',/delete


	endfor

	close,lun


end
