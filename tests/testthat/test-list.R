
test_that("list", {
  
    epLogin(username, password)
    
    pkg_df <- epList("package")
    
    expect_23_class(pkg_df, "data.frame")
    
    expect_length(pkg_df, 10L)
    
})