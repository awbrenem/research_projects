;pro cross_spec_call



;NPM spec calls  09:06:53
;-----------------------------------------------------------------
Nspec = 32
lapping_index = 1


;ttmp = indgen(4096)*0.0328/(4096-1)
;
;step = 1/Nspec
;so = 1/float(lapping_index)

;tsst = get_slidespec_size(step,so,ttmp)
;help,tsst,/str

;print,'freq resolution = ',60000./tsst.freq_bins,' Hz'
;print,'time resolution = ',32./tsst.time_bins,' msec'



;wave_field=what ever your data is. wave_field[*,0] is time,  ;wave_field[*,1] is the data. 
;resample the field



rbsp_efw_init


;**************************************************************************************
;**************************************************************************************
;***TEMPORARY**** TEST THE RBSP STUFF
;First run test_tplot_rbsp_xspec_spec.pro

date = '2014-01-03'
timespan,date
probe = 'a'
rbsp_load_efw_spec,probe='a',type='calibrated'

trange = timerange()

fcals = rbsp_efw_get_gain_results()
fbinsL = fcals.cal_spec.freq_spec64L
fbinsH = fcals.cal_spec.freq_spec64H
bandw = fbinsH - fbinsL


tplot_options,'xmargin',[20.,16.]
tplot_options,'ymargin',[3,9]
tplot_options,'xticklen',0.08
tplot_options,'yticklen',0.02
tplot_options,'xthick',2
tplot_options,'ythick',2
tplot_options,'labflag',-1	
tplot_options,'thick',1


get_data,'rbsp'+probe+'_efw_64_spec2',data=bu2
get_data,'rbsp'+probe+'_efw_64_spec3',data=bv2
get_data,'rbsp'+probe+'_efw_64_spec4',data=bw2


bu2.y[*,0:2] = 0.
bv2.y[*,0:2] = 0.
bw2.y[*,0:2] = 0.

bu2.y[*,45:63] = 0.
bv2.y[*,45:63] = 0.
bw2.y[*,45:63] = 0.

nelem = n_elements(bu2.x)
bt = fltarr(nelem)


