################################################################################

# SoS Reinforcement - Supplemental analysis

################################################################################

# Basic setup ------------------------------------------------------------------

packages <- c("gtools", "readr", "tibble", "dplyr", "data.table", "tidyr",
              "readxl", "ggplot2", "lme4", "TOSTER", "lmerTest", "compute.es",
              "psych", "wesanderson", "corrplot", "ggpubr", "lavaan", "semTools",
              "ggpubr")

lapply(packages, library, character.only = TRUE)

source("corr_mat_p.r")

# Import & filter data ---------------------------------------------------------

sos_full      <- read.csv("./data/sos_wrangle.csv")
sos_long_full <- read.csv("./data/sos_long.csv")

sos           <- read.csv("./data/sos_v.2.csv")
sos_long      <- read.csv("./data/sos_long_v.2.csv")

sos$sum_crit <- rowSums(subset(sos, select = stage_5:stage_6))

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


#Correlation, Disclosed details Phase 4 with Phase 5 & 6 ----------------------- 


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

# Disclosure of critical details -----------------------------------------------


freq_detail <- sos %>%
  drop_na (sum_crit) %>% 
  group_by(style, sum_crit) %>%
  summarise(
    n = n()) %>%
  mutate(rel_freq = paste0(round(100 * n/sum(n), 0), "%")
  )

freq_crit_plot <- ggplot(sos,
                         aes(
                           x = sum_crit
                         )) +
  labs(
    y = "Count",
    x = "Critical details",
  ) +
  facet_wrap(. ~ style) +
  geom_histogram(
    binwidth = 1,
    color = "black",
    fill = "darkgrey"
  ) +
  theme_classic()


# Motivation to appear innocent-------------------------------------------------

## Descriptives 

motivation <- sos %>% 
  group_by(style) %>% 
  summarise(
    Mean = mean(motivation, na.rm = TRUE),
    SD = sd(motivation, na.rm = TRUE),
    Median = median(motivation, na.rm = TRUE),
    SE = SD/sqrt(n()),
    Upper = Mean + (1.96*SE),
    Lower = Mean - (1.96*SE)
  )

## Direct vs. Standard

t_mot_DS <- t.test(
  motivation ~ style,
  data = filter(sos, style == "direct" | style == "standard")
)

## Direct vs. Reinforcement

t_mot_DR <- t.test(
  motivation ~ style,
  data = filter(sos, style == "direct" | style == "reinforcement")
)

## Standard vs. Reinforcement

t_mot_SR <- t.test(
  motivation ~ style,
  data = filter(sos, style == "standard" | style == "reinforcement")
)

## Predicting disclosed details by motivation

### Main effect model

mot_model_1 <- lmer(detail
                     ~ motivation
                     + style
                     + (1|crime_order/ID) 
                     + (1|time)
                     + (1|interviewer),
                     data = sos_long,
                     REML = FALSE
)

summary(mot_model_1)

### Interaction effect model

mot_model_2 <- lmer(detail
                     ~ motivation
                     + style
                     + motivation*style
                     + (1|crime_order/ID) 
                     + (1|time)
                     + (1|interviewer),
                     data = sos_long,
                     REML = FALSE
)

summary(mot_model_2)

comp_mot_model_anova <- anova(mot_model_1, mot_model_2)

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

## Direct vs. Standard

t_eng_DS <- t.test(
  engagement ~ style,
  data = filter(sos, style == "direct" | style == "standard")
)

## Direct vs. Reinforcement

t_eng_DR <- t.test(
  engagement ~ style,
  data = filter(sos, style == "direct" | style == "reinforcement")
)

## Standard vs. Reinforcement

t_eng_SR <- t.test(
  engagement ~ style,
  data = filter(sos, style == "standard" | style == "reinforcement")
)

## Predicting disclosed details by engagement

### Main effect model

eng_model_1 <- lmer(detail
                    ~ engagement
                    + style
                    + (1|crime_order/ID) 
                    + (1|time)
                    + (1|interviewer),
                    data = sos_long,
                    REML = FALSE
)

