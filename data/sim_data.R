## Seed

set.seed(25.8069758011)

## Set up

sample        <- 300
n_stage       <- 6              # nr of stages per half
stages        <- c(1:n_stage)
range_details <- c(0:5)         #details revealed
interviewer   <- c("M", "P", "K")

#MC2A_file     <- read.csv("C:/Users/xnystl/Documents/R projects/SOS-II/data/qualtrics/MC2A.csv")
#MC2B_file     <- read.csv("C:/Users/xnystl/Documents/R projects/SOS-II/data/qualtrics/MC2B.csv")
#files         <- rbind(MC2A_file, MC2B_file)

## Set up data frame

simulation <- 
  expand.grid(
    ID = 1:sample
  )

## Bind permutations data frame with simulation

simulation <- bind_cols(simulation, sample_permutations_random)

simulation$crime_order <- paste(simulation$mock_crime, simulation$sequence)

## Set up column names

trials <- 
  expand.grid(
    step = "stage",
    stage = stages
  ) %>% 
  arrange(by = stage)

column  <- apply(trials, 1, paste , collapse = "_")

## Simulate revealed details

detail  <- replicate(n_stage, sample(range_details, nrow(simulation), replace = TRUE)) %>% 
  as.data.frame()

## Add column names

colnames(detail) <- column

## Bind revealed details with simulation

simulation <- bind_cols(simulation, detail)

## Add interviewer column

simulation$interviewer <- sample(interviewer)

##sim_wide <- left_join(simulation, files, by = "ID")

sim_style <- simulation %>% group_by(style)

sim_style_long <- sim_style %>% pivot_longer(8:13, names_to = "time", values_to = "detail" )

## Coding time vars

sim_style_long$after <- case_when(
  sim_style_long$time == "stage_1" ~ 0,
  sim_style_long$time == "stage_2" ~ 0,
  sim_style_long$time == "stage_3" ~ 0,
  sim_style_long$time == "stage_4" ~ 1,
  sim_style_long$time == "stage_5" ~ 2,
  sim_style_long$time == "stage_6" ~ 3
)

sim_style_long$treatment <- case_when(
  sim_style_long$time == "stage_1" ~ 0,
  sim_style_long$time == "stage_2" ~ 0,
  sim_style_long$time == "stage_3" ~ 0,
  sim_style_long$time == "stage_4" ~ 1,
  sim_style_long$time == "stage_5" ~ 1,
  sim_style_long$time == "stage_6" ~ 1
)

sim_style_long$time <- case_when(
  sim_style_long$time == "stage_1" ~ 1,
  sim_style_long$time == "stage_2" ~ 2,
  sim_style_long$time == "stage_3" ~ 3,
  sim_style_long$time == "stage_4" ~ 4,
  sim_style_long$time == "stage_5" ~ 5,
  sim_style_long$time == "stage_6" ~ 6
)

##Dummy code condition

sim_style_long$cond_direct <- case_when(
  sim_style_long$style == "direct" ~ 1,
  sim_style_long$style == "standard" ~ 0,
  sim_style_long$style == "reinforcement" ~ 0
)

sim_style_long$cond_standard <- case_when(
  sim_style_long$style == "direct" ~ 0,
  sim_style_long$style == "standard" ~ 1,
  sim_style_long$style == "reinforcement" ~ 0
)

sim_style_long$cond_reinforcement <- case_when(
  sim_style_long$style == "direct" ~ 0,
  sim_style_long$style == "standard" ~ 0,
  sim_style_long$style == "reinforcement" ~ 1
)

## Factor condition

sim_style_long$style <- factor(sim_style_long$style, levels = c("direct", "standard", "reinforcement"))


sim_style_long %>% 
  group_by(style, time) %>% 
  summarise(
    Mean = mean(detail, na.rm = TRUE),
    SD = sd(detail, na.rm = TRUE),
    Median = median(detail, na.rm = TRUE)
  ) %>% 
  knitr::kable(digits = 2, align = "l")


info_desc <- sim_style_long %>% 
  group_by(style, time) %>% 
  summarise(
    Mean = mean(detail, na.rm = TRUE),
    SD = sd(detail, na.rm = TRUE),
    Median = median(detail, na.rm = TRUE),
    SE = SD/sqrt(n()),
    Upper = Mean + (1.96*SE),
    Lower = Mean - (1.96*SE)
  )

##Test ggplot. scale labels x error.

ggplot(sim_style_long,
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
    labels = c("1", "2", "3","4","5","6")
  ) +
  coord_cartesian(
    ylim = c(0, 5)
  ) +
  theme_classic()


## 

info_model_main <- lmer(detail ~ time + style + (1|crime_order/ID) + (1|interviewer), data = sim_style_long, REML = FALSE)

summary(info_model_main)