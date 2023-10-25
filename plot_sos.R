################################################################################

# SoS Reinforcement - Additional plots

################################################################################

# Basic setup ------------------------------------------------------------------

packages <- c("gtools", "readr", "tibble", "dplyr", "data.table", "tidyr",
              "readxl", "ggplot2", "lme4", "lmerTest", "cowplot")

lapply(packages, library, character.only = TRUE)

# ------------------------------------------------------------------------------

sos_long_full <- read.csv("./data/sos_long.csv")
sos_long      <- sos_long_full %>% filter(!exclusion %in% c('1'))

# Prepare data -----------------------------------------------------------------

sos_freq <- sos_long

sos_freq <- sos_freq %>% 
  mutate(
    style  = case_when(
      style == "direct"        ~ "Direct",
      style == "reinforcement" ~ "SoS-Reinforcement",
      style == "standard"      ~ "SoS-Standard"
    )
  )


sos_freq$style <- ordered(
  sos_freq$style, levels = c("Direct","SoS-Standard","SoS-Reinforcement")
)


sos_freq$time <- factor(
  sos_freq$time,
  levels = c("0", "1", "2", "3", "4", "5"),
  labels = c("Activity 1", "Activity 2", "Activity 3", "Activity 4", "Activity 5","Activity 6")
)


# Information disclosure by condition and phase, complete grid -----------------

grid_detail <- ggplot(sos_freq,
       aes(
         x = detail
       )) +
  facet_grid(style ~ time
  ) +
  geom_histogram(
    binwidth = 1,
    color = "black",
    fill = "darkgrey"
  ) +
  labs(
    y = "Count",
    x = "Information disclosure"
  ) +
  scale_x_continuous(
    labels = c("0", "1", "2","3","4","5"),
    breaks = 0:5
  ) +
  theme_classic()

# Self-assessment, by style ----------------------------------------------------

perf_plot <- ggplot(sos_freq,
    aes(
      x = self_assessment
  )) +
  labs(
    y = "Count",
    x = "Self-assessment",
  ) +
  facet_wrap(. ~ style) +
  geom_histogram(
    binwidth = .65,
    color = "black",
    fill = "darkgrey"
  ) +
  theme_classic()

# Interview quality, by style --------------------------------------------------

interview_plot <- ggplot(sos_freq,
    aes(
      x = interview_qual
    )) +
  labs (
  y = "Count",
  x = "Interview quality"
  ) +
  facet_wrap(. ~ style) +
  geom_histogram(
    binwidth = .65,
    color = "black",
    fill = "darkgrey"
  ) +
  theme_classic()

# Interviewer perception, by style ---------------------------------------------

interviewer_plot <- ggplot(sos_freq,
                           aes(
                             x = interviewer_qual
                           )) +
  scale_y_continuous(
    breaks = c(0, 50, 100, 150, 200, 250)
  ) +
  labs (
    y = "Count",
    x = "Perceptions of Interviewer"
  ) +
  facet_wrap(. ~ style) +
  geom_histogram(
    binwidth = .65,
    color = "black",
    fill = "darkgrey"
  ) +
  theme_classic()

# Combining self assessment, interview quality & interviewer perception plots --

self_grid <- plot_grid(perf_plot, interview_plot, interviewer_plot, ncol = 1)

