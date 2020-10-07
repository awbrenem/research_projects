;Create a stack plot of all the coherence spectra (properly filtered) for the fullmission


pro plot_coh_fullmission_allpayloads

  pre = '2'

  rbsp_efw_init
  store_data,tnames(),/delete

  tplot_options,'title','plot_coh_fullmission_allpayloads.pro'

;  run = 'tplot_vars_2014_run2'
  run = 'coh_vars_barrelmission2'
  ephem = 'folder_singlepayload'
  path = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/'
  path1 = path + run
  path2 = path + ephem


  ;Restore the tplot file with the combined coherence spectra.
  tplot_restore,filenames=path1 + '/' + 'all_coherence_plots_combined_meanfilter.tplot'



  ;path = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/tplot_vars_2014_120min_top/'
  combos = ['IT','IW','IK','IL','IX','TW','TK','TL','TX','WK','WL','WX','KL','KX','LX','LA','LB','LE','LO','LP','XA','XB','AB','AE','AO','AP','BE','BO','BP','EO','EP','OP']
  ;combos = ['IW','WK','WL','KL','KX','LX']
  ncombos = n_elements(combos)


;  for i=0,ncombos-1 do begin
;
 ;   print,combos[i]
;
 ;   p1 = strmid(combos[i],0,1)
  ;  p2 = strmid(combos[i],1,1)
;
 ;   tplot_restore,filenames=path1 + '/' + combos[i] + '_meanfilter.tplot'
;
 ;   tplot_restore,filenames=path2 + '/' + 'barrel_'+pre+p1+'_fspc_fullmission.tplot'
  ;  tplot_restore,filenames=path2 + '/' + 'barrel_'+pre+p2+'_fspc_fullmission.tplot'
;
;;stop
;
 ;   get_data,'coh_'+combos[i]+'_meanfilter',data=d,dlim=dlim,lim=lim
  ;  periods = d.v
   ; t0 = min(d.x,/nan)
    ;t1 = max(d.x,/nan)
;

;    dt = 1*3600./2.  ;time chunk size for dial plot. 
;    threshold = 0.0001   ;set low. These have already been filtered.
;    mincoh = 0.7
;    periodrange=[10,60]
;    max_mltdiff=12.
;    max_ldiff=15.
;    ratiomax=1.2


;    filter_coherence_spectra,'coh_'+p1+p2+'_meanfilter','L_Kp2_'+pre+p1,'L_Kp2_'+pre+p2,'MLT_Kp2_'+pre+p1,'MLT_Kp2_'+pre+p2,$
;      mincoh,$
;      periodrange[0],periodrange[1],$
;      max_mltdiff,$
;      max_ldiff,$
;      phase_tplotvar='phase_'+p1+p2+'_meanfilter',$
;      anglemax=anglemax,$
;      /remove_lshell_undefined,$
;      /remove_mincoh,$
;      /remove_slidingwindow,$
;      /remove_max_mltdiff,$
;      /remove_max_ldiff,$
;      /remove_anglemax,$
;      ratiomax=ratiomax
    
 ;   tplot,['coh_'+p1+p2+'_meanfilter','phase_'+p1+p2+'_meanfilter']



    ;  tplot,['coh_'+p1+p2+'_meanfilter','phase_'+p1+p2+'_meanfilter']
 ; endfor


  ss = read_supermag_substorm_list()

  timespan,'2014-01-01',45,/days
  tplot,['coh_??_meanfilter']
  timebar,ss.times



;-------------------
;RBSP SCIENCE GATEWAY FILES

pathcdf = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/rbsp_gateway_cdf_files/'

