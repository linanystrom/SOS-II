packages <- c("gtools", "readr", "tibble", "dplyr", "data.table", "tidyr",
              "readxl", "ggplot2", "lme4", "TOSTER", "lmerTest", "compute.es",
              "simr")

lapply(packages, library, character.only = TRUE)

# Import data ------------------------------------------------------------------

sos_full      <- read.csv("./data/sos_wrangle.csv")
sos_long_full <- read.csv("./data/sos_long.csv")

## Filter exclusions

sos           <- sos_full %>% filter(!exclusion %in% c('1'))      
sos_long      <- sos_long_full %>% filter(!exclusion %in% c('1')) 


info_model_int <- lmer(detail
                       ~ time 
                       + treatment 
                       + after 
                       + style 
                       + time*style 
                       + treatment*style 
                       + after*style 
                       + (1|crime_order/ID) 
                       + (1|interviewer), 
                       data = sos_long,
                       REML = FALSE
)

model_sim <- makeLmer(detail_sim
         ~ time 
         + treatment 
         + after 
         + style 
         + time*style 
         + treatment*style 
         + after*style 
         + (1|crime_order/ID) 
         + (1|interviewer), 
         data = sos_long,
         sigma = sigma(info_model_int),
         VarCorr = VarCorr(info_model_int),
         fixef = fixef(info_model_int))


sim_1 <- powerSim(model_sim,
                  test = fixed("after:stylereinforcement",
                               method = "t"),
                  nsim = 1000)

sim_data <- getData(model_sim)


info_desc <- sim_data %>% 
  group_by(style, time) %>% 
  summarise(
    Mean = mean(detail_sim, na.rm = TRUE),
    SD = sd(detail_sim, na.rm = TRUE),
    Median = median(detail_sim, na.rm = TRUE),
    SE = SD/sqrt(n()),
    Upper = Mean + (1.96*SE),
    Lower = Mean - (1.96*SE)
  )


## Plot information disclosure 

info_plot <- ggplot(sim_data,
                    aes(
                      x = time,
                      y = detail_sim
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
