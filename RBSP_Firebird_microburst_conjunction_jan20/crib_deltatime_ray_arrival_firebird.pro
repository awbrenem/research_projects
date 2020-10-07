;create a series of rays from two different locations and find the
;delta-time of arrival at FIREBIRD. Calls triangulate_rays.pro



;------------------------------------------------
;CO-STREAMING CYCLOTRON (n=1) RESONANCE
;------------------------------------------------

timing_error_l = 0.1   ;uncertainty in L due to a ~5 sec timing
											 ;uncertainty in FB data. This is likely to be
											 ;high, but doesn't make much difference here.
FB_leq1 = 4.922 - timing_error_l
FB_leq2 = 5.072 + timing_error_l
;		RBSPa_leq = 5.77   ;TSY04s model value
;TSY04 Bz at RBSPa is 10% too small
;Correcting this is equivalent to moving RBa from L=5.77 to L=5.39.
RBSPa_leq = 5.39   ;value if you adjust L to make |B|-|Bmodel|=0
;RBSPa_leq = 5.24   ;value if you adjust L to make |B|-|Bmodel|=0
RBSPa_leq1 = RBSPa_leq - 0.15  ;adjustment for the size of a chorus wave packet (Agapitov)
RBSPa_leq2 = RBSPa_leq + 0.15


;Set up for northward raytracing
freqv = 1700.
ti = read_write_trace_in(freq=freqv,$
mmult = .80,$
lat=-0.93,$
theta=0.,$
phi=0.,$
alt=(6370.*RBSPa_leq)-6370.,$
final_alt=4000.,$
model=0,$
final_lat=42,$
pplcp=3.,$
pplhw=0.5,$
drl=10000.)

thetavals = -1*indgen(24)*50./(23.)
freqs = replicate(freqv,n_elements(thetavals))
create_rays_thetakb_spread,thetavals,freqs=freqs,title='uB3'

;dens_bo_profile,freqv,dens_sc=8,bo_sc=146,L_sc=RBSPa_leq;,/ps
;x = read_trace_ta()

;restore multiple rays
restore,'/Users/aaronbreneman/Desktop/code/Aaron/github.umn.edu/raytrace/uB3_rays.sav'

fce = freqv/f_fce
kvec = 2*!pi/wavelength   ;1/km
pa = replicate(5.,n_elements(thetavals))
evals = cycl_energies(freqs,thk,pa,fce,kvec,1)

eplot = evals.e_cycl_anom
vz = evals.vz_cycl_anom

;plot resonance energy
plot_rays,xcoord,ycoord,zcoord,ray_vals=eplot,$
xrangeM=[0,6],zrangeM=[-3,3],$
;fill in holes by triangulating
;triangulate_rays,xcoord,zcoord,eplot,minv=5.,maxv=850.,Lsc=[RBSPa_leq1,RBSPa_leq2,FB_leq1,FB_leq2],$
;	limits=[0,-3,6,3],nlvls=50;,xgrid=xg,ygrid=yg,result=result1


Lsc=[RBSPa_leq1,RBSPa_leq2,FB_leq1,FB_leq2],minval=0,maxval=850
alt = 500.;rough altitude of FB4 (632 by 433 km orbit)
dist_remaining = distance_to_atmosphere(lval,lat,offset_alt=alt)


	;calculate time for scattered e- to arrive at FB
	tarr = 6370.*dist_remaining/vz
	tarr = 1000.*tarr ;msec for better plotting
	plot_rays,xcoord,ycoord,zcoord,ray_vals=tarr,$
		xrangeM=[0,6],zrangeM=[-3,3],$
		Lsc=[RBSPa_leq1,RBSPa_leq2,FB_leq1,FB_leq2],minval=20,maxval=400;,/ps

;	triangulate_rays,xcoord,zcoord,tarr,minv=20.,maxv=400.,Lsc=[RBSPa_leq1,RBSPa_leq2,FB_leq1,FB_leq2],$
;		limits=[0,-3,6,3],nlvls=50;,xgrid=xg,ygrid=yg,result=result1



;Now add together the time it takes for chorus wave to propagate
;to a particular point with time it would take electron scattered at
;that point to reach FIREBIRD

ttotal = tarr + timeg*1000.
plot_rays,xcoord,ycoord,zcoord,ray_vals=ttotal,$
xrangeM=[0,6],zrangeM=[-3,3],$
Lsc=[RBSPa_leq1,RBSPa_leq2,FB_leq1,FB_leq2],minval=400,maxval=600;,/ps


triangulate_rays,xcoord,zcoord,ttotal,minv=400.,maxv=600.,Lsc=[RBSPa_leq1,RBSPa_leq2,FB_leq1,FB_leq2],$
	limits=[0,-3,6,3],nlvls=50,xgrid=xg,ygrid=yg,result=result1


;-------------
;Set up for northward raytracing
freqv = 1700.
ti = read_write_trace_in(freq=freqv,$
mmult = .80,$
lat=-0.93,$
theta=0.,$
phi=0.,$
alt=(6370.*RBSPa_leq2)-6370.,$
final_alt=4000.,$
model=0,$
final_lat=42,$
pplcp=3.,$
pplhw=0.5,$
drl=10000.)

thetavals = -1*indgen(24)*50./(23.)

freqs = replicate(freqv,n_elements(thetavals))
create_rays_thetakb_spread,thetavals,freqs=freqs,title='uB3'

;dens_bo_profile,freqv,dens_sc=8,bo_sc=146,L_sc=RBSPa_leq;,/ps
;x = read_trace_ta()

;restore multiple rays
restore,'/Users/aaronbreneman/Desktop/code/Aaron/github.umn.edu/raytrace/uB3_rays.sav'

