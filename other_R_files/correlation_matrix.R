install.packages("corrplot")
library(corrplot)

# Combine points with our predictor columns into one set
cols_for_matrix <- c("points", predictor_cols)

# Subset the data frame to just these columns
matrix_data <- team_data[, cols_for_matrix]

# Compute the full pairwise correlation matrix
corr_matrix <- cor(matrix_data, use = "pairwise.complete.obs")

#correlation plot
corrplot(corr_matrix, 
         method = "color",      # colored squares instead of circles/numbers
         type = "upper",        # only show upper triangle (matrix is symmetric, so lower half is redundant)
         tl.col = "black",      # text label color
         tl.cex = 0.6,          # text size (small since we have 32 labels)
         diag = FALSE,          # hide the diagonal (always 1.0, not informative)
         order = "hclust",      # reorder using hierarchical clustering
         hclust.method = "average")  # how clusters are merged (a common default)