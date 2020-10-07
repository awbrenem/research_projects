

;Uncertainty in field values
;FB4:
;1) timing error (2-3 sec, maybe)
;2) difference b/t different models
;--> Turns out #2 is a larger error


path = '~/Desktop/Research/RBSP_Firebird_microburst_conjunction_jan20/TSY_files/'
tplot_restore,filenames=path+'definitive_FB4_field_mapping.tplot'
tplot_restore,filenames=path+'definitive_RBSP_field_mapping.tplot'

rbsp_efw_init

;------
date = '2016-01-20'
timespan,date

store_data,'Lall_FB4',data=['FB4!CL-shell-t89','FB4!CL-shell-t01','FB4!CL-shell-t04']
options,'Lall_FB4','colors',[0,0,20,20,50,50]


t0 = time_double('2016-01-20/19:43:20')
t1 = time_double('2016-01-20/19:44:40')
tlimit,t0,t1


;***************************************************
;Total extent of chorus observed by RBSPa and RBSPb
;chorus_range = [5.5,5.9]
;MLTrange_rbspa = [9.91,10.71]
;MLTrange_rbspb = [10.33,10.77]

;get_data,'RBSPa!CL-shell-t04',t,d
;cr0 = replicate(chorus_range[0],n_elements(t))
;cr1 = replicate(chorus_range[1],n_elements(t))
;store_data,'cr0',t,cr0
;store_data,'cr1',t,cr1
;store_data,'chorus_range',data=['cr0','cr1']
;***************************************************


;Ensure common time base
get_data,'RBSPa!CL-shell-t89_adj',times,d
tinterpol_mxn,'RBSPa!CL-shell-t01_adj',times,newname='RBSPa!CL-shell-t01_adj'
tinterpol_mxn,'RBSPa!CL-shell-t04s_adj',times,newname='RBSPa!CL-shell-t04_adj'
tinterpol_mxn,'FB4!CL-shell-t89',times,newname='FB4!CL-shell-t89'
tinterpol_mxn,'FB4!CL-shell-t01',times,newname='FB4!CL-shell-t01'
tinterpol_mxn,'FB4!CL-shell-t04s',times,newname='FB4!CL-shell-t04'

tinterpol_mxn,'RBSPa!Cequatorial-foot-MLT!Ct89',times,newname='RBSPa!Cequatorial-foot-MLT!Ct89'
tinterpol_mxn,'RBSPa!Cequatorial-foot-MLT!Ct01',times,newname='RBSPa!Cequatorial-foot-MLT!Ct01'
tinterpol_mxn,'RBSPa!Cequatorial-foot-MLT!Ct04s',times,newname='RBSPa!Cequatorial-foot-MLT!Ct04'
tinterpol_mxn,'FB4!Cequatorial-foot-MLT!Ct89',times,newname='FB4!Cequatorial-foot-MLT!Ct89'
tinterpol_mxn,'FB4!Cequatorial-foot-MLT!Ct01',times,newname='FB4!Cequatorial-foot-MLT!Ct01'
tinterpol_mxn,'FB4!Cequatorial-foot-MLT!Ct04s',times,newname='FB4!Cequatorial-foot-MLT!Ct04'

tinterpol_mxn,'FB4_B_t89_gse',times,newname='FB4_B_t89_gse'
tinterpol_mxn,'FB4_B_t01_gse',times,newname='FB4_B_t01_gse'
tinterpol_mxn,'FB4_B_t04_gse',times,newname='FB4_B_t04_gse'


;Create Bmag variables

