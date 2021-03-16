library(digest)
library(getPass)
library(glue)
library(httr)

#.study_id <- 123413 #BCI Ocelot
#.study_id <- 10449318 #LifeTrack White Stork Loburg
#.studyId <- 21231406	#LifeTrack White Stork SWGermany 2014-2018
.studyId <- 173641633	#LifeTrack White Stork Vorarlberg

user <- getPass(msg='Userid')
pass <- getPass(msg='Password')

apiReq <- glue('https://www.movebank.org/movebank/service/direct-read?entity_type=individual&study_id={.studyId}')

auth <- httr::authenticate(user,pass)

#Make the first request, which should return the license text.
resp <- httr::GET(apiReq, auth, handle=handle('')) #

#Verify that license text was sent. Should start with <html>
substring(content(resp),1,20)

#Need to send hash of license and any cookies in second request

#Make a hash of the license text and return in api request
md5 <- digest(content(resp), "md5", serialize = FALSE)

#Httr should automatically persists cookies in subsequent requests to the same domain
cookies(resp)

apiReq2 <- glue('{apiReq}&license-md5={md5}')

resp2 <- httr::GET(apiReq2, auth)

#Did not retrieve data
status_code(resp2) #403 error
