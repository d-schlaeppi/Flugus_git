

### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###
### Flugus: COLONY meta data ###
### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###
#### READ ME ####

# Script to read in the colony meta data from the flugus tracking experiment to be accessed in other scripts
# loads a data from called colony_metadata holding a variety of basic information for each colony

# to load the data frame in another script just run the following line 
# source(paste0(SOURCEDIR,"colony_metadata_flugus.R"))

cat(red("Warning: dataframe not defined yet", "\n"))




#from VITAL: 
# dat <- read.csv(paste0(SCRIPTDIR,"/fc2_overview_data.csv"), header = TRUE, stringsAsFactors = F)
# colony_metadata <- NULL
# for(i in 1:nrow(dat)) {
#   # collect variables
#   nr                    <- i
#   experiment            <- dat[i, "experiment"] 
#   colony_id             <- dat[i, "colony_id"]
#   block                 <- dat[i, "block"]
#   colony_nr             <- paste0("c", sprintf("%02d", i))
#   treatment             <- dat[i, "treatment"]
#   treatment_simple      <- ifelse((dat[i, "treatment"] == "cb"|dat[i, "treatment"] == "cy"), "control", "virus")
#   food_position_1       <- dat[i, "food_position_1"]
#   food_position_2       <- dat[i, "food_position_2"]
#   tracking_system_main  <- dat[i, "tracking_system_main"]
#   tracking_system_feeding <- dat[i, "tracking_system_feeding"]
#   time_treatment_start  <- dat[i, "treatment_starting_time"]
#   time_treatment_end    <- dat[i, "treatment_end_time"]
#   annotation_start      <- dat[i, "annotation_start_time"] 
#   annotation_stop       <- dat[i, "annotation_stop_time"]
#   mean_ant_lenght_px    <- dat[i, "mean_ant_length_px"] # mean lenght in pixcel of the ants based on a manually oriented colony recorded with the same tracking system & setup (assuming that worker size is consistent accros colonies)
#   mean_ant_lenght_mm    <- dat[i, "mean_ant_length_mm"] # for the future: it might be better to calculate an overall mean ant size per experiment (assuming that all ants come from the same batch of colonies) else if in one tracking system a colony with smaller ants is used for manual orientation it might create downstream effects
#   fluorescence_measured    <- dat[i, "fluorescence_measured"]
#   colony_metadata <-  rbind(colony_metadata, data.frame            (nr,
#                                                         experiment, 
#                                                         colony_id,
#                                                         block, 
#                                                         colony_nr,
#                                                         treatment,
#                                                         treatment_simple,
#                                                         food_position_1,
#                                                         food_position_2,
#                                                         tracking_system_main,
#                                                         tracking_system_feeding,
#                                                         time_treatment_start,
#                                                         time_treatment_end,
#                                                         annotation_start, 
#                                                         annotation_stop,
#                                                         mean_ant_lenght_px,
#                                                         mean_ant_lenght_mm,
#                                                         fluorescence_measured,
#                                                         stringsAsFactors = F))
# }
# metadata_colonies <- colony_metadata