get_data,'FB4_B_t89_gse',t,d  &  bmag = sqrt(d[*,0]^2 + d[*,1]^2 + d[*,2]^2)  &  store_data,'FB4_Bmag_t89',t,bmag
get_data,'FB4_B_t01_gse',t,d  &  bmag = sqrt(d[*,0]^2 + d[*,1]^2 + d[*,2]^2)  &  store_data,'FB4_Bmag_t01',t,bmag
get_data,'FB4_B_t04_gse',t,d  &  bmag = sqrt(d[*,0]^2 + d[*,1]^2 + d[*,2]^2)  &  store_data,'FB4_Bmag_t04',t,bmag
get_data,'rbspa_B_t89_gse',t,d  &  bmag = sqrt(d[*,0]^2 + d[*,1]^2 + d[*,2]^2)  &  store_data,'rbspa_Bmag_t89',t,bmag
get_data,'rbspa_B_t01_gse',t,d  &  bmag = sqrt(d[*,0]^2 + d[*,1]^2 + d[*,2]^2)  &  store_data,'rbspa_Bmag_t01',t,bmag
get_data,'rbspa_B_t04_gse',t,d  &  bmag = sqrt(d[*,0]^2 + d[*,1]^2 + d[*,2]^2)  &  store_data,'rbspa_Bmag_t04',t,bmag
tplot,['FB4_Bmag_t89','rbspa_Bmag_t89']


;Calculate ratio of magnetic fields (RBSPa vs FB4)
div_data,'FB4_Bmag_t89','rbspa_Bmag_t89',newname='Brat_t89'
div_data,'FB4_Bmag_t01','rbspa_Bmag_t01',newname='Brat_t01'
div_data,'FB4_Bmag_t04','rbspa_Bmag_t04',newname='Brat_t04'





;--------------------------------------------------------------
;Calculate the spacecraft separations perpendicular to Bo.


sc_absolute_separation,'RBSPa!CL-shell-t89_adj','FB4!CL-shell-t89','RBSPa!Cequatorial-foot-MLT!Ct89','FB4!Cequatorial-foot-MLT!Ct89';,/km
copy_data,'separation_absolute','separation_absolute_t89'  &  copy_data,'separation_mlt','separation_mlt_t89'  &  copy_data,'separation_lvalue','separation_lvalue_t89'
tplot,'separation_comb_t89'

sc_absolute_separation,'RBSPa!CL-shell-t01_adj','FB4!CL-shell-t01','RBSPa!Cequatorial-foot-MLT!Ct01','FB4!Cequatorial-foot-MLT!Ct01';,/km
copy_data,'separation_absolute','separation_absolute_t01'  &  copy_data,'separation_mlt','separation_mlt_t01'  &  copy_data,'separation_lvalue','separation_lvalue_t01'
tplot,'separation_comb_t01'

sc_absolute_separation,'RBSPa!CL-shell-t04_adj','FB4!CL-shell-t04','RBSPa!Cequatorial-foot-MLT!Ct04','FB4!Cequatorial-foot-MLT!Ct04';,/km
copy_data,'separation_absolute','separation_absolute_t04'  &  copy_data,'separation_mlt','separation_mlt_t04'  &  copy_data,'separation_lvalue','separation_lvalue_t04'
tplot,'separation_comb_t04'


store_data,'lsep_comb',data=['separation_lvalue_t89','separation_lvalue_t01','separation_lvalue_t04']
store_data,'mltsep_comb',data=['separation_mlt_t89','separation_mlt_t01','separation_mlt_t04']
store_data,'abssep_comb',data=['separation_absolute_t89','separation_absolute_t01','separation_absolute_t04']


ylim,'lsep_comb',-2.,2.
tplot,['lsep_comb','mltsep_comb','abssep_comb']



;Reduce to the extreme deltaL and deltaMLT values to calculate separation

get_data,'separation_lvalue_t89',ttmp,t89dL
get_data,'separation_lvalue_t01',ttmp,t01dL
get_data,'separation_lvalue_t04',ttmp,t04dL

get_data,'separation_mlt_t89',ttmp,t89dmlt
get_data,'separation_mlt_t01',ttmp,t01dmlt
get_data,'separation_mlt_t04',ttmp,t04dmlt

maxdL = fltarr(n_elements(ttmp))
mindL = fltarr(n_elements(ttmp))
maxdmlt = fltarr(n_elements(ttmp))
mindmlt = fltarr(n_elements(ttmp))

