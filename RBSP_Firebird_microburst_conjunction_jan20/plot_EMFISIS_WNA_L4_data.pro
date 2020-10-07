;Determine chorus properties from EMFISIS WNA L4 data

rbsp_efw_init

path = '/Users/aaronbreneman/Desktop/Research/RBSP_Firebird_microburst_conjunction_jan20/EMFISIS/'
;fn = 'rbsp-a_20160120T19_WNA-wav-cont-bst-sm_fft1024-fa2-fo75-to75_CDF_v4_10e6filter.cdf'
fn2 = 'rbsp-a_magnetometer_4sec-gse_emfisis-L3_20160120_v1.3.2.cdf'
cdf2tplot,path+fn2

fn = 'rbsp-a_wna-survey_emfisis-L4_20160120_v1.5.1.cdf'
    ;  rbsp-a_wna-survey_emfisis-L4_20160120_v1.5.1.cdf
cdf2tplot,path+fn



get_data,'phsvd',data=d,dlim=dlim,lim=lim
store_data,'phsvd',data={x:d.x,y:d.y,v:reform(d.v)},dlim=dlim,lim=lim

get_data,'plansvd',data=d,dlim=dlim,lim=lim
store_data,'plansvd',data={x:d.x,y:d.y,v:reform(d.v)},dlim=dlim,lim=lim

get_data,'ellsvd',data=d,dlim=dlim,lim=lim
store_data,'ellsvd',data={x:d.x,y:d.y,v:reform(d.v)},dlim=dlim,lim=lim

get_data,'bsum',data=d,dlim=dlim,lim=lim
store_data,'bsum',data={x:d.x,y:d.y,v:reform(d.v)},dlim=dlim,lim=lim

get_data,'b3',data=d,dlim=dlim,lim=lim
store_data,'b3',data={x:d.x,y:d.y,v:reform(d.v)},dlim=dlim,lim=lim

;From Wen Li's 2014 paper. She filters SVD chorus values by:
;ellipticity > 0.7, and (4) planarity > 0.4


;minamp = 1d-12
;minamp = 1d-5  ;corresponds to 20 pT
;minamp = 1d-6  ;corresponds to 6 pT
minamp = 1d-7  ;corresponds to 2 pT
;minplan = 0.4
minellip = 0.7
minplan = 0.01
minellip = 0.01


get_data,'bsum',data=d,dlim=dlim,lim=lim
get_data,'esum',data=e,dlim=dlime,lim=lime
get_data,'plansvd',data=d2,dlim=dlim2,lim=lim2
get_data,'ellsvd',data=d3,dlim=dlim3,lim=lim3


bad = where(d.y lt minamp)
bad2 = where(d2.y lt minplan)
bad3 = where(d3.y lt minellip)

if bad[0] ne -1 then d.y[bad] = !values.f_nan
if bad2[0] ne -1 then d.y[bad2] = !values.f_nan
if bad3[0] ne -1 then d.y[bad3] = !values.f_nan

if bad[0] ne -1 then e.y[bad] = !values.f_nan
if bad2[0] ne -1 then e.y[bad2] = !values.f_nan
if bad3[0] ne -1 then e.y[bad3] = !values.f_nan

if bad[0] ne -1 then d2.y[bad] = !values.f_nan
if bad2[0] ne -1 then d2.y[bad2] = !values.f_nan
if bad3[0] ne -1 then d2.y[bad3] = !values.f_nan

if bad[0] ne -1 then d3.y[bad] = !values.f_nan
if bad2[0] ne -1 then d3.y[bad2] = !values.f_nan
if bad3[0] ne -1 then d3.y[bad3] = !values.f_nan



store_data,'bsum',data={x:d.x,y:d.y,v:d.v},dlim=dlim,lim=lim
store_data,'esum',data={x:e.x,y:e.y,v:e.v},dlim=dlime,lim=lime
store_data,'plansvd',data={x:d2.x,y:d2.y,v:d2.v},dlim=dlim2,lim=lim2
store_data,'ellipsvd',data={x:d3.x,y:d3.y,v:d3.v},dlim=dlim3,lim=lim3


;----------------------------
get_data,'bsum',tt,dd,vv
tinterpol_mxn,'Magnitude',tt,newname='Magnitude'
get_data,'Magnitude',t,b
store_data,'fce',t,28.*b
store_data,'fce_2',t,28.*b/2.
store_data,'fce_01',t,28.*b*0.1

options,['fce','fce_2','fce_01'],'spec',0
options,['fce','fce_2','fce_01'],'thick',3

