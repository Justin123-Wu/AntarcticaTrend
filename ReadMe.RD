1. Folder structure
 When checked out, you will see the following folder tree.
 AntarcticaTrend/doc/                    % the documnet folder
                 src/                    % the code folder
                 data/                   % the data folder
                     /raw                % the raw data folder
                     /processed          % the folder holding processed data by out code

2. download data 
   a) https://www.ncei.noaa.gov/data/integrated-global-radiosonde-archive/access/data-por/
   b) Once download, you need to put them in the folder:
      AntarcticaTrend/data/raw/
                          AYM00089009-data.tx
                          AYM00089062-data.txt
                          AYM00089002-data.txt
                          AYM00089532-data.txt
                          AYM00089664-data.txt
                          AYM00089571-data.txt
                          AYM00089611-data.txt
3.How to run it
  3.1 Create monthly observation and monthly-profile run:
       test_creatMonthlyProfile.m 
  3.2 Debugging and visualizing results run:   
      test_plotMonthlyObservations.m
      test_plotMonthlyProfile.m
  3.3 Compute monthly statistics and  trend:
      test_monthlyStatisticsAndTrend.m
  3.4 Compute seasonal statistics and  trend:
      test_seasonalStatisticsAndTrend.m
  3.5 Learn how to auto save png, trenddecomp(), and chadGreeneTrend() run:
      test_chadGreeneTrend.m
      test_trendDeComp.m 
      test_plot_num_observations_per_month.m
      test_learn_plot_print_png.m

4. Slides and references
     doc/-Antarctic-Boundary-Layer-Study-slides.pdf

---------- eof -------------
