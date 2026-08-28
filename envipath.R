
# relevant object types:
# package, compound, reaction, pathway (node & edge)


# relevant relations:

# compound -> pathway
# pathway -> node -> compound

# reaction -> pathway
# pathway -> edge -> reaction

# compound -> reaction
# reaction -> compound

# compound -> smiles
# compound -> inchi

# reaction -> rhea
# compound -> inchikey

# reaction -> ec (always empty, report)
# compound -> chebi (always empty, report)

# Could we get full rxn and full cpd dfs?


ep_login("X", "Y")

pkg_df <- ep_list("package")


pkg_name <- "EAWAG-BBD"
pkg_id <- pkg_df$id[pkg_df$name == pkg_name]

path_df <- ep_list("pathway", pkg = pkg_id)


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

pkg <- pkg_id
path <- path_id
edge <- edge_df$id[1]
node <- node_df$id[1]

req <- request(ep_url) |>
    req_url_path_append("package", pkg, "pathway", path, "node", node) |>
    req_cookie_preserve(path = cookie_file)

resp <- req_perform(req)

out <- resp_body_json(resp, simplifyVector = TRUE)





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


cpd_df <- ep_list("compound", pkg_id)

cpd_name <- "1-Methylnaphthalene"
cpd_id <- cpd_df$id[cpd_df$name == cpd_name]

ep_compound(cpd_id, pkg_id, "structure")
ep_compound(cpd_id, pkg_id)

pkg <- pkg_id
rxn <- "2b6bbcc5-77f4-4bed-92a9-731cdc978f6a"

req <- request(ep_url) |>
    req_url_path_append("package", pkg, "reaction", rxn) |>
    req_cookie_preserve(path = cookie_file)

resp <- req_perform(req)

out <- resp_body_json(resp, simplifyVector = TRUE)

df <- data.frame(out)
