#' Generate constant baseline forecasts
#'
#' Creates a set of daily \eqn{1,\dots,h}-day ahead forecasts from a
#' persistence (last-observed-value) baseline model.
#' For each issue date, the baseline forecast is equal to the value observed
#' on that day, repeated for all horizons.
#'
#' @param y A data frame or tibble with columns:
#'   \describe{
#'     \item{\code{date}}{Date vector of observation dates (daily, no gaps).}
#'     \item{\code{true_values}}{Numeric vector of observed values.}
#'   }
#' @param horizon Integer. The forecast horizon in days (default = 14).
#'
#' @return A tibble with columns:
#'   \describe{
#'     \item{\code{issue_date}}{Date the forecast was issued.}
#'     \item{\code{horizon}}{Forecast horizon in days ahead.}
#'     \item{\code{date}}{Date the forecast targets.}
#'     \item{\code{forecast}}{Baseline forecast value.}
#'     \item{\code{observed}}{Observed value on \code{date}.}
#'   }
#'
#' @details
#' The function assumes that \code{y} is complete and daily.
#' The rolling-origin setup means forecasts overlap in their target dates;
#' evaluation should be done per (issue_date, horizon) pair.
#'
#' The constant baseline serves as a "naive" reference point to compare against
#' more sophisticated forecasting models. It's particularly useful because:
#'      - It represents the simplest possible forecast (no change from
#'          historical average)
#'      - It provides a benchmark for minimum expected performance
#'      - It helps assess whether more complex models actually add
#'          value beyond this basic assumption
#' This constant baseline essentially answers the question: "What if future
#' observations stay at the same level as the historical average?" This provides
#' a foundation for evaluating more sophisticated forecasting approaches.
#' @examples
#' set.seed(123)
#' y <- data.frame(
#'   date = seq(as.Date("2023-01-01"), as.Date("2023-01-31"), by = "day"),
#'   value = sample(1:100, 31)
#' )
#' res <- baseline_forecasts(y, horizon = 14)
#' res
#'
#' @export
constant_baseline_forecasts <- function(y, col, horizon = 14) {
    y %>%
        mutate(issue_date = date, b = .data[[col]]) %>%
        group_by(issue_date, b) %>%
        reframe(horizon = 1:horizon) %>%
        mutate(date = issue_date + horizon) %>%
        left_join(y %>% select(date = date, observed = all_of(col)),
                  by = "date") %>%
        filter(!is.na(observed)) %>%
        mutate(prediction = b) %>%
        select(issue_date, horizon, date, prediction, observed)
}
