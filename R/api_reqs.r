
apiReq <- function(entityType, studyid, fields=NULL, sensor_type_id=NULL) { #,startTs,endTs

  params <- list()
  params$entity_type <- entityType
  params$study_id <- studyid

  if(!is.null(fields)) {
    params$attributes <- paste(fields,collapse=',')
  }

  if(!is.null(sensor_type_id)) {
    params$sensor_type_id <- sensor_type_id
  }

  qs <- makeQueryString(params)

  url <- sprintf('https://www.movebank.org/movebank/service/direct-read?%s',qs)
  return(url)
}

eventReq <- function(studyid) {
  #TODO: filter by visible!=FALSE.
  #visible: Determines whether an event is visible on the Movebank Search map. Values are calculated automatically, with FALSE indicating that the event has been marked as an outlier by manually marked outlier or algorithm marked outlier. Allowed values are TRUE or FALSE.
  #TODO: add start, end filters (see old_code.r)
  fields <- c(
    'event_id','study_id','individual_id','location_long',
    'location_lat','timestamp',
    #eobs_temperature',
    'ground_speed','sensor_type_id','manually_marked_outlier','visible')

  return(apiReq('event',studyid,fields,653)) #GPS tag id is 653

}

tagReq <- function(studyid) {
  fields <- c( #not sure if this is the list I want.
    'id',
    'study_id',
    'local_identifier', #this appears to be tag_id in Shay's data
    'tag_type_id') #appears to be empty

  return(apiReq('tag',studyid,fields))
}

deploymentReq <- function(studyid) {

  fields <- c(
  'id', 'individual_id', 'local_identifier', 'study_id', 'study_site', 'tag_id', 'comments',
  'deploy_off_timestamp', 'deploy_on_timestamp')

  return(apiReq('deployment',studyid,fields))
}

studyReq <- function(studyid) {

  return(apiReq('study',studyid))
}

