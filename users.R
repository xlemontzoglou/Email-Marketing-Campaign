#Users - datasets to get to KPIS

source('Analysis.R')

#Users info from both email activity and email list----

x <- merge(EmailActivity, EmailLists, by = "email_address")

List_per_user <- group_by(x, email_address, list_id.x) %>% 
    summarise(n()) %>% 
    group_by(email_address) %>% 
    summarise(Lists = n()) %>% 
    arrange(desc(Lists))

table(List_per_user$Lists >1)

#20 belong/are registered to more thatn one list


#Number of emails each user has received
Campaign_per_user <- group_by(x, email_address, campaign_id) %>%
    summarise(n()) %>%
    group_by(email_address) %>%
    summarise(Campaigns = n()) %>%
    arrange(desc(Campaigns))

# Action_per_user <- group_by(x, email_address, action) %>%
#     summarise(n()) %>%
#     group_by(email_address) %>%
#     summarise(Lists = n()) %>%
#     arrange(desc(Lists))


#Actions each users has taken per campaign
Action_per_user <- group_by(x, email_address, campaign_id) %>%
    summarise(actions = n()) 

Users_info = x


EmailLists$email_address %in% EmailActivity$email_address %>% table

#506 don't exist in the list - 1143 out of 1164 exist

filter(EmailLists, EmailLists$status == "subscribed")$email_address %in% EmailActivity$email_address %>% table

#917 are subscribed still - there are 430 subscribed but haven't received email (?)

filter(EmailLists, EmailLists$status == "unsubscribed")$email_address %in% EmailActivity$email_address %>% table

#177 are unsuscribed form those who are in the activity dataset - 32 aren't or unsubribed previously getting email


filter(EmailLists, EmailLists$status == "cleaned")$email_address %in% EmailActivity$email_address %>% table

#the cleaned ones are 48 

#Users info form 3 datasets 
Users <- merge(EmailLists, select(EmailCampaigns,list_id = recipients_list_id, 
                         campaign_id = id) , by = "list_id") %>%
    merge(Action_per_user, by = c("email_address","campaign_id"),  all.x = TRUE) 

