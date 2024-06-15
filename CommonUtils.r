 
# Initializes commonly used libraries, variables, and functions.

library(tidyr)
library(fs)
library(dplyr)
library(readr)
library(purrr)
library(data.table)
library(pwr)
library(janitor)
library(magrittr) 
library(tidyverse)
library(stringr)
library(ggpubr)
library(ggplot2)
library(rstatix)
library(qqplotr)
library(here)
library(tidyverse)
library(qqplotr)
library(rstatix)
library(broom)
library(knitr)
library(ggpubr)
library(gtools)
library(GGally)
library(correlation)
library(png)
library(patchwork)
library(dtplyr)
library(tidyverse)
library(textclean)

# TODO: When we actually get around to analyzing the data, we need to create separate directories for 'good data',
# 'bad data', and 'output files' to keep things organized.

na_strings <- c("NA", "N/A", "na", "n/a", "NULL", "null", "None", "none", "NaN", "nan", "Inf", "-Inf", "inf", "-inf", "", " ")
names_with_indices <- function(data) {
  names_data <- names(data)
  indices <- seq_along(names_data)
  names_indexed <- paste(indices, names_data, sep = ": ")
  return(names_indexed)
}
# Function to fix the header and write a new CSV file
fix_csv_header_id <- function(file_path) {
  # Read the first line to check headers
  con <- file(file_path, open = "r")
  first_line <- readLines(con, n = 1)
  close(con)
  
  # Append ',id' to the first line
  corrected_first_line <- paste(first_line, "id", sep = ",")
  
  # Read the remaining lines of the original file
  remaining_lines <- read_lines(file_path, skip = 1)
  
  # Combine the corrected first line with the remaining lines
  corrected_content <- c(corrected_first_line, remaining_lines)
  
  # Define the new file path
  new_file_path <- paste0(sub(".csv", "", file_path), "_fixed.csv")
  
  # Write the corrected content to the new file
  writeLines(corrected_content, new_file_path)
  
  return(new_file_path)
}

# Function to fix the header and write a new CSV file with additional columns
fix_csv_header_cols <- function(file_path, additional_columns, suffix = "_fixed.csv") {
  # Read the first line to check headers
  con <- file(file_path, open = "r")
  first_line <- readLines(con, n = 1)
  close(con)
  
  # Append additional columns to the first line
  corrected_first_line <- paste(first_line, additional_columns, sep = ",")
  
  # Read the remaining lines of the original file
  remaining_lines <- read_lines(file_path, skip = 1)
  
  # Combine the corrected first line with the remaining lines
  corrected_content <- c(corrected_first_line, remaining_lines)
  
  # Define the new file path
  new_file_path <- paste0(sub(".csv", "", file_path), suffix)
  
  # Write the corrected content to the new file
  writeLines(corrected_content, new_file_path)
  
  return(new_file_path)
}

#path_to_files <- "C:\\DataTest\\"
#path_to_files <- "C:\\Users\\Kit\\OneDrive\\Communication Experiment Data\\expLogs\\"
path_to_files <- "C:\\Users\\Kit\\OneDrive\\Communication Experiment Data\\Communication Analysis\\_raw data\\"
options("digits.secs"=6)

# Setup the base ratings file.
subject_ratings <- fs::dir_ls(path = path_to_files, recurse = TRUE, regexp = "[A-Z]{3}-\\d{3}\\/[A-Z]{3}-\\d{3} rating_fixed\\.csv$") %>%
  map_dfr(.f = function(subjects_file) {
    print(subjects_file)
    subject_row <- read_csv(subjects_file, na = na_strings, show_col_types = FALSE) %>% clean_names()
    subject_row
  }) 
subject_ratings <- subject_ratings %>% filter(round_id != 9) %>% mutate(subject_id = substr(subject_id, 1, 7))
# Ensure subject_ratings is a data frame
subject_ratings <- as.data.frame(subject_ratings)
