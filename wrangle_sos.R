################################################################################

# SoS Reinforcement - Data Wrangling

################################################################################

# Basic setup ------------------------------------------------------------------

packages <- c("gtools", "readr", "tibble", "dplyr", "data.table", "tidyr",
              "readxl", "ggplot2", "lme4")

lapply(packages, library, character.only = TRUE)

# Load & Merge data ------------------------------------------------------------

## Load Qualtrics data

### Exchange for real data when available

files <- read_csv("./data/qualtrics/qualtrics_files.csv")

## Load disclosure data

data <- read_xlsx("./data/coding/coding_solved.xlsx")

## Merge data

df <- merge(data, files, by = "ResponseId") %>% type_convert()

# Prepare data for analysis ----------------------------------------------------

## Reverse code interview quality, interviewer quality and self-assesment items.
## Create interview quality, interviewer quality and self-assesment composite. 

###Interview quality

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
    
    interview_qual = (
      interview_adj_1 + 
        interview_adj_2_R + 
        interview_adj_3 + 
        interview_adj_4_R + 
        interview_adj_5 + 
        interview_adj_6)/6,
    
###Interviewer quality
    
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
    interviewer_qual = (
      interviewer_adj_1 + 
        interviewer_adj_2_R + 
        interviewer_adj_3_R + 
        interviewer_adj_4 + 
        interviewer_adj_5 + 
        interviewer_adj_6_R)/6,
    
### Self-assessment of performance
    
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
    self_assessment = (
      interview_statements_1 + 
        interview_statements_2 + 
        interview_statements_3 + 
        interview_statements_4)/4,
    )

### Add crime_order column
sos$crime_order <- paste(sos$mock_crime, sos$sequence)

### Organize columns

sos_wrangle <- sos %>%
  select(ID,
         ResponseId, 
         mock_crime, 
         sequence, 
         crime_order, 
         style, 
         interviewer, 
         stage_1, 
         stage_2, 
         stage_3, 
         stage_4, 
         stage_5, 
         stage_6, 
         confidence, 
         motivation, 
         interview_qual, 
         interviewer_qual, 
         self_assessment, 
         age, 
         gender, 
         everything())

### Transform data to long format

sos_long <- sos_wrangle %>% 
  pivot_longer(
    cols = c("stage_1",
             "stage_2",
             "stage_3",
             "stage_4",
             "stage_5",
             "stage_6"),
    names_to = "time",
    values_to = "detail")

### Code time variables for interrupted time series regression

sos_long <-sos_long %>% 
  mutate(
    after = case_when(
      time == "stage_1" ~ 0,
      time == "stage_2" ~ 0,
      time == "stage_3" ~ 0,
      time == "stage_4" ~ 1,
      time == "stage_5" ~ 2,
      time == "stage_6" ~ 3
    ),
    
    treatment = case_when(
      time == "stage_1" ~ 0,
      time == "stage_2" ~ 0,
      time == "stage_3" ~ 0,
      time == "stage_4" ~ 1,
      time == "stage_5" ~ 1,
      time == "stage_6" ~ 1
    ),
    
    start_slope = case_when(
      time == "stage_1" ~ 0,
      time == "stage_2" ~ 1,
      time == "stage_3" ~ 2,
      time == "stage_4" ~ 3,
      time == "stage_5" ~ 4,
      time == "stage_6" ~ 4
    ),
    end_slope = case_when(
      time == "stage_1" ~ 0,
      time == "stage_2" ~ 0,
      time == "stage_3" ~ 0,
      time == "stage_4" ~ 0,
      time == "stage_5" ~ 1,
      time == "stage_6" ~ 2
    ),
    
    time = case_when(
      time == "stage_1" ~ 0,
      time == "stage_2" ~ 1,
      time == "stage_3" ~ 2,
      time == "stage_4" ~ 3,
      time == "stage_5" ~ 4,
      time == "stage_6" ~ 5
    ))

### Factor condition

sos_long$style <- factor(
  sos_long$style,
  levels = c("standard",
             "direct",
             "reinforcement"))


# Export data ------------------------------------------------------------------

write.csv(
  sos_wrangle,
  "./data/sos_wrangle.csv",
  row.names = FALSE
)

write.csv(
  sos_long,
  "./data/sos_long.csv",
  row.names = FALSE
)