for i=0,n_elements(ttmp)-1 do begin ;$
  maxdL[i] = t89dL[i] > t01dL[i] > t04dL[i]  ;& $
  mindL[i] = t89dL[i] < t01dL[i] < t04dL[i] ;& $
  maxdmlt[i] = t89dmlt[i] > t01dmlt[i] > t04dmlt[i] ;& $
  mindmlt[i] = t89dmlt[i] < t01dmlt[i] < t04dmlt[i]
endfor

stop

store_data,'maxdL',ttmp,maxdL
store_data,'mindL',ttmp,mindL
store_data,'maxdmlt',ttmp,maxdmlt
store_data,'mindmlt',ttmp,mindmlt

store_data,'dL_extreme',data=['maxdL','mindL']
store_data,'dMLT_extreme',data=['maxdmlt','mindmlt']

tplot,['dL_extreme','dMLT_extreme']



;Also calculate the extreme L value for each time
get_data,'RBSPa!CL-shell-t89_adj',tt,t89R
get_data,'RBSPa!CL-shell-t01_adj',tt,t01R
get_data,'RBSPa!CL-shell-t04_adj',tt,t04R
get_data,'FB4!CL-shell-t89',tt,t89F
get_data,'FB4!CL-shell-t01',tt,t01F
get_data,'FB4!CL-shell-t04',tt,t04F

store_data,'Ltest',data=['RBSPa!CL-shell-t89_adj','RBSPa!CL-shell-t01_adj','RBSPa!CL-shell-t04_adj','FB4!CL-shell-t89','FB4!CL-shell-t01','FB4!CL-shell-t04']
options,'Ltest','colors',[0,0,0,250,250,250]

maxL = fltarr(n_elements(tt))
minL = fltarr(n_elements(tt))

for i=0,n_elements(tt)-1 do begin
  maxL[i] = max([t89R[i],t01R[i],t04R[i],t89F[i],t01F[i],t04F[i]])
  minL[i] = min([t89R[i],t01R[i],t04R[i],t89F[i],t01F[i],t04F[i]])
;  maxL[i] = t89R[i] > t01R[i] > t04R[i] > t89F[i] > t01F[i] > t04F[i]
;  minL[i] = t89R[i] < t01R[i] < t04R[i] < t89F[i] < t01F[i] < t04F[i] ;& $
endfor


store_data,'maxL',tt,maxL
store_data,'minL',tt,minL

store_data,'L_extreme',data=['minL','maxL']
options,'L_extreme','colors',[0,250]

ylim,['Ltest','L_extreme'],4,7
tplot,['Ltest','L_extreme']
stop


;Calculate absolute separation using the extreme dL and dMLT values

  ;put MLT in degrees
  get_data,'maxdmlt',tt,maxdmlt
  get_data,'mindmlt',tt,mindmlt
  dtmax = abs(maxdmlt - 12)*360./24.
  dtmin = abs(mindmlt - 12)*360./24.

daz_max = abs(2*!pi*maxL*(dtmax/360.))
daz_min = abs(2*!pi*minL*(dtmin/360.))

store_data,'daz_max',tt,daz_max
store_data,'daz_min',tt,daz_min
store_data,'dazcomb',data=['daz_min','daz_max']
options,'dazcomb','colors',[0,250]

store_data,'dtmax',tt,dtmax
store_data,'dtmin',tt,dtmin
store_data,'dtcomb',data=['dtmin','dtmax']
options,'dtcomb','colors',[0,250]


tplot,['dazcomb','dtcomb']

sep_max = sqrt(daz_max^2 + (6370.*maxdL)^2)
sep_min = sqrt(daz_min^2 + (6370.*mindL)^2)



store_data,'sep_max',tt,sep_max/6370.
store_data,'sep_min',tt,sep_min/6370.
store_data,'sepcomb',data=['sep_min','sep_max']
options,'sepcomb','colors',[0,250]

tplot,['dazcomb','dtcomb','sepcomb']



