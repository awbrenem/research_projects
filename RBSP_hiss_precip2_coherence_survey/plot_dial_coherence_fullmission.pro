;Make a dial plot (MLT, L) with red boxes indicating locations where high coherence is observed.
;This is the program I used to show that campaign 2 coherence is almost exclusively post-noon.


;pro plot_dial_coherence_fullmission

tplot_options,'title','plot_dial_coherence_fullmission.pro'
rbsp_efw_init


;;***campaign 1
;pre = '1'
;fspcs = 'fspc'
;;Timerange to plot histograms for
;t0 = time_double('2013-01-12/00:00')
;t1 = time_double('2013-02-07/00:00')
;;Min and max coherence values to consider
;pmin_cohtots = 10.
;pmax_cohtots = 60.
;combos = ['BD','BJ','BK','BM','BO','DI','DG','DC','DH','DJ','DK','DM','DO','DQ','DR','IG',$
;'IC','IH','IA','IJ','IK','IM','IO','IQ','IR','IS','IT','IU','IV','GC','GH','GJ','GK','GO',$
;'GQ','GR','GS','GT','GU','CH','CK','CO','CQ','CR','CS','CT','HA','HK','HQ','HR','HS','HT',$
;'HU','HV','AQ','AT','AU','AV','JK','JM','JO','KM','KO','KQ','MO','QR','QS','QT','QU','QV',$
;'RS','ST','SU','TU','TV','UV']


;;***campaign 2
pre = '2'
fspcs = 'fspc'
;Timerange to plot histograms for
t0 = time_double('2014-01-03/00:00')
t1 = time_double('2014-01-13/00:00')
;Min and max coherence values to consider
pmin_cohtots = 10.
pmax_cohtots = 60.
combos = ['IT', 'IW', 'IK', 'IL', 'IX', 'TW', 'TK', 'TL', 'TX', 'WK', 'WL', 'WX', 'KL', 'KX',$
 'LX', 'LA', 'LB', 'LE', 'LO', 'LP', 'XA', 'XB', 'AB', 'AE', 'AO', 'AP', 'BE', 'BO', 'BP', 'EO', 'EP', 'OP']



;How do we want to define colors for coherence values?
colors_for_coneangle = 0
colors_for_imf_orientation = 0



  tplot_options,'xmargin',[20.,16.]
  tplot_options,'ymargin',[3,9]
  tplot_options,'xticklen',0.08
  tplot_options,'yticklen',0.02
  tplot_options,'xthick',2
  tplot_options,'ythick',2
  tplot_options,'labflag',-1




path = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/coh_vars_barrelmission'+pre+'/'
path2 = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/folder_singlepayload/'

fn = 'all_coherence_plots_combined_meanfilter.tplot'
tplot_restore,filenames=path+fn
copy_data,'coh_allcombos_meanfilter','coh_allcombos_meanfilter_filtered'
fn = 'all_coherence_plots_combined_meanfilter_noextremefiltering.tplot'
tplot_restore,filenames=path+fn


;Define some filtering variables
mincoh = 0.7
threshold = 0.0001   ;set low. These have already been filtered.
max_mltdiff=12.
max_ldiff=15.
ratiomax=2.
pmin = 5.
pmax = 60.
anglemax = 90.


;Load OMNI data for full mission (this is quick)
timespan,t0,t1-t0,/sec
plot_omni_quantities,/noplot;,smoothtime=4.



tplot_restore,filename=path+'/all_coherence_plots_combined_meanfilter_noextremefiltering.tplot'
tplot_restore,filename=path+'/all_coherence_plots_combined_meanfilter.tplot'

;tplot,['coh_allcombos_meanfilter','IMF_orientation','IMF_orientation_smoothed','IMF_orientation_smoothed_interp','clockangle','clockangle_smoothed','coneangle','coneangle_smoothed','Bz_rat_comb','Bz_rat_smoothed']
tplot,['coh_allcombos_meanfilter','IMF_orientation_comb','clockangle_comb','coneangle_comb','Bz_rat_comb']


