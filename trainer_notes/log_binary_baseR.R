::: {.panel}
[base R]{.panel-name}
In base R we use the `glm()` function, which works in a very similar way as the `lm()` function.

We define the model as follows:

  ```{r}
glm_diabetes_r <- glm(test_result ~ glucose,
                      data = diabetes,
                      family = binomial)
```
:::note
If you forget to include the family argument then the glm function just performs an ordinary linear model fit (same as the lm function)
:::

  Next, we can summarise the model with:

  ```{r}
summary(glm_diabetes_r)
```

There’s a lot to unpack here so take a deep breath (or make sure you have a coffee) before continuing...

* The first lines just confirm which model we’ve been fitting (trust me, this can be useful when you’re in the middle of a load of analysis and you’ve lost track of what the hell is going on!)

* The next block is called `Deviance Residuals`. This isn’t particularly useful, but just so you know: for linear models the residuals were calculated for each data point and then squared and added up to get the SS (sum of squares), which is used to fit the model. For generalised linear models we don’t use SS to fit the model and instead we use an entirely different method called maximum likelihood. This fitting procedure generates a different quantity, called Deviance, which is the analogue of SS. A deviance of zero indicates the best model we could hope for and bigger values indicate a model that doesn’t fit quite as well. The deviance residuals are then values associated with each data point, that when squared and summed give the deviance for the model (an exact analogy to normal residuals). You’re unlikely to ever need to know this, but I had some time on my hands and decided to share this little nugget with you 😉.

* The `Coefficients` block is next. The main numbers to extract from the output are the two numbers underneath `Estimate.Std`: we have `(Intercept) -5.611732` and `glucose 0.039510`.These are the coefficients of the logistic model equation and need to be placed in the correct equation if we want to be able to calculate the probability of having a positive diabetes test result for a given glucose level.

\begin{equation}
P(positive \ test_result) = \frac{1}{1 + {e}^{-(-5.61 +  0.040 \cdot glucose)}}
\end{equation}

* The p values (`Pr(>|z|`) at the end of each coefficient row merely show whether that particular coefficient is significantly different from zero. This is similar to the p-values obtained in the summary output of a linear model, and as before, for continuous predictors these p-values can be used as a rough guide as to whether that predictor is important (so in this case glucose appears to be significant). However, these p-values aren’t great when we have multiple predictor variables, or when we have categorical predictors with multiple levels (since the output will give us a p-value for each level rather than for the predictor as a whole).

* The next line tells us that the dispersion parameter was assumed to be 1 for this binomial model. Dispersion is a property that says whether the data were more or less spread out around the logistic curve than we would expect. A dispersion parameter of 1 says that the data are spread out exactly as we would expect. Greater than 1 is called over-dispersion and less than 1 is called under-dispersion. Here this line is saying that when we fitted this model, we were assuming that the dispersion of the data was exactly 1. For binary data, like we have here, the data cannot be over- or under-dispersed but this is something that we’ll need to check for other sorts of generalised linear models.

* The last three lines relate to quantities called deviance and AIC (Akaike Information Criterion).
* As we said just above, the deviance values are the equivalent of Sums of Squares values in linear models (and are a product of the technique used to fit the curve to the data). They can be used as a metric of goodness of fit for the model, with a deviance of 0 indicating a perfect fitting model. The deviance for the null model (i.e. the model without any predictors, basically saying that the probability of getting a positive diabetes score is constant and doesn’t depend on glucose level) is given by the first line and the deviance for the actual model is given by the residual deviance line. We will see how we can use the deviance to do two things.
1. to check of whether the model is actually any good (i.e. does it in any way look like it’s close to the data). This is akin to what we were doing with R2 values in linear models.
2.	to check if the model we’ve specified is better than the null model.
It’s important to realise that these two things can be independent of each other; we can have a model that is significantly better than a null model whilst still being rubbish overall (the null model will have been even more rubbish in comparison), and we can have a model that is brilliant yet still not be better than the null model (in this case the null model was already brilliant).
* As we found in the previous practical the AIC value is meaningless by itself, but it will allow us to compare this model to another model with different terms (with the model with the smaller AIC value being the better fitting model).

:::
