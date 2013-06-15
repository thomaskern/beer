test_that("BIC is true",
          {expect_equal( round(BIC(train.all.models("y ~ x",data.frame(x=1:10,y=100:109),"","lm.linear_model",c(""))$all[[1]]$model), 4),-612.8818)}
          )
