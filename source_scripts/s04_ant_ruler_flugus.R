# this script contains: 
# 1. ANT-RULER to measure mean ant (workers) size in pixel and mm 

### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###
#### 1. ANT RULER  #### 
### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###

#### INFORMATION ####
# create a list with all the tracking files for which a measurement is needed and run the loop to create a text file containing mean worker size in pixel and mm
# pixcel size is then used for data extrapolation and if I remember correctly also auto-orientation 
# Fort myrmidon and DATADIR should already be loaded/defined

#### ANT-RULER ####

files <- list.files(DATADIR, pattern = "ManuallyOriented.myrmidon", full.names = TRUE) # if necessary adjust this input list. 
total_files <- length(files)
output_name <- paste0(DATADIR, "/Mean_ant_length_flugus_", format(Sys.time(), "%Y%m%d"), ".txt" )
for (i in 1:total_files) { # i <- 2
  file <- files[i]
  percentage <- (i/total_files)*100
  cat(blue("\r", sprintf("Processing: %3.1f%% (%d/%d) - %s", percentage, i, total_files, file)))
  flush.console()  # Ensure the output is displayed immediately
  ant_measurements <- NULL # 
  tracking_data <- fmExperimentOpen(file) 
  ants <- tracking_data$ants
  for (ant in ants){ # ant <- ants[[1]]  ant <- ants[[33]]  # for each ant excluding the queenget the mean size and put it in a dataframe
    if (length(ant$identifications) == 0) {next} else { # security skip if an ant ID has been deleted (e.g because it was just a fallen off tag)
    if (ant$identifications[[1]]$tagValue == 0) {next} else {# exclude queen  - if you did not use queen tag 0x000 then you need to either manually identify queens in advance or use the old verions of the ant ruler (in vital experiment) which removes the queen as a size outlier
    ant_length_px <- mean(fmQueryComputeMeasurementFor(tracking_data,antID=ant$ID)$length_px)
    ant_length_mm <- mean(fmQueryComputeMeasurementFor(tracking_data,antID=ant$ID)$length_mm)
    ant_measurements <- rbind(ant_measurements, data.frame(length_px = ant_length_px,
                                                           length_mm = ant_length_mm,
                                                           stringsAsFactors = F))
      }
    }
  }
  mean_length_px <- mean(ant_measurements$length_px, na.rm=TRUE)
  mean_length_mm <- mean(ant_measurements$length_mm, na.rm=TRUE)
  table <- NULL
  table <- rbind(table, data.frame("[pixels]" = mean_length_px,
                                   "[mm]" = mean_length_mm,
                                   "file" = file, 
                                   stringsAsFactors = FALSE))
  if (file.exists(output_name)){
    write.table(table, file = output_name, append = TRUE, col.names = FALSE, row.names = FALSE, quote = TRUE, sep = ",")
  } else {
    write.table(table, file = output_name, append = FALSE, col.names = TRUE, row.names = FALSE, quote = TRUE, sep = ",")
  }
}
cat("\n All Done! \n")


