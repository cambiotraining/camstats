

# Single predictor permutation tests

## Objectives
:::objectives
**Questions**

- 

**Objectives**

- 
:::

## Purpose and aim
If we wish to test for a difference between two groups in the case where the assumptions of a two-sample t-test just aren’t met, then a two-sample permutation test procedure is appropriate. It is also appropriate even if the assumptions of a t-test are met, but in that case, it would be easier to just do the damn t-test.

One of the additional benefits of permutation test is that we aren’t just restricted to testing hypotheses about the means of the two groups. We can test hypotheses about absolutely anything we want! So, we could see if the ranges of the two groups differed significantly etc.


## Data and hypotheses
Let’s consider an experimental dataset where we have measured the weights of two groups of 12 female mice (so 24 mice in total). One group of mice was given a perfectly normal diet (control) and the other group of mice was given a high fat diet for several months. We want to test whether there is any difference in the mean weight of the two groups. We still need to specify the hypotheses:

$H_0$: there is no difference in the means of the two groups
$H_1$: there is a difference in the means of the two groups

## Load the data
First we load the data, then we visualise it. If needed, load the tidyverse package using:


```r
library(tidyverse)
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
