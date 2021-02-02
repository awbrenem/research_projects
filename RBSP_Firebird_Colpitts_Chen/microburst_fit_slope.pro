;Fit a best fit as well as max/min slopes to a dispersive microburst with associated errors. 


timespan,'2016-08-30'     

firebird_load_data,'3'    



rbsp_detrend,'fu3_fb_col_hires_flux',0.1

t0 = time_double('2016-08-30/20:47:27.400')
t1 = time_double('2016-08-30/20:47:28.600')
tlimit,t0,t1
tplot,['fu3_fb_col_hires_flux','fu3_fb_col_hires_flux_smoothed']


;For each channel determine the peak time 
;flux = [19.343361,5.3753476,0.96618360,0.26761362,0.039054871]
;tpeak = [1472590047.923d,1472590047.923d,1472590047.923d,1472590047.973d,1472590047.973d]

cadence = 0.05  ;sec

timebar,tpeak[0]
timebar,tmin[0],color=50 
timebar,tmax[0],color=50


ytmp = tsample('fu3_fb_col_hires_flux_smoothed',[t0,t1],times=tms)
fluxpeak = fltarr(5)
fluxadj_high = fltarr(5) 
fluxadj_low = fltarr(5) 
tpeak = dblarr(5)
;extract max value in each channel 
for i=0,4 do begin $
    fluxpeak[i] = max(ytmp[*,i],wh) & $
    tpeak[i] = tms[wh] & $
    fluxadj_high[i] = ytmp[wh+1,i] & $
    fluxadj_low[i] = ytmp[wh-1,i]

for i=0,4 do print,fluxadj_low[i],' ',fluxpeak[i],' ',fluxadj_high[i]


;Error bars in time will extend to the halfway point b/t adjacent values
tmin = tpeak - cadence/2.
tmax = tpeak + cadence/2.

;For each peak, if either adjacent data point has the same value then extend the error bar
;(This happens frequently)
for i=0,4 do begin $
    if fluxpeak[i] eq fluxadj_low[i] then tmin[i] -= cadence/2. & $
    if fluxpeak[i] eq fluxadj_high[i] then tmax[i] += cadence/2.
endfor


;Reshift peak values if either tmin or tmax has been extended due to 
;neighboring data points with the same value 
goohigh = where((tmax - tpeak) gt cadence)
goolow = where((tpeak - tmin) gt cadence)
if goohigh[0] ne -1 then for i=0,n_elements(goohigh)-1 do tpeak[goohigh[i]] += cadence/2.
if goolow[0] ne -1 then for i=0,n_elements(goolow)-1 do tpeak[goolow[i]] -= cadence/2.




;reference times to zero for plotting
times = tpeak - tpeak[0]


;graphic = ERRORPLOT(X, Y, Xerror, Yerror [, Format] [, Keywords=value] [, Properties=value])
xerror = tmax-tmin
yerror = replicate(0.,5)

p = errorplot(times,fluxpeak,xerror,yerror,xrange=[-2*cadence,2*cadence],$
xtitle='time (sec, relative)',ytitle='flux')
p.ylog=1
p.ystyle=1
p.yrange=[0.01,20]

;plot,times,fluxpeak,psym=4,thick=2,xrange=[-1*cadence,cadence],/ylog,/ystyle,yrange=[0.01,20]


 
; Create the plot
p = ERRORPLOT(x, y, yerror, XRANGE=[0,7], $
XTITLE="Day", YTITLE="Distance (miles)", $
TITLE="Average distance bears walk in a day")
 
; Set some properties
p.THICK=2
p.ERRORBAR_THICK=2
p.SYM_COLOR ="cornflower"
p.ERRORBAR_COLOR="indian_red"
p.ERRORBAR_CAPSIZE=0.5


