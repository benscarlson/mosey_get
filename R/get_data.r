#' Downloads study metadata using movebank api
#'
#' @param studyid The id of the study
#' @param userid Movebank user id
#' @return Information about the study
#' @examples
#' getStudy(123413,"ben.s.carlson")
#' @export
#'
getStudy <- function(studyid,userid) {
  #require(httr)
  #require(getPass)
  #require(keyring)

  req <- studyReq(studyid) #build the api request url

  return(getMvData(req,userid)) #make the request
}

#' Downloads event data for a study using movebank api
#'
#' @param studyid The id of the study
#' @param userid Movebank user id
#' @return Events for the study
#' @examples
#' getEvent(123413,"ben.s.carlson")
#' @export
#'
getEvent <- function(studyid,userid) {
  #require(httr)
  #require(getPass)
  #require(keyring)

  req <- eventReq(studyid) #build the api request url

  return(getMvData(req,userid)) #make the request
}

getMvData <- function(apiReq,userid) {

  #auth <- authenticate(userid, key_get('api'))
  auth <- authenticate(userid,getPass())

  resp <- GET(apiReq, auth)
  #'TODO: do some checking of outputs to make sure I got a good response
  cd <- resp$status_code==200
  #stopifnot(cd,sprintf('Failed with status code %s',cd))
  stop_for_status(resp)
  csvStr <- content(resp, as='text', encoding='UTF-8') #get the content as a text string, as recommened by the docs
  rows <- read.csv(text=csvStr,stringsAsFactors=FALSE) #read in the string into a dataframe
  return(rows)
}
