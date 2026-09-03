#' List enviPath objects
#' 
#' @name epList
#' 
#' @description
#' epList returns a list with info on objects available in enviPath.
#' 
#' @param type \code{Character scalar}.
#' 
#' @param pkg \code{Character scalar}.
#' 
#' @returns
#' A data frame.
#' 
#' @examples
#' \donttest{
#' epLogin("username", "password")
#' 
#' epList("package")
#' 
#' epList("pathway", pkg = "32de3cf4-e3e6-4168-956e-32fa5ddb0ce1")
#' }
NULL

#' @export
#' @rdname epList
#' @importFrom httr2 req_url_path_append req_cookie_preserve req_perform resp_body_json
#' @importFrom stringr str_remove
epList <- function(type, pkg = NULL){
    
    is_pkg <- !is.null(pkg)
    
    if( type == "package" && is_pkg ){
        stop("'pkg' cannot be defined when listing packages.", call. = FALSE)
    }
    
    req <- request(eP_env$url) |>
        req_cookie_preserve(eP_env$cookies)
    
    if( is_pkg ) req <- req_url_path_append(req, "package", pkg)
        
    req <- req_url_path_append(req, type)
    
    resp <- req_perform(req)
    
    out <- resp_body_json(resp, simplifyVector = TRUE)
    # Extract data.frame
    df <- out[[1L]]
    # Remove id prefix
    df$id <- str_remove(df$id, ".*/")
    
    to_keep <- c("name", "id", "reviewStatus")
    
    if( type == "package" ){
      
        obj.types <- names(df$links[[1L]])
        obj.counts <- vapply(obj.types, .extract_obj_counts, numeric(nrow(df)), df)
      
        df <- cbind(df, obj.counts)
        to_keep <- c(to_keep, "description", obj.types)
    }
    # Select relevant columns
    df <- df[ , to_keep]
    return(df)
}


.extract_obj_counts <- function(obj.type, df){
    
    counts <- vapply(
        df$links,
        function(x){ y <- unlist(x[[obj.type]]); as.numeric(y[[2L]]) },
        FUN.VALUE = numeric(1L)
    )
    
    return(counts)
}
