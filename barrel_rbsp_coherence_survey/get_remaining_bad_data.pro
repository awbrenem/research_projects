;This list (for 2014 only) represents the remaining bad data gaps in the coherence
;files even after all the flare events, etc have been removed. Sadie
;has identified these by eye
;Returns a structure with their times and durations

function get_remaining_bad_data

  openr,lun,'~/Desktop/code/Aaron/RBSP/efw_barrel_coherence_analysis/barrel_bad_data_2014.txt',/get_lun

  combo = ''
  date = ''
  starttime = ''
  endtime = ''

  junk = ''
  readf,lun,junk

  j=0.
  while not eof(lun) do begin
     readf,lun,junk
     j2 = strsplit(junk,string(9B), /extract)  ;;tab character
     combo = [combo,j2[0]]
     starttime = [starttime,j2[1]]
     endtime = [endtime,j2[2]]
     date = [date,j2[3]]
     j++
  endwhile

  close,lun
  free_lun,lun


  nelem = n_elements(combo)
  combo = combo[1:nelem-1]
  starttime = starttime[1:nelem-1]
  endtime = endtime[1:nelem-1]
  date = date[1:nelem-1]

  datetimestart = strarr(nelem-1)
  datetimeend = strarr(nelem-1)



  for i=0,nelem-2 do begin
     hash = strpos(date[i],'-')
     day = strmid(date[i],0,hash)
     if floor(float(day)) lt 10 then day = '0' + day
     ;; month = strmid(date[i],hash+1)
     ;; if floor(float(month)) lt 10 then month = '0' + month
     datetimestart[i] = '2014-01-' + day + '/' + starttime[i]
     datetimeend[i] = '2014-01-' + day + '/' + endtime[i]
  endfor

  duration = time_double(datetimeend) - time_double(datetimestart)


  return,{combo:combo, starttime:datetimestart, endtime:datetimeend, duration:duration}

end


