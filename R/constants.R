
#' @importFrom tools R_user_dir
.create_eP_env <- function(){
    # Initialise environment
    eP_env <- new.env()
    # Define the API endpoint
    eP_env$url <- "https://envipath.org/api/legacy/"
    # Create cache dir
    cache <- R_user_dir("enviPathR", "cache")
    if( !dir.exists(cache) ) dir.create(cache)
    # Preserve cookies between requests
    eP_env$cookies <- tempfile("cookies", tmpdir = cache, fileext = ".txt")
    return(eP_env)
}

eP_env <- .create_eP_env()
