#Important steps in the process of creating the %-time FBK plots


#rbsp_survey_fbk_percenttime_create_ascii
	-load FBK data (CHECK CALIBRATIONS AGAINST OTHER INSTRUMENTS)
	-load EMFISIS 4-sec L3 GSE data (used for fce)
	-saves peaks and averages for all bins
	-saves peaks and averages for top 3(4) for FBK7(13)

#rbsp_survey_fbk_percenttime_read_ascii
	-no steps that can mess up data


#rbsp_survey_create_ephem_ascii (can majorly simplify this program)
	-calls rbsp_load_spice_kernels
	-calls rbsp_load_spice_state and gets data in GSE
	-gets AE and DST indices (also need Kp)
	-lat values based off of simple dipole model


#rbsp_survey_ephem_read_ascii
	-no steps that can mess up data


#rbsp_survey_fbk_return_grid
	-no steps that can mess up data


#rbsp_survey_fbk_percenttime_bin
	-arbitrary padding value above and below fce
	-calls rbsp_efw_fbk_freq_interpolate

#rbsp_survey_fbk_plot
	-no steps that can mess up data


#rbsp_efw_fbk_freq_interpolate
	-uses Malaspina's gain curves


#rbsp_efw_cal_fbk
	-calls rbsp_efw_get_cal_params
	-need to cross-calibrate the calibrations with other instruments



#rbsp_survey_vxb_create_ascii (NOT NECESSARY FOR FBK SURVEY STUFF)
	-need to add in corotational field correction


#rbsp_survey_vxb_read_ascii
	-load spice kernels
	-calls rbsp_load_spice_state


#----------------------------------------------------------------------------
#List important steps in the process of creating the %-time FBK plots

Since I can't save all the hires FBK data for every day during the entire survey
I take a day's worth of data and divide it into dt=60s chunks. This results in 1440
data points per day of various quantities (see below).


Process starts with rbsp_survey_driver.py.
	run.create_info_struct()
		Creates an IDL save file (info.idl) with structure info

	run.create_ephem_ascii -> Loop that creates ephemeris files for
		each day requested. These files are general (not specific to particular
		run) and so are stored in the survey_programs/ephem folder.

	run.ephem_combine_tplot ->

	run.create_fbk_ascii -> calls rbsp_survey_create_fbk_ascii.pro
		This creates a variety of FBK output files each day with a cadence of dt(=60s).
		The types of files are:
		"fbk"     -> e.g. "fbk13_RBSPa_fbk_Ew_20121012.txt"
						  "fbk13_RBSPa_fbk_Bw_20121012.txt"
					 Peak and average values each dt. Consists of the following:
					 peaks -> number of chorus (0.1-1*fce) peak values each dt
					 avgs -> number of chorus (0.1-1*fce) avg values each dt
					 peakv -> max pk FBK value each dt
					 avgv -> max avg FBK value each dt
					 fce
					 fce_eq
					 Bfield_GSE
					 spinaxis_direction_GSE
		"ampdist" -> e.g. "fbk13_RBSPa_ampdist_pk_Ew_20121012.txt"
					 histogram of counts each dt in 25 different amplitude bins.
					 Separate files for 0.1-1*fce, 0.1-0.2*fce, 0.2-0.3*fce....
					 The data from all of these allows me to plot a 2D histogram
					 of counts (z) for amplitude (y) vs f/fce (x).

					 The specific amplitude bins used are in files pk_bins.txt,
					 avg_bins.txt, ratio_bins.txt
		"freq"	   -> Histogram of counts of FBK values as a function of f/fce
					 f/fce bins used given in file freq_bins.txt (OBSOLETE??)
		"ratio"    -> Similar to "ampdist" but for ratio of pk/avg
		"ratio4sec" -> ratio of pk/avg downsampled to 4s to mimic THEMIS FBK data


	run.survey_combine_ascii -> a Python routine that grabs all of the daily
		files created from rbsp_survey_create_fbk_ascii.pro, from start to end date,
		and puts them in a single "combined" file.
		e.g. fbk13_RBSPa_ampdist_pk_Ew_20121012.txt and fbk13_RBSPa_ampdist_pk_Ew_20121013.txt
		would be combined into  fbk13_RBSPa_ampdist_pk_Ew_combined.txt


	run.fbk_combine_tplot() -> calls rbsp_survey_fbk_combine_tplot.pro
		This takes the fbk13_RBSPa_fbk_Ew_combined.txt file and creates a tplot
		variable which is then saved to an IDL save file

	run.fbk_combine_tplot_ampfreqdist('ampdist_pk') -> calls rbsp_survey_fbk_combine_tplot_ampfreqdist.pro
		This takes the fbk13_RBSPa_ampdist_pk_Ew_combined.txt file and creates a tplot
		variable which is then saved to an IDL save file
