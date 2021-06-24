library("readxl")

## Load qualtrics data
MC2B_file     <- read.csv("./data/qualtrics/MC2B.csv")

## files <- rbind(MC2A_file, MC2B_file)

## Load discloure data

data <- read_excel("./data/coding.xlsx")

## Smush data

df <- merge(data, MC2B_file, by = "ResponseId")