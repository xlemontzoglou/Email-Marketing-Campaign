
library('R.utils') #install.packages('R.utils')

EmailData <-'email_data.sql'


# 3 datasets 
#23- 10398
# 10407 -10455
# 10464- 12122


dataset_start <- c(23, 10406, 10463)
dataset_end <- c(10398, 10455, 12112)

dataset_limits <- cbind(start = dataset_start,
                        end = dataset_end - dataset_start) 


EmailActivity <- read.table(EmailData, skip = dataset_limits[1,"start"], 
                            nrows = dataset_limits[1, "end"], sep = "")

EmailCampaigns <- read.table(EmailData, skip = dataset_limits[2,"start"], 
                             nrows = dataset_limits[2, "end"], sep = "")
    
EmailLists <- read.table(EmailData, skip = dataset_limits[3,"start"], 
                         nrows = dataset_limits[3, "end"], sep = "\t")