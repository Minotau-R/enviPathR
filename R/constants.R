
#' @importFrom tools R_user_dir
.create_eP_env <- function(){
    
    eP_env <- new.env()
    
    # Define the API endpoint
    eP_env$url <- "https://envipath.org/api/legacy/"
    
    # Persist cookies between requests
    cache <- R_user_dir("enviPathR", "cache")
    
    if( !dir.exists(cache) ) dir.create(cache)
    
    eP_env$cookies <- tempfile("cookies", tmpdir = cache, fileext = ".txt")
    
    return(eP_env)
}

eP_env <- .create_eP_env()
