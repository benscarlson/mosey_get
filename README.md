# rmoveapi

## Overview

This is a light-weight wrapper around the movebank api.

https://github.com/movebank/movebank-api-doc

https://www.movebank.org/movebank/service/direct-read?attributes

Movebank api closely follows the movebank data model.

https://www.movebank.org/node/9

## Installation

```r
library(devtools)
install_github('benscarlson/rmoveapi')
```

## Usage

### Initialize

Need to set two package-level options for userid and password.
Note password is stored in cleartext within R, so be careful!

```r
library(rmoveapi)
library(getPass)

options(rmoveapi.userid='my.user.id')
options(rmoveapi.pass=getPass())
```

### Simple examples

```r
studyid <- 123413

getStudy(studyid)

getIndividual(studyid)

getTag(studyid)

getDeployment(studyid)

```

### Additional features

Can use params argument to pass in arbitrary key/value pairs. All get*() functions accept the params argument.

```r

studyid <- 123413

params <- list(attributes=c('id','ring_id','local_identifer'))

getIndividual(studyid,params=params)

```