;sc_absolute_separation,'minL','maxL',$
;'RBSPa!Cequatorial-foot-MLT!Ct04',$
;'FB4!Cequatorial-foot-MLT!Ct04';,/km
;copy_data,'separation_comb','separation_comb_t04'
;copy_data,'separation_absolute','separation_absolute_t04'
;copy_data,'separation_mlt','separation_mlt_t04'
;copy_data,'separation_lvalue','separation_lvalue_t04'
;tplot,'separation_comb_t04'


;x1 - x2 = l1v*sin(t1*!dtor) - l2v*sin(t2*!dtor)

;  x1 = l1v * sin(t1*!dtor)
;  y1 = l1v * cos(t1*!dtor)
;  x2 = l2v * sin(t2*!dtor)
;  y2 = l2v * cos(t2*!dtor)
;  daa = sqrt((abs(x1-x2))^2 + (abs(y1-y2))^2)


;t89-t89
;t01-t01
;t04-t04
;t89-t01
;t89-t04
;t01-t04



path = '~/Desktop/Research/RBSP_Firebird_microburst_conjunction_jan20/TSY_files/'

tplot_restore,filenames=path+'fb4_ts89_mapping_500km_20160120.tplot'
tplot_restore,filenames=path+'RBSPa_tsy89_mapping_500km_20160120.tplot'

tplot_restore,filenames=path+'fb4_ts01_mapping_500km_20160120.tplot'
tplot_restore,filenames=path+'RBSPa_tsy01_mapping_500km_20160120.tplot'

tplot_restore,filenames=path+'fb4_ts04_mapping_500km_20160120.tplot'
tplot_restore,filenames=path+'RBSPa_tsy04_mapping_500km_20160120.tplot'


dif_data,'FB4_out_iono_foot_north_gse_t89','RBSPa_out_iono_foot_north_gse_t89',newname='diff500_t89t89'
dif_data,'FB4_out_iono_foot_north_gse_t01','RBSPa_out_iono_foot_north_gse_t01',newname='diff500_t01t01'
dif_data,'FB4_out_iono_foot_north_gse_t04s','RBSPa_out_iono_foot_north_gse_t04s',newname='diff500_t04t04'
dif_data,'FB4_out_iono_foot_north_gse_t89','RBSPa_out_iono_foot_north_gse_t01',newname='diff500_t89t01'
dif_data,'FB4_out_iono_foot_north_gse_t89','RBSPa_out_iono_foot_north_gse_t04s',newname='diff500_t89t04'
dif_data,'FB4_out_iono_foot_north_gse_t01','RBSPa_out_iono_foot_north_gse_t04s',newname='diff500_t01t04'


get_data,'diff500_t89t89',tt,dd
sep = sqrt(dd[*,0]^2 + dd[*,1]^2 + dd[*,2]^2)
store_data,'diff500_t89t89',tt,sep

get_data,'diff500_t01t01',tt,dd
sep = sqrt(dd[*,0]^2 + dd[*,1]^2 + dd[*,2]^2)
store_data,'diff500_t01t01',tt,sep

get_data,'diff500_t04t04',tt,dd
sep = sqrt(dd[*,0]^2 + dd[*,1]^2 + dd[*,2]^2)
store_data,'diff500_t04t04',tt,sep

get_data,'diff500_t89t01',tt,dd
sep = sqrt(dd[*,0]^2 + dd[*,1]^2 + dd[*,2]^2)
store_data,'diff500_t89t01',tt,sep

get_data,'diff500_t89t04',tt,dd
sep = sqrt(dd[*,0]^2 + dd[*,1]^2 + dd[*,2]^2)
store_data,'diff500_t89t04',tt,sep

get_data,'diff500_t01t04',tt,dd
sep = sqrt(dd[*,0]^2 + dd[*,1]^2 + dd[*,2]^2)
store_data,'diff500_t01t04',tt,sep

store_data,'diff500',data='diff500_t*'

tlimit,'2016-01-20/19:43:20','2016-01-20/19:44:40'

ylim,'diff500',40,700,1
options,'diff500','ytitle','Cross-field separation!Cat 500 km!C[km]'
tplot,'diff500'





