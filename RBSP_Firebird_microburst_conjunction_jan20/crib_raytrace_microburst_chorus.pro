;Test how rays from a single point source near mag eq can spread out
;as they propagate to 20 deg mlat and beyond.

;loc of PP = 3
;density < 10 @19:44:00
;Bo = 146 nT @19:44:00
;fce = 4088 Hz
;fce/2 = 2044 Hz
;f = 1700 Hz @19:44:00 UT
;wave normal angle limits (from EMFISIS) = -40 to 40
;RBSP-A location  L = 5.77

;FB_leq1 = 5.0926843
;FB_leq2 = 5.248
FB_leq1 = 4.922
FB_leq2 = 5.072

RBSPa_leq = 5.77
;RBSPa_leq = 5.3

;RBSPa_leq = 5.4
;RBSPa_leq = 5.5
;RBSPa_leq = 5.39   ;value if you adjust L to make |B|-|Bmodel|=0
freqv = 1900.
ti = read_write_trace_in(freq=freqv,$
	mmult = .80,$
	lat=-0.93,$
	theta=0.,$
	phi=0.,$
	alt=(6370.*RBSPa_leq)-6370.,$
	final_alt=4000.,$
	model=0,$
	final_lat=-50,$
	pplcp=3.,$
	pplhw=0.5,$
	drl=10000.)


	thetavals = 180+[-40.]
;thetavals = -75.
;thetavals = [-40,-30,-20, -10,0,10,20,30,40]
;thetavals = 0.
freqs = replicate(freqv,n_elements(thetavals))

create_rays,thetavals,freqs=freqs,title='uB3'


dens_bo_profile,freqv,dens_sc=8,bo_sc=146,L_sc=RBSPa_leq;,/ps

restore,'~/Desktop/code/Aaron/github.umn.edu/raytrace/uB3_rays.sav'
plot_rays,xcoord,ycoord,zcoord,xrangeM=[0,6],zrangeM=[-3,3],Lsc=[FB_leq1,FB_leq2];,/psonly



x = read_trace_ta()
plot_resonance_energy,x.xcoord,x.ycoord,x.zcoord,x.lat,$
	freqv,x.dens,x.f_fce,x.N,x.thk,x.wl,$
	Lsc=[FB_leq1,FB_leq2],$
	minkeV=200,$
	maxkeV=850,$
	harmonic=4,$
	type='cyclotron',$
	pitch_angle=5.;,/nonrelativistic;,$
	;/ps
;	scposx=scposx,scposz=scposz,/ps



;  KEYWORDS:    rayx -> (*,n_rays) - Meridional x values (SM coord) for ray (RE)
;				rayy -> Equatorial y
;				rayz -> Meridional z
;				ray_struct -> the structure returned from read_trace_ta()
;				xrangeM -> Meridional x range in RE
;				zrangeM -> Meridional z range in RE
;				xrangeE -> Equatorial x range in RE
;				zrangeE -> Equatorial y range in RE
;				colors -> color for each ray
;				colorsX -> color for each X overplotted
;				oplotX -> [n,3] array of xcoord,ycoord,zcoord to overplot the symbol 'X'
;				kvecs  -> overplot the k-unit-vectors at equally spaced intervals
;							[n,3] array of x,y,z values
;				Lsc    -> Overplots L-shell of sc
;				psonly -> only plot ps (to ~/Desktop/rayplot.ps)
;				k_spacing -> spacing of k-vector arrows (km). Defaults to 300 km



v = read_trace_ta()
plot_rays,ray_struct=v,xrangeM=[2,6]



plot_rays,ray_struct='mb_rays'
