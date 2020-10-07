;Create plots to determine how common it is to have decent chorus and microbursts
;during conjunctions 


;**************************
;STEP 1 - load data in using load_master_conjunction_list_part3.pro
;**************************


charsz_plot = 0.8             ;character size for plots
charsz_win = 1.2
!p.charsize = charsz_win
tplot_options,'xmargin',[20.,16.]
tplot_options,'ymargin',[3,9]
tplot_options,'xticklen',0.08
tplot_options,'yticklen',0.02
tplot_options,'xthick',2
tplot_options,'ythick',2
tplot_options,'labflag',-1




nconj = n_elements(t0)

tfirstconj = t0[0] ;2015-02-01/03:51:57
tlastconj = t1[nconj-1];  2019-05-13/20:11:41

tdiff_ndays = (time_double(tlastconj) - time_double(tfirstconj))/86400

;number of conjunctions per day
print,nconj/tdiff_ndays
;       1.5729

;Find average conjunction duration
tdiff_each_conj = time_double(t1) - time_double(t0)



print,max(tdiff_each_conj);       308.00000  sec
print,min(tdiff_each_conj);       5.0000000 sec
print,median(tdiff_each_conj);    79.000000 sec
print,mean(tdiff_each_conj);       90.000000 sec



;total time of all conjunctions
print,total(tdiff_each_conj)/60.;       3687.2333  min
print,total(tdiff_each_conj)/3600.;       61 hrs   over 1562 days






;**************SUMMARY******************
;Conjunction defined as +/-1.0 L and +/-1.0 hrs MLT b/t RBSPa and FU4
;Average of 1.57 conjunctions per day
;over 1562 days from 2015-02-01/03:51:57 to 2019-05-13/20:11:41
;This corresponds to 61 hrs of time under conjunction.
;
;Conjunctions average 90 sec in duration, meaning that we have about 141 sec
;of conjunction time per day. If we use median duration (79 sec) then this is
;124 sec per day.

;**************SUMMARY******************




;Plot histograms of L and MLT
;NOTE that while the start and stop times are well defined, many of conjunctions
;don't have data at the closest approach (lots of data gaps). I'm plotting the
;histograms here under the assumption that there's no L, MLT, etc bias in the
;conjunctions with missing data.



get_data,'Lrb',t,lrb
get_data,'MLTrb',t,mltrb
get_data,'distmin',t,distmin



title = '2015-02-01/03:51:57 to 2019-05-13/20:11:41 --<= RBSPa and FU3'

;lrb_hist = histogram(Lrb_good,binsize=0.5,omax=omax,omin=omin)
binsz = 0.2
lrb_hist = histogram(Lrb,min=2,max=8,binsize=binsz,omax=omax,omin=omin)
;lfb_hist = histogram(Lfb_good,min=2,max=8,binsize=0.5,omax=omax,omin=omin)
xvalsL = indgen((omax-omin)/binsz)*binsz + omin


binsz = 1
MLTrb_hist = histogram(MLTrb,min=0,max=24,binsize=binsz,omax=omax,omin=omin)
;xvalsMLT = 2*indgen((omax-omin)+binsz)*binsz + omin
xvalsMLT = 2*indgen((omax-omin)+binsz)/2. + omin



;gooddmin = where(distmin lt 5)
;distmin_good2 = distmin_good[gooddmin]
binsz = 0.1
distmin_hist = histogram(distmin,min=0,max=5,binsize=binsz,omax=omax,omin=omin)
xvalsdistmin = indgen((omax-omin)/binsz)*binsz + omin



!p.multi = [0,0,3]
plot,xvalsL,lrb_hist,xtitle='L',ytitle='# conjunctions',title=title
plot,xvalsMLT,MLTrb_hist,xtitle='MLT',ytitle='# conjunctions'
plot,xvalsdistmin,distmin_hist,xtitle='distmin',ytitle='# conjunctions'




;----------------------------------------------------
;Determine distribution of wave amplitudes for all the conjuctions WITH wave data during
;closest approach. Note from previously that some conjunctions don't have data at closest approach. 


