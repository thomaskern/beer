\name{ask.plot}
\alias{ask.plot}
\title{Interactively plot models}
\usage{
  ask.plot(..., sort = getSortDefault)
}
\description{
  Plots multiple models one by one and asks to proceed
  between each plot
}
\examples{
derp <- function(num.a, num.b, num.c=0) { factor(c(rep("A", num.a), rep("B", num.b), rep("C",num.c))) }
df = data.frame(x=1:100,y=100:199,z=derp(90,10),u=derp(50,50),t=derp(70,30),v=derp(30,50,20),tmp=derp(70,25,5),y=derp(60,30,10))

g1 = train.models("Sepal.Length ~ Sepal.Width + \%", iris, fam=c("gaussian","Gamma","inverse.gaussian"), replacement=c("Petal.Length","Petal.Width","Species"), plot.title="GLM - 2 distris, 5 formulas")
g2 = train.models("y ~ u + x", df,fam=c("gaussian","poisson","Gamma","inverse.gaussian"))
g3 = train.models("y ~ u + \%", df,algo="glm.linear_model",fam=c("gaussian","poisson","Gamma","quasipoisson"),replacement=c("x","y"),plot.title="GLM - 4 distris, 1 formula")
g4 = train.models("y ~ u + \% + (1 | v)", df,algo="lmer.linear_model",fam=c("gaussian"),replacement=c("u","v","t","y"),plot.title="LMER - 1 distri, 3 formulas")
ask.plot(g1,g2)
}

