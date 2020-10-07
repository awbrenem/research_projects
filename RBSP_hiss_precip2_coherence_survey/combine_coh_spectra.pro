;Combine all the coherence spectra into a single spectra for nice plotting.
;Save this spectra in a tplot file.

;NOTE:
;***Code takes quite a while to run (like 0.5 hrs). See part after the for loop to 
;load tplot save file to skip the long part. 



pro combine_coh_spectra

    pre = '1'

    rbsp_efw_init
    store_data,tnames(),/delete

    tplot_options,'title','combine_coh_spectra.pro'

    run = 'coh_vars_barrelmission'+pre+'v2'
    ephem = 'folder_singlepayload'
    path = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/'
    path1 = path + run
    path2 = path + ephem
    path3 = path + 'barrel_ephemeris'



    ;campaign 1 
    if pre eq '1' then combos = ['BD','BJ','BK','BM','BO','DI','DG','DC','DH','DJ','DK','DM','DO','DQ',$
    'DR','IG','IC','IH','IA','IJ','IK','IM','IO','IQ','IR','IS','IT','IU','IV','GC',$
    'GH','GJ','GK','GO','GQ','GR','GS','GT','GU','CH','CK','CO','CQ','CR','CS','CT',$
    'HA','HK','HQ','HR','HS','HT','HU','HV','AQ','AT','AU','AV','JK','JM','JO','KM',$
    'KO','KQ','MO','QR','QS','QT','QU','QV','RS','ST','SU','TU','TV','UV']

    ;campaign 2
    if pre eq '2' then combos = ['IT','IW','IK','IL','IX','TW','TK','TL','TX','WK','WL',$
    'WX','KL','KX','LX','LA','LB','LE','LO','LP','XA','XB','AB','AE','AO','AP','BE','BO','BP','EO','EP','OP']


    ncombos = n_elements(combos)


    ;Create common time base
    if pre eq '1' then begin 
        t0 = time_double('2013-01-01/00:00')
        t1 = time_double('2013-02-16/00:00')
    endif
    if pre eq '2' then begin 
        t0 = time_double('2014-01-01/00:00')
        t1 = time_double('2014-02-16/00:00')
    endif

    cadence = 60.  ;sec
    ntimes = (t1-t0)/cadence
    intrp_times = cadence*dindgen(ntimes) + t0

    store_data,'Ltmp',intrp_times,replicate(5.,n_elements(intrp_times))
    store_data,'MLTtmp',intrp_times,replicate(5.,n_elements(intrp_times))
    copy_data,'Ltmp','Ltmp2'
    copy_data,'MLTtmp','MLTtmp2'



    ;Interpolate each coherence spectra to the common time base
    for i=0,ncombos-1 do begin

        p1 = strmid(combos[i],0,1)
        p2 = strmid(combos[i],1,1)

        tplot_restore,filenames=path1 + '/' + combos[i] + '.tplot'
        tplot_restore,filenames=path1 + '/' + combos[i] + '_meanfilter.tplot'
        tplot_restore,filenames=path2 + '/' + 'barrel_'+pre+p1+'_fspc_fullmission.tplot'
        tplot_restore,filenames=path2 + '/' + 'barrel_'+pre+p2+'_fspc_fullmission.tplot'
        tplot_restore,filenames=path3 + '/' + pre+p1+'_pp_dist.tplot'
        tplot_restore,filenames=path3 + '/' + pre+p2+'_pp_dist.tplot'

        copy_data,'coh_'+combos[i]+'_meanfilter','coh_'+combos[i]+'_meanfilter_orig'

        get_data,'coh_'+combos[i]+'_meanfilter',data=d,dlim=dlim,lim=lim
        periods = d.v
        t0 = min(d.x,/nan)
        t1 = max(d.x,/nan)


        ;Filter values
        threshold = 0.0001   ;set low. These have already been filtered.
;        mincoh = 0.5
        mincoh = 0.7
