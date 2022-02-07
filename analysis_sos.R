# Basic setup ------------------------------------------------------------------

packages <- c("gtools", "readr", "tibble", "dplyr", "data.table", "tidyr", "readxl", "ggplot2", "lme4", "TOSTER", "lmerTest")

lapply(packages, library, character.only = TRUE)

# Import data ------------------------------------------------------------------
 
sos_full      <- read.csv("./data/sos_wrangle.csv")

sos_long_full <- read.csv("./data/sos_long.csv")

sos           <- sos_full %>% filter(!exclusion %in% c('1'))      #Filter exclusions

sos_long      <- sos_long_full %>% filter(!exclusion %in% c('1')) #Filter exclusions

# Hypothesis testing - Information disclosure ----------------------------------

## Plot Preparation

sos_jitter <- sos %>% 
  mutate(
    jitter_y = runif(nrow(sos), min = -.20, max = .20),
    jitter_x = runif(nrow(sos), min = -.20, max = .20)
  ) %>% 
  select(ID, jitter_y, jitter_x)

sos_plot <- sos_long %>% 
  left_join(sos_jitter, by = "ID") %>% 
  mutate(
    detail_jitter = detail + jitter_y,
    time_jitter   = time   + jitter_x,
    style         = case_when(
      style == "direct"        ~ "Direct",
      style == "reinforcement" ~ "Reinforcement",
      style == "standard"      ~ "Standard"
    )
  )

sos_plot$style <- ordered(sos_plot$style, levels = c("Direct", "Standard", "Reinforcement"))

## Descriptives

info_desc <- sos_plot %>% 
  group_by(style, time) %>% 
  summarise(
    Mean = mean(detail, na.rm = TRUE),
    SD = sd(detail, na.rm = TRUE),
    Median = median(detail, na.rm = TRUE),
    SE = SD/sqrt(n()),
    Upper = Mean + (1.96*SE),
    Lower = Mean - (1.96*SE)
  )

## Plot information disclosure 

info_plot <- ggplot(sos_plot,
       aes(
         x = time_jitter,
         y = detail_jitter
       )) +
  facet_wrap(. ~ style) +
  geom_line(
    aes(
      group = ID
    ),
    size = .05,
    color = "grey",
    position = position_jitter(width = .15),
    alpha = .20
  ) +
  geom_line(
    data = info_desc,
    aes(
      x = time,
      y = Mean,
      group = style
    ),
    color = "red",
    size = 1.5
  ) +
  geom_errorbar(
    data = info_desc,
    aes(
      x = time,
      ymax = Upper,
      ymin = Lower,
      group = style
    ),
    inherit.aes = FALSE,
    color = "red",
    width = .25
  ) +
  labs(
    y = "Information disclosure",
    x = "Phase"
  ) +
  scale_x_continuous(
    labels = c("1", "2", "3","4","5","6"),
    breaks = 1:6
  ) +
  coord_cartesian(
    ylim = c(0, 5)
  ) +
  theme_classic()

info_plot_color <-
  ggplot(sos_plot,
         aes(
           x = time_jitter,
           y = detail_jitter
         )) +
  facet_wrap(. ~ style) +
  geom_line(
    aes(
      group = ID,
      color = as.factor(ID)
    ),
    size = .05,
    position = position_jitter(width = .15),
    alpha = .20
  ) +
  geom_line(
    data = info_desc,
    aes(
      x = time,
      y = Mean,
      group = style
    ),
    color = "red",
    size = 1.5
  ) +
  geom_errorbar(
    data = info_desc,
    aes(
      x = time,
      ymax = Upper,
      ymin = Lower,
      group = style
    ),
    inherit.aes = FALSE,
    color = "red",
    width = .25
  ) +
  labs(
    y = "Information disclosure",
    x = "Phase"
  ) +
  scale_x_continuous(
    labels = c("1", "2", "3","4","5","6"),
    breaks = 1:6
  ) +
  coord_cartesian(
    ylim = c(0, 5)
  ) +
  guides(
    color = "none"
  ) +
  theme_classic()

