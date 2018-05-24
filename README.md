# Project Title

This contains replication materials for the CSSS/STAT 564 project of Bowen Xiao.

## Organization

-   `README.md`: This file, describing the content project.

-   `doc`: Documents and analysis

    -   `Time-Series-Decomposition-Based-on-Markov-Random-Fields.Rmd`: this is my main analysis.
    -   `proposal.Rmd`: Research proposal.

-   `src`: Any R scripts (`.R`) and Stan models (`.stan`) used in the analysis.

-   `data`: Input data used in the analysis. Files in this directory should be treated as read only.

-   `results`: Any outputs produced by scripts, e.g., datasets, tables, plots.

## Install

This project depends on [R](https://cran.r-project.org/) and [rstan](http://mc-stan.org/users/interfaces/rstan).
You will need to install several R packages for this project:

```r
# List of the packages this project depends on
packages <- c("rstan","tidyverse","forecast","loo","bayesplot","e1071","splines")
if(!require(packages)){
  install.packages(packages)
  require(packages)
}
```

## Data

Bike collision records in downtown Seattle from 01/2004 to 06/2017 counted by month, or that, the data contains 162 bike collision counts. Details could be seen at `data/TS.rda`.

## Build

Open `doc/Time-Series-Decomposition-Based-on-Markov-Random-Fields.Rmd` and knit the file.

## Reference

[1]Faulkner, James R.; Minin, Vladimir N. Locally Adaptive Smoothing with Markov Random Fields and Shrinkage Priors. Bayesian Anal. 13 (2018), no. 1, 225--252. doi:10.1214/17-BA1050. https://projecteuclid.org/euclid.ba/1487905413
