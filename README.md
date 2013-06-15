# beer

The aim of `beer` is to make it easier to automatically train and analyse data. 

## Usage

The main method is ``train.models``, used to train multiple models automatically and visualise on demand.

There are two options to train multiple models automatically: either by providing more than one distribution family (only applicable for classifiers which take a distribution family) or by replacing a part of the formula. The former is passed to ``train.models`` with the parameter ``fam``, the latter with parameter ``replacement``. The first example shows the latter, the second the former.

The **first** example trains a linear regression by using `lm` on the ``iris`` dataset. The algorithm is set by passing ``lm.linear_model`` in parameter ``algo``. Currently supported are 

* ``lm.linear_model`` (``lm``)
* ``glm.linear_model`` (``glm``)
* ``lme.linear_model`` (``lme`` from package ``lme4``)
* ``nlme.linear_model`` (``nlme`` from package ``lme4``).

Those are easily extendable, which is discussd under Section ``Extensability``. 

**First** example:

    train.models("Sepal.Length ~ Sepal.Width + %", 
    			  iris, 
    			  algo="lm.linear_model",
    			  replacement=c("Petal.Length","Petal.Width","Species"))

The first parameter is the formula, nothing changes except for the special character `%`. It is used as a replacement character. Parameter ``replacement`` takes a vector of column names of the passed data (in the **first** example ``iris``) that should replace ``%`` in the formula. As for now, only one replacement per formula is possible.

In the **first** example three lm-models are trained with the formulas

* Sepal.Length ~ Sepal.Width + Petal.Length
* Sepal.Length ~ Sepal.Width + Petal.Width
* Sepal.Length ~ Sepal.Width + Species

are trained and returned. Since `lm` does not take a distribution, only three models in total are trained. By default the results of the three models are **visualised**, printed as a **table** and an **anova** is run on it. The result of the visualisation can be seen here:

![d](doc/first-example.png)

The **second** example uses `glm` to train the previous formula but also providing three distribution families.

    train.models("Sepal.Length ~ Sepal.Width + %", 
    			  iris, 
    			  algo="glm.linear_model",
    			  fam=c("gaussian","inverse.gaussian","Gama"), 
    			  replacement=c("Petal.Length","Petal.Width","Species"))
    
Now what happens is it runs all possible combinations of the family and formula. Three replacements for the formula and three families equals nine trained models.

* Sepal.Length ~ Sepal.Width + Petal.Length with gaussian
* Sepal.Length ~ Sepal.Width + Petal.Length with inverse.gaussian
* Sepal.Length ~ Sepal.Width + Petal.Length with Gamma
* Sepal.Length ~ Sepal.Width + Petal.Width with gaussian
* Sepal.Length ~ Sepal.Width + Petal.Width with inverse.gaussian
* Sepal.Length ~ Sepal.Width + Petal.Width with Gamma
* Sepal.Length ~ Sepal.Width + Species with gaussian
* Sepal.Length ~ Sepal.Width + Species with inverse.gaussian
* Sepal.Length ~ Sepal.Width + Species with Gamma

The visualisation again shows AIC, BIC and logLIK values for all nine models:

![d](doc/second-example.png)

## Extensability

d