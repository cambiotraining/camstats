
```
## Registered S3 method overwritten by 'tune':
##   method                   from   
##   required_pkgs.model_spec parsnip
```

```
## ── Attaching packages ────────────────────────────────────── tidymodels 0.1.4 ──
```

```
## ✓ dials        0.1.0     ✓ rsample      0.1.1
## ✓ infer        1.0.0     ✓ tune         0.1.6
## ✓ modeldata    0.1.1     ✓ workflows    0.2.4
## ✓ parsnip      0.2.0     ✓ workflowsets 0.1.0
## ✓ recipes      0.2.0     ✓ yardstick    0.0.9
```

```
## ── Conflicts ───────────────────────────────────────── tidymodels_conflicts() ──
## x scales::discard() masks purrr::discard()
## x dplyr::filter()   masks stats::filter()
## x recipes::fixed()  masks stringr::fixed()
## x dplyr::lag()      masks stats::lag()
## x yardstick::spec() masks readr::spec()
## x recipes::step()   masks stats::step()
## x tune::tune()      masks parsnip::tune()
## • Dig deeper into tidy modeling with R at https://www.tmwr.org
```

```
## Warning: 'xaringanExtra::style_panelset' is deprecated.
## Use 'style_panelset_tabs' instead.
## See help("Deprecated")
```

`<style>.panelset{--panel-tab-font-family: inherit;}</style>`{=html}

# Logistic Models – Binary Response

## Objectives
:::objectives
**Questions**

- 

**Objectives**

- 
:::

## Libraries and functions

::::: {.panelset}

::: {.panel}
[tidyverse]{.panel-name}

| Library| Description|
|:- |:- |
|`tidyverse`| A collection of R packages designed for data science |
|`tidymodels`| A collection of packages for modelling and machine learning using tidyverse principles |

:::
:::::

## Datasets

::::: {.panelset}
::: {.panel}
[Diabetes]{.panel-name}

The example in this section uses the following data set:

`data/diabetes.csv`

This is a data set comprising 768 observations of three variables (one dependent and two predictor variables). This records the results of a diabetes test result as a binary variable (1 is a positive result, 0 is a negative result), along with the result of a glucose test and the diastolic blood pressure for each of 767 women. The variables are called `test_result`, `glucose` and `diastolic`.
:::
:::::

## Visualise the data
First we load the data, then we visualise it. If needed, load the tidyverse package using:

::::: {.panelset}
::: {.panel}
[tidyverse]{.panel-name}
First, we load and inspect the data:


```r
diabetes <- read_csv("data/diabetes.csv")
```

Looking at the data, we can see that the `test_result` column contains zeros and ones. These are test result outcomes and not actually numeric representations.

This will cause problems later, so we need to tell R to see these values as factors. For good measure we'll also improve the information in `test_result` by classifying it as 'negative' (0) or 'positive' (1).


```r
diabetes <- 
diabetes %>% 
  # replace 0 with 'negative' and 1 with 'positive'
  mutate(test_result = case_when(test_result == 0 ~ "negative",
                                 TRUE ~ "positive")) %>% 
  # convert character columns to factor
  mutate_if(is.character, factor)
```

We can plot the data:


```r
diabetes %>% 
  ggplot(aes(x = test_result, y = glucose)) +
  geom_boxplot()
```

<img src="glm-practical-logistic-binary_files/figure-html/unnamed-chunk-4-1.png" width="672" />

It looks as though the patients with a positive diabetes test have slightly higher glucose levels than those with a negative diabetes test.

We can visualise that differently by plotting all the data points as a classic binary response plot:


```r
diabetes %>% 
  ggplot(aes(x = glucose, y = test_result)) +
  geom_point()
```

<img src="glm-practical-logistic-binary_files/figure-html/unnamed-chunk-5-1.png" width="672" />
:::
:::::

## Construct the model
There are different ways to construct a logistic model.

::::: {.panelset}

::: {.panel}
[tidyverse]{.panel-name}

