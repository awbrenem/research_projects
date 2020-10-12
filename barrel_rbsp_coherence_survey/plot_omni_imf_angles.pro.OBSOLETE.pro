;plot OMNI data for the BARREL mission, including 
;clock, cone, IMF angles, etc. (see Petrinec13)

;Petrinec13 shows that under certain IMF angles (those that I label w/ red bars), 
;the Msheath magnetic field is discombobulated pre-noon, but can be coherent post-noon. 
;I plot this in a way that's easy to compare to this paper. 


tplot_options,'plot_omni_imf_angles.pro'

timespan,'2014-01-01',45,/days
omni_hro_load

!p.charsize = 2


path = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/coh_vars_barrelmission2/'
path2 = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/folder_singlepayload/'

fn = 'all_coherence_plots_combined_meanfilter.tplot'
tplot_restore,filenames=path+fn
copy_data,'coh_allcombos_meanfilter','coh_allcombos_meanfilter_filtered'



;Create OMNI Bmag variable
get_data,'OMNI_HRO_1min_BX_GSE',data=bx
get_data,'OMNI_HRO_1min_BY_GSE',data=by
get_data,'OMNI_HRO_1min_BZ_GSE',data=bz
store_data,'OMNI_HRO_1min_bmag',data={x:bx.x,y:sqrt(bx.y^2+by.y^2+bz.y^2)}

;^^Check the SW clock angle (GSE coord)
;Clockangle: zero deg is along zGSE, 90 deg is along yGSE 
;Coneangle: zero deg is along xGSE, 90 along r=sqrt(yGSE^2+zGSE^2)
get_data,'OMNI_HRO_1min_BX_GSE',ttmp,bx
get_data,'OMNI_HRO_1min_BY_GSE',ttmp,by
get_data,'OMNI_HRO_1min_BZ_GSE',ttmp,bz
bmag = sqrt(bx^2 + by^2 + bz^2)

store_data,'clockangle',ttmp,atan(by,bz)/!dtor
store_data,'coneangle',ttmp,acos(bx/bmag)/!dtor
store_data,'IMF_orientation',ttmp,atan(by,bx)/!dtor  ;see Petrinec13
store_data,'Bz_rat',ttmp,abs(bz)/(sqrt(bx^2 + by^2)/2.)
store_data,'bline',ttmp,replicate(1.,n_elements(bx))
store_data,'Bz_rat_comb',data=['Bz_rat','bline']
ylim,'Bz_rat_comb',0,2


store_data,'nearperplineL',ttmp,replicate(70.,n_elements(bx))
store_data,'nearperplineH',ttmp,replicate(110.,n_elements(bx))
store_data,'nearperplinemL',ttmp,replicate(-70.,n_elements(bx))
store_data,'nearperplinemH',ttmp,replicate(-110.,n_elements(bx))
options,['nearperpline*'],'colors',250
options,['nearperpline*'],'thick',2
store_data,'nearPSline1',ttmp,replicate(125.,n_elements(bx))
store_data,'nearPSline2',ttmp,replicate(145.,n_elements(bx))
store_data,'nearPSline3',ttmp,replicate(-35.,n_elements(bx))
store_data,'nearPSline4',ttmp,replicate(-55.,n_elements(bx))
options,'nearPSline*','thick',2

store_data,'betweenlinem1',ttmp,replicate(-10.,n_elements(bx))
store_data,'betweenlinem2',ttmp,replicate(-30.,n_elements(bx))
store_data,'betweenline1',ttmp,replicate(150.,n_elements(bx))
store_data,'betweenline2',ttmp,replicate(170.,n_elements(bx))
options,'betweenline*','colors',50
options,'betweenline*','thick',2

store_data,'90line',ttmp,replicate(90.,n_elements(bx))
store_data,'0line',ttmp,replicate(0.,n_elements(bx))
store_data,'m90line',ttmp,replicate(-90.,n_elements(bx))
store_data,'180line',ttmp,replicate(180.,n_elements(bx))
store_data,'clockangle_comb',data=['clockangle','90line','0line','m90line','180line']
store_data,'coneangle_comb',data=['coneangle','90line','0line','m90line','180line']
options,['90line','m90line','0line','180line'],'color',250


store_data,'IMF_orientation_comb',data=['IMF_orientation','nearperplineL','nearperplineH','nearperplinemL','nearperplinemH',$
'nearPSline1','nearPSline2','nearPSline3','nearPSline4','betweenline1','betweenline2','betweenlinem1','betweenlinem2']
tplot,['coh_allcombos_meanfilter_filtered','IMF_orientation_comb','Bz_rat_comb']



tplot,['coh_allcombos_meanfilter_filtered','IMF_orientation_comb','coneangle_comb']


tplot,['clockangle_comb','coneangle_comb','kyoto_ae','kyoto_dst','OMNI_HRO_1min_flow_speed']
