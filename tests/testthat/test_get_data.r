context('get_data')

#Note these are based on examples in mb docs: https://github.com/movebank/movebank-api-doc/blob/master/movebank-api.md
#TODO: these tests might not work correctly due to various data permissions on the studies. See below for more information.
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

#TODO: Need to update these tests.
# Test that requires accept license should test that data can't be
# downloaded without accepting license first.
# seperate the set of tests for accepting license and for in-memory vs. save to disk tests.

# Different permission scenarios
# 1) public studies, can download data w/o accepting terms
# 2) studies I have permission to download, and have already accepted terms
# 3) studies I have permission to download, but have not yet accepted terms
# 4) studies I dont have permission to download
#
# It is hard to find an example of #2.

#This is the most recent test, should update others to reflect this one
test_that('getMvData: test that stripping /r/n and triming works', {

  #10449318 LifeTrack White Stork Loburg
  # study$grants_used contains field with an \n
  # individual$death_comments contains field with an \n
  # tag$comments contains field with an \n

  req <- list(
      entity_type='study',
      study_id=10449318 #LifeTrack White Stork Loburg
    ) %>% apiReq

  #grants_used field in this study has \n character
  #Need to find positive test cases for \r and \r\n and whitespace in begining and end
  dat1 <- getMvData(req,clean=FALSE)

  expect_true(stringr::str_detect(dat1$grants_used,'[\r\n]'))

  dat2 <- getMvData(req) #Default is to clean the fields

  expect_false(stringr::str_detect(dat2$grants_used,'[\r\n]')) #Check for nonprinting line breaks
  expect_false(stringr::str_detect(dat2$grants_used,'^\\s+')) #Check for white space in beginning
  expect_false(stringr::str_detect(dat2$grants_used,'\\s+$')) #Check for white space at end

  req <- list(
    entity_type='tag',
    study_id=10449318 #LifeTrack White Stork Loburg
  ) %>% apiReq

  dat2 <- getMvData(req,clean=FALSE) #Default is to clean the fields
})


test_that('getMvData: get data, permission to download and already accepted license on movebank', {
  #2911040 Name: Galapagos Albatrosses
  apiReq <- 'https://www.movebank.org/movebank/service/direct-read?entity_type=event&timestamp_start=20080531000000000&timestamp_end=20080601000000000&study_id=2911040'
  dat <- getMvData(apiReq)
  expect_true('data.frame' %in% class(dat))
})

test_that('getMvData: get data, permission to download, but have not accepted license, accept_license=FALSE', {
  # 123413 BCI Ocelot
  #685178886 is the test study from the German developer
  #	10449318 LifeTrack White Stork Loburg - I have permission but need to accept license
  # 577947076 Lower 48 GOEA Migration
  apiReq <- 'https://www.movebank.org/movebank/service/direct-read?entity_type=event&study_id=123413'
  #if accepted license anywhere in r session, then don't need to accept again
  # to force a new session, use handle('')
  dat <- getMvData(apiReq,handle=handle(''))
  expect_equal(dat,NULL)
})

#Note this gets individual, not event (easier to test)
#API seems like it is not working for this one
test_that('getMvData: get data, permission to download, but have not accepted license, accept_license=TRUE', {
  # 123413 BCI Ocelot
  #685178886 is the test study from the German developer
  #	10449318 LifeTrack White Stork Loburg - I have permission but need to accept license
  # 577947076 Lower 48 GOEA Migration
  .studyId <- 21231406	#LifeTrack White Stork SWGermany 2014-2018

  apiReq <- glue('https://www.movebank.org/movebank/service/direct-read?entity_type=individual&study_id={.studyId}')
  #if accepted license anywhere in r session, then don't need to accept again
  # to force a new session, use handle('')
  dat <- getMvData(apiReq,accept_license=TRUE,handle=handle(''))
  expect_equal(dat,NULL)
})

#TODO: I think this is supposed to fail, but it is working
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

#TODO: gets data but maybe not accepting license correctly
#TODO: Some strange behavior with 500 error when doing handle(''), but then it worked correctly.
test_that('getMvData: get data, need to accept license, write to memory, accept_license==TRUE', {
  #685178886 is the test study from the German developer

  apiReq <- 'https://www.movebank.org/movebank/service/direct-read?entity_type=event&study_id=685178886'
  #if accepted license anywhere in r session, then don't need to accept again, so need to force a new session
  # to force a new session, use handle('')
  dat <- getMvData(apiReq,accept_license=TRUE,handle=handle('')) #
  expect_equal(class(dat),'data.frame')
})

#This is working, but I think I can get this data without accepting license
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

