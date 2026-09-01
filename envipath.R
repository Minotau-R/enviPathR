
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

rxn2path <- epLink("reaction", "pathway", rxn_df$id[1:10])

cpd2rxn <- epLink("compound", "reaction", cpd_df$id[1:10])

cpd2path <- epLink("compound", "pathway", cpd_df$id[1:10])

epLink("pathway", "node", path_df$id[1:10])
epLink("pathway", "edge", path_df$id[1:10])

# Now giving struct ids (instead of cpd ids)
epLink("pathway", "compound", path_df$id[1:3])
# Empty (report)
epLink("pathway", "reaction", path_df$id[1:3])

cpd_name <- "1-Methylnaphthalene"
cpd_id <- cpd_df$id[cpd_df$name == cpd_name]

epLink("compound", "structure", cpd_id)

path_objects <- epGet("pathway", path_df$id[1:50], pkg_id)

epGet("compound", cpd_id, pkg_id, "structure")

rxn_id <- "2b6bbcc5-77f4-4bed-92a9-731cdc978f6a"

epGet("reaction", rxn_id)

