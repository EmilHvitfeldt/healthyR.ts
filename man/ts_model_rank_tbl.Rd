% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ts-model-rank.R
\name{ts_model_rank_tbl}
\alias{ts_model_rank_tbl}
\title{Model Rank}
\usage{
ts_model_rank_tbl(.calibration_tbl)
}
\arguments{
\item{.calibration_tbl}{A calibrated modeltime table.}
}
\value{
A tibble with models ranked by metric performance order
}
\description{
This takes in a calibration tibble and computes the ranks of the
models inside of it.
}
\details{
This takes in a calibration tibble and computes the ranks of the models inside
of it. It computes for now only the default \code{yardstick} metrics from \code{modeltime}
These are the following using the \code{dplyr} \code{min_rank()} function with \code{desc} use
on \code{rsq}:
\itemize{
\item "rmse"
\item "mae"
\item "mape"
\item "smape"
\item "rsq"
}
}
\examples{
# NOT RUN
\dontrun{
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(timetk))
suppressPackageStartupMessages(library(modeltime))
suppressPackageStartupMessages(library(rsample))
suppressPackageStartupMessages(library(workflows))
suppressPackageStartupMessages(library(parsnip))
suppressPackageStartupMessages(library(recipes))

data_tbl <- ts_to_tbl(AirPassengers) \%>\%
  select(-index)

splits <- time_series_split(
  data_tbl,
  date_var = date_col,
  assess = "12 months",
  cumulative = TRUE
)

rec_obj <- recipe(value ~ ., training(splits))

model_spec_arima <- arima_reg() \%>\%
  set_engine(engine = "auto_arima")

model_spec_mars <- mars(mode = "regression") \%>\%
  set_engine("earth")

wflw_fit_arima <- workflow() \%>\%
  add_recipe(rec_obj) \%>\%
  add_model(model_spec_arima) \%>\%
  fit(training(splits))

wflw_fit_mars <- workflow() \%>\%
  add_recipe(rec_obj) \%>\%
  add_model(model_spec_mars) \%>\%
  fit(training(splits))

model_tbl <- modeltime_table(wflw_fit_arima, wflw_fit_mars)

calibration_tbl <- model_tbl \%>\%
  modeltime_calibrate(new_data = testing(splits))

ts_model_rank_tbl(calibration_tbl)

}

}
\seealso{
Other Utility: 
\code{\link{calibrate_and_plot}()},
\code{\link{internal_ts_backward_event_tbl}()},
\code{\link{internal_ts_both_event_tbl}()},
\code{\link{internal_ts_forward_event_tbl}()},
\code{\link{model_extraction_helper}()},
\code{\link{ts_get_date_columns}()},
\code{\link{ts_info_tbl}()},
\code{\link{ts_is_date_class}()},
\code{\link{ts_lag_correlation}()},
\code{\link{ts_model_auto_tune}()},
\code{\link{ts_model_compare}()},
\code{\link{ts_model_spec_tune_template}()},
\code{\link{ts_qq_plot}()},
\code{\link{ts_scedacity_scatter_plot}()},
\code{\link{ts_to_tbl}()}
}
\author{
Steven P. Sanderson II, MPH
}
\concept{Utility}
