;Tally the number of payloads making simultaneous measurements and the number of coherence plots
;as a function of time.
;Also tracks the L, MLT, alt, and distance from PP of all payloads vs time.

;**All of these values are designed to give me an idea of balloon coverage vs time.


pre = '1'

rbsp_efw_init
yellow_to_orange

tplot_options,'title','tally_payloads_and_coh_combinations.pro'

run = 'coh_vars_barrelmission1'
single = 'folder_singlepayload'
path = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/'
path1 = path + run
path2 = path + single
path3 = path + 'barrel_ephemeris'


;Campaign 1
payloads = ['b','d','i','g','c','h','a','j','k','m','o','q','r','s','t','u','v']
combos = ['BD','BJ','BK','BM','BO','DI','DG','DC','DH','DJ','DK','DM','DO','DQ','DR','IG','IC','IH','IA','IJ','IK','IM','IO','IQ','IR','IS','IT','IU','IV','GC','GH','GJ','GK','GO','GQ','GR','GS','GT','GU','CH','CK','CO','CQ','CR','CS','CT','HA','HK','HQ','HR','HS','HT','HU','HV','AQ','AT','AU','AV','JK','JM','JO','KM','KO','KQ','MO','QR','QS','QT','QU','QV','RS','ST','SU','TU','TV','UV']

;Campaign 2
;payloads = strupcase(['i','t','w','k','l','x','a','b','e','o','p'])
;combos =   ['IT','IW','IK','IL','IX','TW','TK','TL','TX','WK','WL','WX','KL','KX','LX','LA','LB','LE','LO','LP','XA','XB','AB','AE','AO','AP','BE','BO','BP','EO','EP','OP']


ncombos = n_elements(combos)

for i=0,n_elements(payloads)-1 do tplot_restore,filenames=path2 + '/' + 'barrel_'+pre+payloads[i]+'_fspc_fullmission.tplot'
for i=0,n_elements(payloads)-1 do tplot_restore,filenames=path3 + '/' + pre+payloads[i]+'_pp_dist.tplot'


tvars = tnames('fspc_'+pre+'*')
;tplot,tvars


;Create common time base
t0 = time_double('2013-01-01/00:00')
t1 = time_double('2013-02-15/00:00')
cadence = 1.*60.*60.  ;sec
ntimes = (t1-t0)/cadence
intrp_times = cadence*dindgen(ntimes) + t0

;This array will contain a yes/no value for whether each balloon has data vs time
binary_sp = fltarr(n_elements(intrp_times),n_elements(tvars))
for b=0,n_elements(intrp_times)-1 do for c=0,n_elements(tvars)-1 do binary_sp[b,c] = mean(tsample(tvars[c],[intrp_times[b],intrp_times[b]+60.]))
binary_sp = byte(binary_sp/binary_sp)

;Find total # of balloons at each time that are taking data
totals = fltarr(n_elements(intrp_times))
for i=0,n_elements(totals)-1 do totals[i] = total(binary_sp[i,*],/nan)
store_data,'totalpayloads',intrp_times,totals

;tplot,['totalpayloads',tvars]



;Track the altitude for all balloons currently taking data
altnames = tnames('*alt*')
store_data,'altvars',data=altnames
options,'altvars','colors',[0,250,25,225,50,195,75,150,100,125]
ylim,'altvars',15,40
tplot,['altvars','totalpayloads']


;Track the MLT for all balloons
MLTnames = tnames('*MLT_Kp2*')
store_data,'MLTvars_Kp2',data=MLTnames
options,'MLTvars_Kp2','colors',[0,250,25,225,50,195,75,150,100,125]
ylim,'MLTvars_Kp2',0,24
tplot,['MLTvars_Kp2','totalpayloads']


;Track the Lshell for all balloons
Lnames = tnames('*L_Kp2*')
store_data,'Lvars_Kp2',data=Lnames
options,'Lvars_Kp2','colors',[0,250,25,225,50,195,75,150,100,125]
ylim,'Lvars_Kp2',0,24
tplot,['Lvars_Kp2','totalpayloads']

;Track the L distance from PP binary value for all balloons
distppnames = tnames('*dist_pp_??_bin_0.5')
store_data,'dist_pp_bin',data=distppnames
options,'dist_pp_bin','colors',[0,250,25,225,50,195,75,150,100,125]
ylim,'dist_pp_bin',-1.1,1.1
options,'dist_pp_bin','psym',4
tplot,['dist_pp_bin','totalpayloads']


;Track the L distance from PP value for all balloons
distppnames = tnames('*dist_pp_??')
store_data,'zeroline',intrp_times,replicate(0.,n_elements(intrp_times))
store_data,'dist_pp',data=['zeroline',distppnames]
options,'dist_pp','colors',[0,250,25,225,50,195,75,150,100,125]
ylim,'dist_pp',-5,20
options,'dist_pp','psym',0
tplot,['dist_pp','totalpayloads']




;Grab the combined coherence plot
;tplot_restore,filenames=path1+'/'+'all_coherence_plots_combined_meanfilter.tplot'
tplot_restore,filenames=path1+'/'+'all_coherence_plots_combined_meanfilter_noextremefiltering.tplot'



;Plot all the results
tplot,['coh_allcombos_meanfilter','dist_pp_bin','dist_pp','altvars','Lvars_Kp2','MLTvars_Kp2','totalpayloads']



tplot_save,['totalpayloads',tvars],filename=path2 + '/total_number_of_payloads_mission'+pre


end
