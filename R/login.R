#' Log into enviPath account
#' 
#' @name epLogin
#' 
#' @description
#' epLogin lets you perform login to enviPath. An account is required to use the
#' enviPath API. (add db link to refs)
#' 
#' @param username \code{Character scalar}.
#' 
#' @param password \code{Character scalar}.
#' 
#' @returns
#' A message upon successful login.
#' 
#' @examples
#' # epLogin("FirstLast", "abc123")
#' #> Welcome to enviPath!
NULL

#' @importFrom httr2 request req_method req_body_form req_cookie_preserve req_perform
#' @export
epLogin <- function(username, password){
    # Prepare login request
    req <- request(eP_env$url) |>
        req_method("POST") |>
        req_body_form(
            hiddenMethod  = "login",
            loginusername = username,
            loginpassword = password
        ) |>
        req_cookie_preserve(path = eP_env$cookies)
    # Perform login request
    resp <- req_perform(req)
    # Print message upon successful login
    message("Hi ", username, ", welcome to enviPath!")
    invisible(NULL)
}
