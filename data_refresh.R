# Data refresh job.
#
# Fetches every externally-sourced dataset the app depends on and writes
# each one to data/cache/. Each dataset is fetched and written
# independently: if one source fails (site down, API change, network
# blip), that dataset's existing cache file is left untouched and the
# rest of the refresh continues. global.R only ever reads from
# data/cache/, so the app always has the most recent successful pull
# of each dataset, even if today's refresh partially failed.
#
# Run manually with:
#   Rscript data_refresh.R
#
# To run this once a day.
# (e.g.GitHub Actions)

library(httr)
library(jsonlite)
library(readr)
library(dplyr)
library(tidyr)
library(lubridate)
library(sf)
library(geojsonsf)
library(rvest)
library(httr2)
library(stringr)

source("R/data_helpers.R")

clear_refresh_log()

refresh_dataset <- function(name, fetch, write) {
  message("Refreshing ", name, "...")
  tryCatch(
    {
      value <- fetch()
      write(value)
      log_refresh(name, "success", n_rows = NROW(value))
      message("  OK (", NROW(value), " rows)")
      TRUE
    },
    error = function(e) {
      log_refresh(name, "failure", message = conditionMessage(e))
      message("  FAILED - keeping previous cache: ", conditionMessage(e))
      FALSE
    }
  )
}

#STATEMENTS DATASET -----------------------------------------------------------------------------------
refresh_dataset(
  "statements",
  function() {
    data <- read_csv(Sys.getenv("STATEMENTS"), show_col_types =  FALSE)
    
    df <- pivot_longer(data,
                       cols = c(`British Columbia`, `Vancouver, Coast & Mountains`, `Vancouver Island`, `Thompson Okanagan`, `Kootenay Rockies`, `Northern BC`, `Cariboo Chilcotin Coast`),
                       names_to = "Region",
                       values_to = "Value")
    df
  },
  function(df) atomic_write_csv(df, file.path(CACHE_DIR, "statements.csv"))
)

refresh_dataset(
  "preceptions",
  function() {
    data <- read_csv(Sys.getenv("PRECEPTIONS"), show_col_types =  FALSE)
    
    df <- pivot_longer(data,
                       cols = c(`British Columbia`, `Thompson Okanagan`),
                       names_to = "Region",
                       values_to = "Value")
    df
  },
  function(df) atomic_write_csv(df, file.path(CACHE_DIR, "preceptions.csv"))
)

message("Data refresh complete. See ", file.path(CACHE_DIR, "refresh_log.csv"), " for a run history.")
