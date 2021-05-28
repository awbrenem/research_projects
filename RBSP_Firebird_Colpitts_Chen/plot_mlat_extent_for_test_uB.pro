;Make various plots showing how the source region of uB scattering narrows when 
;you have 5 vs 10 vs 20 energy bins 

rbsp_efw_init

restore,filename='/Users/aaronbreneman/Desktop/code/Aaron/github.umn.edu/research_projects/RBSP_Firebird_Colpitts_Chen/crib_raytrace_IMPAX_call_output'

goo1 = where(N_S_raysF eq 'N')
goo2 = where(nbinsF[goo1] eq 5)
goo = goo1[goo2]
deltalat_max5N = deltalat_fin_maxF[goo]
lats_low_min5N = lats_low_fin_minf[goo]
lats_low_max5N = lats_low_fin_maxf[goo]
lats_hig_min5N = lats_hig_fin_minf[goo]
lats_hig_max5N = lats_hig_fin_maxf[goo]
source5N = source_LF[goo]

goo1 = where(N_S_raysF eq 'S')
goo2 = where(nbinsF[goo1] eq 5)
goo = goo1[goo2]
deltalat_max5S = deltalat_fin_maxF[goo]
lats_low_min5S = lats_low_fin_minf[goo]
lats_low_max5S = lats_low_fin_maxf[goo]
lats_hig_min5S = lats_hig_fin_minf[goo]
lats_hig_max5S = lats_hig_fin_maxf[goo]
source5S = source_LF[goo]


goo1 = where(N_S_raysF eq 'N')
goo2 = where(nbinsF[goo1] eq 10)
goo = goo1[goo2]
deltalat_max10N = deltalat_fin_maxF[goo]
lats_low_min10N = lats_low_fin_minf[goo]
lats_low_max10N = lats_low_fin_maxf[goo]
lats_hig_min10N = lats_hig_fin_minf[goo]
lats_hig_max10N = lats_hig_fin_maxf[goo]
source10N = source_LF[goo]

goo1 = where(N_S_raysF eq 'S')
goo2 = where(nbinsF[goo1] eq 10)
goo = goo1[goo2]
deltalat_max10S = deltalat_fin_maxF[goo]
lats_low_min10S = lats_low_fin_minf[goo]
lats_low_max10S = lats_low_fin_maxf[goo]
lats_hig_min10S = lats_hig_fin_minf[goo]
lats_hig_max10S = lats_hig_fin_maxf[goo]
source10S = source_LF[goo]

goo1 = where(N_S_raysF eq 'N')
goo2 = where(nbinsF[goo1] eq 20)
goo = goo1[goo2]
deltalat_max20N = deltalat_fin_maxF[goo]
lats_low_min20N = lats_low_fin_minf[goo]
lats_low_max20N = lats_low_fin_maxf[goo]
lats_hig_min20N = lats_hig_fin_minf[goo]
lats_hig_max20N = lats_hig_fin_maxf[goo]
source20N = source_LF[goo]

goo1 = where(N_S_raysF eq 'S')
goo2 = where(nbinsF[goo1] eq 20)
goo = goo1[goo2]
deltalat_max20S = deltalat_fin_maxF[goo]
lats_low_min20S = lats_low_fin_minf[goo]
lats_low_max20S = lats_low_fin_maxf[goo]
lats_hig_min20S = lats_hig_fin_minf[goo]
lats_hig_max20S = lats_hig_fin_maxf[goo]
source20S = source_LF[goo]



!p.multi = [0,0,2]

;Northward source
plot,source5N,lats_low_min5N,psym=-4,yrange=[23,38],xrange=[5.7,6.6]
oplot,source5N,lats_low_max5N,psym=-4
oplot,source5N,lats_hig_min5N,psym=-4
oplot,source5N,lats_hig_max5N,psym=-4
oplot,source10N,lats_low_min10N,psym=-4,color=100
oplot,source10N,lats_low_max10N,psym=-4,color=100
oplot,source10N,lats_hig_min10N,psym=-4,color=100
oplot,source10N,lats_hig_max10N,psym=-4,color=100
oplot,source20N,lats_low_min20N,psym=-4,color=200
oplot,source20N,lats_low_max20N,psym=-4,color=200
oplot,source20N,lats_hig_min20N,psym=-4,color=200
oplot,source20N,lats_hig_max20N,psym=-4,color=200


;Southward source
plot,source5S,lats_low_min5S,psym=-4,yrange=[-38,-23],xrange=[5.7,6.6]
oplot,source5S,lats_low_max5S,psym=-4
oplot,source5S,lats_hig_min5S,psym=-4
oplot,source5S,lats_hig_max5S,psym=-4
oplot,source10S,lats_low_min10S,psym=-4,color=100
oplot,source10S,lats_low_max10S,psym=-4,color=100
oplot,source10S,lats_hig_min10S,psym=-4,color=100
oplot,source10S,lats_hig_max10S,psym=-4,color=100
oplot,source20S,lats_low_min20S,psym=-4,color=200
oplot,source20S,lats_low_max20S,psym=-4,color=200
oplot,source20S,lats_hig_min20S,psym=-4,color=200
oplot,source20S,lats_hig_max20S,psym=-4,color=200


