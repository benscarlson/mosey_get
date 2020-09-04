library(getPass)
library(glue)
library(httr)
library(testthat)
library(rmoveapi)

#devtools::document(); devtools::build(); devtools::load_all()

setAuth(getPass(msg='Userid'),getPass(msg='Password'))
# options(rmoveapi.userid=getPass(msg='User id'))
# options(rmoveapi.pass=getPass(msg='User id'))

test_check("rmoveapi")
