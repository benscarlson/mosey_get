source('src/scripts/manage_data/movebank_api/download_data.r')

studyId <- 8863543 #loburg
tagAPICall(studyId)

#-- tag
req <- tagReq(studyId)
mvRaw <- downloadMvData(req)
mvRaw <- mvRaw %>% rename(tag_id=id)
write_csv(mvRaw,file.path('scratch/movebank_raw/tag',sprintf('tag_%s.csv',study_id)))

sqlite3
.open /Users/benc/projects/whitestork/src/db/db.sqlite
.mode csv
.import /Users/benc/projects/whitestork/scratch/movebank_raw/tag/tag_8863543.csv tag

#-- deployment
req <- deploymentReq(studyId)
raw <- downloadMvData(req)
raw <- raw %>% rename(deployment_id=id)
write_csv(raw,file.path('scratch/movebank_raw/deployment',sprintf('deployment_%s.csv',studyId)))

sqlite3
.open /Users/benc/projects/whitestork/src/db/db.sqlite
.mode csv
.import /Users/benc/projects/whitestork/scratch/movebank_raw/deployment/deployment_8863543.csv deployment