;pro plot_histogram_combine 

rbsp_efw_init

path = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/histograms/'

folder = 'histograms_from_2-40min_coherence_files/'
fn = ['campaign1_1-9_mincoh0.7_delta=1.0.idl',$
'campaign1_10-20_mincoh0.7_delta=1.0.idl',$
'campaign1_21-40_mincoh0.7_delta=1.0.idl',$
'campaign2_1-9_mincoh0.7_delta=1.0.idl',$
'campaign2_10-20_mincoh0.7_delta=1.0.idl',$
'campaign2_21-40_mincoh0.7_delta=1.0.idl']

colors = [90,50,0,90,50,0]
linestyle = [0,0,0,2,2,2]

;folder = 'histograms_from_10-60min_coherence_files/'
;fn = ['campaign1_1-9_mincoh0.7_delta=1.0.idl',$
;'campaign1_10-20_mincoh0.7_delta=1.0.idl',$
;'campaign1_21-40_mincoh0.7_delta=1.0.idl',$
;'campaign1_41-90_mincoh0.7_delta=1.0.idl',$
;'campaign2_1-9_mincoh0.7_delta=1.0.idl',$
;'campaign2_10-20_mincoh0.7_delta=1.0.idl',$
;'campaign2_21-40_mincoh0.7_delta=1.0.idl',$
;'campaign2_41-90_mincoh0.7_delta=1.0.idl']

ldF = fltarr(11,n_elements(fn))
ldgooF = fltarr(11,n_elements(fn))
loclF = fltarr(11,n_elements(fn))
loclgooF = fltarr(11,n_elements(fn))
locmltF = fltarr(11,n_elements(fn))
locmltgooF = fltarr(11,n_elements(fn))
mltdF = fltarr(11,n_elements(fn))
mltdgooF = fltarr(11,n_elements(fn))

pre = '1'

for i=0,n_elements(fn)-1 do begin 
    restore,path+folder+fn[i]
    ldF[*,i] = ld
    ldgooF[*,i] = ldgoo
    loclF[*,i] = locl
    loclgooF[*,i] = loclgoo
    locmltF[*,i] = locmlt
    locmltgooF[*,i] = locmltgoo
    mltdF[*,i] = mltd
    mltdgooF[*,i] = mltdgoo


endfor

stop
titlestr = 'plot_histogram_combine.pro'

;;Plot both campaigns together
;!p.multi = [0,0,2]
;!p.charsize = 1.
;plot,loclF[*,0],ldF[*,0],ystyle=1,xtitle='delta-L',ytitle='# times with!Csignificant coherence',title=titlestr,psym=-2,yrange=[1,8000],/ylog,/nodata
;for i=0,n_elements(fn)-1 do oplot,loclF[*,i],ldF[*,i],psym=-2,color=250,linestyle=linestyle[i]
;for i=0,n_elements(fn)-1 do oplot,loclgooF[*,i],ldgooF[*,i],psym=-2,color=colors[i],linestyle=linestyle[i]
;plot,locmltF[*,0],mltdF[*,0],ystyle=1,xtitle='delta-MLT',ytitle='# times with!Csignificant coherence',psym=-2,yrange=[1,9000],/ylog,/nodata
;for i=0,n_elements(fn)-1 do oplot,locmltF[*,i],mltdF[*,i],psym=-2,color=250,linestyle=linestyle[i]
;for i=0,n_elements(fn)-1 do oplot,locmltgooF[*,i],mltdgooF[*,i],psym=-2,color=colors[i],linestyle=linestyle[i]

;Plot campaigns separately
!p.multi = [0,0,4]
!p.charsize = 2.
plot,loclF[*,0],ldF[*,0],ystyle=1,xtitle='delta-L',ytitle='# times with!Csignificant coherence',title=titlestr,psym=-2,yrange=[1,8000],/ylog,/nodata
for i=0,2 do oplot,loclF[*,i],ldF[*,i],psym=-2,color=250
for i=0,2 do oplot,loclgooF[*,i],ldgooF[*,i],psym=-2,color=colors[i]
plot,locmltF[*,0],mltdF[*,0],ystyle=1,xtitle='delta-MLT',ytitle='# times with!Csignificant coherence',psym=-2,yrange=[1,9000],/ylog,/nodata
for i=0,2 do oplot,locmltF[*,i],mltdF[*,i],psym=-2,color=250
for i=0,2 do oplot,locmltgooF[*,i],mltdgooF[*,i],psym=-2,color=colors[i]

