

pro rbsp_rbsp_conjunction_plot

fns = ['RBSPa_t04s_20171121_1900-2020.tplot',$
'RBSPa_t01_20171121_1900-2020.tplot',$
'RBSPa_t89_Kp=4.00000_20171121_1900-2020.tplot',$
'RBSPb_t04s_20171121_1900-2020.tplot',$
'RBSPb_t01_20171121_1900-2020.tplot',$
'RBSPb_t89_Kp=4.00000_20171121_1900-2020.tplot']



;Makes conjunction plots like in Breneman17 for FIREBIRD and RBSP conjunctions.
;Uses saved tplot files from tplot_save_tsy_mapping_firebird_rbsp.pro
;that have the TSY mapped values.

rbsp_efw_init


;--------------------------------
;Input
;--------------------------------

date = '2017-11-21'
;Times for data plot
t0z = '2017-11-21/18:30:00'
t1z = '2017-11-21/20:10:00'

;plot1.yrange=[5,7]
;plot2.yrange=[9.5,11.5]
;plot3.yrange=[-1,1]
;plot4.yrange=[-0.06,0.02]
;plot5.yrange=[10,10000]


timelabel = 'min'  ;min or sec


datestr = strmid(date,0,4)+strmid(date,5,2)+strmid(date,8,2)
t0zs = strmid(t0z,11,2)+strmid(t0z,14,2)+strmid(t0z,17,2)
t1zs = strmid(t1z,11,2)+strmid(t1z,14,2)+strmid(t1z,17,2)


t0z = time_double(t0z)
t1z = time_double(t1z)


;--------------------------------

fileroot = '~/Desktop/Research/RBSP_Firebird_microburst_conjunctions_all/data/'
for i=0,n_elements(fns)-1 do tplot_restore,filenames=fileroot+fns[i]

;where to save .eps files and what to call them.
saveroot = '~/Desktop/Research/RBSP_Firebird_microburst_conjunctions_all/all_conjunctions/'+date
savename = 'conjunction_RBSPa_RBSPb_'+datestr+'_'+t0zs+'-'+t1zs


;--------------------------------
;Ensure common time base
;--------------------------------

get_data,'RBSPa'+'!CL-shell-t89',times,d
tinterpol_mxn,'RBSPa'+'!CL-shell-t01',times,newname='RBSPa'+'!CL-shell-t01'
tinterpol_mxn,'RBSPa'+'!CL-shell-t04s',times,newname='RBSPa'+'!CL-shell-t04'
tinterpol_mxn,'RBSPb'+'!CL-shell-t89',times,newname='RBSPb'+'!CL-shell-t89'
tinterpol_mxn,'RBSPb'+'!CL-shell-t01',times,newname='RBSPb'+'!CL-shell-t01'
tinterpol_mxn,'RBSPb'+'!CL-shell-t04s',times,newname='RBSPb'+'!CL-shell-t04'

tinterpol_mxn,'RBSPa'+'!Cequatorial-foot-MLT!Ct89',times,newname='RBSPa'+'!Cequatorial-foot-MLT!Ct89'
tinterpol_mxn,'RBSPa'+'!Cequatorial-foot-MLT!Ct01',times,newname='RBSPa'+'!Cequatorial-foot-MLT!Ct01'
tinterpol_mxn,'RBSPa'+'!Cequatorial-foot-MLT!Ct04s',times,newname='RBSPa'+'!Cequatorial-foot-MLT!Ct04'
tinterpol_mxn,'RBSPb'+'!Cequatorial-foot-MLT!Ct89',times,newname='RBSPb'+'!Cequatorial-foot-MLT!Ct89'
tinterpol_mxn,'RBSPb'+'!Cequatorial-foot-MLT!Ct01',times,newname='RBSPb'+'!Cequatorial-foot-MLT!Ct01'
tinterpol_mxn,'RBSPb'+'!Cequatorial-foot-MLT!Ct04s',times,newname='RBSPb'+'!Cequatorial-foot-MLT!Ct04'



;--------------------------------------------------------------
;Calculate the spacecraft separations perpendicular to Bo.
;--------------------------------------------------------------

