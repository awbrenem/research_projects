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
;Get the %time that there are FBK peaks above a certain threshold for each time "dt"
;for a number of days
;----------------------------------------------------------------------------------
;----------------------------------------------------------------------------------



;Data limits:
                                ;09-25 - first day with FBK data
                                ;03-15 - last day of FBK13 data

;; ;HSK test run (full cadence is 16 seconds)
;; 	info = {probe:'a',$
;; 		   d0:'2012-09-05',$
;; 		   d1:'2013-11-20',$
;; 		   dt:60.,$
;; 		   tag:'dummy',$
;; 		   fbk_mode:'dummy',$
;; 		   fbk_type:'hsk',$
;; 		   minfreq:0.1,$		;minfreq * fce
;; 		   maxfreq:1,$			;maxfreq * fce
;; 		   minamp_pk:2.5,$		;mV/m or nT
;; 		   maxamp_pk:1d5,$
;; 		   minamp_av:0.5,$
;; 		   maxamp_av:1d5}


;; ;Data limits:
;; 	;09-25 - first day with FBK data
;; 	;03-15 - last day of FBK13 data




;Python program that first passes variables to an info.pro program
;that forms the structure


                                ;Path to current run

;; path = '~/Desktop/code/Aaron/RBSP/survey_programs/runtest_l=5.5_mlt=0..12/'
;; path = '~/Desktop/code/Aaron/RBSP/survey_programs/runtest_l=2-5_mlt=5/'
;; path = '~/Desktop/code/Aaron/RBSP/survey_programs/amptest_basic/'
;path = '~/Desktop/code/Aaron/RBSP/survey_programs/runtest_fbk13a/'
path = '/Users/aaronbreneman/Desktop/Research/RBSP_FBK_first_results/runtest_fbk13a/'
fn = 'info.idl'
restore,path+fn

;***********************



if info.fbk_type eq 'Ew' then units = 'mV/m' else units = 'nT'



tplot_restore,filename=path+'ephem_RBSP'+info.probe+'.tplot'

;from rbsp_survey_delta_lshell_from_plasmapause
tplot_restore,filenames=path+'rbspa_dist_from_pp'+'.tplot'


rbsp_efw_init
tplot,'rbspa_'+['mlt','lshell']
tplot,'rbspa_'+['gold_distance_from_pp','distance_from_pp']


;; ;;peak and avg values each "dt" with time
;; tplot_restore,filename='~/Desktop/code/Aaron/RBSP/survey_programs/runtest_tmp1/'+'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_'+'fbk_ephem2'+'_'+info.fbk_type+'.tplot'

;**************************************************



;;peak and avg values each "dt" with time
tplot_restore,filename=path+'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_'+'fbk_ephem2'+'_'+info.fbk_type+'.tplot'


tplot_restore,filename=path+'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_'+'fbk00100'+'_'+info.fbk_type+'.tplot'
tplot_restore,filename=path+'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_'+'fbk0001'+'_'+info.fbk_type+'.tplot'
tplot_restore,filename=path+'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_'+'fbk0102'+'_'+info.fbk_type+'.tplot'
tplot_restore,filename=path+'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_'+'fbk0203'+'_'+info.fbk_type+'.tplot'
tplot_restore,filename=path+'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_'+'fbk0304'+'_'+info.fbk_type+'.tplot'
tplot_restore,filename=path+'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_'+'fbk0405'+'_'+info.fbk_type+'.tplot'
tplot_restore,filename=path+'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_'+'fbk0506'+'_'+info.fbk_type+'.tplot'
tplot_restore,filename=path+'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_'+'fbk0607'+'_'+info.fbk_type+'.tplot'
tplot_restore,filename=path+'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_'+'fbk0708'+'_'+info.fbk_type+'.tplot'
tplot_restore,filename=path+'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_'+'fbk0809'+'_'+info.fbk_type+'.tplot'
tplot_restore,filename=path+'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_'+'fbk0910'+'_'+info.fbk_type+'.tplot'
tplot_restore,filename=path+'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_'+'fbk10100'+'_'+info.fbk_type+'.tplot'


;;peak amplitude distributions
tplot_restore,filename=path+'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_ampdist_pk00100_'+info.fbk_type+'.tplot'
tplot_restore,filename=path+'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_ampdist_pk0001_'+info.fbk_type+'.tplot'
tplot_restore,filename=path+'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_ampdist_pk0102_'+info.fbk_type+'.tplot'
tplot_restore,filename=path+'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_ampdist_pk0203_'+info.fbk_type+'.tplot'
tplot_restore,filename=path+'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_ampdist_pk0304_'+info.fbk_type+'.tplot'
tplot_restore,filename=path+'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_ampdist_pk0405_'+info.fbk_type+'.tplot'
tplot_restore,filename=path+'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_ampdist_pk0506_'+info.fbk_type+'.tplot'
tplot_restore,filename=path+'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_ampdist_pk0607_'+info.fbk_type+'.tplot'
tplot_restore,filename=path+'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_ampdist_pk0708_'+info.fbk_type+'.tplot'
tplot_restore,filename=path+'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_ampdist_pk0809_'+info.fbk_type+'.tplot'
tplot_restore,filename=path+'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_ampdist_pk0910_'+info.fbk_type+'.tplot'
tplot_restore,filename=path+'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_ampdist_pk10100'+'_'+info.fbk_type+'.tplot'

;;average amplitude distributions
tplot_restore,filename=path+'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_ampdist_avg00100_'+info.fbk_type+'.tplot'
tplot_restore,filename=path+'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_ampdist_avg0001_'+info.fbk_type+'.tplot'
tplot_restore,filename=path+'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_ampdist_avg0102_'+info.fbk_type+'.tplot'
tplot_restore,filename=path+'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_ampdist_avg0203_'+info.fbk_type+'.tplot'
tplot_restore,filename=path+'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_ampdist_avg0304_'+info.fbk_type+'.tplot'
tplot_restore,filename=path+'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_ampdist_avg0405_'+info.fbk_type+'.tplot'
tplot_restore,filename=path+'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_ampdist_avg0506_'+info.fbk_type+'.tplot'
tplot_restore,filename=path+'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_ampdist_avg0607_'+info.fbk_type+'.tplot'
tplot_restore,filename=path+'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_ampdist_avg0708_'+info.fbk_type+'.tplot'
tplot_restore,filename=path+'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_ampdist_avg0809_'+info.fbk_type+'.tplot'
tplot_restore,filename=path+'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_ampdist_avg0910_'+info.fbk_type+'.tplot'
tplot_restore,filename=path+'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_ampdist_avg10100'+'_'+info.fbk_type+'.tplot'

