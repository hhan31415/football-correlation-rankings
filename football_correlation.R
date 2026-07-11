#import data
team_data <- read.csv("data\\team_stats_mls_2025.csv")

# Columns we exclude because they're IDs, non-numeric, or directly define points
exclude_cols <- c("team_id", "team_name", "country_code", "group",
                  "wins", "draws", "losses", "table_position", "matches_played",
                  "points")  # points is our target, not a predictor

# In general to remove non-numeric columns:
# for (col in names(team_data)) {
#   if (is.numeric(team_data[[col]])) {
#     exclude_col <- c(exclude_cols, col)
#   }
# }

# Also exclude every .rank column automatically
rank_cols <- grep("\\.rank$", names(team_data), value = TRUE)
exclude_cols <- c(exclude_cols, rank_cols)

# Everything else is a candidate predictor
predictor_cols <- setdiff(names(team_data), exclude_cols)
#predictor_cols

# Create an empty list to store results as we go
results <- list()

# Loop through each predictor column by name
for (col in predictor_cols) {
  # Pull out the two vectors we're comparing
  x <- team_data[[col]]      # the predictor stat
  y <- team_data$points      # our target
  
  # Run both correlation tests
  pearson_test  <- cor.test(x, y, method = "pearson")
  spearman_test <- cor.test(x, y, method = "spearman")
  
  # Store everything we care about in one row (as a small data frame)
  results[[col]] <- data.frame(
    stat            = col,
    pearson_r       = unname(pearson_test$estimate),
    pearson_r2      = unname(pearson_test$estimate)^2,
    pearson_p       = pearson_test$p.value,
    spearman_rho    = unname(spearman_test$estimate),
    spearman_p      = spearman_test$p.value
  )
}

# Combine the list of single-row data frames into one big table
results_table <- do.call(rbind, results)

# Reset row names (they'll otherwise be messy from the list names)
rownames(results_table) <- NULL

ranked_table <- results_table[order(-abs(results_table$pearson_r2)), ]
ranked_table

# output as csv file
write.csv(ranked_table, file = "output/mls_correlation_results.csv", row.names = FALSE)