;        periodrange=[10,60]
        periodrange=[2,40]
        max_mltdiff=12.
        max_ldiff=15.
        ratiomax=2.


        filter_coherence_spectra,'coh_'+p1+p2+'_meanfilter','L_Kp2_'+pre+p1,'L_Kp2_'+pre+p2,'MLT_Kp2_'+pre+p1,'MLT_Kp2_'+pre+p2,$
        mincoh,$
        periodrange[0],periodrange[1],$
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



;zlim,['coh_'+p1+p2,'coh_'+p1+p2+'_meanfilter','coh_'+p1+p2+'_meanfilter_orig'],mincoh,0.9
;tplot,['coh_'+p1+p2,'coh_'+p1+p2+'_meanfilter_orig','coh_'+p1+p2+'_meanfilter','L_Kp2_'+pre+p1,'L_Kp2_'+pre+p2,'dist_pp_'+pre+p1,'dist_pp_'+pre+p2,'MLT_Kp2_'+pre+p1,'MLT_Kp2_'+pre+p2,'alt_'+pre+p1,'alt_'+pre+p2]
;stop


        ;Put the coherence spectrum on a common timebase
        get_data,'coh_'+p1+p2+'_meanfilter',data=d,dlim=dlim,lim=lim
        goo = where(finite(d.y) eq 0.)
        if goo[0] ne -1 then d.y[goo] = 0.

        nelem = n_elements(d.x)-1
        arrglob = [[d.x[1:nelem]],[d.y[1:nelem,*]]]

        val = resample(arrglob,intrp_times,/nan)
        nelem = n_elements(val[0,*])
        yval = val[*,1:nelem-1]
        store_data,'coh_'+p1+p2+'_meanfilter',val[*,0],yval,d.v,dlim=dlim,lim=lim




        ;Pad the time array so that it extends for the entire time range
        mint = min(val[*,0],/nan)
        maxt = max(val[*,0],/nan)

        goomin = where(intrp_times lt mint)
        goomax = where(intrp_times gt maxt)

        ;new times
        newt = [intrp_times[goomin],val[*,0],intrp_times[goomax]]

        dummymin = replicate(0.,[n_elements(goomin),40])
        dummymax = replicate(0.,[n_elements(goomax),40])
;        dummymin = replicate(0.,[n_elements(goomin),90])
;        dummymax = replicate(0.,[n_elements(goomax),90])

        ;new y-values
        newd = [dummymin,yval,dummymax]

        store_data,'coh_'+p1+p2+'_meanfilter',newt,newd,d.v,dlim=dlim,lim=lim




        ;Create a binary variable that has 1 when coherence values exist, 0 otherwise
        copy_data,'coh_'+p1+p2+'_meanfilter','coh_'+p1+p2+'_meanfilter_binary'
        get_data,'coh_'+p1+p2+'_meanfilter_binary',data=bb

        bb.y = bb.y/bb.y
        poo = where(finite(bb.y) eq 0.)
        if poo[0] ne -1 then bb.y[poo] = 0.
        store_data,'coh_'+p1+p2+'_meanfilter_binary',data=bb


        store_data,'*phase*',/del
        store_data,'coh_??',/del
        store_data,'*alt*',/del
        store_data,['fspc'+'_'+pre+p1,'fspc'+'_'+pre+p2],/del
    endfor


    ;Now that all the coherence spectra are on the SAME time base, we can add them together.

    ;---Add first two and create a new variable called "tmp"
    add_data,'coh_'+combos[0]+'_meanfilter','coh_'+combos[1]+'_meanfilter',newname='tmp'
    ;---Add all the other combos.
    for i=2,ncombos-1 do add_data,'tmp','coh_'+combos[i]+'_meanfilter',newname='tmp'
    ;---Create the final tplot variable that contains all the coherence spectra added together.
    get_data,'tmp',data=dtmp
    goo = where(dtmp.y eq 0.)
    if goo[0] ne -1 then dtmp.y[goo] = !values.f_nan
    store_data,'coh_allcombos_meanfilter',dtmp.x,dtmp.y,d.v,dlim=dlim,lim=lim

    ;---Do the same for the binary variables
    add_data,'coh_'+combos[0]+'_meanfilter_binary','coh_'+combos[1]+'_meanfilter_binary',newname='tmp'
    for i=2,ncombos-1 do add_data,'tmp','coh_'+combos[i]+'_meanfilter_binary',newname='tmp'
    get_data,'tmp',data=dtmp
    goo = where(dtmp.y eq 0.)
    if goo[0] ne -1 then dtmp.y[goo] = 1.
    store_data,'coh_allcombos_meanfilter_binary',dtmp.x,dtmp.y,d.v,dlim=dlim,lim=lim
    zlim,'coh_allcombos_meanfilter_binary',0,10,0



