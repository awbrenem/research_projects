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


;Total number of conjunctions
nconj = n_elements(t0)
;Total number of conjunctions with hires data
nconjhr = n_elements(goohr)


tfirstconj = t0[0] ;2015-02-01/03:51:57
tlastconj = t1[nconj-1];  2019-05-13/20:11:41
tdiff_ndays = (time_double(tlastconj) - time_double(tfirstconj))/86400


tfirstconj_hr = t0[goohr[0]] ;2015-02-01/03:51:57
tlastconj_hr = t1[goohr[nconjhr-1]];  2019-05-13/20:11:41
tdiff_ndays_hr = (time_double(tlastconj_hr) - time_double(tfirstconj_hr))/86400



;number of conjunctions per day
print,nconj/tdiff_ndays
;number of conjunctions per day with hires data
print,nconjhr/tdiff_ndays_hr


;Find average conjunction duration
tdiff_each_conj = time_double(t1) - time_double(t0)
;Find average conjunction duration for conjunctions w/ hires data
tdiff_each_conj_hr = time_double(t1[goohr]) - time_double(t0[goohr])



print,max(tdiff_each_conj);       308.00000  sec
print,min(tdiff_each_conj);       5.0000000 sec
print,median(tdiff_each_conj);    79.000000 sec
print,mean(tdiff_each_conj);       90.000000 sec

print,max(tdiff_each_conj_hr);       265.00000
print,min(tdiff_each_conj_hr);       30.000000
print,median(tdiff_each_conj_hr);       88.000000
print,mean(tdiff_each_conj_hr);        100.32558 



;total time of all conjunctions
print,total(tdiff_each_conj)/60.;       3687.2333  min
print,total(tdiff_each_conj)/3600.;       61 hrs   over 2536 conjunctions

;total time of all hires conjunctions
print,total(tdiff_each_conj_hr)/60.     
print,total(tdiff_each_conj_hr)/3600.

;burst totals 
get_data,'FBb',data=fbb
get_data,'emfb',data=emfb
get_data,'b1b',data=b1b
get_data,'b2b',data=b2b

fbbtotmin = total(fbb.y,/nan)/60.
b1btotmin = total(b1b.y,/nan)/60.
b2btotmin = total(b2b.y,/nan)/60.
emfbtotmin = total(emfb.y,/nan)/60.
bursttotalmin = fbbtotmin + b1btotmin + b2btotmin + emfbtotmin



;###########################
;Summary print statement
print,nconj, '  (', tfirstconj,' to ',tlastconj, ')'
print,nconjhr, '  (', tfirstconj_hr,' to ',tlastconj_hr, ')'
print,nconj/tdiff_ndays
print,nconjhr/tdiff_ndays_hr
print,max(tdiff_each_conj), ' ', min(tdiff_each_conj),' ',median(tdiff_each_conj),' ',mean(tdiff_each_conj),' sec'
print,max(tdiff_each_conj_hr), ' ', min(tdiff_each_conj_hr),' ',median(tdiff_each_conj_hr),' ',mean(tdiff_each_conj_hr),' sec'
print,fbbtotmin,' ',b1btotmin,' ',b2btotmin,' ',emfbtotmin,' ',bursttotalmin



;**************SUMMARY******************
;Conjunction defined as +/-1.0 L and +/-1.0 hrs MLT b/t RBSP and FB

;Total # conjunctions
;A3 = 2536 (2015-02-01/03:51:57 to 2019-05-17/20:57:36)
;A4 = 
;B3 = 
;B4 = 
;Total # conjunctions with hires data
;A3 = 129 (2015-02-01/03:51:57 to 2018-07-13/12:59:46)
;A4 = 
;B3 = 
;B4 = 


;Average # conjunctions per day 
;A3 = 1.62
;A4 = 
;B3 = 
;B4 = 
;Average # conjunctions per day with hires data
;A3 = 0.10
;A4 = 
;B3 = 
;B4 = 


;Conjunction duration (from FB perspective:  max, min, median, average)
;A3 = 
;A4 = 
;B3 = 
;B4 = 


;Total hrs of conjunction survey data on RBSP +/-1.0 L and +/-1.0 hrs MLT
;A3 = 
;A4 = 
;B3 = 
;B4 = 


;Total hrs of conjunction burst data on RBSP +/-1.0 L and +/-1.0 hrs MLT (FBb, B1b, B2b, EMFb, total)
;A3 = 
;A4 = 
;B3 = 
;B4 = 







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


;title = '2015-02-01/03:51:57 to 2019-05-13/20:11:41 --<= RBSPa and FU3'
title = ''

