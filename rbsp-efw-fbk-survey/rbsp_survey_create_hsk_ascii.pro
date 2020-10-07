;Called from rbsp_survey_fbk_crib

;Get hsk data for a large number of days
;Saves data in an ASCII file
;Note, must call one of the data read ASCII routines first (like rbsp_survey_fbk_read_ascii.pro)
;These programs populate the info structure with the appropriate times. 


;Created by Aaron Breneman
;2013-01-12


pro rbsp_survey_create_hsk_ascii,info

	rbspx = 'rbsp' + info.probe

	rbsp_survey_set_filename,info,/hsk


	;Load spice kernels for entire requested timerange
	timespan,info.days[0],info.ndays,/days
;	rbsp_load_spice_kernels

	for dd=0,info.ndays-1 do begin

		timespan,info.days[dd],1 

		;times for the current day
		goo = where(strmid(time_string(info.timesc),0,10) eq info.days[dd])
		timesc = info.timesc[goo]


		;------------------------------
		;load all data
		;------------------------------

		;load state data
		rbsp_load_efw_hsk,probe=info.probe,/get_support_data


		;---------------------------------------
		;Interpolate all values to new times
		;---------------------------------------

		tinterpol_mxn,rbspx+'_efw_hsk_beb_analog_IEFI_IBIAS1',timesc,newname=rbspx+'_efw_hsk_beb_analog_IEFI_IBIAS1'
		tinterpol_mxn,rbspx+'_efw_hsk_beb_analog_IEFI_IBIAS2',timesc,newname=rbspx+'_efw_hsk_beb_analog_IEFI_IBIAS2'
		tinterpol_mxn,rbspx+'_efw_hsk_beb_analog_IEFI_IBIAS3',timesc,newname=rbspx+'_efw_hsk_beb_analog_IEFI_IBIAS3'
		tinterpol_mxn,rbspx+'_efw_hsk_beb_analog_IEFI_IBIAS4',timesc,newname=rbspx+'_efw_hsk_beb_analog_IEFI_IBIAS4'
		tinterpol_mxn,rbspx+'_efw_hsk_beb_analog_IEFI_IBIAS5',timesc,newname=rbspx+'_efw_hsk_beb_analog_IEFI_IBIAS5'
		tinterpol_mxn,rbspx+'_efw_hsk_beb_analog_IEFI_IBIAS6',timesc,newname=rbspx+'_efw_hsk_beb_analog_IEFI_IBIAS6'
		get_data,rbspx+'_efw_hsk_beb_analog_IEFI_IBIAS1',data=beb_analog_IEFI_IBIAS1
		get_data,rbspx+'_efw_hsk_beb_analog_IEFI_IBIAS2',data=beb_analog_IEFI_IBIAS2
		get_data,rbspx+'_efw_hsk_beb_analog_IEFI_IBIAS3',data=beb_analog_IEFI_IBIAS3
		get_data,rbspx+'_efw_hsk_beb_analog_IEFI_IBIAS4',data=beb_analog_IEFI_IBIAS4
		get_data,rbspx+'_efw_hsk_beb_analog_IEFI_IBIAS5',data=beb_analog_IEFI_IBIAS5
		get_data,rbspx+'_efw_hsk_beb_analog_IEFI_IBIAS6',data=beb_analog_IEFI_IBIAS6


		tinterpol_mxn,rbspx+'_efw_hsk_beb_analog_IEFI_GUARD1',timesc,newname=rbspx+'_efw_hsk_beb_analog_IEFI_GUARD1'
		tinterpol_mxn,rbspx+'_efw_hsk_beb_analog_IEFI_GUARD2',timesc,newname=rbspx+'_efw_hsk_beb_analog_IEFI_GUARD2'
		tinterpol_mxn,rbspx+'_efw_hsk_beb_analog_IEFI_GUARD3',timesc,newname=rbspx+'_efw_hsk_beb_analog_IEFI_GUARD3'
		tinterpol_mxn,rbspx+'_efw_hsk_beb_analog_IEFI_GUARD4',timesc,newname=rbspx+'_efw_hsk_beb_analog_IEFI_GUARD4'
		tinterpol_mxn,rbspx+'_efw_hsk_beb_analog_IEFI_GUARD5',timesc,newname=rbspx+'_efw_hsk_beb_analog_IEFI_GUARD5'
		tinterpol_mxn,rbspx+'_efw_hsk_beb_analog_IEFI_GUARD6',timesc,newname=rbspx+'_efw_hsk_beb_analog_IEFI_GUARD6'
		get_data,rbspx+'_efw_hsk_beb_analog_IEFI_GUARD1',data=beb_analog_IEFI_GUARD1
		get_data,rbspx+'_efw_hsk_beb_analog_IEFI_GUARD2',data=beb_analog_IEFI_GUARD2
		get_data,rbspx+'_efw_hsk_beb_analog_IEFI_GUARD3',data=beb_analog_IEFI_GUARD3
		get_data,rbspx+'_efw_hsk_beb_analog_IEFI_GUARD4',data=beb_analog_IEFI_GUARD4
		get_data,rbspx+'_efw_hsk_beb_analog_IEFI_GUARD5',data=beb_analog_IEFI_GUARD5
		get_data,rbspx+'_efw_hsk_beb_analog_IEFI_GUARD6',data=beb_analog_IEFI_GUARD6


		tinterpol_mxn,rbspx+'_efw_hsk_beb_analog_IEFI_USHER1',timesc,newname=rbspx+'_efw_hsk_beb_analog_IEFI_USHER1'
		tinterpol_mxn,rbspx+'_efw_hsk_beb_analog_IEFI_USHER2',timesc,newname=rbspx+'_efw_hsk_beb_analog_IEFI_USHER2'
		tinterpol_mxn,rbspx+'_efw_hsk_beb_analog_IEFI_USHER3',timesc,newname=rbspx+'_efw_hsk_beb_analog_IEFI_USHER3'
		tinterpol_mxn,rbspx+'_efw_hsk_beb_analog_IEFI_USHER4',timesc,newname=rbspx+'_efw_hsk_beb_analog_IEFI_USHER4'
		tinterpol_mxn,rbspx+'_efw_hsk_beb_analog_IEFI_USHER5',timesc,newname=rbspx+'_efw_hsk_beb_analog_IEFI_USHER5'
		tinterpol_mxn,rbspx+'_efw_hsk_beb_analog_IEFI_USHER6',timesc,newname=rbspx+'_efw_hsk_beb_analog_IEFI_USHER6'
		get_data,rbspx+'_efw_hsk_beb_analog_IEFI_USHER1',data=beb_analog_IEFI_USHER1
		get_data,rbspx+'_efw_hsk_beb_analog_IEFI_USHER2',data=beb_analog_IEFI_USHER2
		get_data,rbspx+'_efw_hsk_beb_analog_IEFI_USHER3',data=beb_analog_IEFI_USHER3
		get_data,rbspx+'_efw_hsk_beb_analog_IEFI_USHER4',data=beb_analog_IEFI_USHER4
		get_data,rbspx+'_efw_hsk_beb_analog_IEFI_USHER5',data=beb_analog_IEFI_USHER5
		get_data,rbspx+'_efw_hsk_beb_analog_IEFI_USHER6',data=beb_analog_IEFI_USHER6


		tinterpol_mxn,rbspx+'_efw_hsk_idpu_analog_TMON_LVPS',timesc,newname=rbspx+'_efw_hsk_idpu_analog_TMON_LVPS'
		tinterpol_mxn,rbspx+'_efw_hsk_idpu_analog_TMON_AXB5',timesc,newname=rbspx+'_efw_hsk_idpu_analog_TMON_AXB5'
		tinterpol_mxn,rbspx+'_efw_hsk_idpu_analog_TMON_AXB6',timesc,newname=rbspx+'_efw_hsk_idpu_analog_TMON_AXB6'
		get_data,rbspx+'_efw_hsk_idpu_analog_TMON_LVPS',data=idpu_analog_TMON_LVPS
		get_data,rbspx+'_efw_hsk_idpu_analog_TMON_AXB5',data=idpu_analog_TMON_AXB5
		get_data,rbspx+'_efw_hsk_idpu_analog_TMON_AXB6',data=idpu_analog_TMON_AXB6


		tinterpol_mxn,rbspx+'_efw_hsk_idpu_analog_IMON_BEB',timesc,newname=rbspx+'_efw_hsk_idpu_analog_IMON_BEB'
		tinterpol_mxn,rbspx+'_efw_hsk_idpu_analog_IMON_IDPU',timesc,newname=rbspx+'_efw_hsk_idpu_analog_IMON_IDPU'
		tinterpol_mxn,rbspx+'_efw_hsk_idpu_analog_IMON_FVX',timesc,newname=rbspx+'_efw_hsk_idpu_analog_IMON_FVX'
		tinterpol_mxn,rbspx+'_efw_hsk_idpu_analog_IMON_FVY',timesc,newname=rbspx+'_efw_hsk_idpu_analog_IMON_FVY'
		tinterpol_mxn,rbspx+'_efw_hsk_idpu_analog_IMON_FVZ',timesc,newname=rbspx+'_efw_hsk_idpu_analog_IMON_FVZ'
		get_data,rbspx+'_efw_hsk_idpu_analog_IMON_BEB',data=idpu_analog_IMON_BEB
		get_data,rbspx+'_efw_hsk_idpu_analog_IMON_IDPU',data=idpu_analog_IMON_IDPU
		get_data,rbspx+'_efw_hsk_idpu_analog_IMON_FVX',data=idpu_analog_IMON_FVX
		get_data,rbspx+'_efw_hsk_idpu_analog_IMON_FVY',data=idpu_analog_IMON_FVY
		get_data,rbspx+'_efw_hsk_idpu_analog_IMON_FVZ',data=idpu_analog_IMON_FVZ



		tinterpol_mxn,rbspx+'_efw_hsk_idpu_analog_VMON_BEB_P10VA',timesc,newname=rbspx+'_efw_hsk_idpu_analog_VMON_BEB_P10VA'
		tinterpol_mxn,rbspx+'_efw_hsk_idpu_analog_VMON_BEB_N10VA',timesc,newname=rbspx+'_efw_hsk_idpu_analog_VMON_BEB_N10VA'
		tinterpol_mxn,rbspx+'_efw_hsk_idpu_analog_VMON_BEB_P5VA',timesc,newname=rbspx+'_efw_hsk_idpu_analog_VMON_BEB_P5VA'
		tinterpol_mxn,rbspx+'_efw_hsk_idpu_analog_VMON_BEB_P5VD',timesc,newname=rbspx+'_efw_hsk_idpu_analog_VMON_BEB_P5VD'
		get_data,rbspx+'_efw_hsk_idpu_analog_VMON_BEB_P10VA',data=idpu_analog_VMON_BEB_P10VA
		get_data,rbspx+'_efw_hsk_idpu_analog_VMON_BEB_N10VA',data=idpu_analog_VMON_BEB_N10VA
		get_data,rbspx+'_efw_hsk_idpu_analog_VMON_BEB_P5VA',data=idpu_analog_VMON_BEB_P5VA
		get_data,rbspx+'_efw_hsk_idpu_analog_VMON_BEB_P5VD',data=idpu_analog_VMON_BEB_P5VD

		tinterpol_mxn,rbspx+'_efw_hsk_idpu_analog_VMON_IDPU_P10VA',timesc,newname=rbspx+'_efw_hsk_idpu_analog_VMON_IDPU_P10VA'
		tinterpol_mxn,rbspx+'_efw_hsk_idpu_analog_VMON_IDPU_N10VA',timesc,newname=rbspx+'_efw_hsk_idpu_analog_VMON_IDPU_N10VA'
		get_data,rbspx+'_efw_hsk_idpu_analog_VMON_IDPU_P10VA',data=idpu_analog_VMON_IDPU_P10VA
		get_data,rbspx+'_efw_hsk_idpu_analog_VMON_IDPU_N10VA',data=idpu_analog_VMON_IDPU_N10VA


		tinterpol_mxn,rbspx+'_efw_hsk_idpu_analog_VMON_IDPU_P36VD',timesc,newname=rbspx+'_efw_hsk_idpu_analog_VMON_IDPU_P36VD'
		tinterpol_mxn,rbspx+'_efw_hsk_idpu_analog_VMON_IDPU_P18VD',timesc,newname=rbspx+'_efw_hsk_idpu_analog_VMON_IDPU_P18VD'
		tinterpol_mxn,rbspx+'_efw_hsk_idpu_analog_P33VD',timesc,newname=rbspx+'_efw_hsk_idpu_analog_P33VD'
		tinterpol_mxn,rbspx+'_efw_hsk_idpu_analog_P15VD',timesc,newname=rbspx+'_efw_hsk_idpu_analog_P15VD'
		get_data,rbspx+'_efw_hsk_idpu_analog_VMON_IDPU_P36VD',data=idpu_analog_VMON_IDPU_P36VD
		get_data,rbspx+'_efw_hsk_idpu_analog_VMON_IDPU_P18VD',data=idpu_analog_VMON_IDPU_P18VD
		get_data,rbspx+'_efw_hsk_idpu_analog_P33VD',data=idpu_analog_P33VD
		get_data,rbspx+'_efw_hsk_idpu_analog_P15VD',data=idpu_analog_P15VD

		tinterpol_mxn,rbspx+'_efw_hsk_idpu_eng_SC_EFW_SSR',timesc,newname=rbspx+'_efw_hsk_idpu_eng_SC_EFW_SSR'
		get_data,rbspx+'_efw_hsk_idpu_eng_SC_EFW_SSR',data=idpu_eng_SC_EFW_SSR


		tinterpol_mxn,rbspx+'_efw_hsk_idpu_fast_B1_EVALMAX',timesc,newname=rbspx+'_efw_hsk_idpu_fast_B1_EVALMAX'
		tinterpol_mxn,rbspx+'_efw_hsk_idpu_fast_B1_PLAYREQ',timesc,newname=rbspx+'_efw_hsk_idpu_fast_B1_PLAYREQ'
		tinterpol_mxn,rbspx+'_efw_hsk_idpu_fast_B1_RECBBI',timesc,newname=rbspx+'_efw_hsk_idpu_fast_B1_RECBBI'
		tinterpol_mxn,rbspx+'_efw_hsk_idpu_fast_B1_RECECI',timesc,newname=rbspx+'_efw_hsk_idpu_fast_B1_RECECI'
		tinterpol_mxn,rbspx+'_efw_hsk_idpu_fast_B1_THRESH',timesc,newname=rbspx+'_efw_hsk_idpu_fast_B1_THRESH'
		get_data,rbspx+'_efw_hsk_idpu_fast_B1_EVALMAX',data=idpu_fast_B1_EVALMAX
		get_data,rbspx+'_efw_hsk_idpu_fast_B1_PLAYREQ',data=idpu_fast_B1_PLAYREQ
		get_data,rbspx+'_efw_hsk_idpu_fast_B1_RECBBI',data=idpu_fast_B1_RECBBI
		get_data,rbspx+'_efw_hsk_idpu_fast_B1_RECECI',data=idpu_fast_B1_RECECI
		get_data,rbspx+'_efw_hsk_idpu_fast_B1_THRESH',data=idpu_fast_B1_THRESH


		tinterpol_mxn,rbspx+'_efw_hsk_idpu_fast_B2RECSTATE',timesc,newname=rbspx+'_efw_hsk_idpu_fast_B2RECSTATE'
		tinterpol_mxn,rbspx+'_efw_hsk_idpu_fast_B2_THRESH',timesc,newname=rbspx+'_efw_hsk_idpu_fast_B2_THRESH'
		get_data,rbspx+'_efw_hsk_idpu_fast_B2RECSTATE',data=idpu_fast_B2RECSTATE
		get_data,rbspx+'_efw_hsk_idpu_fast_B2_THRESH',data=idpu_fast_B2_THRESH





		;Fill empty arrays with NaNs

				nans = replicate(!values.f_nan,n_elements(timesc))
		
				if ~is_struct(beb_analog_IEFI_IBIAS1) then beb_analog_IEFI_IBIAS1 = {x:timesc,y:nans}
				if ~is_struct(beb_analog_IEFI_IBIAS2) then beb_analog_IEFI_IBIAS2 = {x:timesc,y:nans}
				if ~is_struct(beb_analog_IEFI_IBIAS3) then beb_analog_IEFI_IBIAS3 = {x:timesc,y:nans}
				if ~is_struct(beb_analog_IEFI_IBIAS4) then beb_analog_IEFI_IBIAS4 = {x:timesc,y:nans}
				if ~is_struct(beb_analog_IEFI_IBIAS5) then beb_analog_IEFI_IBIAS5 = {x:timesc,y:nans}
				if ~is_struct(beb_analog_IEFI_IBIAS6) then beb_analog_IEFI_IBIAS6 = {x:timesc,y:nans}
				if ~is_struct(beb_analog_IEFI_GUARD1) then beb_analog_IEFI_GUARD1 = {x:timesc,y:nans}
				if ~is_struct(beb_analog_IEFI_GUARD2) then beb_analog_IEFI_GUARD2 = {x:timesc,y:nans}
				if ~is_struct(beb_analog_IEFI_GUARD3) then beb_analog_IEFI_GUARD3 = {x:timesc,y:nans}
				if ~is_struct(beb_analog_IEFI_GUARD4) then beb_analog_IEFI_GUARD4 = {x:timesc,y:nans}
				if ~is_struct(beb_analog_IEFI_GUARD5) then beb_analog_IEFI_GUARD5 = {x:timesc,y:nans}
				if ~is_struct(beb_analog_IEFI_GUARD6) then beb_analog_IEFI_GUARD6 = {x:timesc,y:nans}
				if ~is_struct(beb_analog_IEFI_USHER1) then beb_analog_IEFI_USHER1 = {x:timesc,y:nans}
				if ~is_struct(beb_analog_IEFI_USHER2) then beb_analog_IEFI_USHER2 = {x:timesc,y:nans}
				if ~is_struct(beb_analog_IEFI_USHER3) then beb_analog_IEFI_USHER3 = {x:timesc,y:nans}
				if ~is_struct(beb_analog_IEFI_USHER4) then beb_analog_IEFI_USHER4 = {x:timesc,y:nans}
				if ~is_struct(beb_analog_IEFI_USHER5) then beb_analog_IEFI_USHER5 = {x:timesc,y:nans}
				if ~is_struct(beb_analog_IEFI_USHER6) then beb_analog_IEFI_USHER6 = {x:timesc,y:nans}	 
				if ~is_struct(idpu_analog_TMON_LVPS) then idpu_analog_TMON_LVPS = {x:timesc,y:nans}
				if ~is_struct(idpu_analog_TMON_AXB5) then idpu_analog_TMON_AXB5 = {x:timesc,y:nans}
				if ~is_struct(idpu_analog_TMON_AXB6) then idpu_analog_TMON_AXB6 = {x:timesc,y:nans}			
				if ~is_struct(idpu_analog_IMON_BEB) then idpu_analog_IMON_BEB = {x:timesc,y:nans}
				if ~is_struct(idpu_analog_IMON_IDPU) then idpu_analog_IMON_IDPU = {x:timesc,y:nans}
				if ~is_struct(idpu_analog_IMON_FVX) then idpu_analog_IMON_FVX = {x:timesc,y:nans}
				if ~is_struct(idpu_analog_IMON_FVY) then idpu_analog_IMON_FVY = {x:timesc,y:nans}
				if ~is_struct(idpu_analog_IMON_FVZ) then idpu_analog_IMON_FVZ = {x:timesc,y:nans}
				if ~is_struct(idpu_analog_VMON_BEB_P10VA) then idpu_analog_VMON_BEB_P10VA = {x:timesc,y:nans}
				if ~is_struct(idpu_analog_VMON_BEB_N10VA) then idpu_analog_VMON_BEB_N10VA = {x:timesc,y:nans}
				if ~is_struct(idpu_analog_VMON_BEB_P5VA) then idpu_analog_VMON_BEB_P5VA = {x:timesc,y:nans}
				if ~is_struct(idpu_analog_VMON_BEB_P5VD) then idpu_analog_VMON_BEB_P5VD = {x:timesc,y:nans}
				if ~is_struct(idpu_analog_VMON_IDPU_P10VA) then idpu_analog_VMON_IDPU_P10VA = {x:timesc,y:nans}
				if ~is_struct(idpu_analog_VMON_IDPU_N10VA) then idpu_analog_VMON_IDPU_N10VA = {x:timesc,y:nans}
				if ~is_struct(idpu_analog_VMON_IDPU_P36VD) then idpu_analog_VMON_IDPU_P36VD = {x:timesc,y:nans}
				if ~is_struct(idpu_analog_VMON_IDPU_P18VD) then idpu_analog_VMON_IDPU_P18VD = {x:timesc,y:nans}
				if ~is_struct(idpu_analog_P33VD) then idpu_analog_P33VD = {x:timesc,y:nans}
				if ~is_struct(idpu_analog_P15VD) then idpu_analog_P15VD = {x:timesc,y:nans}
				if ~is_struct(idpu_eng_SC_EFW_SSR) then idpu_eng_SC_EFW_SSR = {x:timesc,y:nans}
				if ~is_struct(idpu_fast_B1_EVALMAX) then idpu_fast_B1_EVALMAX = {x:timesc,y:nans}
				if ~is_struct(idpu_fast_B1_PLAYREQ) then idpu_fast_B1_PLAYREQ = {x:timesc,y:nans}
				if ~is_struct(idpu_fast_B1_RECBBI) then idpu_fast_B1_RECBBI = {x:timesc,y:nans}
				if ~is_struct(idpu_fast_B1_RECECI) then idpu_fast_B1_RECECI = {x:timesc,y:nans}
				if ~is_struct(idpu_fast_B1_THRESH) then idpu_fast_B1_THRESH = {x:timesc,y:nans}
				if ~is_struct(idpu_fast_B2RECSTATE) then idpu_fast_B2RECSTATE = {x:timesc,y:nans}
				if ~is_struct(idpu_fast_B2_THRESH) then idpu_fast_B2_THRESH = {x:timesc,y:nans}



		;-------------------------------------
		;Variables saved and their format code
		;-------------------------------------


		;****FOR TESTING THE FORMATTING CODES****

		;times = I10
		;all bias indicators:  F10.1
		;TMON: I6
		;VMON: F6.1
		;IMON: F7.2

		;*******************




		openw,lun,info.path + info.filename_hsk,/get_lun,/append
			for zz=0L,n_elements(timesc)-1 do printf,lun,$
				format='(I10,2x,18f10.1,3I6,5F7.2,8F6.1,10F10.2)',$
				timesc[zz],$
				beb_analog_IEFI_IBIAS1.y[zz],$
				beb_analog_IEFI_IBIAS2.y[zz],$
				beb_analog_IEFI_IBIAS3.y[zz],$
				beb_analog_IEFI_IBIAS4.y[zz],$
				beb_analog_IEFI_IBIAS5.y[zz],$
				beb_analog_IEFI_IBIAS6.y[zz],$
				beb_analog_IEFI_GUARD1.y[zz],$
				beb_analog_IEFI_GUARD2.y[zz],$
				beb_analog_IEFI_GUARD3.y[zz],$
				beb_analog_IEFI_GUARD4.y[zz],$
				beb_analog_IEFI_GUARD5.y[zz],$
				beb_analog_IEFI_GUARD6.y[zz],$
				beb_analog_IEFI_USHER1.y[zz],$
				beb_analog_IEFI_USHER2.y[zz],$
				beb_analog_IEFI_USHER3.y[zz],$
				beb_analog_IEFI_USHER4.y[zz],$
				beb_analog_IEFI_USHER5.y[zz],$
				beb_analog_IEFI_USHER6.y[zz],$	 
				idpu_analog_TMON_LVPS.y[zz],$
				idpu_analog_TMON_AXB5.y[zz],$
				idpu_analog_TMON_AXB6.y[zz],$				
				idpu_analog_IMON_BEB.y[zz],$
				idpu_analog_IMON_IDPU.y[zz],$
				idpu_analog_IMON_FVX.y[zz],$
				idpu_analog_IMON_FVY.y[zz],$
				idpu_analog_IMON_FVZ.y[zz],$
				idpu_analog_VMON_BEB_P10VA.y[zz],$
				idpu_analog_VMON_BEB_N10VA.y[zz],$
				idpu_analog_VMON_BEB_P5VA.y[zz],$
				idpu_analog_VMON_BEB_P5VD.y[zz],$
				idpu_analog_VMON_IDPU_P10VA.y[zz],$
				idpu_analog_VMON_IDPU_N10VA.y[zz],$
				idpu_analog_VMON_IDPU_P36VD.y[zz],$
				idpu_analog_VMON_IDPU_P18VD.y[zz],$
				idpu_analog_P33VD.y[zz],$
				idpu_analog_P15VD.y[zz],$
				idpu_eng_SC_EFW_SSR.y[zz],$
				idpu_fast_B1_EVALMAX.y[zz],$
				idpu_fast_B1_PLAYREQ.y[zz],$
				idpu_fast_B1_RECBBI.y[zz],$
				idpu_fast_B1_RECECI.y[zz],$
				idpu_fast_B1_THRESH.y[zz],$
				idpu_fast_B2RECSTATE.y[zz],$
				idpu_fast_B2_THRESH.y[zz]
		close,lun
		free_lun,lun
	
		store_data,['*hsk*'],/delete

	endfor

end




