# Time_Series_Decomposition_Based_on_Gaussian_Markov_Random_Fields

This contains replication materials for the UW CSSS/STAT 564 project of Bowen Xiao (some materials of course projects of STAT 504 and STAT 527 are also included).

The project is about time series decomposition based on markov random fields, which is a locally adaptive nonparametric curve fitting method that operates within a fully Bayesian framework. I decomposited a time series into trend part, seasonal part and random part by treating it as an additive model and doing markov random fields fitting twice. I also compared the results with some classical parametric techniques, like ARIMA, and machine learning techniques, like RNN/LSTM, with regard to forcasting.

Simulation study of GMRF and spatial model selection are also included.

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
    packages <- c("tidyverse","forecast","loo","bayesplot","e1071","splines","prophet")
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

Bike collision records in downtown Seattle from 01/2004 to 06/2017 counted by month, or that, the data contains 162 bike collision counts. Details could be seen at `data/TS.rda`. Spatial data could be seen at `doc/STAT 504/data.csv`.

## Main Results

- Time series decomposition and forcasting

<p align="center">
  <img src="https://github.com/xiaobw95/Time_Series_Decomposition_Based_on_Gaussian_Markov_Random_Fields/blob/master/results/fig/Time-series-decomposition.png" alt=""/>
</p>

<p align="center">
  <img src="https://github.com/xiaobw95/Time_Series_Decomposition_Based_on_Gaussian_Markov_Random_Fields/blob/master/results/fig/Performance-of-prediction.png" alt=""/>
</p>

<p align="center">
  <img src="https://github.com/xiaobw95/Time_Series_Decomposition_Based_on_Gaussian_Markov_Random_Fields/blob/master/results/tables/mse.png" alt=""/>
</p>

- Simulation study of GMRF

<p align="center">
  <img src="https://github.com/xiaobw95/Time_Series_Decomposition_Based_on_Gaussian_Markov_Random_Fields/blob/master/results/fig/simulation.png" alt=""/>
</p>

<p align="center">
  <img src="https://github.com/xiaobw95/Time_Series_Decomposition_Based_on_Gaussian_Markov_Random_Fields/blob/master/results/fig/mse-vs-sample-size.png" alt=""/>
</p>


- Spatial model selection

<p align="center">
  <img src="https://github.com/xiaobw95/Time_Series_Decomposition_Based_on_Gaussian_Markov_Random_Fields/blob/master/results/fig/figure7.png" alt=""/>
</p>

<p align="center">
  <img src="https://github.com/xiaobw95/Time_Series_Decomposition_Based_on_Gaussian_Markov_Random_Fields/blob/master/results/fig/Rtable.png" width="500" alt=""/>
</p>


## Build

- `R`: Load [`.RData`](https://drive.google.com/open?id=1H0L_5u71YViwD7_s2IoMt_YwND1FApYR), open `doc/Time-Series-Decomposition-Based-on-Markov-Random-Fields.Rmd` and knit the file.
- `Python`: `python src/Python/ts.py`

## Reference

[1]Faulkner, James R.; Minin, Vladimir N. Locally Adaptive Smoothing with Markov Random Fields and Shrinkage Priors. Bayesian Anal. 13 (2018), no. 1, 225--252. doi:10.1214/17-BA1050. https://projecteuclid.org/euclid.ba/1487905413