;;4sec average amplitude distributions
tplot_restore,filename=path+'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_ampdist_avg4sec00100_'+info.fbk_type+'.tplot'
tplot_restore,filename=path+'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_ampdist_avg4sec0001_'+info.fbk_type+'.tplot'
tplot_restore,filename=path+'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_ampdist_avg4sec0102_'+info.fbk_type+'.tplot'
tplot_restore,filename=path+'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_ampdist_avg4sec0203_'+info.fbk_type+'.tplot'
tplot_restore,filename=path+'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_ampdist_avg4sec0304_'+info.fbk_type+'.tplot'
tplot_restore,filename=path+'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_ampdist_avg4sec0405_'+info.fbk_type+'.tplot'
tplot_restore,filename=path+'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_ampdist_avg4sec0506_'+info.fbk_type+'.tplot'
tplot_restore,filename=path+'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_ampdist_avg4sec0607_'+info.fbk_type+'.tplot'
tplot_restore,filename=path+'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_ampdist_avg4sec0708_'+info.fbk_type+'.tplot'
tplot_restore,filename=path+'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_ampdist_avg4sec0809_'+info.fbk_type+'.tplot'
tplot_restore,filename=path+'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_ampdist_avg4sec0910_'+info.fbk_type+'.tplot'
tplot_restore,filename=path+'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_ampdist_avg4sec10100'+'_'+info.fbk_type+'.tplot'

;;ratio amplitude distributions
tplot_restore,filename=path+'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_ampdist_ratio00100_'+info.fbk_type+'.tplot'
tplot_restore,filename=path+'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_ampdist_ratio0001_'+info.fbk_type+'.tplot'
tplot_restore,filename=path+'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_ampdist_ratio0102_'+info.fbk_type+'.tplot'
tplot_restore,filename=path+'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_ampdist_ratio0203_'+info.fbk_type+'.tplot'
tplot_restore,filename=path+'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_ampdist_ratio0304_'+info.fbk_type+'.tplot'
tplot_restore,filename=path+'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_ampdist_ratio0405_'+info.fbk_type+'.tplot'
tplot_restore,filename=path+'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_ampdist_ratio0506_'+info.fbk_type+'.tplot'
tplot_restore,filename=path+'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_ampdist_ratio0607_'+info.fbk_type+'.tplot'
tplot_restore,filename=path+'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_ampdist_ratio0708_'+info.fbk_type+'.tplot'
tplot_restore,filename=path+'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_ampdist_ratio0809_'+info.fbk_type+'.tplot'
tplot_restore,filename=path+'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_ampdist_ratio0910_'+info.fbk_type+'.tplot'
tplot_restore,filename=path+'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_ampdist_ratio10100'+'_'+info.fbk_type+'.tplot'

;;4sec ratio amplitude distributions
tplot_restore,filename=path+'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_ampdist_ratio4sec00100_'+info.fbk_type+'.tplot'
tplot_restore,filename=path+'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_ampdist_ratio4sec0001_'+info.fbk_type+'.tplot'
tplot_restore,filename=path+'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_ampdist_ratio4sec0102_'+info.fbk_type+'.tplot'
tplot_restore,filename=path+'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_ampdist_ratio4sec0203_'+info.fbk_type+'.tplot'
tplot_restore,filename=path+'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_ampdist_ratio4sec0304_'+info.fbk_type+'.tplot'
tplot_restore,filename=path+'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_ampdist_ratio4sec0405_'+info.fbk_type+'.tplot'
tplot_restore,filename=path+'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_ampdist_ratio4sec0506_'+info.fbk_type+'.tplot'
tplot_restore,filename=path+'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_ampdist_ratio4sec0607_'+info.fbk_type+'.tplot'
tplot_restore,filename=path+'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_ampdist_ratio4sec0708_'+info.fbk_type+'.tplot'
tplot_restore,filename=path+'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_ampdist_ratio4sec0809_'+info.fbk_type+'.tplot'
tplot_restore,filename=path+'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_ampdist_ratio4sec0910_'+info.fbk_type+'.tplot'
tplot_restore,filename=path+'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_ampdist_ratio4sec10100'+'_'+info.fbk_type+'.tplot'




;--------------------------------------------------
;combine some of the freq bins for the peak and average values
;--------------------------------------------------

;***My programs don't include avg4sec, ratio or ratio4sec
;versions of these. Should they be created within rbsp_survey_create_fbk_ascii.pro??
;*****


;;lower band chorus
fn = ['0102','0203','0304','0405']
rbsp_survey_combine_freqbins,info,fn,newsuffix='0105'

;;upper band chorus
fn = ['0506','0607','0708','0809','0910']
rbsp_survey_combine_freqbins,info,fn,newsuffix='0510'

;;all chorus
fn = ['0102','0203','0304','0405','0506','0607','0708','0809','0910']
rbsp_survey_combine_freqbins,info,fn,newsuffix='0110'



;--------------------------------------------------
;combine some of the freq bins for the amplitude totals
;--------------------------------------------------

;;lower band chorus
fn = 'pk'+['0102','0203','0304','0405']+'_counts'
rbsp_survey_combine_freqbins_amplitude,info,fn,newsuffix='pk0105_counts'
fn = 'avg'+['0102','0203','0304','0405']+'_counts'
rbsp_survey_combine_freqbins_amplitude,info,fn,newsuffix='avg0105_counts'

;;upper band chorus
fn = 'pk'+['0506','0607','0708','0809','0910']+'_counts'
rbsp_survey_combine_freqbins_amplitude,info,fn,newsuffix='pk0510_counts'
fn = 'avg'+['0506','0607','0708','0809','0910']+'_counts'
rbsp_survey_combine_freqbins_amplitude,info,fn,newsuffix='avg0510_counts'

;;all chorus
fn = 'pk'+['0102','0203','0304','0405','0506','0607','0708','0809','0910']+'_counts'
rbsp_survey_combine_freqbins_amplitude,info,fn,newsuffix='pk0110_counts'
fn = 'avg'+['0102','0203','0304','0405','0506','0607','0708','0809','0910']+'_counts'
rbsp_survey_combine_freqbins_amplitude,info,fn,newsuffix='avg0110_counts'





