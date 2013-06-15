\name{train.models}
\alias{train.models}
\title{Trains all models}
\usage{
  train.models(formula, data, fam = "",
    algo = "glm.linear_model", replacement = c(""),
    plot.title = NULL, output = TRUE, order = "logLIK",
    ...)
}
\description{
  \code{sum} returns the sum of all the values present in
  its arguments. Foobar. Foobar2 Foobar3
}
\details{
  This is a generic function: methods can be defined for it
  directly or via the \code{Summary} group generic.  For
  this to work properly, asdfasdf the arguments \code{...}
  should be unnamed, and dispatch is on the first
  argument.'
}
\examples{
derp <- function(num.a, num.b, num.c=0) { factor(c(rep("A", num.a), rep("B", num.b), rep("C",num.c))) }
df = data.frame(x=1:100,y=100:199,z=derp(90,10),u=derp(50,50),t=derp(70,30),v=derp(30,50,20),tmp=derp(70,25,5),y=derp(60,30,10))

g1 = train.models("Sepal.Length ~ Sepal.Width + \%", iris, fam=c("gaussian","Gamma","inverse.gaussian"), replacement=c("Petal.Length","Petal.Width","Species"), plot.title="GLM - 2 distris, 5 formulas")
g2 = train.models("y ~ u + x", df,fam=c("gaussian","poisson","Gamma","inverse.gaussian"))
g3 = train.models("y ~ u + \%", df,algo="glm.linear_model",fam=c("gaussian","poisson","Gamma","quasipoisson"),replacement=c("x","y"),plot.title="GLM - 4 distris, 1 formula")
g4 = train.models("y ~ u + \% + (1 | v)", df,algo="lmer.linear_model",fam=c("gaussian"),replacement=c("u","v","t","y"),plot.title="LMER - 1 distri, 3 formulas")
g5 = train.models("y ~ u + \%", df,algo="lm.linear_model",replacement=c("t","v"),plot.title="LM - 2 formulas")
g6 = train.models("y ~ u + \%", df,algo="glm.linear_model",fam=c("gaussian","poisson"),replacement=c("x","v"),plot.title="GLM - 2 distris, 2 formulas")
g10 = train.models("y ~ u + \%", df, fam=c("gaussian","poisson","Gamma"), replacement=c("tmp","x","v","t","u","z"), plot.title="GLM - 2 distris, 5 formulas")
g11 = train.models("y ~ u + \%", df, fam=c("gaussian","poisson","Gamma"), replacement=c("tmp","x","v","t","u","z"), plot.title="GLM - 2 distris, 5 formulas", output=FALSE)
}

