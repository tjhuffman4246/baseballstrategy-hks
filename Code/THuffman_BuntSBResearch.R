library(magrittr)
library(rlang)
library(Lahman)
library(devtools)
library(stringi)
library(tidyverse)

# setwd("~/Desktop/Everything/College/19-20/HKS Research/download.folder/unzipped")

# loads in play-by-play data from 1974 to 2019
# pitch sequence data only available since 1988
# https://www.retrosheet.org/eventfile.htm#5

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

#data1988 <- data1988 %>% mutate(sbattempts = sum(stri_detect_fixed(PITCH_SEQ_TX, ">"), na.rm = TRUE),
                        #hitandrun = sum(stri_detect_fixed(PITCH_SEQ_TX, matches), na.rm = TRUE))

#datasets <- paste0("data", 1988:2019)

#for (set in datasets) {
  #used <- get(set)
  #used <- used %>% mutate(sbattempts = sum(stri_detect_fixed(PITCH_SEQ_TX, ">"), na.rm = TRUE),
                          #hitandrun = sum(stri_detect_fixed(PITCH_SEQ_TX, matches), na.rm = TRUE))
#}

#set <- set %>% mutate(sbattempts = sum(stri_detect_fixed(PITCH_SEQ_TX, ">"), na.rm = TRUE))
#set <- set %>% mutate(hitandrun = sum(stri_detect_fixed(PITCH_SEQ_TX, matches), na.rm = TRUE))

##########

# these are lots of individual plots to get a basic sense of the data
# about as basic as you can get using ggplot()

# reads in bunt/SB data from BRef Play Index
alldata <- read_csv("AllData.csv")

# year-by-year plots
# plate appearances
ggplot(alldata, aes(Year, PA)) + 
  geom_point() + 
  labs(title = "Total Plate Appearances", subtitle = "Since 1974")

# bunt attempts
ggplot(alldata, aes(Year, Attempts)) + 
  geom_point() + 
  labs(title = "Total Bunts", subtitle = "Since 1974")

# attempts per PA
ggplot(alldata, aes(Year, Attempts/PA)) + 
  geom_point() + 
  labs(title = "Bunt Attempts per PA", subtitle = "Since 1974")

# success rate ###
ggplot(alldata, aes(Year, Success/Attempts)) + 
  geom_point() + 
  labs(title = "Bunt Success Rate", subtitle = "Since 1974")

# P success rate
ggplot(alldata, aes(Year, P_success/P_attempt)) + 
  geom_point() + 
  labs(title = "Pitcher Bunt Success Rate", subtitle = "Since 1974")

# non-P success rate
ggplot(alldata, aes(Year, nonP_success/nonP_attempt)) + 
  geom_point() + 
  labs(title = "Non-Pitcher Bunt Success Rate", subtitle = "Since 1974")

# non-P/P bunt ratio ###
ggplot(alldata, aes(Year, nonP_attempt/P_attempt)) + 
  geom_point() + 
  labs(title = "Non-Pitcher Bunt Attempts to Pitcher Bunt Attempts", subtitle = "Since 1974")

# non-P attempts as % of all attempts
ggplot(alldata, aes(Year, nonP_attempt/Attempts)) + 
  geom_point() + 
  labs(title = "Percent of Bunt Attempts by Non-Pitchers", subtitle = "Since 1974")

# non-P late-game no-out attempts
ggplot(alldata, aes(Year, nonP_7end_0out_attempts)) + 
  geom_point() + 
  labs(title = "Non-Pitcher Attempts", subtitle = "7th Inning or Later, No Outs; Since 1974")

# late/close attempts
ggplot(alldata, aes(Year, LateClose)) + 
  geom_point() + 
  labs(title = "Total Late and Close Bunt Attempts", 
       subtitle = "7th Inning or Later, Tied or Down by One; Since 1974")

# late/close attempts as a % of all attempts
ggplot(alldata, aes(Year, LateClose/Attempts)) + 
  geom_point() + 
  labs(title = "Percent of Bunt Attempts in Late and Close Situation",
       subtitle = "7th Inning or Later, Tied or Down by One; Since 1974")

