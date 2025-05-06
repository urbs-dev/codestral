test_that("compile_dialog works with valid input", {
  prompt <- c("c: Hello",
              "m: Hi there",
              "a: How can I help you?",
              "s: System message")
  result <- compile_dialog(prompt = prompt)

  expect_equal(result$chatter, "mamba")
  expect_equal(result$dialog, data.frame(
    role = c("user", "user", "assistant", "system"),
    content = c(" Hello", " Hi there", " How can I help you?", " System message")
  ))
})

test_that("compile_dialog ignores text before the first marker", {
  prompt <- c("Some text", "c: Hello", "m: Hi there")
  result <- compile_dialog(prompt = prompt)

  expect_equal(result$chatter, "mamba")
  expect_equal(result$dialog, data.frame(
    role = c("user", "user"),
    content = c(" Hello", " Hi there")
  ))
})

test_that("compile_dialog handles no new prompt after the last answer", {
  prompt <- c("c: Hello",
              "m: Hi there",
              "a: How can I help you?",
              "a: Another answer")

  expect_message({
    result <- compile_dialog(prompt = prompt)
  })

  expect_equal(result$chatter, "mamba")
  expect_equal(result$dialog, data.frame(
    role = c("user", "user"),
    content = c(" Hello", " Hi there")
  ))
})

test_that("compile_dialog stops with malformed request", {
  prompt <- c("Some text", "Some more text")
  expect_error(compile_dialog(prompt = prompt), "Malformed request")
})

test_that("compile_dialog handles mixed markers correctly", {
  prompt <- c("c: Hello",
              "s: System message",
              "m: Hi there",
              "a: How can I help you?")

  expect_message({
    result <- compile_dialog(prompt = prompt)
  })

  expect_equal(result$chatter, "mamba")
  expect_equal(result$dialog, data.frame(
    role = c("user", "system", "user"),
    content = c(" Hello", " System message", " Hi there")
  ))
})

test_that("compile_dialog handles empty input", {
  prompt <- c()
  expect_error(compile_dialog(prompt = prompt), "Malformed request")
})

test_that("compile_dialog handles single marker", {
  prompt <- c("c: Hello")
  result <- compile_dialog(prompt = prompt)

  expect_equal(result$chatter, "codestral")
  expect_equal(result$dialog, data.frame(role = "user", content = " Hello"))
})