;lrb_hist = histogram(Lrb_good,binsize=0.5,omax=omax,omin=omin)
binsz = 0.2
lrb_hist = histogram(Lrb,min=2,max=8,binsize=binsz,omax=omax,omin=omin)
lrb_hr_hist = histogram(Lrb[goohr],min=2,max=8,binsize=binsz,omax=omax,omin=omin)
;lfb_hist = histogram(Lfb_good,min=2,max=8,binsize=0.5,omax=omax,omin=omin)
xvalsL = indgen((omax-omin)/binsz)*binsz + omin


binsz = 1
MLTrb_hist = histogram(MLTrb,min=0,max=24,binsize=binsz,omax=omax,omin=omin)
MLTrb_hr_hist = histogram(MLTrb[goohr],min=0,max=24,binsize=binsz,omax=omax,omin=omin)
;xvalsMLT = 2*indgen((omax-omin)+binsz)*binsz + omin
xvalsMLT = 2*indgen((omax-omin)+binsz)/2. + omin



;gooddmin = where(distmin lt 5)
;distmin_good2 = distmin_good[gooddmin]
binsz = 0.1
distmin_hist = histogram(distmin,min=0,max=5,binsize=binsz,omax=omax,omin=omin)
distmin_hr_hist = histogram(distmin[goohr],min=0,max=5,binsize=binsz,omax=omax,omin=omin)
xvalsdistmin = indgen((omax-omin)/binsz)*binsz + omin



!p.multi = [0,0,3]
plot,xvalsL,lrb_hist,xtitle='L',ytitle='# conjunctions!CRed=hires data avail',title=title,/ylog,yrange=[1,500]
oplot,xvalsL,lrb_hr_hist,color=250
plot,xvalsMLT,MLTrb_hist,xtitle='MLT',ytitle='# conjunctions!CRed=hires data avail',/ylog,yrange=[1,500]
oplot,xvalsMLT,MLTrb_hr_hist,color=250
plot,xvalsdistmin,distmin_hist,xtitle='distmin',ytitle='# conjunctions!CRed=hires data avail',/ylog,yrange=[1,500]
oplot,xvalsdistmin,distmin_hr_hist,color=250




;----------------------------------------------------
;Determine distribution of wave amplitudes for all the conjuctions WITH wave data during
;closest approach. Note that some conjunctions don't have data at closest approach. 


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

!p.multi = [0,0,2]

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




get_data,'fb7E3',t,stmp
stmplog = alog10(double(stmp))
binsz = 0.4
fb7e3_hist = histogram(stmplog,min=0,max=4,binsize=binsz,omax=omax,omin=omin,/nan)
xvalsfb7e3 = indgen((omax-omin)/binsz)*binsz + omin
plot,xvalsfb7e3,fb7e3_hist,xtitle='log FBK7 50-100Hz [mV/m]',ytitle='# conjunctions',title=title,xrange=[0,2],psym=-4,xstyle=1
;Normalize to # conjunctions
percentconj_fb7e3 = fb7e3_hist/nconj7
plot,xvalsfb7e3,100.*percentconj_fb7e3,xtitle='log FBK7 50-100Hz [mV/m]',ytitle='% of conjunctions',title=title,xrange=[0,2],psym=-4,xstyle=1


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



get_data,'fb7B3',t,stmp
stmplog = alog10(double(stmp))
binsz = 0.3
fb7b3_hist = histogram(stmplog,min=0,max=4,binsize=binsz,omax=omax,omin=omin,/nan)
xvalsfb7b3 = indgen((omax-omin)/binsz)*binsz + omin
plot,xvalsfb7b3,fb7b3_hist,xtitle='log FBK7 50-100Hz [pT]',ytitle='# conjunctions',title=title,xrange=[0,4],psym=-4,xstyle=1
;Normalize to # conjunctions
percentconj_fb7b3 = fb7b3_hist/nconj7
plot,xvalsfb7b3,100.*percentconj_fb7b3,xtitle='log FBK7 50-100Hz [pT]',ytitle='% of conjunctions',title=title,xrange=[0,4],psym=-4,xstyle=1

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