popen,'~/Desktop/cohplot'+pre+'.ps'


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
      'fspc'+'_'+pre+p1,'fspc'+'_'+pre+p2,$
      phase_tplotvar='phase_'+p1+p2+'_meanfilter',$
      anglemax=anglemax,$
      /remove_lshell_undefined,$
      /remove_mincoh,$
      /remove_slidingwindow,$
      /remove_max_mltdiff,$
      /remove_max_ldiff,$
      /remove_anglemax,$
      /remove_lowsignal_fluctuation,$
      ratiomax=ratiomax


    ylim,'coh_'+p1+p2+'_meanfilter',5,60,1

    ;Find overlap timerange
    get_data,'coh_'+p1+p2+'_meanfilter',tt,dd
    Tmin = min(tt,/nan)
    Tmax = max(tt,/nan)
    timespan,Tmin,(Tmax-Tmin),/seconds

    get_data,'coh_'+p1+p2+'_meanfilter',tcoh,dcoh,vcoh
    cohtots = fltarr(n_elements(tcoh))
    store_data,'cohtots',tcoh,cohtots
    cttmp = tsample('cohtots',[t0,t1],times=ttemp)


;Make dummy plot for first time through.
;All subsequent loops will overplot onto this.
    dummytime = '2013-01-10/21:00'
    ;dummytime = '2014-01-04/21:00'
    if i eq 0. then plot_plasmapause_goldstein_boundary,dummytime,mlt1,l1,payloadname='',symbolplot=3,/noplotpp,yrange=[-10,10],xrange=[-10,10],xsize=800
    if i eq 0. then plot_plasmapause_goldstein_boundary,dummytime,mlt2,l2,symbolplot=3,/oplot

    if finite(cttmp[0]) ne 0. then begin
        store_data,'cohtots',ttemp,cttmp
        undefine,ttemp,cttmp

        goov = where((vcoh ge pmin_cohtots) and (vcoh le pmax_cohtots))

        for j=0,n_elements(tcoh)-1 do cohtots[j] = total(dcoh[j,goov],/nan)
        store_data,'cohtots',tcoh,cohtots

        tinterpol_mxn,'MLT_Kp2_'+pre+p1,'cohtots',/nearest_neighbor
        tinterpol_mxn,'MLT_Kp2_'+pre+p2,'cohtots',/nearest_neighbor
        tinterpol_mxn,'L_Kp2_'+pre+p1,'cohtots',/nearest_neighbor
        tinterpol_mxn,'L_Kp2_'+pre+p2,'cohtots',/nearest_neighbor

        ;For cone angle it is save to interpolate to the cadence of the coherence data b/c
        ;cone angles don't flip b/t +/- 180.
        tinterpol_mxn,'coneangle','cohtots',/nearest_neighbor
        tinterpol_mxn,'Bz_rat','cohtots',/nearest_neighbor
        tinterpol_mxn,'IMF_orientation','cohtots',/nearest_neighbor


;*************************************
;Test of various interpolation methods.
;Issues is that quantities that flip back and forth b/t +/-180 can average to zero.
;I find that "nearest_neighbor" interpolation does a really good job.

;        ;For quantities that flip b/t +/-180 find the median value
;        get_data,'IMF_orientation',data=dd
;        get_data,'cohtots',timebase,d
;        medianv = fltarr(n_elements(timebase))
;        for qq=0d,n_elements(timebase)-2 do begin
;          goo = where((dd.x ge timebase[qq]) and (dd.x lt timebase[qq+1]))
;          if goo[0] ne -1 then medianv[qq] = median(dd.y[goo])
;        endfor
;        store_data,'IMF_orientation_median',timebase,shift(medianv,1)
;
;        store_data,'IMFcomb',data=['IMF_orientation','IMF_orientation_median']
;        options,'IMFcomb','colors',[0,250]
;        tplot,['IMFcomb'];'IMF_orientation_median','IMF_orientation']
;
;
;        tinterpol_mxn,'IMF_orientation','cohtots',newname='t1'
;        tinterpol_mxn,'IMF_orientation','cohtots',newname='t2',/nearest_neighbor
;        tinterpol_mxn,'IMF_orientation','cohtots',newname='t3',/quadratic
;        tinterpol_mxn,'IMF_orientation','cohtots',newname='t4',/spline
;
;        store_data,'t1comb',data=['IMF_orientation','t1'] & options,'t1comb','colors',[0,250]
;        store_data,'t2comb',data=['IMF_orientation','t2'] & options,'t2comb','colors',[0,250]
;        store_data,'t3comb',data=['IMF_orientation','t3'] & options,'t3comb','colors',[0,250]
;        store_data,'t4comb',data=['IMF_orientation','t4'] & options,'t4comb','colors',[0,250]
;
;        options,['t1comb','t2comb','t3comb','t4comb','IMFcomb'],'psym',-4
;        ylim,['t1comb','t2comb','t3comb','t4comb','IMFcomb'],-200,200
;        tplot,['t1comb','t2comb','t3comb','t4comb','IMFcomb']
;stop
;*************************************


