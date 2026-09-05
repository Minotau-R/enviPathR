#' Log into enviPath account
#' 
#' @name epLogin
#' 
#' @description
#' epLogin lets you perform login to enviPath. An account is required to use the
#' enviPath API.
#' 
#' @param username \code{Character scalar}. String specifying the username
#' used to log into an enviPath personal account.
#' 
#' @param password \code{Character scalar}. String specifying the password
#' used to log into an enviPath personal account.
#' 
#' @returns
#' A message upon successful login.
#' 
#' @seealso
#' \itemize{
#'   \item enviPath front page: \url{https://envipath.org/}
#'   \item legacy API docs: \url{https://envipath.org/api/legacy/docs#/}
#' }
#' 
#' @examples
#' \dontshow{
#'     username <- Sys.getenv("EP_USERNAME")
#'     password <- Sys.getenv("EP_PASSWORD")
#' }
#' # Perform login
#' epLogin(username, password)
NULL

#' @export
#' @rdname epLogin
#' @importFrom httr2 request req_method req_body_form req_cookie_preserve req_perform
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
    message("Hi nature lover, welcome to enviPath!")
    invisible(NULL)
}