;-------------------------------------
;*******
;At this point, save current progress. Program takes about 1/2 hour to run up to this point. 
;These variables represent all the coherence spectra added together, as well as the "binary" spectra, 
;which has a value of 1 for each time coherence survives (used for normalization)
stop
pre ='1'
pathtmp = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/coh_vars_barrelmission'+pre+'v2'
tplot_restore,filename=pathtmp +  '/campaign'+pre+'_tplot_backup_for_combine_coh_spectra.tplot'

;*******
tplot_save,'*',filename=pathtmp + '/campaign'+pre+'_tplot_backup_for_combine_coh_spectra'
;-------------------------------------

zlim,'coh_allcombos_meanfilter_binary',0,5

rbsp_efw_init 

;Record of the number of coherence combinations with actual data during each time
get_data,'coh_allcombos_meanfilter_binary',data=dtmp

;normalize by the total number of coherence combos (WITH ACTUAL DATA) at any given time
get_data,'coh_allcombos_meanfilter',data=dd,dlim=dlim,lim=lim
data_norm = dd.y/dtmp.y
store_data,'coh_allcombos_meanfilter_normalized',data={x:dd.x,y:data_norm,v:dd.v},dlim=dlim,lim=lim

zlim,'coh_allcombos_meanfilter_binary',0,4
tplot,['coh_allcombos_meanfilter','coh_allcombos_meanfilter_normalized','coh_allcombos_meanfilter_binary']

copy_data,'coh_allcombos_meanfilter_normalized','coh_allcombos_meanfilter_normalized2'

;Now filter the combined spectral product. 
mincoh2 = 0.5
periodrange=[10,60]
max_mltdiff=12.
max_ldiff=15.

filter_coherence_spectra,'coh_allcombos_meanfilter_normalized2','Ltmp','Ltmp2','MLTtmp','MLTtmp2',$
mincoh2,$
periodrange[0],periodrange[1],$
max_mltdiff,$
max_ldiff,$
/remove_mincoh,$
/remove_slidingwindow,$
ratiomax=1.005

options,'coh_allcombos_meanfilter','ytitle','coherence!Callcombos!Cmeanfilter only'
options,'coh_allcombos_meanfilter_normalized','ytitle','coherence!Callcombos!Cmeanfilter!C+normalized'
options,'coh_allcombos_meanfilter_normalized2','ytitle','coherence!Callcombos!Cmeanfilter!C+normalized2!C+refiltered'
options,'coh_allcombos_meanfilter_binary','ytitle','coherence!Callcombos binary!C#contributing combos'


savevars = ['coh_allcombos_meanfilter','coh_allcombos_meanfilter_normalized','coh_allcombos_meanfilter_binary','coh_allcombos_meanfilter_normalized2']
tplot,savevars

run = 'coh_vars_barrelmission'+pre+'v2'
path = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/'
path1 = path + run
tplot_save,savevars,filename=path1+'/all_coherence_plots_combined'




end
