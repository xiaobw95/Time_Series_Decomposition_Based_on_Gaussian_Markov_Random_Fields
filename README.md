# Time_Series_Decomposition_Based_on_Gaussian_Markov_Random_Fields

This contains replication materials for the UW CSSS/STAT 564 project of Bowen Xiao (some materials of course projects of STAT 504 and STAT 527 are also included).

## Organization

-   `README.md`: This file, describing the content project.

-   `doc`: Documents and analysis

    -   `Time-Series-Decomposition-Based-on-Markov-Random-Fields.Rmd`: this is my main analysis.
    -   `proposal.Rmd`: Research proposal.
    -   `STAT 504`: this folder includes materials of course project of STAT 504.

-   `src`: Any R scripts (`.R`), Stan models (`.stan`) and Python scripts (`.py`) used in the analysis.

-   `data`: Input data used in the analysis. Files in this directory should be treated as read only.

-   `results`: Any outputs produced by scripts, e.g., datasets, tables, plots.

## Install
- `R`
    This project depends on [R](https://cran.r-project.org/) and [rstan](http://mc-stan.org/users/interfaces/rstan). You will need to install several R packages for this project:

    [rstan install](https://github.com/stan-dev/rstan/wiki/RStan-Getting-Started)

    ```r
    # List of the packages this project depends on
    packages <- c("tidyverse","forecast","loo","bayesplot","e1071","splines")
    if(!require(packages)){
    install.packages(packages)
    require(packages)
    }
    ```

- `Python`

    A [RNN/LSTM](https://machinelearningmastery.com/time-series-forecasting-long-short-term-memory-network-python/) written in Python is also included for comparison.

    Either Python 2 or 3 is okay.

    You must have Keras (2.0 or higher) installed with either the TensorFlow or Theano backend.

    You also should have scikit-learn, Pandas, NumPy and Matplotlib installed.

## Data

Bike collision records in downtown Seattle from 01/2004 to 06/2017 counted by month, or that, the data contains 162 bike collision counts. Details could be seen at `data/TS.rda`.

## Build

- `R`: Open `doc/Time-Series-Decomposition-Based-on-Markov-Random-Fields.Rmd` and knit the file.
- `Python`: `python src/Python/ts.py`

## Reference

[1]Faulkner, James R.; Minin, Vladimir N. Locally Adaptive Smoothing with Markov Random Fields and Shrinkage Priors. Bayesian Anal. 13 (2018), no. 1, 225--252. doi:10.1214/17-BA1050. https://projecteuclid.org/euclid.ba/1487905413