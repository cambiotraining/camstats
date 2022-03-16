--- 
title: "CamStats"
author: "Martin van Rongen and Matt Castle"
date: "2022-03-16"
site: bookdown::bookdown_site
documentclass: book
#bibliography: [book.bib, packages.bib]
# url: your book url like https://bookdown.org/yihui/bookdown
# cover-image: path to the social sharing image like images/cover.jpg
description: "These are the supporting materials for the CamStats series of the Bioinformatics Training Facility, Cambridge University. They are a collection of course materials on a variety of statistical topics that go beyond the Core statistics programme." 
---


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
## • Learn how to get started at https://www.tidymodels.org/start/
```

# Overview

These sessions are intended to enable you to perform additional data analysis techniques appropriately and confidently using R or Python.

- Ongoing formative assessment exercises
- No formal assessment

- No mathematical derivations
- No pen and paper calculations

They are **not** a "how to mindlessly use a stats program" course!

## Core aims
:::highlight
To know what to do when presented with an non-standard dataset e.g.

1. Know how to deal with non-normal data
2. Know how to analyse count data
3. Be able to deal with random effects
:::

## Core topics

1. [Generalised linear models](#glm-intro)


## Datasets {#index-datasets}

This course uses various data sets. The easiest way of accessing these is by creating an R-project in RStudio. Then download the `data` folder [here](camstats_data.zip) by right-clicking on the link and <kbd>Save as...</kbd>. Next unzip the file and copy it into your working directory. Your data should then be accessible via `<working-directory-name>/data`.
