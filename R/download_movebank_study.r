#download study and save it to the study_raw database

source('~/projects/helper_functions/makeQueryString.r')

studyApiCall <- function(study_id) {

  params <- list()
  params$entity_type <- 'study'
  params$study_id <- study_id
  qs <- makeQueryString(params)
  
  url <- sprintf('https://www.movebank.org/movebank/service/direct-read?%s',qs)
  return(url)
}

downloadStudy <- function(studyId=NULL) {
  require(httr)
  #require(getPass)
  require(keyring)
  
  auth <- authenticate("ben.s.carlson", key_get('api'))
  req <- studyApiCall(studyId)
  resp <- GET(req, auth)
  #'TODO: do some checking of outputs to make sure I got a good response
  cd <- resp$status_code==200
  #stopifnot(cd,sprintf('Failed with status code %s',cd))
  stop_for_status(resp)
  csvStr <- content(resp, as='text', encoding='UTF-8') #get the content as a text string, as recommened by the docs
  rows <- read.csv(text=csvStr,stringsAsFactors=FALSE) #read in the string into a dataframe
  return(rows)
  # rowsRn <- rows %>% rename(individual_id=id) %>%
  #   mutate_at(.vars=vars(earliest_date_born,exact_date_of_birth,latest_date_born),
  #             .funs=funs(as.POSIXct(ifelse(.=='',NA,.),tz='GMT')))
  
  #return(rowsRn)
}


