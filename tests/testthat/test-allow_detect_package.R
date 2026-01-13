 test_that("allow_detect_package sets the environment variable correctly", {
   # save previous value and restore it
   previous_value <- Sys.getenv("R_CODESTRAL_DETECT_PACKAGE")

  allow_detect_package(TRUE)
  expect_equal(Sys.getenv("R_CODESTRAL_DETECT_PACKAGE"), "TRUE")

  allow_detect_package(FALSE)
  expect_equal(Sys.getenv("R_CODESTRAL_DETECT_PACKAGE"), "FALSE")

  # restore previous value
  Sys.setenv(R_CODESTRAL_DETECT_PACKAGE = previous_value)
})
