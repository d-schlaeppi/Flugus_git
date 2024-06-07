
### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###
#### Base File Generator  #### 
### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###

#### Information ####
# automatically generate the myrmidon base files for all tracking files
# the new version also loads the tracking data and creates all the ants

# Needs to be sourced from the main script which contains the information for:
# DATADIR
# colony_metadata


# file.remove(status_file) 
# DATADIR <- paste(DATADIR, "TEST_DATA_COPY", sep = "/")
# setwd(DATADIR)

### checks before starting 
if (!file.exists(paste(DATADIR, "base_source.myrmidon", sep = "/"))) {
  cat(red("The file 'base_source.myrmidon' does not exist in DATADIR", "\n", "Please manually copy it to:", DATADIR,"\n")) 
} else {cat(blue("base_source.myrmidon exists in DATADIR, go ahead", "\n"))}
if (!exists("colony_metadata")) {stop("Error: The colony_metadata is not loaded.")} else {cat("colony_metadata is loaded.\n")}
status_file <- paste(DATADIR, "basefile_generator_status.txt", sep = "/")
if (file.exists(status_file)) {
  cat(readLines(status_file), sep = "\n")
  stop(" No need to re-run the script")}



# compile a list of all the myrmidon files (only those) in that folder: 
data_list <- list.files(path=DATADIR, pattern=NULL, all.files=FALSE, full.name=FALSE) # all files
pattern_to_exclude <- "\\.myrmidon$|\\.txt$|climate|\\.csv$"
pattern_to_include <- "\\.\\d{4}$" # filtering for anything that ends with a dot followed by a four digit number
data_list <- grep(pattern_to_exclude, data_list, invert = TRUE, value = TRUE)
data_list <- grep(pattern_to_include, data_list, invert = FALSE, value = TRUE)



#### Start Loop ####
tracking_type <- c("main", "treatment_id_check")
manual_check_required <- NULL

for (i in 1:nrow(colony_metadata)) { # i <- 1
  cat(blue("Processing colony ", colony_metadata[i,"colony_id"], "\n"))
  for (type in tracking_type) { # type = "main"  # type = "treatment_id_check"
   cat(blue(type, "\n"))
    if (type == "main") {
      tracking_data <- fmExperimentOpen("base_source.myrmidon")
      s <- tracking_data$createSpace(colony_metadata[i,"tracking_system_main"])
      printf("Space '%s' has ID: %d\n",s$name,s$ID)
      tracking_data$name <- paste0("CFG flugus ", colony_metadata[i,"colony_id"], " main")
      
      # assign the tracking data
      for (folder_name in data_list) { # folder_name <- data_list[1]
      tryCatch({ # For the main tracking data Fix corrupted data is currently set to FALSE because we try to avoid loosing corrupted data 
        if (grepl(colony_metadata[i, "colony_id"], folder_name, fixed = TRUE) & !grepl("treated", folder_name, fixed = TRUE)) {
          tracking_data$addTrackingDataDirectory(s$ID, paste(DATADIR, folder_name, sep = "/"), fixCorruptedData = FALSE)
        } else {
          next
        }
      }, error = function(e) {
        warning(paste("Error encountered with folder:",  folder_name))
        manual_check_required <<- c(manual_check_required, folder_name)
      })
      }
 
      tag_statistics <- fmQueryComputeTagStatistics(tracking_data)   # extract the tag statistics to know how many times each tag was detected etz
      # create ants - decide on the cutoff: stronger cut off to reduce the chances of false positives if too many false ants are created | tag_statistics[,"count"] #check for the count numbers to see what range should be included (in this case the cutoff is reduced from 0.001 to 0,01)
      if (nrow(tag_statistics) > 0){
        for (j in 1:nrow(tag_statistics)) {  # loop over each tag # j = 2
            if ( tag_statistics[j,"count"] >= 0.01*max(tag_statistics[,"count"],na.rm=T) ) { # antID only if the tag detection rate was more than 1/100 (adriano used 1/1000) of the best tag detection rate
            a <- tracking_data$createAnt(); # creates an antID, i.e. associates a decimal antID number to that particular tagID
            identification <- tracking_data$addIdentification(a$ID,tag_statistics[j,"tagDecimalValue"],fmTimeSinceEver(),fmTimeForever())
            print(identification)
            }
       } }
      tracking_data$save(paste0(DATADIR, "/", colony_metadata[i,"colony_id"], '_main.myrmidon')) # save the file base file with created ants
    } else {
      tracking_data <- fmExperimentOpen("base_source.myrmidon")
      s <- tracking_data$createSpace(colony_metadata[i,"tracking_system_treatment"])
      printf("Space '%s' has ID: %d\n",s$name,s$ID)
      tracking_data$name <- paste0("CFG flugus ", colony_metadata[i,"colony_id"], " treatment")
      
      # For the treatment data the fix corrupted data is currently set to TRUE!
      for (folder_name in data_list) {
      tryCatch({
        if (grepl(colony_metadata[i, "colony_id"], folder_name, fixed = TRUE) & grepl("treated", folder_name, fixed = TRUE)) {
          tracking_data$addTrackingDataDirectory(s$ID, paste(DATADIR, folder_name, sep = "/"), fixCorruptedData = TRUE)
        } else {
          next
        }
      }, error = function(e) {
        warning(paste("Error encountered with folder:",  folder_name))
                manual_check_required <<- c(manual_check_required, folder_name)
      })
      }
      tag_statistics <- fmQueryComputeTagStatistics(tracking_data)   # extract the tag statistics
      if (nrow(tag_statistics) > 0){
      for (j in 1:nrow(tag_statistics)) {  # loop over each tag
        if ( tag_statistics[j,"count"] >= 0.01*max(tag_statistics[,"count"],na.rm=T) ) { # antID only if the tag detection rate was more than 1/100 (adriano used 1/1000) of the best tag detection rate
          a <- tracking_data$createAnt(); # creates an antID, i.e. associates a decimal antID number to that particular tagID
          identification <- tracking_data$addIdentification(a$ID,tag_statistics[j,"tagDecimalValue"],fmTimeSinceEver(),fmTimeForever())
          print(identification)
        }
      }}
      tracking_data$save(paste0(DATADIR, "/" , colony_metadata[i,"colony_id"], '_treatment.myrmidon')) # save the file base file with created ants
    }
  }
}


         
text <- "base file generator has already been run successfully for this dataset"
if (length(manual_check_required) > 0) {
  cat(red("WARNING: Manual check required for the following folders:\n"))
  print(manual_check_required)
} else {cat("No manual checks required.\n")}
writeLines(text, con = status_file)

# In the latest version of the R bindings, fmExperiment$addTrackingdataDirectory() takes an additional fixCorruptedData argument.
# The way the rcpp package works (the package that allows a R program to interface with C++), if you fail to provide all needed arguments, it returns this very cryptic method, which does not tell you to add the missing value.
# To get the old behavior please use FALSE, and the call will fail if there is a data corruption. Use TRUE to ask to not fail but try to fix any encountered error (will cause permanent data loss, but let you recover as much data as possible).


