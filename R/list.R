
#' @importFrom httr2 req_url_path_append req_cookie_preserve req_perform resp_body_json
#' @importFrom stringr str_remove
#' @export
ep_list <- function(x, pkg = NULL){
    
    is_pkg <- !is.null(pkg)
    
    if( x == "package" && is_pkg ){
        stop("'pkg' cannot be defined when listing packages.", call. = FALSE)
    }
    
    req <- request(eP_env$url) |>
        req_cookie_preserve(eP_env$cookies)
    
    if( is_pkg ) req <- req_url_path_append(req, "package", pkg)
        
    req <- req_url_path_append(req, x)
    
    resp <- req_perform(req)
    
    out <- resp_body_json(resp, simplifyVector = TRUE)
    # Extract data.frame
    df <- out[[1L]]
    # Remove id prefix
    df$id <- str_remove(df$id, ".*/")
    
    to_keep <- c("name", "id", "reviewStatus")
    
    if( x == "package" ){
      
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