store_data,['separation_absolute','separation_mlt','separation_lvalue'],/delete
sc_absolute_separation,'RBSPa'+'!CL-shell-t89','RBSPb'+'!CL-shell-t89','RBSPa'+'!Cequatorial-foot-MLT!Ct89','RBSPb'+'!Cequatorial-foot-MLT!Ct89';,/km
store_data,['RBSPb'+'!CL-shell-t89_tmp','RBSPa'+'!Cequatorial-foot-MLT!Ct89_tmp','RBSPb'+'!Cequatorial-foot-MLT!Ct89_tmp','RBSPa'+'!CL-shell-t89_tmp'],/delete
copy_data,'separation_absolute','separation_absolute_t89'
copy_data,'separation_mlt','separation_mlt_t89'
copy_data,'separation_lvalue','separation_lvalue_t89'
;copy_data,'separation_comb','separation_comb_t89'

store_data,['separation_absolute','separation_mlt','separation_lvalue'],/delete
sc_absolute_separation,'RBSPa'+'!CL-shell-t01','RBSPb'+'!CL-shell-t01','RBSPa'+'!Cequatorial-foot-MLT!Ct01','RBSPb'+'!Cequatorial-foot-MLT!Ct01';,/km
store_data,['RBSPb'+'!CL-shell-t01_tmp','RBSPa'+'!Cequatorial-foot-MLT!Ct01_tmp','RBSPb'+'!Cequatorial-foot-MLT!Ct01_tmp','RBSPa'+'!CL-shell-t01_tmp'],/delete
copy_data,'separation_absolute','separation_absolute_t01'
copy_data,'separation_mlt','separation_mlt_t01'
copy_data,'separation_lvalue','separation_lvalue_t01'
;copy_data,'separation_comb','separation_comb_t01'

store_data,['separation_absolute','separation_mlt','separation_lvalue'],/delete
sc_absolute_separation,'RBSPa'+'!CL-shell-t04','RBSPb'+'!CL-shell-t04','RBSPa'+'!Cequatorial-foot-MLT!Ct04','RBSPb'+'!Cequatorial-foot-MLT!Ct04';,/km
store_data,['RBSPb'+'!CL-shell-t04_tmp','RBSPa'+'!Cequatorial-foot-MLT!Ct04_tmp','RBSPb'+'!Cequatorial-foot-MLT!Ct04_tmp','RBSPa'+'!CL-shell-t04_tmp'],/delete
copy_data,'separation_absolute','separation_absolute_t04'
copy_data,'separation_mlt','separation_mlt_t04'
copy_data,'separation_lvalue','separation_lvalue_t04'
;copy_data,'separation_comb','separation_comb_t04'


store_data,'lsep_comb',data=['separation_lvalue_t89','separation_lvalue_t01','separation_lvalue_t04']
store_data,'mltsep_comb',data=['separation_mlt_t89','separation_mlt_t01','separation_mlt_t04']
store_data,'abssep_comb',data=['separation_absolute_t89','separation_absolute_t01','separation_absolute_t04']


ylim,'lsep_comb',-2.,2.
;tplot,['lsep_comb','mltsep_comb','abssep_comb']


;-------------------------------------------------------------------------
;Using values of L and MLT of all the TSY models, find the extreme values at
;each time.
;-------------------------------------------------------------------------

get_data,'separation_lvalue_t89',ttmp,t89dL
get_data,'separation_lvalue_t01',t,t01dL
get_data,'separation_lvalue_t04',t,t04dL

get_data,'separation_mlt_t89',t,t89dmlt
get_data,'separation_mlt_t01',t,t01dmlt
get_data,'separation_mlt_t04',t,t04dmlt

get_data,'separation_absolute_t89',t,t89sep
get_data,'separation_absolute_t01',t,t01sep
get_data,'separation_absolute_t04',t,t04sep

maxdL = fltarr(n_elements(ttmp))
mindL = fltarr(n_elements(ttmp))
maxdmlt = fltarr(n_elements(ttmp))
mindmlt = fltarr(n_elements(ttmp))
minsep = fltarr(n_elements(ttmp))
maxsep = fltarr(n_elements(ttmp))



for i=0,n_elements(ttmp)-1 do begin ;$
  maxdL[i] = t89dL[i] > t01dL[i] > t04dL[i]  ;& $
  mindL[i] = t89dL[i] < t01dL[i] < t04dL[i] ;& $
  maxdmlt[i] = t89dmlt[i] > t01dmlt[i] > t04dmlt[i] ;& $
  mindmlt[i] = t89dmlt[i] < t01dmlt[i] < t04dmlt[i]

  minsep[i] = t89sep[i] < t01sep[i] < t04sep[i]
  maxsep[i] = t89sep[i] > t01sep[i] > t04sep[i]

