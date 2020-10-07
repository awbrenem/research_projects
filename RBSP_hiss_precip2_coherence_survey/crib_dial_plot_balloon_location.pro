;crib sheet for calling dial_plot_balloon_location to see where
;certain balloons are located at certain times.


rbsp_efw_init

filter_data = 1
load_data = 1

;load L and MLT data
fspcs = 'fspc'
pre = '1'
run = 'coh_vars_barrelmission'+pre
folder_singlepayload = 'folder_singlepayload'
path = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/'
path2 = path + run
path3 = path + folder_singlepayload
combos = ['BD','BJ','BK','BM','BO','DI','DG','DC','DH','DJ','DK','DM','DO','DQ',$
    'DR','IG','IC','IH','IA','IJ','IK','IM','IO','IQ','IR','IS','IT','IU','IV','GC',$
    'GH','GJ','GK','GO','GQ','GR','GS','GT','GU','CH','CK','CO','CQ','CR','CS','CT',$
    'HA','HK','HQ','HR','HS','HT','HU','HV','AQ','AT','AU','AV','JK','JM','JO','KM',$
    'KO','KQ','MO','QR','QS','QT','QU','QV','RS','ST','SU','TU','TV','UV']
t0f = time_double('2013-01-01')
t1f = time_double('2013-02-15')


;Define some filtering variables
mincoh = 0.7
threshold = 0.0001   ;set low. These have already been filtered.
max_mltdiff=12.
max_ldiff=15.
ratiomax=2.
periodmin = 10.
periodmax = 60.
dt = 1*3600./2.  ;time chunk size (sec) for dial plot.




colors = 8*indgen(n_elements(combos))
timespan,t0f,t1f-t0f,/seconds

ntimes = (t1f - t0f)/dt  ;number of chunks of size dt
timesALL = t0f + indgen(ntimes)*dt


;-----------------------------------------
;Extract coherence values for dial plot

;  tplot_restore,filenames=path + '/' + combos[i] + '.tplot'
;  copy_data,'coh_'+combos[i]+'_meanfilter','coh_'+combos[i]+'_meanfilter_original'

for i=0,n_elements(combos)-1 do begin

  ;Load the data 
  tplot_restore,filenames=path2 + '/' + combos[i] + '_meanfilter.tplot'
  tplot_restore,filenames=path3 + '/barrel_'+pre+strmid(combos[i],0,1)+'_'+fspcS+'_fullmission.tplot'
  tplot_restore,filenames=path3 + '/barrel_'+pre+strmid(combos[i],1,1)+'_'+fspcS+'_fullmission.tplot'



  p1 = strmid(combos[i],0,1)
  p2 = strmid(combos[i],1,1)
  
  filter_coherence_spectra,'coh_'+p1+p2+'_meanfilter','L_Kp2_'+pre+p1,'L_Kp2_'+pre+p2,'MLT_Kp2_'+pre+p1,'MLT_Kp2_'+pre+p2,$
    mincoh,$
    periodmin,periodmax,$
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
    ratiomax=ratiomax,$
    /remove_lowsignal_fluctuation
    ratiomax=ratiomax

  ;;-------------------------------------------
  ;;Extract timeseries from coherence spectra
  ;;and find peak coherence for each time over the considered wave periods
  ;;-------------------------------------------

  get_data,'coh_'+combos[i]+'_meanfilter',data=d,dlim=dlim,lim=lim
  periods = d.v
  t0 = min(d.x,/nan)
  t1 = max(d.x,/nan)

  goodperiods = where((d.v ge periodmin) and (d.v le periodmax))

  peak_value = fltarr(n_elements(d.x))
  for j=0,n_elements(d.x)-1 do peak_value[j] = max(d.y[j,goodperiods],/nan)
  store_data,combos[i]+'_peak_value',d.x,peak_value


  ;dummy plot without any payload trajectories.
  if i eq 0 then begin 
    l1 = 'L_Kp2_'+pre+p1 & mlt1 = 'MLT_Kp2_'+pre+p1
    l2 = 'L_Kp2_'+pre+p2 & mlt2 = 'MLT_Kp2_'+pre+p2
    dial_plot_balloon_location,l1,l2,mlt1,mlt2,t0,t1,p1+p2+'_peak_value',$
      xrange=[-20,20],yrange=[-20,20],payload1=p1,payload2=p2
  endif


  ;For each time chunk within current combo
  for b=0,ntimes-2 do begin

    t0 = timesALL[b]
    t1 = timesALL[b+1]
    t0t = time_string(t0)
    t1t = time_string(t1)
    t0s = strmid(t0t,0,4)+strmid(t0t,5,2)+strmid(t0t,8,2)+'_'+strmid(t0t,11,2)+strmid(t0t,14,2)+strmid(t0t,17,2)
    t1s = strmid(t1t,0,4)+strmid(t1t,5,2)+strmid(t1t,8,2)+'_'+strmid(t1t,11,2)+strmid(t1t,14,2)+strmid(t1t,17,2)
    ;if ~keyword_set(oplot) then popen,'~/Desktop/barrel_movie_'+t0s+'_'+t1s


    ;plot all payloads
    dial_plot_balloon_location,'L_Kp2_'+pre+strmid(combos[i],0,1),$
    'L_Kp2_'+pre+strmid(combos[i],1,1),'MLT_Kp2_'+pre+strmid(combos[i],0,1),'MLT_Kp2_'+pre+strmid(combos[i],1,1),$
    t0,t1,combos[i]+'_peak_value',/oplot,color=colors[i],payload1=strmid(combos[i],0,1),payload2=strmid(combos[i],1,1)


;    ;plot all payloads
;    for j=0,n_elements(combos)-1 do dial_plot_balloon_location,'L_Kp2_2'+strmid(combos[j],0,1),$
;    'L_Kp2_2'+strmid(combos[j],1,1),'MLT_Kp2_2'+strmid(combos[j],0,1),'MLT_Kp2_2'+strmid(combos[j],1,1),$
;    t0,t1,combos[j]+'_peak_value',/oplot,color=colors[j],payload1=strmid(combos[j],0,1),payload2=strmid(combos[j],1,1)

  endfor ;for all the times within a single combo

print,combos[i]
stop
  store_data,'*',/delete

endfor  ;for each combo


stop


end
