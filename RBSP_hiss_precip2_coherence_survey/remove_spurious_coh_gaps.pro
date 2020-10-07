
;--------------------------------------------------
;remove final bad coherence values. these correspond to "random"
;remaining bad data which are obviously not real and screw up the
;coherence

;see "get_remaining_bad_data.pro" for a list
;--------------------------------------------------

pro remove_spurious_coh_gaps,array,combo

  get_data,array,data=coh


  deltacoh = (coh.x - shift(coh.x,-1))/2.
  cohstart = coh.x - deltacoh
  cohend = cohstart + (-2*deltacoh)


  badd = get_remaining_bad_data()
  goodd = where(badd.combo eq combo)

  if goodd[0] ne -1 then begin
     for j=0,n_elements(goodd)-1 do begin
        g0 = time_double(badd.starttime[goodd[j]])
        g1 = time_double(badd.endtime[goodd[j]])

        print,time_string(g0)
        print,time_string(g1)

                                ;Condition to see if there's
                                ;ANY overlap b/t a coherence
                                ;bin and the gap

        goo = where(((cohstart ge g0) or (cohend ge g0)) and $
                    ((cohstart le g1) or (cohend le g1)))


                                ;We've identified a gap in the
                                ;data. If it's a short gap then it
                                ;shouldn't effect very low
                                ;frequencies. No need to NaN out every
                                ;thing when a tiny gap appears. Only
                                ;NaN out effected bins
        if goo[0] ne -1 then begin
           ;; if n_elements(goo) gt 2 then begin
           deltatmp = 1/(g1 - g0)
           boo = where(coh.v/1000. ge deltatmp)
           for q=0,n_elements(goo)-1 do if boo[0] ne -1 then coh.y[goo[q]+2,boo] = !values.f_nan
        endif

     endfor

     store_data,array,data=coh

  endif


end
