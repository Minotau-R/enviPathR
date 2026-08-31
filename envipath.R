
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

# Could we get full rxn and full cpd dfs from path?

epLogin("X", "Y")

pkg_df <- epList("package")

pkg_name <- "EAWAG-BBD"
pkg_id <- pkg_df$id[pkg_df$name == pkg_name]

path_df <- epList("pathway", pkg = pkg_id)

path_name <- "Naphthalene"
path_id <- path_df$id[path_df$name == path_name]

rule_df <- epList("rule", pkg = pkg_id)
rule_id <- "507b2719-da61-4793-87fc-2d4ae9c20ce9"

rxn_df <- epList("reaction", pkg = pkg_id)
cpd_df <- epList("compound", pkg = pkg_id)

rxn2path <- epLink("reaction", "pathways", rxn_df$id[1:10])

cpd2rxn <- epLink("compound", "reactions", cpd_df$id[1:10])

cpd2path <- epLink("compound", "pathways", cpd_df$id[1:10])

# epLink("compound", "structures", cpd_id)
# epLink("pathway", "nodes", path_id)
# epLink("pathway", "links", path_id)

cpd_df <- epList("compound", pkg_id)

cpd_name <- "1-Methylnaphthalene"
cpd_id <- cpd_df$id[cpd_df$name == cpd_name]

path_objects <- epGet("pathway", pkg_id, init = path_df$id[1:50])

epGet(cpd_id, pkg_id, "structure")

rxn_id <- "2b6bbcc5-77f4-4bed-92a9-731cdc978f6a"

epGet(rxn_id, "reaction")

