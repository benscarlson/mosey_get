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

To see the api request url without actually making the request, use urlonly=TRUE

```r

studyid <- 123413

getStudy(studyid,urlonly=TRUE)

```

getStudy() can accept a vector of study ids, but other get*() functions can't.

```r

studyid <- c(123413,282734839)

getStudy(studyid)

```

Certain studies require you to accept license terms before downloading any data. One way to do this is to accept these terms on movebank.com. Terms can also be accepted over the api by using accept_license=TRUE in the request for data.

```r

studyid <- 685178886

dat <- getEvent(studyid,accept_license=TRUE)

head(dat)

```

By default, get*() functions write the data received from the server to memory. Some datasets are too large to store in memory. In these cases, you can use `save_as` parameter to save the result directly to disk.

```r

studyid <- 685178886

getEvent(studyid,save_as='~/scratch/data.csv',accept_license=TRUE)

```