In `tidymodels` we have access to a very useful package: `parsnip`, which provides a common syntax for a whole range of modelling libraries. This means that the syntax will stay the same as you do different kind of model comparisons. So, the learning curve might be a bit steeper to start with, but this will pay dividend in the long-term (just like when you started using R!).

First, we need to load `tidymodels` (install it first, if needed):


```r
# install.packages("tidymodels")
library(tidymodels)
```

The workflow in `parsnip` is a bit different to what we're used to so far. Up until now, we've directly used the relevant model functions to analyse our data, for example using the `lm()` function to create linear models.

Using `parsnip` we approach things in a more systematic manner. At first this might seem unnecessarily verbose, but there are clear advantages to approaching your analysis in a systematic way. For example, it will be straightforward to implement other types of models using the same workflow, which you'll definitely find useful when moving on to more difficult modelling tasks.

Using `tidymodels` we specify a model in three steps:

1. **Specify the type of model based on its mathematical structure** (e.g., linear regression, random forest, K-nearest neighbors, etc).
2. **When required, declare the mode of the model.** The mode reflects the type of prediction outcome. For numeric outcomes, the mode is regression; for qualitative outcomes, it is classification. If a model can only create one type of model, such as logistic regression, the mode is already set.
3. **Specify the engine for fitting the model.** This usually is the software package or library that should be used.

So, we can create the model as follows:


```r
dia_mod <- logistic_reg() %>% 
  set_mode("classification") %>% 
  set_engine("glm")
```

Note that we are not actually specifying any of the variables just yet! All we've done is tell R what kind of model we're planning to use. If we want to see how `parsnip` converts this code to the package syntax, we can check this with `translate()`:


```r
dia_mod %>% translate()
```

```
## Logistic Regression Model Specification (classification)
## 
## Computational engine: glm 
## 
## Model fit template:
## stats::glm(formula = missing_arg(), data = missing_arg(), weights = missing_arg(), 
##     family = stats::binomial)
```