get_data,'fb7B6',t,stmp
stmplog = alog10(double(stmp))
binsz = 0.3
fb7b6_hist = histogram(stmplog,min=0,max=4,binsize=binsz,omax=omax,omin=omin,/nan)
xvalsfb7b6 = indgen((omax-omin)/binsz)*binsz + omin
plot,xvalsfb7b6,fb7b6_hist,xtitle='log FBK7 3200-6400Hz [pT]',ytitle='# conjunctions',title=title,xrange=[0,4],psym=-4,xstyle=1
;Normalize to # conjunctions
percentconj_fb7b6 = fb7b6_hist/nconj7
plot,xvalsfb7b6,100.*percentconj_fb7b6,xtitle='log FBK7 3200-6500Hz [pT]',ytitle='% of conjunctions',title=title,xrange=[0,4],psym=-4,xstyle=1


get_data,'fb13B6',t,stmp
stmplog = alog10(double(stmp))
binsz = 0.3
fb13b6_hist = histogram(stmplog,min=0,max=4,binsize=binsz,omax=omax,omin=omin,/nan)
xvalsfb13b6 = indgen((omax-omin)/binsz)*binsz + omin
plot,xvalsfb13b6,fb13b6_hist,xtitle='log FBK13 50-100Hz [pT]',ytitle='# conjunctions',title=title,xrange=[0,4],psym=-4,xstyle=1
;Normalize to # conjunctions
percentconj_fb13b6 = fb13b6_hist/nconj13
plot,xvalsfb13b6,100.*percentconj_fb13b6,xtitle='log FBK13 50-100Hz [pT]',ytitle='% of conjunctions',title=title,xrange=[0,4],psym=-4,xstyle=1

get_data,'fb13B7',t,stmp
stmplog = alog10(double(stmp))
binsz = 0.3
fb13b7_hist = histogram(stmplog,min=0,max=4,binsize=binsz,omax=omax,omin=omin,/nan)
xvalsfb13b7 = indgen((omax-omin)/binsz)*binsz + omin
plot,xvalsfb13b7,fb13b7_hist,xtitle='log FBK13 100-200Hz [pT]',ytitle='# conjunctions',title=title,xrange=[0,4],psym=-4,xstyle=1
;Normalize to # conjunctions
percentconj_fb13b7 = fb13b7_hist/nconj13
plot,xvalsfb13b7,100.*percentconj_fb13b7,xtitle='log FBK13 100-200Hz [pT]',ytitle='% of conjunctions',title=title,xrange=[0,4],psym=-4,xstyle=1

get_data,'fb13B8',t,stmp
stmplog = alog10(double(stmp))
binsz = 0.3
fb13b8_hist = histogram(stmplog,min=0,max=4,binsize=binsz,omax=omax,omin=omin,/nan)
xvalsfb13b8 = indgen((omax-omin)/binsz)*binsz + omin
plot,xvalsfb13b8,fb13b8_hist,xtitle='log FBK13 200-400Hz [pT]',ytitle='# conjunctions',title=title,xrange=[0,4],psym=-4,xstyle=1
;Normalize to # conjunctions
percentconj_fb13b8 = fb13b8_hist/nconj13
plot,xvalsfb13b8,100.*percentconj_fb13b8,xtitle='log FBK13 200-400Hz [pT]',ytitle='% of conjunctions',title=title,xrange=[0,4],psym=-4,xstyle=1

get_data,'fb13B9',t,stmp
stmplog = alog10(double(stmp))
binsz = 0.3
fb13b9_hist = histogram(stmplog,min=0,max=4,binsize=binsz,omax=omax,omin=omin,/nan)
xvalsfb13b9 = indgen((omax-omin)/binsz)*binsz + omin
plot,xvalsfb13b9,fb13b9_hist,xtitle='log FBK13 400-800Hz [pT]',ytitle='# conjunctions',title=title,xrange=[0,4],psym=-4,xstyle=1
;Normalize to # conjunctions
percentconj_fb13b9 = fb13b9_hist/nconj13
plot,xvalsfb13b9,100.*percentconj_fb13b9,xtitle='log FBK13 400-800Hz [pT]',ytitle='% of conjunctions',title=title,xrange=[0,4],psym=-4,xstyle=1

get_data,'fb13B10',t,stmp
stmplog = alog10(double(stmp))
binsz = 0.3
fb13b10_hist = histogram(stmplog,min=0,max=4,binsize=binsz,omax=omax,omin=omin,/nan)
xvalsfb13b10 = indgen((omax-omin)/binsz)*binsz + omin
plot,xvalsfb13b10,fb13b10_hist,xtitle='log FBK13 800-1600Hz [pT]',ytitle='# conjunctions',title=title,xrange=[0,4],psym=-4,xstyle=1
;Normalize to # conjunctions
percentconj_fb13b10 = fb13b10_hist/nconj13
plot,xvalsfb13b10,100.*percentconj_fb13b10,xtitle='log FBK13 800-1600Hz [pT]',ytitle='% of conjunctions',title=title,xrange=[0,4],psym=-4,xstyle=1

