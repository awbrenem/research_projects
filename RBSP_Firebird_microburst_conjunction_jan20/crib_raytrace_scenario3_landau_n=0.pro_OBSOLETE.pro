;create a series of rays from two different locations and find the
;delta-time of arrival at FIREBIRD. Calls triangulate_rays.pro


;Scenario 1a
;--f = 1800 Hz
;--theta_kb = -40  (outward pointing)
;--source transverse spread over wide range of L
;--n=1 cyclotron res
;Scenario 1b
;--f = 1800 Hz
;--theta_kb = 0-40  (outward pointing)
;--L=5.38
;--n=1 cyclotron res


;------------------------------------------------
;Landau (n=0) RESONANCE
;------------------------------------------------

FB_leq = 5.
chorus_leq = 5.39   ;value if you adjust L to make |B|-|Bmodel|=0


;Initial raytrace setup
freqv = 1800.
ti = read_write_trace_in(freq=freqv,$
mmult = .72,$
lat=-0.93,$
theta=0.,$
phi=0.,$
alt=(6370.*chorus_leq)-6370.,$
final_alt=3500.,$
model=0,$
final_lat=60,$
pplcp=3.,$
pplhw=0.5,$
drl=10000.)


;--------------------------------------------
;Set up model for observed density, Bo.
thetav = 0.
latv = 0.
freqv = 1800.
altv=(6370.*chorus_leq)-6370.
create_rays_general,freqv,theta=thetav,alt=altv,lat=latv,title='uB3'
dens_bo_profile,freqv,dens_sc=8,bo_sc=146,L_sc=chorus_leq;,/ps
;--------------------------------------------


;;********************
;;Scenario 1a
;;NO SOLUTION (1800 Hz, theta_kb=-50, extended transverse source at eq).
;;Smaller theta_kb doesn't reach L=5
chorus_leqv = (9-5)*indgen(80.)/79. + 5.
thetav = replicate(-60.,80)
latv = replicate(0.,80)
freqv = replicate(1800.,80)
;********************

;;********************
;;Scenario 1b
;;GOOD SOLUTION (1800 Hz, theta_kb spread, L=5.9 at eq)
;chorus_leqv = replicate(5.9,80.)
;;thetav = reverse((-60+0)*indgen(80)/79.)
;thetav = reverse((-50+40)*indgen(80)/79.)-40

;;thetav = reverse((-40+30)*indgen(80)/79.)-30
;latv = replicate(0.,80)
;freqv = replicate(1800.,80)
;********************


;;test....
;chorus_leqv = [5.9,5.7]
;thetav = [-40,0.]
;latv = [0.,0]
;freqv = [1800.,1800]

;chorus_leqv = 6.
;thetav = 40.
;latv = 0.
;freqv = 1800.


altv=(6370.*chorus_leqv)-6370.
create_rays_general,freqv,theta=thetav,alt=altv,lat=latv,title='uB3'


;restore multiple rays
restore,'/Users/aaronbreneman/Desktop/code/Aaron/github.umn.edu/raytrace/uB3_rays.sav'

freqs = make_array(n_elements(thk[*,0]),n_elements(thk[0,*]),value=0)
for i=0,n_elements(freqv)-1 do freqs[*,i] = freqv[i]


fce = freqs/f_fce
kvec = 2*!pi/wavelength   ;1/km
pa = replicate(5.,n_elements(thk[*,0]),n_elements(freqv))
evals = cycl_energies(freqs,thk,pa,fce,kvec,dens,0)
eplot = evals.ez_landau
vz = evals.vz_landau

;plot resonance energy
plot_rays,xcoord,ycoord,zcoord,ray_vals=eplot,$
xrangeM=[0,3],zrangeM=[0,3],minv=1,maxv=985.;,/psonly
stop
;fill in holes by triangulating
triangulate_rays,xcoord,zcoord,eplot,minv=1,maxv=985.,Lsc=[chorus_leq,FB_leq],$
limits=[0,0,3,3],nlvls=20,$
xgrid=xg,ygrid=yg,result=eres,mlats=mlats,lvals=lvals,rads=rads,ilats=ilats,/zbuffer;,/psonly



;Extract slice along single L-value
mlatrange = indgen(90.)
lval_extract = 5.
energiesL = extract_lshell_mlat_slice(lval_extract,mlatrange,xg,yg,eres)




alt = 500.;rough altitude of FB4 (632 by 433 km orbit)
dist_remaining = distance_to_atmosphere(lval,lat,offset_alt=alt)


;calculate time for scattered e- to arrive at FB
tarr = 6370.*dist_remaining/vz
tarr = 1000.*tarr ;msec for better plotting
;	plot_rays,xcoord,ycoord,zcoord,ray_vals=tarr,$
;		xrangeM=[0,6],zrangeM=[-3,3],$
;		Lsc=[chorus_leq,FB_leq],minval=20,maxval=400;,/ps