;First find the number of conjunctions for spectral data, FBK7 and FBK13
get_data,'SpecEMax_lb',t,stmp
goo = where(finite(stmp) ne 0.)
nconj = float(n_elements(t[goo]))
get_data,'fb7E5',t,stmp
goo = where(stmp ne 0.)   ;times of FBK7 only
nconj7 = float(n_elements(t[goo]))
get_data,'fb13B10',t,stmp
goo = where(stmp ne 0.)   ;times of FBK7 only
nconj13 = float(n_elements(t[goo]))



get_data,'SpecEMax_lb',t,stmp
stmplog = alog10(double(stmp))
binsz = 0.5
specEmax_lb_hist = histogram(stmplog,min=-8,max=2,binsize=binsz,omax=omax,omin=omin,/nan)
xvalsspecEmax_lb = indgen((omax-omin)/binsz)*binsz + omin
plot,xvalsspecEmax_lb,specEmax_lb_hist,xtitle='log spec Emax LB [mV/m^2/Hz]',ytitle='# conjunctions',title=title,xrange=[-8,2],psym=-4
;Normalize to # conjunctions
percentconj_specEmax_lb = specEmax_lb_hist/nconj
plot,xvalsspecEmax_lb,100.*percentconj_specEmax_lb,xtitle='log spec Emax LB [mV/m^2/Hz]',ytitle='% of conjunctions',title=title,xrange=[-8,2],psym=-4,xstyle=1


get_data,'SpecBMax_lb',t,stmp
stmplog = alog10(double(stmp))
binsz = 0.5
specBmax_lb_hist = histogram(stmplog,min=-10,max=2,binsize=binsz,omax=omax,omin=omin,/nan)
xvalsspecBmax_lb = indgen((omax-omin)/binsz)*binsz + omin
plot,xvalsspecBmax_lb,specBmax_lb_hist,xtitle='log spec Bmax LB [pT^2/Hz]',ytitle='# conjunctions',title=title,xrange=[-10,0],psym=-4,xstyle=1
;Normalize to # conjunctions
percentconj_specBmax_lb = specBmax_lb_hist/nconj
plot,xvalsspecBmax_lb,100.*percentconj_specBmax_lb,xtitle='log spec Bmax LB [pT^2/Hz]',ytitle='% of conjunctions',title=title,xrange=[-10,0],psym=-4,xstyle=1




get_data,'fb7E4',t,stmp
stmplog = alog10(double(stmp))
binsz = 0.4
fb7e4_hist = histogram(stmplog,min=0,max=4,binsize=binsz,omax=omax,omin=omin,/nan)
xvalsfb7e4 = indgen((omax-omin)/binsz)*binsz + omin
plot,xvalsfb7e4,fb7e4_hist,xtitle='log FBK7 200-400Hz [mV/m]',ytitle='# conjunctions',title=title,xrange=[0,2],psym=-4,xstyle=1
;Normalize to # conjunctions
percentconj_fb7e4 = fb7e4_hist/nconj7
plot,xvalsfb7e4,100.*percentconj_fb7e4,xtitle='log FBK7 200-400Hz [mV/m]',ytitle='% of conjunctions',title=title,xrange=[0,2],psym=-4,xstyle=1


get_data,'fb7E5',t,stmp
stmplog = alog10(double(stmp))
binsz = 0.4
fb7e5_hist = histogram(stmplog,min=0,max=4,binsize=binsz,omax=omax,omin=omin,/nan)
xvalsfb7e5 = indgen((omax-omin)/binsz)*binsz + omin
plot,xvalsfb7e5,fb7e5_hist,xtitle='log FBK7 800-1600Hz [mV/m]',ytitle='# conjunctions',title=title,xrange=[0,2],psym=-4,xstyle=1
;Normalize to # conjunctions
percentconj_fb7e5 = fb7e5_hist/nconj7
plot,xvalsfb7e5,100.*percentconj_fb7e5,xtitle='log FBK7 800-1600Hz [mV/m]',ytitle='% of conjunctions',title=title,xrange=[0,2],psym=-4,xstyle=1


