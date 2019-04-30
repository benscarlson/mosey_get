library(getPass)
library(httr)
library(testthat)
library(rmoveapi)

setAuth(getPass(msg='Userid'),getPass(msg='Password'))
# options(rmoveapi.userid=getPass(msg='User id'))
# options(rmoveapi.pass=getPass(msg='User id'))

test_check("rmoveapi")
