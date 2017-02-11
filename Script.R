
library('R.utils') #install.packages('R.utils')

EmailData <-'email_data.sql'
EmailDataLines <- readLines(EmailData)

# 3 datasets 
#23- 10398
# 10407 -10455
# 10464- 12122

#Datasets starting and end points in sql doc

names_position <- grep("COPY", EmailDataLines)

dataset_start <- names_position
dataset_end <- grep("\\\\+\\.", EmailDataLines) - 1

dataset_limits <- cbind(start = dataset_start,
                        end = dataset_end - dataset_start) 

#Getting names of 1st dataset

getnamesEmailActivity <-strsplit(EmailDataLines[names_position[1]], " [(]") [[1]][2] %>% 
    strsplit("[)]")

separatenamesEmailActivity <- getnamesEmailActivity[[1]][1] %>% 
    strsplit("[\"]") %>% lapply(strsplit, " ") %>% 
    unlist %>% 
    lapply(strsplit, "[,]") %>% 
    unlist

namesEmailActivity <- separatenamesEmailActivity[separatenamesEmailActivity !=""]

#Getting names of 2nd dataset
getnamesEmailCampaigns <-strsplit(EmailDataLines[names_position[2]], " [(]") [[1]][2] %>% 
    strsplit("[)]")

separatenamesEmailCampaigns <- getnamesEmailCampaigns[[1]][1] %>% 
    strsplit("[\"]") %>% lapply(strsplit, " ") %>% 
    unlist %>% 
    lapply(strsplit, "[,]") %>% 
    unlist

namesEmailCampaigns <- separatenamesEmailCampaigns[separatenamesEmailCampaigns !=""]

#Getting names of 3rd dataset

getnamesEmailLists <-strsplit(EmailDataLines[names_position[3]], " [(]") [[1]][2] %>% 
    strsplit("[)]")

separatenamesEmailLists <- getnamesEmailLists[[1]][1] %>% 
    strsplit("[\"]") %>% lapply(strsplit, " ") %>% 
    unlist %>% 
    lapply(strsplit, "[,]") %>% 
    unlist

namesEmailLists <- separatenamesEmailLists[separatenamesEmailLists !=""]


#Getting Datasets

EmailActivity <- read.table(EmailData, skip = dataset_limits[1,"start"], 
                            nrows = dataset_limits[1, "end"], sep = "\t",
                            col.names = namesEmailActivity)

EmailCampaigns <- read.table(EmailData, skip = dataset_limits[2,"start"], 
                             nrows = dataset_limits[2, "end"], sep = "\t",
                             col.names = namesEmailCampaigns)
    
EmailLists <- read.table(EmailData, skip = dataset_limits[3,"start"], 
                         nrows = dataset_limits[3, "end"], sep = "\t",
                         col.names = namesEmailLists)


