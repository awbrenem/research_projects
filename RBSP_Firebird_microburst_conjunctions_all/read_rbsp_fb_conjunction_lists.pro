;Read the files containing conjunction info that are output from master_conjunction_list_part3.pro  
;e.g either: 
;RBSP?_fb?_conjunction_values.txt
;RBSP?_fb?_conjunction_values_hr.txt
;at 
;github/research_projects/RBSP_Firebird_microburst_conjunctions_all/RBSP_FB_final_conjunction_lists/
;


function read_rbsp_fb_conjunction_lists, rbspname, fbname, hires=hr


path = '~/Desktop/code/Aaron/github/research_projects/RBSP_Firebird_microburst_conjunctions_all/RBSP_FB_final_conjunction_lists/'
if keyword_set(hr) then fn = 'RBSP'+rbspname+'_'+'FU'+fbname+'_conjunction_values_hr.txt' else fn = 'RBSP'+rbspname+'_'+'FU'+fbname+'_conjunction_values.txt'

openr,lun,path+fn,/get_lun 

jnk = ''
for i=0,48 do readf,lun,jnk 

header = jnk 
vals = []
;Read the rest of the file 
while not eof(lun) do begin
  readf,lun,jnk
  vals = [vals,jnk]
endwhile
close,lun
free_lun,lun
  
   
nconj = n_elements(vals)


tstart = []
tend = []
tmin = []
Lrb = []
Lfb = []
MLTrb = []
MLTfb = []
distmin = []
dLmin = []
dMLTmin = []
colS = []
surS = []
colHR = []
surHR = []
FBb = []
EMFb = []
B1b = []
B2b = []
;SpecETot_lf         SpecEMax_lf         SpecEAvg_lf         SpecEMed_lf                SpecETot_lb             SpecEMax_lb       SpecEAvg_lb           SpecEMed_lb            SpecETot_ub           SpecEMax_ub            SpecEAvg_ub         SpecEMed_ub           SpecBTot_lf         SpecBMax_lf         SpecBAvg_lf         SpecBMed_lf                SpecBTot_lb             SpecBMax_lb     SpecBAvg_lb            SpecBMed_lb             SpecBTot_ub              SpecBMax_ub        SpecBAvg_ub        SpecBMed_ub    7E3   7E4     7E5     7E6    7B3   7B4      7B5     7B6    13E6   13E7    13E8    13E9    13E10   13E11    13E12   13B6    13B7   13B8    13B9    13B10   13B11   13B12


for i=0,n_elements(vals)-1 do begin
  vtmp = strsplit(vals[i],' ',/extract)
  tstart = [tstart,vtmp[0]]
  tend = [tend,vtmp[1]]
endfor

rvals = {nconj:nconj,tstart:tstart,tend:tend}

return,rvals


end