;	triangulate_rays,xcoord,zcoord,tarr,minv=20.,maxv=400.,Lsc=[RBSPa_leq1,RBSPa_leq2,FB_leq1,FB_leq2],$
;		limits=[0,-3,6,3],nlvls=50;,xgrid=xg,ygrid=yg,result=result1



;Now add together the time it takes for chorus wave to propagate
;to a particular point with time it would take electron scattered at
;that point to reach FIREBIRD

ttotal = tarr + timeg*1000.
plot_rays,xcoord,ycoord,zcoord,ray_vals=ttotal,$
xrangeM=[0,6],zrangeM=[-3,3],$
Lsc=[chorus_leq,FB_leq],minval=1000,maxval=1500;,/ps


triangulate_rays,xcoord,zcoord,ttotal,minv=200.,maxv=1000.,Lsc=[chorus_leq,FB_leq],$
limits=[0,-3,6,3],nlvls=50,xgrid=xg,ygrid=yg,result=totaltime,/zbuffer

totaltimeL = extract_lshell_mlat_slice(lval_extract,mlatrange,xg,yg,totaltime,gridpts=pts)
plot,mlatrange,energiesL,yrange=[0,1000],xrange=[0,50]


;********
;extract other values using the identified grid points

;Extract L-values
triangulate_rays,xcoord,zcoord,lval,minv=1.,maxv=10.,Lsc=[chorus_leq,FB_leq],$
limits=[0,-3,6,3],nlvls=50,xgrid=xg,ygrid=yg,result=tmpvar
lval_fin = fltarr(90.)
ptsx = pts[*,0]
ptsz = pts[*,1]
for i=0,89 do lval_fin[i] = tmpvar[ptsx[i],ptsz[i]]
print,lval_fin   ;these should be the same value I selected for my Lshell slice

;Extract initial L-values
triangulate_rays,xcoord,zcoord,lval0,minv=1.,maxv=10.,Lsc=[chorus_leq,FB_leq],$
limits=[0,-3,6,3],nlvls=50,xgrid=xg,ygrid=yg,result=tmpvar
lval0_fin = fltarr(90.)
ptsx = pts[*,0]
ptsz = pts[*,1]
for i=0,89 do lval0_fin[i] = tmpvar[ptsx[i],ptsz[i]]
print,lval0_fin

;Extract inital mlat values
triangulate_rays,xcoord,zcoord,lat0,minv=0.,maxv=10.,Lsc=[chorus_leq,FB_leq],$
limits=[0,-3,6,3],nlvls=50,xgrid=xg,ygrid=yg,result=tmpvar
mlat0_fin = fltarr(90.)
ptsx = pts[*,0]
ptsz = pts[*,1]
for i=0,89 do mlat0_fin[i] = tmpvar[ptsx[i],ptsz[i]]
print,mlat0_fin

;Extract initial theta_kb values for ray slice
triangulate_rays,xcoord,zcoord,thk0,minv=1.,maxv=60.,Lsc=[chorus_leq,FB_leq],$
limits=[0,-3,6,3],nlvls=50,xgrid=xg,ygrid=yg,result=tmpvar,/zbuffer
thk0_fin = fltarr(90.)
ptsx = pts[*,0]
ptsz = pts[*,1]
for i=0,89 do thk0_fin[i] = tmpvar[ptsx[i],ptsz[i]]
print,thk0_fin

;Extract in situ theta_kb values for ray slice
triangulate_rays,xcoord,zcoord,thk,minv=1.,maxv=90.,Lsc=[chorus_leq,FB_leq],$
limits=[0,-3,6,3],nlvls=50,xgrid=xg,ygrid=yg,result=tmpvar,/zbuffer
thk_fin = fltarr(90.)
ptsx = pts[*,0]
ptsz = pts[*,1]
for i=0,89 do thk_fin[i] = tmpvar[ptsx[i],ptsz[i]]
print,thk_fin



;Subset of values with the correct resonant energy
energiesL2 = energiesL
totaltimeL2 = totaltimeL
lval0_finL2 = lval0_fin
thk_finL2 = thk_fin
thk0_finL2 = thk0_fin


bade = where((energiesL lt 250.) or (energiesL gt 985.))
energiesL2[bade] = !values.f_nan
totaltimeL2[bade] = !values.f_nan
lval0_finL2[bade] = !values.f_nan
thk_finL2[bade] = !values.f_nan
thk0_finL2[bade] = !values.f_nan

