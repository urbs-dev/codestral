test_that("include_file works when files are found", {
  # Create temporary files for testing
  temp_file1 <- "testinclude001.txt"
  temp_file2 <- "testinclude00.txt"

  tempdir <- tempdir()
  currentwd <- getwd()
  setwd(tempdir)

  writeLines("This is file 1 content.", temp_file1)
  writeLines("This is file 2 content.", temp_file2)

  prompt <- c("This is the first line.",
              paste0("ff:", temp_file1),
              "This is the last line.")

  anyFile <- c(FALSE, TRUE, FALSE)

  expected <- c("This is the first line.",
                "This is file 1 content.",
                "This is the last line.")

  expect_message({
    result <- include_file(prompt, anyFile)
  })

  expect_equal(result, expected)

  # Clean up temporary files
  allFiles <- dir()
  tempfiles <- stringr::str_detect(allFiles, "testinclude")

  filestoremove <- allFiles[tempfiles]

  for (ff in filestoremove) {
    unlink(ff)
  }

  setwd(currentwd)
})

test_that("include_file works when files are not found", {
  prompt <- c("This is the first line.",
              "ff:non_existent_file.txt",
              "This is the last line.")

  anyFile <- c(FALSE, TRUE, FALSE)

  expect_condition({
    result <- include_file(prompt, anyFile)
  }, regexp = "not been detected")

  expect_equal(result, prompt)
})

test_that("include_file works with multiple files", {
  # Create temporary files for testing
  temp_file1 <- "testinclude001.txt"
  temp_file2 <- "testinclude00.txt"

  tempdir <- tempdir()
  currentwd <- getwd()
  setwd(tempdir)

  writeLines("This is file 1 content.", temp_file1)
  writeLines("This is file 2 content.", temp_file2)

  prompt <- c(
    "This is the first line.",
    paste0("ff:", temp_file1),
    "This is the second line.",
    paste0("ff:", temp_file2),
    "This is the last line."
  )

  anyFile <- c(FALSE, TRUE, FALSE, TRUE, FALSE)

  expected <- c(
    "This is the first line.",
    "This is file 1 content.",
    "This is the second line.",
    "This is file 2 content.",
    "This is the last line."
  )

  suppressMessages({
    result <- include_file(prompt, anyFile)
  })

  expect_equal(result, expected)

  # Clean up temporary files
  unlink(temp_file1)
  unlink(temp_file2)

  setwd(currentwd)
})

test_that("include_file handles no files to include", {
  prompt <- c("This is the first line.",
              "
              This is the second line.",
              "This is the last line.")

  anyFile <- c(FALSE, FALSE, FALSE)

  result <- include_file(prompt, anyFile)

  expect_equal(result, prompt)
})

test_that("include_file handles empty prompt", {
  prompt <- c()
  anyFile <- c()

  expected <- c()
  result <- include_file(prompt, anyFile)

  expect_equal(result, expected)
})
