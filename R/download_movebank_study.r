#download study and save it to the study_raw database

#' copied from rMOL/r/shared.r
makeQueryString <- function(paramList) {
  attribs <- vector(length=0)
  for(key in names(paramList)) {
    attribs <- append(attribs,paste(key,paramList[[key]],sep='='))
  }
  qs <- paste(attribs,collapse='&')
  return(qs)
}

studyApiCall <- function(study_id) {

  params <- list()
  params$entity_type <- 'study'
  params$study_id <- study_id
  qs <- makeQueryString(params)

  url <- sprintf('https://www.movebank.org/movebank/service/direct-read?%s',qs)
  return(url)
}

#' @param studyid \code(integer) The id of the study
#' @param userid \code(string) Movebank user id
#' @return \code(tibble) A dataframe of information about the study
#' @examples
#' downloadStudy(<id>,"ben.s.carlson")
#' @export
#'
downloadStudy <- function(studyid,userid) {
  require(httr)
  require(getPass)
  #require(keyring)

  #auth <- authenticate(userId, key_get('api'))
  auth <- authenticate(userid,getPass())
  req <- studyApiCall(studyid)
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


