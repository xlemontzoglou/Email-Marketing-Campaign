
source('./GetDatasets.R')

#Email Activity - 1st Dataset----

str(EmailActivity)
#email marketing campaigns 68

table(table(EmailActivity$email_address) == table(EmailActivity$email_id))
#email_address ~ email_id (user) - 1164 users

table(EmailActivity$action)
#open rate - sometimes not correct tracking because of imgs
#click rate
#bounce rate - hard & soft (not delivered)

#type for bounce rate- applicable only for action bounce
table(EmailActivity$type)
table(EmailActivity$list_id)
#list_id : mailing list - 3

#EmailCampaigns - 2nd Dataset --------

str(EmailCampaigns)
#19 campaigns seem to be missing
#open, click rates and unique times opened
#interesting open vs unique open


EmailCampaigns$delivery_status_enabled %>% table
#all f - is it equal to false?

table(table(EmailCampaigns$recipients_recipient_count) == table(EmailCampaigns$emails_sent))
#email_sent vs recipients_recipient_count - there are exactly the same so bounce rate doesn't come from that Or the excluded campaigns had only bounces?

table(table(EmailCampaigns$send_time) >1)
#send_time to check- one was sent the same time with anothert- a/b testing 

#EmailLists - 3rd dataset-----

str(EmailLists)
# More email adresses in the lists than used - 1649 vs 1164 (email activity)
#possible demo-device-internet graphics from this list
#id equal to email_id
#last_changed might contain information if the user has def churned - time of alteration etc. might contain info about external events

table(EmailLists$email_client)
#max is null  ("")
#what usefull info can we get from here

table(EmailLists$email_type)
#could it be of other type of html?


table(EmailLists$list_id) #In which list a user is subscribed- registered
table(EmailActivity$list_id) #The vector of activity - of which user is and in which list is subscribed
#One list missing from EmailList data - why?

table(EmailLists$status)
#cleaned most probably form hard bounce - and a few soft bounces ?
#pending - pending verification if subscription?
#still subscribed are more thatn users from 1st datasets - why an email hasn't been sent to them? they are probably even more the ones that havnt been sent an email once then subscribers of one list are missing
