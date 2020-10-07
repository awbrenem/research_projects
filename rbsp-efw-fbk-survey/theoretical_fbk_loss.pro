;Determine theoretically how much smaller the FBK values are expected to be than the 
;burst waveform values because of the soft rolloff FBK curves.

;This result will be compared to a comparison b/t FBK and actual burst waveform data. 

;How is FBK data created. 
;	1) signal divided into 13 bins
;	2) only the gain curve for each single bin is applied to that bin, NOT the cumulative
;		total of all gain curves. 




rbsp_efw_init

;Restore gain curves and grab freqs
	restore,'~/Desktop/code/Aaron/datafiles/rbsp/FBK_gain_curves/RBSP_FilterBank_Theoretical_Rsponse_wE12ACmeasuredResponse_DMM_20130305.sav'

	fcals = rbsp_efw_get_gain_results()
	fbk13_freqs = fcals.cal_fbk.freq_fbk13c
	fbk13_freqsL = fcals.cal_fbk.freq_fbk13l
	fbk13_freqsH = fcals.cal_fbk.freq_fbk13h

	gcm = FB_THEORETICAL_GAINRESPONSE_E12ACMEASUREDRESPONSECONVOLVED
	gcu = FB_THEORETICAL_GAINRESPONSE_UNITYGAIN10KHZ


;Plot the gain curves

	window, 0
	 plot,  freq , 20d * alog10(gcu[*,0] ), yrange = [-70,1], /xlog, /xs,xrange = [0.1, 1d4], /ystyle, $
	   background = 255, color = 0 , thick = 2, xtitle = 'Hz', ytitle = 'dB', $
	   title = 'Filter Banks Theoretical Response (Unity gain at 10kHz)'
	 for kk = 1, ncascades-1, 1 do oplot, freq, 20d * alog10(gcu[*,kk]), color = kk*20 + 20, thick = 2

	window, 1
	 plot,  freq , 20d * alog10(gcm[*,0]), yrange = [-70,1], /xlog, /xs,xrange = [0.1, 1d4], /ystyle, $
	   background = 255, color = 0 , thick = 2, xtitle = 'Hz', ytitle = 'dB', $
	   title = 'Filter Banks Theoretical Response, E12AC measured response convolved '
	 for kk = 1, ncascades-1, 1 do oplot, freq, 20d * alog10(gcm[*,kk]), color = kk*20 + 20, thick = 2



;Since the FBK data are already calibrated, normalize each curve to itself
	gcu2 = gcu
	for i=0,12 do gcu2[*,i] = gcu2[*,i]/max(gcu2[*,i])

	window, 0
	 plot,  freq , gcu2[*,0], yrange = [0,1], /xlog, /xs,xrange = [0.1, 1d4], /ystyle, $
	   background = 255, color = 0 , thick = 2, xtitle = 'Hz', ytitle = 'dB', $
	   title = 'Filter Banks Theoretical Response (Unity gain at 10kHz)'
	 for kk = 1, ncascades-1, 1 do oplot, freq,gcu2[*,kk], color = kk*20 + 20, thick = 2

;Assuming a signal with constant power as a function of freq, what % of this
;will be lost when the gain curves are applied?

	amp = replicate(1,n_elements(freq))
	amp2 = fltarr(n_elements(freq),13)

	for i=0,12 do amp2[*,i] = amp*gcu2[*,i]


	tunity = fltarr(13)
	nelem = fltarr(13)
	tsignal = fltarr(13)


	for i=0,12 do begin     $
		fl = fbk13_freqsL[12-i]		& $
		fh = fbk13_freqsH[12-i]	& $
		goo = where((freq ge fl) and (freq le fh),n)  & $
		tunity[i] = total(amp[goo])   & $
		tsignal[i] = total(amp2[goo,i])  & $
		nelem[i] = n


	plot,reverse(fbk13_freqs),tunity/nelem,/xlog,yrange=[0,1.2]
	oplot,reverse(fbk13_freqs),tsignal/nelem,color=250

;This is what we should multiply each freq bin by to correct the FBK data due to the 
;soft rolloff filter (assuming unity input signal). This is a good assumption
;for broadband emission
	
	ratio = tunity/tsignal



window, 0
 plot,  freq ,amp2[*,0] , yrange = [0,1.5], /xlog, /xs,xrange = [1, 1d4], /ystyle, $
   background = 255, color = 0 , thick = 2, xtitle = 'Hz', ytitle = 'amp', $
   title = ''
 for kk = 1, ncascades-1, 1 do oplot, freq,amp2[*,kk], color = kk*20 + 20, thick = 2
