
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
## • Search for functions across packages at https://www.tidymodels.org/find/
```

# (PART) Generalised linear models {.unnumbered}

# Introduction {#glm-intro}

## Objectives
:::objectives
**Aim: To introduce R commands for analysing data with non-continuous response variables.**

By the end of this practical participants should be able to achieve the following:

1.	Construct
    a.	a logistic model for binary response variables
    b.	a logistic model for proportion response variables
    c.	a Poisson model for count response variables
    d.	a Negative Binomial model for count response variables
2.	Plot the data and the fitted curve in each case for both continuous and categorical predictors
3.	Assess the significance of fit
4.	Assess assumption of the model
:::

## Background
This practical is divided into sections that considers each sort of response variable and generalised linear model in turn. Within each section there will be at least one example of the modelling process followed by an example.
