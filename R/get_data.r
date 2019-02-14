#' Downloads study data using movebank api
#'
#' @param studyid \code{integer} The id of the study. Can be a vector of ids.
#' @return Information about the study
#' @examples
#' getStudy(123413)
#' @export
#'
getStudy <- function(studyid,params=list(),urlonly=FALSE) {

  params$entity_type = 'study'

  return(getGeneric(studyid,params,urlonly))
}

#' Downloads individual data using movebank api
#'
#' @param studyid \code{integer} The id of the study. Must only be a single id (unlike getStudy).
#' @return Information about the study
#' @examples
#' getIndividual(123413)
#' @export
#'
getIndividual <- function(studyid,params=list(),urlonly=FALSE) {

  params$entity_type = 'individual'

  return(getGeneric(studyid,params,urlonly))
}

#' Downloads tag data using movebank api
#'
#' @param studyid \code{integer} The id of the study. Must only be a single id (unlike getStudy).
#' @return Tag data
#' @examples
#' getTag(123413)
#' @export
#'
getTag <- function(studyid,params=list(),urlonly=FALSE) {

  params$entity_type = 'tag'

  return(getGeneric(studyid,params,urlonly))
}

#' Downloads deployment data using movebank api
#'
#' @param studyid \code{integer} The id of the study. Must only be a single id (unlike getStudy).
#' @return Deployment data
#' @examples
#' getDeployment(123413)
#' @export
#'
getDeployment <- function(studyid,params=list(),urlonly=FALSE) {

  params$entity_type = 'deployment'

  return(getGeneric(studyid,params,urlonly))
}

getGeneric <- function(studyid,params,urlonly) {

  if(missing(studyid)) {
    stop('Must provide studyid.')
  } else {
    params$study_id = studyid
  }

  req <- apiReq(params)

  if(urlonly) {
    return(req)
  } else {
    return(getMvData(req)) #make the request
  }
}

#' Downloads event data for a study using movebank api
#'
#' @param studyid The id of the study
#' @param attributes \{character} Vector of desired attributes. To get all attributes use attributes=all
#' @param ts_start \{character} Assumes UTC
#' @param ts_end \{character} Assumes UTC
#'
#' @return Events for the study
#' @examples
#' getEvent(123413)
#' @export
#'
getEvent <- function(studyid,attributes=NULL,ts_start=NULL,ts_end=NULL,params=list(),urlonly=FALSE) {

  #TODO: set the userid using options()

  params$entity_type = 'event'

  if(missing(studyid)) {
    stop('Must provide studyid.')
  } else {
    params$study_id = studyid
  }

  if(is.null(attributes)) {
    params$attributes <- c(
      'event_id','study_id','individual_id','location_long','location_lat','timestamp',
      'ground_speed','sensor_type_id','manually_marked_outlier','visible')
  }

  if(!is.null(ts_start)) {
    params$timestamp_start <- as.POSIXct(ts_start, tz='UTC')
  }

  if(!is.null(ts_end)) {
    params$timestamp_end <- as.POSIXct(ts_end, tz='UTC')
  }

  req <- apiReq(params)

  if(urlonly) {
    return(req)
  } else {
    return(getMvData(req,userid)) #make the request
  }
}

#' Gets movebank data based on api request
#'
getMvData <- function(apiReq) {

  #TODO: password management needs to be better.
  # First, check if there is a path to a file that contains the password
  # Then, check to see if password has been set in rmoveapi.pass
  # Then, use getPass to ask for password.

  userid <- getOption('rmoveapi.userid')
  pass <- getOption('rmoveapi.pass')

  if(is.null(userid)) {
    stop('Need to set userid.\nUse options(rmoveapi.userid=<userid>)')
  }

  if(is.null(pass)) {
    stop('Need to set password.\nUse options(rmoveapi.pass=<pass>)')
  }

  auth <- httr::authenticate(userid,pass) #getPass::getPass()

  resp <- httr::GET(apiReq, auth)
  #TODO: do some checking of outputs to make sure I got a good response
  cd <- resp$status_code==200
  #stopifnot(cd,sprintf('Failed with status code %s',cd))
  httr::stop_for_status(resp)
  csvStr <- httr::content(resp, as='text', encoding='UTF-8') #get the content as a text string, as recommened by the docs
  rows <- read.csv(text=csvStr,stringsAsFactors=FALSE, na.strings = "") #read in the string into a dataframe
  return(rows) #
}
