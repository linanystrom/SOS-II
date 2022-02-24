################################################################################

# SoS Reinforcement - Supplemental analysis

################################################################################

# Basic setup ------------------------------------------------------------------
packages <- c("gtools", "readr", "tibble", "dplyr", "data.table", "tidyr",
              "readxl", "ggplot2", "lme4", "TOSTER", "lmerTest", "compute.es",
              "psych", "wesanderson", "corrplot")

lapply(packages, library, character.only = TRUE)

source("corr_mat_p.r")

# Import & filter data ---------------------------------------------------------

sos_full      <- read.csv("./data/sos_wrangle.csv")
sos_long_full <- read.csv("./data/sos_long.csv")

sos           <- sos_full %>% filter(!exclusion %in% c('1'))
sos_long      <- sos_long_full %>% filter(!exclusion %in% c('1')) 

# Running linear mixed effects model, where phase 4 is coded as midpoint -------

# Setting Phase 4 as midpoint---------------------------------------------------


sos_midpont_4 <-sos_long %>% 
  mutate(
    after = case_when(
      time == 1 ~ 0,
      time == 2 ~ 0,
      time == 3 ~ 0,
      time == 4 ~ 0,
      time == 5 ~ 1,
      time == 6 ~ 2
    ),
    
    treatment = case_when(
      time == 1 ~ 0,
      time == 2 ~ 0,
      time == 3 ~ 0,
      time == 4 ~ 0,
      time == 5 ~ 1,
      time == 6 ~ 1
    ))

### Main effect model

info_model_M4 <- lmer(detail
                     ~ time  
                     + treatment 
                     + after 
                     + style
                     + (1|crime_order/ID) 
                     + (1|interviewer),
                     data = sos_midpont_4,
                     REML = FALSE
)

summary(info_model_M4)

### Interaction effect model

info_model_M4_int <- lmer(detail
                       ~ time 
                       + treatment 
                       + after 
                       + style 
                       + time*style 
                       + treatment*style 
                       + after*style 
                       + (1|crime_order/ID) 
                       + (1|interviewer), 
                       data = sos_midpont_4,
                       REML = FALSE
)

summary(info_model_M4_int)


## Comparing regression models ANOVA

comp_model_anova <- anova(info_model_M4, info_model_M4_int)


#Correlation, Disclosed details Phase 4 with Phase 5&6 ------------------------- 


#Self-Report of Changing Strategy-----------------------------------------------

### 1 = No, 2 = Yes

## Descriptives

change_strat <- sos %>%
  drop_na (change_strategy) %>% 
  group_by(style, change_strategy) %>%
  summarise(
    n = n()) %>%
  mutate(rel_freq = paste0(round(100 * n/sum(n), 0), "%")
         )

## Chi-square, proportion changed strategy 

### Direct vs. Standard

sos_ds <- sos %>% filter(style != "reinforcement")

sos_ds$style <- ordered(
  sos_ds$style, levels = c("standard","direct")
)

change_strat_ds <-
  table(sos_ds$style, sos_ds$change_strategy)

DS_prop_test <- prop.test(x= change_strat_ds,
                          n= rowSums(change_strat_ds),
                          correct = FALSE)


### Direct vs. Reinforcement

sos_dr <- sos

sos_dr$style <- ordered(
  sos_dr$style, levels = c("reinforcement","direct")
)

change_strat_dr <-
  table(sos_dr$style, sos_dr$change_strategy)

DR_prop_test <- prop.test(x= change_strat_dr,
                          n= rowSums(change_strat_dr),
                          correct = FALSE)

### Standard vs. Reinforcement

sos_sr <- sos

sos_sr$style <- ordered(
  sos$style, levels = c("reinforcement","standard")
)

change_strat_sr <-
  table(sos_sr$style, sos_sr$change_strategy)

SR_prop_test <- prop.test(x= change_strat_sr,
                          n= rowSums(change_strat_sr),
                          correct = FALSE)


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


# Omega estimates of composite measures-----------------------------------------

## Self-assessment

self_assessment_corr = sos[c(
  "interview_statements_1",
  "interview_statements_2",
  "interview_statements_3",
  "interview_statements_4")]

describe(self_assessment_corr)

lowerCor(self_assessment_corr)

self_corr <- omega(self_assessment_corr)

summary(self_corr)

## Interview quality

interviewQ_corr = sos[c(
  "interview_adj_1",
  "interview_adj_2_R",
  "interview_adj_3",
  "interview_adj_4_R",
  "interview_adj_5",
  "interview_adj_6")]

describe(interviewQ_corr)

lowerCor(interviewQ_corr)

