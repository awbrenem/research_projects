from datetime import datetime
import pathlib
import re

import numpy as np
import pandas as pd
import sampex
import load_sampex_modified_attitude
import matplotlib.pyplot as plt
import matplotlib.colors

from spi_precipitation_maps.bin_data import Bin_Data
from spi_precipitation_maps.dial import Dial



class Bin_SAMPEX_HILT:
    """
    Bins the state 4 HILT data between 1997 and 2012.

    If you have the SAMPEX-HILT data downloaded already, check that the
    sampex.config['data_dir'] points to that directory. Run 
    `python3 -m sampex init` in the command line to change that directory.
    """
    def __init__(self,) -> None:
        self._get_dates()
        return

    def __iter__(self):
        """
        The special method called by the Bin_Data class.
        """

        current_year = '0'

        for date in self.dates:
            print(f'Processing SAMPEX-HILT on {date.date()}')
            self.hilt = sampex.HILT(date).load()

            """
            #SHUMKO ORIGINAL METHOD USING SAMPEX'S BUILT-IN ATTITUDE FILES
            try:
                self.attitude = sampex.Attitude(date).load()
            except ValueError as err:
                # Sometimes there is HILT data without corresponding attitude data.
                if 'A matched file not found in' in str(err):
                    continue
                else:
                    raise
            """

            
            #BRENEMAN MODIFICATION USING SAM'S ATTITUDE DATA 
            #**I've tested this against Mike's original version which loads the basic 
            #SAMPEX data files and the results are identical

            #Load an entire year's worth of Sam's attitude data when necessary. Then, merge_asof can be used to select only
            #the appropriate attitude needed for a single day. 
            if str(date.date().year) != current_year:
                try:

                    current_year = str(date.date().year)
                    self.attitude = load_sampex_modified_attitude.Attitude(current_year).load()
                           
                except ValueError as err:
                    # Sometimes there is HILT data without corresponding attitude data.
                    if 'A matched file not found in' in str(err):
                        continue
                    else:
                        raise


            try:
                merged_df = pd.merge_asof(self.hilt, self.attitude, left_index=True, 
                    right_index=True, tolerance=pd.Timedelta(seconds=3), 
                    direction='nearest')
                
                #Eliminate data based on storm flag
#                merged_df = merged_df.loc[merged_df['StormPhase'].isin(['Main','ERecovery','MRecovery','LRecovery'])]
                #merged_df = merged_df.loc[merged_df['StormPhase'].isin(['Main'])]

                #Eliminate based on DLC and BLC %. This eliminates the dominant trapped population
#                merged_df = merged_df.loc[(merged_df['LC2Perc'] > 99) & (merged_df['DLCPerc'] > 99)]



#tst = np.where(merged_df.LC2Perc != 100)
#                fig, axs = plt.subplots(3)
#                axs[0].plot(merged_df.counts,'.')
#                axs[1].plot(merged_df.DLCPerc,'.')
#                axs[2].plot(merged_df.LC2Perc,'.')
                #for i in range(len(axs)):
                #    axs[i].xlim()

            except ValueError as err:
                if 'keys must be sorted' in str(err):
                    continue
                else:
                    raise
            yield merged_df

    def __len__(self):
        """
        How many days to process. It is called by progressbar.
        """
        return len(self.dates)

    def _get_dates(self):
        """
        Finds the SAMPEX files and converts the filenames into dates.
        """
        # Look for local SAMPEX files.
        file_name_glob = f"hhrr*"
        self.hilt_paths = sorted(
            pathlib.Path(sampex.config['data_dir']).rglob(file_name_glob))
        if len(self.hilt_paths):

            date_strs = [re.findall(r"\d+", str(f.name))[0] for f in self.hilt_paths]
            self.dates = [sampex.load.yeardoy2date(date_str) for date_str in date_strs]
        else:
            # Otherwise get the list of filenames online.
            downloader = sampex.Downloader(
                'https://izw1.caltech.edu/sampex/DataCenter/DATA/HILThires/State4/'
                )
            downloaders = downloader.ls(file_name_glob)
            assert len(downloaders), f'{len(downloaders)} HILT files found at {downloader.url}'

            date_strs = [re.findall(r"\d+", str(d.name()))[0] for d in downloaders]
            self.dates = [sampex.load.yeardoy2date(date_str) for date_str in date_strs]
        #self.dates = [date for date in self.dates if date > datetime(1997, 1, 1)]
        #self.dates = [date for date in self.dates if (date > datetime(1998, 1, 1)) and (date < datetime(1998, 1, 12))]
        self.dates = [date for date in self.dates if (date > datetime(1998, 3, 9)) and (date < datetime(1998, 3, 25))]
        return self.dates

if __name__ == '__main__':
    L_bins = np.arange(2, 11)
    MLT_bins = np.arange(0, 24.1)

    m = Bin_Data(L_bins, MLT_bins, 'L_Shell', 'MLT', 'counts', Bin_SAMPEX_HILT)
    try:
        #Aaron's Note: Data are loaded and then binned for each single day in a loop. This means that I need to 
        #apply flags after data load.
        m.bin()
    finally:
        m.save_map('sampex_hilt_l_mlt_map.csv')
        # _, ax = plt.subplots(2, 1, sharex=True)
        fig = plt.figure(figsize=(9, 4))
        ax = [plt.subplot(1, 2, i, projection='polar') for i in range(1, 3)]

        L_labels = [2,4,6]
        cmap = 'viridis'

        dial1 = Dial(ax[0], MLT_bins, L_bins, m.mean)
        dial1.draw_dial(L_labels=L_labels,
            mesh_kwargs={'norm':matplotlib.colors.LogNorm(), 'cmap':cmap},
            colorbar_kwargs={'label':'mean > 1 MeV counts', 'pad':0.1})
        dial2 = Dial(ax[1], MLT_bins, L_bins, m.mean_sampes)
        dial2.draw_dial(L_labels=L_labels,
            mesh_kwargs={'norm':matplotlib.colors.LogNorm(), 'cmap':cmap},
            colorbar_kwargs={'label':'Number of samples', 'pad':0.1})
        """
        #Simplified version of the above removing 'label' kwarg
        dial1 = Dial(ax[0], MLT_bins, L_bins, m.mean)
        dial1.draw_dial(L_labels=L_labels,
            mesh_kwargs={'norm':matplotlib.colors.LogNorm(), 'cmap':cmap},
            colorbar_kwargs={'pad':0.1})
        dial2 = Dial(ax[1], MLT_bins, L_bins, m.mean_sampes)
        dial2.draw_dial(L_labels=L_labels,
            mesh_kwargs={'norm':matplotlib.colors.LogNorm(), 'cmap':cmap},
            colorbar_kwargs={'pad':0.1})
        """


        for ax_i in ax:
            ax_i.set_rlabel_position(235)
            ax_i.tick_params(axis='y', colors='white')

        plt.suptitle(f'SAMPEX-HILT | L-MLT map')
        plt.tight_layout()
        plt.show()