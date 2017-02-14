### Files description

##### GetDatasets.R

First to fetch data form the SQL dump file, the script GetDatasets.R . It fetches the 3 datasets from the file, imporing them in R as dtaframes with the corresponding naming, given within the file.

##### DataSinking.R

After fetching the data, a script was created to:

1. Understand the data
2. Check format
3. get to know what nformation are contained
4. how the information are linked
5. check what might be missing
6. what has to be understood relevant with the email marketing industry

##### Analysis.R

Based on ```DataSinking.R``` and the questions that poped out, a first round of analysis was run.

##### Campaign.R & users.R

Based on the analysis via ```Analysis.R``` two scripts were created for preproccesing the data from the campaign and subscriber(user) scope. Datasets to be used for the KPIs formation were created.

##### KPIS.R

Based on the analysis in ```Analysis.R``` and the preproccesing of the data form the campaign and user scope and the produced datasets from ```Campaign.R``` and ```users.R``, the corresponding KPIs were created and calculated. Within this script, the KPIs - always for measuring the performance of the campaigns-  contained are:

*   Subscribers
    *    Open rate
    *   Click rate
    *   No action rate
    *   Engagement rate
    *   Unsubscribe rate
    *   Action rate
    *   Campaign per country action rate
    *   Weekday action rate
*   Non subscribers
    *   Forward open rate
    *   Forward click rate
*   General
    *   Day performance rate