;Calculate max time diff b/t arrival of 985 keV e- and 220 keV e-
tdiff = max(totaltimeL2,/nan) - min(totaltimeL2,/nan)
L0diff = max(lval0_finL2,/nan) - min(lval0_finL2,/nan)
print,'TIME OF ARRIVAL DIFFERENCE = '+strtrim(tdiff,2)+ ' (MSEC)'

if finite(tdiff) eq 0. then print,'****NO SOLUTION FOUND****'
if finite(tdiff) eq 0. then STOP


!p.multi = [0,2,3]
!p.charsize = 2.

rbsp_efw_init
plot,mlatrange,energiesL,yrange=[0,1000],xrange=[0,60],$
xtitle='mlat',ytitle='Landau energy (keV)',$
title='ray energy vs mlat for L='+strtrim(lval_extract,2)
oplot,mlatrange,energiesL2,color=250,thick=3
boomin = min(energiesL2,mintmp,/nan)
boomax = max(energiesL2,maxtmp,/nan)
oplot,[mlatrange[mintmp],mlatrange[mintmp]],[0,boomin],linestyle=2
oplot,[mlatrange[maxtmp],mlatrange[maxtmp]],[0,boomax],linestyle=2
mlatstr = 'mlat = '+strtrim(mlatrange[mintmp],2) + '-' + strtrim(mlatrange[maxtmp],2)+' deg'
xyouts,0.2,0.8,mlatstr,/normal

plot,mlatrange,totaltimeL,yrange=[0,1500],xrange=[0,60],$
xtitle='mlat',ytitle='Precip time at FB (msec)',$
title='Precip time after chorus onset!Cvs mlat for L='+strtrim(lval_extract,2)
oplot,mlatrange,totaltimeL2,color=250,thick=3
boomin = min(totaltimeL2,mintmp,/nan)
boomax = max(totaltimeL2,maxtmp,/nan)
oplot,[mlatrange[mintmp],mlatrange[mintmp]],[0,boomin],linestyle=2
oplot,[mlatrange[maxtmp],mlatrange[maxtmp]],[0,boomax],linestyle=2
tstr = string(tdiff,format='(f4.0)')+' msec'
xyouts,0.7,0.8,'Delta time = '+tstr,/normal

plot,mlatrange,lval0_fin,yrange=[2,8],xrange=[0,60],$
xtitle='mlat',ytitle='Initial Lshell of ray',$
title='ray L0 vs mlat for L='+strtrim(lval_extract,2)
oplot,mlatrange,lval0_finL2,color=250,thick=3
boomin = min(lval0_finL2,mintmp,/nan)
boomax = max(lval0_finL2,maxtmp,/nan)
oplot,[mlatrange[mintmp],mlatrange[mintmp]],[0,boomin],linestyle=2
oplot,[mlatrange[maxtmp],mlatrange[maxtmp]],[0,boomax],linestyle=2
lstr = string(min(lval0_finL2,/nan),format='(f4.1)')+'-'+$
			 string(max(lval0_finL2,/nan),format='(f4.1)')
xyouts,0.2,0.42,'L0 range='+lstr,/normal

plot,mlatrange,thk_fin,yrange=[0,90],xrange=[0,60],$
xtitle='mlat',ytitle='theta_kb of ray',$
title='ray theta_kb vs mlat for L='+strtrim(lval_extract,2)
oplot,mlatrange,thk_finL2,color=250,thick=3
boomin = min(thk_finL2,mintmp,/nan)
boomax = max(thk_finL2,maxtmp,/nan)
oplot,[mlatrange[mintmp],mlatrange[mintmp]],[0,boomin],linestyle=2
oplot,[mlatrange[maxtmp],mlatrange[maxtmp]],[0,boomax],linestyle=2

plot,mlatrange,thk0_fin,yrange=[0,70],xrange=[0,60],$
xtitle='mlat',ytitle='Inital theta_kb of ray',$
title='ray initial theta_kb vs mlat for L='+strtrim(lval_extract,2)
oplot,mlatrange,thk0_finL2,color=250,thick=3
boomin = min(thk0_finL2,mintmp,/nan)
boomax = max(thk0_finL2,maxtmp,/nan)
oplot,[mlatrange[mintmp],mlatrange[mintmp]],[0,boomin],linestyle=2
oplot,[mlatrange[maxtmp],mlatrange[maxtmp]],[0,boomax],linestyle=2
t0str = string(min(thk0_finL2,/nan),format='(f4.0)')+'-'+$
			 string(max(thk0_finL2,/nan),format='(f4.0)')
xyouts,0.2,0.22,'theta_kb0 range='+t0str+' deg',/normal



;xyouts,0.2,0.13,'L0 range = '+strtrim(L0diff,2)+' RE',/normal


stop




