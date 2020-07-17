library(magrittr)
library(rlang)
library(Lahman)
library(purrr)
library(devtools)
library(stringi)
library(readxl)
library(gt)
library(openxlsx)
library(tidyverse)

# setwd("~/Desktop/Everything/College/19-20/HKS Research/download.folder/unzipped")

# loads in play-by-play data from 1974 to 2019
# pitch sequence data only available since 1988

fields <- read_csv("download.folder/unzipped/fields.csv")
year <- "all.csv"
matches <- c(">F", ">L", ">M", ">O", ">Q", ">R", ">S", ">T", ">X", ">Y")
for (i in 1988:2019) {
  var <- paste0("data", i)
  stri_sub(year, 4, 3) <- i
  assign(var, read_csv(paste0("download.folder/unzipped/", year), 
                       col_names = pull(fields, Header), na = character()))
  year <- "all.csv"
}

# code from "Analyzing Baseball Data With R, Second Edition"
# unused for now 

# analyze <- function(data_file) {
#   # creates variables for runs, half-inning, and runs scored
#   data_file <- data_file %>%
#     mutate(RUNS = AWAY_SCORE_CT + HOME_SCORE_CT,
#            HALF_INNING = paste(GAME_ID, INN_CT, BAT_HOME_ID),
#            RUNS_SCORED =
#              (BAT_DEST_ID > 3) + (RUN1_DEST_ID > 3) +
#              (RUN2_DEST_ID > 3) + (RUN3_DEST_ID > 3))
#   
#   # same process, ctd.
#   half_innings <- data_file %>% 
#     group_by(HALF_INNING) %>% 
#     summarize(outs_inning = sum(EVENT_OUTS_CT),
#               runs_inning = sum(RUNS_SCORED),
#               runs_start = first(RUNS),
#               MAX_RUNS = runs_inning + runs_start)
#   
#   # computes new state variables
#   data_file <- data_file %>%
#     inner_join(half_innings, by = "HALF_INNING") %>% 
#     mutate(BASES = 
#              paste(ifelse(BASE1_RUN_ID > '', 1, 0),
#                    ifelse(BASE2_RUN_ID > '', 1, 0),
#                    ifelse(BASE3_RUN_ID > '', 1, 0), sep = ""),
#            STATE = paste(BASES, OUTS_CT),
#            NRUNNER1 =
#              as.numeric(RUN1_DEST_ID == 1 | BAT_DEST_ID == 1),
#            NRUNNER2 =
#              as.numeric(RUN1_DEST_ID == 2 | RUN2_DEST_ID == 2 |
#                           BAT_DEST_ID == 2),
#            NRUNNER3 =
#              as.numeric(RUN1_DEST_ID == 3 | RUN2_DEST_ID == 3 |
#                           RUN3_DEST_ID == 3 | BAT_DEST_ID == 3),
#            NOUTS = OUTS_CT + EVENT_OUTS_CT,
#            NEW_BASES = paste(NRUNNER1, NRUNNER2,
#                              NRUNNER3, sep = ""),
#            NEW_STATE = paste(NEW_BASES, NOUTS))
#   
#   # creates new dataset with only complete innings (three outs and batting event)
#   data_file <- data_file %>% 
#     filter((STATE != NEW_STATE) | (RUNS_SCORED > 0))
#   
#   mod_data <- data_file %>% 
#     filter(outs_inning == 3, BAT_EVENT_FL == TRUE) %>% 
#     mutate(NEW_STATE = gsub("[0-1]{3} 3", "3", NEW_STATE))
#   
#   # creates matrices of counts and probabilities
#   freq_matrix <- mod_data %>% 
#     select(STATE, NEW_STATE) %>% 
#     table()
#   
#   prob_matrix <- prop.table(freq_matrix, 1)
#   prob_matrix <- rbind(prob_matrix, c(rep(0, 24), 1))
#   
#   
# }

runexp_data <- read.xlsx("RunExp_Data.xlsx")
wexp_data <- read.xlsx("WinExp_Data.xlsx")

# creates run expectancy matrices and saves
runexp_data %>% 
  filter(year == 2019) %>% 
  slice(9:16) %>% 
  select(states, '0', '1', '2') %>% 
  mutate(states = substr(states, 0, 3)) %>% 
  gt() %>% 
  tab_header(title = "Run Expectancy Matrix, 2019",
             subtitle = "via Baseball Prospectus with play-by-play data") %>% 
  gtsave("RE_2019_Empirical.pdf", path = "Tables/RunExp", zoom = .6)


# creates win expectancy matrices
wexp_data %>% 
  slice(9:16) %>% 
  mutate(states = substr(states, 0, 3)) %>% 
  gt() %>% 
  tab_header(title = "Win Probability Matrix, 2002",
             subtitle = "Down by 1, bottom of the 7th") %>% 
  tab_footnote('via "The Book", Tango et al.', locations = cells_title()) %>% 
  gtsave("WE_2002_Empirical.pdf", path = "Tables/WinExp", zoom = .6)



