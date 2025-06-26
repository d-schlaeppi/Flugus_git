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

#' Script written by Daniel Schläppi based on previous versions by:
#' Compatible with Myrmidon 0.8.3

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


#### prerequisites ####
rm(list = setdiff(ls(), "first_time_use_working_directory"))
# rm(list = ls())

if (!exists("first_time_use_working_directory") || first_time_use_working_directory == "") {
  standard <- "/media/ael/gismo_hd6/Flugus_git"
  selected_dir <- if (dir.exists(standard)) {standard} else {tcltk::tk_choose.dir(default = "~/", caption = "Select Working Directory")}
  if(is.null(selected_dir) || selected_dir == "") {cat("No directory selected. Exiting.\n")
    return()}
  setwd(selected_dir)
  first_time_use_working_directory <- getwd()
  setwd(first_time_use_working_directory)
  cat(crayon::blue(getwd()))
} else {setwd(first_time_use_working_directory)
  cat(crayon::blue(getwd()))}

experiment <- "flugus"
source("02_config_user_and_hd_flugus.R") # contains getUserOptions() that defines usr, hd and useful functions as well as your directories:

# # should now also work on windows and if not quickly define inputs manually:
# DATADIR <- "D:/gismo_hd6/data/CFG_extrapolated"
# SCRIPTDIR <- "D:/gismo_hd6/Flugus_git"
# SOURCEDIR <- "D:/gismo_hd6/Flugus_git/source_scripts"
#' DATADIR is the directory where your tracking data is saved
#' SCRIOTDIR is the home directory where your r scripts are stored
#' SOURCEDIR is a sub-directory of SCRIOPTDIR containing r scripts to source for the analysis  

source(paste(SOURCEDIR,"s01_colony_metadata_flugus.R", sep = "/" )) # load colony meta data 


# Define what analysis step to run: 
if(TRUE) { 
  run_s02 <- FALSE # s02_base_file_generator_flugus.R
  run_s04 <- FALSE # s04_ant_ruler_flugus.R
  run_s05 <- TRUE # meta data generator
}

#### 1. First Step ####
# Create base files and define ants for all files, then manually orient + measure one colony per tracking system:
# Then, For each tracking system setting used (typically 1 per tracking system), select one exemplary colony to get mean worker size with the ant_ruler script
# Use this information to do the data extrapolation

#### 1.1 Create base myrmidon files ####
if (run_s02) {source(paste(SOURCEDIR, "s02_base_file_generator_flugus.R", sep = "/"))}

# following the file generator manually add the tracking data to the files for which it did not work. 
# Those files are stored in manual_check_required - if you do not proceed this very moment save manual_check_required somewhere
# for the colonies needed then quickly run the s03_ant_generator.R script based on the colonies listed in manual_check_required

#### 1.2 Automatically generate the ants for the selected tracking files using the "ant_generator" ####
# is now incorporated in step 1 and no longer needed. 

#### 1.3 Manually orient files in fort myrmidon #### 
# For one colony per tracking system used in the experiment perform manual orientation. 
# This is required to get the mean ant size in pixels and mm which is used for extrapolation and auto-orientation of the remaining files
# still needs to be done manually... at least it is only one colony per tracking system / tracking system setting
# to follow the same formatting as used in the flugus script save the files as colonyid_main_ManuallyOriented.myrmidon e.g. c01_main_ManuallyOriented.myrmidon
# if you have no other files with ManuallyOriented in the filename the following script should run for you.


#### 1.4 Get the mean worker size per tracking system using the "ant_ruler“ ####
# source the standalone r-script called ant_ruler
if (run_s04) {source(paste(SOURCEDIR, "s04_ant_ruler_flugus.R", sep = "/"))}

#### 1.5 Data extrapolation ####
#' To correct short tag blinks (non detection) we run nathalies data extrapolation code 
#' In brief, it will identify moments where the tag was not detected for a very short moment and fill in the missing trajectories.
#' Done on the good computer. Requires two HDs with sufficent space the raw data and the file containing the mean worker size per tracking system.

#### 1.6 Add meta data keys and zones ####

#' For one example colony pre define the zoes in the nest:
#' Nest, Arena, Water, Sugar Water
#' Save it as zone_source.myrmidon

if (run_s05) {source(paste(SOURCEDIR, "s05_meta_generator.R", sep = "/"))}

#### 1.7 Ant Orient Express ####
# if (run_s06) {source(paste(SOURCEDIR, "s06_NAME ANT ORIENT EXPRESS.R", sep = "/"))}

#### 1.8 Manual post processing ####
# Done by Ana







#### TO DO NEXT ####
#' Check if all of the data is needed and for which files we can just get rid of the acclimatisation tracking period.
#' With only the right data rerun the base file creater and update it with Metadata keys and zones
#' Manual Post processing (old step 3.4)
#' Give Nathalie the Data for Data extrapolation 
#' 
#' Retagged ants
#' Add meta data : retagged, tag 1, tag 2
#' 
#' Run ant Orient express: 
#' 
#' #### 3.5 Ant Orient Express ####
# !!! To do: Needs to be updated slightly because there were some issues in Adrianos script in with the capsule assignment 
# See the capsule cloner for an updated version of the capsule assignment (using capsule number instead of capsule names. )
#' Get the right capsules: the 2018 capsule and the best grooming capsule
#' Run the grooming stuff
#' Continue with next analysis scripts.








