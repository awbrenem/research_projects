;Plot histograms of delta-L and delta-MLT separation for times of coherence. 



;pro plot_dl_dmlt_coherence_fullmission



charsz_plot = 0.8  ;character size for plots
charsz_win = 1.2  
!p.charsize = charsz_win
tplot_options,'xmargin',[20.,16.]
tplot_options,'ymargin',[3,9]
tplot_options,'xticklen',0.08
tplot_options,'yticklen',0.02
tplot_options,'xthick',2
tplot_options,'ythick',2
tplot_options,'labflag',-1	


tplot_options,'title','plot_dl_dmlt_coherence_fullmission.pro'
rbsp_efw_init 
pre = '1'
fspcs = 'fspc'



;Timerange to plot histograms for
if pre eq '2' then begin 
  t0 = time_double('2014-01-01/00:00')
  t1 = time_double('2014-01-15/00:00')
endif 
if pre eq '1' then begin 
  t0 = time_double('2013-01-01/00:00')
  t1 = time_double('2013-02-07/00:00')
endif 

;Min and max coherence values to consider
;pmin_cohtots = 1.
;pmax_cohtots = 9.9
;pmin_cohtots = 10.
;pmax_cohtots = 20.
pmin_cohtots = 21.
pmax_cohtots = 40.
;pmin_cohtots = 41.
;pmax_cohtots = 90.
;          Inf      40.0000      20.0000      13.3333      10.0000      8.00000      6.66667      5.71429      5.00000      4.44444      4.00000      3.63636
;      3.33333      3.07692      2.85714      2.66667      2.50000      2.35294      2.22222      2.10526      2.00000      1.90476      1.81818      1.73913
;      1.66667      1.60000      1.53846      1.48148      1.42857      1.37931      1.33333      1.29032      1.25000      1.21212      1.17647      1.14286
;      1.11111      1.08108      1.05263      1.02564
cohmin = 0.7



path = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/coh_vars_barrelmission'+pre +'v2/'
path2 = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/folder_singlepayload/'

fn = 'all_coherence_plots_combined.tplot'
tplot_restore,filenames=path+fn
copy_data,'coh_allcombos_meanfilter','coh_allcombos_meanfilter_filtered'
;fn = 'all_coherence_plots_combined_meanfilter_noextremefiltering.tplot'
;tplot_restore,filenames=path+fn


if pre eq '2' then combos = ['IT', 'IW', 'IK', 'IL', 'IX', 'TW', 'TK', 'TL', 'TX', 'WK', 'WL', 'WX', 'KL', 'KX', 'LX', 'LA', 'LB', 'LE', 'LO', 'LP', 'XA', 'XB', 'AB', 'AE', 'AO', 'AP', 'BE', 'BO', 'BP', 'EO', 'EP', 'OP']
if pre eq '1' then combos = ['BD','BJ','BK','BM','BO','DI','DG','DC','DH','DJ','DK','DM','DO','DQ',$
    'DR','IG','IC','IH','IA','IJ','IK','IM','IO','IQ','IR','IS','IT','IU','IV','GC',$
    'GH','GJ','GK','GO','GQ','GR','GS','GT','GU','CH','CK','CO','CQ','CR','CS','CT',$
    'HA','HK','HQ','HR','HS','HT','HU','HV','AQ','AT','AU','AV','JK','JM','JO','KM',$
    'KO','KQ','MO','QR','QS','QT','QU','QV','RS','ST','SU','TU','TV','UV']


;Define some filtering variables
mincoh = 0.7
threshold = 0.0001   ;set low. These have already been filtered.
max_mltdiff=12.
max_ldiff=15.
ratiomax=2.
pmin = 2. 
pmax = 40.
anglemax = 90.


;----------------------------------------------------
;Arrays that will be used to calculate histograms
;----------------------------------------------------

