
# set-up ====
enumerate <- 0 # to count number of tests performed using iterations in loops
loops <- 0 # to count number of loops
errorfun <- function(tt) {
  if(isTRUE(tt)) print(tt)
  if(isFALSE(tt)) stop(print(tt))
}


# package not installed ====
pattern <- "The following packages are not installed"
expect_error(
  import_as(~stri., "stringi", lib.loc = c("foo1", "foo2")),
  pattern = pattern
)
expect_error(
  import_inops("stringi", lib.loc = c("foo1", "foo2")),
  pattern = pattern
)
expect_error(
  import_inops(unexpose = "stringi", lib.loc = c("foo1", "foo2")),
  pattern = pattern
)
expect_error(
  import_LL("stringi", lib.loc = c("foo1", "foo2"), selection = "foo"),
  pattern = pattern
)
expect_error(
  import_int(stringi ~ foo, lib.loc = c("foo1", "foo2")),
  pattern = pattern
)
expect_error(
  pversion_check4mismatch("foo", lib.loc = c("foo1", "foo2")),
  pattern = pattern
)
expect_error(
  pversion_report("foo", lib.loc = c("foo1", "foo2")),
  pattern = pattern
)
expect_error(
  import_as(~stri., "stringi", dependencies = c("foo1", "foo2")),
  pattern = "The following dependencies are not installed"
)
expect_error(
  import_as(~stri., "stringi", extensions = c("foo1", "foo2")),
  pattern = "The following extensions are not installed"
)


# package misspelled ====

pattern <- "You have misspelled the following"
loops <- loops + 1
for(i in c("", "!@#$%^&*()")) {
  expect_error(
    import_as(~stri., i),
    pattern = pattern
  ) |> errorfun()
  expect_error(
    import_inops(i),
    pattern = pattern
  )  |> errorfun()
  expect_error(
    import_inops(unexpose = i),
    pattern = pattern
  )  |> errorfun()
  expect_error(
    import_LL(i, "foo"),
    pattern = pattern
  )  |> errorfun()
  expect_error(
    pversion_check4mismatch(i),
    pattern = pattern
  )  |> errorfun()
  expect_error(
    pversion_report(i),
    pattern = pattern
  )  |> errorfun()
  expect_error(
    import_as(~stri., "stringi", dependencies = i),
    pattern = pattern
  )
  expect_error(
    import_as(~stri., "stringi", extensions = i),
    pattern = pattern
  )
  enumerate <- enumerate + 7
}
expect_error(
  import_int(`!@#$%^&*()` ~ foo),
  pattern = pattern
)
expect_error(
  import_as(~stri., "stringi", dependencies = c("", "!@#$%^&*()")),
  pattern = pattern
)
expect_error(
  import_as(~stri., "stringi", extensions = c("", "!@#$%^&*()")),
  pattern = pattern
)


# package is core R ====
basepkgs <- c(
  "base", "compiler", "datasets", "grDevices", "graphics", "grid", "methods",
  "parallel", "splines", "stats", "stats4", "tcltk", "tools",
  "translations", "utils"
)
pattern <- 'The following "packages" are base/core R, which is not allowed:'
loops <- loops + 1
for(i in basepkgs) {
  expect_error(
    import_as(~stri., i),
    pattern = pattern
  ) |> errorfun()
  expect_error(
    import_inops(i),
    pattern = pattern
  )  |> errorfun()
  expect_error(
    import_inops(unexpose = i),
    pattern = pattern
  )  |> errorfun()
  expect_error(
    import_LL(i, "foo"),
    pattern = pattern
  )  |> errorfun()
  form <- as.formula(paste(i, "~ foo"))
  expect_error(
    import_int(form),
    pattern = pattern
  )  |> errorfun()
  expect_error(
    import_as(~stri., "stringi", dependencies = i),
    pattern = pattern
  )
  expect_error(
    import_as(~stri., "stringi", extensions = i),
    pattern = pattern
  )
  enumerate <- enumerate + 7
}
expect_error(
  import_as(~stri., "stringi", dependencies = basepkgs[1:5]),
  pattern = pattern
)
expect_error(
  import_as(~stri., "stringi", extensions = basepkgs[1:5]),
  pattern = pattern
)


# package is metaverse ====
metapkgs <- c(
  "tidyverse", "fastverse", "tinyverse"
)
pattern <- "The following packages are known meta-verse packages, which is not allowed:"
loops <- loops + 1
for(i in metapkgs) {
  expect_error(
    import_as(~stri., i),
    pattern = pattern
  ) |> errorfun()
  expect_error(
    import_inops(i),
    pattern = pattern
  )  |> errorfun()
  expect_error(
    import_inops(unexpose = i),
    pattern = pattern
  )  |> errorfun()
  expect_error(
    import_LL(i, "foo"),
    pattern = pattern
  )  |> errorfun()
  form <- as.formula(paste(i, "~ foo"))
  expect_error(
    import_int(form),
    pattern = pattern
  )  |> errorfun()
  expect_error(
    pversion_check4mismatch(i),
    pattern = pattern
  )  |> errorfun()
  expect_error(
    pversion_report(i),
    pattern = pattern
  )  |> errorfun()
  expect_error(
    import_as(~stri., "stringi", dependencies = i),
    pattern = pattern
  )
  expect_error(
    import_as(~stri., "stringi", extensions = i),
    pattern = pattern
  )
  enumerate <- enumerate + 9
}
expect_error(
  import_as(~stri., "stringi", dependencies = metapkgs),
  pattern = pattern
)
expect_error(
  import_as(~stri., "stringi", extensions = metapkgs),
  pattern = pattern
)


# bad library ====
expect_error(
  import_as(~stri., "stringi", lib.loc=mean),
  pattern = "`lib.loc` must be a character vector with at least one library path"
)
expect_error(
  import_inops("stringi", lib.loc=mean),
  pattern = "`lib.loc` must be a character vector with at least one library path"
)
expect_error(
  import_inops(unexpose = "stringi", lib.loc=mean),
  pattern = "`lib.loc` must be a character vector with at least one library path"
)
expect_error(
  import_LL("stringi", "%stri==%", lib.loc=mean),
  pattern = "`lib.loc` must be a character vector with at least one library path"
)
expect_error(
  import_int(stringi ~ foo, lib.loc=mean),
  pattern = "`lib.loc` must be a character vector with at least one library path"
)
expect_error(
  import_data("stringi", 'foo', lib.loc=mean),
  pattern = "`lib.loc` must be a character vector with at least one library path"
)
expect_error(
  pversion_report("stringi", lib.loc = mean),
  pattern = "`lib.loc` must be a character vector with at least one library path"
)
expect_error(
  pversion_check4mismatch("stringi", lib.loc = mean),
  pattern = "`lib.loc` must be a character vector with at least one library path"
)

