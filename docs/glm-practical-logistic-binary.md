

# Logistic Models – Binary Response

## Objectives
:::objectives
**Questions**

- 

**Objectives**

- 
:::

## Data
This section uses the following dataset:

`data/MS1-Diabetes.csv`

This is a dataset comprising 768 observations of three variables (one dependent and two predictor variables). This records the results of a diabetes test as a binary variable (1 is a positive result, 0 is a negative result), along with the result of a glucose test and the diastolic blood pressure for each of 767 women. The variables are called `test`, `glucose` and `diastolic`.

## Load the data
First we load the data, then we visualise it. If needed, load the tidyverse package using:


```r
library(tidyverse)
```


```r
diabetes <- read_csv("data/MS1-Diabetes.csv")
```

We can plot the data:


```r
diabetes %>% 
  mutate(test = as_factor(test)) %>% 
  ggplot(aes(x = test, y = glucose)) +
  geom_boxplot()
```

<img src="glm-practical-logistic-binary_files/figure-html/unnamed-chunk-4-1.png" width="672" />

It looks as though the variable glucose may have an effect on the results of the diabetes test since the positive test results seem to be slightly higher than the negative test results.

We can visualise that differently by plotting all the data points as a classic binary response plot:


```r
diabetes %>% 
  ggplot(aes(x = glucose, y = test)) +
  geom_point()
```

<img src="glm-practical-logistic-binary_files/figure-html/unnamed-chunk-5-1.png" width="672" />

## Construct a logistic model
First we construct a logistic model named `glm_diabetes`. The format of this function is similar to that used by the linear model function `lm()`. The important difference is that we must specify the family of error distribution to use. For logistic regression we must set the family to `binomial`.

:::note
Important: if you forget to include the family argument then the `glm()` function just performs an ordinary linear model fit (same as the `lm()` function)
:::

Right, let's construct the model:


```r
glm_diabetes <- diabetes %>% 
  glm(test ~ glucose,
      family = binomial,
      data = .)
```

When we summarise the output of the model, we get the following information:


```r
summary(glm_diabetes)
```

```
## 
## Call:
## glm(formula = test ~ glucose, family = binomial, data = .)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -2.1353  -0.7819  -0.5189   0.8269   2.2832  
## 
## Coefficients:
##              Estimate Std. Error z value Pr(>|z|)    
## (Intercept) -5.611732   0.442289  -12.69   <2e-16 ***
## glucose      0.039510   0.003398   11.63   <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 936.6  on 727  degrees of freedom
## Residual deviance: 752.2  on 726  degrees of freedom
## AIC: 756.2
## 
## Number of Fisher Scoring iterations: 4
```

There’s a lot to unpack here so take a deep breath (or make sure you have a coffee) before continuing...

* The first lines just confirm which model we’ve been fitting (trust me, this can be useful when you’re in the middle of a load of analysis and you’ve lost track of what the hell is going on!)

* The next block is called `Deviance Residuals`. This isn’t particularly useful, but just so you know: for linear models the residuals were calculated for each data point and then squared and added up to get the SS (sum of squares), which is used to fit the model. For generalised linear models we don’t use SS to fit the model and instead we use an entirely different method called maximum likelihood. This fitting procedure generates a different quantity, called Deviance, which is the analogue of SS. A deviance of zero indicates the best model we could hope for and bigger values indicate a model that doesn’t fit quite as well. The deviance residuals are then values associated with each data point, that when squared and summed give the deviance for the model (an exact analogy to normal residuals). You’re unlikely to ever need to know this, but I had some time on my hands and decided to share this little nugget with you 😉.

* The `Coefficients` block is next. The main numbers to extract from the output are the two numbers underneath `Estimate.Std`: we have `(Intercept) -5.611732` and `glucose 0.039510`.These are the coefficients of the logistic model equation and need to be placed in the correct equation if we want to be able to calculate the probability of having a positive diabetes test for a given glucose level.

\begin{equation}
P(positive \ test) = \frac{1}{1 + {e}^{-(-5.61 +  0.040 \cdot glucose)}}
\end{equation}

* The p values (`Pr(>|z|`) at the end of each coefficient row merely show whether that particular coefficient is significantly different from zero. This is similar to the p-values obtained in the summary output of a linear model, and as before, for continuous predictors these p-values can be used as a rough guide as to whether that predictor is important (so in this case glucose appears to be significant). However, these p-values aren’t great when we have multiple predictor variables, or when we have categorical predictors with multiple levels (since the output will give us a p-value for each level rather than for the predictor as a whole).

