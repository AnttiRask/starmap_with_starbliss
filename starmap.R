source("functions.R")
source("secrets.R")

library(ggmap)
library(starBliss)
library(tidyverse)

draw_starmap(
    "Helsinki",
    "00510",
    "Finland",
    "2024-12-26",
    save = TRUE
)