;Histograms for times of coherence
mlt1goo = 0. & mlt2goo = 0.
l1goo = 0. & l2goo = 0.
ldiffgoo = 0. & mltdiffgoo = 0.

;comparative histograms for all times
mlt1all = 0. & mlt2all = 0.
l1all = 0. & l2all = 0.
ldiffall = 0. & mltdiffall = 0.



;Loop through each coherence combo to extract histograms
for i=0,n_elements(combos)-1 do begin 

    p1 = strmid(combos[i],0,1)
    p2 = strmid(combos[i],1,1)

    tplot_restore,filenames=path+combos[i]+'_meanfilter.tplot'
    tplot_restore,filenames=path2+'barrel_'+pre+p1+'_fspc_fullmission.tplot'
    tplot_restore,filenames=path2+'barrel_'+pre+p2+'_fspc_fullmission.tplot'
;    tplot,['coh_'+combos[i]+'_meanfilter','L_Kp2_'+pre+p1,'L_Kp2_'+pre+p2,'MLT_Kp2_'+pre+p1,'MLT_Kp2_'+pre+p2]
      copy_data,'coh_'+p1+p2+'_meanfilter','coh_'+p1+p2+'_meanfilter_orig'


    filter_coherence_spectra,'coh_'+p1+p2+'_meanfilter','L_Kp2_'+pre+p1,'L_Kp2_'+pre+p2,'MLT_Kp2_'+pre+p1,'MLT_Kp2_'+pre+p2,$
      mincoh,$
      pmin,pmax,$
      max_mltdiff,$
      max_ldiff,$
      phase_tplotvar='phase_'+p1+p2+'_meanfilter',$
      anglemax=anglemax,$
      /remove_lshell_undefined,$
      /remove_mincoh,$
      /remove_slidingwindow,$
      /remove_max_mltdiff,$
      /remove_max_ldiff,$
      /remove_anglemax,$
      ratiomax=ratiomax
    

    ylim,'coh_'+p1+p2+'_meanfilter',1,60,1

    ;set timerange
    get_data,'coh_'+p1+p2+'_meanfilter',tt,dd
    Tmin = min(tt,/nan)
    Tmax = max(tt,/nan)
    timespan,Tmin,(Tmax-Tmin),/seconds


    get_barrel_dl_dmlt_vars,'L_Kp2_'+pre+p1,'L_Kp2_'+pre+p2,'MLT_Kp2_'+pre+p1,'MLT_Kp2_'+pre+p2,'diff'


    get_data,'coh_'+p1+p2+'_meanfilter',tcoh,dcoh,vcoh,dlim=dlim,lim=lim
    cohtots = fltarr(n_elements(tcoh))


  ;-------------------------------------------
  ;Remove elements of coherence spectra that are below certain threshold. Up until this point, the 
  ;coh spectra will retain all elements during a certain time when any period at that time exceeds
  ;the filtering threshold. This is problematic here, though b/c I want to separate histograms
  ;based on certain period ranges. 

    boo = where(dcoh lt cohmin)

    if boo[0] ne -1 then dcoh[boo] = !values.f_nan
    store_data,'coh_'+p1+p2+'_meanfilterv2',tcoh,dcoh,vcoh,dlim=dlim,lim=lim
  ;-------------------------------------------


    ;Find indices of data in selected period range
    goov = where((vcoh ge pmin_cohtots) and (vcoh le pmax_cohtots))

    for j=0,n_elements(tcoh)-1 do cohtots[j] = total(dcoh[j,goov],/nan)
    ;cohavg = cohtots/n_elements(goov)
    store_data,'cohtots',tcoh,cohtots
    cttmp = tsample('cohtots',[t0,t1],times=ttemp)