* The next line tells us that the dispersion parameter was assumed to be 1 for this binomial model. Dispersion is a property that says whether the data were more or less spread out around the logistic curve than we would expect. A dispersion parameter of 1 says that the data are spread out exactly as we would expect. Greater than 1 is called over-dispersion and less than 1 is called under-dispersion. Here this line is saying that when we fitted this model, we were assuming that the dispersion of the data was exactly 1. For binary data, like we have here, the data cannot be over- or under-dispersed but this is something that we’ll need to check for other sorts of generalised linear models.

* The last three lines relate to quantities called deviance and AIC (Akaike Information Criterion).
    * As we said just above, the deviance values are the equivalent of Sums of Squares values in linear models (and are a product of the technique used to fit the curve to the data). They can be used as a metric of goodness of fit for the model, with a deviance of 0 indicating a perfect fitting model. The deviance for the null model (i.e. the model without any predictors, basically saying that the probability of getting a positive diabetes score is constant and doesn’t depend on glucose level) is given by the first line and the deviance for the actual model is given by the residual deviance line. We will see how we can use the deviance to do two things.
      1. to check of whether the model is actually any good (i.e. does it in any way look like it’s close to the data). This is akin to what we were doing with R2 values in linear models.
      2.	to check if the model we’ve specified is better than the null model.
    It’s important to realise that these two things can be independent of each other; we can have a model that is significantly better than a null model whilst still being rubbish overall (the null model will have been even more rubbish in comparison), and we can have a model that is brilliant yet still not be better than the null model (in this case the null model was already brilliant).
* As we found in the previous practical the AIC value is meaningless by itself, but it will allow us to compare this model to another model with different terms (with the model with the smaller AIC value being the better fitting model).

## Assessing significance
First, we’ll look at whether the model is "well specified" overall. Roughly speaking "well specified" just means that our model can predict our dataset pretty well.


```r
glm_diabetes %>% 
  #augment()
  glance() %>%
  select(deviance, df.residual) %>% 
  as.numeric() %>% 
  #pchisq(x = .[1], df = .[2]) %>% 
  chisq_test()
```

```
## # A tibble: 1 × 6
##       n statistic     p    df method          p.signif
## * <int>     <dbl> <dbl> <dbl> <chr>           <chr>   
## 1     2     0.464 0.496     1 Chi-square test ns
```

```r
#install.packages("tidymodels")
library(tidymodels)
```

```
## Registered S3 method overwritten by 'tune':
##   method                   from   
##   required_pkgs.model_spec parsnip
```

```
## ── Attaching packages ────────────────────────────────────── tidymodels 0.1.4 ──
```

```
## ✓ dials        0.0.10     ✓ rsample      0.1.1 
## ✓ infer        1.0.0      ✓ tune         0.1.6 
## ✓ modeldata    0.1.1      ✓ workflows    0.2.4 
## ✓ parsnip      0.1.7      ✓ workflowsets 0.1.0 
## ✓ recipes      0.1.17     ✓ yardstick    0.0.9
```

```
## ── Conflicts ───────────────────────────────────────── tidymodels_conflicts() ──
## x infer::chisq_test() masks rstatix::chisq_test()
## x scales::discard()   masks purrr::discard()
## x rstatix::filter()   masks dplyr::filter(), stats::filter()
## x recipes::fixed()    masks stringr::fixed()
## x dials::get_n()      masks rstatix::get_n()
## x dplyr::lag()        masks stats::lag()
## x infer::prop_test()  masks rstatix::prop_test()
## x yardstick::spec()   masks readr::spec()
## x recipes::step()     masks stats::step()
## x infer::t_test()     masks rstatix::t_test()
## • Learn how to get started at https://www.tidymodels.org/start/
```

```r
library(glmnet)
```

```
## Loading required package: Matrix
```

```
## 
## Attaching package: 'Matrix'
```

```
## The following objects are masked from 'package:tidyr':
## 
##     expand, pack, unpack
```

```
## Loaded glmnet 4.1-3
```



```r
pchisq(752.2,726)
```

```
## [1] 0.757072
```

```r
1-pchisq(752.2,726)
```

```
## [1] 0.242928
```


## Exercise
:::exercise
We can add exercises

<details><summary>Answer</summary>
With answers
</details>
:::

## Key points

:::keypoints
Adding key points
:::
