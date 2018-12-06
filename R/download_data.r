
downloadMvData <- function(apiReq) {
  require(httr)
  #require(getPass)
  require(keyring)
  
  auth <- authenticate("ben.s.carlson", key_get('api'))
  resp <- GET(apiReq, auth)
  #'TODO: do some checking of outputs to make sure I got a good response
  cd <- resp$status_code==200
  #stopifnot(cd,sprintf('Failed with status code %s',cd))
  stop_for_status(resp)
  csvStr <- content(resp, as='text', encoding='UTF-8') #get the content as a text string, as recommened by the docs
  rows <- read.csv(text=csvStr,stringsAsFactors=FALSE) #read in the string into a dataframe
  return(rows)

}

