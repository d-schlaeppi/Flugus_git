#### vital  R script - all the steps ####

### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### 
### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###
###                                                                                                 ###
###   ### ### ### ###  ###          ###       ###  ### ### ### ###  ###       ###  ### ### ### ###  ###
###   ### ### ### ###  ###          ###       ###  ### ### ### ###  ###       ###  ### ### ### ###  ###
###   ###              ###          ###       ###  ###         ###  ###       ###  ###              ###
###   ###              ###          ###       ###  ###              ###       ###  ###              ###
###   ### ### ###      ###          ###       ###  ###              ###       ###  ### ### ### ###  ###
###   ### ### ###      ###          ###       ###  ###     ### ###  ###       ###  ### ### ### ###  ###
###   ###              ###          ###       ###  ###     ### ###  ###       ###              ###  ###
###   ###              ###          ###       ###  ###         ###  ###       ###              ###  ###
###   ###              ### ### ###    ###   ###    ### ### ### ###    ###   ###    ### ### ### ###  ###
###   ###              ### ### ###       ###       ### ### ### ###       ###       ### ### ### ###  ###
###                                                                                                 ###
### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### 
### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###


### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###
###                   CFG: Colony level FLU-pyradifurone fun-GUS interaction experiment                         ### ### ### ### ### 
### Script guiding through the first steps of the Analysis of tracking data for the Flugus tracking experiment  ### ### ### ### ###
### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###

#### Background information | Read me ####

# Useful information before starting the tracking experiment. 
# Tracking systems - don't change settings (camera height etc) throughout the experiment. Settings for one specific tracking system should stay the same to minimize manual orientation
# If you use separate systems for main tracking and treatment tracking: Don't mix them. Always the same tracking systems for main tracking and different systems for treatment tracking (Unless you can use exactly the same setup) 
# If you do short trackings (e.g. for treatments in addition to a main tracking increase the rate at which pictures are taken of each ant in the leto file)
# Use dedicated queen tags (0x000) if possible!

# Step by step processing of the tracking data for flugus:
# Step 1: For each tracking system setting the first colony is selected get the mean worker size (mm and pixcels used for data extrapolation and orientation of remaining colonies)
#   Step 1.1 Create base myrmidon files
#   Step 1.2 Automatically generate the ants for the selected tracking files using the "ant_generator"
#   Step 1.3 Manually orient files in fort myrmidon
#   Step 1.4 Get the mean worker size per tracking system using the "ant_ruler“

# Step 2: Run data extrapolation for all the data based on the mean body size in each tracking system (Nathalies script)

# Step 3: Use the extrapolated data for all the colonies do all the necessary post processing

# Step 3.1: Create all base myrmidon files
# Step 3.2: Generate all ants
# Step 3.3: Automatically create the metadata variables needed
# Step 3.4: Adjust replaced or re-glued tags and do required manual post processing
# Step 3.5: Automatically orient all ants in all extrapolated data using the ant_orient express (Includes capsule generation)
# Step 3.6: Post processing of queen meta data (Manual)

# Step 4 Data analyses
# Step 4.1 Define and apply different capsules to train the trophallaxis classifier
# Step 4.2 Train behaviour (Trophallaxis) classifier using Nathalies script ant computer
# Step 4.3 General data analyses i.e. Base Analysis and Next steps 


### ### ### ###  ###
### Useful links ###
### ### ### ###  ###

# for more information on fort-myrmidon and fort-studio see: 
# https://formicidae-tracker.github.io/myrmidon/latest/index.html

# Postprocessing tips
# https://uob.sharepoint.com/:w:/r/teams/grp-AntsEpidemiologyLab/_layouts/15/Doc.aspx?sourcedoc=%7B2562631B-A6E5-4289-907F-89502F6C27E6%7D&file=pre-processing_Adriano_June2022.docx&action=default&mobileredirect=true

# AEL Github repositories
# https://github.com/d-schlaeppi/vital_rscripts_git
# https://github.com/AdrianoWanderlingh/PhD-exp1-data-analysis/tree/main/scriptsR
# https://github.com/Leckie-Bris/SICC
# https://github.com/EnricoGavagnin?tab=repositories
# https://github.com/d-schlaeppi
# Add Linda

#### TODOS ####

# create a first version of the meta data for the flugus colonies

#### prerequisites ####
rm(list = setdiff(ls(), "first_time_use_working_directory"))
# rm(list = ls())

if (!exists("first_time_use_working_directory") || first_time_use_working_directory == "") {
  setwd(tcltk::tk_choose.dir(default = "~/", caption = "Select Working Directory"))
  first_time_use_working_directory <- getwd()
  setwd(first_time_use_working_directory)
  cat(crayon::blue(getwd()))
} else {setwd(first_time_use_working_directory)
  cat(crayon::blue(getwd()))}

source("02_config_user_and_hd_flugus.R") # contains getUserOptions() that defines usr, hd and useful functions as well as your directories:

# # should now also work on windows and if not quickly define inputs manually:
# DATADIR <- "D:/gismo_hd6/data/CFG"
# SCRIPTDIR <- "D:/gismo_hd6/Flugus_git"
# SOURCEDIR <- "D:/gismo_hd6/Flugus_git/source_scripts"

source(paste(SOURCEDIR,"s01_colony_metadata_flugus.R", sep = "/" )) # load colony meta data 

#### Step 1 ####
# Step 1: For each tracking system setting (typically 1 per tracking system) used select one exemplary colony get mean worker size
# Create base files and define ants for all files, then manually orient + measure one colony per tracking system

#### 1.1 Create base myrmidon files ####
source(paste(SOURCEDIR, "s02_base_file_generator_flugus.R", sep = "/"))
# following the file generator manually add the tracking data to the files for which it did not work. 
# stored in manual_check_required - if you do not proceed this very moment save manual_check_required somewhere
# for the colonies needed then quickly run the s03_ant_generator.R script based on manual_check_required

#### Step 1.2 Automatically generate the ants for the selected tracking files using the "ant_generator" ####
# is now incorporated in step 1 and no longer needed. 

#### 1.3 Manually orient files in fort myrmidon #### 
# For one colony per tracking system used in the experiment perform manual orientation. 
# This is required to get the mean ant size in pixels and mm which is used for extrapolation and auto-orientation of the remaining files
# still needs to be done manually... at least it is only one colony per tracking system / tracking system setting 

#### 1.4 Get the mean worker size per tracking system using the "ant_ruler“ ####