endfor


store_data,'maxdL',ttmp,maxdL
store_data,'mindL',ttmp,mindL
store_data,'maxdmlt',ttmp,maxdmlt
store_data,'mindmlt',ttmp,mindmlt
store_data,'minsep',ttmp,minsep
store_data,'maxsep',ttmp,maxsep



;-------------------------------------------------
;Extreme L values for each time

get_data,'RBSPa'+'!CL-shell-t89',ttmp,t89R
get_data,'RBSPa'+'!CL-shell-t01',t,t01R
get_data,'RBSPa'+'!CL-shell-t04',t,t04R
get_data,'RBSPb'+'!CL-shell-t89',t,t89F
get_data,'RBSPb'+'!CL-shell-t01',t,t01F
get_data,'RBSPb'+'!CL-shell-t04',t,t04F

store_data,'Ltest',data=['RBSPa'+'!CL-shell-t89','RBSPa'+'!CL-shell-t01','RBSPa'+'!CL-shell-t04','RBSPb'+'!CL-shell-t89','RBSPb'+'!CL-shell-t01','RBSPb'+'!CL-shell-t04']
options,'Ltest','colors',[0,0,0,250,250,250]

maxLFB = fltarr(n_elements(ttmp))
minLFB = fltarr(n_elements(ttmp))
maxLRB = fltarr(n_elements(ttmp))
minLRB = fltarr(n_elements(ttmp))


for i=0,n_elements(ttmp)-1 do begin
  maxLFB[i] = t89F[i] > t01F[i] > t04F[i]
  minLFB[i] = t89F[i] < t01F[i] < t04F[i] ;& $
  maxLRB[i] = t89R[i] > t01R[i] > t04R[i]
  minLRB[i] = t89R[i] < t01R[i] < t04R[i] ;& $
endfor

store_data,'maxLFB',ttmp,maxLFB
store_data,'minLFB',ttmp,minLFB
store_data,'maxLRB',ttmp,maxLRB
store_data,'minLRB',ttmp,minLRB

;----------------------------------------------------
;Extreme MLT values for each time

get_data,'RBSPa'+'!Cequatorial-foot-MLT!Ct89',ttmp,t89R
get_data,'RBSPa'+'!Cequatorial-foot-MLT!Ct01',ttmp,t01R
get_data,'RBSPa'+'!Cequatorial-foot-MLT!Ct04',ttmp,t04R
get_data,'RBSPb'+'!Cequatorial-foot-MLT!Ct89',ttmp,t89F
get_data,'RBSPb'+'!Cequatorial-foot-MLT!Ct01',ttmp,t01F
get_data,'RBSPb'+'!Cequatorial-foot-MLT!Ct04',ttmp,t04F


maxMLTFB = fltarr(n_elements(ttmp))
minMLTFB = fltarr(n_elements(ttmp))
maxMLTRB = fltarr(n_elements(ttmp))
minMLTRB = fltarr(n_elements(ttmp))


for i=0,n_elements(ttmp)-1 do begin
  maxMLTFB[i] = t89F[i] > t01F[i] > t04F[i]
  minMLTFB[i] = t89F[i] < t01F[i] < t04F[i] ;& $
  maxMLTRB[i] = t89R[i] > t01R[i] > t04R[i]
  minMLTRB[i] = t89R[i] < t01R[i] < t04R[i] ;& $
endfor

store_data,'maxMLTFB',ttmp,maxMLTFB
store_data,'minMLTFB',ttmp,minMLTFB
store_data,'maxMLTRB',ttmp,maxMLTRB
store_data,'minMLTRB',ttmp,minMLTRB


;--------------------------------------
;Extract times around the conjunction to be used in plot
;--------------------------------------

get_data,'mindL',tt,mindl
goo = where((tt ge t0z) and (tt le t1z))
ttmp = tt[goo]
tzero = strmid(time_string(ttmp[0]),11,8)

if timelabel eq 'sec' then timeplot = ttmp-ttmp[0]
if timelabel eq 'min' then timeplot = (ttmp-ttmp[0])/60.