;          tplot,['coh_'+p1+p2+'_meanfilter_orig','coh_'+p1+p2+'_meanfilter',$
;                'MLT_Kp2_'+pre+p1+'_interp','MLT_Kp2_'+pre+p2+'_interp','L_Kp2_'+pre+p1+'_interp','L_Kp2_'+pre+p2+'_interp']
        ;stop



        ;Extract data for given timerange
        mlt1 = tsample('MLT_Kp2_'+pre+p1+'_interp',[t0,t1],times=t,/nan)
        mlt2 = tsample('MLT_Kp2_'+pre+p2+'_interp',[t0,t1],/nan)
        l1 = tsample('L_Kp2_'+pre+p1+'_interp',[t0,t1],/nan)
        l2 = tsample('L_Kp2_'+pre+p2+'_interp',[t0,t1],/nan)
        imfo = tsample('IMF_orientation_interp',[t0,t1],/nan,times=tttmp)
        brat = tsample('Bz_rat_interp',[t0,t1],/nan,times=tttmp)
        coneao = tsample('coneangle_interp',[t0,t1],/nan)

        mlt1goo = -1 & mlt2goo = -1 & l1goo = -1 & l2goo = -1 & imfogoo = -1 & bratgoo = -1 & coneaogoo = -1

        goo = where(cohtots ne 0.)
        if goo[0] ne -1 then mlt1goo = mlt1[goo]
        if goo[0] ne -1 then mlt2goo = mlt2[goo]
        if goo[0] ne -1 then l1goo = l1[goo]
        if goo[0] ne -1 then l2goo = l2[goo]
        if goo[0] ne -1 then imfogoo = imfo[goo]
        if goo[0] ne -1 then bratgoo = brat[goo]
        if goo[0] ne -1 then coneaogoo = coneao[goo]

