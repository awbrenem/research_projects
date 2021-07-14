;Plot microburst spectra 

;Questions:
;--Does MagEIS (averaged over 80s in different PA bins) see the correct energy range and similar spectra to the microbursts? 


rbsp_efw_init 

ub = microbursts_and_properties_20171205()

;Get energy channel range 
en = firebird_get_calibration_counts2flux('2017-12-05','3')
en3_col = en.ENERGY_RANGE_COLLIMATED
en = firebird_get_calibration_counts2flux('2017-12-05','4')
en4_col = en.ENERGY_RANGE_COLLIMATED

en3_mid = (en3_col[0:4,1] + en3_col[0:4,0])/2.
en4_mid = (en4_col[0:4,1] + en4_col[0:4,0])/2.



;First plot without subtracting background counts. 
nelem = n_elements(ub.fluxpeak_fu3[0,*])
colors = indgen(nelem)*255./(nelem-1)

;FU3-collimated
plot,en3_mid,ub.fluxpeak_fu3[*,0],/nodata,xrange=[200,1200],yrange=[0.01,100],/ylog,/xstyle
for i=0,nelem do oplot,en3_mid,ub.fluxpeak_fu3[*,i],color=colors[i],psym=-4

plot,en3_mid,ub.fluxpeak_fu3[*,0],/nodata,xrange=[200,1200],yrange=[1d-2,1d5],/ylog,/xstyle,/ystyle
for i=0,nelem do oplot,en3_mid,ub.fluxpeak_fu3[*,i],color=colors[i],psym=-4




;Get MagEIS data for comparison 
fn = 'rbspa_rel04_ect-mageis-L3_20171205_v8.1.0.cdf'
path = '/Users/aaronbreneman/Desktop/Research/RBSP_Firebird_Colpitts_Chen/rbsp_mageis_data/'
cdf2tplot,path+fn


get_data,'FEDU_CORR',data=d
   X               DOUBLE    Array[7864]
   Y               DOUBLE    Array[7864, 25, 11]
   V1              DOUBLE    Array[11]
   V2              DOUBLE    Array[25]
   
pa = d.v1

;number of pitch angles 
npa = n_elements(d.v1)


;extract interesting times 
conj_time = time_double('2017-12-05/23:00:00')
t0 = conj_time - 40.
t1 = conj_time + 40.
goodt = where((d.x ge t0) and (d.x le t1))

;extract energy bins
e0 = 200.
e1 = 1100.
goode = where((d.v2 ge e0) and (d.v2 le e1))

;Full MagEIS array within t0-t1 and e0-e1
dtmp = d.y[goodt,goode,*]


;Test comparison of FIREBIRD and MagEIS
j = 6.
plot,d.v2[goode],dtmp[j,*,6],/ylog,yrange=[1d-2,1d5],xrange=[200,1200],/xstyle,/ystyle
oplot,d.v2[goode],dtmp[j,*,5]
oplot,d.v2[goode],dtmp[j,*,4]
oplot,d.v2[goode],dtmp[j,*,3]
oplot,d.v2[goode],dtmp[j,*,2]
oplot,d.v2[goode],dtmp[j,*,1]
oplot,d.v2[goode],dtmp[j,*,0]
for i=0,nelem do oplot,en3_mid,ub.fluxpeak_fu3[*,i],color=colors[i],psym=-4



;Average the MagEIS flux over all remaining times 
davg = fltarr(n_elements(goode),npa)
ntimes = n_elements(dtmp[*,0,0])
for i=0,n_elements(goode)-1 do begin $
    for j=0,npa-1 do begin & $
        davg[i,j] = total(dtmp[*,i,j])/ntimes


;Plot the time-averaged values for each pitch angle from 0-90 deg.
plot,d.v2[goode],davg[*,6],/ylog,yrange=[1d-2,1d5],xrange=[200,1200],/xstyle,/ystyle
oplot,d.v2[goode],davg[*,5]
oplot,d.v2[goode],davg[*,4]
oplot,d.v2[goode],davg[*,3]
oplot,d.v2[goode],davg[*,2]
oplot,d.v2[goode],davg[*,1]
oplot,d.v2[goode],davg[*,0]
for i=0,nelem do oplot,en3_mid,ub.fluxpeak_fu3[*,i],color=colors[i],psym=-4



endfor 



