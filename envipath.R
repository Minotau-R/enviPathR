


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

epLink("pathway", "compound", path_df$id[1:3])

epLink("pathway", "reaction", path_df$id[1:3])

cpd_name <- "1-Methylnaphthalene"
cpd_id <- cpd_df$id[cpd_df$name == cpd_name]

epLink("compound", "structure", cpd_id)

path_objects <- epGet("pathway", path_df$id[1:50], pkg_id)

epGet("compound", cpd_id, pkg_id, "structure")

rxn_id <- "2b6bbcc5-77f4-4bed-92a9-731cdc978f6a"

epGet("reaction", rxn_id)

# This throws error when no rxns have rhea
epLink("reaction", "rhea", rxn_df$id[1:10])

epLink("compound", "inchikey", cpd_id)
epLink("compound", "smiles", cpd_id)

epLink("reaction", "compound", rxn_df$id[1:10])
