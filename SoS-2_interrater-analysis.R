################################################################################

# SoS - Reinforcement, Interrater Reliability Analysis

################################################################################

# Basic setup ------------------------------------------------------------------

packages <- c("readxl", "lme4", "boot")

lapply(packages, library, character.only = TRUE)

source("icc_func.r")
set.seed(666)

# Load data --------------------------------------------------------------------

K <- read_xlsx("./data/coding/coding_K.xlsx") %>% 
  filter(!is.na(stage_1))

L <- read_xlsx("./data/coding/coding_L.xlsx") %>% 
  filter(!is.na(stage_1))

M <- read_xlsx("./data/coding/coding_M.xlsx") %>% 
  filter(!is.na(stage_1))

P <- read_xlsx("./data/coding/coding_P.xlsx") %>% 
  filter(!is.na(stage_1))

# Information disclosure -------------------------------------------------------

K_long <- K %>% 
  pivot_longer(
    cols = c("stage_1", "stage_2", "stage_3", "stage_4", "stage_5", "stage_6"),
    names_to = "stage",
    values_to = "disclosure"
  ) %>% 
  mutate(
    stage_id = paste(stage, ID, sep = "_")
  ) %>% 
  select(stage_id, coded_by, stage, disclosure)

L_long <- L %>% 
  pivot_longer(
    cols = c("stage_1", "stage_2", "stage_3", "stage_4", "stage_5", "stage_6"),
    names_to = "stage",
    values_to = "disclosure"
  ) %>% 
  mutate(
    stage_id = paste(stage, ID, sep = "_")
  ) %>% 
  select(stage_id, coded_by, stage, disclosure)

M_long <- M %>% 
  pivot_longer(
    cols = c("stage_1", "stage_2", "stage_3", "stage_4", "stage_5", "stage_6"),
    names_to = "stage",
    values_to = "disclosure"
  ) %>% 
  mutate(
    stage_id = paste(stage, ID, sep = "_")
  ) %>% 
  select(stage_id, coded_by, stage, disclosure)

P_long <- P %>% 
  pivot_longer(
    cols = c("stage_1", "stage_2", "stage_3", "stage_4", "stage_5", "stage_6"),
    names_to = "stage",
    values_to = "disclosure"
  ) %>% 
  mutate(
    stage_id = paste(stage, ID, sep = "_")
  ) %>% 
  select(stage_id, coded_by, stage, disclosure)

coded_stages <- bind_rows(K_long, L_long, M_long, P_long)

disclosure_model <- lmer(disclosure ~ (1|stage_id) + (1|coded_by), data = coded_stages)

disclosure_icc <- ICC_func(disclosure_model)

disclosure_boot_icc <- bootMer(disclosure_model, ICC_func, nsim = 1000)

disclosure_ci_icc <- boot.ci(disclosure_boot_icc, index = 1, type = "perc")


# Confrontations ---------------------------------------------------------------

K_long_confrontation <- K %>% 
  pivot_longer(
    cols = c("stage_1_conf", "stage_2_conf", "stage_3_conf", "stage_4_conf"),
    names_to = "stage",
    values_to = "confrontations"
  ) %>% 
  mutate(
    stage_id = paste(stage, ID, sep = "_")
  ) %>% 
  select(stage_id, coded_by, stage, confrontations)

L_long_confrontation <- L %>% 
  pivot_longer(
    cols = c("stage_1_conf", "stage_2_conf", "stage_3_conf", "stage_4_conf"),
    names_to = "stage",
    values_to = "confrontations"
  ) %>% 
  mutate(
    stage_id = paste(stage, ID, sep = "_")
  ) %>% 
  select(stage_id, coded_by, stage, confrontations)

M_long_confrontation <- M %>% 
  pivot_longer(
    cols = c("stage_1_conf", "stage_2_conf", "stage_3_conf", "stage_4_conf"),
    names_to = "stage",
    values_to = "confrontations"
  ) %>% 
  mutate(
    stage_id = paste(stage, ID, sep = "_")
  ) %>% 
  select(stage_id, coded_by, stage, confrontations)

