#' Downloads study data using movebank api
#'
#' @param studyid \code{integer} The id of the study. Can be a vector of ids.
#' @return Information about the study
#' @examples
#' getStudy(123413)
#' @export
#'
getStudy <- function(studyid,params=list(),...) {

  params$entity_type = 'study'

  return(getGeneric(studyid,params,...))
}

#' Downloads individual data using movebank api
#'
#' @param studyid \code{integer} The id of the study. Must only be a single id (unlike getStudy).
#' @return Information about the study
#' @examples
#' getIndividual(123413)
#' @export
#'
getIndividual <- function(studyid,params=list(),...) {

  params$entity_type = 'individual'

  return(getGeneric(studyid,params,...))
}

#' Downloads tag data using movebank api
#'
#' @param studyid \code{integer} The id of the study. Must only be a single id (unlike getStudy).
#' @return Tag data
#' @examples
#' getTag(123413)
#' @export
#'
getTag <- function(studyid,params=list(),...) {

  params$entity_type = 'tag'

  return(getGeneric(studyid,params,...))
}

#' Downloads deployment data using movebank api
#'
#' @param studyid \code{integer} The id of the study. Must only be a single id (unlike getStudy).
#' @return Deployment data
#' @examples
#' getDeployment(123413)
#' @export
#'
getDeployment <- function(studyid,params=list(),...) {

  params$entity_type = 'deployment'

  return(getGeneric(studyid,params,...))
}

#' Downloads event data for a study using movebank api
#'
#' @param studyid The id of the study
#' @param attributes \code{character} Vector of desired attributes. To get all attributes use attributes=all
#' @param ts_start \code{character} Assumes UTC
#' @param ts_end \code{character} Assumes UTC
#'
#' @return Events for the study
#' @examples
#' getEvent(123413)
#' @export
#'
getEvent <- function(studyid,attributes=NULL,ts_start=NULL,ts_end=NULL,params=list(),...) {

  #TODO: set the userid using options()

  params$entity_type = 'event'

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

  return(getGeneric(studyid,params,...)) #make the request

}

getGeneric <- function(studyid,params,...) {

  optargs <- list(...)

  if(missing(studyid)) {
    stop('Must provide studyid.')
  } else {
    params$study_id = studyid
  }

  req <- apiReq(params)

  if('urlonly' %in% names(optargs) && optargs$urlonly) { #note using short-circuit &&
    return(req)
  } else {
    return(getMvData(req,...)) #make the request
  }
}

#' Gets movebank data based on api request
#'
#' @param apiReq \code{character} URL for API request.
#' @param accept_license \code{boolean} Set to TRUE to use md5 method to accept license terms over api.
#' @param handle \code{handle} Handle object used in httr. Mainly for testing purposes to start with blank session.
#'
#' @return \code{data.frame} Data from API request
#' @examples
#' apiReq <- https://www.movebank.org/movebank/service/direct-read?entity_type=study&study_id=2911040
#' getMvData(apiReq,accept_license=TRUE)
#'
getMvData <- function(apiReq,accept_license=FALSE,handle=NULL) {

  #TODO: password management needs to be better.
  # First, check if there is a path to a file that contains the password
  # Then, check to see if password has been set in rmoveapi.pass
  # Then, use getPass to ask for password.

  userid <- getOption('rmoveapi.userid')
  pass <- getOption('rmoveapi.pass')
  licenseTxt <- "The requested download may contain copyrighted material"

  if(is.null(userid)) {
    stop('Need to set userid.\nUse options(rmoveapi.userid=<userid>)')
  }

  if(is.null(pass)) {
    stop('Need to set password.\nUse options(rmoveapi.pass=<pass>)')
  }

  auth <- httr::authenticate(userid,pass) #getPass::getPass()

  if(is.null(handle)) {
    resp <- httr::GET(apiReq, auth)
  } else {
    resp <- httr::GET(apiReq,handle=handle,auth)
  }

  httr::stop_for_status(resp)

  cont <- httr::content(resp, as='text', encoding='UTF-8') #get the content as a text string, as recommened by the docs

  #If we got the license text, need to accept license by sending back MD5 of license text
  # Must be in the same session in order to work
  if(stringr::str_detect(cont,licenseTxt)) {
    if(accept_license) {
      #md5 of license text is passed back to movebank in order to accept terms
      md5 <- digest::digest(cont, "md5", serialize = FALSE)

      apiReq2 <- glue::glue('{apiReq}&license-md5={md5}')
      #apiReq2 <- 'https://www.movebank.org/movebank/service/direct-read?entity_type=event&study_id=685178886&license-md5=c017d5bda56c72ccd079a864130d851f'

      resp2 <- httr::GET(apiReq2, auth)
      httr::stop_for_status(resp2)
      cont <- httr::content(resp2, as='text', encoding='UTF-8')
    } else {
      message('Data could not be downloaded because you need to accept license terms.\nUse accept_license=TRUE or accept terms on movebank.com')
      return(NULL)
    }
  }

  rows <- read.csv(text=cont,stringsAsFactors=FALSE, na.strings = "") #read in the string into a dataframe
  return(rows)
}
