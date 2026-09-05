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
#' \dontshow{
#'     username <- Sys.getenv("EP_USERNAME")
#'     password <- Sys.getenv("EP_PASSWORD")
#'     
#'     epLogin(username, password)
#' 
#'     library(httptest2)
#'     start_vignette("httptest/link")
#' }
#' rxn_id <- "2b6bbcc5-77f4-4bed-92a9-731cdc978f6a"
#' 
#' epLink("reaction", "compound", rxn_id)
#' \dontshow{
#'     end_vignette()
#' }
NULL

#' @export
#' @rdname epLink
#' @importFrom BiocParallel bplapply
#' @importFrom stringr str_remove
#' @importFrom stats complete.cases
epLink <- function(from, to, init = NULL, pkg = NULL){
    
    if( is.null(pkg) ) pkg <- "32de3cf4-e3e6-4168-956e-32fa5ddb0ce1"
    
    if( is.null(init) ) init <- epList(from, pkg)$id
    
    by <- paste(from, to, sep = "2")
    specTo <- eP_env$links[[by]]

    out <- bplapply(init, .ep_link, from = from, to = specTo, pkg = pkg)
    
    linkmap <- data.frame(
        x = rep(init, lengths(out)),
        y = unlist(out, use.names = FALSE)
    )
    
    colnames(linkmap) <- c(from, to)
    
    linkmap <- linkmap[complete.cases(linkmap[[to]]), ]
    
    if( nrow(linkmap) == 0L ){
        warning("No bindings found", call. = FALSE)
        return(linkmap)
    }
    
    if( by == "pathway2compound" ){
        linkmap[to] <- str_remove(linkmap[[to]], "/structure/.*")
    }
    
    # Remove id prefix
    linkmap[to] <- str_remove(linkmap[[to]], ".*/")
    
    return(linkmap)
}


#' @importFrom httr2 request req_url_path_append req_cookie_preserve req_perform resp_body_json
.ep_link <- function(init, from, to, pkg){
    
    req <- request(eP_env$url) |>
        req_url_path_append("package", pkg, from, init) |>
        req_cookie_preserve(path = eP_env$cookies)
    
    resp <- req_perform(req)
    
    out <- resp_body_json(resp, simplifyVector = TRUE)
    
    out <- out[to[["item"]]] |>
        lapply(`[[`, to[["var"]]) |>
        unlist(use.names = FALSE)
    
    if( is.null(out) ) out <- NA
    
    return(out)
}

