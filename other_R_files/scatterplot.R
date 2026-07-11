# Plots for specific data frames
plot(team_data$data, team_data$points,
     xlab = "Data",
     ylab = "Points",
     main = "Data vs Points",
     pch = 19, col = "steelblue")

# Add a linear trend line on top
abline(lm(points ~ Touches.in.opposition.box, data = team_data), col = "red", lwd = 2)