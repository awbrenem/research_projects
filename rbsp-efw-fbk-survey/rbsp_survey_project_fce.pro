;Creates the fce_eq and fce_comb tplot variables. Can run this once we've called the '...read_ascii' program
;and the '...read_ephem' progam. 

;Aaron Breneman
;2013-01-12


pro rbsp_survey_project_fce

	;Find the equatorial value of fce (EMFISIS data should already be loaded)
	get_data,'fce',data=fce
	get_data,'mlat',data=mlat
	fce_eq = fce.y*cos(2*mlat.y*!dtor)^3/sqrt(1+3*sin(mlat.y*!dtor)^2)

	store_data,'fce_eq',data={x:fce.x,y:fce_eq}

	store_data,'fce_comb',data=['fce','fce_eq']
	options,'fce_comb','colors',[0,250]

end


