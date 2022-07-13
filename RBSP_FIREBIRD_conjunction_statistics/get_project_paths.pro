;Returns file paths for the FIREBIRD/RBSP conjunction statistics project


function get_project_paths

  root = '~/Desktop/code/Aaron/github/research_projects/RBSP_FIREBIRD_conjunction_statistics/'

  paths = {root:root,$
           Shumko_conjunctions:root+'conjunction_lists/Shumko/',$
           Shumko_microburst_detection:root+'Shumko_microburst_detection/',$
           Breneman_conjunctions:root+'conjunction_lists/Breneman/',$
           immediate_conjunction_values:root+'immediate_conjunction_values/',$
           extended_conjunction_values:root+'extended_conjunction_values/',$
           immediate_conjunction_microbursts:root+'immediate_conjunction_microbursts/'}


  return,paths

end

