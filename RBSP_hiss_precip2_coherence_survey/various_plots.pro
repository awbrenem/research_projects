
;------------------------------------------
;Plot all coherence plots over entire mission
;-------------------------------------------

t0f = time_double('2013-12-31')
t1f = time_double('2014-02-11')
timespan,t0f,t1f-t0f,/seconds
omni_hro_load


tplot,['kyoto_dst','kyoto_ae','coh_??_meanfilter']
;tplot,['kyoto_dst','kyoto_ae','coh_??']
tplot,['kyoto_dst','kyoto_ae'],/add
tplot,['OMNI_HRO_1min_BZ_GSE','OMNI_HRO_1min_flow_speed','OMNI_HRO_1min_proton_density','OMNI_HRO_1min_Pressure'],/add


;---------------------------------
;First blob of coherence
;---------------------------------

t0f = time_double('2014-01-04')
t1f = time_double('2014-01-15')
timespan,t0f,t1f-t0f,/seconds
tplot,'coh_'+['IT','IW','IK','TW','TK','TL','TX','WK','WL','WX','KL','KX','LX']+'_meanfilter'
tplot,['kyoto_dst','kyoto_ae'],/add
tplot,['OMNI_HRO_1min_BZ_GSE','OMNI_HRO_1min_flow_speed','OMNI_HRO_1min_proton_density','OMNI_HRO_1min_Pressure'],/add


;---------------------------------
;Second blob of coherence
;---------------------------------

t0f = time_double('2014-01-17')
t1f = time_double('2014-01-26')
timespan,t0f,t1f-t0f,/seconds
tplot,'coh_'+['LA','LB','LE','LO','LP','XA','XB','AB']+'_meanfilter'
tplot,['kyoto_dst','kyoto_ae'],/add
tplot,['OMNI_HRO_1min_BZ_GSE','OMNI_HRO_1min_flow_speed','OMNI_HRO_1min_proton_density','OMNI_HRO_1min_Pressure'],/add


;---------------------------------
;Third blob of coherence
;---------------------------------

t0f = time_double('2014-01-29')
t1f = time_double('2014-02-11')
timespan,t0f,t1f-t0f,/seconds
tplot,'coh_'+['LA','LB','LE','LO','LP','XA','XB','AB','AE','AO','AP','BE','BO','BP','EO','EP','OP']+'_meanfilter'
tplot,['kyoto_dst','kyoto_ae'],/add
tplot,['OMNI_HRO_1min_BZ_GSE','OMNI_HRO_1min_flow_speed','OMNI_HRO_1min_proton_density','OMNI_HRO_1min_Pressure'],/add


;--------------------------------------------
;Make rectangular plots instead of dial plots
;--------------------------------------------




nvformatleft = 5
nvformatright = 5

mincolor_vals = min(peroccavg)
maxcolor_vals = (max(peroccavg)+1)/2.
mincolor_cnt = min(totalcounts)
maxcolor_cnt = (max(totalcounts)+1)/2.


  ;Define levels for the colors (from dfanning website:
  ;page 144: http://www.idlcoyote.com/books/tg/samples/tg_chap5.pdf
  ;Letting IDL manually define the colors based on the nlevels keyword
  ;often leads to bad color scales.
  nlevels = 12
  LoadCT, 33, NColors=nlevels, Bottom=1
  step = (maxcolor_vals-mincolor_vals) / nlevels
  levels = IndGen(nlevels) * step + mincolor_vals

  stepc = (maxcolor_cnt-mincolor_cnt)/nlevels
  levelsc = IndGen(nlevels) * stepc + mincolor_cnt

  SetDecomposedState, 0, CurrentState=currentState


  !p.multi = [0,0,2]

    SetDecomposedState, currentState
    contour,peroccavg,grid.grid_lshell[1:grid.nshells],grid.grid_theta[1:grid.nthetas],$
    xtitle='Distance from PP (RE)',ytitle='MLT',$
    /fill,$
    C_Colors=IndGen(nlevels)+1,$
    levels=levels,$
    title='titletmp',$
    ymargin=[4,8],xmargin=[10,20],$
    xrange=[0,12],$
    yrange=[0,24],$
    xstyle=1,ystyle=1

    SetDecomposedState, currentState
    contour,totalcounts,grid.grid_lshell[1:grid.nshells],grid.grid_theta[1:grid.nthetas],$
    xtitle='Distance from PP (RE)',ytitle='MLT',$
    /fill,$
    C_Colors=IndGen(nlevels)+1,$
    levels=levelsc,$
    title='titletmp',$
    ymargin=[4,8],xmargin=[10,20],$
    xrange=[0,12],$
    yrange=[0,24],$
    xstyle=1,ystyle=1



  tn = (maxcolor_vals-mincolor_vals)*indgen(nvformatleft)/(nvformatleft-1)+mincolor_vals
  tn = string(tn,format='(f4.1)')
colorbar,position=[0.92,0.65,0.95,0.95],ticknames=tn,divisions=nvformatleft-1,/vertical,format='(f4.1)'
  tn = (maxcolor_cnt-mincolor_cnt)*indgen(nvformatleft)/(nvformatleft-1)+mincolor_cnt
  tn = string(tn,format='(f6.0)')
colorbar,position=[0.92,0.15,0.95,0.45],ticknames=tn,divisions=nvformatleft-1,/vertical,format='(f4.1)'


stop