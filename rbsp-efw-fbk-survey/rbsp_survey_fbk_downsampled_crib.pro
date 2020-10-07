;Crib sheet for creating, getting and plotting survey data.


;pass along structure with all relevant data

;****************************************
;Basic structure

;	info = {probe:'a',$
;		   d0:'2012-09-25',$	;START DATE
;		   d1:'2013-01-28',$	;END DATE
;		   dt:20.,$				;DELTA TIME OVER WHICH TO DETERMINE WHATEVER IS BEING CALCULATED. 
;								;EX1: THE %TIME IN EACH dt THAT THERE ARE FBK PEAKS ABOVE A CERTAIN THRESHOLD (rbsp_survey_fbk_percenttime_create_ascii.pro)
;								;EX2: THE MAXIMUM VALUE IN EACH dt (rbsp_survey_fbk_maxvals_create_ascii.pro)
;		   tag:'fbk',$			;FOR LABELING
;		   fbk_mode:'7',$		;FILTERBANK '7' OR '13'
;		   fbk_type:'Ew',$		;THE CHANNEL TYPE 'Ew' OR 'Bw'
;		   thres_pk_amp:1.,$	;MINIMUM PEAK AMPLITUDE TO CONSIDER
;		   thres_av_amp:0.5}	;MINIMUM AVERAGE AMPLITUDE TO CONSIDER
;****************************************










;----------------------------------------------------------------------------------
;----------------------------------------------------------------------------------
;Get the average values of FBK downsampled data over "dt" for a number of days
;----------------------------------------------------------------------------------
;----------------------------------------------------------------------------------


;Basic structure
info = {probe:'a',$
	   d0:'2012-09-01',$
	   d1:'2013-01-31',$
	   dt:4.,$
	   tag:'fbk'}

rbsp_efw_init

;Create the downsampled FBK actual data and save as ASCII
rbsp_survey_fbk_downsampled_create_ascii,info
help,info,/st


;;Create the max and min values and save as ASCII
;rbsp_survey_fbk_create_ascii


;Read ASCII file and store data as tplot vars
rbsp_survey_fbk_downsampled_read_ascii,info 
help,info,/st


;Get the RBSP positional data for the appropriate times
rbsp_survey_create_ephem_ascii,info


;Read in the positional data and save as tplot vars
rbsp_survey_ephem_read_ascii,info

;	tplot,['fbk_pk','fbk_av']
;	tlimit,times[0],times[n_elements(times)-1]





