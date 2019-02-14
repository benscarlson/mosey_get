context('apiReq')

#Note these are based on examples in mb docs: https://github.com/movebank/movebank-api-doc/blob/master/movebank-api.md

test_that('Get event data for a single sensor type', {

  params <- list(
    'entity_type'='event',
    'study_id'=2911040,
    'attributes'=c('individual_id','timestamp','location_long','location_lat','visible'))

  expect_equal(
    apiReq(params),
    'https://www.movebank.org/movebank/service/direct-read?entity_type=event&study_id=2911040&attributes=individual_id,timestamp,location_long,location_lat,visible'
  )

})

test_that('Get event data for a single sensor type', {

  params <- list(
    'entity_type'='event',
    'study_id'=2911040,
    'sensor_type_id'=653)

  expect_equal(
    apiReq(params),
    'https://www.movebank.org/movebank/service/direct-read?entity_type=event&study_id=2911040&sensor_type_id=653'
  )

})

test_that('Get event data for an individual animal', {

  params <- list(
    'entity_type'='event',
    'study_id'=2911040,
    'individual_id'=2911059)

  expect_equal(
    apiReq(params),
    'https://www.movebank.org/movebank/service/direct-read?entity_type=event&study_id=2911040&individual_id=2911059'
  )

})

test_that('Get event data for a specified time period', {

  params <- list(
    'entity_type'='event',
    'study_id'=2911040,
    'timestamp_start'=as.POSIXct('2008-06-04 13:30:45', tz='UTC'),
    'timestamp_end'=as.POSIXct('2008-06-04 13:30:46', tz='UTC'))

  expect_equal(
    apiReq(params),
    'https://www.movebank.org/movebank/service/direct-read?entity_type=event&study_id=2911040&timestamp_start=20080604133045000&timestamp_end=20080604133046000'
  )

})
