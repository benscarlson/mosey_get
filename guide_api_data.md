# Guide to working with API data

## Duplicates and pseudo-duplicates

The `event` entity often includes duplicates. One reason duplicates occur is when an event record is initially sent over the cell phone network. Such records contain minimal information, and lack some useful fields such as `ground_speed`. Later, a user might use a base station to download the complete record and then upload this to movebank. When this happens, movebank does not attempt to update the already existing record, but instead simply adds the more complete one. This results in two records, one less complete and one more complete. Thus these records are not duplicates in the strict sense of the word, but instead are pseudo-duplicates.

Below is an example. Note individul_id, timestamp, lon, lat are all the same, but in one record ground_speed is NA, whereas in the second record ground_speed is 0.71. Other informational fields such as gps_dop, h_dop, etc. suffer this same problem.

|event_id |	individual_id	| location_long	| tag_id | location_lat	| timestamp	| ground_speed |
|----- | ----- | -----| ----- | ----- | ----- | ----- |
|254837938	| 00001	| -6.0000	| 10197472 | 	35.0000	| 2013-10-29 | 07:00:23 | NA
|254837938	| 00001	| -6.0000	| 10197472 | 	35.0000	| 2013-10-29 | 07:00:23 | 0.71

This greatly complicates removing duplicates, since you can't just group records by individual and timestamp, and arbitarily take one from each group (like you could if these were strict duplicates). Instead, you need to take the more complete record. One option might be to always take the later record, assuming that the more complete record is always added later. Unfortunately, this isn't always the case

One approach to removing pseudo-duplicates is to identify the record with the highest number of non-empty fields and take that one. The is the approach I take in `mosey_db`. This isn't a perfect solution but seems to work pretty well. Below are some snippets of code, but see `clean_study.r` for the full solution.

Note removal of pseudo-duplicates are further complicated by the presence of milliseconds. Two pseudo-duplicates might differ in the number of milliseconds, and can even differ by the value of the seconds position (e.g. 30.000 vs. 29.997). So you can't simply match the value of the timestamp, but need to accomodate small differences in the milliseconds. If working in R, this is further complicated by serious quirks in how R internally stores milliseconds. See the section on milliseconds below for further discussion.

```{r}

dupgrps <- evtdep %>% 
  group_by(individual_id,tag_id,sensor_type_id,ts_sec) %>% 
  summarize(num=n()) %>%
  filter(num > 1) %>%
  ungroup() %>%
  mutate(dup_id=row_number())
  
  #This gets all duplicate records
  dupevts <- evtdep %>%
    inner_join(dupgrps,by=c('individual_id','tag_id','sensor_type_id','ts_sec')) %>%
    mutate(ts_str=mbts(timestamp)) %>% 
    arrange(individual_id,tag_id,timestamp,event_id)
    
  undup <- dupevts %>% 
    mutate(numvals=rowSums(!is.na(.))) %>%
    group_by(dup_id) %>% 
    filter(numvals==max(numvals)) %>%
    ungroup
  
```

## Milliseconds

TODO
