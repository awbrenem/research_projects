;Finds out what days the Kyoto DST index is below a certain value (dstmax)
;Returns a structure with all the times where this is true
;as well as the unique dates where this is true


function dst_sort,dstmax

	rbsp_efw_init

	date = '2012-09-25'
	timespan,date,365,/days

	kyoto_load_dst    
	ylim,'kyoto_dst',-150,50


	get_data,'kyoto_dst',data=dst

	goo = where(dst.y le dstmax)

	dates_all = time_string(dst.x[goo])
	datestmp = strmid(dates_all,0,10)
	dates_uniq = datestmp[uniq(datestmp)]

	;tplot,'kyoto_dst'
	;timebar,time_double(dates)

	d = {dates_all:dates_all,$
		 dates_uniq:dates_uniq,$
		 dstmax:dstmax}

	return,d

end