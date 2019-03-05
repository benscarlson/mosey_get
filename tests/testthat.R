library(getPass)
library(httr)
library(testthat)
library(rmoveapi)


options(rmoveapi.userid=getPass())
options(rmoveapi.pass=getPass())

test_check("rmoveapi")
