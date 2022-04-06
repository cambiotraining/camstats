`<style>.panelset{--panel-tab-font-family: inherit;}</style>`{=html}


# Principal component analysis (PCA)

## Objectives
:::objectives
**Questions**

- How do I...
- What do I...

**Objectives**

- Be able to...
- Use...
:::

## Purpose and aim
This is a statistical technique for reducing the dimensionality of a data set. The technique aims to find a new set of variables for describing the data. These new variables are made from a weighted sum of the old variables. The weighting is chosen so that the new variables can be ranked in terms of importance in that the first new variable is chosen to account for as much variation in the data as possible. Then the second new variable is chosen to account for as much of the remaining variation in the data as possible, and so on until there are as many new variables as old variables.

## Libraries and functions

::::: {.panelset}

::: {.panel}
[tidyverse]{.panel-name}

| Library| Description|
|:- |:- |
|`tidyverse`| A collection of R packages designed for data science |
|`tidymodels`| A collection of packages for modelling and machine learning using tidyverse principles |
|`palmerpenguins`| Contains data sets on penguins at the Palmer Station on Antartica.|
|`broom`| Summarises key information about statistical objects in tidy tibbles |
|`corrr`| A package for exploring correlations in R |
|`tidytext`| Makes text tidying easy

:::
:::::

## Data
First we need some data! To liven things up a bit, we'll be using data from the `palmerpenguins` package. This package has a whole bunch of data on penguins. What's not to love?