rbsp_efw_init
textadd = ''



;;Default values for the info struct. These may be changed later
str_element,info,'mlatL',0,/add_replace
str_element,info,'mlatH',90,/add_replace
str_element,info,'aeL',0,/add_replace
str_element,info,'aeH',5000,/add_replace
str_element,info,'dstL',-1000,/add_replace
str_element,info,'dstH',1000,/add_replace
str_element,info,'combined_sc',0,/add_replace



;Limit data by magnetic latitude if desired
mlatL = 0.
mlatH = 90.
rbsp_survey_mlat_limit,mlatL,mlatH,'rbsp'+info.probe+'_nfbk_pk0105',info
rbsp_survey_mlat_limit,mlatL,mlatH,'rbsp'+info.probe+'_nfbk_av0105',info
rbsp_survey_mlat_limit,mlatL,mlatH,'rbsp'+info.probe+'_fbk_pk',info
rbsp_survey_mlat_limit,mlatL,mlatH,'rbsp'+info.probe+'_fbk_av',info
rbsp_survey_mlat_limit,mlatL,mlatH,'rbsp'+info.probe+'_amp_ratio_counts',info
rbsp_survey_mlat_limit,mlatL,mlatH,'rbsp'+info.probe+'_amp_ratio4sec_counts',info
textadd = textadd + '!C for mlat>'+strtrim(floor(mlatL),2)+' to mlat<'+strtrim(floor(mlatH),2)+ ' deg'

;Limit data by AE index if desired
aeL = 0.
aeH = 5000.
nhrs = 0.
;****NEED TO TEST THIS BETTER. NOt sure lag is working properly
rbsp_survey_ae_limit,aeL,aeH,'rbsp'+info.probe+'_nfbk_pk0105',info,nhrs=nhrs
rbsp_survey_ae_limit,aeL,aeH,'rbsp'+info.probe+'_nfbk_av0105',info,nhrs=nhrs
rbsp_survey_ae_limit,aeL,aeH,'rbsp'+info.probe+'_fbk_pk',info,nhrs=nhrs
rbsp_survey_ae_limit,aeL,aeH,'rbsp'+info.probe+'_fbk_av',info,nhrs=nhrs
rbsp_survey_ae_limit,aeL,aeH,'rbsp'+info.probe+'_amp_ratio_counts',info
rbsp_survey_ae_limit,aeL,aeH,'rbsp'+info.probe+'_amp_ratio4sec_counts',info
textadd = textadd + '!C for AE>'+strtrim(floor(aeL),2)+' to AE<'+strtrim(floor(aeH),2)

;Limit data by DST
dstL = -1000.
dstH = 1000.
nhrs = 1.

;****NEED TO TEST THIS BETTER. Not sure lag is working properly
rbsp_survey_dst_limit,dstL,dstH,'rbsp'+info.probe+'_nfbk_pk????',info,nhrs=nhrs
rbsp_survey_dst_limit,dstL,dstH,'rbsp'+info.probe+'_fbk_pk????',info,nhrs=nhrs
;; rbsp_survey_dst_limit,dstL,dstH,'rbsp'+info.probe+'_nfbk_av0105',info,nhrs=nhrs
;; rbsp_survey_dst_limit,dstL,dstH,'rbsp'+info.probe+'_fbk_pk',info,nhrs=nhrs
;; rbsp_survey_dst_limit,dstL,dstH,'rbsp'+info.probe+'_fbk_av',info,nhrs=nhrs
;; rbsp_survey_dst_limit,dstL,dstH,'rbsp'+info.probe+'_amp_ratio_counts',info
;; rbsp_survey_dst_limit,dstL,dstH,'rbsp'+info.probe+'_amp_ratio4sec_counts',info
textadd = textadd + '!C for DST>'+strtrim(floor(dstL),2)+' to DST<'+strtrim(floor(dstH),2)




;---------------------------------------------------------------------
;Find the %-time in each sector for d0 to d1. This puts the data into
;info.percentoccurrence_bin, so only select a single one of these
;---------------------------------------------------------------------



dlshell = 0.5                   ;delta-Lshell for grid
lmin = -2
lmax = 5
dtheta = 1.                     ;delta-theta (hours) for grid
tmin = 0.
tmax = 24.


rbsp_survey_fbk_return_grid,info,dtheta,dlshell,lmin,lmax,tmin,tmax



fstr = '0105'
rbsp_survey_fbk_percenttime_bin,info,fstr,/deltaL_pp ;,/combinesc


if info.combined_sc eq 0 then text = '% occurrence of FBK peak values ('+strtrim(floor(info.dt),2)+$
                                     ' sec chunks)!Cin each sector for!C'+'RBSP-'+strupcase(info.probe) + $
                                     '!C'+info.D0+' to '+info.D1+'!Cfor freq range '+fstr
if info.combined_sc eq 1 then text = '% occurrence of FBK peak values ('+strtrim(floor(info.dt),2)+$
                                     ' sec chunks)!Cin each sector for!C'+'both sc' + $
                                     '!C'+info.D0+' to '+info.D1+'!Cfor freq range '+fstr
text = text + textadd


                                ;-----------------------------------------------
                                ;...plot the % times for all bins
title = 'Amp>' + string(info.minamp_pk,format='(f4.1)') + units + ','
cbtitle = '% time'
if info.fbk_mode eq '13' then values = 100.*info.percentoccurrence_bin.percent_peaks
if info.fbk_mode eq '7' then values = 100.*info.percentoccurrence_bin.percent_peaks
counts = info.percentoccurrence_bin.counts
                              ;-----------------------------------------------


rbsp_survey_fbk_dial_plot,info,values,counts,$
                     minc_vals=0.1,$
                     maxc_vals=5.,$
                     minc_cnt=1.,$
                     maxc_cnt=5000.,$
                     text=text,title=title,cbtitle=cbtitle,$
                     ps=0,$
                     formatleft='(F6.1)',$
                     formatright='(G8.1)',$
                     nvformatleft=5,$
                     nvformatright=5


rbsp_survey_fbk_plot,info,values,counts,$
                     minc_vals=0.1,$
                     maxc_vals=5.,$
                     minc_cnt=1.,$
                     maxc_cnt=5000.,$
                     text=text,title=title,cbtitle=cbtitle,$
                     ps=0,$
                     formatleft='(F6.1)',$
                     formatright='(G8.1)',$
                     nvformatleft=5,$
                     nvformatright=5,/deltaL_pp,$
                     xrange=[0,24],yrange=[-2,5]


