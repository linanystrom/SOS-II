## Packages

packages <- c("gtools", "readr", "tibble", "dplyr")

lapply(packages, library, character.only = TRUE)

## Seed

set.seed(666)

## Study set up

nr_mcs    <- 3    #Number of mock crimes
nr_stages <- 2    #Number of stages per mock crime
nr_style  <- 3    #Number of styles
sample    <- 300  #Sample size
group     <- sample / nr_mcs

style     <- c("direct", "standard", "reinforcement") #interview style
stages    <- c("A","B")                               #stages

## Generate permutations for stages

permutations <- permutations(n = nr_stages, r = nr_stages, v = stages)

colnames(permutations) <- c("stage_1","stage_2")

permutations <- data.frame(permutations)

## Adding column for sequence of stages

permutations$sequence <-
  paste(
    permutations$stage_1,
    permutations$stage_2
  )

## Calculating number of possible permutations

poss_permutations <- length(permutations$sequence)

## Multipling possible permutations with number of mock crimes

mc_x_poss_permutations <- poss_permutations*nr_mcs

## Creating data frame with all possible permutations * number of mock crimes

MCpermutations <- do.call("rbind", replicate(nr_mcs, permutations, simplify = FALSE))

## Assigning mock crime to permitations

MCpermutations$mock_crime <- NA

MCpermutations$mock_crime <- c("MC_2")
MCpermutations$mock_crime[1:poss_permutations]<- c("MC_1")
MCpermutations$mock_crime[(mc_x_poss_permutations - (poss_permutations - 1)):mc_x_poss_permutations]<- c("MC_3")

sample_permutations <- do.call("rbind", replicate((sample/mc_x_poss_permutations), MCpermutations, simplify = FALSE))

sample_permutations$style[sample(1:nrow(sample_permutations), nrow(sample_permutations), FALSE)] <- rep(style,group)

style_count <- count(sample_permutations, style)
MC_count <- count(sample_permutations, mock_crime)

overall_count <- count(sample_permutations, mock_crime, sequence, style)

rows <- sample(nrow(sample_permutations))

sample_permutations_random <- sample_permutations[rows,]


write.csv(sample_permutations_random,"filmpermutations.csv", row.names = FALSE)