get_data,'fb7B4',t,stmp
stmplog = alog10(double(stmp))
binsz = 0.3
fb7b4_hist = histogram(stmplog,min=0,max=4,binsize=binsz,omax=omax,omin=omin,/nan)
xvalsfb7b4 = indgen((omax-omin)/binsz)*binsz + omin
plot,xvalsfb7b4,fb7b4_hist,xtitle='log FBK7 200-400Hz [pT]',ytitle='# conjunctions',title=title,xrange=[0,4],psym=-4,xstyle=1
;Normalize to # conjunctions
percentconj_fb7b4 = fb7b4_hist/nconj7
plot,xvalsfb7b4,100.*percentconj_fb7b4,xtitle='log FBK7 200-400Hz [pT]',ytitle='% of conjunctions',title=title,xrange=[0,4],psym=-4,xstyle=1


get_data,'fb7B5',t,stmp
stmplog = alog10(double(stmp))
binsz = 0.3
fb7b5_hist = histogram(stmplog,min=0,max=4,binsize=binsz,omax=omax,omin=omin,/nan)
xvalsfb7b5 = indgen((omax-omin)/binsz)*binsz + omin
plot,xvalsfb7b5,fb7b5_hist,xtitle='log FBK7 800-1600Hz [pT]',ytitle='# conjunctions',title=title,xrange=[0,4],psym=-4,xstyle=1
;Normalize to # conjunctions
percentconj_fb7b5 = fb7b5_hist/nconj7
plot,xvalsfb7b5,100.*percentconj_fb7b5,xtitle='log FBK7 800-1600Hz [pT]',ytitle='% of conjunctions',title=title,xrange=[0,4],psym=-4,xstyle=1



get_data,'fb13B8',t,stmp
stmplog = alog10(double(stmp))
binsz = 0.3
fb13b8_hist = histogram(stmplog,min=0,max=4,binsize=binsz,omax=omax,omin=omin,/nan)
xvalsfb13b8 = indgen((omax-omin)/binsz)*binsz + omin
plot,xvalsfb13b8,fb13b8_hist,xtitle='log FBK13 200-400Hz [pT]',ytitle='# conjunctions',title=title,xrange=[0,4],psym=-4,xstyle=1
;Normalize to # conjunctions
percentconj_fb13b8 = fb13b8_hist/nconj13
plot,xvalsfb13b8,100.*percentconj_fb13b8,xtitle='log FBK13 200-400Hz [pT]',ytitle='% of conjunctions',title=title,xrange=[0,4],psym=-4,xstyle=1


get_data,'fb13B10',t,stmp
stmplog = alog10(double(stmp))
binsz = 0.3
fb13b10_hist = histogram(stmplog,min=0,max=4,binsize=binsz,omax=omax,omin=omin,/nan)
xvalsfb13b10 = indgen((omax-omin)/binsz)*binsz + omin
plot,xvalsfb13b10,fb13b10_hist,xtitle='log FBK13 800-1600Hz [pT]',ytitle='# conjunctions',title=title,xrange=[0,4],psym=-4,xstyle=1
;Normalize to # conjunctions
percentconj_fb13b10 = fb13b10_hist/nconj13
plot,xvalsfb13b10,100.*percentconj_fb13b10,xtitle='log FBK13 800-1600Hz [pT]',ytitle='% of conjunctions',title=title,xrange=[0,4],psym=-4,xstyle=1


get_data,'fb13E10',t,stmp
stmplog = alog10(double(stmp))
binsz = 0.4
fb13e10_hist = histogram(stmplog,min=0,max=4,binsize=binsz,omax=omax,omin=omin,/nan)
xvalsfb13e10 = indgen((omax-omin)/binsz)*binsz + omin
plot,xvalsfb13e10,fb13e10_hist,xtitle='log FBK13 800-1600Hz [mV/m]',ytitle='# conjunctions',title=title,xrange=[0,2],psym=-4,xstyle=1
;Normalize to # conjunctions
percentconj_fb13e10 = fb13e10_hist/nconj13
plot,xvalsfb13e10,100.*percentconj_fb13e10,xtitle='log FBK13 800-1600Hz [mV/m]',ytitle='% of conjunctions',title=title,xrange=[0,2],psym=-4,xstyle=1