;Add up amplitude in all 64 bins and multiply each bin by a bandwidth
ball = bu2.y + bv2.y + bw2.y
for j=0L,nelem-1 do bt[j] = sqrt(total(ball[j,*]*bandw))  ;RMS method (Malaspina's method)


store_data,'Bfield_hissint',data={x:bu2.x,y:bt}
tplot,'Bfield_hissint'





payloads = '2I'
rbsp_load_barrel_lc,payloads,date,type='rcnt'

;Get rid of NaN values in the peak detector data. This messes up the downsampling
get_data,'PeakDet_2I',data=dd
goo = where(dd.y lt 0.)
if goo[0] ne -1 then dd.y[goo] = !values.f_nan
xv = dd.x
yv = dd.y
interp_gap,xv,yv
store_data,'PeakDet_2I',data={x:xv,y:yv}
options,'PeakDet_2I','colors',250



;get hiss and precip on same cadence
tinterpol_mxn,'PeakDet_2I','Bfield_hissint'


t0 = time_double('2014-01-03/19:30')
t1 = time_double('2014-01-03/22:30')

tplot,['PeakDet_2I','Bfield_hissint']
tlimit,t0,t1

p = tsample('PeakDet_2I',[t0,t1],times=pt)
h = tsample('Bfield_hissint',[t0,t1],times=ht)

wave_field = [[pt],[p]]
wave_field2 = [[ht[0:2618]],[h[0:2618]]]


;**************************************************************************************
;**************************************************************************************



;.compile ~/Desktop/Research/UMN_rocket/idllibs/codemgr/lib/libs/data/even_rate.pro
;E_times=Even_rate(wave_field[*,0])
;.compile ~/Desktop/Research/UMN_rocket/idllibs/codemgr/lib/libs/data/resample.pro
;wave_field=resample(wave_field,E_times,bad,/nan)



E_num=LONG64(n_elements(wave_field[*,0]))
Enfft=E_num/nspec

seconds=double(max(wave_field[*,0])-Min(wave_field[*,0]))
freqs=Nspec*findgen(Enfft/2+1)/seconds


;.compile ~/Desktop/code/Aaron/IDL/analysis/cross_spec
FFT_E_1=FFT_series(wave_field[*,1],seconds,Nspec,E_num,lapping_index)
Aver_Pow_E_1=Pow_Spectra(FFT_E_1,seconds,Nspec,E_num,lapping_index)

FFT_E_2=FFT_series(wave_field2[*,1],seconds,Nspec,E_num,lapping_index)
Aver_Pow_E_2=Pow_Spectra(FFT_E_2,seconds,Nspec,E_num,lapping_index)



coh_fin = dblarr(n_elements(freqs),n_elements(freqs))
bicoh_fin = dblarr(n_elements(freqs),n_elements(freqs))
phase_fin = dblarr(n_elements(freqs),n_elements(freqs))





;Used for calling coherence
for qq=0L,n_elements(freqs)-1 do begin


	FFT_E_2 = shift(FFT_E_2,qq)
;	if qq gt 0 then FFT_E_2[0:qq-1] = 0
	
	Aver_Pow_E_2=Pow_Spectra(FFT_E_2,seconds,Nspec,E_num,lapping_index)
	freqs2 = shift(freqs,qq)
;	if qq gt 0 then freqs2[0:qq] = 0

	COHERENCE_E1_E2=COHERENCE_spectra(FFT_E_1,FFT_E_2,seconds,Nspec,E_num,E_num,Aver_Pow_E_1,Aver_Pow_E_2,lapping_index)
	PHASE_E1_E2=Phase_spectra(FFT_E_1,FFT_E_1,seconds,Nspec,E_num,E_num,Aver_Pow_E_1,Aver_Pow_E_1,lapping_index)


	for bb=0L,n_elements(freqs)-qq-1 do begin
		coh_fin[bb,bb+qq] = coherence_e1_e2[bb+qq]
		phase_fin[bb,bb+qq] = phase_e1_e2[bb+qq]		
	endfor
		

endfor





;;Used for calling bicoherence
;for qq=0L,n_elements(freqs)-1 do begin
;
;
;	FFT_E_2 = shift(FFT_E_1,qq)
;	FFT_E_3 = shift(FFT_E_1,qq+1)
;
;;	if qq gt 0 then FFT_E_2[0:qq-1] = 0
;	
;	Aver_Pow_E_2=Pow_Spectra(FFT_E_2,seconds,Nspec,E_num,lapping_index)
;	freqs2 = shift(freqs,qq)
;;	if qq gt 0 then freqs2[0:qq] = 0
;
;	bicoher = bicoherence_spectra(FFT_E_1,FFT_E_2,FFT_E_3,seconds,Nspec,E_num,E_num,Aver_Pow_E_1,Aver_Pow_E_2,lapping_index)
;	
;;	PHASE_E1_E2=Phase_spectra(FFT_E_1,FFT_E_1,seconds,Nspec,E_num,E_num,Aver_Pow_E_1,Aver_Pow_E_1,lapping_index)
;
;
;	for bb=0L,n_elements(freqs)-qq-1 do begin
;		bicoh_fin[bb,bb+qq] = bicoher[bb+qq]
;		;phase_fin[bb,bb+qq] = phase_e1_e2[bb+qq]		
;	endfor
		

;endfor


;dt = e_num/seconds
;bi_spec2 = bi_spectrum(wave_field[*,1],dt=dt,/img,f=freqs2)   ;,n_seg=4096/2.)
;
;bi_spec1 = bi_spectrum(wave_field[*,1],dt=dt,f=freqs2)    ;,n_seg=4096/2.)
;
;coh_fin = bi_spec2



;set_plot,'ps'
;device,filename='~/Desktop/crossspec.ps',/color

boo = where(coh_fin eq 0.)
coh_fin2 = coh_fin
coh_fin2[boo] = 255

!p.multi = [0,0,1]
;extra = {xtitle:'freq (kHz)',ytitle:'freq (kHz)',title:filename}
;extracb = {ticknames:['0','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1.0'],divisions:10}


!p.font = 0.

