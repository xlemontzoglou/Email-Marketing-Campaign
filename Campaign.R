# Campaign - datasets to get to KPIS

EmailCampaigns$emails_sent
EmailCampaigns$recipients_recipient_count

EmailCampaigns$recipients_list_id %>% table

# 180b7eeb41 9375e3c354 cd055c6fe3 
# 25          2         22 

#Actions per campaign

Campaign_actions = group_by(EmailActivity, campaign_id, action) %>% 
    summarise(Summary =n())

#Total actions of recorderd/registered users 

Campaign_actions_count = group_by(EmailActivity, campaign_id, action) %>% 
    summarise(Summary =n()) %>% 
    group_by(campaign_id) %>% 
    summarise(registered_actions = sum(Summary))

#Campaign data including actions taken in each campaign form registered users
Campaign_data <- select(EmailCampaigns, campaign_id = id, 
       emails_sent, unique_opens = report_summary_unique_opens, 
       total_clicks = report_summary_clicks, 
       total_opens = report_summary_opens) %>% 
    merge(Campaign_actions_count, by = "campaign_id" )

#bounce rate missing

#Action open per campaign of registered/subscribed ones
registered_open <- Campaign_actions %>% filter(action == "open") %>% 
    select(campaign_id, registered_open = Summary)

#Action bounce per campaign of registered/subscribed ones
registered_bounce <- Campaign_actions %>% filter(action == "bounce") %>%
    select(campaign_id, registered_bounce = Summary)

#Action click per campaign of registered/subscribed ones
registered_click <- Campaign_actions %>% filter(action == "click") %>%
    select(campaign_id, registered_click = Summary)

#(Action open) unique opens per campaign of registered/subscribed ones
registered_unique_open <- filter(EmailActivity, action == "open") %>%
    select(email_address, campaign_id) %>%
    group_by(campaign_id, email_address) %>% 
    summarise(x = n()) %>%
    group_by(campaign_id) %>%
    summarise(registered_unique_open = n())

#Copmlete dataset of actions of subscribed ones and total actions overall
Campaign_data_overall <- merge(Campaign_data, registered_open,by = "campaign_id") %>%
    merge(registered_unique_open, by = "campaign_id", all.x = TRUE) %>%
    merge( registered_click, by = "campaign_id", all.x = TRUE) %>% 
    merge(registered_bounce, by = "campaign_id", all.x = TRUE)
