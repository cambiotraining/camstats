
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

## Libraries and functions

::::: {.panelset}

::: {.panel}
[tidyverse]{.panel-name}

| Library| Description|
|:- |:- |
|`tidyverse`| A collection of R packages designed for data science |
|`broom`| Summarises key information about statistical objects in tidy tibbles |
|`modeldata`| Contains data sets used in documentation and testing for tidymodels packages.|

:::

::: {.panel}
[base R]{.panel-name}

| Library| Description|
|:- |:- |
|`modeldata`| Contains data sets used in documentation and testing for tidymodels packages.|

:::

:::::

## Workflow
K-means clustering is an iterative process. It follows the following steps:

1. Select the number of clusters to identify (e.g. K = 3)
2. Create centroids
3. Place centroids randomly in your data
4. Assign each data point to the closest centroid
5. Calculate the centroid of each new cluster
6. Repeat steps 4-5 until the clusters do not change

## Data
First we need some data! To liven things up a bit, we'll be using data from the `modeldata` package. This package has a whole bunch of interesting datasets for us to look at. I'll be using the `penguins` dataset to illustrate the K-means clustering, but I've highlighted some other data sets that you can try this on yourself.

::::: {.panelset}
::: {.panel}
[penguins]{.panel-name}

```r
# attach the data
data("penguins")
```
:::