This shows that we have a logistic regression model, where the outcome is going to be a classification (in our case, that's a positive or negative test result). The model fit template tells us that we'll be using the `glm()` function from the `stats` package, which can take a `formula`, `data`, `weights` and `family` argument. The `family` argument is already set to binomial.

Now we've specified what kind of model we're planning to use, we can fit our data to it, using the `fit()` function:


```r
dia_fit <- dia_mod %>% 
  fit(test_result ~ glucose,
      data = diabetes)
```

We can look at the output directly, but I prefer to tidy the data up using the `tidy()` function from `broom` package:


```r
dia_fit %>% tidy()
```

```
## # A tibble: 2 × 5
##   term        estimate std.error statistic  p.value
##   <chr>          <dbl>     <dbl>     <dbl>    <dbl>
## 1 (Intercept)  -5.61     0.442       -12.7 6.90e-37
## 2 glucose       0.0395   0.00340      11.6 2.96e-31
```

The `estimate` column gives you the coefficients of the logistic model equation. We could use these to calculate the probability of having a positive diabetes test, for any given glucose level, using the following equation:

\begin{equation}
P(positive \ test_result) = \frac{1}{1 + {e}^{-(-5.61 +  0.040 \cdot glucose)}}
\end{equation}

But of course we're not going to do it that way. We'll let R deal with that in the next section.

The `std.error` column gives you the error associated with the coefficients and the `statistic` column tells you the statistic value.

The values in `p.value` merely show whether that particular coefficient is significantly different from zero. This is similar to the p-values obtained in the summary output of a linear model, and as before, for continuous predictors these p-values can be used as a rough guide as to whether that predictor is important (so in this case glucose appears to be significant). However, these p-values aren’t great when we have multiple predictor variables, or when we have categorical predictors with multiple levels (since the output will give us a p-value for each level rather than for the predictor as a whole).
:::
:::::

## Using the model to make predictions
What if we got some new glucose level data and we wanted to predict if people might have diabetes or not?

We could use the existing model and feed it the some data:

::::: {.panelset}
::: {.panel}
[tidyverse]{.panel-name}


```r
# create a dummy data set using some hypothetical glucose measurements
diabetes_newdata <- tibble(glucose = c(188, 122, 83, 76, 144))

# predict if the patients have diabetes or not
augment(dia_fit,
        new_data = diabetes_newdata)
```

```
## # A tibble: 5 × 4
##   glucose .pred_class .pred_negative .pred_positive
##     <dbl> <fct>                <dbl>          <dbl>
## 1     188 positive             0.140         0.860 
## 2     122 negative             0.688         0.312 
## 3      83 negative             0.912         0.0885
## 4      76 negative             0.931         0.0686
## 5     144 positive             0.481         0.519
```

Although you are able to get the predicted outcomes (in `.pred_class`), I would like to stress that this is not the point of running the model. It is important to realise that the model (as with all statistical models) creates a predicted outcome based on certain _probabilities_. It is therefore much more informative to look at how probable these predicted outcomes are. They are encoded in `.pred_negative` and `.pred_positive`.

For the first value this means that there is a 14% chance that the diabetes test will return a negative result and around 86% chance that it will return a positive result.
:::
:::::

## Model evaluation
So far we've constructed the logistic model and fed it some new data to make predictions to the possible outcome of a diabetes test, depending on the glucose level of a given patient. This gave us some diabetes test predictions but, more importantly, the probabilities of whether the test could come back negative or positive.

The question we'd like to ask ourselves at this point: how reliable is the model?

To explore this, we need to take a step back.

::::: {.panelset}

::: {.panel}
[tidyverse]{.panel-name}

### Split the data
When we created the model, we used _all_ of the data. However, a good way of assessing a model fit is to actually split the data into two:

1. a **training data set** that you use to fit your model
2. a **test data set** to validate your model and measure model performance

Before we split the data, let's have a closer look at the data set. If we count how many diabetes test results are negative (0) and positive (1), we see that these counts are not evenly split.


```r
diabetes %>% 
  count(test_result) %>% 
  mutate(prop = n/sum(n))
```

```
## # A tibble: 2 × 3
##   test_result     n  prop
##   <fct>       <int> <dbl>
## 1 negative      478 0.657
## 2 positive      250 0.343
```

This can have some consequences if we start splitting our data into a training and test set. By splitting the data into two parts - where most of the data goes into your training set - you have data left afterwards that you can use to test how good the predictions of your model are. However, we need to make sure that the _proportion_ of negative and positive diabetes test outcomes remains roughly the same.

The `rsample` package has a couple of useful functions that allow us to do just that and we can use the `strata` argument to keep these proportions more or less the same.


```r
# Use 75% of the data to create the training data set
data_split <- initial_split(diabetes, strata = test_result)

# Create data frames for the two sets:
train_data <- training(data_split)
test_data  <- testing(data_split)
```

We can check what the `initial_split()` function has done:


```r
# proportion of data allocated to the training set
nrow(train_data) / nrow(diabetes)
```

```
## [1] 0.7486264
```

```r
# proportion of diabetes test results for the training and test data sets
train_data %>% 
  count(test_result) %>% 
  mutate(prop = n/sum(n))
```

```
## # A tibble: 2 × 3
##   test_result     n  prop
##   <fct>       <int> <dbl>
## 1 negative      358 0.657
## 2 positive      187 0.343
```

```r
test_data %>% 
  count(test_result) %>% 
  mutate(prop = n/sum(n))
```

```
## # A tibble: 2 × 3
##   test_result     n  prop
##   <fct>       <int> <dbl>
## 1 negative      120 0.656
## 2 positive       63 0.344
```

From the output we can see that around 75% of the data set has been used to create a training data set, with the remaining 25% kept as a test set.

Furthermore, the proportions of negative:positive is kept more or less constant.

### Create a recipe

```r
# Create a recipe
dia_rec <- 
  recipe(test_result ~ ., data = train_data)

# Look at the recipe summary
summary(dia_rec)
```

```
## # A tibble: 3 × 4
##   variable    type    role      source  
##   <chr>       <chr>   <chr>     <chr>   
## 1 glucose     numeric predictor original
## 2 diastolic   numeric predictor original
## 3 test_result nominal outcome   original
```

### Build a model specification

```r
dia_mod <- 
  logistic_reg() %>% 
  set_engine("glm")
```

### Use recipe as we train and test our model

```r
dia_wflow <- 
  workflow() %>% 
  add_model(dia_mod) %>% 
  add_recipe(dia_rec)

dia_wflow
```

```
## ══ Workflow ════════════════════════════════════════════════════════════════════
## Preprocessor: Recipe
## Model: logistic_reg()
## 
## ── Preprocessor ────────────────────────────────────────────────────────────────
## 0 Recipe Steps
## 
## ── Model ───────────────────────────────────────────────────────────────────────
## Logistic Regression Model Specification (classification)
## 
## Computational engine: glm
```

Although it seems a bit of overkill, we now have a single function that can we can use to prepare the recipe and train the model from the resulting predictors:


```r
dia_fit <- 
  dia_wflow %>% 
  fit(data = train_data)
```

This creates an object called `dia_fit`, which contains the final recipe and fitted model objects. We can extract the model and recipe objects with several helper functions:


```r
dia_fit %>% 
  extract_fit_parsnip() %>% 
  tidy()
```

```
## # A tibble: 3 × 5
##   term        estimate std.error statistic  p.value
##   <chr>          <dbl>     <dbl>     <dbl>    <dbl>
## 1 (Intercept)  -7.13     0.782       -9.12 7.61e-20
## 2 glucose       0.0378   0.00388      9.72 2.41e-22
## 3 diastolic     0.0240   0.00872      2.75 6.03e- 3
```

### Use trained workflow for predictions
So far, we have done the following:

1. Built the model (`dia_mod`),
2. Created a pre-processing recipe (`dia_rec`),
3. Combined the model and recipe into a workflow (`dia_wflow`)
4. Trained our workflow using the `fit()` function (`dia_fit`)

The results we generated above do not differ much from the values we obtained with the entire data set. However, these are based on 3/4 of the data (our training data set). Because of this, we still have our test data set available to apply this workflow to data the model has not yet seen.


```r
dia_aug <- 
augment(dia_fit, test_data)

dia_aug
```

```
## # A tibble: 183 × 6
##    glucose diastolic test_result .pred_class .pred_negative .pred_positive
##      <dbl>     <dbl> <fct>       <fct>                <dbl>          <dbl>
##  1     137        40 positive    negative            0.731           0.269
##  2     197        70 positive    positive            0.121           0.879
##  3     110        92 negative    negative            0.685           0.315
##  4     115        70 positive    negative            0.753           0.247
##  5     196        90 positive    positive            0.0813          0.919
##  6      97        66 negative    negative            0.869           0.131
##  7     138        76 negative    negative            0.525           0.475
##  8     111        72 positive    negative            0.771           0.229
##  9     103        66 positive    negative            0.841           0.159
## 10     187        68 positive    positive            0.174           0.826
## # … with 173 more rows
```

### Evaluate the model
We can now evaluate the model. One way of doing this is by using the area under the ROC curve as a metric.


```r
dia_aug %>% 
  roc_curve(truth = test_result, .pred_negative) %>% 
  autoplot()
```

<img src="glm-practical-logistic-binary_files/figure-html/unnamed-chunk-21-1.png" width="672" />

```r
dia_aug %>% 
  filter(test_result == .pred_class) %>% 
  count(test_result) %>% 
  mutate(prop = n/sum(n))
```

```
## # A tibble: 2 × 3
##   test_result     n  prop
##   <fct>       <int> <dbl>
## 1 negative      102 0.761
## 2 positive       32 0.239
```

```r
dia_aug %>% 
  count(test_result) %>% 
  mutate(prop = n/sum(n))
```

```
## # A tibble: 2 × 3
##   test_result     n  prop
##   <fct>       <int> <dbl>
## 1 negative      120 0.656
## 2 positive       63 0.344
```


```r
dia_aug %>% 
  roc_auc(truth = test_result, .pred_negative)
```

```
## # A tibble: 1 × 3
##   .metric .estimator .estimate
##   <chr>   <chr>          <dbl>
## 1 roc_auc binary         0.761
```
:::
:::::

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
