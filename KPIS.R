#KPIS

library('lubridate')
source('Campaign.R')
source('users.R')

#noaction
#registered_rates
#forward_rates
#returning_rates

#to revisit click rate

names(Campaign_data_overall)
##############################################################################################
#Action and no action rates for registered/subscribed  ones-------

no_action = Campaign_data_overall$emails_sent - Campaign_data_overall$registered_unique_open

Campaign_registered <- Campaign_data_overall %>% select(campaign_id, 
                                 open = registered_unique_open,
                                 click= registered_click,
                                 bounce= registered_bounce) %>% cbind.data.frame(no_action)

Campaign_registered_rates <- cbind(campaign_id = Campaign_registered$campaign_id %>% as.character,
                                   no_action_rate = Campaign_registered$no_action/Campaign_data_overall$emails_sent,
                                   open_rate = Campaign_registered$open/Campaign_data_overall$emails_sent,
                                   click_rate = Campaign_registered$click/Campaign_data_overall$emails_sent,
                                   bounce_rate = Campaign_registered$bounce/Campaign_data_overall$emails_sent) 

#engagement_rate
engagement_rate <- (Campaign_registered_rates[,4] %>% as.character %>% as.double)/ (Campaign_registered_rates[,3] %>% as.character %>% as.double) 

#unsubscription rate

Unsubscribers <- EmailActivity[EmailLists[EmailLists$status == "unsubscribed",]$email_address, ] %>%
    group_by(campaign_id) %>% 
    summarise(unsubscribers = n())

Unsubscribe_rate <- merge(Unsubscribers,  select(Campaign_data_overall,campaign_id, emails_sent), 
                          by = "campaign_id", all.y = TRUE) %>% 
    mutate(Unsubscribe_rate = unsubscribers/emails_sent)

Unsubscribe_rate$Unsubscribe_rate[is.na(Unsubscribe_rate$Unsubscribe_rate)] <- 0
##############################################################################################
#non registered ones - most probably from forwarding or open -----

Campaign_non_registered <- cbind(campaign_id = Campaign_registered$campaign_id %>% as.character,
                                 forward_open = Campaign_data_overall$unique_opens - Campaign_data_overall$registered_unique_open,
                                 forward_click = Campaign_data_overall$total_clicks - Campaign_data_overall$registered_click) %>% as.data.frame

Campaign_non_registered_rates <- cbind(campaign_id = Campaign_non_registered$campaign_id %>% as.character,
                                       forward_open_rate = as.integer(Campaign_non_registered$forward_open)/(as.integer(Campaign_non_registered$forward_open)+ Campaign_registered$open),
                                       forward_click = as.integer(Campaign_non_registered$forward_click) /(as.integer(Campaign_non_registered$forward_click) + Campaign_registered$click))



Average_open <- cbind(campaign_id = Campaign_data_overall$campaign_id %>% as.character,
                        avg_open = Campaign_data_overall$total_opens/Campaign_data_overall$unique_opens)

##############################################################################################
#Actions rate----------

#Per user average action rate
Action_rate <- merge(EmailLists, select(EmailCampaigns,list_id = recipients_list_id, 
                                        campaign_id = id) , by = "list_id") %>%
    group_by(email_address) %>% 
    summarise(campaigns_sent = n()) %>% 
    merge(Action_per_user, by = "email_address", all.x = TRUE) %>%
    group_by(email_address) %>%
    mutate(action_rate = actions/campaigns_sent) %>%
    summarise(action_rate = mean(action_rate))

table(!is.na(Action_rate$action_rate))

#Per country action rate 
Country_action_rate <- group_by(Users, campaign_id, location_country_code) %>% 
    summarise(country_code_sent = n(), actions = sum(actions)) %>% 
    mutate(country_action_rate = actions/country_code_sent) %>% 
    arrange(desc(country_action_rate))

#Per campaign the country action rate

Campaign_Country_action_rate <- Country_action_rate %>% 
    ungroup %>% 
    group_by(campaign_id) 

Campaign_Country_action_rate$country_action_rate[is.na(Campaign_Country_action_rate$country_action_rate)] <- 0

Campaign_Country_action_rate <-Campaign_Country_action_rate %>%
    mutate( country_action_rate = country_action_rate/sum(country_action_rate)) %>% arrange(campaign_id)

Campaign_Country_action_rate.max <- 
    Campaign_Country_action_rate%>% 
    # filter(country_code_sent > 1) %>%
    filter(country_action_rate == max(country_action_rate)) %>% ungroup %>%
    group_by(location_country_code) %>%
    arrange(location_country_code)

most_engaged_countries <- Campaign_Country_action_rate%>% 
         filter(country_action_rate == max(country_action_rate)) %>% ungroup %>%
         group_by(location_country_code) %>%
         arrange(location_country_code) %>% group_by(location_country_code) %>%
    summarise(times_top = n()) %>% arrange(desc(times_top))
##############################################################################################
#Day --------


Actions_email_days_users <- EmailActivity$timestamp %>% 
    as.Date %>% weekdays %>% 
    cbind(email_address = EmailActivity$email_address %>% as.character) %>% 
    as.data.frame
#Weekday performance based on average action rate 
Actions_email_days <- group_by(Actions_email_days_users, 
                               Actions_email_days_users[,1]) %>%
    summarise(weekday_action_rate = n()) %>% 
    arrange(weekday_action_rate) %>% 
    mutate(weekday_action_rate =weekday_action_rate/sum(weekday_action_rate))

#Weekday performance of campaigns sent - on average- based on no action rate (look at day performance)

Sent_email_days <- EmailCampaigns$send_time %>% as.Date %>% 
    weekdays %>% cbind(campaign_id =EmailCampaigns$id %>% as.character) %>% 
    merge(Campaign_registered_rates, by = "campaign_id") %>% 
    group_by(campaign_id) %>%
    arrange(no_action_rate) 

names(Sent_email_days)[2] <- "Day"

statistics_days <- Sent_email_days %>% group_by(Day) %>% 
    summarise(variance = sd(no_action_rate %>% as.character %>% as.double), 
             average_no_action_rate = mean(no_action_rate %>% as.character %>% as.double)) %>% 
    arrange(average_no_action_rate)

day_performace <- (statistics_days$variance/statistics_days$average_no_action_rate + statistics_days$average_no_action_rate) %>% cbind.data.frame(statistics_days$Day) 

day_performace <- arrange(day_performace, day_performace[,1])


#More to be explored- Suggestions --------
#opening frequency
#how long till the unsubscribed
#click frequency
#inactivity rate - capaign sent to list - list users - action?

