
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
    message("Welcome to enviPath!")
    invisible(NULL)
}