;        ;Plot dots for balloon trajectories
;        if i ne 0. then plot_plasmapause_goldstein_boundary,dummytime,mlt1,l1,symbolplot=3,/oplot
;        if i ne 0. then plot_plasmapause_goldstein_boundary,dummytime,mlt2,l2,symbolplot=3,/oplot


        ;------------------------------------------------
        ;DEFINE COLORS AND PLOT FOR IMF ORIENTATION (Petrinic et al., 2013)
        ;------------------------------------------------

        if colors_for_imf_orientation then begin

          ;Choose color of square to plot based on the IMF orientation as defined in Petrinic13
          ;The below satisfy both a particular IMF orientation and Bz ratio <1
          nearperp1 = where((imfogoo ge 70) and (imfogoo le 110) and (bratgoo le 1))
          nearperp2 = where((imfogoo le -70) and (imfogoo ge -110) and (bratgoo le 1))
          nearPS1 = where((imfogoo ge 125) and (imfogoo le 145) and (bratgoo le 1))
          nearPS2 = where((imfogoo le -35) and (imfogoo ge -55) and (bratgoo le 1))
          nearpar1 = where((imfogoo ge 150) and (imfogoo le 170) and (bratgoo le 1))
          nearpar2 = where((imfogoo le -10) and (imfogoo ge -30) and (bratgoo le 1))
          nearorthoPS1 = where((imfogoo ge 0) and (imfogoo lt 70) and (bratgoo le 1))
          nearorthoPS2 = where((imfogoo lt -110) and (imfogoo ge -180) and (bratgoo le 1))

          help,nearperp1,nearperp2,nearPS1,nearPS2,nearpar1,nearpar2

          ;The below satisfy a particular IMF orientation but have Bz ratio >1
          nearperp1bad = where((imfogoo ge 70) and (imfogoo le 110) and (bratgoo gt 1))
          nearperp2bad = where((imfogoo le -70) and (imfogoo ge -110) and (bratgoo gt 1))
          nearPS1bad = where((imfogoo ge 125) and (imfogoo le 145) and (bratgoo gt 1))
          nearPS2bad = where((imfogoo le -35) and (imfogoo ge -55) and (bratgoo gt 1))
          nearpar1bad = where((imfogoo ge 150) and (imfogoo le 170) and (bratgoo gt 1))
          nearpar2bad = where((imfogoo le -10) and (imfogoo ge -30) and (bratgoo gt 1))
          nearorthoPS1bad = where((imfogoo ge 0) and (imfogoo lt 70) and (bratgoo gt 1))
          nearorthoPS2bad = where((imfogoo lt -110) and (imfogoo ge -180) and (bratgoo gt 1))

          help,nearperp1bad,nearperp2bad,nearPS1bad,nearPS2bad,nearpar1bad,nearpar2bad

          other1 = where((imfogoo gt 110) and (imfogoo lt 125))
          other2 = where((imfogoo gt 145) and (imfogoo lt 150))
          other3 = where((imfogoo gt 170) and (imfogoo lt 180))
          other4 = where((imfogoo lt 0) and (imfogoo gt -10))
          other5 = where((imfogoo lt -30) and (imfogoo gt -35))
          other6 = where((imfogoo lt -55) and (imfogoo gt -70))

          help,nearorthoPS1,nearorthoPS2,other1,other2,other3,other4,other5,other6
          help,mlt1goo,mlt2goo,l1goo,l2goo


          ;Plot squares where coherence is observed
          if goo[0] ne -1 then begin

            ;First for payload 1
            if nearperp1[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt1goo[nearperp1],l1goo[nearperp1],color=250,/oplot,symsize=1
            if nearperp2[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt1goo[nearperp2],l1goo[nearperp2],color=250,/oplot,symsize=1
            if nearPS1[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt1goo[nearPS1],l1goo[nearPS1],color=0,/oplot,symsize=1
            if nearPS2[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt1goo[nearPS2],l1goo[nearPS2],color=0,/oplot,symsize=1
            if nearpar1[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt1goo[nearpar1],l1goo[nearpar1],color=75,/oplot,symsize=1
            if nearpar2[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt1goo[nearpar2],l1goo[nearpar2],color=75,/oplot,symsize=1
            if nearorthoPS1[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt1goo[nearorthoPS1],l1goo[nearorthoPS1],color=200,/oplot,symsize=1
            if nearorthoPS2[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt1goo[nearorthoPS2],l1goo[nearorthoPS2],color=200,/oplot,symsize=1

            ;Plot values that don't satisfy Bz ratio as the same color (effectively ignoring Bz ratio)
;            if nearperp1bad[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt1goo[nearperp1bad],l1goo[nearperp1bad],color=250,/oplot,symsize=1
;            if nearperp2bad[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt1goo[nearperp2bad],l1goo[nearperp2bad],color=250,/oplot,symsize=1
;            if nearPS1bad[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt1goo[nearPS1bad],l1goo[nearPS1bad],color=0,/oplot,symsize=1
;            if nearPS2bad[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt1goo[nearPS2bad],l1goo[nearPS2bad],color=0,/oplot,symsize=1
;            if nearpar1bad[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt1goo[nearpar1bad],l1goo[nearpar1bad],color=75,/oplot,symsize=1
;            if nearpar2bad[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt1goo[nearpar2bad],l1goo[nearpar2bad],color=75,/oplot,symsize=1
;            if nearorthoPS1bad[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt1goo[nearorthoPS1bad],l1goo[nearorthoPS1bad],color=200,/oplot,symsize=1
;            if nearorthoPS2bad[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt1goo[nearorthoPS2bad],l1goo[nearorthoPS2bad],color=200,/oplot,symsize=1

            ;Plot values that don't satisfy Bz ratio as green.
           if nearperp1bad[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt1goo[nearperp1bad],l1goo[nearperp1bad],color=120,/oplot,symsize=1
           if nearperp2bad[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt1goo[nearperp2bad],l1goo[nearperp2bad],color=120,/oplot,symsize=1
           if nearPS1bad[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt1goo[nearPS1bad],l1goo[nearPS1bad],color=120,/oplot,symsize=1
           if nearPS2bad[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt1goo[nearPS2bad],l1goo[nearPS2bad],color=120,/oplot,symsize=1
           if nearpar1bad[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt1goo[nearpar1bad],l1goo[nearpar1bad],color=120,/oplot,symsize=1
           if nearpar2bad[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt1goo[nearpar2bad],l1goo[nearpar2bad],color=120,/oplot,symsize=1
           if nearorthoPS1bad[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt1goo[nearorthoPS1bad],l1goo[nearorthoPS1bad],color=120,/oplot,symsize=1
           if nearorthoPS2bad[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt1goo[nearorthoPS2bad],l1goo[nearorthoPS2bad],color=120,/oplot,symsize=1

            if other1[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt1goo[other1],l1goo[other1],color=120,/oplot,symsize=1
            if other2[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt1goo[other2],l1goo[other2],color=120,/oplot,symsize=1
            if other3[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt1goo[other3],l1goo[other3],color=120,/oplot,symsize=1
            if other4[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt1goo[other4],l1goo[other4],color=120,/oplot,symsize=1
            if other5[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt1goo[other5],l1goo[other5],color=120,/oplot,symsize=1
            if other6[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt1goo[other6],l1goo[other6],color=120,/oplot,symsize=1


            ;*****
            ;Second for payload 2
            if nearperp1[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt2goo[nearperp1],l2goo[nearperp1],color=250,/oplot,symsize=1
            if nearperp2[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt2goo[nearperp2],l2goo[nearperp2],color=250,/oplot,symsize=1
            if nearPS1[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt2goo[nearPS1],l2goo[nearPS1],color=0,/oplot,symsize=1
            if nearPS2[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt2goo[nearPS2],l2goo[nearPS2],color=0,/oplot,symsize=1
            if nearpar1[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt2goo[nearpar1],l2goo[nearpar1],color=75,/oplot,symsize=1
            if nearpar2[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt2goo[nearpar2],l2goo[nearpar2],color=75,/oplot,symsize=1
            if nearorthoPS1[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt2goo[nearorthoPS1],l2goo[nearorthoPS1],color=200,/oplot,symsize=1
            if nearorthoPS2[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt2goo[nearorthoPS2],l2goo[nearorthoPS2],color=200,/oplot,symsize=1

;            if nearperp1bad[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt2goo[nearperp1bad],l2goo[nearperp1bad],color=250,/oplot,symsize=1
;            if nearperp2bad[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt2goo[nearperp2bad],l2goo[nearperp2bad],color=250,/oplot,symsize=1
;            if nearPS1bad[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt2goo[nearPS1bad],l2goo[nearPS1bad],color=0,/oplot,symsize=1
;            if nearPS2bad[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt2goo[nearPS2bad],l2goo[nearPS2bad],color=0,/oplot,symsize=1
;            if nearpar1bad[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt2goo[nearpar1bad],l2goo[nearpar1bad],color=75,/oplot,symsize=1
;            if nearpar2bad[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt2goo[nearpar2bad],l2goo[nearpar2bad],color=75,/oplot,symsize=1
;            if nearorthoPS1bad[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt2goo[nearorthoPS1bad],l2goo[nearorthoPS1bad],color=200,/oplot,symsize=1
;            if nearorthoPS2bad[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt2goo[nearorthoPS2bad],l2goo[nearorthoPS2bad],color=200,/oplot,symsize=1

            if nearperp1bad[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt2goo[nearperp1bad],l2goo[nearperp1bad],color=120,/oplot,symsize=1
            if nearperp2bad[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt2goo[nearperp2bad],l2goo[nearperp2bad],color=120,/oplot,symsize=1
            if nearPS1bad[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt2goo[nearPS1bad],l2goo[nearPS1bad],color=120,/oplot,symsize=1
            if nearPS2bad[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt2goo[nearPS2bad],l2goo[nearPS2bad],color=120,/oplot,symsize=1
            if nearpar1bad[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt2goo[nearpar1bad],l2goo[nearpar1bad],color=120,/oplot,symsize=1
            if nearpar2bad[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt2goo[nearpar2bad],l2goo[nearpar2bad],color=120,/oplot,symsize=1
            if nearorthoPS1bad[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt2goo[nearorthoPS1bad],l2goo[nearorthoPS1bad],color=120,/oplot,symsize=1
            if nearorthoPS2bad[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt2goo[nearorthoPS2bad],l2goo[nearorthoPS2bad],color=120,/oplot,symsize=1

            if other1[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt2goo[other1],l2goo[other1],color=120,/oplot,symsize=1
            if other2[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt2goo[other2],l2goo[other2],color=120,/oplot,symsize=1
            if other3[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt2goo[other3],l2goo[other3],color=120,/oplot,symsize=1
            if other4[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt2goo[other4],l2goo[other4],color=120,/oplot,symsize=1
            if other5[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt2goo[other5],l2goo[other5],color=120,/oplot,symsize=1
            if other6[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt2goo[other6],l2goo[other6],color=120,/oplot,symsize=1


         endif
        endif  ;colors for imf orientation

        ;------------------------------------------------
        ;DEFINE COLORS AND PLOT FOR SOLAR WIND CONE ANGLE
        ;------------------------------------------------


        if colors_for_coneangle then begin

          nearPS1 = where((coneaogoo ge 115) and (coneaogoo le 155) and (bratgoo le 1))
          nearOPS1 = where((coneaogoo ge 25) and (coneaogoo le 65) and (bratgoo le 1))
          nearperp1 = where((coneaogoo ge 65) and (coneaogoo le 115) and (bratgoo le 1))
          nearpar1 = where((coneaogoo ge 0) and (coneaogoo lt 25) and (bratgoo le 1))
          nearpar2 = where((coneaogoo gt 155) and (coneaogoo le 180) and (bratgoo le 1))

          nearPS1bad = where((coneaogoo ge 115) and (coneaogoo le 155) and (bratgoo gt 1))
          nearOPS1bad = where((coneaogoo ge 25) and (coneaogoo le 65) and (bratgoo gt 1))
          nearperp1bad = where((coneaogoo ge 65) and (coneaogoo le 115) and (bratgoo gt 1))
          nearpar1bad = where((coneaogoo ge 0) and (coneaogoo lt 25) and (bratgoo gt 1))
          nearpar2bad = where((coneaogoo gt 155) and (coneaogoo le 180) and (bratgoo gt 1))


          ;Plot squares where coherence is observed
          if goo[0] ne -1 then begin

            ;First for payload 1 values satisfying Bzrat<1
            if nearPS1[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt1goo[nearPS1],l1goo[nearPS1],color=0,/oplot,symsize=1
            if nearOPS1[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt1goo[nearOPS1],l1goo[nearOPS1],color=200,/oplot,symsize=1
            if nearperp1[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt1goo[nearperp1],l1goo[nearperp1],color=50,/oplot,symsize=1
            if nearpar1[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt1goo[nearpar1],l1goo[nearpar1],color=250,/oplot,symsize=1
            if nearpar2[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt1goo[nearpar2],l1goo[nearpar2],color=250,/oplot,symsize=1

;            if nearPS1bad[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt1goo[nearPS1bad],l1goo[nearPS1bad],color=0,/oplot,symsize=1
;            if nearOPS1bad[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt1goo[nearOPS1bad],l1goo[nearOPS1bad],color=200,/oplot,symsize=1
;            if nearperp1bad[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt1goo[nearperp1bad],l1goo[nearperp1bad],color=50,/oplot,symsize=1
;            if nearpar1bad[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt1goo[nearpar1bad],l1goo[nearpar1bad],color=250,/oplot,symsize=1
;            if nearpar2bad[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt1goo[nearpar2bad],l1goo[nearpar2bad],color=250,/oplot,symsize=1

            if nearPS1bad[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt1goo[nearPS1bad],l1goo[nearPS1bad],color=120,/oplot,symsize=1
            if nearOPS1bad[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt1goo[nearOPS1bad],l1goo[nearOPS1bad],color=120,/oplot,symsize=1
            if nearperp1bad[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt1goo[nearperp1bad],l1goo[nearperp1bad],color=120,/oplot,symsize=1
            if nearpar1bad[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt1goo[nearpar1bad],l1goo[nearpar1bad],color=120,/oplot,symsize=1
            if nearpar2bad[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt1goo[nearpar2bad],l1goo[nearpar2bad],color=120,/oplot,symsize=1



            ;Now for payload 2
            if nearPS1[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt2goo[nearPS1],l2goo[nearPS1],color=0,/oplot,symsize=1
            if nearOPS1[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt2goo[nearOPS1],l2goo[nearOPS1],color=200,/oplot,symsize=1
            if nearperp1[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt2goo[nearperp1],l2goo[nearperp1],color=50,/oplot,symsize=1
            if nearpar1[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt2goo[nearpar1],l2goo[nearpar1],color=250,/oplot,symsize=1
            if nearpar2[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt2goo[nearpar2],l2goo[nearpar2],color=250,/oplot,symsize=1

;            if nearPS1bad[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt2goo[nearPS1bad],l2goo[nearPS1bad],color=0,/oplot,symsize=1
;            if nearOPS1bad[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt2goo[nearOPS1bad],l2goo[nearOPS1bad],color=200,/oplot,symsize=1
;            if nearperp1bad[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt2goo[nearperp1bad],l2goo[nearperp1bad],color=50,/oplot,symsize=1
;            if nearpar1bad[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt2goo[nearpar1bad],l2goo[nearpar1bad],color=250,/oplot,symsize=1
;            if nearpar2bad[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt2goo[nearpar2bad],l2goo[nearpar2bad],color=250,/oplot,symsize=1

            if nearPS1bad[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt2goo[nearPS1bad],l2goo[nearPS1bad],color=120,/oplot,symsize=1
            if nearOPS1bad[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt2goo[nearOPS1bad],l2goo[nearOPS1bad],color=120,/oplot,symsize=1
            if nearperp1bad[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt2goo[nearperp1bad],l2goo[nearperp1bad],color=120,/oplot,symsize=1
            if nearpar1bad[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt2goo[nearpar1bad],l2goo[nearpar1bad],color=120,/oplot,symsize=1
            if nearpar2bad[0] ne -1 then plot_plasmapause_goldstein_boundary,dummytime,mlt2goo[nearpar2bad],l2goo[nearpar2bad],color=120,/oplot,symsize=1


          endif

        endif  ;colors_for_coneangle

 ;         plot_plasmapause_goldstein_boundary,dummytime,mlt2goo,l2goo,color=250,/oplot,symsize=1


          ;Plot everything as RED

          mltavg = (mlt1goo + mlt2goo)/2.
          lavg = (l1goo + l2goo)/2.
          plot_plasmapause_goldstein_boundary,dummytime,mltavg,lavg,color=250,/oplot,symsize=1
;          plot_plasmapause_goldstein_boundary,dummytime,mlt1goo,l1goo,color=250,/oplot,symsize=1
;          plot_plasmapause_goldstein_boundary,dummytime,mlt2goo,l2goo,color=250,/oplot,symsize=1


    endif ;have coherence values to plot


store_data,['MLT_Kp*','L_Kp*','flag_*','avg_*','diff?_*','fspc_*','alt_*','coh_*','phase_*','ratio*'],/del


undefine,mlt1goo,mlt2goo,l1goo,l2goo
;store_data,'coh_'+combos[i]+'*',/delete
;store_data,['L_Kp?_'+pre+p1+'*','L_Kp?_'+pre+p2+'*','fspc_'+pre+p1+'*','fspc_'+pre+p2+'*'],/delete
;store_data,['phase*','alt*','cohtots'],/del

endfor


pclose



end
