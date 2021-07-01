library("readxl")

## Load qualtrics data
MC2B_file     <- read_xlsx("./data/qualtrics/help.xlsx")

## files <- rbind(MC2A_file, MC2B_file)

## Load discloure data

data <- read_xlsx("./data/coding.xlsx")

## Smush data

df <- merge(data, MC2B_file, by = "ResponseId")

## Reverse code interview quality and interviewer quality items. Create interiew quality and interviewer quality composite. 

df <- df %>% 
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
  )

## Remove attention check failures (1 = correct)

clean_df <- df %>% 
  mutate(
  attention_pass = case_when(
    sum(attention_a1, attention_a2, attention_b1, attention_b2) == 4 ~1,
    sum(attention_a1, attention_a2, attention_b1, attention_b2) != 4 ~0,
  )
) %>% 
  filter(attention_pass == 1)


