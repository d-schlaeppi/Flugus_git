
### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###
#### Base File Generator  #### 
### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###

#### Information ####
# automatically generate the myrmidon base files for all tracking files
# Needs to be sourced from the main script which contains the information for:
# DATADIR
# colony_metadata

# get a list of all the myrmidon files in that folder:
data_list <- list.files(path=DATADIR, pattern=NULL, all.files=FALSE, full.name=FALSE) # all files
pattern_to_exclude <- "\\.myrmidon$|\\.txt$|climate|\\.csv$"
pattern_to_include <- "\\.\\d{4}$" # filtering for anything that ends with a dot followed by a four digit number
data_list <- grep(pattern_to_exclude, data_list, invert = TRUE, value = TRUE)
data_list <- grep(pattern_to_include, data_list, invert = FALSE, value = TRUE)


### CONTINUE HERE       

         


# first an empty .myrmidon file is created manually as a source file using fort studio: base_source.myrmidon this is then used to create the rest of the files... 

#### Main Loop for file creation  ####
# first an empty .myrmidon file is created manually as a source file using fort studio: base_source.myrmidon this is then used to create the rest of the files... 

tracking_type <- c("main", "feeding")
for (i in 1:nrow(data_collection)) {
  for (type in tracking_type) {
    if (type == "main") {
      file_name <- paste0(data_collection[i,"colony_nr"], '_m_base.myrmidon') # file name will be of the following structure: c01_m_base.myrmidon (m = main tracking vs f = feeding)
      tracking_data <- fmExperimentOpen("base_source.myrmidon")
      s <- tracking_data$createSpace(data_collection[i,"tracking_system_main"])
      printf("Space '%s' has ID: %d\n",s$name,s$ID)
      tracking_data$name <- paste0("vital fc2 ",data_collection[i,"colony_nr"], " main")
      # assign the tracking data
      for (folder_name in data_list) {
        if (grepl(data_collection[i,"colony_nr"], folder_name, fixed = TRUE) & !grepl("feeding", folder_name, fixed = TRUE)) {
          tracking_data$addTrackingDataDirectory(s$ID, paste0(directory,folder_name))
        } else {next}
      }
      # save the file base file with created ants 
      tracking_data$save(paste0(directory, data_collection[i,"colony_nr"], '_main.myrmidon'))
    } else {
      file_name <- paste0(data_collection[i,"colony_nr"], '_f_base.myrmidon') # file name will be of the following structure: c01_m_base.myrmidon (m = main tracking vs f = feeding)
      tracking_data <- fmExperimentOpen("base_source.myrmidon")
      s <- tracking_data$createSpace(data_collection[i,"tracking_system_feeding"])
      printf("Space '%s' has ID: %d\n",s$name,s$ID)
      tracking_data$name <- paste0("vital fc2 ",data_collection[i,"colony_nr"], " feeding")
      # assign the tracking data
      for (folder_name in data_list) {
        if (grepl(data_collection[i,"colony_nr"], folder_name, fixed = TRUE) & grepl("feeding", folder_name, fixed = TRUE)) {
          tracking_data$addTrackingDataDirectory(s$ID, paste0(directory,folder_name))
        }
      }
      # save the file base file with created ants 
      tracking_data$save(paste0(directory, data_collection[i,"colony_nr"], '_feeding.myrmidon'))
    }
  }
}

### Error with addTrackingDataDirectory() --> reported on github 
# thus, the code does not work yet

#### once the issue with the tracking data valid method error is resolved The loop above should work to create all the base files..

# if it does not work the files can be created automatically, but the directories need to be added manually which is annoying.
# but if it works the ant creation code could be run within the same loop to save time. 


# In the latest version of the R bindings, fmExperiment$addTrackingdataDirectory() takes an additional fixCorruptedData argument.
# 
# The way the rcpp package works (the package that allows a R program to interface with C++), if you fail to provide all needed arguments, it returns this very cryptic method, which does not tell you to add the missing value.
# 
# To get the old behaviorm please use FALSE, and the call will fail if there is a data corruption. Use TRUE to ask to not fail but try to fix any encountered error (will cause permanent data loss, but let you recover as much data as possible).
# 