plot,loclF[*,0],ldF[*,0],ystyle=1,xtitle='delta-L',ytitle='# times with!Csignificant coherence',title=titlestr,psym=-2,yrange=[1,8000],/ylog,/nodata
for i=3,5 do oplot,loclF[*,i],ldF[*,i],psym=-2,color=250
for i=3,5 do oplot,loclgooF[*,i],ldgooF[*,i],psym=-2,color=colors[i]
plot,locmltF[*,0],mltdF[*,0],ystyle=1,xtitle='delta-MLT',ytitle='# times with!Csignificant coherence',psym=-2,yrange=[1,9000],/ylog,/nodata
for i=3,5 do oplot,locmltF[*,i],mltdF[*,i],psym=-2,color=250
for i=3,5 do oplot,locmltgooF[*,i],mltdgooF[*,i],psym=-2,color=colors[i]






;Plot campaigns separately
!p.multi = [0,0,4]
!p.charsize = 2.
;plot,loclF[*,0],ldF[*,0],ystyle=1,xtitle='delta-L',ytitle='# times with!Csignificant coherence',title=titlestr,psym=-2,yrange=[0,400],xrange=[0,6],/nodata
;for i=0,2 do oplot,loclF[*,i],ldF[*,i],psym=-2,color=250
plot,loclF[*,0],ldF[*,0],ystyle=1,xtitle='delta-L',ytitle='# times with!Csignificant coherence',title=titlestr,psym=-2,yrange=[0,400],xrange=[0,6],/nodata
for i=0,2 do oplot,loclgooF[*,i],ldgooF[*,i],psym=-2,color=colors[i]
plot,locmltF[*,0],mltdF[*,0],ystyle=1,xtitle='delta-MLT',ytitle='# times with!Csignificant coherence',psym=-2,yrange=[0,320],xrange=[0,6],/nodata
for i=0,2 do oplot,locmltgooF[*,i],mltdgooF[*,i],psym=-2,color=colors[i]
plot,loclF[*,0],ldF[*,0],ystyle=1,xtitle='delta-L',ytitle='# times with!Csignificant coherence',title=titlestr,psym=-2,yrange=[0,150],/nodata
for i=3,5 do oplot,loclgooF[*,i],ldgooF[*,i],psym=-2,color=colors[i]
plot,locmltF[*,0],mltdF[*,0],ystyle=1,xtitle='delta-MLT',ytitle='# times with!Csignificant coherence',psym=-2,yrange=[0,170],/nodata
for i=3,5 do oplot,locmltgooF[*,i],mltdgooF[*,i],psym=-2,color=colors[i]



;!p.multi = [0,0,2]
;plot,locmltF[*,0],mltdF[*,0],ystyle=1,xtitle='delta-MLT',ytitle='# times with!Csignificant coherence',psym=-2,yrange=[0,400],xrange=[0,6],/nodata
;for i=0,2 do oplot,locmltF[*,i],mltdF[*,i],psym=-2,color=250




!p.multi = [0,0,4]
!p.charsize = 2.
plot,locl,ld,yrange=[0,2000],ystyle=1,xtitle='delta-L',ytitle='# times with!Csignificant coherence',title=titlestr,psym=-2,/nodata
oplot,locl,ld,psym=-2,color=250
plot,loclgoo,ldgoo,yrange=[0,150],ystyle=1,xtitle='delta-L',ytitle='# times with!Csignificant coherence',title='dL,dLMT histograms!Call payloads!CBARREL mission2',psym=-2
plot,locmlt,mltd,yrange=[0,3000],ystyle=1,xtitle='delta-MLT',ytitle='# times with!Csignificant coherence',psym=-2,/nodata
oplot,locmlt,mltd,psym=-2,color=250
plot,locmltgoo,mltdgoo,yrange=[0,200],ystyle=1,xtitle='delta-MLT',ytitle='# times with!Csignificant coherence',psym=-2



end