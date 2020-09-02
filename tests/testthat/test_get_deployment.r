context('get_deployment')

test_that('Already accepted license', {

  studyid <- 2911040 #Galapagos Albatrosses, I have accepted license on website
  dat <- getDeployment(studyid)
  expect_true('tbl' %in% class(dat))
})

#---- Test getDeployment ----#

test_that('getDeployment: url is correct', {
  expect_equal(
    getDeployment(2911040,urlonly=TRUE),
    paste0(API_URL,'?entity_type=deployment&study_id=2911040')
  )
})

test_that('accept license', {
  # is the test study from the German developer
  #TODO: this test is not hitting the code that accepts license, becuase it's not getting license text from
  # the API. So this is *not* a valid test.
  studyid <- 685178886
  dat <- getDeployment(studyid,accept_license=TRUE,handle=handle(''))
  expect_equal(class(dat),'data.frame')
})
