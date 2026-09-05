
test_that("list", {
      
    pkg_df <- epList("package")
      
    expect_s3_class(pkg_df, "data.frame")
      
    expect_length(pkg_df, 10L)
})
