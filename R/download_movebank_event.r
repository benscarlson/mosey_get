source('~/projects/helper_functions/makeQueryString.r')



#' Creates an movebank api call 
#' Usage example: eventAPICall(study_id=9648615)
#' 
#' TODO: filter by visible!=FALSE. 
#' visible: Determines whether an event is visible on the Movebank Search map. Values are calculated automatically, with FALSE indicating that the event has been marked as an outlier by manually marked outlier or algorithm marked outlier. Allowed values are TRUE or FALSE.
eventAPICall <- function(study_id,start=NULL,end=NULL) {

  if(!is.null(start)) {
    dt <- strptime("2008-06-04 13:30:45", "%Y-%m-%d %H:%M:%S",tz='UTC')
    start_dt <- paste0(gsub('-|:| ','', ds),'000')
  }
  
  fields <- c(
    'event_id',
    'study_id',
    'individual_id',
    'location_long',
    'location_lat',
    'timestamp',
    #'eobs_temperature',
    'ground_speed',
    'sensor_type_id',
    'manually_marked_outlier',
    'visible')
  
  params <- list()
  params$entity_type <- 'event'
  params$study_id <- study_id
  params$sensor_type_id <- 653 #GPS tag id is 653
  params$attributes <- paste(fields,collapse=',')
  qs <- makeQueryString(params)
  
  url <- sprintf('https://www.movebank.org/movebank/service/direct-read?%s',qs)
  return(url)
}
# save to e.g. whitestork/scratch/movebank_raw/LifeTrack_White_Stork_Bavaria_raw.csv

#ACC data are also stored in the event table
#This is incomplete! Just copied/pasted from eventAPICall
accAPICall <- function(study_id) { #,startTs,endTs
    
    fields <- c( #checking out these fields to see if they are even meaningful
      'acceleration_axes', 
      'acceleration_raw_x', 
      'acceleration_sampling_frequency_per_axis', 
      'acceleration_x', 
      'accelerations_raw', 
      'algorithm_marked_outlier', 
      'behavioural_classification', 
      'deployment_id', 
      'eobs_acceleration_axes', 
      'eobs_acceleration_sampling_frequency_per_axis', 
      'eobs_accelerations_raw', 
      'eobs_start_timestamp', 
      'eobs_status', 
      'eobs_temperature', 
      'event_id', 
      'external_temperature', 
      'ground_speed', 
      'individual_id', 
      'internal_temperature', 
      'location_error_numerical', 
      'location_lat', 
      'location_long', 
      'manually_marked_outlier',
      'migration_stage', 
      'migration_stage_standard', 
      'study_id', 
      'timestamp', 
      'update_ts',
      'visible')
  
  params <- list()
  params$entity_type <- 'event'
  params$study_id <- study_id
  params$sensor_type_id <- 2365683 #GPS tag id is 653
  params$attributes <- paste(fields,collapse=',')
  qs <- makeQueryString(params)
  
  url <- sprintf('https://www.movebank.org/movebank/service/direct-read?%s',qs)
  return(url)
}


