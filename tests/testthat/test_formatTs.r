context('formatTs')

test_that('formats correctly', {

  expect_equal(
    formatTs(as.POSIXct("2008-06-04 13:30:45",tz='UTC')),
    '20080604133045000'
  )

  #note ignores thousands of seconds (.999 below)
  expect_equal(
    formatTs(as.POSIXct("2008-06-04 13:30:45.999",tz='UTC')),
    '20080604133045000'
  )
})