summary(eng_model_1)

### Interaction effect model

eng_model_2 <- lmer(detail
                    ~ engagement
                    + style
                    + engagement*style
                    + (1|crime_order/ID) 
                    + (1|time)
                    + (1|interviewer),
                    data = sos_long,
                    REML = FALSE
)

summary(eng_model_2)

comp_mot_model_anova <- anova(eng_model_1, eng_model_2)

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

## CFA

self_assessment_uni_model <- 
'

self =~ interview_statements_1
+ interview_statements_2
+ interview_statements_3
+ interview_statements_4

'

self_uni_fit <- cfa(self_assessment_uni_model, data = sos,
                    std.lv = TRUE,
                    estimator = "MLR")

summary(self_uni_fit, fit.measures = TRUE)

reliability(self_uni_fit)

compRelSEM(self_uni_fit)


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

## CFA

interviewQ_uni_model <- 
  '

self =~ interview_adj_1
+ interview_adj_2_R
+ interview_adj_3
+ interview_adj_4_R
+ interview_adj_5
+ interview_adj_6

'

interviewQ_fit <- cfa(interviewQ_uni_model, data = sos,
                    std.lv = TRUE,
                    estimator = "MLR")

summary(interviewQ_fit, fit.measures = TRUE)

reliability(interviewQ_fit)

compRelSEM(interviewQ_fit)


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

## CFA

interviewerP_uni_model <- 
  '

self =~ interviewer_adj_1
+ interviewer_adj_2_R
+ interviewer_adj_3_R
+ interviewer_adj_4
+ interviewer_adj_5
+ interviewer_adj_6_R

'

interviewerP_fit <- cfa(interviewerP_uni_model, data = sos,
                      std.lv = TRUE,
                      estimator = "MLR")

summary(interviewerP_fit, fit.measures = TRUE)

reliability(interviewerP_fit)

compRelSEM(interviewerP_fit)

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

# Perception of info -----------------------------------------------------------

## Descriptives - knowledge_before

pre_knowledge_tale  <- sos %>%
  group_by(style) %>%
  summarise(
    Mean = mean(knowledge_before, na.rm = TRUE),
    SD = sd(knowledge_before, na.rm = TRUE),
    Median = median(knowledge_before, na.rm = TRUE),
    SE = SD/sqrt(n()),
    Upper = Mean + (1.96*SE),
    Lower = Mean - (1.96*SE)
  )

### Direct v. Standard

t_k_DS <- t.test(
  knowledge_before ~ style,
  data = filter(sos, style == "direct" | style == "standard")
)

### Direct v. Reinforcement

t_k_DR <- t.test(
  knowledge_before ~ style,
  data = filter(sos, style == "direct" | style == "reinforcement")
)

### Standard vs. Reinforcement

t_k_RS <- t.test(
  knowledge_before ~ style,
  data = filter(sos, style == "standard" | style == "reinforcement")
)

## Descriptives - new info

new_info_tale <- sos %>%
  group_by(style) %>%
  summarise(
    Mean = mean(new_info, na.rm = TRUE),
    SD = sd(new_info, na.rm = TRUE),
    Median = median(new_info, na.rm = TRUE),
    SE = SD/sqrt(n()),
    Upper = Mean + (1.96*SE),
    Lower = Mean - (1.96*SE)
  )

### Direct v. Standard

t_ni_DS <- t.test(
  new_info ~ style,
  data = filter(sos, style == "direct" | style == "standard")
)

### Direct v. Reinforcement

t_ni_DR <- t.test(
  new_info ~ style,
  data = filter(sos, style == "direct" | style == "reinforcement")
)

### Standard vs. Reinforcement

t_ni_RS <- t.test(
  new_info ~ style,
  data = filter(sos, style == "standard" | style == "reinforcement")
)

# Correlation performance x information disclosure -----------------------------

##Overall

corr_perf <- c("self_assessment",
               "stage_1",
               "stage_2",
               "stage_3",
               "stage_4",
               "stage_5",
               "stage_6")