; oplot,freq,ptots3



;Calculate the theoretical chorus bandwidth (Bunch13)

fce_th = 2*fbk13_freqs
dw_min = 0.04*fce_th
dw_max = 0.09*fce_th

      
;Wow, the FBK13 bin width is nearly exactly the same as the predicted
;chorus bandwidth (Bunch13) based on FBK center frequencies
;I wonder if the FBK bin width was set up with this in mind

;RBSP_EFW> for i=0,13 do print,i,fbk13_freqsl[i],fbk13_freqsh[i],'|',dw_min[i+3],dw_max[i+3]
;
;	   i)     fbk13_min		fbk13_max	fmin_chorus	  fmax_chorus
;       0     0.800000      1.50000|     0.720000      1.62000
;       1      1.50000      3.00000|      1.48000      3.33000
;       2      3.00000      6.00000|      3.00000      6.75000
;       3      6.00000      12.0000|      6.00000      13.5000
;       4      12.0000      25.0000|      12.0000      27.0000
;       5      25.0000      50.0000|      24.0000      54.0000
;       6      50.0000      100.000|      48.0000      108.000
;       7      100.000      200.000|      96.0000      216.000
;       8      200.000      400.000|      192.000      432.000
;       9      400.000      800.000|      388.000      873.000


window, 0
 plot,  freq ,amp2[*,0] , yrange = [0,1],/xlog, /xs,xrange = [1,1d4], /ystyle, $
   background = 255, color = 0 , thick = 2, xtitle = 'Hz', ytitle = 'amp', $
   title = ''
 for kk = 1, ncascades-1, 1 do oplot, freq,amp2[*,kk], color = kk*20 + 20, thick = 2




;----------------------------------------------------------------

;With the previous observation that the chorus theoretical Gaussian bandwidth is nearly the same
;as the FBK 13 bin size, let's assume that the peak of the Gaussian is randomly distributed
;b/t the peak of FBK bin x and FBK bin x+1. If this is the case then we can determine the
;necessary scaling factor for each curve by computing the ratio of the area of a square box
;(unity gain curve) with the area of the actual gain curve. 


;0 - 1.7, ch12, ratio_area = xx
;1.7 - 3.5, ch11, ratio_area = 1.118
;3.5 - 7, ch10, ratio_area = 1.111
;7 - 14, ch9, incompatible freq dfs
;14 - 28, ch8, ratio_area = 1.077
;28 - 57, ch7, ratio_area = 1.092
;57 - 113, ch6, ratio_area = 1.412
;113 - 225, ch5, ratio_area = 1.116
;225 - 455, ch4, ratio_area = 1.145
;455 - 910, ch3, ratio_area = 1.118
;910 - 1850, ch2, incompatible freq dfs
;1850 - 4060, ch1, ratio_area = 1.181
;4060 - 8192, ch0, ratio_area = 1.135

ra = [!values.f_nan,1.118,1.111,!values.f_nan,1.077,1.092,1.412,1.116,1.145,1.118,!values.f_nan,1.181,1.135]
;RBSP_EFW> print,mean(ra,/nan)
;      1.15050


	f0 = 0.
	f1 = 1.7
	ch = 12


    goo = where((freq ge f0) and (freq le f1)) 


	;Determine delta-f
	df = freq[goo] - shift(freq[goo],1)
	print,df
	df = 0.018

	sq_h =  amp2[goo,ch]	
	sq_area = df * sq_h
	
	tr_h = abs(shift(sq_h,1) - sq_h)
	tr_area = (tr_h * df)/2.

	area = total(sq_area + tr_area)
	area_unity = (f1 - f0)*1

	ratio_area = area_unity/area
	print,ratio_area



;--------------------------------------------------------------------
;Now compare burst data to the original and corrected FBK data
;--------------------------------------------------------------------

charsz_plot = 0.8  ;character size for plots
charsz_win = 1.2  
!p.charsize = charsz_win
tplot_options,'xmargin',[20.,16.]
tplot_options,'ymargin',[3,9]
tplot_options,'xticklen',0.08
tplot_options,'yticklen',0.02
tplot_options,'xthick',2
tplot_options,'ythick',2
tplot_options,'labflag',-1	
	


