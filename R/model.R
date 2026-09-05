#' Predict biotransformation pathways for compounds
#' 
#' @name epModel
#' 
#' @description
#' epGet returns a raw object from enviPath.
#' 
#' @param smiles \code{Character vector}.
#' 
#' @param setting \code{Character scalar}.
#' 
#' @returns
#' A list with two data frames with information on nodes and edges,
#' respectively.
#' 
#' @examples
#' \dontrun{
#' library(igraph)
#' 
#' # Perform login
#' epLogin("username", "password")
#' 
#' # List available model settings
#' epList("setting")
#' 
#' # Define smiles of interest
#' smiles <- "ClC(Cl)=C(Cl)Cl"
#' 
#' # Perform pathway prediction with enviFormer
#' former_out <- epModel(smiles)
#' 
#' # Set id for PEPPER model setting
#' setting_id <- "3cda8e56-f4ff-47a8-b68c-4cfcfc4e8c2a"
#' 
#' # Perform pathway prediction with PEPPER
#' pepper_out <- epModel(smiles, setting_id)
#' 
#' # Convert model output to igraph object
#' path_graph <- graph_from_data_frame(
#'     pepper_out$edges,
#'     vertices = pepper_out$nodes
#' )
#' 
#' # Visualise predicted pathway
#' plot(path_graph)
#' }
NULL

#' @export
#' @rdname epModel
#' @importFrom httr2 request req_method req_url_path_append req_body_form req_cookie_preserve req_perform resp_body_json
epModel <- function(smiles, setting = NULL){
    
    if( smiles == "" ){
        stop("'smiles' must be a valid SMILES string.", call. = FALSE)
    }
    
    if( is.null(setting) ) setting <- "1d915a48-286a-4394-9693-bfaa187326a5"
    
    setting <- paste0("https://envipath.org/setting/", setting)
    
    req <- request(eP_env$url) |>
        req_method("POST") |>
        req_url_path_append("util") |>
        req_body_form(smiles = smiles, settingUri = setting) |>
        req_cookie_preserve(path = eP_env$cookies)
    
    resp <- req_perform(req)
    
    out <- resp_body_json(resp, simplifyVector = TRUE)
    
    if( is.data.frame(out$edges$rule) ){
        out$edges$ruleId <- out$edges$rule$uuid
        out$edges$ruleName <- out$edges$rule$name
        out$edges$rule <- NULL
    }
    
    out$nodes$name <- out$nodes$smiles
    out$nodes$smiles <- NULL
    
    out$nodes <- out$nodes[c("id", "name", "depth")]
    return(out)
}