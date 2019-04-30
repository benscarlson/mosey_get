context('get_data')

#TODO: somewhere (maybe in testthat.R) need to set username & pass
#Note these are based on examples in mb docs: https://github.com/movebank/movebank-api-doc/blob/master/movebank-api.md

test_that('getStudy: url is correct', {

  expect_equal(
    getStudy(2911040,urlonly=TRUE),
    paste0(API_URL,'?entity_type=study&study_id=2911040')
  )

})

test_that('getStudy: get data', {
  #685178886 is the test study from the German developer
  studyId <- 685178886
  dat <- getStudy(685178886)
  expect_equal(class(dat),'data.frame')
})

#---- Test getIndividual ----#

test_that('getIndividual: url is correct', {

  expect_equal(
    getIndividual(2911040,urlonly=TRUE),
    paste0(API_URL,'?entity_type=individual&study_id=2911040')
  )

})

test_that('getIndividual: accept license', {
  #685178886 is the test study from the German developer
  studyId <- 685178886
  dat <- getIndividual(685178886,accept_license=TRUE)
  expect_equal(class(dat),'data.frame')
})

#---- Test getTag ----#

test_that('getTag: url is correct', {

  expect_equal(
    getTag(2911040,urlonly=TRUE),
    paste0(API_URL,'?entity_type=tag&study_id=2911040')
  )

})

test_that('getTag: accept license', {
  #685178886 is the test study from the German developer
  studyId <- 685178886
  dat <- getTag(685178886,accept_license=TRUE)
  expect_equal(class(dat),'data.frame')
})

#---- Test getDeployment ----#

test_that('getDeployment: url is correct', {
  expect_equal(
    getDeployment(2911040,urlonly=TRUE),
    paste0(API_URL,'?entity_type=deployment&study_id=2911040')
  )
})

test_that('getDeployment: accept license', {
  #685178886 is the test study from the German developer
  studyId <- 685178886
  dat <- getDeployment(685178886,accept_license=TRUE)
  expect_equal(class(dat),'data.frame')
})

#-----------------------#
#---- Test getEvent ----#
#-----------------------#

test_that('getEvent: accept license', {
  #685178886 is the test study from the German developer
  studyId <- 685178886
  dat <- getEvent(685178886,accept_license=TRUE)
  expect_equal(class(dat),'data.frame')
})

test_that('getEvent: defaults', {
  #123413 is the test study from the German developer
  studyId <- 685178886 #BCI Ocelot. Has radio-tag data, not gps. Need to accept license terms
  #attributes <- c('event_id','individual_id','location_long','location_lat','timestamp','ground_speed','sensor_type_id','manually_marked_outlier','visible')
  dat <- getEvent(studyId,accept_license=TRUE) #sensor_type_id=NULL,
  expect_equal(class(dat),'data.frame')
})

test_that('getEvent: get gps data', {
  #123413 is the test study from the German developer
  studyId <- 2911040 #Galaposgos Albatrosses. GPS (653) and ACC (2365683) data. I have accepted license terms
  attributes <- c('event_id','individual_id','location_long','location_lat','timestamp','ground_speed','sensor_type_id','manually_marked_outlier','visible')
  dat <- getEvent(studyId,attributes,sensor_type_id=653) #,sensor_type_id=2365683,accept_license=TRUE,,urlonly=TRUE
  expect_equal(unique(dat$sensor_type_id),653)
})

test_that('getEvent: get gps data', {
  #123413 is the test study from the German developer
  studyId <- 2911040 #Galaposgos Albatrosses. GPS (653) and ACC (2365683) data. I have accepted license terms
  attributes <- c('event_id','individual_id','location_long','location_lat','timestamp','ground_speed','sensor_type_id','manually_marked_outlier','visible')
  dat <- getEvent(studyId,attributes,sensor_type_id=2365683) #,sensor_type_id=2365683,accept_license=TRUE,,urlonly=TRUE
  expect_equal(unique(dat$sensor_type_id),2365683)
})

#------------------------#
#---- Test getMvData ----#
#------------------------#

test_that('getMvData: get data, already accepted license on movebank', {
  #2911040 Name: Galapagos Albatrosses
  apiReq <- 'https://www.movebank.org/movebank/service/direct-read?entity_type=event&timestamp_start=20080531000000000&timestamp_end=20080601000000000&study_id=2911040'
  dat <- getMvData(apiReq)
  expect_equal(class(dat),'data.frame')
})

test_that('getMvData: get data, need to accept license, write to memory, accept_license=FALSE', {
  #685178886 is the test study from the German developer
  apiReq <- 'https://www.movebank.org/movebank/service/direct-read?entity_type=event&study_id=685178886'
  #if accepted license anywhere in r session, then don't need to accept again
  # to force a new session, use handle('')
  dat <- getMvData(apiReq,handle=handle(''))
  expect_equal(dat,NULL)
})

test_that('getMvData: get data, need to accept license, write to disk, accept_license==FALSE', {
  #685178886 is the test study from the German developer
  tempP <- tempdir()
  tempPF <- tempfile(tmpdir=tempP,fileext='.csv')

  apiReq <- 'https://www.movebank.org/movebank/service/direct-read?entity_type=event&study_id=685178886'
  #if accepted license anywhere in r session, then don't need to accept again, so need to force a new session
  # to force a new session, use handle('')
  dat <- getMvData(apiReq,save_as=tempPF,handle=handle(''))
  expect_equal(dat,NULL)
})

#TODO: Some strange behavior with 500 error when doing handle(''), but then it worked correctly.
test_that('getMvData: get data, need to accept license, write to memory, accept_license==TRUE', {
  #685178886 is the test study from the German developer

  apiReq <- 'https://www.movebank.org/movebank/service/direct-read?entity_type=event&study_id=685178886'
  #if accepted license anywhere in r session, then don't need to accept again, so need to force a new session
  # to force a new session, use handle('')
  dat <- getMvData(apiReq,accept_license=TRUE,handle=handle('')) #
  expect_equal(class(dat),'data.frame')
})

test_that('getMvData: get data, need to accept license, write to disk, accept_license==TRUE', {
  #685178886 is the test study from the German developer
  tempP <- tempdir()
  tempPF <- tempfile(tmpdir=tempP,fileext='.csv')

  apiReq <- 'https://www.movebank.org/movebank/service/direct-read?entity_type=event&study_id=685178886'
  #if accepted license anywhere in r session, then don't need to accept again, so need to force a new session
  # to force a new session, use handle('')
  dat <- getMvData(apiReq, save_as=tempPF, accept_license=TRUE,handle=handle('')) #
  expect_true(dat)
})