fce = freqv/f_fce
kvec = 2*!pi/wavelength   ;1/km
pa = replicate(5.,n_elements(thetavals))
evals = cycl_energies(freqs,thk,pa,fce,kvec,1)

eplot = evals.e_cycl_anom
vz = evals.vz_cycl_anom

plot_rays,xcoord,ycoord,zcoord,ray_vals=eplot,$
xrangeM=[0,6],zrangeM=[-3,3],$
Lsc=[RBSPa_leq1,RBSPa_leq2,FB_leq1,FB_leq2],minval=0,maxval=850
alt = 500.;rough altitude of FB4 (632 by 433 km orbit)
dist_remaining = distance_to_atmosphere(lval,lat,offset_alt=alt)


	;calculate time for scattered e- to arrive at FB
	tarr = 6370.*dist_remaining/vz
	tarr = 1000.*tarr ;msec for better plotting
	plot_rays,xcoord,ycoord,zcoord,ray_vals=tarr,$
		xrangeM=[0,6],zrangeM=[-3,3],$
		Lsc=[RBSPa_leq1,RBSPa_leq2,FB_leq1,FB_leq2],minval=20,maxval=400;,/ps



;Now add together the time it takes for chorus wave to propagate
;to a particular point with time it would take electron scattered at
;that point to reach FIREBIRD

ttotal = tarr + timeg*1000.
plot_rays,xcoord,ycoord,zcoord,ray_vals=ttotal,$
xrangeM=[0,6],zrangeM=[-3,3],$
Lsc=[RBSPa_leq1,RBSPa_leq2,FB_leq1,FB_leq2],minval=400,maxval=600;,/ps



triangulate_rays,xcoord,zcoord,eplot,minv=5.,maxv=850.,Lsc=[RBSPa_leq1,RBSPa_leq2,FB_leq1,FB_leq2],$
	limits=[0,-3,6,3],nlvls=50,xgrid=xg,ygrid=yg,result=result2



;Take the difference of result 1 and result 2 and plot
resultdiff = result1-result2
minv=1.
maxv=50.

contour,resultdiff,xg,yg,nlevels=10.,min_value=minv,max_value=maxv,$
/cell_fill,xrange=[0,6],yrange=[-3,3],xstyle=1,ystyle=1


;plot colorbar
loadct,39  ;need the first element to be black
nticks = 7.
tn = (indgen(nticks)/(nticks-1))*(maxv-minv)  + minv
tn = strtrim(string(tn,format='(f8.2)'),2)
colorbar,POSITION=[0.15, 0.50, 0.95, 0.52],$
divisions=nticks-1,ticknames=tn,charsize = 0.8,range=[minv,maxv]



;overplot earth, L shells, etc.
earthx = COS((2*!PI/99.0)*FINDGEN(100))
earthy = SIN((2*!PI/99.0)*FINDGEN(100))

;latitude lines
lats = [0,10,20,30,40,50,60,70,80]
lats = [-1*reverse(lats[1:n_elements(lats)-1]),lats]

L2 = dipole(2.)
L4 = dipole(4.)
L6 = dipole(6.)
L8 = dipole(8.)

Lsc=[RBSPa_leq1,RBSPa_leq2,FB_leq1,FB_leq2]

	LstR = 0.
	Lstlat = 0.
	for i=0,n_elements(Lsc)-1 do $
		Lsttmp = dipole(Lsc[i]) & $
		LstR = [LstR,Lsttmp.R] & $
		Lstlat = [Lstlat,Lsttmp.lat]


	Lst = {R:LstR[1:n_elements(LstR)-1],lat:Lstlat[1:n_elements(LstR)-1]}


oplot,earthx,earthy,color=60
;oplot,replicate(1.078,360.),indgen(360.)*!dtor,/polar,color=80

oplot,replicate(1.078,360.)*cos(indgen(360.)*!dtor),replicate(1.078,360.)*sin(indgen(360.)*!dtor),color=80
oplot,L2.R/6370.*cos(L2.lat*!dtor),L2.R/6370.*sin(L2.lat*!dtor),color=120
oplot,L2.R/6370.*cos(L2.lat*!dtor),-1*L2.R/6370.*sin(L2.lat*!dtor),color=120

oplot,L4.R/6370.*cos(L4.lat*!dtor),L4.R/6370.*sin(L4.lat*!dtor),color=120
oplot,L4.R/6370.*cos(L4.lat*!dtor),-1*L4.R/6370.*sin(L4.lat*!dtor),color=120

oplot,L6.R/6370.*cos(L6.lat*!dtor),L6.R/6370.*sin(L6.lat*!dtor),color=120
oplot,L6.R/6370.*cos(L6.lat*!dtor),-1*L6.R/6370.*sin(L6.lat*!dtor),color=120

oplot,L8.R/6370.*cos(L8.lat*!dtor),L8.R/6370.*sin(L8.lat*!dtor),color=120
oplot,L8.R/6370.*cos(L8.lat*!dtor),-1*L8.R/6370.*sin(L8.lat*!dtor),color=120


if keyword_set(Lsc) then oplot,Lst.R/6370.*cos(Lst.lat*!dtor),Lst.R/6370.*sin(Lst.lat*!dtor),color=160 & oplot,Lst.R/6370.*cos(Lst.lat*!dtor),-1*Lst.R/6370.*sin(Lst.lat*!dtor),color=160
for i=0,n_elements(lats)-1 do oplot,[1,50]*cos([lats[i]*!dtor,lats[i]*!dtor]),[1,50]*sin([lats[i]*!dtor,lats[i]*!dtor]),linestyle=3,color=100
