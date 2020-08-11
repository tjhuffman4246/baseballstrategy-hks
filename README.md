# HKS Baseball Strategy

A collection of research on the evolution of MLB strategy, particularly sacrifice bunt and stolen base attempts. Some material presented at the 2020 MIT Sloan Sports Analytics Conference by Nobel Prize-winning economist Dr. Richard Thaler of the University of Chicago. Other components remain in-progress.

## Code

Two R files for research. `THuffman_BuntSBResearch.R` contains code for simple data summary graphs, as well as the more detailed charts on baseball's strategic shifts. `THuffman_RETables.R` contains some unused code for win probability and instead creates some run expectancy and win probability tables.

## Data

`AllData.csv` is the most important file of the three and contains relevant information of sacrifice bunt and stolen base attempts since 1974. The other two files are used in `THuffman_RETables.R` for construct RE and WP tables. Within this folder is the subfolder `Full`, which contains play-by-play data since 1974, as well as yearly rosters.

## Plots

Assorted plots from `THuffman_BuntSBResearch.R`. The two used at SSAC20 are `SacBunts_Final.pdf` and `SB_Revised.pdf`.

## SUDDEN DEATH AVERSION.pdf

Dr. Thaler's 2000 paper on the tendency of coaches in professional sports to avoid the immediate high-risk scenario in favor of a delayed decision point that brings lessened possibility of success.

## Tables

Run expectancy and win probability tables, constructed using the `gt` package and information from Baseball Prospectus and FanGraphs. 