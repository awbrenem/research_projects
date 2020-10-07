;; Creates non-polar plots (MLT vs r-value) of some value (like FBK peak)
;; Called from rbsp_survey_fbk_crib.pro


pro rbsp_survey_fbk_plot,$
   info,$
   values,$
   counts,$
   minc_vals=mincolor_vals,$
   maxc_vals=maxcolor_vals,$
   minc_cnt=mincolor_cnt,$
   maxc_cnt=maxcolor_cnt,$
   text = text_vals,$
   title = title,$
   cbtitle = cbtitle,$
   ps=ps,$
   formatleft=formatleft,$
   formatright=formatright,$
   nvformatleft=nvformatleft,$
   nvformatright=nvformatright,$
   deltaL_pp=deltal_pp,$
   xrange=xrange,yrange=yrange


   !p.multi = 0.

  loadct,39

  if ~KEYWORD_SET(xrange) then xrange = [0,24]
  if ~KEYWORD_SET(yrange) then yrange=[-4,4]
  if keyword_set(deltaL_pp) then ytitle='deltaL_pp' else ytitle = 'L-value'
  if ~keyword_set(nvformatleft) then nvformatleft = 5
  if ~keyword_set(nvformatright) then nvformatright = 5
  if ~keyword_set(formatleft) then formatleft = '(F4.1)'
  if ~keyword_set(formatright) then formatright = '(F6.1)'
  if ~keyword_set(mincolor_vals) then mincolor_vals = 0.1
  if ~keyword_set(maxcolor_vals) then maxcolor_vals = 150
  if ~keyword_set(mincolor_cnt) then mincolor_cnt = 50
  if ~keyword_set(maxcolor_cnt) then maxcolor_cnt = max(counts)+1
  if ~keyword_set(text_vals) then begin
     if info.combined_sc eq 0 then text_vals = 'Sector values ('+strtrim(floor(info.dt),2)+$
                                               ' sec chunks)!Cfor!C'+'RBSP-'+strupcase(info.probe) + $
                                               '!C'+info.D0+' to '+info.D1+'!C'
     if info.combined_sc eq 1 then text_vals = 'Sector values ('+strtrim(floor(info.dt),2)+$
                                               ' sec chunks)!Cfor!C'+'both sc' + $
                                               '!C'+info.D0+' to '+info.D1+'!C'
  endif
  if ~keyword_set(title) then title = 'Lshell vs MLT'
  if ~keyword_set(cbtitle) then cbtitle = ''


  nshells = info.grid.nshells
  nthetas = info.grid.nthetas
  grid_theta_center = info.grid.grid_theta_center
  grid_theta = info.grid.grid_theta
  grid_lshell_center = info.grid.grid_lshell_center
  grid_lshell = info.grid.grid_lshell
  Earthx = info.grid.Earthx
  Earthy = info.grid.Earthy
  Earthy2 = info.grid.Earthy_shade


  if info.fbk_type eq 'Ew' then units = 'mV/m' else units = 'nT'
;; ----------------------------
;; Define colors
;; ----------------------------

  ;; --data values
  bs_vals = BYTSCL(values,min=mincolor_vals,max=maxcolor_vals)
  ;; The last colorbar value is white. To avoid having the largest values be white
  ;; let's change to a value of 254 which is red
  boo = where(bs_vals eq 255)
  if boo[0] ne -1 then bs_vals[boo] = 254

  ;; Change zero-counts to white
  goo = where(bs_vals eq 0)
  if goo[0] ne -1 then bs_vals[goo] = 255


  ;; --counts
  bs_cnt = BYTSCL(counts,min=mincolor_cnt,max=maxcolor_cnt)
  boo = where(bs_cnt eq 255)
  if boo[0] ne -1 then bs_cnt[boo] = 254
  goo = where(bs_cnt eq 0)
  if goo[0] ne -1 then bs_cnt[goo] = 255 ;change zero-counts to white


  ;; REMOVE VALUES WHEN THE LSHELL-MLT BIN CONTAINS LESS THAN THE MINIMUM COUNTS
  goo = where(bs_cnt eq 255)
  if goo[0] ne -1 then bs_vals[goo] = 255