get_data,'fb13B11',t,stmp
stmplog = alog10(double(stmp))
binsz = 0.3
fb13b11_hist = histogram(stmplog,min=0,max=4,binsize=binsz,omax=omax,omin=omin,/nan)
xvalsfb13b11 = indgen((omax-omin)/binsz)*binsz + omin
plot,xvalsfb13b11,fb13b11_hist,xtitle='log FBK13 1600-3200Hz [pT]',ytitle='# conjunctions',title=title,xrange=[0,4],psym=-4,xstyle=1
;Normalize to # conjunctions
percentconj_fb13b11 = fb13b11_hist/nconj13
plot,xvalsfb13b11,100.*percentconj_fb13b11,xtitle='log FBK13 1600-3200Hz [pT]',ytitle='% of conjunctions',title=title,xrange=[0,4],psym=-4,xstyle=1

get_data,'fb13B12',t,stmp
stmplog = alog10(double(stmp))
binsz = 0.3
fb13b12_hist = histogram(stmplog,min=0,max=4,binsize=binsz,omax=omax,omin=omin,/nan)
xvalsfb13b12 = indgen((omax-omin)/binsz)*binsz + omin
plot,xvalsfb13b12,fb13b12_hist,xtitle='log FBK13 3200-6400Hz [pT]',ytitle='# conjunctions',title=title,xrange=[0,4],psym=-4,xstyle=1
;Normalize to # conjunctions
percentconj_fb13b12 = fb13b12_hist/nconj13
plot,xvalsfb13b12,100.*percentconj_fb13b12,xtitle='log FBK13 3200-6400Hz [pT]',ytitle='% of conjunctions',title=title,xrange=[0,4],psym=-4,xstyle=1


get_data,'fb13E6',t,stmp
stmplog = alog10(double(stmp))
binsz = 0.4
fb13e6_hist = histogram(stmplog,min=0,max=4,binsize=binsz,omax=omax,omin=omin,/nan)
xvalsfb13e6 = indgen((omax-omin)/binsz)*binsz + omin
plot,xvalsfb13e6,fb13e6_hist,xtitle='log FBK13 50-100Hz [mV/m]',ytitle='# conjunctions',title=title,xrange=[0,2],psym=-4,xstyle=1
;Normalize to # conjunctions
percentconj_fb13e6 = fb13e6_hist/nconj13
plot,xvalsfb13e6,100.*percentconj_fb13e6,xtitle='log FBK13 50-100Hz [mV/m]',ytitle='% of conjunctions',title=title,xrange=[0,2],psym=-4,xstyle=1

get_data,'fb13E7',t,stmp
stmplog = alog10(double(stmp))
binsz = 0.4
fb13e7_hist = histogram(stmplog,min=0,max=4,binsize=binsz,omax=omax,omin=omin,/nan)
xvalsfb13e7 = indgen((omax-omin)/binsz)*binsz + omin
plot,xvalsfb13e7,fb13e7_hist,xtitle='log FBK13 100-200Hz [mV/m]',ytitle='# conjunctions',title=title,xrange=[0,2],psym=-4,xstyle=1
;Normalize to # conjunctions
percentconj_fb13e7 = fb13e7_hist/nconj13
plot,xvalsfb13e7,100.*percentconj_fb13e7,xtitle='log FBK13 100-200Hz [mV/m]',ytitle='% of conjunctions',title=title,xrange=[0,2],psym=-4,xstyle=1

get_data,'fb13E8',t,stmp
stmplog = alog10(double(stmp))
binsz = 0.4
fb13e8_hist = histogram(stmplog,min=0,max=4,binsize=binsz,omax=omax,omin=omin,/nan)
xvalsfb13e8 = indgen((omax-omin)/binsz)*binsz + omin
plot,xvalsfb13e8,fb13e8_hist,xtitle='log FBK13 200-400Hz [mV/m]',ytitle='# conjunctions',title=title,xrange=[0,2],psym=-4,xstyle=1
;Normalize to # conjunctions
percentconj_fb13e8 = fb13e8_hist/nconj13
plot,xvalsfb13e8,100.*percentconj_fb13e8,xtitle='log FBK13 200-400Hz [mV/m]',ytitle='% of conjunctions',title=title,xrange=[0,2],psym=-4,xstyle=1

