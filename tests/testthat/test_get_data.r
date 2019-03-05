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
  stuydId <- 685178886
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
  stuydId <- 685178886
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
  stuydId <- 685178886
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
  stuydId <- 685178886
  dat <- getDeployment(685178886,accept_license=TRUE)
  expect_equal(class(dat),'data.frame')
})

#---- Test getEvent ----#
test_that('getEvent: accept license', {
  #685178886 is the test study from the German developer
  stuydId <- 685178886
  dat <- getEvent(685178886,accept_license=TRUE)
  expect_equal(class(dat),'data.frame')
})

#---- Test getMvData ----#
test_that('getMvData: do not accept license', {
  #685178886 is the test study from the German developer
  apiReq <- 'https://www.movebank.org/movebank/service/direct-read?entity_type=event&study_id=685178886'
  expect_equal(getMvData(apiReq,handle=handle('')),NULL)
})

test_that('getMvData: accept license', {
  #685178886 is the test study from the German developer
  apiReq <- 'https://www.movebank.org/movebank/service/direct-read?entity_type=event&study_id=685178886'
  dat <- getMvData(apiReq,accept_license=TRUE)
  expect_equal(class(dat),'data.frame')
})


