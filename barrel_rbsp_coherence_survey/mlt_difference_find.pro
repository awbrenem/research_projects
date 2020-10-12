;;Find the MLT difference between two inputs
;;that doesn't have the 24 hr "bump"
;;Returns a tplot variable 

pro mlt_difference_find,tname1,tname2

  get_data,tname1,data=mlt1
  get_data,tname2,data=mlt2

  ;;find common times
  mT1 = mlt1.x[0] > mlt2.x[0]
  mT2 = mlt1.x[n_elements(mlt1.x)-1] < mlt2.x[n_elements(mlt2.x)-1]
  
  good1 = where((mlt1.x ge mT1) and (mlt1.x le mT2))
  good2 = where((mlt2.x ge mT1) and (mlt2.x le mT2))

  ;;Get MLT values on same times
  store_data,'m1t',data={x:mlt1.x[good1],y:mlt1.y[good1]}
  store_data,'m2t',data={x:mlt2.x[good2],y:mlt2.y[good2]}
  tinterpol_mxn,'m2t','m1t',newname='m2t'
  ;;reinterpolating back gets rid lots of the deviations in the tplot variables
  tinterpol_mxn,'m1t','m2t',newname='m1t'

  get_data,'m1t',data=m1t
  get_data,'m2t',data=m2t

  ;;define MLT sector (1-4 in six hour chunks)
  s1 = float(floor(m1t.y/6. + 1.))
  s2 = float(floor(m2t.y/6. + 1.))
  btmp = where(abs(float(s1)) gt 4.)
  if btmp[0] ne -1 then s1[btmp] = -10
  btmp = where(abs(float(s2)) gt 4.)
  if btmp[0] ne -1 then s2[btmp] = -10


  ;;final delta-MLT values
  dmlt_fin = fltarr(n_elements(s1))

  for qq=0L,n_elements(s1)-1 do begin
     if s1[qq] ne s2[qq] then begin
        pp1 = s1[qq] > s2[qq]
        pp2 = s1[qq] < s2[qq]


        ;;For adjacent sectors (except 4,1) just take difference
        if pp1 - pp2 eq 1 then dmlt_fin[qq] = abs(m1t.y[qq] - m2t.y[qq]) 

        ;;For two sectors with a sector in between, find out if the
        ;;direct difference, or the other route through 24 MLT is shorter
        if pp1 - pp2 eq 2 then begin
           if pp1 eq s1[qq] then begin
              tst1 = abs(m1t.y[qq] - m2t.y[qq])
              tst2 = (24. - m1t.y[qq]) + m2t.y[qq]
           endif
           if pp1 eq s2[qq] then begin
              tst1 = abs(m2t.y[qq] - m1t.y[qq])
              tst2 = (24. - m2t.y[qq]) + m1t.y[qq]
           endif
           dmlt_fin[qq] = tst1 < tst2
        endif
        
        ;;For two sectors with two sectors in between - which can only
        ;;refer to sectors 4 and 1, the shortest path must be through
        ;;24 MLT
        if pp1 - pp2 eq 3 then begin
           if pp1 eq s1[qq] then dmlt_fin[qq] = (24. - m1t.y[qq]) + m2t.y[qq]
           if pp1 eq s2[qq] then dmlt_fin[qq] = (24. - m2t.y[qq]) + m1t.y[qq]             
        endif


        ;;if data are in the same sector...
     endif else dmlt_fin[qq] = abs(m1t.y[qq] - m2t.y[qq])
  endfor



  store_data,'dMLT',data={x:m1t.x,y:dmlt_fin}
  store_data,['m1t','m2t'],/delete



end