boo = where(coh_fin eq 1)
if boo[0] ne -1 then coh_fin[boo] = 0.99


num = 150.
lvls = indgen(num)*1/(num-1)
col = indgen(num)*255./(num-1)
col[0] = 255.

e2 = {xmargin:[20,40],ymargin:[20,40]}


loadct,39
tvlct,r,g,b,/get  
r[255] = 255
g[255] = 255
b[255] = 255
modifyct,20,'mycolors',r,g,b
loadct,20

;goo = where(coh_fin eq 0.)
;coh_fin2[goo] = 5

;boo = where((coh_fin gt 0) and (coh_fin lt 0.02))
;coh_fin2[boo] = 0.04


contour,coh_fin2,freqs,freqs,/fill,$   ;c_colors=col,xrange=[0,2.5d1],/fill,$
	yrange=[0.001,0.1],xrange=[0.001,0.1],/xlog,/ylog,position=[0.1,0.1,0.90,0.95],levels=lvls,xtitle='freq',ytitle='freq',_extra=e2
colorbar,position=[0.91,0.1,0.94,0.95],range=[0,1],/vertical,/right,ncolors=256,minrange=0,maxrange=255.,_extra=extracb


stop

contour,coh_fin2,freqs,freqs,/fill,$   ;c_colors=col,xrange=[0,2.5d1],/fill,$
	yrange=[0.001,0.1],xrange=[0.001,0.1],/xlog,/ylog,position=[0.1,0.1,0.90,0.95],levels=lvls,xtitle='freq',ytitle='freq',_extra=e2
colorbar,position=[0.91,0.1,0.94,0.95],range=[0,1],/vertical,/right,ncolors=256,minrange=0,maxrange=255.,_extra=extracb




plot,freqs,coh_fin2[0,*],title='Coherence'



;bi-coherence plot
contour,coh_fin2,freqs/1000.,freqs/1000.,c_colors=col,xrange=[0,2.5d1],/fill,$
	yrange=[0,2.5d1],title=filename,position=[0.1,0.1,0.90,0.95],levels=lvls/20.,xtitle='freq (kHz)',ytitle='freq (kHz)',_extra=e2
colorbar,position=[0.91,0.1,0.94,0.95],range=[0,1],/vertical,/right,ncolors=256,minrange=0,maxrange=255.,_extra=extracb
;extracb = {ticknames:['0','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1.0'],divisions:10}

plot,freqs,coh_fin2[*,0],title='biCoherence'





;-----------------
;sqrt of coherence
contour,sqrt(coh_fin2),freqs/1000.,freqs/1000.,c_colors=col,xrange=[0,2.5d1],/fill,$
	yrange=[0,2.5d1],title=filename,position=[0.1,0.1,0.90,0.95],levels=lvls,xtitle='freq (kHz)',ytitle='freq (kHz)',_extra=e2
colorbar,position=[0.91,0.1,0.94,0.95],range=[0,1],/vertical,/right,ncolors=256,minrange=0,maxrange=255.,_extra=extracb

plot,freqs,sqrt(coh_fin2[0,*]),title='sqrt Coherence'
;-----------------



device,/close
set_plot,'x'


;oplot,[21400,21400],[0,60000]
;oplot,[0,60000],[21400,21400]
;oplot,[200,200],[0,60000]

;oplot,[21400+200,21400+200],[0,60000]
;oplot,[0,60000],[21400+200,21400+200]
;oplot,[21400-200,21400-200],[0,60000]
;oplot,[0,60000],[21400-200,21400-200]





contour,coh_fin,freqs,freqs,levels=lvls,c_colors=col,/fill,xrange=[0,2000],yrange=[0,2.5d4]




stop




CONTOUR,phase_fin,freqs,freqs,c_colors=[100],/cell_fill



plot_wavestuff,time,sine,/spec,/nocb
plot_wavestuff,time,wf,/spec,/nocb




;determine number of samples for significance calculation

;Burst length is 32 msec. A 200 Hz wave has 

print,200*32/1000.
;IDL> print,200*32/1000.
;      6.40000

;From Bevington, this corresponds to a 0.1 % chance that
;this number could occur by chance. 


END