::::: {.panelset}
::: {.panel}
[Penguins]{.panel-name}
The `penguins` data set comes from `palmerpenguins` package (for more information, see [the GitHub page](https://github.com/allisonhorst/palmerpenguins)).
:::
:::::

## Visualise the data
First of all, let's have a look at the data. It is always a good idea to get a sense of how your data.

::::: {.panelset}
::: {.panel}
[tidyverse]{.panel-name}
First, we load and inspect the data:

```r
# attach the data
data(package = 'palmerpenguins')

# inspect the data
penguins
```

```
## # A tibble: 344 × 8
##    species island    bill_length_mm bill_depth_mm flipper_length_mm body_mass_g
##    <fct>   <fct>              <dbl>         <dbl>             <int>       <int>
##  1 Adelie  Torgersen           39.1          18.7               181        3750
##  2 Adelie  Torgersen           39.5          17.4               186        3800
##  3 Adelie  Torgersen           40.3          18                 195        3250
##  4 Adelie  Torgersen           NA            NA                  NA          NA
##  5 Adelie  Torgersen           36.7          19.3               193        3450
##  6 Adelie  Torgersen           39.3          20.6               190        3650
##  7 Adelie  Torgersen           38.9          17.8               181        3625
##  8 Adelie  Torgersen           39.2          19.6               195        4675
##  9 Adelie  Torgersen           34.1          18.1               193        3475
## 10 Adelie  Torgersen           42            20.2               190        4250
## # … with 334 more rows, and 2 more variables: sex <fct>, year <int>
```
:::
:::::

We can see that there are different kinds of variables, both factors and numerical. Also, there appear to be some missing data in the data set, so we probably have to deal with that.

Lastly, we should be careful with the `year` column: it is recognised as a numerical column (because it contains numbers), but we should view it as a factor, since the years have a categorical meaning.

To get a better sense of our data we could plot all the numerical variables against each other, to see if there is any possible correlation between them. However, there are quite a few of them, so it might be easier to just create a correlation matrix.

::::: {.panelset}

::: {.panel}
[tidyverse]{.panel-name}
First, we load the `corrr` package, which allows us to plot a correlation matrix using the `tidyverse` syntax:


```r
library(corrr)

penguins_corr <- penguins %>%
  select(where(is.numeric)) %>%  # select the numerical columns
  correlate() %>%                # calculate the correlations
  rearrange()                    # rearrange highly correlated
```

```
## 
## Correlation method: 'pearson'
## Missing treated using: 'pairwise.complete.obs'
```

```r
                                 # variables close together

penguins_corr
```

```
## # A tibble: 5 × 6
##   term         flipper_length_… body_mass_g bill_length_mm    year bill_depth_mm
##   <chr>                   <dbl>       <dbl>          <dbl>   <dbl>         <dbl>
## 1 flipper_len…           NA          0.871          0.656   0.170        -0.584 
## 2 body_mass_g             0.871     NA              0.595   0.0422       -0.472 
## 3 bill_length…            0.656      0.595         NA       0.0545       -0.235 
## 4 year                    0.170      0.0422         0.0545 NA            -0.0604
## 5 bill_depth_…           -0.584     -0.472         -0.235  -0.0604       NA
```

We get a message (not an error) that the correlation method used is `pearson`, which is the default. We also get a message about how the missing values are treated, with only complete pairwise comparisons made.
:::
:::::

We can see that there is, for example, a strong positive correlation between `flipper_length_mm` and `body_mass_g`. Other variable combinations seem reasonably well-correlated, such as `flipper_length_mm` and `bill_length_mm` (positive) or `flipper_length_mm` and `bill_depth_mm` (negative).

When there are so many different variables that appear to be correlated or, if you just have lots of variables in your data and you don't know where to look, then it can be useful to reduce the number of variables. We can do this with dimension reduction methods, of which Principal Component Analysis (PCA) is one.

Basically, a PCA replaces your original variables with new ones: the principal components. These principal components consist of parts of your original variables.

You could compare this with a smoothy consisting of, let's say, 80% orange, 10% strawberry and 10% banana (no kale).

Similarly, our new principal component could consist of 80% `flipper_length_mm`, 10% `body_mass_g` and 10% `bill_depth_mm` (still no kale).

::::: {.panelset}

::: {.panel}
[tidyverse]{.panel-name}
Before we perform the PCA, we'll use a few `recipe()` pre-processing steps:

1. remove any NA values
2. centre all predictors
3. scale all predictors


```r
penguin_recipe <-
  recipe(~., data = penguins) %>% 
  update_role(species, island, sex, year, new_role = "id") %>% 
  step_naomit(all_predictors()) %>% 
  step_normalize(all_predictors()) %>%
  step_pca(all_predictors(), id = "pca") %>% 
  prep()

penguin_pca <- 
  penguin_recipe %>% 
  tidy(id = "pca") 

penguin_pca
```

```
## # A tibble: 16 × 4
##    terms                value component id   
##    <chr>                <dbl> <chr>     <chr>
##  1 bill_length_mm     0.455   PC1       pca  
##  2 bill_depth_mm     -0.400   PC1       pca  
##  3 flipper_length_mm  0.576   PC1       pca  
##  4 body_mass_g        0.548   PC1       pca  
##  5 bill_length_mm    -0.597   PC2       pca  
##  6 bill_depth_mm     -0.798   PC2       pca  
##  7 flipper_length_mm -0.00228 PC2       pca  
##  8 body_mass_g       -0.0844  PC2       pca  
##  9 bill_length_mm    -0.644   PC3       pca  
## 10 bill_depth_mm      0.418   PC3       pca  
## 11 flipper_length_mm  0.232   PC3       pca  
## 12 body_mass_g        0.597   PC3       pca  
## 13 bill_length_mm     0.146   PC4       pca  
## 14 bill_depth_mm     -0.168   PC4       pca  
## 15 flipper_length_mm -0.784   PC4       pca  
## 16 body_mass_g        0.580   PC4       pca
```
:::
:::::

### Visualising PCs
Now that we've performed our PCA, we can have a bit of a closer look. A useful way of looking at how much your PCs (principal components) are contributing to the amount of variance that is being explained is to create a _screeplot_. Basically, this plots the percentage of explained variance for each PC.

::::: {.panelset}

::: {.panel}
[tidyverse]{.panel-name}
We can extract the relevant data directly from the `penguin_recipe` object:

```r
penguin_recipe %>% 
  tidy(id = "pca", type = "variance") %>% 
  filter(terms == "percent variance") %>% 
  ggplot(aes(x = component, y = value)) + 
  geom_col() + 
  xlim(c(0, 5)) +
  ylab("% of total variance")
```

<img src="clustering-practical-pca_files/figure-html/unnamed-chunk-5-1.png" width="672" />
:::
:::::

By definition, the first principal component (PC1) will always explain the largest amount of variation. In this case, PC1 explains almost 70% of our variance!

That's pretty good going, since it means that instead of having to look at four variables, we could look at just one but still capture 70% of our data. The number of variables in our data set is very manageable, so we probably wouldn't do this. However, if you have a data set with hundreds of variables, then seeing if they can be described well by using PCs is a very useful thing to do.

### Loadings
Let's think back to our smoothy metaphor. Remember how the smoothy was made up of various fruits - just like our PCs are made up of parts of our original variables.

Let's, for the sake of illustrating this, assume the following for PC1:

| parts| variable|
|:- |:- |
| 4 | `flipper_length_mm` |
| 1 | `body_mass_g` |

Each PC has something called an **eigenvector**, which in simplest terms is a line with a certain direction and length.

If we want to calculate the length of the eigenvector for PC1, we can employ Pythagoras (well, not directly, just his legacy). This gives:

$eigenvector \, PC1 = \sqrt{4^2 + 1^2} = 4.12$

The **loading scores** for PC1 are the "parts" scaled for this length, _i.e._:

| scaled parts| variable|
|:- |:- |
| 4 / 4.12 = 0.97 | `flipper_length_mm` |
| 1 / 4.12 = 0.24 | `body_mass_g` |

What we can do with these values is plot the loadings for each of the original variables. For example, if we plotted PC1 against PC2, and wanted to see how much the original variables contribute to each principal component, we would do the following:

::::: {.panelset}

::: {.panel}
[tidyverse]{.panel-name}
The loadings are encoded in the `value` column of the pca object (`penguin_pca`). To plot this, we need the data in a "wide" format:

```r
# get pca loadings into wider format
pca_wider <- penguin_pca %>% 
  pivot_wider(names_from = component, id_cols = terms)

pca_wider
```

```
## # A tibble: 4 × 5
##   terms                PC1      PC2    PC3    PC4
##   <chr>              <dbl>    <dbl>  <dbl>  <dbl>
## 1 bill_length_mm     0.455 -0.597   -0.644  0.146
## 2 bill_depth_mm     -0.400 -0.798    0.418 -0.168
## 3 flipper_length_mm  0.576 -0.00228  0.232 -0.784
## 4 body_mass_g        0.548 -0.0844   0.597  0.580
```

We can see that there are four terms (our original variables) and four PCs. This makes sense, because the maximum number of principal components cannot exceed the number of original variables.

We need to do a bit more data gymnastics, with defining an arrow style (vectors are represented using arrows), plotting the PCs, and plotting the loadings.

Arrow:

```r
# define arrow style
arrow_style <- arrow(length = unit(2, "mm"),
                     type = "closed")
```

To plot PC1 vs PC2, we need to extract the relevant data. All of the PCA-related data is stored in the `penguin_recipe` object. Since the people who developed `tidymodels` are quite fond of verbs (I'm really more of an adjective kind-of-guy myself...) they invented the `bake()` function.

The logic is: you follow a `recipe()` and then you `bake()` it. Yes, I know.

Anyways, we use this to get the data from our `penguin_recipe`, telling the function that it shouldn't expect any new data (the function is also used in model testing, where data is split in a training and test data set).


```r
bake(penguin_recipe, new_data = NULL)
```

```
## # A tibble: 342 × 8
##    species island    sex     year    PC1      PC2     PC3     PC4
##    <fct>   <fct>     <fct>  <int>  <dbl>    <dbl>   <dbl>   <dbl>
##  1 Adelie  Torgersen male    2007 -1.84  -0.0476   0.232   0.523 
##  2 Adelie  Torgersen female  2007 -1.30   0.428    0.0295  0.402 
##  3 Adelie  Torgersen female  2007 -1.37   0.154   -0.198  -0.527 
##  4 Adelie  Torgersen female  2007 -1.88   0.00205  0.618  -0.478 
##  5 Adelie  Torgersen male    2007 -1.91  -0.828    0.686  -0.207 
##  6 Adelie  Torgersen female  2007 -1.76   0.351   -0.0276  0.504 
##  7 Adelie  Torgersen male    2007 -0.809 -0.522    1.33    0.338 
##  8 Adelie  Torgersen <NA>    2007 -1.83   0.769    0.689  -0.427 
##  9 Adelie  Torgersen <NA>    2007 -1.19  -1.02     0.729   0.333 
## 10 Adelie  Torgersen <NA>    2007 -1.73   0.787   -0.205   0.0205
## # … with 332 more rows
```

It spits out the original table, but with the PC values instead of the original variables. We can then use that information to plot the PCs, focussing here on PC1 vs PC2:


```r
pca_plot <-
  bake(penguin_recipe, new_data = NULL) %>%
  ggplot(aes(PC1, PC2)) +
  geom_point(aes(colour = species, # colour the data
                 shape = species), # give it a shape
             alpha = 0.8,          # add transparency
             size = 2)             # make the data points bigger
```

Lastly (finally), we take this plot and add the loading data on top of it:


```r
pca_plot +
  # define the vector
  geom_segment(data = pca_wider,
               aes(xend = PC1, yend = PC2), 
               x = 0, 
               y = 0, 
               arrow = arrow_style) + 
  # add the text labels
  geom_text(data = pca_wider,
            aes(x = PC1, y = PC2, label = terms), 
            hjust = 0, 
            vjust = 1,
            size = 5) 
```

<img src="clustering-practical-pca_files/figure-html/unnamed-chunk-10-1.png" width="672" />
:::
:::::

Slightly annoyingly, this can cause some overlap in the labels. Also, if there are many different variables then this because rather hard to interpret because there will be a web of vectors.

But here things look pretty OK still. One thing that is immediately obvious from these data is that the Gentoo penguins PCs are quite distinct from the Adelie and Chinstrap species.

From a PC-perspective, the `flipper_length_mm` and `body_mass_g` variables make up most of PC1, since the vectors are almost horizontal.

In contrast, `bill_length_mm` and `bill_depth_mm` contribute a lot to PC2. They also contribute positively (`bill_length_mm`) and negatively (`bill_depth_mm`) to PC1.

Because the vectors can become a bit messy in terms of visualisation, it can be useful to represent the loadings differently. Note that, at this point, I'm not aware of a method that allows you to do this reasonably straightforward in anything other than R's tidyverse.

::::: {.panelset}

::: {.panel}
[tidyverse]{.panel-name}

```r
penguin_pca %>%
  mutate(terms = reorder_within(terms, 
                                abs(value), 
                                component)) %>%
  ggplot(aes(abs(value), terms, fill = value > 0)) +
  geom_col() +
  facet_wrap(~component, scales = "free_y") +
  tidytext::scale_y_reordered() +
  labs(
    x = "Absolute value of contribution",
    y = NULL, fill = "Positive?"
  ) 
```

<img src="clustering-practical-pca_files/figure-html/unnamed-chunk-11-1.png" width="672" />
:::
:::::

## Exercise

:::exercise ::::::

Exercise

::::: {.panelset}
::: {.panel}
[tidyverse]{.panel-name}

question

:::
:::::

<details><summary>Answer</summary>

::::: {.panelset}

::: {.panel}
[tidyverse]{.panel-name}

answer

:::
:::::

</details>

::::::::::::::::::

## Key points

:::keypoints
- Point 1
- Point 2
- Point 3
:::