get_data,'fb13E9',t,stmp
stmplog = alog10(double(stmp))
binsz = 0.4
fb13e9_hist = histogram(stmplog,min=0,max=4,binsize=binsz,omax=omax,omin=omin,/nan)
xvalsfb13e9 = indgen((omax-omin)/binsz)*binsz + omin
plot,xvalsfb13e9,fb13e9_hist,xtitle='log FBK13 400-800Hz [mV/m]',ytitle='# conjunctions',title=title,xrange=[0,2],psym=-4,xstyle=1
;Normalize to # conjunctions
percentconj_fb13e9 = fb13e9_hist/nconj13
plot,xvalsfb13e9,100.*percentconj_fb13e9,xtitle='log FBK13 400-800Hz [mV/m]',ytitle='% of conjunctions',title=title,xrange=[0,2],psym=-4,xstyle=1

get_data,'fb13E10',t,stmp
stmplog = alog10(double(stmp))
binsz = 0.4
fb13e10_hist = histogram(stmplog,min=0,max=4,binsize=binsz,omax=omax,omin=omin,/nan)
xvalsfb13e10 = indgen((omax-omin)/binsz)*binsz + omin
plot,xvalsfb13e10,fb13e10_hist,xtitle='log FBK13 800-1600Hz [mV/m]',ytitle='# conjunctions',title=title,xrange=[0,2],psym=-4,xstyle=1
;Normalize to # conjunctions
percentconj_fb13e10 = fb13e10_hist/nconj13
plot,xvalsfb13e10,100.*percentconj_fb13e10,xtitle='log FBK13 800-1600Hz [mV/m]',ytitle='% of conjunctions',title=title,xrange=[0,2],psym=-4,xstyle=1

get_data,'fb13E11',t,stmp
stmplog = alog10(double(stmp))
binsz = 0.4
fb13e11_hist = histogram(stmplog,min=0,max=4,binsize=binsz,omax=omax,omin=omin,/nan)
xvalsfb13e11 = indgen((omax-omin)/binsz)*binsz + omin
plot,xvalsfb13e11,fb13e11_hist,xtitle='log FBK13 1600-3200Hz [mV/m]',ytitle='# conjunctions',title=title,xrange=[0,2],psym=-4,xstyle=1
;Normalize to # conjunctions
percentconj_fb13e11 = fb13e11_hist/nconj13
plot,xvalsfb13e11,100.*percentconj_fb13e11,xtitle='log FBK13 1600-3200Hz [mV/m]',ytitle='% of conjunctions',title=title,xrange=[0,2],psym=-4,xstyle=1

get_data,'fb13E12',t,stmp
stmplog = alog10(double(stmp))
binsz = 0.4
fb13e12_hist = histogram(stmplog,min=0,max=4,binsize=binsz,omax=omax,omin=omin,/nan)
xvalsfb13e12 = indgen((omax-omin)/binsz)*binsz + omin
plot,xvalsfb13e12,fb13e12_hist,xtitle='log FBK13 3200-6400Hz [mV/m]',ytitle='# conjunctions',title=title,xrange=[0,2],psym=-4,xstyle=1
;Normalize to # conjunctions
percentconj_fb13e12 = fb13e12_hist/nconj13
plot,xvalsfb13e12,100.*percentconj_fb13e12,xtitle='log FBK13 3200-6400Hz [mV/m]',ytitle='% of conjunctions',title=title,xrange=[0,2],psym=-4,xstyle=1







get_data,'col',t,stmp
stmplog = alog10(double(stmp))
binsz = 0.08
speccol_hist = histogram(stmplog,min=0.,max=5.,binsize=binsz,omax=omax,omin=omin,/nan)
xvalscol = indgen((omax-omin)/binsz)*binsz + omin
plot,xvalscol,speccol_hist,xtitle='FB column counts',ytitle='# conjunctions',title=title,xrange=[0.,5.],psym=-4

get_data,'colHR',t,stmp
stmplog = alog10(double(stmp))
binsz = 0.5
speccol_hr_hist = histogram(stmplog,min=0.,max=5.,binsize=binsz,omax=omax,omin=omin,/nan)
xvalscol_hr = indgen((omax-omin)/binsz)*binsz + omin
plot,xvalscol_hr,speccol_hr_hist,xtitle='FB hires column flux',ytitle='# conjunctions',title=title,xrange=[0.,5.],psym=-4


get_data,'sur',t,stmp
stmplog = alog10(double(stmp))
binsz = 0.4
specsur_hist = histogram(stmplog,min=0.,max=7.,binsize=binsz,omax=omax,omin=omin,/nan)
xvalssur = indgen((omax-omin)/binsz)*binsz + omin
plot,xvalssur,specsur_hist,xtitle='FB surface counts',ytitle='# conjunctions',title=title,xrange=[0.,6.],psym=-4,/xstyle

