
with_mock_dir("httptest/get", {
    
    test_that("get", {
        
        rxn_id <- "2b6bbcc5-77f4-4bed-92a9-731cdc978f6a"
        
        rxn <- epGet("reaction", rxn_id)
        
        expect_type(rxn, "list")
        expect_length(rxn, 15L)
    })
})