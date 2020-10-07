;Read the list of solar flare events that Sadie Tetrick identified.
;Returns a structure with their times and durations

function get_flare_list

;; openr,lun,'~/Desktop/Research/RBSP_hiss_precip/idl/flare_list.txt',/get_lun
;openr,lun,'~/Desktop/code/Aaron/RBSP/efw_barrel_coherence_analysis/flare_list.txt',/get_lun
openr,lun,'~/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/flare_list/flare_list.txt',/get_lun
            ;/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/flare_list
time = 0d
datetime = ''
duration = 0.

j=0.
while not eof(lun) do begin
   junk = ''
   readf,lun,junk
   j2 = strsplit(junk,' ', /extract)
   datetime = [datetime,j2[0]]
   time = [time,j2[1]]
   duration = [duration,j2[2]]
   j++
endwhile

close,lun
free_lun,lun

return,{datetime:datetime, time:time, duration:duration}

end
