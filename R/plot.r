add.title = function(p,title) {
  if(!is.null(title) && nchar(title) > 0)
    p = p + labs(title=title)
  p
}

prep = function(x,sort){
  df = na.omit(melt(as.data.frame(x),id.vars=c("modeltype")))
  df$modeltype = factor(df$modeltype)
  df$variable = factor(df$variable)
  df$modeltype = factor(df$modeltype, 
                        levels=df$modeltype[order(df[df$variable==sort,"value"])])
  df
}

add.color = function(p,l){
  if(length(paletteForLength(l)) > 1)
    p = p + scale_fill_manual("Model",values=paletteForLength(l))
  p
}

paletteForLength = function(l) {
  for(l1 in names(colors))
    if(l <= as.numeric(l1))
      return(colors[[l1]](l))
  return(NA)
}


#' Plots multiple 
#' 
#' its awesome, real nice
#' @param plots Passes all plots as a list
#' @param cols Number of columns to be used
#' @param plot.title Name of the entire plot
#' @export
multiplot <- function(plots,cols=1,plot.title=NULL) {
  do.call(grid.arrange,c(plots,
                         ncol=cols,
                         main=plot.title))
}

create.plots = function(...,sort,plot.title=""){
  lapply(dots(...),function(x){
         create.plot(prep(x,sort),
                     paste0(x$all[[1]]$formula,",",x$all[[1]]$algo, plot.title),
                     function(){facet_wrap(~variable)})})
}

#' @export
create.plot = function(tmp,plot.title,fn){
  p = ggplot(tmp,aes(modeltype,value,fill=modeltype)) + fn() + geom_bar(stat="identity",position="dodge") 
  p = p + theme_tufte()
  p = p + labs(x=NULL,y=NULL) +  theme(axis.text.x=element_text(angle=90),legend.position="None", panel.grid.major.x=element_blank()) 
  p = add.title(p, plot.title)
  p = add.color(p,length(levels(tmp$modeltype)))
  p = p + coord_flip()

  if(range.clean(tmp$value)[1] <= 0 && range.clean(tmp$value)[2] >= 0)
    p = p + geom_hline(yintercept=0,color="Black")
  p
}

#' @export
create.multiplot = function(...,sort, plot.title=NULL){
  dots = dots(...)
  fn = function(y) sapply(dots,function(x) models(x$all,name=y,simplify=TRUE)[1])
  n=fn("formula")
  algo=fn("algo")
  tmp = do.call(rbind,
                Reduce(function(y,x){y[[x]]$f=factor(paste(n[x], algo[x],sep=" - "));y},
                       seq(dots),
                       init=lapply(dots,function(x) prep(x,sort))))
  create.plot(tmp,plot.title,function(){facet_grid(variable~f,scales=c("free_x"))})
}

#' @export
ask = function(ask=T){
  par(ask=ask)
}

#' Interactively plot models 
#' 
#' Plots multiple models one by one and asks to proceed between each plot
#' @export
#' @examples
#' derp <- function(num.a, num.b, num.c=0) { factor(c(rep("A", num.a), rep("B", num.b), rep("C",num.c))) }
#' df = data.frame(x=1:100,y=100:199,z=derp(90,10),u=derp(50,50),t=derp(70,30),v=derp(30,50,20),tmp=derp(70,25,5),y=derp(60,30,10))
#' 
#' g1 = train.models("Sepal.Length ~ Sepal.Width + %", iris, fam=c("gaussian","Gamma","inverse.gaussian"), replacement=c("Petal.Length","Petal.Width","Species"), plot.title="GLM - 2 distris, 5 formulas")
#' g2 = train.models("y ~ u + x", df,fam=c("gaussian","poisson","Gamma","inverse.gaussian"))
#' g3 = train.models("y ~ u + %", df,algo="glm.linear_model",fam=c("gaussian","poisson","Gamma","quasipoisson"),replacement=c("x","y"),plot.title="GLM - 4 distris, 1 formula")
#' g4 = train.models("y ~ u + % + (1 | v)", df,algo="lmer.linear_model",fam=c("gaussian"),replacement=c("u","v","t","y"),plot.title="LMER - 1 distri, 3 formulas")
#' ask.plot(g1,g2)
ask.plot = function(...,sort=getSortDefault){
  dots = dots(...)
  a = par()$ask
  ask()
  tryCatch(for(x in seq(dots)){
           plot(dots[[x]],sort=sort)
                },
                finally=ask(a))
}

#' Plot method for models overriding generic plot function
#' 
#' Plots one or more models
#' @export
#' @examples
#' derp <- function(num.a, num.b, num.c=0) { factor(c(rep("A", num.a), rep("B", num.b), rep("C",num.c))) }
#' df = data.frame(x=1:100,y=100:199,z=derp(90,10),u=derp(50,50),t=derp(70,30),v=derp(30,50,20),tmp=derp(70,25,5),y=derp(60,30,10))
#' 
#' g1 = train.models("Sepal.Length ~ Sepal.Width + %", iris, fam=c("gaussian","Gamma","inverse.gaussian"), replacement=c("Petal.Length","Petal.Width","Species"), plot.title="GLM - 2 distris, 5 formulas")
#' g2 = train.models("y ~ u + x", df,fam=c("gaussian","poisson","Gamma","inverse.gaussian"))
#' g3 = train.models("y ~ u + %", df,algo="glm.linear_model",fam=c("gaussian","poisson","Gamma","quasipoisson"),replacement=c("x","y"),plot.title="GLM - 4 distris, 1 formula")
#' g4 = train.models("y ~ u + % + (1 | v)", df,algo="lmer.linear_model",fam=c("gaussian"),replacement=c("u","v","t","y"),plot.title="LMER - 1 distri, 3 formulas")
#' plot(g1)
#' plot(g1,g2,g3,g4,plot.title="Foobar")
#' plot(g1,plot.title="not a multiplot")
#' plot(g1,g2,g3,g4,cols=2,plot.title="Multiplot")
#' print(g1,g2)
#' plot(merge(g2,g3,g4))
plot.models = function(...,sort=getSortDefault,plot.title=NULL,cols=ceiling(length(dots(...))/2)){
  if(length(dots(...)) == 1)
    print(create.plots(...,
                       sort=sort,
                       plot.title=ifelse(is.null(plot.title), 
                                         "", 
                                         paste(" =>",plot.title)))[[1]])
  else
    multiplot(create.plots(..., sort=sort),
              cols=cols,
              plot.title=plot.title)
}

save.multiplot = function(...,filename){
  pdf(filename)
  plot(...)
  dev.off()
}