get_data,'col',t,stmp
stmplog = alog10(double(stmp))
binsz = 0.08
speccol_hist = histogram(stmplog,min=0.,max=5.,binsize=binsz,omax=omax,omin=omin,/nan)
xvalscol = indgen((omax-omin)/binsz)*binsz + omin
plot,xvalscol,speccol_hist,xtitle='FB column flux',ytitle='# conjunctions',title=title,xrange=[0.,5.],psym=-4

get_data,'sur',t,stmp
stmplog = alog10(double(stmp))
binsz = 0.4
specsur_hist = histogram(stmplog,min=0.,max=7.,binsize=binsz,omax=omax,omin=omin,/nan)
xvalssur = indgen((omax-omin)/binsz)*binsz + omin
plot,xvalssur,specsur_hist,xtitle='FB surface flux',ytitle='# conjunctions',title=title,xrange=[0.,6.],psym=-4,/xstyle

!p.multi = [0,0,2]
plot,xvalscol,speccol_hist,xtitle='log FB column flux',ytitle='# conjunctions',title=title,xrange=[0.,5.],psym=-4
plot,xvalssur,specsur_hist,xtitle='log FB surface flux',ytitle='# conjunctions',title=title,xrange=[0.,6.],psym=-4,/xstyle



;*************************************
;Forward integrate to find total % of conjunctions with at least a max amplitude of y
;This seems counterintuitive at first. Here's the justification:
;The chance of seeing the smallest amp wave must be the highest. It must be the cumulative
;probability of seeing all the larger amp waves. 
nelem=n_elements(percentconj_specBmax_lb)
inttotal_specBmax_lb = fltarr(nelem)
for i=0,n_elements(percentconj_specBmax_lb)-1 do inttotal_specBmax_lb[i] = total(percentconj_specBmax_lb[i:nelem-1],/nan)
plot,xvalsspecBmax_lb,100.*inttotal_specBmax_lb,xtitle='log spec Bmax LB [pT^2/Hz]',ytitle='% conjunctions that have!Camp <= x-value',title=title,xrange=[-10,0],psym=-4,xstyle=1

nelem=n_elements(percentconj_specEmax_lb)
inttotal_specEmax_lb = fltarr(nelem)
for i=0,n_elements(percentconj_specEmax_lb)-1 do inttotal_specEmax_lb[i] = total(percentconj_specEmax_lb[i:nelem-1],/nan)
plot,xvalsspecEmax_lb,100.*inttotal_specEmax_lb,xtitle='log spec Emax LB [mV/m^2/Hz]',ytitle='% conjunctions that have!Camp <= x-value',title=title,xrange=[-8,0],psym=-4,xstyle=1


nelem=n_elements(percentconj_fb7b4)
inttotal_fb7b4 = fltarr(nelem)
for i=0,n_elements(percentconj_fb7b4)-1 do inttotal_fb7b4[i] = total(percentconj_fb7b4[i:nelem-1],/nan)
plot,xvalsfb7b4,100.*inttotal_fb7b4,xtitle='log FBK7 200-400Hz [pT]',ytitle='% conjunctions that have!Camp <= x-value',title=title,xrange=[0,4],psym=-4,xstyle=1


nelem=n_elements(percentconj_fb7b5)
inttotal_fb7b5 = fltarr(nelem)
for i=0,n_elements(percentconj_fb7b5)-1 do inttotal_fb7b5[i] = total(percentconj_fb7b5[i:nelem-1],/nan)
plot,xvalsfb7b5,100.*inttotal_fb7b5,xtitle='log FBK7 800-1600Hz [pT]',ytitle='% conjunctions that have!Camp <= x-value',title=title,xrange=[0,4],psym=-4,xstyle=1

nelem=n_elements(percentconj_fb7e5)
inttotal_fb7e5 = fltarr(nelem)
for i=0,n_elements(percentconj_fb7e5)-1 do inttotal_fb7e5[i] = total(percentconj_fb7e5[i:nelem-1],/nan)
plot,xvalsfb7e5,100.*inttotal_fb7e5,xtitle='log FBK7 800-1600Hz [mV/m]',ytitle='% conjunctions that have!Camp <= x-value',title=title,xrange=[0,4],psym=-4,xstyle=1


