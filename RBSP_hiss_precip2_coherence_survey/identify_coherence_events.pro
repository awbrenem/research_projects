;;Identify the 2014 coherence events


load_data = 1

rbsp_efw_init

timespan,'2014-01-01',35,/days

path = '~/Desktop/code/Aaron/RBSP/efw_barrel_coherence_analysis/tplot_vars_2014/'


;; combos = ['IT','IW','IK','IL','IX','TW','TK','TL','TX','WK','WL','WX','KL','KX','LX','LA','LB','LE','LO','LP','XA','XB','AB','AE','AO','AP','BE','BO','BP','EO','EP','OP']


combos = 'IK'


if load_data then for i=0,n_elements(combos)-1 do tplot_restore,filenames=path + combos[i] + '.tplot'

;; tplot_restore,filenames=path + 'IK' + '.tplot'


names0 = tnames('coh_??_band0*')  
names1 = tnames('coh_??_band1*')  
names2 = tnames('coh_??_band2*')  
names3 = tnames('coh_??_band3*')  
names4 = tnames('coh_??_band4*')  

mlts = tnames('*mlt_2?')

ylim,names0,0.1,3,1
ylim,names1,0.1,3,1
ylim,names2,0.1,3,1
ylim,names3,0.1,3,1
ylim,names4,0.1,3,1



;; tplot,names1[i]
;; tplot,['coh_I?_band1','fspc_2I_band1']


;;**************************************************

ylim,'fspc_2*',-20,20

for j=0,n_elements(combos)-1 do begin

   p1 = strmid(combos[j],0,1)
   p2 = strmid(combos[j],1,1)

stop
   ;; tplot,['coh_'+p1+p2+'_band1','coh_'+p1+p2+'_band4','fspc_2'+p1+'_band1','fspc_2'+p2+'_band1']


   get_data,'coh_'+p1+p2+'_band1',data=coh
   goo = where((coh.v ge 0.1) and (coh.v le 3))
   store_data,'coh_'+p1+p2+'_band1',data={x:coh.x,y:coh.y[*,goo],v:coh.v[goo]}
   get_data,'coh_'+p1+p2+'_band1',data=coh
   options,'coh_'+p1+p2+'_band1','spec',1



;;remove small values
   goo = where(coh.y lt 0.7)
   if goo[0] ne -1 then coh.y[goo] = !values.f_nan


;; cohtotes = fltarr(n_elements(coh.x))
   ny = n_elements(coh.y[0,*])


   xsize = 5
   overlap = 1
   nelem = n_elements(coh.x)
   cohtotes3 = fltarr(nelem)


   for q=xsize+1,nelem-xsize do cohtotes3[q] = total(coh.y[q-xsize:q+xsize-1,*],/nan)/(ny*xsize)


   store_data,'cohtotes',data={x:coh.x,y:cohtotes3}
   store_data,'cohtotes3',data={x:coh.x,y:(cohtotes3)^3}
   ylim,'*cohtotes*',0,0

   options,['cohtotes','cohtotes*'],'psym',-4
   ylim,'coh_'+p1+p2+'_band1',0,3,0
   tplot,['coh_'+p1+p2+'_band1','cohtotes',$
          'cohtotes3',$
          'mlt_2'+p1,'mlt_2'+p2,'delta_mlt_2'+p1+p2,$
          'lshell_2'+p1,'lshell_2'+p2,'delta_lshell_2'+p1+p2]
   tlimit,/full



;;Plot coherence vs Lshell
   tinterpol_mxn,'mlt_2'+p1,'cohtotes3',newname='mlt_2'+p1

   get_data,'cohtotes',data=coh
   get_data,'cohtotes3',data=coh3
   get_data,'mlt_2'+p1,data=mlt


stop

!p.multi = [0,0,2]
   plot,mlt.y,coh.y,xrange=[0,24],psym=4
   plot,mlt.y,coh3.y,xrange=[0,24],psym=4

stop



;;Find distance from Goldstein's plasmasphere
;; lshell_2K
;; mlt_2K
;; get_data,'Pressure_omni_SPEC',data=p

t0 = time_double('2014-01-05/00:00')
t1 = time_double('2014-01-14/00:00')
y = tsample('coh_'+combos[j]+'_band1',[t0,t1],times=tms)

ldiff = fltarr(n_elements(tms))
mdiff = fltarr(n_elements(tms))

;; for i=0,n_elements(tms)-1 do begin  $ 
;;    s = plasmapause_goldstein_boundary(time_string(tms[i]),tsample('mlt_2K',tms[i]),tsample('lshell_2K',tms[i]))    & $
;;    ldiff[i] = s.distance_from_pp   & $
;;    mdiff[i] = s.mlt_offset

for i=0,n_elements(tms)-1 do begin   
   s = plasmapause_goldstein_boundary(time_string(tms[i]),tsample('mlt_2'+p1,tms[i]),tsample('lshell_2'+p1,tms[i]))
   ldiff[i] = s.distance_from_pp 
   mdiff[i] = s.mlt_offset
endfor

store_data,'lshell_offset_2'+p1,data={x:tms,y:ldiff}
store_data,'mlt_offset_1'+p1,data={x:tms,y:mdiff}


ldiff = fltarr(n_elements(tms))
mdiff = fltarr(n_elements(tms))

for i=0,n_elements(tms)-1 do begin 
   s = plasmapause_goldstein_boundary(time_string(tms[i]),tsample('mlt_2'+p2,tms[i]),tsample('lshell_2'+p2,tms[i])) 
   ldiff[i] = s.distance_from_pp 
   mdiff[i] = s.mlt_offset
endfor

store_data,'lshell_offset_2'+p2,data={x:tms,y:ldiff}
store_data,'mlt_offset_2'+p2,data={x:tms,y:mdiff}


ylim,['lshell_offset_2'+p1,'lshell_offset_2'+p2],-10,10
tplot_options,'title','from identify_coherence_events.pro'
tplot,['Pressure_omni_SPEC','coh_'+combos[i]+'_band1','lshell_offset_2'+p1,'lshell_offset_2'+p2,'mlt_offset_2'+p1,'mlt_offset_2'+p2]


stop
endfor
end
