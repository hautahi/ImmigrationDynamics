# ImmigrationDynamics

This repository contains the programs required to produce the results contained in the article
[The Dynamic Effects of Immigration](http://hautahikingi.com/docs/ImmigrationDynamics_Kingi.pdf).

## Contents

* The `Model` directory contains the Matlab programs used to solve and simulate the theoretical model, which is executed from the `main.m` file. 

* The `Data` directory contains the Stata and R programs used to analyze data and calculate statistics required to calibrate the theoretical model

  - The `CPS` directory contains the analysis of  the Current Population Survey data. To replicate the analysis, you first need to add the raw data downloaded from IPUMS into the `raw_ipums` directory, which can be obtained by emailing me. (At 2.5GB, it's too big to include here). You then run the Stata do files in their order.
  - The `SIPP` directory contains the analysis of the Survey of Income and Program Participation data. Running the `1.2008 panel - download and create database.R` file downloads and creates the required database. The `2.calculations.R` file then computes the required wealth shares.