## Interrupted time series linear mixed effects model

info_model_1 <- lmer(detail ~ time  + treatment + after + style + (1|crime_order/ID) + (1|interviewer), data = sos_long, REML = FALSE)

summary(info_model_1)

info_model_int <- lmer(detail ~ time  + treatment + after + style + time*style + treatment*style + after*style + (1|crime_order/ID) + (1|interviewer), data = sos_long, REML = FALSE)

summary(info_model_int)

## Comparing regression models

comp_model_anova <- anova(info_model_1, info_model_int)


# Hypothesis testing - Self-assessment of performance --------------------------

## Descriptives

perf_desc <- sos %>%
  group_by(style) %>%
  summarise(
    Mean = mean(self_assessment, na.rm = TRUE),
    SD = sd(self_assessment, na.rm = TRUE),
    Median = median(self_assessment, na.rm = TRUE)
  )

## Plots self-assessment

perf_plot <- ggplot(sos,
       aes(
         x = self_assessment
       )) +
  facet_wrap(. ~ style) +
  geom_histogram(
    binwidth = .65,
    color = "black",
    fill = "darkgrey"
  ) +
  theme_classic()

## Comparison of each condition

t_self_DS <- t.test(self_assessment ~ style, data = filter(sos, style == "direct" | style == "standard"))

t_self_DR <-t.test(self_assessment ~ style, data = filter(sos, style == "direct" | style == "reinforcement"))

t_self_RS <-t.test(self_assessment ~ style, data = filter(sos, style == "reinforcement" | style == "standard"))

## Comparison to the midpoint

t_self_mid_D <- t.test(filter(sos, style == "direct")$self_assessment, mu = 3)

t_self_mid_S <- t.test(filter(sos, style == "standard")$self_assessment, mu = 3)

t_self_mid_R <- t.test(filter(sos, style == "reinforcement")$self_assessment, mu = 3)

## TOST (Only performed if initial three t-test are nonsignificant)

self_table <- sos %>%
  filter(complete.cases(self_assessment)) %>% 
  group_by(style) %>%
  summarise(
    Mean = mean(self_assessment, na.rm = TRUE),
    SD = sd(self_assessment, na.rm = TRUE),
    Median = median(self_assessment, na.rm = TRUE),
    n = n()
  ) %>% 
  ungroup()

direct_mean <- filter(self_table, style == "direct")$Mean
reinforcement_mean <- filter(self_table, style == "reinforcement")$Mean
standard_mean <- filter(self_table, style == "standard")$Mean

direct_sd <- filter(self_table, style == "direct")$SD
reinforcement_sd <- filter(self_table, style == "reinforcement")$SD
standard_sd <- filter(self_table, style == "standard")$SD

direct_n <- filter(self_table, style == "direct")$n
reinforcement_n <- filter(self_table, style == "reinforcement")$n
standard_n <- filter(self_table, style == "standard")$n

### Direct vs. Standard

tost_self_DS <- TOSTtwo(m1 = direct_mean, m2 = standard_mean , sd1 = direct_sd, sd2 =  standard_sd, n1 = direct_n, n2 = standard_n, low_eqbound_d = -.20, high_eqbound_d = .20, alpha = .05, plot = FALSE, var.equal = FALSE)

### Direct vs. Reinforcement

tost_self_DR <-TOSTtwo(m1 = direct_mean, m2 = reinforcement_mean, sd1 = direct_sd, sd2 = reinforcement_sd, n1 = direct_n, n2 = reinforcement_n, low_eqbound_d = -.20, high_eqbound_d = .20, alpha = .05, plot = FALSE, var.equal = FALSE)

### Reinforcement vs. Standard

