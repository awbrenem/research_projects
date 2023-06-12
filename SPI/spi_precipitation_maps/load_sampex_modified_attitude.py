# This is a modification of Mike Shumko's load.py (part of his SAMPEX package) 
# that loads Sam Walton's modified SAMPEX attitude files. These have the same data as the official attitude files but also contain extra stuff.


#from typing import Union
import pathlib
import zipfile
import re
import dateutil.parser
from datetime import datetime, date
#import warnings

import pandas as pd
import numpy as np




#import sampex

class Attitude:
    """ 
    Load a SAMEX attitude file that contains the desired day and convert 
    the date and time to ``pd.Timestamp``. You need to explicitly call 
    the ``.load()`` method to load the file into memory.

    Once loaded, you can access the timestamps with Attitude['time']
    You can access the other variables similarly. Alternatively, the 
    Attitude.data attribute is a pd.DataFrame containing both the 
    timestamps and attitude variables.

    Parameters
    ----------
    load_year: datetime.datetime, pd.Timestamp
        The year of data to load
    verbose: bool
        If True, will notify you when data is loaded. This is useful when
        loading a lot of data and the computer seems unresponsive.

    Notes
    -----
    Attitude files span multiple days.

    Longitudes are transformed from (0 -> 360) to (-180 -> 180).
    

    Example
    -------
    | from datetime import datetime
    | 
    | import matplotlib.pyplot as plt
    | 
    | import sampex
    | 
    | day = datetime(2007, 1, 20)
    | 
    | a = sampex.Attitude(day)
    | a.load()
    | 
    | fig, ax = plt.subplots()
    | ax.step(a['time'], a['Altitude'], label='SAMPEX Altitude', where='post')
    | plt.suptitle(f'SAMPEX Altitude | {day.date()}')
    | plt.show()
    """

    def __init__(self, load_year, verbose=False):

        self.load_year = load_year
        self.load_year_str = load_year
        self.verbose = verbose

        # Find the appropriate attitude file.
        self._find_attitude_file()
        return

    def load(self, columns="default", remove_old_time_cols=True):
        """ 
        Loads the attitude file. Only columns specified in the columns arg are 
        loaded to conserve memory.

        Notes
        -----
        The other than ``time``, the loaded columns are: GEO_Radius, GEO_Long, 
        GEO_Lat, Altitude, L_Shell, MLT, Mirror_Alt, Pitch, and Att_Flag

        Longitudes are transformed from (0 -> 360) to (-180 -> 180).
        """
        if self.verbose:
            print(
                f"Loading SAMPEX attitude data on {self.load_year.date()} from"
                f" {self.attitude_file.name}"
            )
        # A default set of hard-coded list of columns to load
        if columns == "default":
            columns = {
                1: "Year",					# Year
                2: "DoY",				    # Day of the Year (i.e. 1-365)
                3: "SoD",					# Second of the Day (i.e. 1-86400)
                #4: "OrbitNo",				# Orbits since the start of the mission 
                #5: "ELO",					# The PET/ELO channel
                #6: "EHI",					# PET/EHI channel
                7: "GEOr",					# GEO coordinates - radius from centre of Earth
                8: "GEOlong",				# GEO longitude
                9: "GEOlat",				# GEO latitude
                10: "Alt",					# Spacecraft Altitude
                11: "L",					# IGRF L-shell
                12: "B",					# IGRF Local B value (Gauss)
                13: "MLT",					# MLT
                14: "InvLat",				# Latitude of the current field line at the Earth’s surface
                15: "Mlat",					# MLAT at the location of the spacecraft
                16: "LC1",					# IGRF BLC in the current hemisphere
                17: "LC2",					# IGRF BLC in either hemisphere
                18: "SAA",					# South Atlantic Anomaly Flag (0 or 1; 1 being in SAA)
                19: "PA",					# Pointing direction of the centre of the PET detective, in degrees from the IGRF field line
                20: "Att_Flag",				# contains various attitude flags - see:  https://izw1.caltech.edu/sampex/DataCenter/docs/sampex_psset.html
                21: "T05",					# T05 L-star values, calculated for 90 degrees pitch angle
                22: "BLC",					# calculation of BLC for a dipole field (not recommended)
                23: "B100_N",				# Value of B (gauss) at 100 km on the current field line (northern hemisphere)
                24: "B100_S",				# Value of B (gauss) at 100 km on the current field line (southern hemisphere)
                25: "B100min",				# Value of B (gauss) at 100 km on the current field line (either hemisphere)
                26: "DLC",					# my estimate of the DLC (probably needs improving with a drift-shell calculation
                27: "LC2Perc",				# percentage of the 58 degree detector taken by the BLC
                28: "DLCPerc",				# percentage of the 58 degree detector taken by the DLC
                29: "StormPhase",			# Storm phase, from the Walach and Grocott (2019) list
                30: "StormNumber",			# Storm number (in chronological order) from the Walach and Grocott (2019) list.
                31: "B100Dmin"}                      	# minimum 100km B for entire drift shell d - estimated based on the dataset average - needs improving with better drift shell calculation

        """
           columns = {
                0: "Year",
                1: "Day-of-year",
                2: "Sec_of_day",
                6: "GEO_Radius",
                7: "GEO_Long",
                8: "GEO_Lat",
                9: "Altitude",
                20: "L_Shell",
                22: "MLT",
                42: "Mirror_Alt",
                68: "Pitch",
                71: "Att_Flag",
            }
        """ 

        self.data = pd.read_csv(
            self.attitude_file, names=columns.values(), usecols=columns.keys(),skiprows=1
        )
        
        # Change format of Year and doy to datetimes 
        self._parse_attitude_datetime(remove_old_time_cols)
        # Transform the longitudes from (0 -> 360) to (-180 -> 180).
        self.data["GEOlong"] = np.mod(self.data["GEOlong"] + 180, 360) - 180

        #Rename some of the columns to be consistent with the official SAMPEX
        #attitude since this is what Mike Shumko's code uses. 
        self.data.rename(columns={"GEOr":"GEO_Radius", "GEOlong":"GEO_Long", 
                                  "GEOlat":"GEO_Lat", "Alt":"Altitude", "L":"L_Shell",
                                  "PA":"Pitch"}, inplace=True)

        return self.data

    def __getitem__(self, _slice):
        """
        Allows you to access data via, for example, Attitude['time'].
        """
        if isinstance(_slice, str):
            if "time" in _slice.lower():
                return self.data.index
            else:
                for column in self.data.columns:
                    if _slice.lower() in column.lower():
                        return self.data[column].to_numpy()
                raise KeyError(
                    f"{_slice} is an invalid column: Valid columns are: "
                    f"{self.data.columns.to_numpy()} "
                )
        else:
            raise KeyError(f"Slices other than 'time' or "
                f"{self.data.columns.to_numpy()} are unsupported")

    def _find_attitude_file(self):
        """ 
        Use pathlib.rglob to find the attitude file that contains 
        the DOY from self.load_year
        """
        self.file_match = self.load_year + ".txt"
        self.attitude_file = self._find_local_file()

        if self.attitude_file is None: # At this stage we have not found a file.
            raise FileNotFoundError
        return self.attitude_file

    def _find_local_file(self):
        """
        Look for a file on the local computer
        """
        
        attitude_files = sorted(
            list(pathlib.Path("/Users/abrenema/data/SAMPEX/").rglob(self.file_match)) 
       )

        self.attitude_file = attitude_files[0]
        
    
        return self.attitude_file



    def _skip_header(self, f):
        """ 
        Read in the "f" attitude file stream line by line until the 
        "BEGIN DATA" line is reached. Then return the row index to the
        names from the parsed header.
        """
        for i, line in enumerate(f):
            if "BEGIN DATA" in str(line):
                # because for some reason the first attitude row has
                # an extra column so skip the first "normal" row.
                next(f)
                return
        return None

    def _parse_attitude_datetime(self, remove_old_time_cols):
        """
        Parse the attitude year, DOY, and second of day columns 
        into datetime objects. 
        """
        # Parse the dates by first making YYYY-DOY strings.
        year_doy = [f"{int(year)}-{int(doy)}" for year, doy in self.data[["Year", "DoY"]].values]
        # Convert to date objects
        attitude_dates = pd.to_datetime(year_doy, format="%Y-%j")
        # Now add the seconds of day to complete the date and time.
        self.data.index = attitude_dates + pd.to_timedelta(self.data["SoD"], unit="s")
        # Optionally remove duplicate columns to conserve memory.
        if remove_old_time_cols:
            self.data.drop(["Year", "DoY", "SoD"], axis=1, inplace=True)
        return


