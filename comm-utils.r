
Initialize commonly used variables and functions.
```{r}
# TODO: When we actually get around to analyzing the data, we need to create separate directories for 'good data',
# 'bad data', and 'output files' to keep things organized.

#path_to_files <- "C:\\DataTest\\"
path_to_files <- "C:\\Users\\Adil\\OneDrive\\Communication Experiment Data\\expLogs\\"

na_strings <- c("NA", "N/A", "na", "n/a", "NULL", "null", "None", "none", "NaN", "nan", "Inf", "-Inf", "inf", "-inf", "", " ")
names_with_indices <- function(data) {
  names_data <- names(data)
  indices <- seq_along(names_data)
  names_indexed <- paste(indices, names_data, sep = ": ")
  return(names_indexed)
}
# Function to fix the header and write a new CSV file
fix_csv_header <- function(file_path) {
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
```
