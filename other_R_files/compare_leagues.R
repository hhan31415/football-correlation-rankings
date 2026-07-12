#install.packages("dplyr")
library(dplyr)

#list all output files
result_files <- list.files("output\\correlation_results", pattern = "_correlation_results.csv", full.names = TRUE)

# Empty list to collect each league's table
all_results <- list()

for (file in result_files) {
  league_data <- read.csv(file)
  all_results[[file]] <- league_data
}

# Stack them all into one big table
all_leagues <- do.call(rbind, all_results)
rownames(all_leagues) <- NULL

# Filter out unwanted leagues:
#all_leagues <- all_leagues %>% filter(league != "mls")

# Print out variance in R and p-value by stat
stat_variability <- all_leagues %>%
  group_by(stat) %>%
  summarize(
    min_r  = min(pearson_r),
    max_r  = max(pearson_r),
    range  = max_r - min_r,
    mean_r = mean(pearson_r),
    min_p  = min(pearson_p),
    max_p  = max(pearson_p),
    mean_p = mean(pearson_p),
  ) %>%
  arrange(desc(range))
  #arrange(desc(max_p))

# Show if stats are significant
stat_variability <- stat_variability %>% 
  mutate(min_significant = if_else(min_p<0.05, TRUE, FALSE)) %>%
  mutate(max_significant = if_else(max_p<0.05, TRUE, FALSE))
#print(stat_variability, n=30)

write.csv(stat_variability, 
            file = paste0("output/team_stat_variability.csv"), 
            row.names = FALSE)

# Arrange all_leagues by the top 17 stats (these are the stats that are not significant in at least one league) 
top_variable_stats <- stat_variability$stat[1:17]

detail_view <- all_leagues %>%
  filter(stat %in% top_variable_stats) %>%
  select(league, stat, pearson_r2, pearson_r, pearson_p) %>%
  arrange(league, desc(pearson_r2))
detail_view <- detail_view %>%
  mutate(pearson_p = formatC(pearson_p, format = "f", digits = 6))

write.csv(detail_view, 
          file = paste0("output/league_top_variable_stats.csv"), 
          row.names = FALSE)