# percent of bunters who are "good"
# --> percent of all players w/ >= 2 sac. bunts w/ OPS+ >= 100
ggplot(alldata, aes(Year, PctGood)) + 
  geom_point() + 
  labs(title = "Percent of Frequent Bunters At or Above Average", 
       subtitle = "Percent of Non-Pitchers with At Least 2 Sacrifice Bunts with OPS+ At/Above 100; 
       Since 1974")

# stolen base opportunities
ggplot(alldata, aes(Year, SBOpps)) +
  geom_point() +
  labs(title = "Total Stolen Base Opportunities", subtitle = "Since 1974")

# stolen base attempts
ggplot(alldata, aes(Year, SB + CS)) +
  geom_point() +
  labs(title = "Total Stolen Base Attempts", subtitle = "Since 1974")

# stolen base success rate
ggplot(alldata, aes(Year, SB / (SB + CS))) +
  geom_point() +
  labs(title = "Stolen Base Success Rate", subtitle = "Since 1974")

# 2B SB attempts
ggplot(alldata, aes(Year, SB2 + CS2)) +
  geom_point() +
  labs(title = "Total Stolen Base Attempts (Second Base Only)", subtitle = "Since 1974")

# 2B SB success rate
ggplot(alldata, aes(Year, SB2 / (SB2 + CS2))) +
  geom_point() +
  labs(title = "Stolen Base Success Rate (Second Base Only)", subtitle = "Since 1974")

# 3B SB attempts
ggplot(alldata, aes(Year, SB3 + CS3)) +
  geom_point() +
  labs(title = "Total Stolen Base Attempts (Third Base Only)", subtitle = "Since 1974")

# 3B SB success rate
ggplot(alldata, aes(Year, SB3 / (SB3 + CS3))) +
  geom_point() +
  labs(title = "Stolen Base Success Rate (Third Base Only)", subtitle = "Since 1974")

######################

# bunt frequency by position players in close games, no outs, 1xx or 12x
# "close" = tied/down by one
ggplot(alldata, aes(Year, attempts_nonP_close_1xx_12x_0out / PA_nonP_close_1xx_12x_0out)) + 
  geom_line() + 
  labs(title = "How Often Do Baseball Players Sacrifice Bunt?", 
       subtitle = "Sacrifice Bunt Frequency in Close Games by Position Players", 
       caption = "Since 1974; data via Baseball Reference") +
  ylab("Bunt Rate") +
  ylim(0, .2) +
  theme_minimal()


# FINAL
ggplot(alldata, aes(Year)) +
  geom_line(aes(y = (SB + CS) / G, color = "Attempts per Game")) +
  geom_line(aes(y = 2.5 * (SB / (SB + CS)) - .8, color = "Success Rate")) +
  geom_hline(yintercept = 1.075, linetype = "dashed") +
  scale_color_manual(values = c("deepskyblue4", "red3")) +
  scale_y_continuous(sec.axis = sec_axis(~ . * .4 + .32, 
                                         name = "Stolen Base Success Rate",
                                         breaks = c(.6, .64, .68, .72, .76, .8))) +
  labs(title = "The Evolution of Stolen Bases",
       subtitle = "Stolen Base Attempts and Success Rate",
       caption = "Since 1974; data via Baseball Reference",
       color = "Legend") +
  ylab("Stolen Base Attempts per Game") +
  annotate("text", x = 2012, y = 1.1, size = 4, label = '"Breakeven Rate" 
           (0.75)') +
  theme_minimal() +
  theme(legend.position = "bottom",
        axis.title.y = element_text(margin = margin(t = 0, r = 10, b = 0, l = 0)),
        axis.title.y.right = element_text(margin = margin(t = 0, r = 0, b = 0, l = 10)),
        axis.title.x = element_text(margin = margin(t = 5, r = 0, b = 0, l = 0)))

# first draft
# ggplot(alldata, aes(Year)) +
#   geom_line(aes(y = SB + CS, color = "Attempts")) +
#   geom_line(aes(y = 7496 * (SB / (SB + CS)) - 997, color = "Success Rate")) +
#   geom_hline(yintercept = 4625, linetype = "dashed") +
#   scale_color_manual(values = c("deepskyblue4", "red3")) +
#   scale_y_continuous(sec.axis = sec_axis(~ . / 7500 + 2/15, 
#                                          name = "Stolen Base Success Rate",
#                                          breaks = c(.6, .7, .75, .8))) +
#   labs(title = "The Evolution of Stolen Bases",
#        subtitle = "Stolen Base Attempts and Success Rate",
#        caption = "Since 1974; data via Baseball Reference",
#        color = "Legend") +
#   ylab("Stolen Base Attempts") +
#   annotate("text", x = 1983, y = 3200, size = 3.5, label = "1981 
#   Strike") +
#   annotate("text", x = 1996, y = 3300, size = 3.5, label = "1994 
#   Strike") +
#   annotate("text", x = 2012, y = 4750, size = 4, label = "Stolen Base
#   Breakeven Rate") +
#   theme_minimal() +
#   theme(legend.position = "bottom",
#         axis.title.y = element_text(margin = margin(t = 0, r = 10, b = 0, l = 0)),
#         axis.title.y.right = element_text(margin = margin(t = 0, r = 0, b = 0, l = 10)),
#         axis.title.x = element_text(margin = margin(t = 5, r = 0, b = 0, l = 0)))