;    ylim,['coh_'+p1+p2+'_meanfilter','coh_'+p1+p2+'_meanfilterv2'],1,40,1
;    tplot,['coh_'+p1+p2+'_meanfilter','coh_'+p1+p2+'_meanfilterv2','cohtots']


    ;-------------------------------------------------------------
    ;Only tally values if there is data in the timerange t0 to t1
    ;-------------------------------------------------------------

    if finite(cttmp[0]) ne 0. then begin 
        store_data,'cohtots',ttemp,cttmp
        undefine,ttemp,cttmp

        tinterpol_mxn,'MLT_Kp2_'+pre+p1,'cohtots'
        tinterpol_mxn,'MLT_Kp2_'+pre+p2,'cohtots'
        tinterpol_mxn,'L_Kp2_'+pre+p1,'cohtots'
        tinterpol_mxn,'L_Kp2_'+pre+p2,'cohtots'
        tinterpol_mxn,'dMLT_diff','cohtots'
        tinterpol_mxn,'dL_diff','cohtots'

;********************************************************************

        ylim,'dL_diff_both',0,30
;        tplot,['coh_'+p1+p2+'_meanfilter_orig','coh_'+p1+p2+'_meanfilter',$
;                'MLT_Kp2_'+pre+p1+'_interp','MLT_Kp2_'+pre+p2+'_interp','L_Kp2_'+pre+p1+'_interp','L_Kp2_'+pre+p2+'_interp','dL_diff_both','dMLT_diff_both']


        ;Extract data for given timerange
        mlt1 = tsample('MLT_Kp2_'+pre+p1+'_interp',[t0,t1],times=t,/nan)
        mlt2 = tsample('MLT_Kp2_'+pre+p2+'_interp',[t0,t1],/nan)
        l1 = tsample('L_Kp2_'+pre+p1+'_interp',[t0,t1],/nan)
        l2 = tsample('L_Kp2_'+pre+p2+'_interp',[t0,t1],/nan)
        ldiff = tsample('dL_diff_interp',[t0,t1],/nan)
        mltdiff = tsample('dMLT_diff_interp',[t0,t1],/nan)


        goo = where(cohtots ne 0.)
        if goo[0] ne -1 then mlt1goo = [mlt1goo,mlt1[goo]]
        if goo[0] ne -1 then mlt2goo = [mlt2goo,mlt2[goo]]
        if goo[0] ne -1 then l1goo = [l1goo,l1[goo]]
        if goo[0] ne -1 then l2goo = [l2goo,l2[goo]]
        if goo[0] ne -1 then ldiffgoo = [ldiffgoo,ldiff[goo]]
        if goo[0] ne -1 then mltdiffgoo = [mltdiffgoo,mltdiff[goo]]


        mlt1all = [mlt1all,mlt1]
        mlt2all = [mlt2all,mlt2]
        l1all = [l1all,l1]
        l2all = [l2all,l2]
        ldiffall = [ldiffall,ldiff]
        mltdiffall = [mltdiffall,mltdiff]


    endif




    ;undefine,mlt1goo,mlt2goo,l1goo,l2goo
    store_data,'coh_'+combos[i]+'*',/delete
    store_data,['L_Kp?_2'+p1+'*','L_Kp?_2'+p2+'*','fspc_2'+p1+'*','fspc_2'+p2+'*'],/delete
    store_data,['phase*','alt*','cohtots'],/del

endfor

;If we only have one element, then no coherence values have satisfied our criterea 
;and we have nothing to plot. Check the period range and cohmin value. 
sztst = size(mlt1goo) 
if sztst[2] eq 1 then begin 
  PRINT,'****************************************'
  PRINT,'****************************************'
  PRINT,'****************************************'
  print,'*******NO COHERENCE VALUES TO PLOT******'
  PRINT,'****************************************'
  PRINT,'****************************************'
  PRINT,'****************************************'
STOP
endif