;;----------------------------------------------
;;Plot the peak values for all bins
;;----------------------------------------------

fstr = '0105'
rbsp_survey_fbk_percenttime_bin,info,fstr,/deltaL_pp ;,/combinesc


valuesP = info.amps_bin.peaks
countsP = info.amps_bin.counts
cbtitle = 'Peak value [mV/m]'
title = 'Amp>' + string(info.minamp_pk,format='(f4.1)') + units + ','

if info.combined_sc eq 0 then text = 'FBK peak values ('+strtrim(floor(info.dt),2)+$
                                     ' sec chunks)!Cin each sector for!C'+'RBSP-'+strupcase(info.probe) + $
                                     '!C'+info.D0+' to '+info.D1+'!Cfor freq range '+fstr
if info.combined_sc eq 1 then text = 'FBK peak values ('+strtrim(floor(info.dt),2)+$
                                     ' sec chunks)!Cin each sector for!C'+'both sc' + $
                                     '!C'+info.D0+' to '+info.D1+'!Cfor freq range '+fstr
text = text + textadd


rbsp_survey_fbk_dial_plot,info,valuesP,countsP,$
                     minc_vals=0.1,$
                     maxc_vals=100,$
                     minc_cnt=1,$
                     maxc_cnt=5000,$
                     text=text,title=title,cbtitle=cbtitle,$
                     ps=0,$
                     formatleft='(I5)',$
                     formatright='(I5)',$
                     nvformatleft=5,$
                     nvformatright=5

rbsp_survey_fbk_plot,info,valuesP,countsP,$
                    minc_vals=0.1,$
                    maxc_vals=100.,$
                    minc_cnt=1.,$
                    maxc_cnt=5000.,$
                    text=text,title=title,cbtitle=cbtitle,$
                    ps=0,$
                    formatleft='(F6.1)',$
                    formatright='(G8.1)',$
                    nvformatleft=5,$
                    nvformatright=5,/deltaL_pp,$
                    xrange=[0,24],yrange=[-2,5]


;;------------------------------------------------------
;;Plot frequency distributions as function of **MLT**
;;------------------------------------------------------

;;Get a different grid for the f_fce plots
dlshell = 5                     ;delta-Lshell for grid
lmin = 2
lmax = 7
dtheta = 1                      ;delta-theta (hours) for grid
tmin = 0.
tmax = 24.

rbsp_survey_fbk_return_grid,info,dtheta,dlshell,lmin,lmax,tmin,tmax


                                ;-----------------------------------------------
                                ;...plot the % times for all bins
title = 'Amp>' + string(info.minamp_pk,format='(f4.1)') + units + '!C'+$
        'Lmin='+strtrim(lmin,2)+',Lmax='+strtrim(lmax,2)+',dL='+strtrim(dlshell,2)
cbtitle = '% time'
                                ;-----------------------------------------------

rbsp_survey_f_fce_plots,info,type='mlt',yrange=[0,24],$
                        minc_vals=0.1,$
                        maxc_vals=1,$
                        minc_peaks=0.,$
                        maxc_peaks=100,$
                        minc_cnt=1.,$
                        maxc_cnt=30000.,$
                        text=text,title=title,cbtitle=cbtitle,$
                        ps=1,$
                        formatleft='(F5.1)',$
                        formatright='(I9)',$
                        nvformatleft=5,$
                        nvformatright=5,$
                        plot_linecounts=1



;;------------------------------------------------------
;;Plot frequency distributions as function of **Lshell**
;;------------------------------------------------------

;;Get a different grid for the f_fce plots
dlshell = 0.5                   ;delta-Lshell for grid
lmin = 2
lmax = 7
dtheta = 24                     ;delta-theta (hours) for grid
tmin = 0.
tmax = 24.

rbsp_survey_fbk_return_grid,info,dtheta,dlshell,lmin,lmax,tmin,tmax

                                ;-----------------------------------------------
                                ;...plot the % times for all bins
title = 'Amp>' + string(info.minamp_pk,format='(f4.1)') + units + '!C'+$
        'MLTmin='+strtrim(tmin,2)+',MLTmax='+strtrim(tmax,2)+',dMLT='+strtrim(dtheta,2)

cbtitle = '% time'
cb2title = 'peak value [mV/m]'
                                ;-----------------------------------------------

rbsp_survey_f_fce_plots,info,type='lshell',yrange=[2,7],$
                        minc_vals=0.1,$
                        maxc_vals=1,$
                        minc_peaks=0.,$
                        maxc_peaks=100,$
                        minc_cnt=1.,$
                        maxc_cnt=70000.,$
                        text=text,title=title,cbtitle=cbtitle,cb2title=cb2title,$
                        ps=1,$
                        formatleft='(F5.1)',$
                        formatright='(I9)',$
                        nvformatleft=5,$
                        nvformatright=5,$
                        plot_linecounts=1


;;--------------------------------------------------
;;Other contour plots
;;--------------------------------------------------



;;--------------------------------------------------
;;Lshell (yaxis) vs DST (xaxis)
;;--------------------------------------------------


;;Get a different grid for the f_fce plots
dlshell = 0.5                   ;delta-Lshell for grid
lmin = 2
lmax = 7
dtheta = 24                     ;delta-theta (hours) for grid
tmin = 0.
tmax = 24.

rbsp_survey_fbk_return_grid,info,dtheta,dlshell,lmin,lmax,tmin,tmax

                                ;-----------------------------------------------
                                ;...plot the % times for all bins
title = 'Amp>' + string(info.minamp_pk,format='(f4.1)') + units + '!C'+$
        'MLTmin='+strtrim(tmin,2)+',MLTmax='+strtrim(tmax,2)+',dMLT='+strtrim(dtheta,2)

cbtitle = '% time'
cb2title = 'peak value [mV/m]'
                                ;-----------------------------------------------