get_data,'surHR',t,stmp
stmplog = alog10(double(stmp))
binsz = 0.2
specsur_hr_hist = histogram(stmplog,min=0.,max=5.,binsize=binsz,omax=omax,omin=omin,/nan)
xvalssur_hr = indgen((omax-omin)/binsz)*binsz + omin
plot,xvalssur_hr,specsur_hr_hist,xtitle='FB hires surface flux',ytitle='# conjunctions',title=title,xrange=[0.,5.],psym=-4


!p.multi = [0,0,2]
plot,xvalscol,speccol_hist,xtitle='log FB column counts',ytitle='# conjunctions',title=title,xrange=[0.,5.],psym=-4
plot,xvalssur,specsur_hist,xtitle='log FB surface counts',ytitle='# conjunctions',title=title,xrange=[0.,6.],psym=-4,/xstyle

!p.multi = [0,0,2]
plot,xvalscol_hr,speccol_hr_hist,xtitle='log FB column hires flux',ytitle='# conjunctions',title=title,xrange=[0.,5.],psym=-4
plot,xvalssur_hr,specsur_hr_hist,xtitle='log FB surface hires flux',ytitle='# conjunctions',title=title,xrange=[0.,6.],psym=-4,/xstyle


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

nelem=n_elements(percentconj_fb7b3)
inttotal_fb7b3 = fltarr(nelem)
for i=0,n_elements(percentconj_fb7b3)-1 do inttotal_fb7b3[i] = total(percentconj_fb7b3[i:nelem-1],/nan)
plot,xvalsfb7b3,100.*inttotal_fb7b3,xtitle='log FBK7 50-100Hz [pT]',ytitle='% conjunctions that have!Camp <= x-value',title=title,xrange=[0,4],psym=-4,xstyle=1

nelem=n_elements(percentconj_fb7b4)
inttotal_fb7b4 = fltarr(nelem)
for i=0,n_elements(percentconj_fb7b4)-1 do inttotal_fb7b4[i] = total(percentconj_fb7b4[i:nelem-1],/nan)
plot,xvalsfb7b4,100.*inttotal_fb7b4,xtitle='log FBK7 200-400Hz [pT]',ytitle='% conjunctions that have!Camp <= x-value',title=title,xrange=[0,4],psym=-4,xstyle=1

nelem=n_elements(percentconj_fb7b5)
inttotal_fb7b5 = fltarr(nelem)
for i=0,n_elements(percentconj_fb7b5)-1 do inttotal_fb7b5[i] = total(percentconj_fb7b5[i:nelem-1],/nan)
plot,xvalsfb7b5,100.*inttotal_fb7b5,xtitle='log FBK7 800-1600Hz [pT]',ytitle='% conjunctions that have!Camp <= x-value',title=title,xrange=[0,4],psym=-4,xstyle=1


nelem=n_elements(percentconj_fb7e3)
inttotal_fb7e3 = fltarr(nelem)
for i=0,n_elements(percentconj_fb7e3)-1 do inttotal_fb7e3[i] = total(percentconj_fb7e3[i:nelem-1],/nan)
plot,xvalsfb7e3,100.*inttotal_fb7e3,xtitle='log FBK7 50-100Hz [mV/m]',ytitle='% conjunctions that have!Camp <= x-value',title=title,xrange=[0,4],psym=-4,xstyle=1

nelem=n_elements(percentconj_fb7e4)
inttotal_fb7e4 = fltarr(nelem)
for i=0,n_elements(percentconj_fb7e4)-1 do inttotal_fb7e4[i] = total(percentconj_fb7e4[i:nelem-1],/nan)
plot,xvalsfb7e4,100.*inttotal_fb7e4,xtitle='log FBK7 200-400Hz [mV/m]',ytitle='% conjunctions that have!Camp <= x-value',title=title,xrange=[0,4],psym=-4,xstyle=1

nelem=n_elements(percentconj_fb7e5)
inttotal_fb7e5 = fltarr(nelem)
for i=0,n_elements(percentconj_fb7e5)-1 do inttotal_fb7e5[i] = total(percentconj_fb7e5[i:nelem-1],/nan)
plot,xvalsfb7e5,100.*inttotal_fb7e5,xtitle='log FBK7 800-1600Hz [mV/m]',ytitle='% conjunctions that have!Camp <= x-value',title=title,xrange=[0,4],psym=-4,xstyle=1