fn = ['rbspa_ect-hope.l2.ele_ect-mageis.l3_ect-rept.l2_efw.l2.e-spinfit-mgse_emfisis.l2.hfr_20140101_20140107_110214_v1.1.cdf',$
'rbspa_ect-hope.l2.ele_ect-mageis.l3_ect-rept.l2_efw.l2.e-spinfit-mgse_emfisis.l2.hfr_20140107_20140113_112103_v1.1.cdf',$
'rbspa_ect-hope.l2.ele_ect-mageis.l3_ect-rept.l2_efw.l2.e-spinfit-mgse_emfisis.l2.hfr_20140113_20140119_113889_v1.1.cdf',$
'rbspa_ect-hope.l2.ele_ect-mageis.l3_ect-rept.l2_efw.l2.e-spinfit-mgse_emfisis.l2.hfr_20140119_20140125_115454_v1.1.cdf',$
'rbspa_ect-hope.l2.ele_ect-mageis.l3_ect-rept.l2_efw.l2.e-spinfit-mgse_emfisis.l2.hfr_20140125_20140131_117259_v1.1.cdf',$
'rbspa_ect-hope.l2.ele_ect-mageis.l3_ect-rept.l2_efw.l2.e-spinfit-mgse_emfisis.l2.hfr_20140131_20140206_118984_v1.1.cdf',$
'rbspa_ect-hope.l2.ele_ect-mageis.l3_ect-rept.l2_efw.l2.e-spinfit-mgse_emfisis.l2.hfr_20140206_20140212_122283_v1.1.cdf',$
'rbspa_ect-hope.l2.ele_ect-mageis.l3_ect-rept.l2_efw.l2.e-spinfit-mgse_emfisis.l2.hfr_20140209_20140215_106367_v1.1.cdf',$
'rbspa_ect-hope.l2.ele_ect-mageis.l3_ect-rept.l2_efw.l2.e-spinfit-mgse_emfisis.l2.hfr_20140212_20140218_123993_v1.1.cdf']


cdf2tplot,pathcdf+fn[0]

STOP


;-----------------------------------
;***TEST - RESAMPLE.PRO 
;WORKS: just need to send everything in as a large pointer array

;Create common time base 
t0 = time_double('2014-01-01/00:00')
t1 = time_double('2014-02-15/00:00')
cadence = 60.  ;sec
ntimes = (t1-t0)/cadence
intrp_times = cadence*dindgen(ntimes) + t0



;Create pointer array
ptr_array = make_array(3,type=10)

get_data,'coh_LX_meanfilter',data=d
nelem = n_elements(d.x)-1
arrglob = [[d.x[1:nelem]],[d.y[1:nelem,*]]]
ptr_array[0] = ptr_new(arrglob)

get_data,'coh_WK_meanfilter',data=d
nelem = n_elements(d.x)-1
arrglob = [[d.x[1:nelem]],[d.y[1:nelem,*]]]
ptr_array[1] = ptr_new(arrglob)

get_data,'coh_BP_meanfilter',data=d
nelem = n_elements(d.x)-1
arrglob = [[d.x[1:nelem]],[d.y[1:nelem,*]]]
ptr_array[2] = ptr_new(arrglob)

;for testing
;data_array = ptr_array
;in_times = intrp_times

;get_data,'coh_TL_meanfilter2',data=d
;data_array = [[d.x],[d.y]]
val = resample(ptr_array,intrp_times,/nan)
xval3 = val[*,0]
yval = val[*,1:90]
store_data,'tst3',xval,yval,d.v















get_data,'coh_LX_meanfilter2',data=d
data_array = [[d.x],[d.y]]
val = resample(data_array,intrp_times,/nan)
xval1 = val[*,0]
yval = val[*,1:90]
store_data,'tst',xval,yval,d.v


get_data,'coh_KX_meanfilter2',data=d
data_array = [[d.x],[d.y]]
val = resample(data_array,intrp_times,/nan)
xval2 = val[*,0]
yval = val[*,1:90]
store_data,'tst2',xval,yval,d.v


get_data,'coh_TL_meanfilter2',data=d
data_array = [[d.x],[d.y]]
val = resample(data_array,intrp_times,/nan)
xval3 = val[*,0]
yval = val[*,1:90]
store_data,'tst3',xval,yval,d.v

options,['tst','tst2','tst3'],'spec',1
tplot,['tst','tst2','tst3']


tplot,['coh_LX_meanfilter2','tst','coh_KX_meanfilter2','tst2']


get_data,'tst',data=d1 
get_data,'tst2',data=d2
store_data,'tstfin',data={x:d1.x,y:d1.y+d2.y,v:d1.v}

add_data,'tst','tst2',newname='tmparr2'
options,['tmparr2'],'spec',1
tplot,['coh_LX_meanfilter2','tst','coh_KX_meanfilter2','tst2','tstfin']





;function resample,data_array,intrp_times,bad_pts,nan=nan,cubic=cubic,$
;   forcecubic=forcecubic,names=names,skipbad=skipbad







