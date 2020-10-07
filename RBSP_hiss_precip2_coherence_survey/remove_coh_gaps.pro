;--------------------------------------------------
;Remove coherence values corresponding to times when there's a
;gap in the FSPC data

;called from create_ch_ascii.pro
;Make sure that the array (coh) y-values are in mHz
;--------------------------------------------------


pro remove_coh_gaps,tname

  get_data,tname,data=coh


;Need to remove NaN times from coh
  totes = fltarr(n_elements(coh.x))
  for uu=0,n_elements(coh.x)-1 do totes[uu] = total(coh.y[uu,*])
  good = where(finite(totes) ne 0.)

  deltacoh = (coh.x - shift(coh.x,-1))/2.
  cohstart = coh.x - deltacoh
  cohend = cohstart + (-2*deltacoh)

  cohstart = cohstart[1:n_elements(cohstart)-2]
  cohend = cohend[1:n_elements(cohend)-2]


  for j=0,n_elements(gapsI)-2 do begin
     g0 = gapsI_unix[j]
     g1 = gapeI_unix[j]

     print,time_string(g0)
     print,time_string(g1)

                                ;Condition to see if there's
                                ;ANY overlap b/t a coherence
                                ;bin and the gap
     for b=0,n_elements(cohstart)-2 do begin  
        goo = where(((cohstart[b] ge g0) or (cohend[b] ge g0)) and $
                    ((cohstart[b] le g1) or (cohend[b] le g1)))


                                ;We've identified a gap in the
                                ;data. If it's a short gap then it
                                ;shouldn't effect very low
                                ;frequencies. No need to NaN out every
                                ;thing when a tiny gap appears. Only
                                ;NaN out effected bins
        if goo[0] ne -1 then begin
           deltatmp = 1/(g1 - g0)
           boo = where(coh.v/1000. ge deltatmp)
           if boo[0] ne -1 then coh.y[b+2,boo] = !values.f_nan
        endif
     endfor
  endfor

                                ;Now do the same for the second balloon payload
  for j=0,n_elements(gapsI2)-2 do begin
     g0 = gapsI2_unix[j]
     g1 = gapeI2_unix[j]

     print,time_string(g0)
     print,time_string(g1)

     for b=0,n_elements(cohstart)-2 do begin  
        goo = where(((cohstart[b] ge g0) or (cohend[b] ge g0)) and $
                    ((cohstart[b] le g1) or (cohend[b] le g1)))

        if goo[0] ne -1 then begin
           deltatmp = 1/(g1 - g0)
           boo = where(coh.v/1000. ge deltatmp)
           if boo[0] ne -1 then coh.y[b+2,boo] = !values.f_nan
        endif

     endfor
  endfor



;;--------------------------------------------------
;; get rid of remaining NaN values
;;--------------------------------------------------

  if good[0] ne -1 then begin
     hoo = where(finite(coh.y[good,*]) eq 0)
     if hoo[0] ne -1 then coh.y[good[hoo]] = 0.
  endif

  store_data,tname,data=coh
end


