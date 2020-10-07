
;....OBSOLETE
pro rbsp_survey_fbk_get_times,info


	;; ndays = floor((time_double(info.d1) - time_double(info.d0))/86400 + 1)
	;; str_element,info,'ndays',ndays,/ADD_REPLACE

	;; days = strmid(time_string(time_double(info.d0) + (86400*indgen(info.ndays)+1)),0,10)
	;; str_element,info,'days',days,/ADD_REPLACE



;	for dd=0,info.ndays-1 do begin

	
		;number of times with timestep dt
		ntimes = 86400./info.dt	

		t0 = time_double(info.days[dd])
		t1 = time_double(info.days[dd]) + info.dt

		;; timesb = t0 + info.dt*indgen(ntimes)   ;time at beginning of bin
		;; timese = t1 + info.dt*indgen(ntimes)	  ;time at end of bin

		timesb = info.dt*indgen(ntimes)   ;time at beginning of bin
		timese = timesb + dt
                timesc = timesb + dt/2.

                ;; timesb_f = timesb[0]
                ;; timese_f = timese[0]
                

		;; for ntime=0d,ntimes-1 do begin

		;; 	timesb[ntime] = t0
		;; 	timese[ntime] = t1

		;; 	t0 = t0 + info.dt
		;; 	t1 = t1 + info.dt
			
		;; endfor

		;; if dd eq 0 then timesb_f = timesb else timesb_f = [timesb_f,timesb]
		;; if dd eq 0 then timese_f = timese else timese_f = [timese_f,timese]
	
;	endfor
	
	;get center times

                timesc = (timese + timesb)/2.

	timesc_f = (timese_f + timesb_f)/2d
	
	str_element,info,'timesb',timesb_f,/ADD_REPLACE
	str_element,info,'timese',timese_f,/ADD_REPLACE
	str_element,info,'timesc',timesc_f,/ADD_REPLACE
	
	
	;Add the frequencies to the structure

	;; fbk13_binsL = [0.8,1.5,3,6,12,25,50,100,200,400,800,1600,3200]
	;; fbk13_binsH = [1.5,3,6,12,25,50,100,200,400,800,1600,3200,6500]
	;; fbk7_binsL = fbk13_binsL[lindgen(7)*2]
	;; fbk7_binsH = fbk13_binsH[lindgen(7)*2]
	
	;; fbk13_binsC = (fbk13_binsH + fbk13_binsL)/2.
	;; fbk7_binsC = (fbk7_binsH + fbk7_binsL)/2.

	;; fbk_freqs = {fbk13_binsL:fbk13_binsL,$
	;; 		fbk13_binsH:fbk13_binsH,$
	;; 		fbk7_binsL:fbk7_binsL,$
	;; 		fbk7_binsH:fbk7_binsH,$
	;; 		fbk13_binsC:fbk13_binsC,$
	;; 		fbk7_binsC:fbk7_binsC}
		
	;; str_element,info,'fbk_freqs',fbk_freqs,/ADD_REPLACE


	
	
	
end
