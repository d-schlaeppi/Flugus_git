

### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###
### Flugus: COLONY meta data ###
### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###
#### READ ME ####

# Script to read in the colony meta data from the flugus tracking experiment to be accessed in other scripts
# loads a data from called colony_metadata holding a variety of basic information for each colony

# to load the data frame in another script just run the following line 
# source(paste0(SOURCEDIR,"colony_metadata_flugus.R"))

cat(red("Warning: dataframe defined but not complete and further variables might need to be defined as we go along", "\n"))
dat <- read.csv(paste0(DATADIR,"/CFG_colony_metadata.csv"), header = TRUE, stringsAsFactors = F)

# #temporary just copy it from clip board:
# #copy stuff to the clipboard to insert in excel and vice versa
# write_clip(paste0(tagID, collapse = "\n")) # copy from R to clipboard for pasting e.g. in excel
# my_data <- read_clip() # read vector from clipboard in R
# dat <- read_clip_tbl() #read table from clipboard in R
# write.csv(dat, file = "CFG_colony_metadata.csv", row.names = FALSE)

colony_metadata <- NULL
for(i in 1:nrow(dat)) { # i <- 1
  colony_id                 <- dat[i, "colony_id"]
  colony_nr                 <- substring(dat[i, "colony_id"],2,3)
  block                     <- dat[i, "block"]
  treatment                 <- dat[i, "treatment"]
  tracking_system_main      <- dat[i, "tracking_system"]
  tracking_system_treatment <- "esterhase"
  time_treatment_start      <- dat[i, "time_treatment_start"]
  time_treatment_end        <- dat[i, "time_treatment_end"]
  mean_ant_lenght_px        <- dat[i, "mean_ant_lenght_px"]
  mean_ant_lenght_mm        <- dat[i, "mean_ant_lenght_mm"]
  spores_quantified         <- dat[i, "spores_quantified"]
  transcriptomics_conducted <- dat[i, "transcriptomics_conducted"]
  colony_metadata <-  rbind(colony_metadata, data.frame ( colony_id,
                                                          colony_nr,
                                                          block,
                                                          treatment,
                                                          tracking_system_main,
                                                          tracking_system_treatment,
                                                          time_treatment_start,
                                                          time_treatment_end,
                                                          mean_ant_lenght_px,
                                                          mean_ant_lenght_mm,
                                                          spores_quantified,
                                                          transcriptomics_conducted,
                                                          stringsAsFactors = F))
}

cat(blue("colony_metadata for the cfg experiment is now available ", "\n"))
print("For further comments on each of the colonies consult the notes on sharepoint:")
print("https://uob.sharepoint.com/:x:/r/teams/grp-AntsEpidemiologyLab/_layouts/15/Doc.aspx?sourcedoc=%7B9CF14807-3A5A-4DC9-949F-89DC762185DA%7D&file=CFG_Colony_FluGus_Masterfile.xlsx&action=default&mobileredirect=true")