;Compare the FBK data to the B2 data on Sep 19, 2012  (2335:33-40)

	;date = '2012-09-19'
	;t0 = time_double(date + '/' + '18:40:59')
	;t1 = time_double(date + '/' + '18:41:05')

	;date = '2012-09-19'
	;t0 = time_double(date + '/' + '18:16:04')
	;t1 = time_double(date + '/' + '18:16:10')

	;date = '2012-09-19'
	;t0 = time_double(date + '/' + '16:51:30')
	;t1 = time_double(date + '/' + '16:51:36')

	;date = '2012-09-19'
	;t0 = time_double(date + '/' + '16:40:13')
	;t1 = time_double(date + '/' + '16:40:19')

	date = '2012-12-15'
	t0 = time_double(date + '/' + '04:03:15')
	t1 = time_double(date + '/' + '04:03:45')

	;date = '2012-12-15'
	;t0 = time_double(date + '/' + '13:03:50')
	;t1 = time_double(date + '/' + '13:04:30')

	;date = '2012-12-15'
	;t0 = time_double(date + '/' + '20:05:17')
	;t1 = time_double(date + '/' + '20:05:19')



	trange = timerange([t0,t1])
	bl = rbsp_efw_boom_deploy_history(trange[0])


	timespan,date

	rbsp_load_efw_waveform,probe=probe,type='calibrated',coord='uvw',datatype='vb2';,/noclean
	rbsp_load_efw_fbk,probe=probe,type='calibrated'
	rbsp_split_fbk,probe


;Create the E12 data from V1 and V2 (no Eb2 data on this day)

	split_vec,'rbspa_efw_vb2'
	get_data,'rbspa_efw_vb2_0',data=V1
	get_data,'rbspa_efw_vb2_1',data=V2

	e12 = 1000*(V1.y - V2.y)/bl.a12		;mV/m
	store_data,'e12',data={x:V1.x,y:e12}

	tplot,['e12','rbspa_fbk1_13pk_11']
	tlimit,t0,t1

;Reduce FBK data to burst times

	dat5 = tsample('rbspa_fbk1_13pk_5',[t0,t1],times=tms)   
	dat6 = tsample('rbspa_fbk1_13pk_6',[t0,t1],times=tms)   
	dat7 = tsample('rbspa_fbk1_13pk_7',[t0,t1],times=tms)   
	dat8 = tsample('rbspa_fbk1_13pk_8',[t0,t1],times=tms)   
	dat9 = tsample('rbspa_fbk1_13pk_9',[t0,t1],times=tms)   
	dat10 = tsample('rbspa_fbk1_13pk_10',[t0,t1],times=tms)   
	dat11 = tsample('rbspa_fbk1_13pk_11',[t0,t1],times=tms)   
	dat12 = tsample('rbspa_fbk1_13pk_12',[t0,t1],times=tms)   

;Apply time and y-axis offset 

	toffset = 0.06  ;msec correction to fbk data
	yoffset = 0.05  ;remove the y-offset
	store_data,'rbspa_fbk1_13pk_5',data={x:tms-toffset,y:dat5-yoffset}
	store_data,'rbspa_fbk1_13pk_6',data={x:tms-toffset,y:dat6-yoffset}
	store_data,'rbspa_fbk1_13pk_7',data={x:tms-toffset,y:dat7-yoffset}
	store_data,'rbspa_fbk1_13pk_8',data={x:tms-toffset,y:dat8-yoffset}
	store_data,'rbspa_fbk1_13pk_9',data={x:tms-toffset,y:dat9-yoffset}
	store_data,'rbspa_fbk1_13pk_10',data={x:tms-toffset,y:dat10-yoffset}
	store_data,'rbspa_fbk1_13pk_11',data={x:tms-toffset,y:dat11-yoffset}
	store_data,'rbspa_fbk1_13pk_12',data={x:tms-toffset,y:dat12-yoffset}



;Create combined FBK plot

	totso = (dat5+dat6+dat7+dat8+dat9+dat10+dat11+dat12) - 8*yoffset
	store_data,'rbspa_fbk1_13pk_A',data={x:tms-toffset,y:totso}
	store_data,'comb_A',data=['e12','rbspa_fbk1_13pk_A']
	options,'comb_A','colors',[0,0]
	tplot,'comb_A'


	get_data,'rbspa_fbk1_13pk_12',data=d12
	get_data,'rbspa_fbk1_13pk_11',data=d11
	get_data,'rbspa_fbk1_13pk_10',data=d10
	get_data,'rbspa_fbk1_13pk_9',data=d9
	get_data,'rbspa_fbk1_13pk_8',data=d8
	get_data,'rbspa_fbk1_13pk_7',data=d7
	get_data,'rbspa_fbk1_13pk_6',data=d6
	get_data,'rbspa_fbk1_13pk_5',data=d5



