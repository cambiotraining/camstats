
```
## Warning: 'xaringanExtra::style_panelset' is deprecated.
## Use 'style_panelset_tabs' instead.
## See help("Deprecated")
```

`<style>.panelset{--panel-tab-font-family: inherit;}</style>`{=html}

# K-means clustering {#kmeans}

## Objectives
:::objectives
Objectives
:::

## Workflow
K-means clustering is an iterative process. It follows the following steps:

1. Select the number of clusters to identify (e.g. K = 3)
2. Create centroids
3. Place centroids randomly in your data
4. Assign each data point to the closest centroid
5. Calculate the centroid of each new cluster
6. Repeat steps 4-5 until the clusters do not change

### Data {.panelset}
First we need some data! To liven things up a bit, we'll be using data from the `modeldata` package. This package has a whole bunch of interesting datasets for us to look at. I'll be using the `penguins` dataset to illustrate the K-means clustering, but I've highlighted some other data sets that you can try this on yourself.

#### penguins {.unnumbered}

```r
# run if needed
# install.packages("modeldata")

library(modeldata)
# attach the data
data(penguins)
```

#### Alzheimer's {.unnumbered}

```r
library(modeldata)
# attach the data
data(ad_data)
```

### Visualise the data {.panelset}
First of all, let's have a look at the data. It is always a good idea to get a sense of how your data.


```r
head(penguins)
```

```
## # A tibble: 6 × 7
##   species island bill_length_mm bill_depth_mm flipper_length_… body_mass_g sex  
##   <fct>   <fct>           <dbl>         <dbl>            <int>       <int> <fct>
## 1 Adelie  Torge…           39.1          18.7              181        3750 male 
## 2 Adelie  Torge…           39.5          17.4              186        3800 fema…
## 3 Adelie  Torge…           40.3          18                195        3250 fema…
## 4 Adelie  Torge…           NA            NA                 NA          NA <NA> 
## 5 Adelie  Torge…           36.7          19.3              193        3450 fema…
## 6 Adelie  Torge…           39.3          20.6              190        3650 male
```

So we have different types of penguins, from different islands. Bill and flipper measurements were taken, and the penguins' weight plus sex was recorded.

So let's have a look at flipper length versus bill length, as an example.

#### tidyverse {.unnumbered}

```r
ggplot(penguins, aes(x = flipper_length_mm,
                     y = bill_length_mm,
                     colour = species)) +
  geom_point()
```

<img src="clustering-practical-kmeans_files/figure-html/unnamed-chunk-5-1.png" width="672" />

#### base R {.unnumbered}


```r
# scatter plot
plot(penguins$flipper_length_mm,
     penguins$bill_length_mm,
     pch = 19,
     col = penguins$species)

# legend
legend("bottomright",
       legend = levels(penguins$species),
       pch = 19,
       col = factor(levels(penguins$species)))
```

<img src="clustering-practical-kmeans_files/figure-html/unnamed-chunk-6-1.png" width="672" />

We can already see that the data appear to cluster quite closely by species. A great example to illustrate K-means clustering (you'd almost think I chose the example on purpose!)


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