store_data,'lsep_comb',data=['separation_lvalue_t89','separation_lvalue_t01','separation_lvalue_t04']
store_data,'mltsep_comb',data=['separation_mlt_t89','separation_mlt_t01','separation_mlt_t04']
store_data,'abssep_comb',data=['separation_absolute_t89','separation_absolute_t01','separation_absolute_t04']


ylim,'lsep_comb',-2.,2.
tplot,['lsep_comb','mltsep_comb','abssep_comb']














;-----------------------------------------------------------------------
;Determine the focusing factor of fields so I can map the cross-field separation
;to the position of FB
;-----------------------------------------------------------------------

;conservation of flux in narrowing flux tube
;Find ratio of B2/B1 = A1/A2. (Note that 70 km used here may be a bit
;A = r^2
;B2/B1 = (r1/r2)^2
;sep2 = sep1/(sqrt(B2/B1))



tinterpol_mxn,'FB4_B_igrf_gse','rbspa_B_igrf_gse',newname='FB4_B_igrf_gse'
tinterpol_mxn,'FB4_B_t89_gse','rbspa_B_igrf_gse',newname='FB4_B_t89_gse'
tinterpol_mxn,'FB4_B_t96_gse','rbspa_B_igrf_gse',newname='FB4_B_t96_gse'
tinterpol_mxn,'FB4_B_t01_gse','rbspa_B_igrf_gse',newname='FB4_B_t01_gse'
tinterpol_mxn,'FB4_B_t04_gse','rbspa_B_igrf_gse',newname='FB4_B_t04_gse'


get_data,'FB4_B_t89_gse',t,d  &  bmag = sqrt(d[*,0]^2 + d[*,1]^2 + d[*,2]^2)  &  store_data,'FB4_Bmag_t89',t,bmag
get_data,'FB4_B_t01_gse',t,d  &  bmag = sqrt(d[*,0]^2 + d[*,1]^2 + d[*,2]^2)  &  store_data,'FB4_Bmag_t01',t,bmag
get_data,'FB4_B_t04_gse',t,d  &  bmag = sqrt(d[*,0]^2 + d[*,1]^2 + d[*,2]^2)  &  store_data,'FB4_Bmag_t04',t,bmag


get_data,'rbspa_B_t89_gse',t,d  &  bmag = sqrt(d[*,0]^2 + d[*,1]^2 + d[*,2]^2)  &  store_data,'rbspa_Bmag_t89',t,bmag
get_data,'rbspa_B_t01_gse',t,d  &  bmag = sqrt(d[*,0]^2 + d[*,1]^2 + d[*,2]^2)  &  store_data,'rbspa_Bmag_t01',t,bmag
get_data,'rbspa_B_t04_gse',t,d  &  bmag = sqrt(d[*,0]^2 + d[*,1]^2 + d[*,2]^2)  &  store_data,'rbspa_Bmag_t04',t,bmag


tplot,['FB4_Bmag_igrf','rbspa_Bmag_igrf']

;Calculate ratio of magnetic fields (RBSPa vs FB4)
div_data,'FB4_Bmag_t89','rbspa_Bmag_t89',newname='Brat_t89'
div_data,'FB4_Bmag_t01','rbspa_Bmag_t01',newname='Brat_t01'
div_data,'FB4_Bmag_t04','rbspa_Bmag_t04',newname='Brat_t04'

;tplot,['dL_extreme','separation_lvalue_t89']
;tplot,['dMLT_extreme','separation_mlt_t89']


;Put MLT values in km
get_data,'separation_mlt_t89',t,mlteq

;circum = 6370d*abs(leq)*2.*!dpi

;tplot,['separation_mlt_t89_km','separation_mlt_t89']

get_data,'Brat_t89',t,brat



get_data,'separation_absolute_t89',t,sep_eq
get_data,'separation_lvalue_t89',t,leq
get_data,'separation_mlt_t89',t,mlteq
circum = 2.*!pi*abs(leq)*6370.
km = (mlteq/24.) * circum
store_data,'separation_mlt_t89_km',t,abs(km)
mlt_500 = mlteq/sqrt(brat)
mlt_500_km = km/sqrt(brat)
sep_500 = sep_eq/sqrt(brat)
l_500 = leq/sqrt(brat)
store_data,'separation_absolute_500_t89',t,sep_500*6370.
store_data,'separation_lvalue_500_t89',t,abs(l_500*6370.)
store_data,'separation_mlt_500_t89',t,mlt_500*6370.
store_data,'separation_mlt_500_km_t89',t,mlt_500_km
options,'separation_mlt_500_km_t89','ytitle','separation T89!CMLT 500km!C[km]'


get_data,'Brat_t01',t,brat
get_data,'separation_absolute_t01',t,sep_eq
get_data,'separation_lvalue_t01',t,leq
get_data,'separation_mlt_t01',t,mlteq
circum = 2.*!pi*abs(leq)*6370.
km = (mlteq/24.) * circum
store_data,'separation_mlt_t01_km',t,abs(km)
mlt_500 = mlteq/sqrt(brat)
mlt_500_km = km/sqrt(brat)
sep_500 = sep_eq/sqrt(brat)
l_500 = leq/sqrt(brat)
store_data,'separation_absolute_500_t01',t,sep_500*6370.
store_data,'separation_lvalue_500_t01',t,abs(l_500*6370.)
store_data,'separation_mlt_500_t01',t,mlt_500*6370.
store_data,'separation_mlt_500_km_t01',t,mlt_500_km
options,'separation_mlt_500_km_t01','ytitle','separation T01!CMLT 500km!C[km]'

get_data,'Brat_t04',t,brat
get_data,'separation_absolute_t04',t,sep_eq
get_data,'separation_lvalue_t04',t,leq
get_data,'separation_mlt_t04',t,mlteq
circum = 2.*!pi*abs(leq)*6370.
km = (mlteq/24.) * circum
store_data,'separation_mlt_t04_km',t,abs(km)
mlt_500 = mlteq/sqrt(brat)
mlt_500_km = km/sqrt(brat)
sep_500 = sep_eq/sqrt(brat)
l_500 = leq/sqrt(brat)
store_data,'separation_absolute_500_t04',t,sep_500*6370.
store_data,'separation_lvalue_500_t04',t,abs(l_500*6370.)
store_data,'separation_mlt_500_t04',t,mlt_500*6370.
store_data,'separation_mlt_500_km_t04',t,mlt_500_km
options,'separation_mlt_500_km_t04','ytitle','separation T04!CMLT 500km!C[km]'


store_data,'separation_absolute_500km',data='separation_absolute_500_' + ['t89','t01','t04']
options,'separation_absolute_500km','colors',[0,50,254]
store_data,'separation_lvalue_500_km',data='separation_lvalue_500_' + ['t89','t01','t04']
options,'separation_lvalue_500_km','colors',[0,50,254]
store_data,'separation_mlt_500_km',data='separation_mlt_500_km_' + ['t89','t01','t04']
options,'separation_mlt_500_km','colors',[0,50,254]


tplot,['separation_absolute_500km','separation_lvalue_500_km','separation_mlt_500_km']



ylim,'separation_absolute_500km',0,1000
ylim,'abssep_comb',0,1.5d4
tplot,['abssep_comb','separation_absolute_500km']


get_data,'separation_absolute_t04',tt,dd
store_data,'separation_absolute_t04T',tt,dd*6370.
tplot,['separation_absolute_t04T','separation_absolute_500_t04','Brat_t04']


tplot,['separation_absolute_500_t04','Brat_t04']



store_data,'mltsep_comb',data=['separation_mlt_t89','separation_mlt_t01','separation_mlt_t04']

options,'separation_mlt_500_km','colors',[0,50,250]
options,'mltsep_comb','colors',[0,50,250]
tplot,['separation_mlt_500_km','mltsep_comb']


stop






store_data,'ltst',data=['rbspa_state_lshell','RBSPa!CL-shell-t89','RBSPa!CL-shell-t01','RBSPa!CL-shell-t04s']




end