tost_self_RS <-TOSTtwo(m1 = standard_mean, m2 = reinforcement_mean, sd1 = standard_sd, sd2 = reinforcement_sd, n1 = standard_n, n2 = reinforcement_n, low_eqbound_d = -.20, high_eqbound_d = .20, alpha = .05, plot = FALSE, var.equal = FALSE)


# Hypothesis testing - Interaction quality --------------------------------------------------

## Descriptives - Interview

interview_desc <- sos %>%
  group_by(style) %>%
  summarise(
    Mean = mean(interview_qual, na.rm = TRUE),
    SD = sd(interview_qual, na.rm = TRUE),
    Median = median(interview_qual, na.rm = TRUE)
  ) 

## Plot

interview_plot <- ggplot(sos,
       aes(
         x = interview_qual
       )) +
  facet_wrap(. ~ style) +
  geom_histogram(
    binwidth = .65,
    color = "black",
    fill = "darkgrey"
  ) +
  theme_classic()

## Descriptives - Interviewer

interviewer_desc <- sos %>%
  group_by(style) %>%
  summarise(
    Mean = mean(interviewer_qual, na.rm = TRUE),
    SD = sd(interviewer_qual, na.rm = TRUE),
    Median = median(interviewer_qual, na.rm = TRUE)
  ) 

## Plot

interviewer_plot <- ggplot(sos,
       aes(
         x = interviewer_qual
       )) +
  facet_wrap(. ~ style) +
  geom_histogram(
    binwidth = .65,
    color = "black",
    fill = "darkgrey"
  ) +
  theme_classic()

## Comparison - Interview

t_inteview_DS <- t.test(interview_qual ~ style, data = filter(sos, style == "direct" | style == "standard"))

t_inteview_DR <-t.test(interview_qual ~ style, data = filter(sos, style == "direct" | style == "reinforcement"))

t_inteview_RS <-t.test(interview_qual ~ style, data = filter(sos, style == "reinforcement" | style == "standard"))

## TOST - These will only be used if the t-tests above are nonsignificant

interview_table <- sos %>%
  filter(complete.cases(interview_qual)) %>% 
  group_by(style) %>%
  summarise(
    Mean = mean(interview_qual, na.rm = TRUE),
    SD = sd(interview_qual, na.rm = TRUE),
    Median = median(interview_qual, na.rm = TRUE),
    n = n()
  ) %>% 
  ungroup()

direct_mean_2 <- filter(interview_table, style == "direct")$Mean
reinforcement_mean_2 <- filter(interview_table, style == "reinforcement")$Mean
standard_mean_2 <- filter(interview_table, style == "standard")$Mean

direct_sd_2 <- filter(interview_table, style == "direct")$SD
reinforcement_sd_2 <- filter(interview_table, style == "reinforcement")$SD
standard_sd_2 <- filter(interview_table, style == "standard")$SD

direct_n_2 <- filter(interview_table, style == "direct")$n
reinforcement_n_2 <- filter(interview_table, style == "reinforcement")$n
standard_n_2 <- filter(interview_table, style == "standard")$n

### Direct vs. Standard

tost_interview_DS <- TOSTtwo(m1 = direct_mean_2, m2 =standard_mean_2 , sd1 = direct_sd_2, sd2 = standard_sd_2, n1 = direct_n_2, n2 =standard_n_2, low_eqbound_d = -.20, high_eqbound_d = .20, alpha = .05, plot = FALSE, var.equal = FALSE)

### Direct vs. Reinforcement

tost_interview_DR <-TOSTtwo(m1 = direct_mean_2, m2 = reinforcement_mean_2, sd1 = direct_sd_2, sd2 = reinforcement_sd_2, n1 = direct_n_2, n2 = reinforcement_n_2, low_eqbound_d = -.20, high_eqbound_d = .20, alpha = .05, plot = FALSE, var.equal = FALSE)

### Reinforcement vs. Standard

