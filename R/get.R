
#' @export
#' @importFrom BiocParallel bplapply
epGet <- function(type, pkg, init = NULL, property = NULL){
    
    if( is.null(init) ) init <- epList(type, pkg)$id
    
    out <- bplapply(init, .ep_get, type = type, pkg = pkg, property = property)
    return(out)
} 

.ep_get <- function(init, type, pkg, property = NULL){
    
    req <- request(eP_env$url) |>
        req_url_path_append("package", pkg, type, init) |>
        req_cookie_preserve(path = eP_env$cookies)
    
    if( !is.null(property) ) req <- req_url_path_append(req, property)
    
    resp <- req_perform(req)
    
    out <- resp_body_json(resp, simplifyVector = TRUE)
    
    return(out)
}
