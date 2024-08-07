
#include <Rcpp.h>
using namespace Rcpp;


//' @keywords internal
//' @noRd
// [[Rcpp::export(.rcpp_n_matches)]]
Rcpp::IntegerVector rcpp_n_matches( const List lst ) {
  R_xlen_t n = lst.size();
  Rcpp::IntegerVector res( n );
  
  for(R_xlen_t i = 0; i < n; i++ ) {
    res[i] = Rf_length( lst[i] ) / 2;
  }
  return res;
}


//' @keywords internal
//' @noRd
// [[Rcpp::export(.rcpp_convert_i0)]]
IntegerVector rcpp_convert_i0(const IntegerVector n_matches, const IntegerVector i) {
  int n = i.length();
  IntegerVector out(n);
  int res = 0;
  
  for(int j = 0; j < n; ++j) {
    if(IntegerVector::is_na(i[j])) {
      stop("`i` is not allowed to be zero or NA");
    }
    else if(i[j] < 0) {
      res = n_matches[j] - abs(i[j] + 1);
      if(res < 1) {
        out[j] = 1;
      } else {
        out[j] = res;
      }
    }
    else if(i[j] > 0) {
      if(i[j] < n_matches[j]) {
        out[j] = i[j];
      } else {
        out[j] = n_matches[j];
      }
    }
    else {
      stop("`i` is not allowed to be zero or NA");
    }
  }
  return out;
}


//' @keywords internal
//' @noRd
// [[Rcpp::export(.rcpp_convert_i1)]]
IntegerVector rcpp_convert_i1(const IntegerVector n_matches, const int i) {
  int n = n_matches.length();
  IntegerVector out(n);
  
  if(i < 0) {
    int res = 0;
    for(int j = 0; j < n; ++j) {
      res = n_matches[j] - abs(i + 1);
      if(res < 1) {
        out[j] = 1;
      } else {
        out[j] = res;
      }
    }
  }
  else if(i > 0) {
    for(int j = 0; j < n; ++j) {
      if(i < n_matches[j]) {
        out[j] = i;
      } else {
        out[j] = n_matches[j];
      }
    }
  }
  else {
    stop("`i` is not allowed to be zero or NA");
  }
  
  return out;
}



//' @keywords internal
//' @noRd
// [[Rcpp::export(.rcpp_alloc_stri_locate_ith)]]
IntegerMatrix rcpp_alloc_stri_locate_ith(const List p1, const IntegerVector n_matches, const IntegerVector i) {
  int n = Rf_length(p1); // using regular integer, because maximum nrow/ncol for matrices is approx 2^30 -1 anyway
  IntegerMatrix out(n, 2);
  for(int j = 0; j < n; ++j) {
    IntegerVector temp = p1[j];
    out(j, 0) = temp[i[j]];
    out(j, 1) = temp[i[j] + n_matches[j]];
  }
  return  out;
}
