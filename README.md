# Correlation Analysis of Stats vs Success: Top 5 European Leagues and MLS
## by Heechan Han

## Contents
- [Introduction](#introduction)
- [Computing Correlation](#computing-correlation)
- [Comparing Leagues](#comparing-leagues)
- [Interesting Observations](#interesting-observations)
- [Conclusion](#conclusion)

## Introduction
This project aims to explore various football stats that best correlate with success, and compare how this correlation differs across different stats across different leagues. The general idea is as follows. We will take football club statistics scraped from my [FotMob data scraper](https://github.com/hhan31415/fotmob-scraper) for six different leagues in the 2025-2026 season: the Big 5 leagues (i.e., Premier League, La Liga, Bundesliga, Serie A, Ligue 1) and the MLS. These statistics include xG, average possession, corners taken, clearances, etc. 

Then for each league, we will use R to compute and compile the correlation between total points in the league season and each of these statistics. The correlation data will be given by Pearson's and Spearman's correlation tests. Removing obvious correlating stats like wins and goals scored, we want to see if for each league, there are any non-trivial statistics that correlate highly to on-field success.

We then want to compare these correlation numbers across various leagues to explore if there is any meaningful difference between the games being played across Europe and the US. In particular, we want to identify statistics whose correlation strength varies substantially across leagues, while still being statistically significant in at least some of them. We will later see that a few non-trivial examples can pop up.

## Computing Correlation
The main R file we will be working with is [football_correlation.R](football_correlation.R). The main part of this R script is the function league_correlation(csv_path, league_name, manual_exclude), which takes in arguments: csv_path (str) the path for the CSV; league_name (str) the name of the league for labelling; and manual_exclude (vec) a vector of specific columns to exclude, with default assignment 
```
c("team_id", "points", "wins", "draws", "losses", "table_position", "matches_played")
```
which are irrelevant stats like team_id (used internally by FotMob to track clubs) or stats that are mathematically dependent on points, like winss.

The function outputs a table of each relevant stat with five correlation values: Pearson's r, r^2, p-value, Spearman Rho, and Spearman p-value, which are then saved as a CSV. The following is such a table for the Premier League:
| stat | pearson_r | pearson_r2 | pearson_p | spearman_rho | spearman_p | league |
|---|---|---|---|---|---|---|
| FotMob.rating | 0.89846258 | 0.807235002 | 7.498509e-08 | 0.77044860 | 7.052362e-05 | premier_league |
| Goals.per.match | 0.90723050 | 0.823067179 | 3.437734e-08 | 0.82046608 | 9.400566e-06 | premier_league |
| Goals.conceded.per.match | -0.89097401 | 0.793834690 | 1.383139e-07 | -0.69718606 | 6.344045e-04 | premier_league |
| Average.possession | 0.73748014 | 0.543876960 | 2.067840e-04 | 0.73391089 | 2.301655e-04 | premier_league |
| Clean.sheets | 0.81742146 | 0.668177847 | 1.080780e-05 | 0.61132044 | 4.185640e-03 | premier_league |
| Attendance | 0.41576262 | 0.172858560 | 6.827582e-02 | 0.26646611 | 2.561136e-01 | premier_league |
| Expected.goals | 0.76995536 | 0.592831259 | 7.175832e-05 | 0.72563087 | 2.932583e-04 | premier_league |
| xG.difference | 0.86488588 | 0.748027582 | 8.638453e-07 | 0.72515081 | 2.973290e-04 | premier_league |
| Shots.on.target.per.match | 0.82426661 | 0.679415452 | 7.869323e-06 | 0.76050602 | 9.927917e-05 | premier_league |
| Big.chances | 0.77757427 | 0.604621751 | 5.462182e-05 | 0.66629007 | 1.338323e-03 | premier_league |
| Big.chances.missed | 0.78830681 | 0.621427626 | 3.651691e-05 | 0.69905843 | 6.045943e-04 | premier_league |
| Accurate.passes.per.match | 0.64218604 | 0.412402905 | 2.266045e-03 | 0.63153973 | 2.820520e-03 | premier_league |
| Accurate.long.balls.per.match | -0.29925767 | 0.089555151 | 1.999254e-01 | -0.31972935 | 1.693808e-01 | premier_league |
| Accurate.crosses.per.match | 0.03392909 | 0.001151183 | 8.870756e-01 | -0.17113773 | 4.706513e-01 | premier_league |
| Penalties.awarded | 0.07599872 | 0.005775805 | 7.643902e-01 | 0.08059095 | 7.505690e-01 | premier_league |
| Touches.in.opposition.box | 0.82544360 | 0.681357137 | 7.441404e-06 | 0.78283829 | 4.495741e-05 | premier_league |
| Corners | 0.61640048 | 0.379949550 | 3.799819e-03 | 0.48681236 | 2.949727e-02 | premier_league |
| Set.piece.goals | 0.61536222 | 0.378670666 | 3.876177e-03 | 0.41992179 | 6.528415e-02 | premier_league |
| xG.conceded | -0.82988504 | 0.688709177 | 6.003340e-06 | -0.69227877 | 7.185065e-04 | premier_league |
| Interceptions.per.match | -0.41799274 | 0.174717927 | 6.665918e-02 | -0.37646195 | 1.018349e-01 | premier_league |
| Tackles.per.match | -0.46872238 | 0.219700668 | 3.710283e-02 | -0.52409653 | 1.769097e-02 | premier_league |
| Clearances.per.match | -0.55166264 | 0.304331664 | 1.168207e-02 | -0.48474580 | 3.029827e-02 | premier_league |
| Possession.won.final.3rd.per.match | 0.55096761 | 0.303565306 | 1.180991e-02 | 0.46113260 | 4.071417e-02 | premier_league |
| Set.piece.goals.conceded | -0.12718712 | 0.016176565 | 5.930981e-01 | -0.06818278 | 7.751683e-01 | premier_league |
| Saves.per.match | -0.69559924 | 0.483858300 | 6.606347e-04 | -0.44806326 | 4.756344e-02 | premier_league |
| Fouls.per.match | -0.53628957 | 0.287606499 | 1.478526e-02 | -0.54905723 | 1.216715e-02 | premier_league |
| Yellow.cards | -0.31941707 | 0.102027267 | 1.698211e-01 | -0.30496997 | 1.910573e-01 | premier_league |
| goal_difference | 0.97186223 | 0.944516197 | 9.481978e-13 | 0.91337106 | 1.899175e-08 | premier_league |
| Penalties.conceded | -0.52927149 | 0.280128306 | 1.979110e-02 | -0.49580653 | 3.086279e-02 | premier_league |
| Red.cards | -0.15170975 | 0.023015850 | 5.610711e-01 | -0.29233629 | 2.548623e-01 | premier_league |

The CSV files for the six leagues can be found [here](data/).

In addition, there are two supplementary R files [scatterplot.R](other_R_files/scatterplot.R) and [correlation_matrix.R](other_R_files/correlation_matrix.R). The former creates a scatterplot with a linear trend line for a specific stat, and the latter creates a correlation matrix for all stats in a league. Both can be inserted into the main function of the football_correlation.R file to give these visualizations if desired.

## Comparing Leagues
Now that we have the correlation values for each statistic, we want to compare these values across leagues to see if there are any meaningful differences between the leagues. In particular, the following are some examples of interesting observations we may look for:
- Statistics not directly connected to wins or goals that have a significant, high correlation across multiple leagues,
- Stats which have high correlation and significant p-values in some leagues, but low correlation in others,
- Stats which have positive correlation in some leagues but negative correlation in others.

To do this, I combined all the previous CSVs containing correlation data into one massive table, grouping by stats, then computed various values like range of r values and average r values across the leagues. For example, the following is one output for the stat "Accurate long balls per match":
```
   stat                           min_r   max_r  range  mean_r    min_p    max_p   mean_p min_significant max_significant
   <chr>                          <dbl>   <dbl>  <dbl>   <dbl>    <dbl>    <dbl>    <dbl> <lgl>           <lgl>          
 1 Accurate.long.balls.per.match -0.299   0.151  0.450  -0.0647 2.00e- 1 9.86e- 1 5.84e- 1 FALSE           FALSE          
```
which tells us that the stat "accurate long balls per match" has a decent range of r values with weak correlation across the 5 major leagues + the MLS. You can check the full table [here](output/team_stat_variability.csv) and the R file for this section [here](other_R_files/compare_leagues.R).

Of course, this itself still may not be all that interesting if the correlation is not significant. Indeed, the above statistic has a minimum p-value of 0.2 across the six leagues, so the correlation not significant. This shows us that throughout all six leagues, accurate long balls have basically shown no real evidence of a relationship with on-pitch success. 

In fact, accurate long balls per match is one of two stats which show no significance (p > 0.05) across all six leagues, along with red cards. All other stats have at least one league which shows significance. Checking the table also shows that there are thirteen stats which show significance for _all_ six leagues; most of these are stats that obviously seem to have a real relationship with success like Goal difference and xG, although there are some more interesting stats like corners and big chances missed.

In general, these thirteen significant stats also have a generally strong correlation across all leagues, so we can take them as the "obvious" correlating stats in Europe and the MLS. Let us now turn to the stats which vary in correlation and significance across the leagues. We look at the remaining 17 stats and analyze the r and p-values for each stat across each league to see which league may be an outlier. The table for this data is [here](output/league_top_variable_stats.csv). The following is a Tableau visualization of the table. This is the core deliverable of the project, distilling everything the correlation analysis was built to answer: which stats actually predict points, and where that relationship holds up (or breaks down) across leagues.
![](img/stats_correlation_1.png)
![](img/stats_correlation_2.png)
The link to the relevant Tableau dashboard is [here](https://public.tableau.com/app/profile/heechan.han/viz/Top5LeaguesMLSCorrelationBetweenStatsandSuccess/StatsvsCorrelation1).

## Interesting Observations
The visualizations give us a really good idea of the differences between the leagues, especially between the top leagues in Europe vs the MLS. Note that the first four stats (average possession, xG conceded, accurate passes per match, clearances per match) enjoy a strong correlation and significant p-value across the top 5 leagues, yet in the MLS, the correlation is moderate to weak, with a nonsignificant p-value. A few observations may help explain these differences. First, the level of play in the top 5 leagues is generally much higher compared to the MLS, and thus stats like average possession and accurate passes can more efficiently be converted to on-pitch success. In the same light, conceding more xG or having more clearances (and thus defending much more often) is more likely to be punished against higher-skilled opposition. 

Another explanation may be given by the higher existence of parity between clubs at the highest levels of Europe. In these leagues, there are often a few giants (like Barcelona and Real Madrid for La Liga or Bayern Munich for the Bundesliga) which oftentimes are outliers which may contribute greatly to the overall correlation and significance of these data points. In contrast, the MLS is relatively much more balanced due to restrictions like the salary cap, and club performances between seasons tend to vary much more regularly. 

Apart from the MLS - Europe dichotomy, there are many of the other stats that show discrepancies even within the top 5 leagues of Europe. I will mention a few which I thought were especially interesting: 
- Set-piece goals has strong correlation and significance in all leagues except for Ligue 1 and La Liga, while set-piece goals conceded have strong correlation and significance in only Ligue 1, La Liga, and Serie A. 
- Penalties awarded has strong correlation and significance in the Bundesliga, while in the Premier League, the correlation is incredibly weak (r=0.076) and nonsignificant (p=0.7644); however,  the PL has strong correlation and significance for penalties conceded, while the Bundesliga has weak correlation and nonsignificance.
- The Serie A is the only league with strong (positive) correlation and/or significance for accurate crosses; some leagues (like La Liga and the MLS) even have negative correlation (albeit with nonsignificant p-values).
- Tackles and interceptions have strong correlation and significance for the Bundesliga, but incredibly weak correlation and nonsignificance for fouls and yellow cards; the exact opposite is true for La Liga, where fouls and yellow cards show moderate to strong correlation and significance, and tackles and interceptions show weak correlation and nonsignificance.

I think it's especially interesting that many leagues seem to hold a sort of dichotomy of correlation and significance for certain related pairs of stats, like set piece goals scored vs conceded for Ligue 1 and La Liga, penalties awarded vs conceded in the PL and Bundesliga, and tackles and interceptions vs fouls and yellow cards in La Liga and Bundesliga.

## Conclusion
There seems to be several interesting stats which correlate well with success in the top leagues of Europe and in the MLS, and seeing which stat correlates well in which league is a helpful way of gauging playing style across various leagues. In particular, the MLS notably has few nontrivial stats that correlate with success. More generally, such an exercise can be done for virtually any league to figure out which stats have been found to correlate with the most success in that particular league. Of course, it is always essential to keep in mind that correlation ≠ causation. More clearances correlating with less success in a league does not automatically mean that a club should strive to only play out from the back. But this does give us clues to figure out patterns within a league that could be helpful.