IQ_corr <- omega(interviewQ_corr)

summary(IQ_corr)


## Interviewer perception

interviewerP_corr = sos[c(
  "interviewer_adj_1",
  "interviewer_adj_2_R",
  "interviewer_adj_3_R",
  "interviewer_adj_4",
  "interviewer_adj_5",
  "interviewer_adj_6_R")]


describe(interviewerP_corr)

lowerCor(interviewerP_corr)

IP_corr <- omega(interviewerP_corr)

summary(IP_corr)

# Interviewer perception, individual items -------------------------------------

## Friendly

friendly_desc <- sos %>% 
  group_by(style) %>% 
  summarise(
    Mean = mean(interviewer_adj_1, na.rm = TRUE),
    SD = sd(interviewer_adj_1, na.rm = TRUE),
    Median = median(interviewer_adj_1, na.rm = TRUE),
    SE = SD/sqrt(n()),
    Upper = Mean + (1.96*SE),
    Lower = Mean - (1.96*SE)
  )

### Direct v. Standard

t_self_FDS <- t.test(
  interviewer_adj_1 ~ style,
  data = filter(sos, style == "direct" | style == "standard")
)

### Direct v. Reinforcement

t_self_FDR <- t.test(
  interviewer_adj_1 ~ style,
  data = filter(sos, style == "direct" | style == "reinforcement")
)

### Standard vs. Reinforcement

t_self_FRS <- t.test(
  interviewer_adj_1 ~ style,
  data = filter(sos, style == "standard" | style == "reinforcement")
)

## Challenging

challenging_desc <- sos %>% 
  group_by(style) %>% 
  summarise(
    Mean = mean(interviewer_adj_2, na.rm = TRUE),
    SD = sd(interviewer_adj_2, na.rm = TRUE),
    Median = median(interviewer_adj_2, na.rm = TRUE),
    SE = SD/sqrt(n()),
    Upper = Mean + (1.96*SE),
    Lower = Mean - (1.96*SE)
  )

### Direct v. Standard

t_self_CDS <- t.test(
  interviewer_adj_2 ~ style,
  data = filter(sos, style == "direct" | style == "standard")
)

### Direct v. Reinforcement

t_self_CDR <- t.test(
  interviewer_adj_2 ~ style,
  data = filter(sos, style == "direct" | style == "reinforcement")
)

### Standard vs. Reinforcement

t_self_CRS <- t.test(
  interviewer_adj_2 ~ style,
  data = filter(sos, style == "standard" | style == "reinforcement")
)

## Aggressive

aggressive_desc <- sos %>% 
  group_by(style) %>% 
  summarise(
    Mean = mean(interviewer_adj_3, na.rm = TRUE),
    SD = sd(interviewer_adj_3, na.rm = TRUE),
    Median = median(interviewer_adj_3, na.rm = TRUE),
    SE = SD/sqrt(n()),
    Upper = Mean + (1.96*SE),
    Lower = Mean - (1.96*SE)
  )

### Direct v. Standard

t_self_ADS <- t.test(
  interviewer_adj_3 ~ style,
  data = filter(sos, style == "direct" | style == "standard")
)

### Direct v. Reinforcement

t_self_ADR <- t.test(
  interviewer_adj_3 ~ style,
  data = filter(sos, style == "direct" | style == "reinforcement")
)

### Standard vs. Reinforcement

t_self_ARS <- t.test(
  interviewer_adj_3 ~ style,
  data = filter(sos, style == "standard" | style == "reinforcement")
)


## Sympathetic

sympathetic_desc <- sos %>% 
  group_by(style) %>% 
  summarise(
    Mean = mean(interviewer_adj_4, na.rm = TRUE),
    SD = sd(interviewer_adj_4, na.rm = TRUE),
    Median = median(interviewer_adj_4, na.rm = TRUE),
    SE = SD/sqrt(n()),
    Upper = Mean + (1.96*SE),
    Lower = Mean - (1.96*SE)
  )

### Direct v. Standard

t_self_SDS <- t.test(
  interviewer_adj_4 ~ style,
  data = filter(sos, style == "direct" | style == "standard")
)

### Direct v. Reinforcement

t_self_SDR <- t.test(
  interviewer_adj_4 ~ style,
  data = filter(sos, style == "direct" | style == "reinforcement")
)

### Standard vs. Reinforcement

t_self_SRS <- t.test(
  interviewer_adj_4 ~ style,
  data = filter(sos, style == "standard" | style == "reinforcement")
)

## Interested

