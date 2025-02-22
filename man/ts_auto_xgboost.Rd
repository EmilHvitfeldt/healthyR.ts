% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/boilerplate-xgboost.R
\name{ts_auto_xgboost}
\alias{ts_auto_xgboost}
\title{Boilerplate Workflow}
\usage{
ts_auto_xgboost(
  .data,
  .date_col,
  .value_col,
  .formula,
  .rsamp_obj,
  .prefix = "ts_xgboost",
  .tune = TRUE,
  .grid_size = 10,
  .num_cores = 1,
  .cv_assess = 12,
  .cv_skip = 3,
  .cv_slice_limit = 6,
  .best_metric = "rmse",
  .bootstrap_final = FALSE
)
}
\arguments{
\item{.data}{The data being passed to the function. The time-series object.}

\item{.date_col}{The column that holds the datetime.}

\item{.value_col}{The column that has the value}

\item{.formula}{The formula that is passed to the recipe like \code{value ~ .}}

\item{.rsamp_obj}{The rsample splits object}

\item{.prefix}{Default is \code{ts_xgboost}}

\item{.tune}{Defaults to TRUE, this creates a tuning grid and tuned model.}

\item{.grid_size}{If \code{.tune} is TRUE then the \code{.grid_size} is the size of the
tuning grid.}

\item{.num_cores}{How many cores do you want to use. Default is 1}

\item{.cv_assess}{How many observations for assess. See \code{\link[timetk:time_series_cv]{timetk::time_series_cv()}}}

\item{.cv_skip}{How many observations to skip. See \code{\link[timetk:time_series_cv]{timetk::time_series_cv()}}}

\item{.cv_slice_limit}{How many slices to return. See \code{\link[timetk:time_series_cv]{timetk::time_series_cv()}}}

\item{.best_metric}{Default is "rmse". See \code{\link[modeltime:metric_sets]{modeltime::default_forecast_accuracy_metric_set()}}}

\item{.bootstrap_final}{Not yet implemented.}
}
\value{
A list
}
\description{
This is a boilerplate function to create automatically the following:
\itemize{
\item recipe
\item model specification
\item workflow
\item tuned model (grid ect)
\item calibration tibble and plot
}
}
\details{
This uses the \code{parsnip::boost_tree()} with the \code{engine} set to \code{xgboost}
}
\examples{
\dontrun{
library(dplyr)

data <- AirPassengers \%>\%
  ts_to_tbl() \%>\%
  select(-index)

splits <- time_series_split(
  data
  , date_col
  , assess = 12
  , skip = 3
  , cumulative = TRUE
)

ts_xgboost <- ts_auto_xgboost(
  .data = data,
  .num_cores = 1,
  .date_col = date_col,
  .value_col = value,
  .rsamp_obj = splits,
  .formula = value ~ .,
  .grid_size = 2
)

ts_xgboost$recipe_info
}

}
\seealso{
Other Boiler_Plate: 
\code{\link{ts_auto_arima_xgboost}()},
\code{\link{ts_auto_arima}()},
\code{\link{ts_auto_croston}()},
\code{\link{ts_auto_exp_smoothing}()},
\code{\link{ts_auto_glmnet}()},
\code{\link{ts_auto_lm}()},
\code{\link{ts_auto_mars}()},
\code{\link{ts_auto_nnetar}()},
\code{\link{ts_auto_prophet_boost}()},
\code{\link{ts_auto_prophet_reg}()},
\code{\link{ts_auto_smooth_es}()},
\code{\link{ts_auto_svm_poly}()},
\code{\link{ts_auto_svm_rbf}()},
\code{\link{ts_auto_theta}()}
}
\author{
Steven P. Sanderson II, MPH
}
\concept{Boiler_Plate}
\concept{xgboost}