corr_perf_data <-sos[corr_perf]

perf_corr_matrix <- corr_p_mat(corr_perf_data)

## Direct

corr_perf_direct <- sos %>% filter(style == "direct")

corr_perf_direct <- corr_perf_direct[corr_perf]

corr_perf_direct_matrix  <- corr_p_mat(corr_perf_direct)

## Standard

corr_perf_standard <- sos %>% filter(style == "standard")

corr_perf_standard <- corr_perf_standard[corr_perf]

corr_perf_standard_matrix <- corr_p_mat(corr_perf_standard)

## Reinforcement

corr_perf_reinforcement <- sos %>% filter(style == "reinforcement")

corr_perf_reinforcement <- corr_perf_reinforcement[corr_perf]

corr_perf_reinforcement_matrix <- corr_p_mat(corr_perf_reinforcement)


# Exploratory analysis ---------------------------------------------------------

## Predicting disclosed details by self_assessment

### Main effect model

expl_model_1 <- lmer(detail
                     ~ self_assessment
                     + style
                     + (1|crime_order/ID) 
                     + (1|time)
                     + (1|interviewer),
                     data = sos_long,
                     REML = FALSE
)

summary(expl_model_1)

### Interaction effect model

expl_model_2 <- lmer(detail
                     ~ self_assessment
                     + style
                     + self_assessment*style
                     + (1|crime_order/ID) 
                     + (1|time)
                     + (1|interviewer),
                     data = sos_long,
                     REML = FALSE
)

summary(expl_model_2)

comp_expl_model_anova <- anova(expl_model_1, expl_model_2)

## Scatter plot relationship between performance and disclosed details.

sos_expl <- sos %>% mutate(
  detail_sum = select(., stage_1:stage_6) %>% apply(1, sum, na.rm=TRUE),
  style         = case_when(
    style == "direct"        ~ "Direct",
    style == "reinforcement" ~ "SoS-Reinforcement",
    style == "standard"      ~ "SoS-Standard"
  ))

sos_expl$style <- ordered(
  sos_expl$style, levels = c("Direct","SoS-Standard","SoS-Reinforcement")
)

expl_plot <- ggplot(sos_expl,
                    aes(
                      x = detail_sum,
                      y = self_assessment,
                      colour = factor(style)
                    )) +
  facet_wrap(. ~ style) +
  geom_point(size = 1.5) +
  geom_smooth(method='lm',
              size = 1.5) +
  labs(
      x = "Sum details",
      y = "Self assessment of Performance"
  ) +
  scale_color_manual(values = c("#7DAF9C",
                                "#DB94B2",
                                "#EA8C55")
  ) +
  theme_classic()

expl_plot_wo_legend <- expl_plot + theme(legend.position = "none")


## Predicting perceived interviewer quality by disclosed details (Exploratory)

### Main effect model

expl_model_3 <- lmer(detail
                     ~ interviewer_qual
                     + style
                     + (1|crime_order/ID)
                     + (1|time)
                     + (1|interviewer),
                     data = sos_long,
                     REML = FALSE,
                     control = lmerControl(
                       optCtrl = list(maxfun = 100000),
                       optimizer = "bobyqa"
                     )
)

summary(expl_model_3)

### Interaction effect model

expl_model_4 <- lmer(detail
                     ~ interviewer_qual
                     + style
                     + interviewer_qual*style
                     + (1|crime_order/ID)
                     + (1|time)
                     + (1|interviewer),
                     data = sos_long,
                     REML = FALSE,
                     control = lmerControl(
                       optCtrl = list(maxfun = 100000),
                       optimizer = "bobyqa"
                     )
)

summary(expl_model_4)

comp_expl_model_anova_2 <- anova(expl_model_3, expl_model_4)


## Plot interviewer

## Scatter plot relationship between interviewer quality and disclosed details.

