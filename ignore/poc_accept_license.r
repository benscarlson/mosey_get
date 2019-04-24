library(digest)
library(glue)
library(httr)

apiReq <- 'https://www.movebank.org/movebank/service/direct-read?entity_type=event&study_id=685178886'

auth <- httr::authenticate(getPass::getPass(),getPass::getPass())

resp <- httr::GET(apiReq, auth) #handle=handle(''),

#get md5
md5 <- digest(content(resp), "md5", serialize = FALSE)

apiReq2 <- glue('{apiReq}&license-md5={md5}')
#apiReq2 <- 'https://www.movebank.org/movebank/service/direct-read?entity_type=event&study_id=685178886&license-md5=c017d5bda56c72ccd079a864130d851f'

resp2 <- httr::GET(apiReq2, auth)