;add blanket correction factor

	fac = 1.15
	store_data,'rbspa_fbk1_13pk_12b',data={x:d12.x,y:d12.y*fac}
	store_data,'rbspa_fbk1_13pk_11b',data={x:d12.x,y:d11.y*fac}
	store_data,'rbspa_fbk1_13pk_10b',data={x:d12.x,y:d10.y*fac}
	store_data,'rbspa_fbk1_13pk_9b',data={x:d12.x,y:d9.y*fac}
	store_data,'rbspa_fbk1_13pk_8b',data={x:d12.x,y:d8.y*fac}
	store_data,'rbspa_fbk1_13pk_7b',data={x:d12.x,y:d7.y*fac}
	store_data,'rbspa_fbk1_13pk_6b',data={x:d12.x,y:d6.y*fac}
	store_data,'rbspa_fbk1_13pk_5b',data={x:d12.x,y:d5.y*fac}


	totso = (d5.y+d6.y+d7.y+d8.y+d9.y+d10.y+d11.y+d12.y)*fac
	store_data,'rbspa_fbk1_13pk_Ab',data={x:d12.x,y:totso}
	store_data,'comb_Ab',data=['e12','rbspa_fbk1_13pk_A','rbspa_fbk1_13pk_Ab']
	options,'comb_Ab','colors',[0,0,2]
	tplot,'comb_Ab'




;Correct each single FBK element with the interpolation routine

	dat12_2 = d12.y & dat11_2 = d11.y & dat10_2 = d10.y & dat9_2 = d9.y & dat8_2 = d8.y & dat7_2 = d7.y & dat6_2 = d6.y & dat5_2 = d5.y

	caf = fltarr(n_elements(tms))
	for i=0,n_elements(tms)-1 do begin   $ 
		amptmp = [dat5[i],dat6[i],dat7[i],dat8[i],dat9[i],dat10[i],dat11[i],dat12[i]]  & $
		val_bin = max(amptmp,wh)		& $
		bin = wh + 1		& $
		if wh ne 0 then val_binL = amptmp[wh-1] else val_binL = 5	& $
		if wh ne 7 then val_binH = amptmp[wh+1] else val_binH = 12	& $
		ca = 0.	& $
		x = rbsp_efw_fbk_freq_interpolate(bin,val_bin,val_binL,val_binH,correct_amp=ca,scale_fac_lim=100.15)	& $
		caf[i] = ca    & $
		if wh eq 0 then dat5_2[i] = ca  & $
		if wh eq 1 then dat6_2[i] = ca  & $
		if wh eq 3 then dat7_2[i] = ca  & $
		if wh eq 3 then dat8_2[i] = ca  & $
		if wh eq 4 then dat9_2[i] = ca  & $
		if wh eq 5 then dat10_2[i] = ca  & $
		if wh eq 6 then dat11_2[i] = ca  & $
		if wh eq 7 then dat12_2[i] = ca 


;corrected data

	store_data,'rbspa_fbk1_13pk_5c',data={x:d5.x,y:dat5_2}
	store_data,'rbspa_fbk1_13pk_6c',data={x:d6.x,y:dat6_2}
	store_data,'rbspa_fbk1_13pk_7c',data={x:d7.x,y:dat7_2}
	store_data,'rbspa_fbk1_13pk_8c',data={x:d8.x,y:dat8_2}
	store_data,'rbspa_fbk1_13pk_9c',data={x:d9.x,y:dat9_2}
	store_data,'rbspa_fbk1_13pk_10c',data={x:d10.x,y:dat10_2}
	store_data,'rbspa_fbk1_13pk_11c',data={x:d11.x,y:dat11_2}
	store_data,'rbspa_fbk1_13pk_12c',data={x:d12.x,y:dat12_2}

	totso = (dat5_2+dat6_2+dat7_2+dat8_2+dat9_2+dat10_2+dat11_2+dat12_2)
	store_data,'rbspa_fbk1_13pk_Ac',data={x:d12.x,y:totso}
	store_data,'comb_Ac',data=['e12','rbspa_fbk1_13pk_A','rbspa_fbk1_13pk_Ac']
	options,'comb_Ac','colors',[0,0,6]
	tplot,'comb_Ac'


;Compare the blanket method with the interpolate-corrected method

	store_data,'comball',data=['e12','rbspa_fbk1_13pk_A','rbspa_fbk1_13pk_Ab','rbspa_fbk1_13pk_Ac']	;corrected
	options,'comball','colors',[0,0,2,6]
	tplot_options,'title','Black=FBKorig!CBlue=FBKblanketcorrection(x1.15)!CRed=FBKfreq by freq correction(rbsp_efw_fbk_freq_interpolate.pro)'
	tplot,'comball'








	
	
	
	
	
	