sos_expl_2 <- sos %>% mutate(
  detail_sum = select(., stage_1:stage_6) %>% apply(1, sum, na.rm=TRUE),
  style         = case_when(
    style == "direct"        ~ "Direct",
    style == "reinforcement" ~ "SoS-Reinforcement",
    style == "standard"      ~ "SoS-Standard"
  ))

sos_expl_2$style <- factor(
  sos_expl_2$style, levels = c("Direct","SoS-Standard","SoS-Reinforcement")
)

expl_plot_2 <- ggplot(sos_expl_2,
                    aes(
                      x = detail_sum,
                      y = interviewer_qual,
                      colour = factor(style)
                    )) +
  facet_wrap(. ~ style) +
  geom_point(size = 1.5) +
  geom_smooth(method='lm',
              size = 1.5) +
  labs(
    x = "Sum details",
    y = "Perceptions of Interviewer"
  ) +
  scale_color_manual(values = c("#7DAF9C",
                                "#DB94B2",
                                "#EA8C55")
  ) +
  theme_classic()

expl_plot_2_wo_legend <- expl_plot_2 + theme(legend.position = "none")

## Predicting perceived interviewer quality by disclosed details (Exploratory)

### Main effect model

expl_model_5 <- lmer(detail
                     ~ interview_qual
                     + style
                     + (1|crime_order/ID)
                     + (1|time)
                     + (1|interviewer),
                     data = sos_long,
                     REML = FALSE
                     )

summary(expl_model_5)

### Interaction effect model

expl_model_6 <- lmer(detail
                     ~ interview_qual
                     + style
                     + interview_qual*style
                     + (1|crime_order/ID)
                     + (1|time)
                     + (1|interviewer),
                     data = sos_long,
                     REML = FALSE
)

summary(expl_model_6)

comp_expl_model_anova_3 <- anova(expl_model_5, expl_model_6)

## Assessing training effects

### Main effect model

training_model_1 <- lm(sum_info
                    ~ ID
                    + interviewer,
                    data = sos
)

summary(training_model_1)


training_model_2 <- lm(sum_info
                       ~ ID
                       + interviewer
                       + ID*interviewer,
                       data = sos
)

summary(training_model_2)

training_anova <- anova(training_model_1, training_model_2)

## Duration --------------------------------------------------------------------

sos_duration <- read.csv("./duration.csv")
sos_time <- merge(sos, sos_duration, by = "ID")
sos_time_long <- merge(sos_long, sos_duration, by = "ID")


duration_desc <- sos_time %>% 
  group_by(style) %>% 
  summarise(
    Mean = mean(minutes, na.rm = TRUE),
    SD = sd(minutes, na.rm = TRUE),
    Median = median(minutes, na.rm = TRUE),
    SE = SD/sqrt(n()),
    Upper = Mean + (1.96*SE),
    Lower = Mean - (1.96*SE)
  )

## Non-critical

dur_model_1 <- lmer(detail
                    ~ minutes
                    + style
                    + (1|crime_order/ID) 
                    + (1|time)
                    + (1|interviewer),
                    data = sos_time_long,
                    REML = FALSE
)

summary(dur_model_1)

dur_model_2 <- lmer(detail
                    ~ minutes
                    + style
                    + minutes*style
                    + (1|crime_order/ID) 
                    + (1|time)
                    + (1|interviewer),
                    data = sos_time_long,
                    REML = FALSE
)

summary(dur_model_2)

## Comparing regression models ANOVA

dur_model_anova <- anova(dur_model_1, dur_model_2)

## Critical

dur_model_3 <- lmer(sum_crit
                    ~ minutes
                    + style
                    + (1|interviewer),
                    data = sos_time,
                    REML = FALSE
)

summary(dur_model_3)

dur_model_4 <- lmer(sum_crit
                    ~ minutes
                    + style
                    + minutes*style
                    + (1|interviewer),
                    data = sos_time,
                    REML = FALSE
)

summary(dur_model_4)

## Comparing regression models ANOVA

dur_model_anova_crit <- anova(dur_model_3, dur_model_4)


