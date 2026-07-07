# SQL_Layoff-Analysis_Project

# SQL Data Cleaning & Exploratory Data Analysis (EDA) – World Layoffs Dataset

## Project Overview

This project demonstrates an end-to-end SQL data analysis workflow using a real-world layoffs dataset. The project is divided into two major phases:

1. **Data Cleaning** – Preparing the raw dataset by removing inconsistencies, handling missing values, and ensuring data quality.
2. **Exploratory Data Analysis (EDA)** – Analyzing the cleaned dataset to uncover trends, patterns, and business insights related to global layoffs.

The project was completed using **MySQL**, utilizing SQL features such as Common Table Expressions (CTEs), Window Functions, Aggregate Functions, String Functions, Date Functions, Joins, and Data Definition Language (DDL) commands.


## Dataset

The dataset contains information about company layoffs, including:

* Company
* Location
* Industry
* Total Employees Laid Off
* Percentage of Workforce Laid Off
* Date
* Company Stage
* Country
* Funds Raised (Millions)

# Part 1: Data Cleaning

## Objective

The objective of this phase was to transform the raw dataset into a clean, reliable, and analysis-ready dataset by eliminating data quality issues.

## Data Cleaning Process

### 1. Created a Staging Table

* Created a copy of the original dataset to preserve the raw data.
* Performed all cleaning operations on the staging tables instead of modifying the original data.

### 2. Removed Duplicate Records

* Identified duplicate rows using the `ROW_NUMBER()` window function.
* Assigned row numbers to duplicate records.
* Removed duplicate entries while preserving one unique record.

### 3. Standardized Data

Improved data consistency by:

* Removing leading and trailing spaces from company names.
* Standardizing industry names (e.g., converting all Crypto-related values to **Crypto**).
* Standardizing country names (e.g., converting **United States.** to **United States**).
* Converting the `date` column from text format to the SQL `DATE` data type.

### 4. Handled Missing Values

* Converted blank values into `NULL`.
* Populated missing industry values using existing records for the same company and location through a self-join.
* Identified records where missing values could not be reliably inferred.

### 5. Removed Invalid Records

* Deleted rows where both `total_laid_off` and `percentage_laid_off` were missing because they contained no meaningful layoff information.

### 6. Final Cleanup

* Removed helper columns used during duplicate detection.
* Produced a clean dataset ready for analysis.

# Part 2: Exploratory Data Analysis (EDA)

## Objective

After cleaning the dataset, exploratory data analysis was performed to identify trends, compare companies and industries, and understand the overall impact of layoffs across different dimensions.

## Analysis Performed

### Overall Layoff Statistics

* Identified the largest layoff event.
* Found the highest layoff percentage recorded.

### Companies with Complete Layoffs

* Identified companies that laid off 100% of their workforce.
* Compared these companies based on funding raised.

### Company Analysis

* Calculated total layoffs by company.
* Ranked companies according to total employees laid off.

### Time-Based Analysis

* Determined the time range covered by the dataset.
* Analyzed yearly layoff trends.
* Examined monthly layoffs.
* Calculated rolling cumulative layoffs over time using window functions.

### Industry Analysis

* Compared layoffs across industries.
* Identified industries most affected by workforce reductions.

### Geographic Analysis

* Compared total layoffs across countries.

### Business Stage Analysis

* Analyzed layoffs by company growth stage (Startup, Series A, IPO, etc.).

### Company Rankings

* Ranked companies by layoffs for each year using the `DENSE_RANK()` window function.
* Identified the Top 5 companies with the highest layoffs annually.

### Key Insights 

* The largest single layoff event affected 12,000 employees.
* The United States recorded the highest total layoffs.
* The Consumer and Retail industries experienced significant
  workforce reductions.
* Layoffs peaked during 2023.
* Several well-funded companies still laid off 100% of their
  employees, highlighting that high funding does not guarantee
  business sustainability.

# SQL Concepts Demonstrated

* SELECT Statements
* WHERE, GROUP BY, ORDER BY
* Aggregate Functions (`SUM`, `MAX`, `MIN`)
* String Functions (`TRIM`, `SUBSTR`)
* Date Functions (`STR_TO_DATE`, `YEAR`)
* Window Functions (`ROW_NUMBER`, `DENSE_RANK`, Rolling SUM)
* Common Table Expressions (CTEs)
* Self Joins
* Data Cleaning Techniques
* Data Type Conversion
* ALTER TABLE
* DELETE & UPDATE Statements

# Skills Demonstrated

* SQL Data Cleaning
* Data Transformation
* Data Validation
* Exploratory Data Analysis (EDA)
* Window Functions
* Data Aggregation
* Trend Analysis
* Business Insight Generation
* Relational Database Management
* MySQL

# Project Outcome

This project demonstrates a complete SQL workflow—from cleaning raw data to generating meaningful business insights. It showcases practical data preparation techniques, analytical SQL queries, and the ability to transform messy datasets into reliable information for decision-making.


The final cleaned dataset is suitable for further visualization in tools such as Power BI or Tableau and can serve as a foundation for advanced analytics.
