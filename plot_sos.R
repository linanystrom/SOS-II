
#Grid - Information disclosure

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



D1_plot <- ggplot(
  subset(sos, style == "direct"),
  aes(
    x = stage_1
  )) +
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

D2_plot <- ggplot(subset(sos, style == "direct"),
                        aes(
                          x = stage_2
                        )) +
  #facet_wrap(. ~ time) +
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