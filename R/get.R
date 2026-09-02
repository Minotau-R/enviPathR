#' Get enviPath objects
#' 
#' @name epGet
#' 
#' @description
#' epGet returns a raw object from enviPath.
#' 
#' @param type \code{Character scalar}.
#' 
#' @param init \code{Character vector}.
#' 
#' @param pkg \code{Character scalar}.
#' 
#' @param property \code{Character scalar}.
#' 
#' @returns
#' A list of objects
#' 
#' @examples
#' \dontshow{
#'     username <- Sys.getenv("EP_USERNAME")
#'     password <- Sys.getenv("EP_PASSWORD")
#'     eP_env$cookies <- file.path(Sys.getenv("GITHUB_WORKSPACE"), "eP_cookies")
#' }
#' epLogin(username, password)
#' 
#' rxn_id <- "2b6bbcc5-77f4-4bed-92a9-731cdc978f6a"
#' 
#' epGet("reaction", rxn_id)
NULL

#' @export
#' @rdname epGet
#' @importFrom BiocParallel bpmapply
epGet <- function(type, init = NULL, pkg = NULL, property = NULL){
    
    if( is.null(pkg) ) pkg <- "32de3cf4-e3e6-4168-956e-32fa5ddb0ce1"
    
    if( is.null(init) ) init <- epList(type, pkg)$id
    
    out <- bpmapply(
        .ep_get,
        init,
        MoreArgs = list(type = type, pkg = pkg, property = property),
        SIMPLIFY = FALSE
    )
    
    if( length(out) == 1L ) out <- out[[1L]]
    
    return(out)
} 

#' @importFrom httr2 request req_url_path_append req_cookie_preserve req_perform resp_body_json
.ep_get <- function(init, type, pkg, property = NULL){
    
    req <- request(eP_env$url) |>
        req_url_path_append("package", pkg, type, init) |>
        req_cookie_preserve(path = eP_env$cookies)
    
    if( !is.null(property) ) req <- req_url_path_append(req, property)
    
    resp <- req_perform(req)
    
    out <- resp_body_json(resp, simplifyVector = TRUE)
    
    return(out)
}
