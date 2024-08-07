#' Miscellaneous import_ - Functions
#'
#' @description
#'
#' The \code{import_LL()} function
#' places specific functions from a package in the current environment,
#' and also locks (see \link[base]{lockBinding}) the specified functions to prevent modification. \cr
#' The primary use-case for this function is for exposing functions inside a local environment. \cr
#' \cr
#' The \code{import_int()} function
#' directly returns an internal function from a package. \cr
#' It is similar to the \link[base]{:::} operator, but with 2 key differences: \cr
#'  1) \code{import_int()} includes the \code{lib.loc} argument.
#'  2) \code{import_int()} only searches internal functions, not exported ones.
#'  This makes it clearer in your code that you're using an internal function,
#'  instead of making it ambiguous. \cr \cr
#'
#'
#'
#' @param package a single string,
#' giving the name of the package to take functions from. \cr
#' Core R (i.e. "base", "stats", etc.) is not allowed.
#' @param selection a character vector of function names
#' (both regular functions and infix operators). \cr
#' Internal functions or re-exported functions are not supported.
#' @param form a two-sided formula, with one term on each side. \cr
#' The term on the left hand side should give a single package name. \cr
#' The term on the right hand side should give a single internal function. \cr
#' Example: \code{package_name ~ function_name} \cr
#' Core R (i.e. "base", "stats", etc.) is not allowed.
#' @param lib.loc character vector specifying library search path
#' (the location of R library trees to search through). \cr
#' The \code{lib.loc} argument would usually be \code{.libPaths()}. \cr
#' See also \link[base]{loadNamespace}.
#'
#'
#' @details
#' \bold{Regarding the Locks in \code{import_LL()}} \cr
#' The \link{import_as} function returns a locked environment,
#' just like \link[base]{loadNamespace},
#' thus protecting the functions from accidental modification or re-assignment. \cr
#' The \link{import_inops} function returns infix operators,
#' and though these are not locked,
#' one needs to surround infix operators by back ticks to re-assign or modify them,
#' which is unlikely to happen on accident. \cr
#' The \code{import_LL()} function, however, returns "loose" functions.
#' And these functions
#' (unless they are infix operators)
#' do not have the protection due to a locked environment or due to the syntax. \cr
#' Therefore, to ensure safety from (accidental) modification or re-assignment,
#' the \code{import_LL()} function locks these functions (see \link[base]{lockBinding}).
#' For consistency, infix operators exposed by \code{import_LL()} are also locked. \cr
#' \cr
#' \bold{Other Details} \cr
#' The \code{import_LL()} and \code{import_int()} functions
#' do not support importing functions from base/core R. \cr
#' \cr
#'
#'
#' @returns
#' For \code{import_LL()}: \cr
#' The specified functions will be placed in the current environment,
#' and locked. \cr
#' To unexpose or overwrite the functions, simply remove them; i.e.: \cr
#' \code{rm(list=c("some_function1", "some_function2")}). \cr
#' \cr
#' For \code{import_int()}: \cr
#' The function itself is returned directly. \cr
#' So one can assign the function directly to some variable, like so: \cr
#' \code{myfun <- import_int(...)} \cr
#' or use it directly without re-assignment like so: \cr
#' \code{import_int(...)(...)}
#'
#'
#' @seealso \link{tinycodet_import}
#'
#'
#' @examples
#'
#' # Using import_LL ====
#' import_LL(
#'   "stringi", "stri_sub"
#' )
#' # the stri_sub() function now cannot be modified, only used or removed, because it's locked:
#' bindingIsLocked("stri_sub", environment()) # TRUE
#'
#' mypaste <- function(x, y) {
#'   import_LL("stringi", selection = "stri_c")
#'   stri_c(x, y)
#'   }
#' mypaste("hello ", "world")
#'
#'
#'
#' # Using internal function ====
#' # Through re-assignment:
#' fun <- import_int(tinycodet ~ .internal_paste, .libPaths())
#' fun("hello", "world")
#'
#' # Or using directly:
#' import_int(
#'   tinycodet ~ .internal_paste, .libPaths()
#' )("hello", "world")
#'
#'
#'

