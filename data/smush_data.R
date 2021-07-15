
packages <- c("gtools", "readr", "tibble", "dplyr", "data.table", "tidyr", "readxl", "ggplot2", "lme4")

lapply(packages, library, character.only = TRUE)

## Load qualtrics data
MC2B_file     <- read_xlsx("./data/qualtrics/help.xlsx")

## files <- rbind(MC2A_file, MC2B_file)

## Load discloure data

data <- read_xlsx("./data/coding.xlsx")

## Smush data

df <- merge(data, MC2B_file, by = "ResponseId")

## Reverse code interview quality, interviewer quality and self-assessment items. Create interview quality, interviewer quality and self-assessment composite. 

#Interview quality

sos <- df %>% 
  mutate(
    interview_adj_2_R = case_when(
      interview_adj_2 == 5 ~ 1,
      interview_adj_2 == 4 ~ 2,
      interview_adj_2 == 3 ~ 3,
      interview_adj_2 == 2 ~ 4,
      interview_adj_2 == 1 ~ 5
    ),
    interview_adj_4_R = case_when(
      interview_adj_4 == 5 ~ 1,
      interview_adj_4 == 4 ~ 2,
      interview_adj_4 == 3 ~ 3,
      interview_adj_4 == 2 ~ 4,
      interview_adj_4 == 1 ~ 5
    ),
   
    interview_qual = (interview_adj_1 + interview_adj_2_R + interview_adj_3 + interview_adj_4_R + interview_adj_5 + interview_adj_6)/6,
    
#Interviewer quality
    
    interviewer_adj_2_R = case_when(
      interviewer_adj_2 == 5 ~ 1,
      interviewer_adj_2 == 4 ~ 2,
      interviewer_adj_2 == 3 ~ 3,
      interviewer_adj_2 == 2 ~ 4,
      interviewer_adj_2 == 1 ~ 5
    ),
    interviewer_adj_3_R = case_when(
      interviewer_adj_3 == 5 ~ 1,
      interviewer_adj_3 == 4 ~ 2,
      interviewer_adj_3 == 3 ~ 3,
      interviewer_adj_3 == 2 ~ 4,
      interviewer_adj_3 == 1 ~ 5
    ),
    interviewer_adj_6_R = case_when(
      interviewer_adj_6 == 5 ~ 1,
      interviewer_adj_6 == 4 ~ 2,
      interviewer_adj_6 == 3 ~ 3,
      interviewer_adj_6 == 2 ~ 4,
      interviewer_adj_6 == 1 ~ 5
    ),
    interviewer_qual = (interviewer_adj_1 + interviewer_adj_2_R + interviewer_adj_3_R + interviewer_adj_4 + interviewer_adj_5 + interviewer_adj_6_R)/6,

# Self-assessment of performance

    interview_statements_2 = case_when(
      interview_statements_2 == 5 ~ 1,
      interview_statements_2 == 4 ~ 2,
      interview_statements_2 == 3 ~ 3,
      interview_statements_2 == 2 ~ 4,
      interview_statements_2 == 1 ~ 5
    ),
    interview_statements_3 = case_when(
      interview_statements_3 == 5 ~ 1,
      interview_statements_3 == 4 ~ 2,
      interview_statements_3 == 3 ~ 3,
      interview_statements_3 == 2 ~ 4,
      interview_statements_3 == 1 ~ 5
    ),
    self_assessment = (interview_statements_1 + interview_statements_2 + interview_statements_3 + interview_statements_4)/4
    )

# Add crime_order
sos$crime_order <- paste(sos$mock_crime, sos$sequence)

#Transform data to long format

sos_long <- sos %>% pivot_longer(6:11, names_to = "time", values_to = "detail")

#Code time variables for interrupted time series regression

sos_long$after <- case_when(
  sos_long$time == "stage_1" ~ 0,
  sos_long$time == "stage_2" ~ 0,
  sos_long$time == "stage_3" ~ 0,
  sos_long$time == "stage_4" ~ 1,
  sos_long$time == "stage_5" ~ 2,
  sos_long$time == "stage_6" ~ 3
)

sos_long$treatment <- case_when(
  sos_long$time == "stage_1" ~ 0,
  sos_long$time == "stage_2" ~ 0,
  sos_long$time == "stage_3" ~ 0,
  sos_long$time == "stage_4" ~ 1,
  sos_long$time == "stage_5" ~ 1,
  sos_long$time == "stage_6" ~ 1
)

