# Data repository for modelling of COVID19 in Pennsylvania

This repository includes useful resources to model COVID19 cases in Pennsylvania (at county level). We collect sources of both cases, testing, policy, mobility and
other potential predictors.

## Sources

### Spatial Data

- County boundaries - PA Department of Transportation 2020, via [Pennsylvania Spatial Data Access (PASDA)](https://www.pasda.psu.edu/uci/DataSummary.aspx?dataset=24)

- Hospital locations via PASDA

- Nursing home locations via PASDA

### Cases

- COVID-19 case data for PA by county via John's Hopkins University.  County cases for all of US found on [JHU github](https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_US.csv)


### Covariates

- Census Demographics found [here](https://www.census.gov/content/census/en/data/datasets/time-series/demo/popest/2010s-counties-detail.html)

- Survey of mask use by county during the month of July 2020, via the [New York Times](https://github.com/nytimes/covid-19-data/tree/master/mask-use)

### Mobility

- Descartes Labs cellphone mobility data: m50 - The median of the max-distance mobility for all samples in a county; m50_index - The percent of normal m50 in county, normalized to February 2020.  [Descartes Labs github](https://raw.githubusercontent.com/descarteslabs/DL-COVID-19/master/DL-us-m50_index.csv)

### Policy
