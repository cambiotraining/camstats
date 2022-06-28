

# (PART) Resampling techniques {.unnumbered}

# Introduction {#resampling-intro}

## Objectives
:::objectives
**Aim: To introduce R/Python commands and algorithms for conducting simple permutation tests.**

By the end of this practical participants should be able to perform

1.	Monte Carlo permutation tests for
    a.	Two-samples of continuous data
    b.	Multiple samples of continuous data
    c.	Simple Linear Regression
    d.	Two-way anova

and understand how to apply these techniques more generally.
:::

## Background
All traditional statistical test make use of various named distributions (normally the normal distribution, lol, for parametric tests like the t-test or ANOVA) in order to work properly, or they require certain assumptions to be made about the parent distribution (such as the shape of the distribution is symmetric for non-parametric tests like Wilcoxon). If these assumptions are met then traditional statistical tests are fine, but what can we do when we can’t assume normality or if the distribution of the data is just weird?

Resampling techniques are the tools that work here. They can allow us to test hypotheses about our data using only the data itself (without appeal to any assumptions about the shape or form of the parent distribution). They are in some ways a much simpler approach to statistics, but because they rely on the ability to generate thousands and tens of thousands of random numbers very quickly, they simply weren’t considered practical back in the day. Even now, they aren’t widely used because they require the user (you, in case you’d forgotten what’s going on at this time of day) to do more than click a button on a stats package or even know the name of the test. These techniques require a mix of statistical knowledge and programming; a combination of skills that isn’t all that common! There are three broad areas of resampling methods (although they are all quite closely related):

1.	Permutation Methods
2.	Bootstrapping
3.	Cross-validation

Permutation methods are what we will focus on in this practical and they allow us to carry out hypothesis testing.

Bootstrapping is a technique for estimating confidence intervals for parameter estimates. We effectively treat our dataset as if it was the parent distribution, draw samples from it and calculate the statistic of choice (the mean usually) using these sub-samples. If we repeat this process many times, we will eventually be able to construct a distribution for our sample statistic. This can be used to give us a confidence interval for our statistic.

Cross-validation is at the heart of modern machine learning approaches but existed long before this technique became sexy/fashionable. You divide your dataset up into two sets: a training set that you use to fit your model and a testing set that you use to evaluate your model. This allows your model accuracy to be empirically measured. There are several variants of this technique (holdout, k-fold cross validation, leave-one-out-cross-validation (LOOCV), leave-p-out-cross-validation (LpOCV) etc.), all of which do essentially the same thing; the main difference between them being a trade-off between the amount of time it takes to perform versus the reliability of the method.

We won’t cover bootstrapping or cross-validation in this practical but feel free to Google them.
