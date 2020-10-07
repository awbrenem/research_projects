;Finds out what days the Kyoto AE index is greater than aemin
;Returns a structure with all the times where this is true
;as well as the unique dates where this is true

function ae_sort, aemin

	rbsp_efw_init

	date = '2012-09-25'
	timespan,date,365,/days

	kyoto_load_ae

	ylim,'kyoto_ae',0,2000


	get_data,'kyoto_ae',data=ae

	goo = where(ae.y ge aemin)

	dates_all = time_string(ae.x[goo])
	datestmp = strmid(dates_all,0,10)
	dates_uniq = datestmp[uniq(datestmp)]

	;	tplot,'kyoto_ae'
	;	timebar,time_double(dates),color=250

	d = {$
	dates_all:dates_all,$
	dates_uniq:dates_uniq,$
	aemin:aemin}

	return,d


end
