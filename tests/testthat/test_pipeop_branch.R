context("PipeOpBranch")

test_that("PipeOpBranch - basic properties", {
  expect_pipeop_class(PipeOpBranch, list(1))
  expect_pipeop_class(PipeOpBranch, list(3))
  expect_error(PipeOpBranch$new(0))


  po = PipeOpBranch$new(3)
  expect_pipeop(po)


  expect_data_table(po$input, nrows = 1)
  expect_data_table(po$output, nrows = 3)
})


test_that("PipeOpBranch - train and predict", {
  # Define PipeOp's
  t1 = mlr_tasks$get("iris")

  branch = PipeOpBranch$new(2)
  tout = train_pipeop(branch, list(t1))
  expect_true(length(tout) == branch$outnum)
  expect_list(tout, len = branch$outnum)
  expect_class(tout[[branch$param_set$values$selection]], "Task")
  expect_equal(tout[[branch$param_set$values$selection]], t1)
  expect_class(tout[[2]], "NO_OP")
  expect_true(is_noop(tout[[2]]))

  branch2 = PipeOpBranch$new(2)
  branch2$param_set$values$selection = 2L
  tout = train_pipeop(branch2, list(t1))
  # expect_true(length(tout) == branch2$outnum)
  # expect_list(tout, len = branch2$outnum)
  expect_class(tout[[branch2$param_set$values$selection]], "Task")
  expect_equal(tout[[branch2$param_set$values$selection]], t1)
  expect_class(tout[[1]], "NO_OP")
  expect_true(is_noop(tout[[1]]))

  pout = predict_pipeop(branch, list(t1))
  # expect_true(length(pout) == branch$outnum)
  expect_equal(pout[[1]], t1)
  expect_class(pout[[2]], "NO_OP")
  expect_true(is_noop(pout[[2]]))
})