yspec = [200,3000]
ylim,['fce','fce_2','fce_01'],200,3000,1
ylim,'bsum',yspec,1
ylim,'esum',yspec,1
ylim,'thsvd2',yspec,1
ylim,'phsvd2',yspec,1
ylim,'mltdiff_tsy04',-5,5
ylim,'ldiff_tsy04',-2,2

store_data,'bcomb',data=['bsum','fce'];,'fce_2','fce_01','bsum']
ylim,'bcomb',yspec,1

;tplot,['fce','fce_2','fce_01','bsum','thsvd2']




;get_data,'esum',data=d,dlim=dlim,lim=lim
;if bad[0] ne -1 then d.y[bad] = !values.f_nan
;if bad2[0] ne -1 then d.y[bad2] = !values.f_nan
;store_data,'esum',data={x:d.x,y:d.y,v:reform(d.v)},dlim=dlim,lim=lim


;Create single phi variable that ranges from 0-360
get_data,'phsvd',data=d,dlim=dlim,lim=lim
if bad[0] ne -1 then d.y[bad] = !values.f_nan
if bad2[0] ne -1 then d.y[bad2] = !values.f_nan
if bad3[0] ne -1 then d.y[bad3] = !values.f_nan
goo = where(d.y lt 0.)
d360 = d.y
;change to 0-360 deg
d360[goo] = d360[goo] + 360.
store_data,'phsvd',data={x:d.x,y:d360,v:reform(d.v)},dlim=dlim,lim=lim
options,'phsvd','ytitle','Phi!C0=antiearthward!C180=earthward'

;Create two separate phi variables, earthward, and anti-earthward.
;Each goes from -180 to 180.
;This has the advantage of being able to scale the colorbar nicely

;anti-earthward
d2 = d360
d2[*] = !values.f_nan
goo = where((d360 ge 0.) and (d360 lt 90.))
d2[goo] = d360[goo]
goo = where((d360 ge 270.) and (d360 le 360.))
d2[goo] = d360[goo] - 360.
store_data,'phsvd_antiearthward',data={x:d.x,y:d2,v:reform(d.v)},dlim=dlim,lim=lim
options,'phsvd_antiearthward','ytitle','Phi!C0=antiearthward!C+90=north'


d2 = d360
d2[*] = !values.f_nan
goo = where((d360 gt 90.) and (d360 le 270.))
d2[goo] = d360[goo]
d2 = -1*d2 + 180.
store_data,'phsvd_earthward',data={x:d.x,y:d2,v:reform(d.v)},dlim=dlim,lim=lim
options,'phsvd_earthward','ytitle','Phi!C0=earthward!C+90=north'


get_data,'thsvd',data=d,dlim=dlim,lim=lim
if bad[0] ne -1 then d.y[bad] = !values.f_nan
if bad2[0] ne -1 then d.y[bad2] = !values.f_nan
if bad3[0] ne -1 then d.y[bad3] = !values.f_nan
store_data,'thsvd',data={x:d.x,y:d.y,v:reform(d.v)},dlim=dlim,lim=lim

get_data,'phpoy1_2_3',data=d,dlim=dlim,lim=lim
if bad[0] ne -1 then d.y[bad] = !values.f_nan
if bad2[0] ne -1 then d.y[bad2] = !values.f_nan
if bad3[0] ne -1 then d.y[bad3] = !values.f_nan
store_data,'phpoy1_2_3',data={x:d.x,y:d.y,v:reform(d.v)},dlim=dlim,lim=lim

get_data,'thpoy1_2_3',data=d,dlim=dlim,lim=lim
if bad[0] ne -1 then d.y[bad] = !values.f_nan
if bad2[0] ne -1 then d.y[bad2] = !values.f_nan
if bad3[0] ne -1 then d.y[bad3] = !values.f_nan
store_data,'thpoy1_2_3',data={x:d.x,y:d.y,v:reform(d.v)},dlim=dlim,lim=lim


;ylim,'*',200,3000,0
ylim,'Magnitude',140,160
;ylim,['fce','fce_2','fce_01'],200,3000,0
zlim,'bsum',minamp,1d-4,1
zlim,'esum',1d-2,1d0,1
zlim,'thsvd',0,50,0

;phi angles are definitely slightly negative
zlim,'phsvd_earthward',-90,90,0
zlim,'phsvd_antiearthward',-90,90,0
zlim,'phsvd',0,360.,0

store_data,'thcomb',data=['thsvd','fce_2','fce_01']
store_data,'bcomb',data=['bsum','fce_2','fce_01']
ylim,'*',30,4000,1




tplot_options,'title','plot_EMFISIS_WNA_l4_data.pro'
tplot,['bcomb','thcomb','plansvd','ellipsvd'];,'phsvd_earthward','phsvd_antiearthward']


tlimit,'2016-01-20/19:00','2016-01-20/20:10'

stop
end
