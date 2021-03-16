

#' Formats an movebank api request
#'
#' @param params \code{list} List in which item name is the api parameter name, and value is the value to send to api
#' @return \code{character} A request url
#'
apiReq <- function(params) { #entityType, studyid, fields=NULL, sensor_type_id=NULL,startTs,endTs

  #Remove any elements that are null or empty
  params <- params[lengths(params) > 0 & params != ""]

  if(!is.null(params$study_id)) {
    params$study_id <- paste(params$study_id,collapse=',')
  }

  if(!is.null(params$attributes)) {
    params$attributes <- paste(params$attributes,collapse=',')
  }

  if(!is.null(params$timestamp_start)) {
    params$timestamp_start <- formatTs(params$timestamp_start)
  }

  if(!is.null(params$timestamp_end)) {
    params$timestamp_end <- formatTs(params$timestamp_end)
  }

  qs <- makeQueryString(params)

  url <- paste0(API_URL,'?',qs)
  return(url)
}