sos_long$time <- case_when(
  sos_long$time == "stage_1" ~ 1,
  sos_long$time == "stage_2" ~ 2,
  sos_long$time == "stage_3" ~ 3,
  sos_long$time == "stage_4" ~ 4,
  sos_long$time == "stage_5" ~ 5,
  sos_long$time == "stage_6" ~ 6
)

#Factor condition

sos_long$style <- factor(sos_long$style, levels = c("direct", "standard", "reinforcement"))

#Set standard as reference group

sos_long <- within(sos_long, style <- relevel(style, ref = "standard"))

#Hypothesis testing - Information disclosure

#Descriptives

sos_long %>% 
  group_by(style, time) %>% 
  summarise(
    Mean = mean(detail, na.rm = TRUE),
    SD = sd(detail, na.rm = TRUE),
    Median = median(detail, na.rm = TRUE)
  ) %>% 
  knitr::kable(digits = 2, align = "l")

info_desc <- sos_long %>% 
  group_by(style, time) %>% 
  summarise(
    Mean = mean(detail, na.rm = TRUE),
    SD = sd(detail, na.rm = TRUE),
    Median = median(detail, na.rm = TRUE),
    SE = SD/sqrt(n()),
    Upper = Mean + (1.96*SE),
    Lower = Mean - (1.96*SE)
  )

#Plot information disclosure

