#function to calculate point vs data correlation for a specific league
league_correlation <- function(csv_path, league_name, 
    manual_exclude = c("team_id", "points", 
                   "wins", "draws", 
                   "losses", "table_position", "matches_played")) {
  #Args:
  #csv_path (str): the path for the csv; the given csv files should be of the form data/team_stats_league_year(s)
  #league_name (str): the name of the league for labeling
  #manual_exclude (vec): vector of specific columns to exclude
  team_data <- read.csv(csv_path)
  
  exclude_cols <- manual_exclude
  
  #Remove non-numeric columns if they weren't already removed by manual_exclude
  for (col in names(team_data)) {
     if (!is.numeric(team_data[[col]])) {
       exclude_cols <- c(exclude_cols, col)
     }
   }
  
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
      spearman_p      = spearman_test$p.value,
      league          = league_name    #for when we join/filter with other tables
    )
  }
  
  # Combine the list of single-row data frames into one big table
  results_table <- do.call(rbind, results)
  
  # Reset row names (they'll otherwise be messy from the list names)
  rownames(results_table) <- NULL
  
  ranked_table <- results_table[order(-abs(results_table$pearson_r2)), ]
  
  # output as csv file
  write.csv(results_table, 
            file = paste0("output/correlation_results/", league_name, "_correlation_results.csv"), 
            row.names = FALSE)
  return(results_table)
}

# Call function for each league to output as csv
# league_correlation("data\\team_stats_mls_2025.csv","mls")
# league_correlation("data\\team_stats_bundesliga_2025-2026.csv","bundesliga")
# league_correlation("data\\team_stats_la_liga_2025-2026.csv","la_liga")
# league_correlation("data\\team_stats_premier_league_2025-2026.csv","premier_league")
# league_correlation("data\\team_stats_serie_a_2025-2026.csv","serie_a")
# league_correlation("data\\team_stats_ligue_1_2025-2026.csv","ligue_1")


