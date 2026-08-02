
library(httr2)
library(jsonlite)
library(stringr)

# Define the API endpoint
ep_url <- "https://envipath.org/api/legacy/"

# Persist cookies between requests (similar to session in Python client)
cookie_file <- tempfile("envipath_cookies_", fileext = ".txt")

ep_login <- function(username, password){
    
    # Send login request
    req <- request(ep_url) |>
        req_method("POST") |>
        req_body_form(
            hiddenMethod  = "login",
            loginusername = username,
            loginpassword = password
        ) |>
        req_cookie_preserve(path = cookie_file)
    
    resp <- req_perform(req)
    
    invisible(NULL)
}


ep_login("X", "Y")

# 2) Query package

pkg_id <- "32de3cf4-e3e6-4168-956e-32fa5ddb0ce1"

ep_packages <- function(){

    req <- request(ep_url) |>
        req_url_path_append("package") |>
        req_cookie_preserve(path = cookie_file)
    
    resp <- req_perform(req)
    
    out <- resp_body_json(resp, simplifyVector = TRUE)
    
    df <- out[[1L]]
    
    obj.types <- names(df$links[[1L]])
    obj.counts <- vapply(obj.types, .extract_obj_counts, numeric(nrow(df)), df)
    
    pkg_cols <- c("name", "id", "description", "reviewStatus")
    df <- df[ , pkg_cols]
    
    df$id <- str_remove(df$id, ".*/")
    
    df <- cbind(df, obj.counts)
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

df <- ep_packages()


ep_pathways <- function(pkg){
    
    req <- request(ep_url) |>
        req_url_path_append("package", pkg, "pathway") |>
        req_cookie_preserve(path = cookie_file)
    
    resp <- req_perform(req)
    
    out <- resp_body_json(resp, simplifyVector = TRUE)
    
    df <- out[[1L]]
    
    df$id <- str_remove(df$id, ".*/")
    
    df <- df[ , c("name", "id", "reviewStatus")]
    return(df)
}

pkg_name <- "EAWAG-BBD"
pkg_id <- df$id[df$name == pkg_name]

path_df <- ep_pathways(pkg_id)

path_name <- "Naphthalene"
path_id <- path_df$id[path_df$name == path_name]

ep_pathway <- function(path, pkg, what){
    
    req <- request(ep_url) |>
        req_url_path_append("package", pkg, "pathway", path, what) |>
        req_cookie_preserve(path = cookie_file)
    
    resp <- req_perform(req)
    
    out <- resp_body_json(resp, simplifyVector = TRUE)
    
    df <- out[[1L]]
    
    df$id <- str_remove(df$id, ".*/")
    
    df <- df[ , c("name", "id", "reviewStatus")]
    return(df)
}

edge_df <- ep_pathway(path_id, pkg_id, "edge")
node_df <- ep_pathway(path_id, pkg_id, "node")






ep_compounds <- function(pkg){
    
    req <- request(ep_url) |>
        req_url_path_append("package", pkg, "compound") |>
        req_cookie_preserve(path = cookie_file)
    
    resp <- req_perform(req)
    
    out <- resp_body_json(resp, simplifyVector = TRUE)
    
    df <- out[[1L]]
    
    df$id <- str_remove(df$id, ".*/")
    
    df <- df[ , c("name", "id", "reviewStatus")]
    return(df)
}

ep_compound <- function(cpd, pkg, what = NULL){
    
    req <- request(ep_url) |>
        req_url_path_append("package", pkg, "compound", cpd, what) |>
        req_cookie_preserve(path = cookie_file)
    
    resp <- req_perform(req)
    
    out <- resp_body_json(resp, simplifyVector = TRUE)
    
    df <- out[[1L]]
    
    df$id <- str_remove(df$id, ".*/")
    
    df <- df[ , c("name", "id", "reviewStatus")]
    return(df)
}


cpd_df <- ep_compounds(pkg_id)

cpd_name <- "1-Methylnaphthalene"
cpd_id <- cpd_df$id[cpd_df$name == cpd_name]

ep_compound(cpd_id, pkg_id, "structure")
ep_compound(cpd_id, pkg_id)