tost_interview_RS <-TOSTtwo(m1 =standard_mean_2, m2 = reinforcement_mean_2, sd1 =standard_sd_2, sd2 = reinforcement_sd_2, n1 =standard_n_2, n2 = reinforcement_n_2, low_eqbound_d = -.20, high_eqbound_d = .20, alpha = .05, plot = FALSE, var.equal = FALSE)

## Comparison to negative endpoint

t_interview_neg_D <- t.test(filter(sos, style == "direct")$interview_qual, mu = 1)

t_interview_neg_S <-t.test(filter(sos, style == "standard")$interview_qual, mu = 1)

t_interview_neg_R <-t.test(filter(sos, style == "reinforcement")$interview_qual, mu = 1)

## Comparison - Interviewer

t_interviewer_DS <- t.test(interviewer_qual ~ style, data = filter(sos, style == "direct" | style == "standard"))

t_interviewer_DR <-t.test(interviewer_qual ~ style, data = filter(sos, style == "direct" | style == "reinforcement"))

t_interviewer_RS <-t.test(interviewer_qual ~ style, data = filter(sos, style == "reinforcement" | style == "standard"))

## TOST - These will only be used if the t-tests above are nonsignificant

interviewer_table <- sos %>%
  filter(complete.cases(interview_qual)) %>% 
  group_by(style) %>%
  summarise(
    Mean = mean(interviewer_qual, na.rm = TRUE),
    SD = sd(interviewer_qual, na.rm = TRUE),
    Median = median(interviewer_qual, na.rm = TRUE),
    n = n()
  ) %>% 
  ungroup()

direct_mean_3 <- filter(interviewer_table, style == "direct")$Mean
reinforcement_mean_3 <- filter(interviewer_table, style == "reinforcement")$Mean
standard_mean_3 <- filter(interviewer_table, style == "standard")$Mean

direct_sd_3 <- filter(interviewer_table, style == "direct")$SD
reinforcement_sd_3 <- filter(interviewer_table, style == "reinforcement")$SD
standard_sd_3 <- filter(interviewer_table, style == "standard")$SD

direct_n_3 <- filter(interviewer_table, style == "direct")$n
reinforcement_n_3 <- filter(interviewer_table, style == "reinforcement")$n
standard_n_3 <- filter(interviewer_table, style == "standard")$n

### Direct vs. Standard

tost_interviewer_DS <- TOSTtwo(m1 = direct_mean_3, m2 = standard_mean_3 , sd1 = direct_sd_3, sd2 = standard_sd_3, n1 = direct_n_3, n2 = standard_n_3, low_eqbound_d = -.20, high_eqbound_d = .20, alpha = .05, plot = FALSE, var.equal = FALSE)

### Direct vs. Reinforcement

tost_interviewer_DR <- TOSTtwo(m1 = direct_mean_3, m2 = reinforcement_mean_3, sd1 = direct_sd_3, sd2 = reinforcement_sd_3, n1 = direct_n_3, n2 = reinforcement_n_3, low_eqbound_d = -.20, high_eqbound_d = .20, alpha = .05, plot = FALSE, var.equal = FALSE)

### Reinforcement vs. Standard

tost_interviewer_RS <- TOSTtwo(m1 = standard_mean_3, m2 = reinforcement_mean_3, sd1 = standard_sd_3, sd2 = reinforcement_sd_3, n1 = standard_n_3, n2 = reinforcement_n_3, low_eqbound_d = -.20, high_eqbound_d = .20, alpha = .05, plot = FALSE, var.equal = FALSE)


## Comparison to the negative endpoint

t_interviewer_neg_D <- t.test(filter(sos, style == "direct")$interviewer_qual, mu = 1)

t_interviewer_neg_S <- t.test(filter(sos, style == "standard")$interviewer_qual, mu = 1)

t_interviewer_neg_R <- t.test(filter(sos, style == "reinforcement")$interviewer_qual, mu = 1)