rbsp_survey_contour_plots,info,$
                          fstr='0110',$ ;frequency subset
                          yaxis='rbsp'+info.probe+'_lshell',$
                          xaxis='rbsp'+info.probe+'_dst',$
                          nbins=10,$  ;number of histogram (xaxis) bins
                          xmin=-150,$    ;histogram (xaxis) min
                          xmax=50,$ ;histogram (xaxis) max
                          yrange=[2,7],$
                          xrange=[-150,50],$
                          minc_vals=0.,$
                          maxc_vals=10,$
                          minc_peaks=1.,$
                          maxc_peaks=150,$
                          minc_cnt=1.,$
                          maxc_cnt=1000.,$
                          text=text,title=title,cbtitle=cbtitle,cb2title=cb2title,$
                          ps=1,$
                          formatleft='(F5.1)',$
                          formatright='(I9)',$
                          nvformatleft=5,$
                          nvformatright=5,$
                          lineplots=0




;;--------------------------------------------------
;;MLT (yaxis) vs AE (xaxis)
;;--------------------------------------------------


;;Get a different grid for the f_fce plots
dlshell = 5                   ;delta-Lshell for grid
lmin = 2
lmax = 7
dtheta = 1                     ;delta-theta (hours) for grid
tmin = 0.
tmax = 12.

rbsp_survey_fbk_return_grid,info,dtheta,dlshell,lmin,lmax,tmin,tmax

                                ;-----------------------------------------------
                                ;...plot the % times for all bins
title = 'Amp>' + string(info.minamp_pk,format='(f4.1)') + units + '!C'+$
        'Lmin='+strtrim(lmin,2)+',Lmax='+strtrim(lmax,2)+',dL='+strtrim(dlshell,2)
cbtitle = '% time'
cb2title = 'peak value [mV/m]'
                                ;-----------------------------------------------

rbsp_survey_contour_plots,info,$
                          fstr='0110',$ ;frequency subset
                          yaxis='rbsp'+info.probe+'_mlt',$
                          xaxis='rbsp'+info.probe+'_ae',$
                          nbins=10,$  ;number of histogram (xaxis) bins
                          xmin=0,$    ;histogram (xaxis) min
                          xmax=1000,$ ;histogram (xaxis) max
                          yrange=[0,12],$
                          xrange=[0,1000],$
                          minc_vals=0.,$
                          maxc_vals=20,$
                          minc_peaks=0.,$
                          maxc_peaks=150,$
                          minc_cnt=1.,$
                          maxc_cnt=1000.,$
                          text=text,title=title,cbtitle=cbtitle,cb2title=cb2title,$
                          ps=1,$
                          formatleft='(F5.1)',$
                          formatright='(I9)',$
                          nvformatleft=5,$
                          nvformatright=5,$
                          lineplots=0



;;--------------------------------------------------
;;Lshell (yaxis) vs AE (xaxis)
;;--------------------------------------------------


;;Get a different grid for the f_fce plots
dlshell = 0.5                   ;delta-Lshell for grid
lmin = 2
lmax = 7
dtheta = 24                     ;delta-theta (hours) for grid
tmin = 0.
tmax = 24.

rbsp_survey_fbk_return_grid,info,dtheta,dlshell,lmin,lmax,tmin,tmax

                                ;-----------------------------------------------
                                ;...plot the % times for all bins
title = 'Amp>' + string(info.minamp_pk,format='(f4.1)') + units + '!C'+$
        'MLTmin='+strtrim(tmin,2)+',MLTmax='+strtrim(tmax,2)+',dMLT='+strtrim(dtheta,2)
cbtitle = '% time'
cb2title = 'peak value [mV/m]'
                                ;-----------------------------------------------

rbsp_survey_contour_plots,info,$
                          fstr='0110',$ ;frequency subset
                          yaxis='rbsp'+info.probe+'_lshell',$
                          xaxis='rbsp'+info.probe+'_ae',$
                          nbins=20,$  ;number of histogram (xaxis) bins
                          xmin=0,$    ;histogram (xaxis) min
                          xmax=1000,$ ;histogram (xaxis) max
                          yrange=[2,8],$
                          xrange=[0,1000],$
                          minc_vals=0.,$
                          maxc_vals=20,$
                          minc_peaks=2.,$
                          maxc_peaks=100,$
                          minc_cnt=1.,$
                          maxc_cnt=500.,$
                          text=text,title=title,cbtitle=cbtitle,cb2title=cb2title,$
                          ps=1,$
                          formatleft='(F5.1)',$
                          formatright='(I9)',$
                          nvformatleft=5,$
                          nvformatright=5,$
                          lineplot=0




;;--------------------------------------------------
;;MLT (yaxis) vs DST (xaxis)
;;--------------------------------------------------


;;Get a different grid for the f_fce plots
dlshell = 5                   ;delta-Lshell for grid
lmin = 2
lmax = 7
dtheta = 1                     ;delta-theta (hours) for grid
tmin = 0.
tmax = 12.

rbsp_survey_fbk_return_grid,info,dtheta,dlshell,lmin,lmax,tmin,tmax

                                ;-----------------------------------------------
                                ;...plot the % times for all bins
title = 'Amp>' + string(info.minamp_pk,format='(f4.1)') + units + '!C'+$
        'Lmin='+strtrim(lmin,2)+',Lmax='+strtrim(lmax,2)+',dL='+strtrim(dlshell,2)
cbtitle = '% time'
cb2title = 'peak value [mV/m]'
                                ;-----------------------------------------------

rbsp_survey_contour_plots,info,$
                          fstr='0110',$ ;frequency subset
                          yaxis='rbsp'+info.probe+'_mlt',$
                          xaxis='rbsp'+info.probe+'_dst',$
                          nbins=20,$  ;number of histogram (xaxis) bins
                          xmin=-150,$    ;histogram (xaxis) min
                          xmax=50,$ ;histogram (xaxis) max
                          yrange=[0,12],$
                          xrange=[-150,50],$
                          minc_vals=0.,$
                          maxc_vals=20,$
                          minc_peaks=2.,$
                          maxc_peaks=100,$
                          minc_cnt=1.,$
                          maxc_cnt=500.,$
                          text=text,title=title,cbtitle=cbtitle,cb2title=cb2title,$
                          ps=1,$
                          formatleft='(F5.1)',$
                          formatright='(I9)',$
                          nvformatleft=5,$
                          nvformatright=5,$
                          lineplot=0







;; ------------------------------------------------------------------
;; Plot the number of counts (z-axis) for amplitude (y-axis) vs freq (x-axis)
;; ------------------------------------------------------------------

lshellr = [2,7]
mltr = [0,24]