;;**TEST combine multiple coherence spectra
;
;get_data,'coh_KX_meanfilter',data=d1
;get_data,'coh_LX_meanfilter',data=d2
;
;
;;Create common time base 
;t0 = time_double('2014-01-01/00:00')
;t1 = time_double('2014-02-15/00:00')
;cadence = 60.  ;sec
;ntimes = (t1-t0)/cadence
;
;times = cadence*dindgen(ntimes) + t0
;
;tinterpol_mxn,'coh_IW_meanfilter',times,newname='coh_IW_meanfilter_interp',/nan_extrapolate
;
;tplot,['coh_KX_meanfilter_interp','coh_KX_meanfilter']
;tplot,['coh_IW_meanfilter','coh_IK_meanfilter']
;
;
;get_data,'coh_KX_meanfilter',data=d1
;tmin = min(d1.x)
;tmax = max(d1.x)


;*********TESTING**************
;ARRAY globbing technique
;----DOESN'T WORK...PRODUCES MORE GAPS WITH EACH SPECTRA ADDED

;get_data,'coh_WK_meanfilter2',data=d1
;get_data,'coh_KL_meanfilter2',data=d2
;get_data,'coh_LX_meanfilter2',data=d3
;xt = [d1.x,d2.x,d3.x]
;dt = [d1.y,d2.y,d3.y]

;sortorder = sort(xt,/l64)
;xt2 = xt[sortorder]
;dt2 = dt[sortorder,*]

;store_data,'tst',data={x:xt2,y:dt2,v:dtmp.v}

;tinterpol_mxn,'tst',times,newname='tst2'

;options,['tst','tst2'],'spec',1
;ylim,['coh_WK_meanfilter2','coh_KL_meanfilter2','coh_LX_meanfilter2','tst','tst2'],1,60,1
;zlim,['coh_WK_meanfilter2','coh_KL_meanfilter2','coh_LX_meanfilter2','tst','tst2'],0.2,1
;tplot,['coh_WK_meanfilter2','coh_KL_meanfilter2','coh_LX_meanfilter2','tst','tst2']



;*********TESTING**************
;Add data technique
;***DOESN'T WORK

;tn = tnames('coh_??_meanfilter')

;;First need to turn NaN values to zeros in order for adding to work 
;for i=0,n_elements(tn)-1 do begin $
;  get_data,tn[i],data=dtmp  & $
;  goo = where(finite(dtmp.y) eq 0.)  & $
;  if goo[0] ne -1 then dtmp.y[goo] = 0.  & $
;  store_data,tn[i]+'2',data=dtmp,limits={spec:1,ylim:[1,60],ylog:1}
;endfor


;tn += '2'
;;options,tn2,'spec',1
;;options,tn2,'ylim',1

;;Now add all the coherence arrays together 

;;...add the first combination

;add_data,tn[0],tn[1],newname='tmparr'
;get_data,'tmparr',data=d
;store_data,'tmparr',data={x:d.x,y:d.y,v:dtmp.v}

;tplot,[tn[0],tn[1],'tmparr']

;for i=1,n_elements(tn)-2 do add_data,'tmparr',tn[i+1],newname='tmparr'

;tplot,[tn[*],'tmparr']


;add_data,'coh_IT_meanfilter2','coh_XB_meanfilter2',newname='tmparr2'
;add_data,'coh_XB_meanfilter2','coh_IT_meanfilter2',newname='tmparr3'
;options,['tmparr2','tmparr3'],'spec',1
;tplot,['coh_XB_meanfilter2','coh_IT_meanfilter2','tmparr2','tmparr3']







;for i=0,n_elements(tn)-1 do begin $
;  add_data,'coh_KX_meanfilter2','coh_LX_meanfilter2',newname='tmp2'

;get_data,'coh_KX_meanfilter2',data=dd
;vvals = dd.v
;get_data,'tmp2',data=ddd
;store_data,'tmp2',data={x:ddd.x,y:ddd.y,v:vvals}


;options,'tmp2','spec',1
;ylim,['coh_KX_meanfilter2','coh_LX_meanfilter2','tmp2'],1,60,1
;tplot,['coh_KX_meanfilter2','coh_LX_meanfilter2','tmp2']





end

