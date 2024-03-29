% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/subset_if.R
\name{subset_if}
\alias{subset_if}
\alias{\%[if]\%}
\alias{\%[!if]\%}
\alias{\%unreal =\%}
\title{Conditional Sub-setting and In-place Replacement of Unreal Values}
\usage{
x \%[if]\% cond

x \%[!if]\% cond

x \%unreal =\% repl
}
\arguments{
\item{x}{a vector, matrix, or array.}

\item{cond}{a (possibly anonymous) function that returns a \code{logical} vector
of the same length/dimensions as \code{x}. \cr
For example: \code{\(x)x>0}. \cr}

\item{repl}{the replacement value.}
}
\value{
For the \code{x \%[if]\% cond} and \code{x \%[!if]\% cond} operators: \cr
The subset_if - operators all return a vector with the selected elements. \cr
\cr
For the \code{x \%unreal =\% repl} operator: \cr
The \code{x \%unreal =\% repl} operator does not return any value: \cr
It is an in-place modifier, and thus modifies \code{x} directly.
The object \code{x} is modified such that all
\code{NA}, \code{NaN}, \code{Inf}, and \code{-Inf} elements are replaced with \code{repl}.
}
\description{
The \code{x \%[if]\% cond} operator
selects elements from vector/matrix/array \code{x},
for which the result of \code{cond(x)} returns \code{TRUE}. \cr
And the \code{x \%[!if]\% cond} operator
selects elements from vector/matrix/array \code{x},
for which the result of \code{cond(x)} returns \code{FALSE}. \cr
\cr
The \code{x \%unreal =\% repl} operator
modifies all unreal (\code{NA, NaN, Inf, -Inf}) values of \code{x}
with replacement value \code{repl}. \cr
Thus, \cr
\code{x \%unreal =\% repl}, \cr
is the same as, \cr
\code{x[is.na(x) | is.nan(x) | is.infinite(x)] <- repl} \cr
}
\examples{
x <- c(-10:9, NA, NA)
object_with_very_long_name <- matrix(x, ncol=2)
print(object_with_very_long_name)
object_with_very_long_name \%[if]\% \(x)x \%in\% 1:10
object_with_very_long_name \%[!if]\% \(x)x \%in\% 1:10

x <- c(1:9, NA, NaN, Inf)
print(x)
x \%unreal =\% 0 # same as x[is.na(x)|is.nan(x)|is.infinite(x)] <- 0
print(x)
}
\seealso{
\link{tinycodet_dry}
}