;--------------------------------------

;--------------------------------------
;Extract data for plotting
;--------------------------------------

get_data,'mindL',tt,tmp & mindl = tmp[goo]
get_data,'maxdL',tt,tmp & maxdl = tmp[goo]
get_data,'mindmlt',tt,tmp & mindmlt = tmp[goo]
get_data,'maxdmlt',tt,tmp & maxdmlt = tmp[goo]
get_data,'minsep',tt,tmp & minsep = tmp[goo]
get_data,'maxsep',tt,tmp & maxsep = tmp[goo]

get_data,'separation_lvalue_t89',tt,tmp & sepL_t89 = tmp[goo]
get_data,'separation_lvalue_t01',tt,tmp & sepL_t01 = tmp[goo]
get_data,'separation_lvalue_t04',tt,tmp & sepL_t04 = tmp[goo]
get_data,'separation_mlt_t89',tt,tmp & sepMLT_t89 = tmp[goo]
get_data,'separation_mlt_t01',tt,tmp & sepMLT_t01 = tmp[goo]
get_data,'separation_mlt_t04',tt,tmp & sepMLT_t04 = tmp[goo]

get_data,'minLFB',tt,tmp & minlfb = tmp[goo]
get_data,'maxLFB',tt,tmp & maxlfb = tmp[goo]
get_data,'minLRB',tt,tmp & minlrb = tmp[goo]
get_data,'maxLRB',tt,tmp & maxlrb = tmp[goo]
get_data,'RBSPa'+'!CL-shell-t89',tt,tmp & t89r = tmp[goo]
get_data,'RBSPa'+'!CL-shell-t01',tt,tmp & t01r = tmp[goo]
get_data,'RBSPa'+'!CL-shell-t04',tt,tmp & t04r = tmp[goo]
get_data,'RBSPb'+'!CL-shell-t89',tt,tmp & t89f = tmp[goo]
get_data,'RBSPb'+'!CL-shell-t01',tt,tmp & t01f = tmp[goo]
get_data,'RBSPb'+'!CL-shell-t04',tt,tmp & t04f = tmp[goo]

get_data,'minMLTFB',tt,tmp & minMLTfb = tmp[goo]
get_data,'maxMLTFB',tt,tmp & maxMLTfb = tmp[goo]
get_data,'minMLTRB',tt,tmp & minMLTrb = tmp[goo]
get_data,'maxMLTRB',tt,tmp & maxMLTrb = tmp[goo]
get_data,'RBSPa'+'!Cequatorial-foot-MLT!Ct89',tt,tmp & t89mr = tmp[goo]
get_data,'RBSPa'+'!Cequatorial-foot-MLT!Ct01',tt,tmp & t01mr = tmp[goo]
get_data,'RBSPa'+'!Cequatorial-foot-MLT!Ct04',tt,tmp & t04mr = tmp[goo]
get_data,'RBSPb'+'!Cequatorial-foot-MLT!Ct89',tt,tmp & t89mf = tmp[goo]
get_data,'RBSPb'+'!Cequatorial-foot-MLT!Ct01',tt,tmp & t01mf = tmp[goo]
get_data,'RBSPb'+'!Cequatorial-foot-MLT!Ct04',tt,tmp & t04mf = tmp[goo]


;Create line at zero
zeroline = fltarr(n_elements(timeplot))

;--------------------------------------
;Final plots of data
;--------------------------------------

plot1 = PLOT(timeplot,maxLFB,thick=2,layout=[2,3,1])
plot1 = PLOT(timeplot,minLFB,/overplot,thick=2)
plot1 = PLOT(timeplot,maxLRB,/overplot,thick=2,color="red")
plot1 = PLOT(timeplot,minLRB,/overplot,thick=2,color="red")
plot1 = PLOT(timeplot,t89F,/overplot,thick=2,linestyle=2)
plot1 = PLOT(timeplot,t01F,/overplot,thick=2,linestyle=2)
plot1 = PLOT(timeplot,t04F,/overplot,thick=2,linestyle=2)
plot1 = PLOT(timeplot,t89R,/overplot,thick=2,linestyle=2,color="red")
plot1 = PLOT(timeplot,t01R,/overplot,thick=2,linestyle=2,color="red")
plot1 = PLOT(timeplot,t04R,/overplot,thick=2,linestyle=2,color="red")
plot1.yrange = [4,7]
if timelabel eq 'sec' then plot1.xtitle = 'Seconds from ' + tzero
if timelabel eq 'min' then plot1.xtitle = 'Minutes from ' + tzero
plot1.ytitle = 'Lshell t89,t01,t04!Cred=RBSP!Cblack=FIREBIRD'
plot1.title = date + ' RBSPa and FU4 conjunction'
plot1.font_size = 10

