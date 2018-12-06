source('~/projects/helper_functions/makeQueryString.r')
#https://github.com/movebank/movebank-api-doc

depAPICall <- function(study_id) { #,startTs,endTs
  
  fields <- c( #not sure if this is the list I want.
    'id',
    'individual_id',
    'study_id',
    'tag_id')
  
  params <- list()
  params$entity_type <- 'deployment'
  params$study_id <- study_id
  params$attributes <- paste(fields,collapse=',')
  qs <- makeQueryString(params)
  
  url <- sprintf('https://www.movebank.org/movebank/service/direct-read?%s',qs)
  return(url)
}


study_id <- 8863543
depAPICall(study_id)

https://www.movebank.org/movebank/service/direct-read?entity_type=tag&study_id=8863543