title = 'Lshells='+strtrim(lshellr[0],2)+'-'+strtrim(lshellr[1],2)+'!C'+$
        'MLTs='+strtrim(mltr[0],2)+'-'+strtrim(mltr[1],2)

rbsp_survey_fbk_ampfreq_2dhist_bin,info,mltr,lshellr,$
                                   type='pk',$
                                   yrange=[2,100.],$
                                   minc_vals=0,$
                                   maxc_vals=20000.,$
                                   text=text,title=title,$
                                   ps=1,$
                                   formatleft='(I5)',$
                                   formatright='(I12)',$
                                   nvformatleft=5,$
                                   nvformatright=5,$
                                   cbtitle='counts'

















;---------------------------------------------------------------------
;FOR EACH AMPLITUDE: Find the %-time in each sector for d0 to d1. This puts the data into
;info.percentoccurrence_bin, so only select a single one of these
;---------------------------------------------------------------------



dlshell = 0.5                   ;delta-Lshell for grid
lmin = 2
lmax = 7
dtheta = 1.                     ;delta-theta (hours) for grid
tmin = 0.
tmax = 24.


rbsp_survey_fbk_return_grid,info,dtheta,dlshell,lmin,lmax,tmin,tmax



fstr = '0110'
rbsp_survey_fbk_percenttime_bin_amphist,info,fstr ;,/combinesc


if info.combined_sc eq 0 then text = '% occurrence of FBK peak values ('+strtrim(floor(info.dt),2)+$
                                     ' sec chunks)!Cin each sector for!C'+'RBSP-'+strupcase(info.probe) + $
                                     '!C'+info.D0+' to '+info.D1+'!Cfor freq range '+fstr
if info.combined_sc eq 1 then text = '% occurrence of FBK peak values ('+strtrim(floor(info.dt),2)+$
                                     ' sec chunks)!Cin each sector for!C'+'both sc' + $
                                     '!C'+info.D0+' to '+info.D1+'!Cfor freq range '+fstr
text = text + textadd


                                ;-----------------------------------------------
                                ;...plot the % times for all bins
title = 'Amp>' + string(info.minamp_pk,format='(f4.1)') + units + ','
cbtitle = '% time'
;; if info.fbk_mode eq '13' then values = 100.*info.percentoccurrence_ampbin.percent_amppeaks[*,*,4]
if info.fbk_mode eq '13' then values = 100.*info.percentoccurrence_ampbin.percent_amppeaks

;; if info.fbk_mode eq '7' then values = 100.*info.percentoccurrence_bin.percent_peaks
counts = info.percentoccurrence_ampbin.counts
                                ;-----------------------------------------------


rbsp_survey_fbk_dial_plot_allamps,info,values,counts,$
                     minc_vals=0.1,$
                     maxc_vals=1.,$
                     minc_cnt=1.,$
                     maxc_cnt=5000.,$
                     text=text,title=title,cbtitle=cbtitle,$
                     ps=0,$
                     formatleft='(F6.1)',$
                     formatright='(G8.1)',$
                     nvformatleft=5,$
                     nvformatright=5






;;--------------------------------------------------
;;Lshell (yaxis) vs DST (xaxis)   (broken down by amp)
;;--------------------------------------------------


;;Get a different grid for the f_fce plots
dlshell = 0.5                   ;delta-Lshell for grid
lmin = 2
lmax = 7
dtheta = 24                     ;delta-theta (hours) for grid
tmin = 0.
tmax = 24.

rbsp_survey_fbk_return_grid,info,dtheta,dlshell,lmin,lmax,tmin,tmax

                                ;-----------------------------------------------
                                ;...plot the % times for all bins
title = 'Amp>' + string(info.minamp_pk,format='(f4.1)') + units + '!C'+$
        'MLTmin='+strtrim(tmin,2)+',MLTmax='+strtrim(tmax,2)+',dMLT='+strtrim(dtheta,2)

cbtitle = '% time'
cb2title = 'peak value [mV/m]'
                                ;-----------------------------------------------

rbsp_survey_contour_plots_allamps,info,$
                          fstr='0110',$ ;frequency subset
                          yaxis='rbsp'+info.probe+'_lshell',$
                          xaxis='rbsp'+info.probe+'_dst',$
                          nbins=10,$  ;number of histogram (xaxis) bins
                          xmin=-150,$    ;histogram (xaxis) min
                          xmax=50,$ ;histogram (xaxis) max
                          yrange=[2,7],$
                          xrange=[-150,50],$
                          minc_vals=0.,$
                          maxc_vals=1,$
                          minc_cnt=1.,$
                          maxc_cnt=1000.,$
                          text=text,title=title,cbtitle=cbtitle,cb2title=cb2title,$
                          ps=1,$
                          formatleft='(F5.1)',$
                          formatright='(I9)',$
                          nvformatleft=5,$
                          nvformatright=5,$
                          lineplots=0




;;--------------------------------------------------
;;MLT (yaxis) vs DST (xaxis)   (broken down by amp)
;;--------------------------------------------------


;;Get a different grid for the f_fce plots
dlshell = 5                   ;delta-Lshell for grid
lmin = 2
lmax = 7
dtheta = 1                     ;delta-theta (hours) for grid
tmin = 0.
tmax = 12.

rbsp_survey_fbk_return_grid,info,dtheta,dlshell,lmin,lmax,tmin,tmax

                                ;-----------------------------------------------
                                ;...plot the % times for all bins
title = 'Amp>' + string(info.minamp_pk,format='(f4.1)') + units + '!C'+$
        'Lmin='+strtrim(lmin,2)+',Lmax='+strtrim(lmax,2)+',dL='+strtrim(dlshell,2)

cbtitle = '% time'
cb2title = 'peak value [mV/m]'
                                ;-----------------------------------------------

rbsp_survey_contour_plots_allamps,info,$
                          fstr='0110',$ ;frequency subset
                          yaxis='rbsp'+info.probe+'_mlt',$
                          xaxis='rbsp'+info.probe+'_dst',$
                          nbins=10,$  ;number of histogram (xaxis) bins
                          xmin=-150,$    ;histogram (xaxis) min
                          xmax=50,$ ;histogram (xaxis) max
                          yrange=[0,12],$
                          xrange=[-150,50],$
                          minc_vals=0.,$
                          maxc_vals=1,$
                          ;; minc_peaks=1.,$
                          ;; maxc_peaks=150,$
                          minc_cnt=1.,$
                          maxc_cnt=1000.,$
                          text=text,title=title,cbtitle=cbtitle,cb2title=cb2title,$
                          ps=0,$
                          formatleft='(F5.1)',$
                          formatright='(I9)',$
                          nvformatleft=5,$
                          nvformatright=5,$
                          lineplots=0















                                ;----------------------------------------------
                                ;Plot the amplitude and frequency
                                ;distributions (***create the option
                                ;of stacking all of these in a single call***)
                                ;----------------------------------------------