def date2yeardoy(day):
    """
    Converts a date into the "YYYYDOY" string format used extensively 
    for the SAMPEX file names.

    Parameters
    ----------
    day: str, datetime.datetime, pd.Timestamp
         A date.

    Returns
    -------
    str
        The corresponding YYYDOY string.
    """
    if isinstance(day, str):
        day = pd.to_datetime(day)

    # Figure out how to calculate the day of year (DOY)
    if isinstance(day, pd.Timestamp):
        doy = str(day.dayofyear).zfill(3)
    elif isinstance(day, (datetime, date)):
        doy = str(day.timetuple().tm_yday).zfill(3)
    return f"{day.year}{doy}"


def yeardoy2date(yeardoy: str):
    """
    Converts a date in the (year day-of-year) format (YEARDOY)
    into a datetime.datetime object.

    Parameters
    ----------
    yeardoy: str
        The date in the YYYDOY format

    Returns
    -------
    datetime.datetime
        The corresponding datetime object 
    """
    return datetime.strptime(yeardoy, "%Y%j")


if __name__ == "__main__":
    import sampex
    import load_sampex_modified_attitude

    #day = datetime(1992, 10, 4)
    #a = sampex.Attitude(day)

    year = "1998"
    b = load_sampex_modified_attitude.Attitude(year)
    b.load()





    print("here")


    #b = load_sampex_modified_attitude.Attitude(current_year).load()

    #a.load()

