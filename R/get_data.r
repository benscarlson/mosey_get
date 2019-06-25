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
getEvent <- function(studyid,attributes=NULL,sensor_type_id=NULL,ts_start=NULL,ts_end=NULL,params=list(),...) {

  params$entity_type = 'event'

  if(!is.null(attributes)) {
    params$attributes <- attributes
  }

  if(!is.null(ts_start)) {
    params$timestamp_start <- as.POSIXct(ts_start, tz='UTC')
  }

  if(!is.null(ts_end)) {
    params$timestamp_end <- as.POSIXct(ts_end, tz='UTC')
  }

  if(!is.null(sensor_type_id)) {
    params$sensor_type_id=sensor_type_id
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
#' @param save_as \code{character} Save response directly to disk.
#'
#' @return \code{data.frame} Data from API request. If saving results to disk, returns TRUE.
#' @examples
#' apiReq <- https://www.movebank.org/movebank/service/direct-read?entity_type=study&study_id=2911040
#' getMvData(apiReq,accept_license=TRUE)
#'
getMvData <- function(apiReq,accept_license=FALSE,handle=NULL,save_as=NULL) {

  userid <- getOption('rmoveapi.userid')
  pass <- getOption('rmoveapi.pass')

  licenseTxt <- "The requested download may contain copyrighted material"

  if(is.null(userid)) {
    stop('Need to set userid.\nUse options(rmoveapi.userid=<userid>)')
  }

  if(is.null(pass)) {
    stop('Need to set password.\nUse options(rmoveapi.pass=<pass>)')
  }

  auth <- httr::authenticate(userid,pass)

  #TODO: I think I can just pass in handle, should do the right thing if null
  if(is.null(save_as)) {
    writeMethod <- httr::write_memory()
  } else {
    writeMethod <- httr::write_disk(save_as,overwrite=TRUE)
  }

  resp <- httr::GET(apiReq, auth, writeMethod, handle=handle)

  httr::stop_for_status(resp)

  #need to check result to see if license text was returned. First, load it from memory or disk.
  if(is.null(save_as)) {
    cont <- httr::content(resp, as='text', encoding='UTF-8') #get the content as a text string, as recommened by the docs
  } else {
    cont <- readLines(file(save_as,open='r'),n=1) #just read first line, because file is probably large
  }

  #Check if response is license text. If not, can just return the data
  if(!stringr::str_detect(cont,licenseTxt)) {
    if(is.null(save_as)) {
      return(read.csv(text=cont,stringsAsFactors=FALSE, na.strings = "")) #read in the string into a dataframe and return
    } else {
      return(TRUE) #if saved to disk, then just return true
    }
  }

  #If we've reached this point, then we got license text. Now, return unless user has set accept_license = TRUE
  if(!accept_license) {
    message('Data could not be downloaded because you need to accept license terms.\nUse accept_license=TRUE or accept terms on movebank.com')
    return(NULL)
  }

  #If we've reached this point, then we got license text, and user has set accept_license = TRUE
  # need to accept license by sending back MD5 of license text. Must be in the same session in order to work

  #content() will either extract the content from memory or read from disk, depending on how response was saved
  license <- httr::content(resp, as='text', encoding='UTF-8')

  md5 <- digest::digest(license, "md5", serialize = FALSE)

  apiReq2 <- glue::glue('{apiReq}&license-md5={md5}')
  #apiReq2 <- 'https://www.movebank.org/movebank/service/direct-read?entity_type=event&study_id=685178886&license-md5=c017d5bda56c72ccd079a864130d851f'

  resp2 <- httr::GET(apiReq2, auth, writeMethod)
  httr::stop_for_status(resp2)

  #Either return data or return TRUE (if data was saved to disk)
  if(is.null(save_as)) {
    cont <- httr::content(resp2, as='text', encoding='UTF-8')
    rows <- read.csv(text=cont,stringsAsFactors=FALSE, na.strings = "") #read in the string into a dataframe
    return(rows)
  } else {
    return(TRUE)
  }

}