P_long_confrontation <- P %>% 
  pivot_longer(
    cols = c("stage_1_conf", "stage_2_conf", "stage_3_conf", "stage_4_conf"),
    names_to = "stage",
    values_to = "confrontations"
  ) %>% 
  mutate(
    stage_id = paste(stage, ID, sep = "_")
  ) %>% 
  select(stage_id, coded_by, stage, confrontations)

coded_stages_confrontation <- bind_rows(K_long_confrontation, L_long_confrontation, M_long_confrontation, P_long_confrontation)

confrontation_model <- lmer(confrontations ~ (1|stage_id) + (1|coded_by), data = coded_stages_confrontation)

confrontation_icc <- ICC_func(confrontation_model)

confrontation_boot_icc <- bootMer(confrontation_model, ICC_func, nsim = 1000)

confrontation_ci_icc <- boot.ci(confrontation_boot_icc, index = 1, type = "perc")


# Disclosures During Reinforcement ---------------------------------------------

K_long_reinforcement <- K %>% 
  pivot_longer(
    cols = c("stage_1_reinf", "stage_2_reinf", "stage_3_reinf"),
    names_to = "stage",
    values_to = "reinf_disc"
  ) %>% 
  mutate(
    stage_id = paste(stage, ID, sep = "_")
  ) %>% 
  select(stage_id, coded_by, stage, reinf_disc)

L_long_reinforcement <- L %>% 
  pivot_longer(
    cols = c("stage_1_reinf", "stage_2_reinf", "stage_3_reinf"),
    names_to = "stage",
    values_to = "reinf_disc"
  ) %>% 
  mutate(
    stage_id = paste(stage, ID, sep = "_")
  ) %>% 
  select(stage_id, coded_by, stage, reinf_disc)

M_long_reinforcement <- M %>% 
  pivot_longer(
    cols = c("stage_1_reinf", "stage_2_reinf", "stage_3_reinf"),
    names_to = "stage",
    values_to = "reinf_disc"
  ) %>% 
  mutate(
    stage_id = paste(stage, ID, sep = "_")
  ) %>% 
  select(stage_id, coded_by, stage, reinf_disc)

P_long_reinforcement <- P %>% 
  pivot_longer(
    cols = c("stage_1_reinf", "stage_2_reinf", "stage_3_reinf"),
    names_to = "stage",
    values_to = "reinf_disc"
  ) %>% 
  mutate(
    stage_id = paste(stage, ID, sep = "_")
  ) %>% 
  select(stage_id, coded_by, stage, reinf_disc)

coded_stages_reinforcement <- bind_rows(K_long_reinforcement, L_long_reinforcement, M_long_reinforcement, P_long_reinforcement)

reinforcement_model <- lmer(reinf_disc ~ (1|stage_id) + (1|coded_by), data = coded_stages_reinforcement)

reinforcement_icc <- ICC_func(reinforcement_model)

reinforcement_boot_icc <- bootMer(reinforcement_model, ICC_func, nsim = 1000)

reinforcement_ci_icc <- boot.ci(reinforcement_boot_icc, index = 1, type = "perc")

# Total disagreement -----------------------------------------------------------

L_vec <- L_long$disclosure 

K_vec <- K_long$disclosure 

M_vec <- M_long$disclosure 

P_vec <- P_long$disclosure 

# P & L comp

L_vec_1 <- L_vec[1:1014]

disagreement_PL <- sum((L_vec_1 - P_vec) != 0)


# K & L comp

L_vec_2 <- L_vec[1015:1188] #ID: 204

K_vec_1 <- K_vec[1:174] #ID: 204

disagreement_KL <- sum((L_vec_2 - K_vec_1) != 0)

# M & L comp

L_vec_3 <- L_vec[1189:1356] #ID: 232

M_vec_1 <- M_vec[7:174]

disagreement_ML <- sum((L_vec_3 - M_vec_1) != 0)

# M & K comp

K_vec_2 <- K_vec[175:618] #ID: 308

M_vec_2 <- M_vec[175:618]

disagreement_KM <- sum((K_vec_2 - M_vec_2) != 0, na.rm = TRUE)

# Total

total_disagreement <- disagreement_PL+ disagreement_KL + disagreement_ML + disagreement_KM + 2 # added 2 for M's NAs

perc_disagreement <- total_disagreement/1800