#' @rdname import_misc
#' @export
import_LL <- function(
    package, selection, lib.loc = .libPaths()
) {

  # check library:
  .internal_check_lib.loc(lib.loc, sys.call())


  # check main_package:
  if(!is.character(package) || length(package) > 1){
    stop("`package` must be a single string")
  }
  .internal_check_forbidden_pkgs(pkgs = package, lib.loc = lib.loc, abortcall = sys.call())
  .internal_check_pkgs(pkgs = package, lib.loc = lib.loc, abortcall = sys.call())
  
  # check selection:
  checks <- c(
    !is.character(selection),
    length(selection)==0,
    any(!nzchar(selection)),
    anyDuplicated(selection)
  )
  if(any(checks)) {
    stop("`selection` must be a non-empty character vector of unique function names")
  }
  
  # load package:
  ns <- .internal_prep_Namespace(package, lib.loc, abortcall = sys.call())
  ns <- ns[lapply(ns, is.function) |> unlist()]
  
  # finish up:
  if(any(!selection %in% names(ns))) {
    stop("specified functions not found in package namespace")
  }

  message("exposing and locking functions to current environment ...")
  for (sel in selection) {
    check_existence <- .is.tinyLL(sel, env = parent.frame(n = 1))
    if(isTRUE(check_existence)) {
      rm(list = sel, envir = parent.frame(n = 1))
    }
    assign(sel, ns[[sel]], envir = parent.frame(n = 1))
    lockBinding(as.character(sel), env = parent.frame(n = 1))
  }
  message("Done")

}


#' @rdname import_misc
#' @export
import_int <- function(form, lib.loc = .libPaths()) {


  # check form:
  check_form <- .internal_is_formula(form)
  if(!check_form) {
    stop("`form` must be a formula")
  }
  if(length(form) != 3) {
    stop("`form` must be a two-sided formula")
  }
  package <- all.vars(form[[2]]) |> as.character()
  intfun <- all.vars(form[[3]]) |> as.character()
  if(length(intfun) != 1) {
    stop("must give a single internal function")
  }
  if(length(package) != 1) {
    stop("must give a single package")
  }
  
  # check library:
  .internal_check_lib.loc(lib.loc, sys.call())

  # check & get package:
  .internal_check_forbidden_pkgs(package, lib.loc, abortcall = sys.call())
  .internal_check_pkgs(package, lib.loc, abortcall = sys.call())
  ns <- .get_internals(package, lib.loc, abortcall = sys.call())
  
  ns <- as.environment(ns)
  if(!intfun %in% names(ns)) {
    stop(paste0(intfun, " is not an internal function of ", package))
  }
  return(get(as.character(intfun), envir = ns, inherits = FALSE))
}


#' @keywords internal
#' @noRd
.is.tinyLL <- function(nm, env) {
  if(!exists(as.character(nm), envir = env, inherits = FALSE)) {
    return(FALSE)
  }
  if(!isTRUE(bindingIsLocked(as.character(nm), env = env))) {
    return(FALSE)
  }
  obj <- get(as.character(nm), envir = env)
  if(!is.function(obj)) {
    return(FALSE)
  }
  check_class <- isTRUE(all(c("function", "tinyimport") %in% class(obj)))
  if(!check_class) {
    return(FALSE)
  }
  package_name <- .internal_get_packagename(obj)
  if(is.null(package_name)){
    return(FALSE)
  }
  pkgs_core <- .internal_list_coreR()
  check <- isFALSE(package_name %in% pkgs_core)
  if(!check) {
    return(FALSE)
  }
  function_name <- attr(obj, "function_name")
  if(is.null(function_name) || !is.character(function_name)) {
    return(FALSE)
  }
  if(function_name != nm) {
    return(FALSE)
  }
  return(TRUE)
}


#' @keywords internal
#' @noRd
.get_internals <- function(package, lib.loc, abortcall) {

  .internal_check_ns_requirements(package, lib.loc, abortcall)

  ns <- loadNamespace(package, lib.loc = lib.loc) |> as.list(all.names=TRUE, sorted=TRUE)
  names_exported <- names(ns[[".__NAMESPACE__."]][["exports"]])
  ns <- ns[!names(ns) %in% names_exported]
  ns <- ns[!is.na(names(ns))]
  return(ns)
}
