#' @export
anova.models = function(object,...){
  do.call(anova,models(object$all))
}

