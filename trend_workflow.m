% robust regression trend processing work flow in matlab

%load data
shrub_trend_import

%fix 2001 Landsat data drop
fix01

%find all multi-trends in dataset
shrub_multitrend_calc

%visualize trend lines
imagesc(numtrends)

%visualize the total number of fires
imagesc(totfires)

%visualize one pixel's trend line(s)
vistrends_example