nelem=n_elements(percentconj_fb13b8)
inttotal_fb13b8 = fltarr(nelem)
for i=0,n_elements(percentconj_fb13b8)-1 do inttotal_fb13b8[i] = total(percentconj_fb13b8[i:nelem-1],/nan)
plot,xvalsfb13b8,100.*inttotal_fb13b8,xtitle='log FBK13 200-400Hz [pT]',ytitle='% conjunctions that have!Camp <= x-value',title=title,xrange=[0,4],psym=-4,xstyle=1


nelem=n_elements(percentconj_fb13b10)
inttotal_fb13b10 = fltarr(nelem)
for i=0,n_elements(percentconj_fb13b10)-1 do inttotal_fb13b10[i] = total(percentconj_fb13b10[i:nelem-1],/nan)
plot,xvalsfb13b10,100.*inttotal_fb13b10,xtitle='log FBK13 800-1600Hz [pT]',ytitle='% conjunctions that have!Camp <= x-value',title=title,xrange=[0,4],psym=-4,xstyle=1

nelem=n_elements(percentconj_fb13e10)
inttotal_fb13e10 = fltarr(nelem)
for i=0,n_elements(percentconj_fb13e10)-1 do inttotal_fb13e10[i] = total(percentconj_fb13e10[i:nelem-1],/nan)
plot,xvalsfb13e10,100.*inttotal_fb13e10,xtitle='log FBK13 800-1600Hz [mV/m]',ytitle='% conjunctions that have!Camp <= x-value',title=title,xrange=[0,4],psym=-4,xstyle=1


;*************************************





;!p.multi = [0,0,4]
;!p.charsize = 2
;plot,xvalsspecBmax_lb,100.*percentconj_specBmax_lb,xtitle='log spec Bmax LB [pT^2/Hz]',ytitle='% of conjunctions in!Ceach histogram bin',title=title,xrange=[-8,0],psym=-4,xstyle=1
;plot,xvalsfb7b5,100.*percentconj_fb7b5,xtitle='log FBK7 800-1600Hz [pT]',ytitle='% of conjunctions in!Ceach histogram bin',title=title,xrange=[0,4],psym=-4,xstyle=1


!p.multi = [0,0,2]
plot,xvalsspecBmax_lb,100.*inttotal_specBmax_lb,xtitle='log spec Bmax LB [pT^2/Hz]',ytitle='% conjunctions that have!Camp >= x-value',title=title,xrange=[-10,0],psym=-4,xstyle=1
plot,xvalsfb7b5,100.*inttotal_fb7b5,xtitle='log FBK7/13(b/r) 800-1600Hz [pT]',ytitle='% conjunctions that have!Camp >= x-value',title=title,xrange=[0,4],psym=-4,xstyle=1
oplot,xvalsfb13b10,100.*inttotal_fb13b10,color=250,psym=-4
;oplot,xvalsfb13b8,100.*inttotal_fb13b8,color=200,psym=-4


!p.multi = [0,0,2]
plot,xvalsspecEmax_lb,100.*inttotal_specEmax_lb,xtitle='log spec Emax LB [mV/m^2/Hz]',ytitle='% conjunctions that have!Camp >= x-value',title=title,xrange=[-8,0],psym=-4,xstyle=1
plot,xvalsfb7e5,100.*inttotal_fb7e5,xtitle='log FBK7/13(b/r) 800-1600Hz [mV/m]',ytitle='% conjunctions that have!Camp >= x-value',title=title,xrange=[0,2],psym=-4,xstyle=1
oplot,xvalsfb13e10,100.*inttotal_fb13e10,psym=-4,color=250


;plot,xvalscol,speccol_hist,xtitle='log FB column flux',ytitle='# conjunctions',title=title,xrange=[0.,5.],psym=-4
;plot,xvalssur,specsur_hist,xtitle='log FB surface flux',ytitle='# conjunctions',title=title,xrange=[0.,6.],psym=-4,/xstyle



;****************************
;SEPARATE % VALUES BY L, MLT TO SEE WHERE CUBESATS SHOULD GO
;****************************


