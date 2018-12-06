source('~/projects/helper_functions/makeQueryString.r')
#https://github.com/movebank/movebank-api-doc
#https://www.movebank.org/movebank/service/direct-read?attributes

apiReq <- function(entityType, studyId, fields) { #,startTs,endTs
  
  params <- list()
  params$entity_type <- entityType
  params$study_id <- studyId
  params$attributes <- paste(fields,collapse=',')
  qs <- makeQueryString(params)
  
  url <- sprintf('https://www.movebank.org/movebank/service/direct-read?%s',qs)
  return(url)
}

tagReq <- function(studyId) {
  fields <- c( #not sure if this is the list I want.
    'id',
    'study_id',
    'local_identifier', #this appears to be tag_id in Shay's data
    'tag_type_id') #appears to be empty
  
  return(apiReq('tag',studyId,fields))
}

deploymentReq <- function(studyId) {
  
  fields <- c(
  'id', 'individual_id', 'local_identifier', 'study_id', 'study_site', 'tag_id', 'comments',
  'deploy_off_timestamp', 'deploy_on_timestamp')
  
  return(apiReq('deployment',studyId,fields))
}


