library(ggplot2)
library(readr)
library(dplyr)
library(shiny)
library(bslib)
library(shinydashboard)
library(fresh)
library(httr)
library(jsonlite)
library(plotly)
library(tidyr)
library(lubridate)
library(rsconnect)
library(gt)

source("R/data_helpers.R")

# All externally-sourced data below is read from data/ or data/cache/, which is
# populated by data_refresh.R on a schedule. The app itself never
# scrapes or calls an external API directly at startup - if a scheduled
# refresh fails for a dataset, its cache file is left untouched, so the
# app keeps running on the last successful pull (see
# data/cache/refresh_log.csv for a history of refresh attempts).

#STATMENTS DATA --------------------------------------------------------------------
df_statements <- read_cache_csv("statements")

#PRECEPTIONS DATA ------------------------------------------------------------------
df_perceptions <- read_cache_csv("preceptions")