makeQueryString <- function(paramList) {
  attribs <- vector(length=0)
  for(key in names(paramList)) {
    attribs <- append(attribs,paste(key,paramList[[key]],sep='='))
  }
  qs <- paste(attribs,collapse='&')
  return(qs)
}

#' Formats a POSIXct object into a format required by movebank api
#' @param ts \code{POSIXct} Timestamp to be converted to movebank api format
#' @return \code{character} Formatted timestamp
#'
formatTs <- function(ts) {

  #strftime is for formatting date objects.
  #usetz just controls whether tz is printed, *not* whether it is used to convert time
  #for this, need to specify tz, otherwise time is converted to local time
  tsStr <- strftime(ts, format="%Y-%m-%d %H:%M:%S", usetz=FALSE, tz=attr(ts,'tzone'))
  tsFmt <- paste0(gsub('-|:| ','', tsStr),'000') #move requires no extra symbols, and thousands of seconds

  return(tsFmt)
}

#' Sets the userid for the r session
#' @param userid \code{character} Movebank user id
#' @param pass \code{character} Movebank password
#' @example
#' setAuth('my.user.id',getPass())
#' @export
#'
setAuth <- function(userid,pass) {
  options(rmoveapi.userid=userid)
  options(rmoveapi.pass=pass)
}