;; ---------------------------------------
;; Plot the data values
;; ---------------------------------------


  !p.multi = [0,2,0]
  if keyword_set(ps) then !p.charsize = 0.8 else !p.charsize = 1.5


  d0t = strmid(info.d0,0,4)+strmid(info.d0,5,2)+strmid(info.d0,8,2)
  d1t = strmid(info.d1,0,4)+strmid(info.d1,5,2)+strmid(info.d1,8,2)
  if info.maxamp_pk ge 1000 then maxamp = 'inf' else $
     maxamp = strtrim(string(info.maxamp_pk,format='(f6.1)'),2)

  ;; text_title = 'fbk_perocc_RBSP'+info.probe+'_dt_eq'+$
  ;;              string(info.dt,format='(i2)')+'s_'+d0t+'-'+d1t + '_(' + $
  ;;              strtrim(string(info.minamp_pk,format='(f5.1)'),2)+$
  ;;              'GT_'+units+'_LT'+maxamp+')_('+ $
  ;;              strtrim(string(info.mlatL,format='(I2)'),2)+'GT_mlat_LT'+$
  ;;              strtrim(string(info.mlatH,format='(I2)'),2)+')_(' + $
  ;;              strtrim(string(info.aeL,format='(I5)'),2)+'GT_AE_LT'+$
  ;;              strtrim(string(info.aeH,format='(I5)'),2)+')_(' + $
  ;;              strtrim(string(info.dstL,format='(I6)'),2)+'GT_DST_LT'+$
  ;;              strtrim(string(info.dstH,format='(I6)'),2)+').ps'

  text_title = 'plot.ps'


  if keyword_set(ps) then popen,'~/Desktop/'+text_title,/landscape


  vals_plot = transpose(bs_vals[*,*])


  contour,vals_plot,grid_theta_center,grid_lshell_center,/cell_fill,nlevels=20,$
                xrange=xrange,yrange=yrange,/nodata,title=title,$
                xtitle='MLT (hrs)',ytitle=ytitle,$
                ystyle=1,xstyle=1,position=[0.1,0.1,0.45,0.7]

;  for q=0,nshells do oplot,grid_theta,grid_lshell[q]*sin(grid_theta)
;  for q=0,nthetas do oplot,grid_lshell*cos(grid_theta[q]),grid_lshell*sin(grid_theta[q])

  xyouts,0.35,0.95,text_vals,/normal


  ;; fill in the cells
    for h=0,nshells-1 do begin
      for j=0,nthetas-1 do begin

       xtmp0 = grid_theta[j]
       xtmp1 = grid_theta[j+1]
       xtmp2 = grid_theta[j+1]
       xtmp3 = grid_theta[j]
       xtmp4 = xtmp0

       ytmp0 = grid_lshell[h]
       ytmp1 = grid_lshell[h]
       ytmp2 = grid_lshell[h+1]
       ytmp3 = grid_lshell[h+1]
       ytmp4 = ytmp0

       xv = [xtmp0,xtmp1,xtmp2,xtmp3,xtmp4]
       yv = [ytmp0,ytmp1,ytmp2,ytmp3,ytmp4]
       cc = bs_vals[h,j]
       polyfill,xv,yv,color=cc


  endfor
    endfor


  ;; Replot the grid lines
  ;vertical lines
  for q=0,nthetas do $
      oplot,[grid_theta[q],grid_theta[q]],$
            [grid_lshell[0],grid_lshell[nshells]]
  ;horizontal lines
    for q=0,nshells do $
      oplot,[grid_theta[0],grid_theta[nthetas]],$
        [grid_lshell[q],grid_lshell[q]]


  ;; ticknames for the peak values
  tn = (maxcolor_vals-mincolor_vals)*indgen(nvformatleft)/(nvformatleft-1)+mincolor_vals
  tn = string(tn,format=formatleft)

  colorbar,ticknames=tn,divisions=nvformatleft-1,position=[0.1,0.85,0.45,0.88],title=cbtitle,/noerase



;; --------------------------------------------
;; Plot counts
;; --------------------------------------------

  contour,transpose(counts),grid_theta_center,grid_lshell_center,$
                /cell_fill,nlevels=20,$
                xrange=xrange,yrange=yrange,/nodata,$
                title='Counts!CLshell vs MLT',$
                xtitle='MLT (hrs)',ytitle=ytitle,$
                ystyle=1,xstyle=1,position=[0.55,0.1,0.9,0.7],/noerase


  ;; fill in the cells
  for h=0,nshells-1 do begin
    for j=0,nthetas-1 do begin

     xtmp0 = grid_theta[j]
     xtmp1 = grid_theta[j+1]
     xtmp2 = grid_theta[j+1]
     xtmp3 = grid_theta[j]
     xtmp4 = xtmp0

     ytmp0 = grid_lshell[h]
     ytmp1 = grid_lshell[h]
     ytmp2 = grid_lshell[h+1]
     ytmp3 = grid_lshell[h+1]
     ytmp4 = ytmp0

     xv = [xtmp0,xtmp1,xtmp2,xtmp3,xtmp4]
     yv = [ytmp0,ytmp1,ytmp2,ytmp3,ytmp4]
     cc = bs_cnt[h,j]
     polyfill,xv,yv,color=cc

endfor
  endfor

  ;; Replot the grid lines
  ;vertical lines
  for q=0,nthetas do $
      oplot,[grid_theta[q],grid_theta[q]],$
            [grid_lshell[0],grid_lshell[nshells]]
  ;horizontal lines
    for q=0,nshells do $
      oplot,[grid_theta[0],grid_theta[nthetas]],$
        [grid_lshell[q],grid_lshell[q]]


  ;; ticknames for the count values
  tn = (maxcolor_cnt-mincolor_cnt)*indgen(nvformatright)/(nvformatright-1) + mincolor_cnt
  tn = string(tn,format=formatright)
  colorbar,ticknames=tn,divisions=nvformatright-1,position=[0.55,0.85,0.9,0.88],title='counts',/noerase



  if keyword_set(ps) then pclose

end
