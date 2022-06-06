# ar66b-plot-underway-data
Matlab scripts for plotting underway temperature, salinity and fluorescence in near-real time from the ARYYMMDD_0000.csv files located in the '\\10.100.100.30\data_on_memory\underway\proc\' repository during the cruise. 
Also included a Matlab script to plot on a map the ship track and the sampled station using the m_map toolbox (Pawlowicz, R., 2020. "M_Map: A mapping package for MATLAB", version 1.4m, [Computer software], available online at www.eoas.ubc.ca/~rich/map.html.) from the same near-real time data during the cruise.

**plot_underway.m:**
subplots of temperature/salinity/fluorescence vs. latitude and time during along the whole transect and during the whole cruise.

**plot_underway_zoom_front.m**
subplots of temperature/salinity vs. latitude zooming on the southern part of the transect around the shelf-break front.

**map_TSG_bathy_AR66.m**
map of the ship track with the bathymetrie of the study area (Hi-Res bathymetry in Bathy_zoom.mat file) using the m_map toolbox.
maps of underway temperature/salinity/fluorescence in near-real time. Note the use cmocean colormap (Thyng, K. M., Greene, C. A., Hetland, R. D., Zimmerle, H. M., & DiMarco, S. F. (2016). True colors of oceanography. Oceanography, 29(3), 10. link: http://tos.org/oceanography/assets/docs/29-3_thyng.pdf)
