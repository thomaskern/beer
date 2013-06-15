#' All distributions available
distris = c("binomial","gaussian","Gamma","inverse.gaussian","poisson","quasi","quasibinomial","quasipoisson")
colors = list("8" = economist_pal(),
              "10" = tableau_color_pal(),
              "20" = tableau_color_pal("tableau20"))

getSortDefault = "AIC"
shorten.word = function(str,len) substr(str,1,len)
split.word = function(str,how) unlist(strsplit(str,how,fixed=TRUE))
shorten.and.concate = function(x,s,len) do.call(paste, c(lapply(x,shorten,len=len),sep=s))
indexOf = function(str,x) grep(x,split.word(str,""),fixed=TRUE)[1]
shorter = function(x) shorten(gsub(".linear_model","",x,fixed=TRUE))

shorten = function(word,sentence=c(","," ","."),len=3){
  splitter = names(Filter(function(x){!is.na(x)}, sapply(sentence,indexOf,str=word))[1])
  if(is.na(splitter)) 
    shorten.word(word,len) # reached word-level => always truncate
  else
    shorten.and.concate(split.word(word,splitter),splitter,len)
}

lhs = function(f) paste(f[2])
rhs = function(f) paste(f[-2])
whitespace = function(n) paste0(rep(" ",n),collapse="") 
p = function(...) do.call(paste,c(" ",as.vector(dots(...)),"\n",sep="\t"))
out = function(...) cat(p(...))
r = function(x) round(x,5)
models = function(x,fn=identity,name="model",simplify=FALSE) sapply(x,function(tmp){fn(tmp[[name]])},simplify=simplify, USE.NAMES=FALSE )
is.not.null=function(x) !is.null(x)
error = function(e){print(e);cat("Traceback\n");traceback()}
clean = function(a){a=na.omit(a);a[a != -Inf & a != Inf]}
range.clean = function(a) range(clean(a))
dots = function(...) list(...)

gsub.form = function(formula,x,fn=as.formula){
  fn(gsub("%",x,formula))
}

gsub.form.string = function(formula,x) gsub.form(formula,x,paste0)

paste.to = function(...) {
  do.call(function(...) paste(...,sep=","),Filter(function(x) x != "",dots(...)))
}

#' @export
print.models = function(...,sort=getSortDefault){
  for(i in dots(...)){
    print(i$all[[1]]$formula)
    m = as.matrix(i)
    print(m[order(-(unlist(m[,sort]))),])
  }
}

output = function(r,plot.title=NULL,sort=getSortDefault){
  cat("Performance Table\n")
  print(r,sort=sort)
  plot(r,plot.title=plot.title,sort=sort)
  cat("\n\nANOVA\n")
  tryCatch((function(){print(anova(r))})(),
           error=function(e){error(e);warning("IMPORTANT: No automatic anova possible. Manual anova required!")})
}

best.by = function(x,fn){
  x[which.max(models(x,fn))]
}

best.by.AIC = function(x) best.by(x,AIC)

best.by.BIC = function(x) best.by(x,BIC)

best.by.logLik = function(x) best.by(x,logLik)

