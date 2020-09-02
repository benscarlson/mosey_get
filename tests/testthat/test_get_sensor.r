context('get_sensor')

test_that('Get data', {

  studyid <- 2911040 #Galapagos Albatrosses, I have accepted license on website
  dat <- getSensor(studyid)
  expect_equal(class(dat),'data.frame')
})
