

.study_id <- 10449318 #LifeTrack White Stork Loburg

apiReq <- glue('https://www.movebank.org/movebank/service/direct-read?entity_type=event&timestamp_start=20180501000000000&timestamp_end=20180515000000000&study_id={.study_id}')
dat <- getMvData(apiReq,handle=handle(''))
