
library(httptest2)

username <- Sys.getenv("EP_USERNAME")
password <- Sys.getenv("EP_PASSWORD")

epLogin(username, password)