::: {.panel}
[Alzheimer's]{.panel-name}

```r
# attach the data
data("ad_data")
```
:::
:::::

## Visualise the data
First of all, let's have a look at the data. It is always a good idea to get a sense of how your data.

::::: {.panelset}
::: {.panel}
[tidyverse]{.panel-name}

```r
penguins
```

```
## # A tibble: 344 × 7
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
## # … with 334 more rows, and 1 more variable: sex <fct>
```
:::

::: {.panel}
[base R]{.panel-name}

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
:::

:::::

So we have different types of penguins, from different islands. Bill and flipper measurements were taken, and the penguins' weight plus sex was recorded.

So let's have a look at flipper length versus bill length, as an example.

::::: {.panelset}
::: {.panel}
[tidyverse]{.panel-name}

```r
ggplot(penguins, aes(x = flipper_length_mm,
                     y = bill_length_mm,
                     colour = species)) +
  geom_point()
```

<img src="clustering-practical-kmeans_files/figure-html/unnamed-chunk-6-1.png" width="672" />
:::

::: {.panel}
[base R]{.panel-name}

```r
plot(penguins$flipper_length_mm,  # scatter plot
     penguins$bill_length_mm,
     pch = 20,
     col = penguins$species)      # colour by species

legend("bottomright",             # legend
       legend = levels(penguins$species),
       pch = 20,
       col = factor(levels(penguins$species)))
```

<img src="clustering-practical-kmeans_files/figure-html/unnamed-chunk-7-1.png" width="672" />
:::
:::::

We can already see that the data appear to cluster quite closely by species. A great example to illustrate K-means clustering (you'd almost think I chose the example on purpose!)

## Clustering

Next, we'll do the actual clustering.

::::: {.panelset}

::: {.panel}
[tidyverse]{.panel-name}
To do the clustering, we'll be using the `kmeans()` function. This function requires numeric data as its input.


```r
points <-
  penguins %>% 
  select(flipper_length_mm,      # select data
         bill_length_mm) %>% 
  drop_na()                      # remove missing values

kclust <-
  kmeans(points,                 # perform k-means clustering
         centers = 3)            # using 3 centers

summary(kclust)                  # summarise output
```

```
##              Length Class  Mode   
## cluster      342    -none- numeric
## centers        6    -none- numeric
## totss          1    -none- numeric
## withinss       3    -none- numeric
## tot.withinss   1    -none- numeric
## betweenss      1    -none- numeric
## size           3    -none- numeric
## iter           1    -none- numeric
## ifault         1    -none- numeric
```

Note that the output is a list of vectors, with differing lengths. That's because they contain different types of information:

* `cluster` contains information about each point
* `centers`, `withinss`, and `size` contain information about each cluster
* `totss`, `tot.withinss`, `betweenss`, and `iter` contain information about the full clustering
:::

::: {.panel}
[base R]{.panel-name}
To do the clustering, we'll be using the `kmeans()` function. This function requires numeric data as its input.


```r
points_r <-
  data.frame(
    penguins$flipper_length_mm,  # get numeric data
    penguins$bill_length_mm) |>  # use base R pipe!
  na.omit()                      # remove missing data

kclust_r <-
  kmeans(points_r,               # perform k-means clustering
         centers = 3)            # using 3 centers

summary(kclust_r)                # summarise output
```

```
##              Length Class  Mode   
## cluster      342    -none- numeric
## centers        6    -none- numeric
## totss          1    -none- numeric
## withinss       3    -none- numeric
## tot.withinss   1    -none- numeric
## betweenss      1    -none- numeric
## size           3    -none- numeric
## iter           1    -none- numeric
## ifault         1    -none- numeric
```

Note that the output is a list of vectors, with differing lengths. That's because they contain different types of information:

* `cluster` contains information about each point
* `centers`, `withinss`, and `size` contain information about each cluster
* `totss`, `tot.withinss`, `betweenss`, and `iter` contain information about the full clustering
:::
:::::

## Visualise clusters
We can visualise the clusters that we calculated above.

::::: {.panelset}
::: {.panel}
[tidyverse]{.panel-name}
When we performed the clustering, the centers were calculated. These values give the (x, y) coordinates of the centroids.


```r
tidy_clust <- tidy(kclust) # get centroid coordinates

tidy_clust
```

```
## # A tibble: 3 × 5
##   flipper_length_mm bill_length_mm  size withinss cluster
##               <dbl>          <dbl> <int>    <dbl> <fct>  
## 1              197.           46.0    93    3932. 1      
## 2              217.           47.6   129    6658. 2      
## 3              187.           38.4   120    3494. 3
```

:::note
The initial centroids get randomly placed in the data. This, combined with the iterative nature of the process, means that the values that you will see are going to be slightly different from the values here. That's normal!
:::

Next, we want to visualise the which data points belong to which cluster. We can do that as follows:


```r
kclust %>%                              # take clustering data
  augment(points) %>%                   # combine with original data
  ggplot(aes(x = flipper_length_mm,     # plot the original data
             y = bill_length_mm)) +
  geom_point(aes(colour = .cluster)) +  # colour by classification
  geom_point(data = tidy_clust,
             size = 7, shape = "x")     # add the cluster centers
```

<img src="clustering-practical-kmeans_files/figure-html/unnamed-chunk-11-1.png" width="672" />
:::

::: {.panel}
[base R]{.panel-name}
When we performed the clustering, the centers were calculated. These values give the (x, y) coordinates of the centroids.


```r
kclust_r$centers  # get centroid coordinates
```

```
##   penguins.flipper_length_mm penguins.bill_length_mm
## 1                   216.8837                47.56744
## 2                   196.7312                45.95484
## 3                   186.9917                38.42750
```

:::note
The initial centroids get randomly placed in the data. This, combined with the iterative nature of the process, means that the values that you will see are going to be slightly different from the values here. That's normal!
:::

Next, we want to visualise the which data points belong to which cluster. We can do that as follows:


```r
plot(points_r,                # plot original data
     col = kclust_r$cluster,  # colour by cluster
     pch = 20)

points(kclust_r$centers,      # add cluster centers
       pch = 4,
       lwd = 3)
```

<img src="clustering-practical-kmeans_files/figure-html/unnamed-chunk-13-1.png" width="672" />
:::
:::::

## Optimising cluster number
In the example we set the number of clusters to 3. This made sense, because the data already visually separated in roughly three groups - one for each species.

However, it might be that the cluster number to choose is a lot less obvious. In that case it would be helpful to explore clustering your data into a range of clusters.

::::: {.panelset}
::: {.panel}
[tidyverse]{.panel-name}

```r
#tidy explore
```
:::

::: {.panel}
[base R]{.panel-name}

```r
#baseR explore
```
:::
:::::

From the exploration we can see that three clusters are optimal in this scenario.

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