;*************************************
;Test that I've calculated lshell, mlat, radial distance correctly
;*************************************

minv=3
maxv=max(lvals)
contour,lvals,xg,yg,nlevels=10,min_value=minv,max_value=maxv,$
/cell_fill,xrange=[0,6],yrange=[-3,3],xstyle=1,ystyle=1,$
background=255,position=aspect(1),color=2

triangulate_rays,xcoord,zcoord,lval0,minv=1.,maxv=10.,Lsc=[chorus_leq,FB_leq],$
limits=[0,-3,6,3],nlvls=50,xgrid=xg,ygrid=yg,result=eres,mlats=mlats,lvals=lvals,rads=rads,ilats=ilats


;************
;Test of ray initial values held constant throughout trajectory (raypath should be a single color...test with single ray)
plot_rays,xcoord,ycoord,zcoord,ray_vals=lval0,$
xrangeM=[0,6],zrangeM=[-3,3],minv=1,maxv=7.

plot_rays,xcoord,ycoord,zcoord,ray_vals=radius0,$
xrangeM=[0,6],zrangeM=[-3,3],minv=1,maxv=7.

plot_rays,xcoord,ycoord,zcoord,ray_vals=lat,$
xrangeM=[0,6],zrangeM=[-3,3],minv=1,maxv=10.
;************



minv=3
maxv=max(rads)
contour,rads,xg,yg,nlevels=10,min_value=minv,max_value=maxv,$
/cell_fill,xrange=[0,6],yrange=[-3,3],xstyle=1,ystyle=1,$
background=255,position=aspect(1),color=2

minv=0
maxv=max(mlats)
contour,mlats,xg,yg,nlevels=30,min_value=minv,max_value=maxv,$
/cell_fill,xrange=[0,6],yrange=[-3,3],xstyle=1,ystyle=1,$
background=255,position=aspect(1),color=2


L2 = dipole(2.)
L4 = dipole(4.)
L6 = dipole(6.)
L5 = dipole(5.)
L8 = dipole(8.)
earthx = COS((2*!PI/99.0)*FINDGEN(100))
earthy = SIN((2*!PI/99.0)*FINDGEN(100))
oplot,earthx,earthy,color=60
;oplot,replicate(1.078,360.),indgen(360.)*!dtor,/polar,color=80

oplot,replicate(1.078,360.)*cos(indgen(360.)*!dtor),replicate(1.078,360.)*sin(indgen(360.)*!dtor),color=80
oplot,L2.R/6370.*cos(L2.lat*!dtor),L2.R/6370.*sin(L2.lat*!dtor),color=120
oplot,L2.R/6370.*cos(L2.lat*!dtor),-1*L2.R/6370.*sin(L2.lat*!dtor),color=120

oplot,L4.R/6370.*cos(L4.lat*!dtor),L4.R/6370.*sin(L4.lat*!dtor),color=120
oplot,L4.R/6370.*cos(L4.lat*!dtor),-1*L4.R/6370.*sin(L4.lat*!dtor),color=120

oplot,L6.R/6370.*cos(L6.lat*!dtor),L6.R/6370.*sin(L6.lat*!dtor),color=120
oplot,L6.R/6370.*cos(L6.lat*!dtor),-1*L6.R/6370.*sin(L6.lat*!dtor),color=120

oplot,L5.R/6370.*cos(L5.lat*!dtor),L5.R/6370.*sin(L5.lat*!dtor),color=120
oplot,L5.R/6370.*cos(L5.lat*!dtor),-1*L5.R/6370.*sin(L5.lat*!dtor),color=120

oplot,L8.R/6370.*cos(L8.lat*!dtor),L8.R/6370.*sin(L8.lat*!dtor),color=120
oplot,L8.R/6370.*cos(L8.lat*!dtor),-1*L8.R/6370.*sin(L8.lat*!dtor),color=120

;latitude lines
latstmp = [0,10,20,30,40,50,60,70,80]
latstmp = [-1*reverse(latstmp[1:n_elements(latstmp)-1]),latstmp]
for i=0,n_elements(latstmp)-1 do oplot,[1,50]*cos([latstmp[i]*!dtor,latstmp[i]*!dtor]),[1,50]*sin([latstmp[i]*!dtor,latstmp[i]*!dtor]),linestyle=3,color=100


loadct,39  ;need the first element to be black
nticks = 10.
tn = (indgen(nticks)/(nticks-1))*(maxv-minv)  + minv
tn = strtrim(string(tn,format='(f8.2)'),2)
colorbar,POSITION=[0.15, 0.75, 0.85, 0.77],$
divisions=nticks-1,ticknames=tn,charsize = 0.8,range=[minv,maxv],color=2

;*************************************

stop

end