;;****THESE DON'T WORK AT THE MOMENT
rbsp_survey_fbk_pk_vs_avg_plot,info
rbsp_survey_fbk_pk_vs_mlat,info,text=text,title=title
rbsp_survey_fbk_freqdist_bin,info,mltr,lshellr













;	;---------------------------------------------
;	;Compare Ew and Bw plots
;	;---------------------------------------------
;
;	;Directions: Run the crib for FBK7 Ew. Save the data
;	;			 Do the same for FBK7 Bw. Save the data
;	;			 Restore these save files and run below code
;
;	save,info,nfbk_pk,npk_percent,filename='~/Desktop/code/Aaron/datafiles/rbsp/survey_data/Ew_for_Ew_Bw_compare.idl'
;	save,info,nfbk_pk,npk_percent,filename='~/Desktop/code/Aaron/datafiles/rbsp/survey_data/Bw_for_Ew_Bw_compare.idl'











;**************************************************************************************************
;Testing difference b/t FBK13 and FBK13 with every other bin removed to imitate FBK7...i.e. "FBK7"
;**************************************************************************************************

;Directions: run the crib for FBK13 and save the tplot variables
;	nfbk_pk, nfbk_percent'
;Do the same for "FBK7". Note that there are some lines you need to comment out
;in rbsp_survey_fbk_create_ascii.pro at beginning and end of code.


get_data,'nfbk_pk',data=nfbk_pk
get_data,'npk_percent',data=npk_percent

save,info,nfbk_pk,npk_percent,filename='~/Desktop/code/Aaron/datafiles/rbsp/survey_data/fbk7_percent'
save,info,nfbk_pk,npk_percent,filename='~/Desktop/code/Aaron/datafiles/rbsp/survey_data/fbk13_percent'

restore,'~/Desktop/code/Aaron/datafiles/rbsp/survey_data/fbk13_percent'
store_data,'nfbk_pko',data=nfbk_pk
store_data,'npk_percento',data=npk_percent

restore,'~/Desktop/code/Aaron/datafiles/rbsp/survey_data/fbk7_percent'
store_data,'nfbk_pka',data=nfbk_pk
store_data,'npk_percenta',data=npk_percent

tplot,['nfbk_pko','nfbk_pka']
dif_data,'npk_percento','npk_percenta',newname='perdiff'
dif_data,'nfbk_pko','nfbk_pka',newname='nfbkdiff'

ylim,'perdiff',0,1
options,'npk_percento','ytitle','% occurrence!CFBK13'
options,'npk_percenta','ytitle','% occurrence!CFBK7'
options,'perdiff','ytitle','%FBK13 - %FBK7'

tplot,['npk_percento','npk_percenta','perdiff']

get_data,'nfbk_pko',data=pko
get_data,'nfbk_pka',data=pka
get_data,'nfbkdiff',data=nfbkdiff
get_data,'npk_percento',data=perco
get_data,'npk_percenta',data=perca
get_data,'perdiff',data=perdiff

print,100.*total(perdiff.y)/total(perco.y)
print,100.*total(nfbkdiff.y)/total(pko.y)

;Here's the percent of the overall FBK13 that "FBK7" sees
print,100.*(1-total(nfbkdiff.y)/total(pko.y))


;**************************************************************************************************
;END: Testing difference b/t FBK13 and FBK13 with every other bin removed to imitate FBK7...i.e. "FBK7"
;**************************************************************************************************





























;******************************************
;SHOULD BE OBSOLETE  -- START
;******************************************


;First, create a save file with these tplot variables for both FBK13 and "FBK7"
;'fbk_maxamp_orig'
;'fbk_maxamp_adj'
;'fbk_freq_of_max_orig'
;'fbk_freq_of_max_adj'
;These are the outputs of rbsp_efw_fbk_freq_interpolate.pro




;get_data,'fbk_maxamp_orig',data=mao
;get_data,'fbk_maxamp_adj',data=maa
;get_data,'fbk_freq_of_max_orig',data=fomo
;get_data,'fbk_freq_of_max_adj',data=foma

;save,mao,maa,fomo,foma,filename='~/Desktop/code/Aaron/datafiles/rbsp/survey_data/fbk_fullsav2'
;save,mao,maa,fomo,foma,filename='~/Desktop/code/Aaron/datafiles/rbsp/survey_data/fbk_reducedsav2'


;FBK13
restore,'~/Desktop/code/Aaron/datafiles/rbsp/survey_data/fbk_fullsav2'
store_data,'fbk_maxamp_orig1',data=mao
store_data,'fbk_maxamp_adj1',data=maa
store_data,'fbk_freq_of_max_orig1',data=fomo
store_data,'fbk_freq_of_max_adj1',data=foma
;"FBK7"
restore,'~/Desktop/code/Aaron/datafiles/rbsp/survey_data/fbk_reducedsav2'
store_data,'fbk_maxamp_orig2',data=mao
store_data,'fbk_maxamp_adj2',data=maa
store_data,'fbk_freq_of_max_orig2',data=fomo
store_data,'fbk_freq_of_max_adj2',data=foma


dif_data,'fbk_maxamp_orig1','fbk_maxamp_orig2',newname='maxamp_orig_diff'
ylim,['fbk_maxamp_orig1','fbk_maxamp_orig2','maxamp_orig_diff'],0,150
tplot,['fbk_maxamp_orig1','fbk_maxamp_orig2','maxamp_orig_diff']

dif_data,'fbk_maxamp_adj1','fbk_maxamp_adj2',newname='maxamp_adj_diff'
ylim,['fbk_maxamp_adj1','fbk_maxamp_adj2','maxamp_adj_diff'],0,150
tplot,['fbk_maxamp_adj1','fbk_maxamp_adj2','maxamp_adj_diff']


;Eliminate amps < amin mV/m
amin = 5.
get_data,'fbk_maxamp_adj1',data=tmp
goo = where(tmp.y le amin)
if goo[0] ne -1 then tmp.y[goo] = 0
store_data,'fbk_maxamp_adj1r',data=tmp