mlt1goo = mlt1goo[1:n_elements(mlt1goo)-1]
mlt2goo = mlt2goo[1:n_elements(mlt1goo)-1]
l1goo = l1goo[1:n_elements(mlt1goo)-1]
l2goo = l2goo[1:n_elements(mlt1goo)-1]
ldiffgoo = ldiffgoo[1:n_elements(mlt1goo)-1]
mltdiffgoo = mltdiffgoo[1:n_elements(mlt1goo)-1]

mlt1all = mlt1all[1:n_elements(mlt1all)-1]
mlt2all = mlt2all[1:n_elements(mlt1all)-1]
l1all = l1all[1:n_elements(mlt1all)-1]
l2all = l2all[1:n_elements(mlt1all)-1]
ldiffall = ldiffall[1:n_elements(mlt1all)-1]
mltdiffall = mltdiffall[1:n_elements(mlt1all)-1]


;---------------------------------------------------------------------------
;Histograms of balloon separations for only times with coherence
;---------------------------------------------------------------------------
binsz = 1.

ldgoo = histogram(ldiffgoo,/nan,min=0,max=10,binsize=binsz,locations=loclgoo)
mltdgoo = histogram(mltdiffgoo,/nan,min=0,max=10,binsize=binsz,locations=locmltgoo)

;---------------------------------------------------------------------------
;Histograms of balloon separations for ALL times. Use this to compare to 
;shape of histograms when coherence is observed.
;---------------------------------------------------------------------------

ld = histogram(ldiffall,/nan,min=0,max=10,binsize=binsz,locations=locl)
mltd = histogram(mltdiffall,/nan,min=0,max=10,binsize=binsz,locations=locmlt)

titlestr = 'dL,dLMT histograms!Call payloads!CBARREL mission'+pre+' '+string(pmin_cohtots,format='(I2)')+'-'+string(pmax_cohtots,format='(I2)')+' min periods'

!p.multi = [0,0,4]
!p.charsize = 2.
plot,locl,ld,yrange=[0,2000],ystyle=1,xtitle='delta-L',ytitle='# times with!Csignificant coherence',title=titlestr,psym=-2,/nodata
oplot,locl,ld,psym=-2,color=250
plot,loclgoo,ldgoo,yrange=[0,150],ystyle=1,xtitle='delta-L',ytitle='# times with!Csignificant coherence',title='dL,dLMT histograms!Call payloads!CBARREL mission2',psym=-2
plot,locmlt,mltd,yrange=[0,3000],ystyle=1,xtitle='delta-MLT',ytitle='# times with!Csignificant coherence',psym=-2,/nodata
oplot,locmlt,mltd,psym=-2,color=250
plot,locmltgoo,mltdgoo,yrange=[0,200],ystyle=1,xtitle='delta-MLT',ytitle='# times with!Csignificant coherence',psym=-2



!p.multi = [0,0,2]
!p.charsize = 1.
plot,locl,ld,ystyle=1,xtitle='delta-L',ytitle='# times with!Csignificant coherence',title=titlestr,psym=-2,yrange=[1,8000],/ylog,/nodata
oplot,locl,ld,psym=-2,color=250
oplot,loclgoo,ldgoo,psym=-2
plot,locmlt,mltd,ystyle=1,xtitle='delta-MLT',ytitle='# times with!Csignificant coherence',psym=-2,yrange=[1,9000],/ylog,/nodata
oplot,locmlt,mltd,psym=-2,color=250
oplot,locmltgoo,mltdgoo,psym=-2





pmin_cohtotsstr = string(pmin_cohtots,format='(I2)')
pmax_cohtotsstr = string(pmax_cohtots,format='(I2)')
binszstr = string(binsz,format='(F3.1)')
cohminstr = string(cohmin,format='(F3.1)')
save,locl,ld,loclgoo,ldgoo,locmlt,mltd,locmltgoo,mltdgoo,titlestr,filename='~/Desktop/campaign'+pre+'_'+pmin_cohtotsstr+'-'+pmax_cohtotsstr + '_mincoh'+cohminstr+'_delta='+binszstr+'.idl'


stop
end 