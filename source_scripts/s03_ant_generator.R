

### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###
#### 1. ANT Generator ####
### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###

#### INFORMATION ####
# ANT-GENERATOR to define ant indentifications in Fort
# create a list with all the tracking files for which a measurement is needed and run the loop to create the ants in the fort myrmidon files

#### PREREQUISITES ####
# asumes that FortMyrmidon, and directories have already been loaded in the data_preprocessing script (including the variable manual check required)
# if you are running this script as a standalone, do it manually

# # load required libraries
# library(FortMyrmidon) # R bindings
# directory <-  '/media/gw20248/gismo_hd5/trophy_data/' 
# setwd(directory)

# manual_check_required <- c("alleline_flugus_c24.0000")

extract_colony_id_from_manual_check_required <- function(filename) { # filename <- "alleline_flugus_c24.0000"
  colony_id <- substring(unlist(strsplit(filename, "_"))[3], 1,3)
}
colony_ids <- sapply(manual_check_required, extract_colony_id_from_manual_check_required)
pattern_to_include <- paste0("(", paste(colony_ids, collapse = "|"), ").*\\.myrmidon$")
myrmidon_files <- list.files(DATADIR, pattern = pattern_to_include, full.names = TRUE)

for (file in myrmidon_files) { # file <- myrmidon_files[1] 
  tracking_data <- fmExperimentOpen(file) # files that need the ants created
  tag_statistics <- fmQueryComputeTagStatistics(tracking_data)   # extract the tag statistics to know how many times each tag was detected etz
  ants <- tracking_data$ants
  if (length(ants) == 0) { # if ants have not been create yet - decide on the cutoff: stronger cut off to reduce the chances of false positives if too many false ants are created | tag_statistics[,"count"] 
  for ( i in 1:nrow(tag_statistics)) { 
    if ( tag_statistics[i,"count"] >= 0.01*max(tag_statistics[,"count"],na.rm=T) ) { # antID only if the tag detection rate was more than 1/100 (adriano used 1/1000) of the best tag detection rate
      a <- tracking_data$createAnt(); # creates an antID, i.e. associates a decimal antID number to that particular tagID
      identification <- tracking_data$addIdentification(a$ID,tag_statistics[i,"tagDecimalValue"],fmTimeSinceEver(),fmTimeForever())
      print(identification)
    }
  }
  tracking_data$save(file) # Save the file (consider making a new name filename_ants_created.myrmidon)
  }else {
    next  # skip to the next file if ants exist already
  }
}