get_data,'fbk_maxamp_adj2',data=tmp
goo = where(tmp.y le amin)
if goo[0] ne -1 then tmp.y[goo] = 0
store_data,'fbk_maxamp_adj2r',data=tmp

tplot,['fbk_maxamp_adj1','fbk_maxamp_adj2']

;Make all values > amin mV/m into unity value
get_data,'fbk_maxamp_adj1r',data=tmp
goo = where(tmp.y ge amin)
if goo[0] ne -1 then tmp.y[goo] = 1
store_data,'fbk_maxamp_adj1rr',data=tmp

get_data,'fbk_maxamp_adj2r',data=tmp
goo = where(tmp.y ge amin)
if goo[0] ne -1 then tmp.y[goo] = 1
store_data,'fbk_maxamp_adj2rr',data=tmp


dif_data,'fbk_maxamp_adj1rr','fbk_maxamp_adj2rr',newname='adj_diff'


ylim,['fbk_maxamp_adj1rr','fbk_maxamp_adj2rr','adj_diff'],0,2
ylim,'adj_diff',-2,2
tplot,['fbk_maxamp_adj1rr','fbk_maxamp_adj2rr','adj_diff']


;Find totals
get_data,'fbk_maxamp_adj1rr',data=adj1rr
get_data,'fbk_maxamp_adj2rr',data=adj2rr
get_data,'adj_diff',data=adj_diff

print,total(adj1rr.y,/nan)
print,total(adj2rr.y,/nan)
print,total(abs(adj_diff.y),/nan)



;Reduce the full FBK data to nchunks, just as percenttime_bin would

nchunks = 1440.
dt = 60.
finaldato = fltarr(nchunks)
finaldata = fltarr(nchunks)
i = 0
j = 8.*60.
t0 = fltarr(nchunks)
t1 = fltarr(nchunks)

for qq=0,nchunks-1 do begin		$
;	finaldat[qq] = total(adj_diff.y[i:j])   & $
   finaldato[qq] = total(adj1rr.y[i:j])   & $
   finaldata[qq] = total(adj2rr.y[i:j])   & $
   t0[qq] = i/8.		& $
   t1[qq] = j/8.		& $
   i+= 8*60.		& $
   j+= 8*60.		& $
   print,i,j

;good values in 1440 bins
   finaldato2 = finaldato
   goo = where(finaldato ge 1)
   finaldato2[goo] = 1

   finaldata2 = finaldata
   goo = where(finaldata ge 1)
   finaldata2[goo] = 1



;Values common to the original FBK13 and the FBK13->FBK7 will have value = 2.
   finaldatcomb = finaldato2 + finaldata2

   goo = where(finaldatcomb eq 1)
   permissed = 100.*n_elements(goo)/n_elements(finaldatcomb)
   goo = where(finaldato2 eq 1)
   perhito = 100.*n_elements(goo)/n_elements(finaldato2)
   goo = where(finaldata2 eq 1)
   perhita = 100.*n_elements(goo)/n_elements(finaldata2)

   print,'% of FBK13 bins with a "hit" = ',perhito
   print,'% of "FBK7" bins with a "hit" = ',perhita
   print,'% of bins messed up b/c of FBK13 -> FBK7 transition = ',permissed

;Remove the times when both the FBK13 and the "FBK7" have a hit each chunk
   goo = where(finaldatcomb eq 2)
   finaldatcomb[goo] = 0


   t0 = time_double('2012-10-13') + double(t0)
   t1 = time_double('2012-10-13') + double(t1)

   store_data,'finaldato2',data={x:t0,y:finaldato2}
   store_data,'finaldata2',data={x:t0,y:finaldata2}
   store_data,'finaldat2',data={x:t0,y:finaldatcomb}

   ylim,['finaldato2','finaldata2','finaldat2'],0,2

   options,['finaldato2','finaldata2','finaldat2'],'psym',2

   options,'finaldato2','ytitle','Original!CFBK13!Chas hit'
   options,'finaldata2','ytitle','Modified!CFBK13->FBK7!Chas hit'
   options,'finaldat2','ytitle','Modified!CFBK13 misses value!Cthat original!CFBK13 hits'

   tplot,['finaldato2','finaldata2','finaldat2']



   get_data,'fbk_maxamp_adj1rr',data=adj1rr
   tinterpol_mxn,'finaldat2',adj1rr.x,newname='finaldat3'

   ylim,'finaldat3',0,1
   tplot,['fbk_maxamp_adj1rr','fbk_maxamp_adj2rr','adj_diff','finaldat3']

   get_data,'finaldat3',data=fd3
   print,total(fd3.y,/nan)


;******************************************
;SHOULD BE OBSOLETE  -- FINISH
;******************************************













   restore,'~/Desktop/code/Aaron/datafiles/rbsp/survey_data/fbk_fullsav'
   info_full = info
   restore,'~/Desktop/code/Aaron/datafiles/rbsp/survey_data/fbk_reducedsav'
   info_red = info


   dfull = info_full.percentoccurrence_bin.PERCENT_PEAKS
   cfull = info_full.percentoccurrence_bin.COUNTS

   dred = info_red.percentoccurrence_bin.PERCENT_PEAKS
   cred = info_red.percentoccurrence_bin.COUNTS


   values = 100.*(dfull - dred)
;values = 100.*info.percentoccurrence_bin.percent_peaks[*,*]
   text = 'difference in %time b/t full FBK13 and FBK13 reduced to 7 bins'
   cbtitle = 'diff in %'

   counts = info.percentoccurrence_bin.counts
   rbsp_survey_fbk_dial_plot,info,values,counts,$
                        minc_vals=0.1,$
                        maxc_vals=5,$
                        minc_cnt=1,$
                        maxc_cnt=120,$
                        text=text,title=title,cbtitle=cbtitle








;******************************************
;REDUCE DATA FOR TESTING

   tlimit,'2012-10-15/20:00',,'2012-10-15/20:18'
   tplot,'npk_percent'

   get_data,'npk_percent',data=dat

   t0 = time_double('2012-10-15/20:00')
   t1 = time_double('2012-10-15/20:18')

   goo = where((dat.x ge t0) and (dat.x le t1))

   store_data,'tst',data={x:dat.x[goo],y:dat.y[goo]}

   get_data,'tst',data=dat


;*****************************************
