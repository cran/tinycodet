% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/form.R
\name{form}
\alias{form}
\title{Construct Formula With Safer Environment Specification}
\usage{
form(f, env = NULL)
}
\arguments{
\item{f}{either one of the following:
\itemize{
\item a literal single string, or a variable containing a single string. \cr
If a string is given that does not contain a tilde ( \code{~} ),
a tilde is prepended to the string before converting it to a formula. \cr
\item a literal formula. \cr
Note that if a literal formula is given,
it must actually be a literal formula,
\bold{not} a variable that contains a formula,
as that would defeat the whole point of the \code{form()} function. \cr
}}

\item{env}{\link[base]{environment} of the formula. \cr
Defaults to \code{NULL}. \cr \cr}
}
\value{
A formula with no environment,
or a formula with the specified environment. \cr \cr
}
\description{
When creating a formula with the tilde ( \verb{~ }) operator,
and storing a formula in a variable to be used later,
the environment is captured by the formula. \cr
Therefore,
any object in the captured environment might not be freed from the memory,
potentially creating some memory leak
(see also the Examples section below). \cr
\cr
The \code{form()} function is a convenience function,
to create and return/store a formula more safely,
by having no default environment,
and allowing the user to specify the environment explicitly. \cr
It can also convert a single string to a formula,
again allowing for explicit environment specification,
and having no environment by default. \cr \cr
}
\examples{

# basic examples ====

(myform <- form(a ~ b))
(myform2 <- form("a ~ b"))
mystring <- "a ~ b"
(myform3 <- form(mystring))
form("a")

myform <- form(x ~ y)
environment(myform) # NULL
mydata <- data.frame(x = rnorm(1e5), y = rnorm(1e5))
lm(myform, data = mydata)


#############################################################################


# showcasing environment capture ====
# see also http://adv-r.had.co.nz/memory.html


f1 <- function() {
  foo <- c(letters, LETTERS)
  return(10)
}
x1 <- f1()
environment(x1) |> as.list() # empty, since no formula is used inside f1(), so safe


f2 <- function() {
  foo <- c(letters, LETTERS)
  out <- a ~ b
  return(out)
}
x2 <- f2()
environment(x2) |> as.list() # NOT safe: contains all objects from f2()
exists("foo", envir = environment(x2)) # = TRUE: "foo" still exists!
environment(x2)$foo # can still access it; probably won't be removed by gc()


f3 <- function() {
  foo <- c(letters, LETTERS)
  out <- form(a ~ b)
  return(out)
}
x3 <- f3()
environment(x3) |> as.list() # empty, since form() is used, so safe


f4 <- function() {
  foo <- c(letters, LETTERS)
  out <- form("a ~ b")
  return(out)
}
x4 <- f4()
environment(x4) |> as.list() # empty, since form() is used, so safe


}
\seealso{
\link{tinycodet_safer}, \link{aes_pro}, \link{with_pro}
}
