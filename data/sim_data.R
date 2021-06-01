
## Set up

sample       <- 300
n_stage      <- 3              # nr of stages per half
stages       <- c(1:n_stage)
midpoint     <- c("before", "after")
range_details      <- c(0:5)         #details revealed

## Set up data frame

simulation <- 
  expand.grid(
    ID = 1:sample
  )

## Bind permutations data frame with simulation

simulation <- bind_cols(simulation, sample_permutations_random)

## Set up column names

trials <- 
  expand.grid(
    midpoint = midpoint,
    stage = stages
  ) %>% 
  arrange(by = midpoint)

column  <- apply(trials, 1, paste, collapse = "_")

## Simulate revealed details

detail  <- replicate(n_stage * nrow(expand.grid(midpoint)), sample(range_details, nrow(simulation), replace = TRUE)) %>% 
  as.data.frame()

## Add column names

colnames(detail) <- column

## Bind revealed details with simulation

simulation <- bind_cols(simulation, detail)
