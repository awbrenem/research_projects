;load BARREL location w/r to plasmapause for a payload (e.g. 2I). 
;
;Returns tplot variables
;dist_pp_2I  --> RE distance from PP
;dist_pp_2I_comb --> same as dist_pp_2I but with a zeroline added
;dist_mlt_2I --> ????
;dist_pp_2I_bin --> binary variable, whether balloon is inside or outside of PS
;dist_pp_2I_bin_0.5 --> same as above binary variable, but only defined as inside/outside PS
;     if the payload is at least 0.5 RE from the PP.


pro load_barrel_plasmapause_distance,payload

  path = '~/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/barrel_ephemeris/'
  fn = payload + '_pp_dist.tplot'
  tplot_restore,filenames=path+fn

  get_data,'dist_pp_'+payload,data=d
  store_data,'zerolinePP',d.x,replicate(0.,n_elements(d.x))
  store_data,'zero5linePP',d.x,replicate(0.5,n_elements(d.x))
  store_data,'zerom5linePP',d.x,replicate(-0.5,n_elements(d.x))
  options,['zerolinePP','zero5linePP','zerom5linePP'],'linestyle',2

  store_data,'dist_pp_'+payload+'_comb',data=['dist_pp_'+payload,'zerolinePP']
  ylim,['dist_pp_'+payload+'_comb'],-5,5

  store_data,'dist_pp_'+payload+'_bin_comb',data=['dist_pp_'+payload+'_bin','zerolinePP']
  store_data,'dist_pp_'+payload+'_bin_0.5_comb',data=['dist_pp_'+payload+'_bin_0.5','zerolinePP','zero5linePP','zerom5linePP']

  ylim,'dist_pp_'+payload+'_bin',-1.5,1.5
  ylim,'dist_pp_'+payload+'_bin_0.5',-1.5,1.5
  ylim,'dist_pp_'+payload+'_bin_comb',-1.5,1.5
  ylim,'dist_pp_'+payload+'_bin_0.5_comb',-1.5,1.5

;  tplot,['dist_pp_'+payload+'_comb','dist_pp_'+payload+'_bin_comb','dist_pp_'+payload+'_bin_0.5_comb']

end