plot2 = PLOT(timeplot,maxMLTFB,thick=2,layout=[2,3,2],/current)
plot2 = PLOT(timeplot,minMLTFB,/overplot,thick=2)
plot2 = PLOT(timeplot,maxMLTRB,/overplot,thick=2,color="red")
plot2 = PLOT(timeplot,minMLTRB,/overplot,thick=2,color="red")
plot2 = PLOT(timeplot,t89mF,/overplot,thick=2,linestyle=2)
plot2 = PLOT(timeplot,t01mF,/overplot,thick=2,linestyle=2)
plot2 = PLOT(timeplot,t04mF,/overplot,thick=2,linestyle=2)
plot2 = PLOT(timeplot,t89mR,/overplot,thick=2,linestyle=2,color="red")
plot2 = PLOT(timeplot,t01mR,/overplot,thick=2,linestyle=2,color="red")
plot2 = PLOT(timeplot,t04mR,/overplot,thick=2,linestyle=2,color="red")
plot2.yrange = [10.3,10.55]
if timelabel eq 'sec' then plot2.xtitle = 'Seconds from ' + tzero
if timelabel eq 'min' then plot2.xtitle = 'Minutes from ' + tzero
plot2.title = 'From fb_rbsp_conjunction_plot.pro'
plot2.ytitle = 'MLT t89,t01,t04!Cred=RBSP!Cblack=FIREBIRD'
plot2.font_size = 10


plot3 = PLOT(timeplot,mindl,thick=2,layout=[2,3,3],/current)
plot3 = PLOT(timeplot,maxdl,/overplot,thick=2)
plot3 = PLOT(timeplot,sepL_t89,/overplot,linestyle=2)
plot3 = PLOT(timeplot,sepL_t01,/overplot,linestyle=2)
plot3 = PLOT(timeplot,sepL_t04,/overplot,linestyle=2)
plot3 = PLOT(timeplot,zeroline,/overplot,linestyle=3)
plot3.yrange = [-0.5,4.0]
plot3.ytitle = 'dLshell'
if timelabel eq 'sec' then plot3.xtitle = 'Seconds from ' + tzero
if timelabel eq 'min' then plot3.xtitle = 'Minutes from ' + tzero
plot3.font_size = 10


plot4 = PLOT(timeplot,mindmlt,thick=2,layout=[2,3,4],/current)
plot4 = PLOT(timeplot,maxdmlt,/overplot,thick=2)
plot4 = PLOT(timeplot,sepMLT_t89,/overplot,linestyle=2)
plot4 = PLOT(timeplot,sepMLT_t01,/overplot,linestyle=2)
plot4 = PLOT(timeplot,sepMLT_t04,/overplot,linestyle=2)
plot4 = PLOT(timeplot,zeroline,/overplot,linestyle=3)
;plot4.yrange = [-0.15,0.05]
plot4.yrange = [-1,1]
plot4.ytitle = 'dMLT [hrs]'
if timelabel eq 'sec' then plot4.xtitle = 'Seconds from ' + tzero
if timelabel eq 'min' then plot4.xtitle = 'Minutes from ' + tzero
plot4.font_size = 10


plot5 = PLOT(timeplot,minsep*6370.,thick=2,layout=[2,3,5],/current)
plot5 = PLOT(timeplot,maxsep*6370,/overplot,thick=2)
;plot5.yrange = [0,2.]
;plot5.yrange = [0.01,4.]*6370.
plot5.yrange = [6000.,30000.]
plot5.ylog = 1.
plot5.ytitle = 'Azimuthal equatorial!Cseparation [km]'
if timelabel eq 'sec' then plot5.xtitle = 'Seconds from ' + tzero
if timelabel eq 'min' then plot5.xtitle = 'Minutes from ' + tzero
plot5.font_size = 10

stop
plot1.save,saveroot + '/' + savename + '.eps'



end
