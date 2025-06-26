
### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###
#### Meta data generation and zone cloning  #### 
### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###

#### 1. Information ####
#' automatically generate the metadata keys
#' automatically clone the zones that have been predefined in a single file to all files


#' Needs to be sourced from the main script which contains the information for:
#' DATADIR
#' colony_metadata


# file.remove(status_file) 
# DATADIR <- paste(DATADIR, "TEST_DATA_COPY", sep = "/")
# setwd(DATADIR)

#### 2. get the file list and the source file ####
#select the source file that contains the zones
source_file_zones  <- paste(DATADIR,"/zone_source.myrmidon",sep="")
# create a file list with all files to be modified
dest_files <- list.files(path=DATADIR, pattern="_main.myrmidon",full.names=T, recursive = F)


#### 3. Extract zones ####
# extract zone information from source file
zoned <- fmExperimentOpen(source_file_zones) 
zone_list <- list()
for (space in zoned$spaces){
  zone_list <- c(zone_list,space$zones)
}

# get information for each zone 
for (zone in zone_list){
  ID   <- zone$ID 
  name <- zone$name
  start <- zone$definitions[[1]]$start
  end   <- zone$definitions[[1]]$end
  shapes <- zone$definitions[[1]]$shapes
}


#### 4. Clone zones and add metadata keys ####
# clone the zones into their destination files.
cat(yellow("Processing: \n"))
for (unzoned_file in dest_files){ # unzoned_file <- dest_files[2]
  cat(unzoned_file, "\n")
  fort_exp <- fmExperimentOpen(unzoned_file) # open destination myrmidon file  
  for (space in fort_exp$spaces){# check that there are no zones, or delete existing zones 
    if (length(space$zones)>0){
      for (zone in space$zones){
        space$deleteZone(zone$ID)
      }
    }
  }
  for (space in fort_exp$spaces){ #duplicate the desired zones 
    for (zone in zone_list){
      space$createZone(zone$name) # create zone
      new_zone <- space$zones[[length(space$zones)]] # load new zone into object
      new_zone$addDefinition(zone$definitions[[1]]$shapes ,   zone$definitions[[1]]$start , zone$definitions[[1]]$end )# add zone definitions
    }
  }
  # fort_data$spaces[[1]]$createZone(name = "nest") # create zones to be defined manually in the fort files 
  # fort_data$spaces[[1]]$createZone(name = "arena")
  # fort_data$spaces[[1]]$createZone(name = "water_left")
  # fort_data$spaces[[1]]$createZone(name = "sugar_right")
  # replaced by the cloning
  fort_exp$setMetaDataKey(key = "meta_ID",     default_Value = 001)  # create the key variables you want as metadata in your data sets 
  fort_exp$setMetaDataKey(key = "IsQueen",     default_Value = FALSE)
  fort_exp$setMetaDataKey(key = "IsTreated",   default_Value = FALSE)
  fort_exp$setMetaDataKey(key = "IsAlive",     default_Value = TRUE)
  fort_exp$setMetaDataKey(key = "comment",     default_Value = "NA")
  fort_exp$setMetaDataKey(key = "tag_reoriented", default_Value = FALSE)
  for (y in 1:length(fort_exp$ants)) {
    fort_exp$ants[[y]]$setValue(key="meta_ID", value = c(fort_exp$ants[[y]]$identifications[[1]]$targetAntID), time = fmTimeSinceEver())
  }
  
  ### update the metadata key of treated ants
  treatment_data <- fmExperimentOpen(sub("main", "treatment", unzoned_file))     # create vector of the treated ants (separately recorded, separate myrmidon file)
  treated_ants <- treatment_data$ants
  tag_value_vector <- NULL
  tag_values <- NULL
  for (z in treated_ants) { #go through every ant of the separately recorded individuals
    tag_values <- z$identifications[[1]]$tagValue #extract tag value
    tag_value_vector <- rbind(tag_value_vector, data.frame(tag_values))
  }
  ants <- fort_exp$ants  # for each ant adjust the meta data if it is the queen or a treated worker
  for (x in ants) { # x <- ants[[1]]  x$identifications[[1]]$tagValue
    if (x$identifications[[1]]$tagValue==0) {
      x$setValue("IsQueen", TRUE, time = fmTimeSinceEver())}
    if(is.element(x$identifications[[1]]$tagValue, as.matrix(tag_value_vector))) {
      x$setValue(key="IsTreated", value = TRUE, time = fmTimeSinceEver())}
  }
  
  
  fort_exp$save(paste0((DATADIR), "/", basename(unzoned_file))) 
  rm(list=c("fort_exp", "treatment_data"))
}


# To update: Include the information on treated ants:



#### TO DO: CHeck if treated ants have been assigned isTreated correctly!