interested_desc <- sos %>% 
  group_by(style) %>% 
  summarise(
    Mean = mean(interviewer_adj_5, na.rm = TRUE),
    SD = sd(interviewer_adj_5, na.rm = TRUE),
    Median = median(interviewer_adj_5, na.rm = TRUE),
    SE = SD/sqrt(n()),
    Upper = Mean + (1.96*SE),
    Lower = Mean - (1.96*SE)
  )

### Direct v. Standard

t_self_IDS <- t.test(
  interviewer_adj_5 ~ style,
  data = filter(sos, style == "direct" | style == "standard")
)

### Direct v. Reinforcement

t_self_IDR <- t.test(
  interviewer_adj_5 ~ style,
  data = filter(sos, style == "direct" | style == "reinforcement")
)

### Standard vs. Reinforcement

t_self_IRS <- t.test(
  interviewer_adj_5 ~ style,
  data = filter(sos, style == "standard" | style == "reinforcement")
)

## Rough

rough_desc <- sos %>% 
  group_by(style) %>% 
  summarise(
    Mean = mean(interviewer_adj_6, na.rm = TRUE),
    SD = sd(interviewer_adj_6, na.rm = TRUE),
    Median = median(interviewer_adj_6, na.rm = TRUE),
    SE = SD/sqrt(n()),
    Upper = Mean + (1.96*SE),
    Lower = Mean - (1.96*SE)
  )

### Direct v. Standard

t_self_RDS <- t.test(
  interviewer_adj_6 ~ style,
  data = filter(sos, style == "direct" | style == "standard")
)

### Direct v. Reinforcement

t_self_RDR <- t.test(
  interviewer_adj_6 ~ style,
  data = filter(sos, style == "direct" | style == "reinforcement")
)

### Standard vs. Reinforcement

t_self_RRS <- t.test(
  interviewer_adj_6 ~ style,
  data = filter(sos, style == "standard" | style == "reinforcement")
)

# Information disclosure - Correlation -----------------------------------------

## Overall

phases <- c("stage_1", "stage_2", "stage_3", "stage_4", "stage_5", "stage_6")

corr_data <- sos[phases]

overall_corr <- corr_p_mat(corr_data)

## Direct

corr_direct <- sos %>% filter(style == "direct")

corr_direct <- corr_direct[phases]

corr_direct_matrix  <- corr_p_mat(corr_direct)

## Standard

corr_standard <- sos %>% filter(style == "standard")

corr_standard <- corr_standard[phases]

corr_standard_matrix <- corr_p_mat(corr_standard)

## Reinforcement

corr_reinforcement <- sos %>% filter(style == "reinforcement")

corr_reinforcement <- corr_reinforcement[phases]

corr_reinforcement_matrix <- corr_p_mat(corr_reinforcement)


## Plot phase 4 & 5

corr_plot_4_5 <- ggplot(sos,
        aes(
            stage_4,
            stage_5,
            colour= style)) +
 geom_point() +
      geom_smooth(
        method=lm,
        se=FALSE) +
  geom_jitter(
    aes(
      stage_4,
      stage_5)) +
  labs(
    y = "Phase 4",
    x = "Phase 5") +
  scale_color_manual(
    values = wes_palette("GrandBudapest1", n = 3)
  ) +
  scale_x_continuous(
    labels = c("0", "1", "2","3","4","5"),
    breaks = 0:5) +
  scale_y_continuous(
    labels = c("0", "1", "2","3","4","5"),
    breaks = 0:5) +
  stat_cor(method = "pearson") +
  theme_classic()
  
# Information disclosure - Correlation between phase 5 & 6 ---------------------

corr_plot_5_6 <- ggplot(sos,
        aes(
            stage_5,
            stage_6,
            colour= style)) +
  geom_point() +
  geom_smooth(
    method=lm,
    se=FALSE) +
  geom_jitter(
    aes(
      stage_5,
      stage_6)) +
  labs(
    y = "Phase 4",
    x = "Phase 5") +
  scale_color_manual(
    values = wes_palette("GrandBudapest1", n = 3)
  ) +
  scale_x_continuous(
    labels = c("0", "1", "2","3","4","5"),
    breaks = 0:5) +
  scale_y_continuous(
    labels = c("0", "1", "2","3","4","5"),
    breaks = 0:5) +
  stat_cor(method = "pearson") +
  theme_classic()


# Demographics------------------------------------------------------------------

age_table <- sos %>% 
  summarise(
    Age_M = mean(age, na.rm = TRUE),
    Age_sd = sd(age, na.rm = TRUE),
    Age_Mdn = median(age, na.rm = TRUE)
  ) 

gender_table <- sos %>% 
  group_by(gender) %>% 
  summarise(
    n = n()
  )

