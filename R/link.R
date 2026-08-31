#' Link enviPath objects
#' 
#' @name epLink
#' 
#' @description
#' epLink returns mappings between enviPath object types.
#' 
#' @param from \code{Character scalar}.
#' 
#' @param to \code{Character scalar}.
#' 
#' @param init \code{Character vector}.
#' 
#' @param pkg \code{Character scalar}.
#' 
#' @returns
#' A data frame with links between from and to.
#' 
#' @examples
#' rxn_id <- "2b6bbcc5-77f4-4bed-92a9-731cdc978f6a"
#' 
#' epGet("reaction", rxn_id)
NULL

#' @export
#' @rdname epLink
#' @importFrom BiocParallel bplapply
#' @importFrom stringr str_remove
epLink <- function(from, to, init = NULL, pkg = NULL){
    
    if( is.null(pkg) ) pkg <- "32de3cf4-e3e6-4168-956e-32fa5ddb0ce1"
    
    if( is.null(init) ) init <- epList(from, pkg)$id
    
    out <- bplapply(init, .ep_link, from = from, to = to, pkg = pkg)
    
    linkmap <- data.frame(x = rep(init, lengths(out)), y = unlist(out))
    
    to_remove <- vapply(linkmap$y, is.null, logical(1L))
    linkmap <- linkmap[!to_remove, ]
    
    # Remove id prefix
    linkmap$y <- str_remove(linkmap$y, ".*/")
    
    colnames(linkmap) <- c(from, to)
    rownames(linkmap) <- NULL
    
    return(linkmap)
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

