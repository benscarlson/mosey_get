source('~/projects/helper_functions/makeQueryString.r')

indivApiCall <- function(studyId) {
  fields <- c(
    'id',
    'study_id',
    'local_identifier',
    'ring_id',
    'sex',
    'earliest_date_born',
    'exact_date_of_birth',
    'latest_date_born',
    'taxon_canonical_name',
    'death_comments',
    'comments')
  
  params <- list()
  params$entity_type <- 'individual'
  params$study_id <- studyId
  params$attributes <- paste(fields,collapse=',')
  qs <- makeQueryString(params)
  
  url <- sprintf('https://www.movebank.org/movebank/service/direct-read?%s',qs)
  return(url)
}

downloadIndividual <- function(studySn=NULL,studyId=NULL) {
  require(httr)
  require(getPass)
  
  if(is.null(studyId)) { studyId <- idFromStudySn(studySn) }
  
  auth <- authenticate("ben.s.carlson", getPass())
  req <- indivApiCall(studyId)
  resp <- GET(req, auth)
  #'TODO: do some checking of outputs to make sure I got a good response
  csvStr <- content(resp, as='text') #get the content as a text string, as recommened by the docs
  rows <- read.csv(text=csvStr,stringsAsFactors=FALSE) #read in the string into a dataframe
  
  rowsRn <- rows %>% rename(individual_id=id) %>%
    mutate_at(.vars=vars(earliest_date_born,exact_date_of_birth,latest_date_born),
              .funs=funs(as.POSIXct(ifelse(.=='',NA,.),tz='GMT')))
  
  return(rowsRn)
}

