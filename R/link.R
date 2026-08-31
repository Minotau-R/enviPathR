
#' @export
#' @importFrom BiocParallel bpmapply
#' @importFrom stringr str_remove
epLink <- function(from, to, init = NULL, pkg = NULL){
    
    if( is.null(pkg) ) pkg <- "32de3cf4-e3e6-4168-956e-32fa5ddb0ce1"
    
    if( is.null(init) ) init <- epList(from, pkg)$id
    
    out <- bpmapply(
        .ep_link,
        init,
        MoreArgs = list(from = from, to = to, pkg = pkg)
    )
    
    to_remove <- vapply(out, is.null, logical(1L))
    out <- out[!to_remove]
    
    # Remove id prefix
    out <- str_remove(out, ".*/")
    
    df <- data.frame(names(out), out)
    
    colnames(df) <- c(from, to)
    rownames(df) <- NULL
    
    return(df)
}


#' @importFrom httr2 request req_url_path_append req_cookie_preserve req_perform resp_body_json
.ep_link <- function(init, from, to, pkg){
    
    req <- request(eP_env$url) |>
        req_url_path_append("package", pkg, from, init) |>
        req_cookie_preserve(path = eP_env$cookies)
    
    resp <- req_perform(req)
    
    out <- resp_body_json(resp, simplifyVector = TRUE)
    
    out <- out[[to]]$id
    
    return(out)
}

