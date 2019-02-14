context('get_data')

#Note these are based on examples in mb docs: https://github.com/movebank/movebank-api-doc/blob/master/movebank-api.md

test_that('getStudy: url is correct', {

  expect_equal(
    getStudy(2911040,urlonly=TRUE),
    paste0(API_URL,'?entity_type=study&study_id=2911040')
  )

})

test_that('getIndividual: url is correct', {

  expect_equal(
    getIndividual(2911040,urlonly=TRUE),
    paste0(API_URL,'?entity_type=individual&study_id=2911040')
  )

})

test_that('getTag: url is correct', {

  expect_equal(
    getTag(2911040,urlonly=TRUE),
    paste0(API_URL,'?entity_type=tag&study_id=2911040')
  )

})

test_that('getDeployment: url is correct', {

  expect_equal(
    getDeployment(2911040,urlonly=TRUE),
    paste0(API_URL,'?entity_type=deployment&study_id=2911040')
  )

})
