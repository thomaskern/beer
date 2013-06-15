test_that("shorten tokenizes correctly",{
  expect_equal(shorten(",word important"),",wor imp")
  expect_equal(shorten("word important,"),"wor imp")
  expect_equal(shorten("word,important"),"wor,imp")
  expect_equal(shorten("word,important.foobar"),"wor,imp.foo")
  expect_equal(shorten("word"),"wor")
  expect_equal(shorten("word.important"),"wor.imp")
  expect_equal(shorten("word important"),"wor imp")
})
