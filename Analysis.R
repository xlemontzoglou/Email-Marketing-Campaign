#1st Questions to answer

source('./GetDatasets.R')

#1st round of getting to know the data at DataSinking.R


##Missing list and its relevance ------

 missing_list <- levels(EmailActivity$list_id) %in% levels(EmailLists$list_id)  
 

#The missing list_id from Email lists is  '9375e3c354' where only 140 email were sent
 
table(missing_list == FALSE)["TRUE"]/length(missing_list)
#1/3 of the lists is missing

table(EmailActivity$list_id)[missing_list == FALSE]/nrow(EmailActivity)
#small percentage of the total email sent~ 1.3 %

mis_list_actions <- group_by(EmailActivity, list_id, action) %>% 
    filter(list_id == levels(EmailActivity$list_id)[missing_list == FALSE]) %>% 
    summarise(n())
#interesting - no bouncing
#from DataSinking.R 
# table(table(EmailCampaigns$recipients_recipient_count) == table(EmailCampaigns$emails_sent))
# #email_sent vs recipients_recipient_count - there are exactly the same so bounce rate doesn't come from that Or the excluded campaigns had only bounces?
#Answer: No. need to look a bit more into email_sent vs recipients_recipient_count in EmailCampaigns

#is it relevant this list?- check time 

mis_list_dates <-filter(EmailActivity, list_id == levels(EmailActivity$list_id)[2])

max(mis_list_dates$timestamp %>% as.Date)
#not relevant - last email opened from this list two years ago

#####Missing campaigns and their relevance ---------

missing_campaigns <- levels(EmailActivity$campaign_id) %in%  levels(EmailCampaigns$id)

table(missing_campaigns == FALSE)["TRUE"]/length(missing_campaigns)
#big percentage ~ 30% of campaigns are missing form EmailCampaigns


table(EmailActivity$campaign_id)[missing_campaigns == FALSE] %>% 
    sum / length(EmailActivity$campaign_id)
#18 % of the email sent were from the missing campaignss
#so in order to get info for the campaiugns it might be good to generate the same info for all campaigns given the other two datasets

missing_campaigns_ids <- levels(EmailActivity$campaign_id)[missing_campaigns == FALSE]

EmailActivity[EmailActivity$campaign_id == missing_campaigns_ids, ] %>% 
    group_by(campaign_id) %>%
    summarise(max( timestamp %>% as.Date))

#relevant dates!

levels(EmailCampaigns$id) %in% levels(EmailActivity$campaign_id) 
table(EmailCampaigns$id)[levels(EmailCampaigns$id) %in% 
                             levels(EmailActivity$campaign_id) == FALSE]
#one doesn't exist in the EmailActivity dataset
#the info are missing or it hasn;'t yet run
EmailCampaigns[levels(EmailCampaigns$id) %in% levels(EmailActivity$campaign_id) == FALSE,]
#it was sent - however it was only sent to 34

EmailCampaigns[levels(EmailCampaigns$id) %in% 
                   levels(EmailActivity$campaign_id) == FALSE,]$emails_sent / 
    sum(EmailCampaigns$emails_sent)
#only 0.2 % of the total emails sent

##Users missing------

table(levels(EmailActivity$email_address) %in% levels(EmailLists$email_address))
#44 users aren't in the form the EmailActivity dataset aren't found in the EmailList
EmailListUsersMissing <- EmailActivity[levels(EmailActivity$email_address) %in% 
                                           levels(EmailLists$email_address) == FALSE,]

table(levels(EmailLists$email_address)  %in% levels(EmailActivity$email_address))
#for 502 subscribers doesn't exist record of their activity
EmailActivityUsersMissing <- EmailLists[levels(EmailLists$email_address)  %in% 
                                            levels(EmailActivity$email_address) == FALSE,]


###Other----

table(duplicated(EmailLists$email_address))
#27 users have registered more than once or/and they belong to more than one list


