ggplot(sos_long,
       aes(
         x = time,
         y = detail
       )) +
  facet_wrap(. ~ style) +
  geom_line(
    aes(
      group = ID
    ),
    size = .05,
    color = "grey",
    position = position_jitter(width = .15, height = .15),
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
  scale_x_discrete(
    labels = c("1", "2", "3","4","5","6") ## nope
  ) +
  coord_cartesian(
    ylim = c(0, 5)
  ) +
  theme_classic()

#Interrupted time series linear mixed effects model

info_model_main <- lmer(detail ~ time  + treatment + after + style + time*style + treatment*style + after*style + (1|crime_order/ID) + (1|interviewer), data = sos_long, REML = FALSE)

summary(info_model_main)


# Self-assessment of performance

#Descriptives

sos %>%
  group_by(style) %>%
  summarise(
    Mean = mean(self_assessment, na.rm = TRUE),
    SD = sd(self_assessment, na.rm = TRUE),
    Median = median(self_assessment, na.rm = TRUE)
  ) %>% 
  knitr::kable(digits = 2, align = "l")

#Plots self-assessment

ggplot(sos,
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

#Comparison of each condition

t.test(self_assessment ~ style, data = filter(sos, style == "direct" | condition == "standard"))

t.test(self_assessment ~ style, data = filter(sos, style == "direct" | condition == "reinforcement"))

t.test(self_assessment ~ style, data = filter(sos, style == "reinforcement" | condition == "standard"))

# Comparison to the midpoint

t.test(filter(sos, style == "direct")$self_assessment, mu = 3)

t.test(filter(sos, style == "standard")$self_assessment, mu = 3)

t.test(filter(sos, style == "reinforcement")$self_assessment, mu = 3)

#TOST (Only performed if initial three t-test are nonsignificant)

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
reinforcement_mean <- filter(self_table, style == "reiforcement")$Mean
standard_mean <- filter(self_table, style == "standard")$Mean

direct_sd <- filter(self_table, style == "direct")$SD
reinforcement_sd <- filter(self_table, style == "reinforcement")$SD
standard_sd <- filter(self_table, style == "standard")$SD

direct_n <- filter(self_table, style == "direct")$n
reinforcement_n <- filter(self_table, style == "reinforcement")$n
standard_n <- filter(self_table, style == "standard")$n

# Direct vs. Standard

TOSTtwo(m1 = direct_mean, m2 = standard_mean , sd1 = direct_sd, sd2 =  standard_sd, n1 = direct_n, n2 = standard_n, low_eqbound_d = -.20, high_eqbound_d = .20, alpha = .05, plot = FALSE, var.equal = FALSE)

#Direct vs. Reinforcement
 
TOSTtwo(m1 = direct_mean, m2 = reinforcement_mean, sd1 = direct_sd, sd2 = reinforcement_sd, n1 = direct_n, n2 = reinforcement_n, low_eqbound_d = -.20, high_eqbound_d = .20, alpha = .05, plot = FALSE, var.equal = FALSE)

#Reinforcement vs. Standard

TOSTtwo(m1 = standard_mean, m2 = reinforcement_mean, sd1 = standard_sd, sd2 = reinforcement_sd, n1 = standard_n, n2 = reinforcement_n, low_eqbound_d = -.20, high_eqbound_d = .20, alpha = .05, plot = FALSE, var.equal = FALSE)


# Interaction quality

# Descriptives - Interview

sos %>%
  group_by(style) %>%
  summarise(
    Mean = mean(interview_qual, na.rm = TRUE),
    SD = sd(interview_qual, na.rm = TRUE),
    Median = median(interview_qual, na.rm = TRUE)
  ) %>% 
  knitr::kable(digits = 2, align = "l")

#Plot

ggplot(sos,
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

#Descriptives - Interviewer

sos %>%
  group_by(style) %>%
  summarise(
    Mean = mean(interviewer_qual, na.rm = TRUE),
    SD = sd(interviewer_qual, na.rm = TRUE),
    Median = median(interviewer_qual, na.rm = TRUE)
  ) %>% 
  knitr::kable(digits = 2, align = "l")

#Plot

ggplot(sos,
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

#Comparison - Interview

t.test(interview_qual ~ style, data = filter(sos, style == "direct" | style == "standard"))

t.test(interview_qual ~ style, data = filter(sos, style == "direct" | style == "reinforcement"))

t.test(interview_qual ~ style, data = filter(sos, style == "reinforcement" | style == "standard"))

#TOST - These will only be used if the t-tests above are nonsignificant

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

#Direct vs. Standard

TOSTtwo(m1 = direct_mean_2, m2 =standard_mean_2 , sd1 = direct_sd_2, sd2 = standard_sd_2, n1 = direct_n_2, n2 =standard_n_2, low_eqbound_d = -.20, high_eqbound_d = .20, alpha = .05, plot = FALSE, var.equal = FALSE)

#Direct vs. Reinforcement

TOSTtwo(m1 = direct_mean_2, m2 = reinforcement_mean_2, sd1 = direct_sd_2, sd2 = reinforcement_sd_2, n1 = direct_n_2, n2 = reinforcement_n_2, low_eqbound_d = -.20, high_eqbound_d = .20, alpha = .05, plot = FALSE, var.equal = FALSE)

# Reinforcement vs. Standard

TOSTtwo(m1 =standard_mean_2, m2 = reinforcement_mean_2, sd1 =standard_sd_2, sd2 = reinforcement_sd_2, n1 =standard_n_2, n2 = reinforcement_n_2, low_eqbound_d = -.20, high_eqbound_d = .20, alpha = .05, plot = FALSE, var.equal = FALSE)

#Comparison to negative endpoint

t.test(filter(sos, style == "direct")$interview_qual, mu = 1)

t.test(filter(sos, style == "standard")$interview_qual, mu = 1)

t.test(filter(sos, style == "reinforcement")$interview_qual, mu = 1)

#Interviewer

t.test(interviewer_qual ~ style, data = filter(sos, style == "direct" | style == "standard"))

t.test(interviewer_qual ~ style, data = filter(sos, style == "direct" | style == "reinforcement"))

t.test(interviewer_qual ~ style, data = filter(sos, style == "reinforcement" | style == "standard"))

#TOST - These will only be used if the t-tests above are nonsignificant

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

#Direct vs. Standard

TOSTtwo(m1 = direct_mean_3, m2 = standard_mean_3 , sd1 = direct_sd_3, sd2 = standard_sd_3, n1 = direct_n_3, n2 = standard_n_3, low_eqbound_d = -.20, high_eqbound_d = .20, alpha = .05, plot = FALSE, var.equal = FALSE)

#Direct vs. Reinforcement

TOSTtwo(m1 = direct_mean_3, m2 = reinforcement_mean_3, sd1 = direct_sd_3, sd2 = reinforcement_sd_3, n1 = direct_n_3, n2 = reinforcement_n_3, low_eqbound_d = -.20, high_eqbound_d = .20, alpha = .05, plot = FALSE, var.equal = FALSE)

#Reinforcement vs. Standard

TOSTtwo(m1 = standard_mean_3, m2 = reinforcement_mean_3, sd1 = standard_sd_3, sd2 = reinforcement_sd_3, n1 = standard_n_3, n2 = reinforcement_n_3, low_eqbound_d = -.20, high_eqbound_d = .20, alpha = .05, plot = FALSE, var.equal = FALSE)


# Comparison to the negative endpoint

t.test(filter(sos, condition == "direct")$interviewer_qual, mu = 1)

t.test(filter(sos, condition == "standard")$interviewer_qual, mu = 1)

t.test(filter(sos, condition == "reinforcement")$interviewer_qual, mu = 1)