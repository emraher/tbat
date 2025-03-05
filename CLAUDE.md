# TBAT Package Development Guide

## Commands
- Install: `devtools::install_github("emraher/tbat")`
- Check: `R CMD check .` or `devtools::check()`
- Document: `devtools::document()`
- Test: `devtools::test()` or `testthat::test_package("tbat")`
- Test single file: `testthat::test_file("tests/testthat/test-filename.R")`
- Coverage: `covr::package_coverage()`
- Build site: `pkgdown::build_site()`
- Lint: `lintr::lint_package()`

## Style Guidelines
- Follow tidyverse style guide
- Use pipe (`%>%`) for readable data manipulation chains
- Document functions with roxygen2 (params, return values, examples)
- Use tidy evaluation principles for data analysis functions
- Prefer explicit return values
- Use snake_case for function and variable names
- Include tests for all new functionality
- Keep functions focused on a single task
- Error messages should be informative and actionable