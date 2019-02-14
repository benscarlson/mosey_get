context('eventReq')

test_that('Get event data for a single sensor type', {

  expect_equal(
    eventReq(studyid=2911040, attributes='timestamp'),
    'https://www.movebank.org/movebank/service/direct-read?entity_type=event&study_id=2911040'
  )

})
