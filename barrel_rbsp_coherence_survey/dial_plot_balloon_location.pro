;Plot BARREL balloon orbits during the input time range, and draw a connecting line b/t
;payloads that see significant coherence.
;This lets me know where the balloons are during certain events.

;(see crib_dial_plot_balloon_location.pro for usage)


;Uses plot_plasmapause_goldstein_boundary.pro, and overplots balloon locations
;and lines of coherence. [NOTE: IF YOU JUST WANT TO PLOT THE BALLOON LOCATION
;FOR A SINGLE TIME AND AREN'T WORRIED ABOUT COHERENCE, JUST CALL
;plot_plasmapause_goldstein_boundary.pro]



;if t1 and t2 (unix times) are set, then program only grabs Lshell and MLT data
;during this timerange

;Input the following tplot variables
;l1,l2 --> lshell (or RE) of balloons 1, 2
;mlt1, mlt2 --> MLT (hrs) of balloons 1, 2

;oplot --> set for overplotting new payload on preexisting plot


pro dial_plot_balloon_location,l1,l2,mlt1,mlt2,t1,t2,coh,$
    oplot=oplot,$
    color=color,$
    symbol=symbol,$
    xrange=xr,yrange=yr,$
    payload1=pl1,payload2=pl2


;print,'dpbl input',t1,t2
;stop

if ~keyword_set(color) then color = 0.
if ~keyword_set(symbol) then symbol = 2.
if ~keyword_set(xr) then xr = [-10,10]
if ~keyword_set(yr) then yr = [-10,10]
if ~keyword_set(pl) then pl = 'X'  ;generic symbol for a balloon


;get_data,coh,cohtimes,d


if keyword_set(t1) and keyword_set(t2) then begin
    t1 = time_double(t1)
    t2 = time_double(t2)
    l1v = tsample(l1,[t1,t2])
    l2v = tsample(l2,[t1,t2])
    mlt1v = tsample(mlt1,[t1,t2])
    mlt2v = tsample(mlt2,[t1,t2])

    cohv = tsample(coh,[t1,t2],times=tms)


    if keyword_set(tms) and total(cohv,/nan) ne 0 then begin
        tinterpol_mxn,l1,tms,newname=l1+'_interp'
        tinterpol_mxn,l2,tms,newname=l2+'_interp'
        tinterpol_mxn,mlt1,tms,newname=mlt1+'_interp'
        tinterpol_mxn,mlt2,tms,newname=mlt2+'_interp'

        l1v2 = tsample(l1+'_interp',[t1,t2])
        l2v2 = tsample(l2+'_interp',[t1,t2])
        mlt1v2 = tsample(mlt1+'_interp',[t1,t2])
        mlt2v2 = tsample(mlt2+'_interp',[t1,t2])
    endif

endif else begin
    get_data,l1,t,l1v
    get_data,l2,t,l2v
    get_data,mlt1,t,mlt1v
    get_data,mlt2,t,mlt2v

    get_data,l1+'_interp',t,l1v2
    get_data,l2+'_interp',t,l2v2
    get_data,mlt1+'_interp',t,mlt1v2
    get_data,mlt2+'_interp',t,mlt2v2
    get_data,coh,t,cohv
endelse


;Yes/No coherence variable
cohv2 = bytarr(n_elements(cohv))
goo = where((cohv ne 0.) and (finite(cohv) ne 0.))
if goo[0] ne -1 then cohv2[goo] = 1.



;Turn MLT hours into radians
mlt1v_rad = mlt1v*(360./24.)*!dtor + !pi/2.
mlt2v_rad = mlt2v*(360./24.)*!dtor + !pi/2.
if keyword_set(tms) and total(cohv,/nan) ne 0  then mlt1v2_rad = mlt1v2*(360./24.)*!dtor + !pi/2.
if keyword_set(tms) and total(cohv,/nan) ne 0  then mlt2v2_rad = mlt2v2*(360./24.)*!dtor + !pi/2.





xv1 = l1v*sin(mlt1v_rad)
yv1 = -1*l1v*cos(mlt1v_rad)
xv2 = l2v*sin(mlt2v_rad)
yv2 = -1*l2v*cos(mlt2v_rad)


if keyword_set(tms) and total(cohv,/nan) ne 0 then begin
    xv12 = l1v2*sin(mlt1v2_rad)
    yv12 = -1*l1v2*cos(mlt1v2_rad)
    xv22 = l2v2*sin(mlt2v2_rad)
    yv22 = -1*l2v2*cos(mlt2v2_rad)
endif

;-------------------------------------------------------------------
;Make dial plot of the payload separations during times of coherence
;-------------------------------------------------------------------

if ~keyword_set(oplot) then $
    plot_plasmapause_goldstein_boundary,t1,0.,0.,xrange=xr,yrange=yr


for b=0,n_elements(xv1)-1 do oplot,[xv1[b],xv1[b]],[yv1[b],yv1[b]],psym=2
for b=0,n_elements(xv2)-1 do oplot,[xv2[b],xv2[b]],[yv2[b],yv2[b]],psym=1



if keyword_set(tms) and total(cohv,/nan) ne 0 then begin
    print,'**********'
    print,time_string(t1),' to ',time_string(t2)
    help,cohv,tms
    print,pl1,pl2
    print,'**********'

    for b=0,n_elements(xv12)-1 do oplot,[xv12[b],xv12[b]]*cohv2[b],[yv12[b],yv12[b]]*cohv2[b],psym=-1*6,color=254,symsize=2
    for b=0,n_elements(xv22)-1 do oplot,[xv22[b],xv22[b]]*cohv2[b],[yv22[b],yv22[b]]*cohv2[b],psym=-1*6,color=254,symsize=2
    for b=0,n_elements(xv12)-1 do oplot,[xv12[b],xv22[b]]*cohv2[b],[yv12[b],yv22[b]]*cohv2[b],color=250
endif

;oplot balloon name at beginning of track
xyouts,[xv1[0],xv1[0]],[yv1[0],yv1[0]],pl1,charsize=2,charthick=2
xyouts,[xv2[0],xv2[0]],[yv2[0],yv2[0]],pl2,charsize=2,charthick=2

end
