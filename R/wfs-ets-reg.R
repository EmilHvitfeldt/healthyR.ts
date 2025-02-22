#' Auto ETS Workflowset Function
#'
#' @family Auto Workflowsets
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @description
#' This function is used to quickly create a workflowsets object.
#'
#' @seealso \url{https://workflowsets.tidymodels.org/}
#' @seealso \url{https://business-science.github.io/modeltime/reference/exp_smoothing.html}
#'
#' @details This function expects to take in the recipes that you want to use in
#' the modeling process. This is an automated workflow process. There are sensible
#' defaults set for the model specification, but if you choose you can set them
#' yourself if you have a good understanding of what they should be. The mode is
#' set to "regression".
#'
#' This uses the following engines:
#'
#' [modeltime::exp_smoothing()] exp_smoothing() is a way to generate a specification
#' of an Exponential Smoothing model before fitting and allows the model to be
#' created using different packages. Currently the only package is forecast.
#' Several algorithms are implemented:
#' -  "ets"
#' -  "croston"
#' -  "theta"
#' -  "smooth_es
#'
#' @param .model_type This is where you will set your engine. It uses
#' [modeltime::exp_smoothing()] under the hood and can take one of the following:
#'   * "ets"
#'   * "croston"
#'   * "theta"
#'   * "smooth_es"
#'   * "all_engines" - This will make a model spec for all available engines.
#' @param .recipe_list You must supply a list of recipes. list(rec_1, rec_2, ...)
#' @param .seasonal_period A seasonal frequency. Uses "auto" by default.
#' A character phrase of "auto" or time-based phrase of "2 weeks" can be used
#' if a date or date-time variable is provided. See Fit Details below.
#' @param .error The form of the error term: "auto", "additive", or
#' "multiplicative". If the error is multiplicative, the data must be non-negative.
#' @param .trend The form of the trend term: "auto", "additive", "multiplicative"
#' or0 "none".
#' @param .season The form of the seasonal term: "auto", "additive",
#' "multiplicative" or "none".
#' @param .damping Apply damping to a trend: "auto", "damped", or "none".
#' @param .smooth_level This is often called the "alpha" parameter used as the
#' base level smoothing factor for exponential smoothing models.
#' @param .smooth_trend This is often called the "beta" parameter used as the
#' trend smoothing factor for exponential smoothing models.
#' @param .smooth_seasonal This is often called the "gamma" parameter used as
#' the seasonal smoothing factor for exponential smoothing models.
#'
#' @examples
#' suppressPackageStartupMessages(library(modeltime))
#' suppressPackageStartupMessages(library(timetk))
#' suppressPackageStartupMessages(library(dplyr))
#' suppressPackageStartupMessages(library(rsample))
#'
#' data <- AirPassengers %>%
#'   ts_to_tbl() %>%
#'   select(-index)
#'
#' splits <- time_series_split(
#'    data
#'   , date_col
#'   , assess = 12
#'   , skip = 3
#'   , cumulative = TRUE
#' )
#'
#' rec_objs <- ts_auto_recipe(
#'  .data = training(splits)
#'  , .date_col = date_col
#'  , .pred_col = value
#' )
#'
#' wf_sets <- ts_wfs_ets_reg("all_engines", rec_objs)
#' wf_sets
#'
#' @return
#' Returns a workflowsets object.
#'
#' @export
#'

ts_wfs_ets_reg <- function(.model_type = "all_engines",
                           .recipe_list,
                           .seasonal_period = "auto",
                           .error = "auto",
                           .trend = "auto",
                           .season = "auto",
                           .damping = "auto",
                           .smooth_level = 0.1,
                           .smooth_trend = 0.1,
                           .smooth_seasonal = 0.1
){

    # * Tidyeval ----
    model_type      = .model_type
    recipe_list     = .recipe_list
    seasonal_period = .seasonal_period
    error           = .error
    trend           = .trend
    season          = .season
    damping         = .damping
    smooth_level    = .smooth_level
    smooth_trend    = .smooth_trend
    smooth_seasonal = .smooth_seasonal

    # * Checks ----
    if (!is.character(model_type)) {
        stop(call. = FALSE, "(.model_type) must be a character like 'ets','theta','croston','smooth_ets','all_engines'")
    }

    if (!model_type %in% c("ets","croston","theta","smooth_ets","all_engines")){
        stop(call. = FALSE, "(.model_type) must be one of the following, 'ets','croston','theta','smooth_ets','all_engines'")
    }

    if (!is.list(recipe_list)){
        stop(call. = FALSE, "(.recipe_list) must be a list of recipe objects")
    }

    # * Models ----
    model_spec_ets <- modeltime::exp_smoothing(
        mode            = "regression",
        seasonal_period = seasonal_period,
        error           = error,
        trend           = trend,
        season          = season,
        damping         = damping,
        smooth_level    = smooth_level,
        smooth_trend    = smooth_trend,
        smooth_seasonal = smooth_seasonal
    ) %>%
        parsnip::set_engine("ets")

    model_spec_croston <- modeltime::exp_smoothing(
        mode            = "regression",
        seasonal_period = seasonal_period,
        smooth_level    = smooth_level
    ) %>%
        parsnip::set_engine("croston")

    model_spec_theta <- modeltime::exp_smoothing(
        mode            = "regression",
        seasonal_period = seasonal_period
    ) %>%
        parsnip::set_engine("theta")

    model_spec_smooth_ets <- modeltime::exp_smoothing(
        mode            = "regression",
        seasonal_period = seasonal_period,
        error           = error,
        trend           = trend,
        season          = season,
        damping         = damping,
        smooth_level    = smooth_level,
        smooth_trend    = smooth_trend,
        smooth_seasonal = smooth_seasonal
    ) %>%
        parsnip::set_engine("smooth_es")

    final_model_list <- if (model_type == "ets"){
        fml <- list(model_spec_ets)
    } else if (model_type == "croston"){
        fml <- list(model_spec_croston)
    } else if (model_type == "theta"){
        fml <- list(model_spec_theta)
    } else if (model_type == "smooth_es"){
        fml <- list(model_spec_smooth_ets)
    } else {
        fml <- list(
            model_spec_ets,
            model_spec_croston,
            model_spec_theta,
            model_spec_smooth_ets
        )
    }

    # * Workflow Sets ----
    wf_sets <- workflowsets::workflow_set(
        preproc = recipe_list,
        models  = final_model_list,
        cross   = TRUE
    )

    # * Return ---
    return(wf_sets)

}