nelem=n_elements(percentconj_fb13b7)
inttotal_fb13b7 = fltarr(nelem)
for i=0,n_elements(percentconj_fb13b7)-1 do inttotal_fb13b7[i] = total(percentconj_fb13b7[i:nelem-1],/nan)
plot,xvalsfb13b7,100.*inttotal_fb13b7,xtitle='log FBK13 100-200Hz [pT]',ytitle='% conjunctions that have!Camp <= x-value',title=title,xrange=[0,4],psym=-4,xstyle=1

nelem=n_elements(percentconj_fb13b8)
inttotal_fb13b8 = fltarr(nelem)
for i=0,n_elements(percentconj_fb13b8)-1 do inttotal_fb13b8[i] = total(percentconj_fb13b8[i:nelem-1],/nan)
plot,xvalsfb13b8,100.*inttotal_fb13b8,xtitle='log FBK13 200-400Hz [pT]',ytitle='% conjunctions that have!Camp <= x-value',title=title,xrange=[0,4],psym=-4,xstyle=1

nelem=n_elements(percentconj_fb13b9)
inttotal_fb13b9 = fltarr(nelem)
for i=0,n_elements(percentconj_fb13b9)-1 do inttotal_fb13b9[i] = total(percentconj_fb13b9[i:nelem-1],/nan)
plot,xvalsfb13b9,100.*inttotal_fb13b9,xtitle='log FBK13 400-800Hz [pT]',ytitle='% conjunctions that have!Camp <= x-value',title=title,xrange=[0,4],psym=-4,xstyle=1

nelem=n_elements(percentconj_fb13b10)
inttotal_fb13b10 = fltarr(nelem)
for i=0,n_elements(percentconj_fb13b10)-1 do inttotal_fb13b10[i] = total(percentconj_fb13b10[i:nelem-1],/nan)
plot,xvalsfb13b10,100.*inttotal_fb13b10,xtitle='log FBK13 800-1600Hz [pT]',ytitle='% conjunctions that have!Camp <= x-value',title=title,xrange=[0,4],psym=-4,xstyle=1

nelem=n_elements(percentconj_fb13e11)
inttotal_fb13e11 = fltarr(nelem)
for i=0,n_elements(percentconj_fb13e11)-1 do inttotal_fb13e11[i] = total(percentconj_fb13e11[i:nelem-1],/nan)
plot,xvalsfb13e11,100.*inttotal_fb13e11,xtitle='log FBK13 1600-3200Hz [mV/m]',ytitle='% conjunctions that have!Camp <= x-value',title=title,xrange=[0,4],psym=-4,xstyle=1

nelem=n_elements(percentconj_fb13e12)
inttotal_fb13e12 = fltarr(nelem)
for i=0,n_elements(percentconj_fb13e12)-1 do inttotal_fb13e12[i] = total(percentconj_fb13e12[i:nelem-1],/nan)
plot,xvalsfb13e12,100.*inttotal_fb13e12,xtitle='log FBK13 3200-6400Hz [mV/m]',ytitle='% conjunctions that have!Camp <= x-value',title=title,xrange=[0,4],psym=-4,xstyle=1

;*************************************




;TEST COMPARE FBK7 AND FBK13 RESULTS
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
;Plot FB counts vs wave amplitude 
;****************************

get_data,'fb7B5',data=fbk
get_data,'col',data=col
get_data,'colHR',data=colhr
get_data,'sur',data=sur
get_data,'surHR',data=surhr
plot,fbk.y,col.y,psym=1,yrange=[0,200],xrange=[0,500]
plot,fbk.y,sur.y,psym=1,yrange=[0,200],xrange=[0,500]


