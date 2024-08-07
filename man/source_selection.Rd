% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/source_selection.R
\name{source_selection}
\alias{source_selection}
\title{Source Specific Objects from Script}
\usage{
source_selection(lst, select = NULL, regex = NULL, fixed = NULL)
}
\arguments{
\item{lst}{a named list, giving the arguments to be passed to the
\link[base]{source} function. \cr
The \code{local} argument should not be included in the list.}

\item{select}{a character vector,
giving the exact names of the functions or objects appearing in the script,
to expose to the current environment.}

\item{regex}{a character vector of \code{regex} patterns
(see \link[stringi]{about_search_regex}). \cr
These should give regular expressions that match to
the names of the functions or objects appearing in the script,
to expose to the current environment. \cr
For example, to expose the following methods to the current environment, \cr
\code{mymethod.numeric()} and \code{mymethod.character()} from generic \code{mymethod()}, \cr
one could specify \code{regex = "^mymethod"}. \cr
\ifelse{html}{\href{https://stringi.gagolewski.com/rapi/about_search_regex.html}{\figure{aboutsearch-regex-darkred.svg}{options: alt='[REGEX]'}}}{\href{https://stringi.gagolewski.com/rapi/about_search_regex.html}{about search: regex}} \cr}

\item{fixed}{a character vector of \code{fixed} patterns
(see \link[stringi]{about_search_fixed}). \cr
These should give fixed expressions that match to
the names of the functions or objects appearing in the script,
to expose to the current environment. \cr
For example, to expose the following methods to the current environment, \cr
\code{mymethod.numeric()} and \code{mymethod.character()} from generic \code{mymethod()}, \cr
one could specify \code{fixed = "mymethod"}. \cr
\ifelse{html}{\href{https://stringi.gagolewski.com/rapi/about_search_fixed.html}{\figure{aboutsearch-fixed-darkgreen.svg}{options: alt='[FIXED]'}}}{\href{https://stringi.gagolewski.com/rapi/about_search_fixed.html}{about search: fixed}} \cr}
}
\value{
Any specified objects will be placed
in the current environment. \cr
\cr
}
\description{
The \code{source_selection()} function is the same as
base R's \link[base]{source} function, except that it allows only placing
the selected objects and functions into the current environment,
instead of all objects. \cr
\cr
The objects to be selected can be specified using any combination of the following:
\itemize{
\item by supplying a character vector of exact object names to the \code{select} argument.
\item by supplying a character vector of \code{regex} patterns to the \code{regex} argument.
\item by supplying a character vector of \code{fixed} patterns to the \code{fixed} argument.
}

Note that the \code{source_selection()} function does not suppress output
(i.e. plots, prints, messages)
from the sourced script file. \cr
}
\details{
One can specify which objects to expose using arguments
\code{select}, \code{regex}, or \code{fixed}. \cr
The user can specify all 3 of them, but at least one of the 3 must be specified. \cr
It is not a problem if the specifications overlap.
}
\examples{

exprs <- expression({
helloworld = function()print("helloworld")
goodbyeworld <- function() print("goodbye world")
`\%s+test\%` <- function(x,y) stringi::`\%s+\%`(x,y)
`\%s*test\%` <- function(x,y) stringi::`\%s*\%`(x,y)
 mymethod <- function(x) UseMethod("mymethod", x)
 mymethod.numeric <- function(x)x * 2
 mymethod.character <- function(x)chartr(x, old = "a-zA-Z", new = "A-Za-z")
})

source_selection(list(exprs=exprs), regex = "^mymethod")
mymethod(1)
mymethod("a")


temp.fun <- function(){
  source_selection(list(exprs=exprs), regex = "^mymethod", fixed = c("\%", ":="))
  ls() # list all objects residing within the function definition
}
temp.fun()

temp.fun <- function(){
  source_selection(list(exprs=exprs), select = c("helloworld", "goodbyeworld"))
  ls() # list all objects residing within the function definition
}
temp.fun()


}
\seealso{
\link{tinycodet_misc}, \code{\link[base:source]{base::source()}}
}
