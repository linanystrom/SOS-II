################################################################################

# SoS Reinforcement - Supplemental analyses

################################################################################

# Basic setup ------------------------------------------------------------------
packages <- c("gtools", "readr", "tibble", "dplyr", "data.table", "tidyr",
              "readxl", "ggplot2", "lme4", "TOSTER", "lmerTest", "compute.es",
              "cowplot")

lapply(packages, library, character.only = TRUE)

# Import & filter data ---------------------------------------------------------

sos_full      <- read.csv("./data/sos_wrangle.csv")
sos           <- sos_full %>% filter(!exclusion %in% c('1'))

#Self-Report of Changing Strategy-----------------------------------------------

### 1 = No, 2 = Yes

## Descriptives

change_strat <- sos %>%
  drop_na (change_strategy) %>% 
  group_by(style, change_strategy) %>%
  summarise(
    n = n()) %>%
  mutate(rel_freq = paste0(round(100 * n/sum(n), 0), "%"))


## Chi-square, proportion changed strategy 

### Direct vs. Standard

DS_prop_test <- prop.test(x=c(28,16),n=c(97,100), correct = FALSE)

DS_prop_test <- prop.test(x=c(28,16),n=c(97,100), correct = FALSE)

### Direct vs. Reinforcement

DR_prop_test <- prop.test(x=c(33,16),n=c(100,100), correct = FALSE)

### Standard vs. Reinforcement

SR_prop_test <- prop.test(x=c(33,28),n=c(100,97), correct = FALSE)


# Motivation to appear innocent-------------------------------------------------

## Descriptives 

motivation <- sos %>% 
  summarise(
    Mean = mean(motivation, na.rm = TRUE),
    SD = sd(motivation, na.rm = TRUE),
    Median = median(motivation, na.rm = TRUE),
    SE = SD/sqrt(n()),
    Upper = Mean + (1.96*SE),
    Lower = Mean - (1.96*SE)
  )

# Engagement with clips---------------------------------------------------------

## Descriptives

engagement <- sos %>% 
  summarise(
    Mean = mean(engagement, na.rm = TRUE),
    SD = sd(engagement, na.rm = TRUE),
    Median = median(engagement, na.rm = TRUE),
    SE = SD/sqrt(n()),
    Upper = Mean + (1.96*SE),
    Lower = Mean - (1.96*SE)
  )

