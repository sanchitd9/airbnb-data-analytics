library("tibble")

# ------------------------------------------------------ #
# IMPORT THE DATA
# ------------------------------------------------------ #
airbnb_df <- read.csv("airbnb-listings.csv", sep = ";")


# ------------------------------------------------------ #
# TIDY THE DATA
# ------------------------------------------------------ #

# Check out the variables and their data types
# Observations:
# 1. Most of the values are strings with no particular patterns or structure, not useful for analysis.
# 2. Some variables which look useful for our data analysis:
# "Accommodates", "Bedrooms", "Bathrooms", "Beds", "Price", "City", "State", etc
glimpse(airbnb_df)

# Create a vector of the useful variables
useful_vars <- c(
  "City",
  "State",
  "Country",
  "Accommodates",
  "Bathrooms",
  "Bedrooms",
  "Beds",
  "Price",
  "Number.of.Reviews",
  "Review.Scores.Rating"
)

# Remove all the other variables from the data frame.
airbnb_df <- airbnb_df[, useful_vars]

# Remove all the rows with at least column equal to NA.
airbnb_df <- na.omit(airbnb_df)
# Remove all the rows with empty strings for City, State or Country
airbnb_df <- airbnb_df[airbnb_df$City != "", ]
airbnb_df <- airbnb_df[airbnb_df$State != "", ]
airbnb_df <- airbnb_df[airbnb_df$Country != "", ]

# Check the data again.
glimpse(airbnb_df)
summary(airbnb_df)

# There is still an anomaly with the price, as it has a minimum value of 0.
# Each listing on Airbnb needs to have a non-zero price, so we'll remove these rows of data.
# Remove rows with price = 0
airbnb_df <- airbnb_df[airbnb_df$Price > 0, ]


# ------------------------------------------------------ #
# EXPLORATORY ANALYSIS
# ------------------------------------------------------ #