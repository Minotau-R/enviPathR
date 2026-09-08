#' enviPathR: the R client for the enviPath RESTful API
#' 
#' @name enviPathR
#' 
#' @description
#' The environmental pathway database (enviPath) is a key resource for the
#' functional annotation and pathway prediction of microbial communities,
#' providing knowledge on biotransformation pathways along with the chemical
#' reactions and produced compounds. This package enables the programmatic
#' access to enviPath by porting the database API from R.
#' 
#' @seealso
#' \itemize{
#'   \item enviPath front page: \url{https://envipath.org/}
#'   \item legacy API docs: \url{https://envipath.org/api/legacy/docs#/}
#' }
"_PACKAGE"
NULL

.make_ep_dbs <- function(){
    c("compound", "package", "pathway", "reaction", "rule", "setting")
}

.make_ep_links <- function(){
    list(
        compound2inchikey = c(item = "structures", var = "inchikey"),
        compound2pathway = c(item = "pathways", var = "id"),
        compound2reaction = c(item = "reactions", var = "id"),
        compound2smiles = c(item = "structures", var = "smiles"),
        compound2structure = c(items = "structures", var = "id"),
        pathway2compound = c(item = "nodes", var = "idcomp"),
        pathway2edge = c(item = "links", var = "id"),
        pathway2node = c(item = "nodes", var = "id"),
        pathway2reaction = c(item = "links", var = "idreaction"),
        pathway2structure = c(item = "nodes", var = "idcomp"),
        reaction2compound = list(item = c("educts", "products"), var = "id"),
        reaction2ec = c(item = "ecNumbers", var = "id"),
        reaction2pathway = c(item = "pathways", var = "id"),
        reaction2rhea = c(item = "references", var = "rheaReferences")
    )
}

#' @importFrom tools R_user_dir
.create_eP_env <- function(){
    # Initialise environment
    eP_env <- new.env()
    # Define the API endpoint
    eP_env$url <- "https://envipath.org/api/legacy/"
    # Create cache dir
    cache <- R_user_dir("enviPathR", "cache")
    if( !dir.exists(cache) ) dir.create(cache, recursive = TRUE)
    # Preserve cookies between requests
    eP_env$cookies <- file.path(cache, "cookies.txt")
    # Add database types
    eP_env$dbs <- .make_ep_dbs()
    # Add links
    eP_env$links <- .make_ep_links()
    return(eP_env)
}

eP_env <- .create_eP_env()