;Plots vs FB column counts
!p.multi = [0,0,4]
get_data,'SpecBTot_lb',data=spectot
get_data,'SpecBMax_lb',data=specmax
get_data,'SpecBAvg_lb',data=specavg
get_data,'SpecBMed_lb',data=specmed
;log y-scale
plot,alog10(spectot.y),col.y,psym=1,xrange=[-10,-2],yrange=[50,500],/ylog,/ystyle,xtitle='log SpecBTot',ytitle='FB column counts'
plot,alog10(specmax.y),col.y,psym=1,xrange=[-10,-2],yrange=[50,500],/ylog,/ystyle,xtitle='log SpecBMax',ytitle='FB column counts'
plot,alog10(specavg.y),col.y,psym=1,xrange=[-10,-2],yrange=[50,500],/ylog,/ystyle,xtitle='log SpecBAvg',ytitle='FB column counts'
plot,alog10(specmed.y),col.y,psym=1,xrange=[-10,-2],yrange=[50,500],/ylog,/ystyle,xtitle='log SpecBMed',ytitle='FB column counts'
;linear y-scale
plot,alog10(spectot.y),col.y,psym=1,xrange=[-10,-2],yrange=[0,500],/ystyle,xtitle='log SpecBTot',ytitle='FB column counts'
plot,alog10(specmax.y),col.y,psym=1,xrange=[-10,-2],yrange=[0,500],/ystyle,xtitle='log SpecBMax',ytitle='FB column counts'
plot,alog10(specavg.y),col.y,psym=1,xrange=[-10,-2],yrange=[0,500],/ystyle,xtitle='log SpecBAvg',ytitle='FB column counts'
plot,alog10(specmed.y),col.y,psym=1,xrange=[-10,-2],yrange=[0,500],/ystyle,xtitle='log SpecBMed',ytitle='FB column counts'

;Plots vs FB surface counts
!p.multi = [0,0,4]
;log y-scale
plot,alog10(spectot.y),sur.y,psym=1,xrange=[-10,-2],yrange=[50,500000],/ylog,/ystyle,xtitle='log SpecBTot',ytitle='FB surface counts'
plot,alog10(specmax.y),sur.y,psym=1,xrange=[-10,-2],yrange=[50,500000],/ylog,/ystyle,xtitle='log SpecBTot',ytitle='FB surface counts'
plot,alog10(specavg.y),sur.y,psym=1,xrange=[-10,-2],yrange=[50,500000],/ylog,/ystyle,xtitle='log SpecBTot',ytitle='FB surface counts'
plot,alog10(specmed.y),sur.y,psym=1,xrange=[-10,-2],yrange=[50,500000],/ylog,/ystyle,xtitle='log SpecBTot',ytitle='FB surface counts'
;linear y-scale
plot,alog10(spectot.y),sur.y,psym=1,xrange=[-10,-2],yrange=[0,200000],/ystyle,xtitle='log SpecBTot',ytitle='FB surface counts'
plot,alog10(specmax.y),sur.y,psym=1,xrange=[-10,-2],yrange=[0,200000],/ystyle,xtitle='log SpecBTot',ytitle='FB surface counts'
plot,alog10(specavg.y),sur.y,psym=1,xrange=[-10,-2],yrange=[0,200000],/ystyle,xtitle='log SpecBTot',ytitle='FB surface counts'
plot,alog10(specmed.y),sur.y,psym=1,xrange=[-10,-2],yrange=[0,200000],/ystyle,xtitle='log SpecBTot',ytitle='FB surface counts'


;Plots vs FB HIRES column counts
plot,alog10(spectot.y),colhr.y,psym=1,xrange=[-10,-2],yrange=[0.0,10],ylog=0,/ystyle,xtitle='log SpecBTot',ytitle='FB column hires flux'
plot,alog10(specmax.y),colhr.y,psym=1,xrange=[-10,-2],yrange=[0.0,10],ylog=0,/ystyle,xtitle='log SpecBMax',ytitle='FB column hires flux'
plot,alog10(specavg.y),colhr.y,psym=1,xrange=[-10,-2],yrange=[0.0,10],ylog=0,/ystyle,xtitle='log SpecBAvg',ytitle='FB column hires flux'
plot,alog10(specmed.y),colhr.y,psym=1,xrange=[-10,-2],yrange=[0.0,10],ylog=0,/ystyle,xtitle='log SpecBMed',ytitle='FB column hires flux'

;Plots vs FB HIRES surface counts
plot,alog10(spectot.y),surhr.y,psym=1,xrange=[-10,-2],yrange=[1,20],ylog=0,/ystyle,xtitle='log SpecBTot',ytitle='FB surface hires flux'
plot,alog10(specmax.y),surhr.y,psym=1,xrange=[-10,-2],yrange=[1,20],ylog=0,/ystyle,xtitle='log SpecBTot',ytitle='FB surface hires flux'
plot,alog10(specavg.y),surhr.y,psym=1,xrange=[-10,-2],yrange=[1,20],ylog=0,/ystyle,xtitle='log SpecBTot',ytitle='FB surface hires flux'
plot,alog10(specmed.y),surhr.y,psym=1,xrange=[-10,-2],yrange=[1,20],ylog=0,/ystyle,xtitle='log SpecBTot',ytitle='FB surface hires flux'





;****************************
;SEPARATE % VALUES BY L, MLT TO SEE WHERE CUBESATS SHOULD GO
;****************************


