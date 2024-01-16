# retrieve input parameters

library(optparse)
library(jsonlite)


option_list = list(

make_option(c("--id"), action="store", default=NA, type="character", help="my description")

)

# set input parameters accordingly
opt = parse_args(OptionParser(option_list=option_list))

id <- gsub('"', '', opt$id)

if (!requireNamespace("climwin", quietly = TRUE)) {
  install.packages("climwin",repos = "http://cran.us.r-project.org")
}
if (!requireNamespace("zoo", quietly = TRUE)) {
  install.packages("zoo",repos = "http://cran.us.r-project.org")
}
zoo = ''
climwin = ''
library(climwin)
library(zoo)

set.seed(123)
temperature_data <- rnorm(365, mean = 15, sd = 5)

window_size <- 30

temperature_zoo <- zoo::zoo(temperature_data)

rolling_mean_temp <- rollmean(temperature_zoo, k = window_size, fill = 0.0)


temperature_string <- as.character(temperature_zoo)
rolling_mean_temp_string <- as.character(rolling_mean_temp)


# capturing outputs
file <- file(paste0('/tmp/temperature_data_', id, '.json'))
writeLines(toJSON(temperature_data, auto_unbox=TRUE), file)
close(file)
file <- file(paste0('/tmp/rolling_mean_temp_', id, '.json'))
writeLines(toJSON(rolling_mean_temp_string, auto_unbox=TRUE), file)
close(file)
