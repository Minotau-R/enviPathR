test_that("types", {
    
    types <- epTypes()
    
    expect_length(types, 2L)
    
    expect_named(types, c("listable", "linkable"))
    
    expect_type(types$listable, "character")
    expect_s3_class(types$linkable, "data.frame")
})