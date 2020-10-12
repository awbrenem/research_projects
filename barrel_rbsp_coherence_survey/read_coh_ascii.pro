;Read in the ASCII files (created from create_coh_ascii.pro) with the calculated coherence for each BARREL
;payload combination. Called from coh_analysis_driver.py

;*************************************************
;SEEMS THAT THIS IS OBSOLETE!!!!!!!!!!!!!!!!!!!!!
;*************************************************


pro read_coh_ascii


  command_line_args()
  p1 = args[0]
  p2 = args[1]


  ;; p1 = 'K'
  ;; p2 = 'L'

;  path = '~/Desktop/code/Aaron/RBSP/efw_barrel_coherence_analysis/'
  path = '~/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/barrel_missionwide/'
  fn = 'barrel_'+p1+p2+'_coherence_fullmission.txt'


  openr,lun,path+fn,/get_lun
  jnk = ''
  readf,lun,jnk
  freqs = 0.
  times = 0d


  j=0
  while not eof(lun) do begin
     readf,lun,jnk
     if strmid(jnk,0,9) ne 'Following' then begin
        freqs = [freqs,jnk]
        j++
     endif else break
  endwhile

  freqs = freqs[1:n_elements(freqs)-1]

  while not eof(lun) do begin
     readf,lun,jnk
     if strmid(jnk,0,9) ne 'Following' then begin
        times = [times,jnk]
        j++
     endif else break
  endwhile

  times = times[1:n_elements(times)-1]

  coh = 0.


  while not eof(lun) do begin
     readf,lun,jnk
     if strmid(jnk,0,9) ne 'Following' then begin
        coh = [coh,jnk]
        j++
     endif else break
  endwhile


  ntimes = n_elements(times)
  nfreqs = n_elements(freqs)

  coh2 = fltarr(ntimes, nfreqs)


stop
  for j=0L,ntimes-1 do coh2[j,*] = coh[j*nfreqs : (j+1)*nfreqs-1]


  store_data,'coh',data={x:times,y:coh2,v:freqs}
  options,'coh','spec',1
  ylim,'coh',0,0.01,0
  tplot,'coh'




end
