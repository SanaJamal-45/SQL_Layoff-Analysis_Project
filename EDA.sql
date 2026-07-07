/*
						EXPLORATORY DATA ANALYSIS (EDA)
							WORLD LAYOFFS DATASET
                            
Project Goal:
Explore the cleaned layoffs dataset to identify trends,
patterns, and business insights regarding workforce reductions
across companies, industries, countries, and time.

Analysis Objectives:
1. Understand the scale of layoffs
2. Identify companies with the largest layoffs
3. Analyze layoffs by industry and country
4. Explore yearly and monthly layoff trends
5. Calculate cumulative layoffs over time
6. Identify top companies with the highest layoffs each year
*/

/*
STEP 1 - Preview the Cleaned Dataset
Verify that the cleaned dataset is ready for analysis.
*/
SELECT *
FROM layoffs_staging2;

/*
STEP 2 - Find the Largest Layoff Event
Identify the maximum number of employees laid off in a single
event and determine the highest layoff percentage recorded.
*/

SELECT MAX(total_laid_off)  AS highest_layoffs, 
MAX(percentage_laid_off) AS highest_percentage
FROM layoffs_staging2;

/*
STEP 3 - Companies with 100% Workforce Layoffs
Identify companies that laid off their entire workforce
(percentage_laid_off = 1) and rank them by the number of
employees affected.
*/

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

/*
STEP 4 - Funding Raised by Companies that Shut Down
Analyze how much funding these companies had raised before
laying off their entire workforce.
*/

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

/*
STEP 5 - Total Layoffs by Company
Calculate the total number of employees laid off by each
company to identify those most affected.
*/

SELECT company, SUM(total_laid_off) AS total_layoffs
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

/*
STEP 6 - Determine the Dataset Time Period
Find the earliest and latest dates available to understand
the analysis period.
*/

SELECT MIN(`date`) AS first_record, MAX(`date`) AS last_record
FROM layoffs_staging2;

/*
STEP 7 - Layoffs by Industry
Analyze which industries experienced the highest number
of layoffs.
*/

SELECT industry, SUM(total_laid_off) AS total_layoffs
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

/*
STEP 8 - Layoffs by Country
Compare the total layoffs across different countries.
*/

SELECT country, SUM(total_laid_off) AS total_layoffs
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

/*
STEP 9 - Yearly Layoff Trend
Analyze how layoffs changed over different years.
*/

SELECT YEAR(`date`)  AS layoff_year, 
SUM(total_laid_off) AS total_layoffs
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

/*
STEP 10 - Layoffs by Company Growth Stage
Evaluate which business stages (Startup, Series A, IPO, etc.)
experienced the largest workforce reductions.
*/

SELECT stage, SUM(total_laid_off) AS total_layoffs
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

/*
STEP 11 - Monthly Layoff Trend
Aggregate layoffs by month to identify changes and seasonal
patterns over time.
*/

SELECT SUBSTR(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS total_layoffs
FROM layoffs_staging2
WHERE SUBSTR(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;

/*
STEP 12 - Rolling Total of Layoffs
Calculate the cumulative number of layoffs over time using
a window function to observe the overall trend.
*/

WITH ROLLING_TOTAL AS
(
SELECT SUBSTR(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS total_layoffs
FROM layoffs_staging2
WHERE SUBSTR(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`, total_layoffs, 
SUM(total_layoffs) OVER (ORDER BY `MONTH`) AS rolling_total
FROM ROLLING_TOTAL;

/*
STEP 13 - Company Layoffs by Year
Calculate yearly layoffs for each company to compare
their workforce reductions over time.
*/

SELECT company, YEAR(`date`)  AS layoff_year, 
SUM(total_laid_off) AS total_layoffs
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

/*
STEP 14 - Top 5 Companies with the Most Layoffs Each Year
Use Common Table Expressions (CTEs) and the DENSE_RANK()
window function to rank companies based on yearly layoffs.
This identifies the top five companies with the highest
number of layoffs in each year.
*/

WITH company_year (company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
), Company_Rank_Year AS 
(
SELECT *, 
DENSE_RANK() OVER (partition by years ORDER BY total_laid_off DESC) AS RANKING
FROM company_year
WHERE years IS NOT NULL
)
SELECT * 
FROM Company_Rank_Year
WHERE Ranking <=5; 


/*
							KEY INSIGHTS

• The largest single layoff event affected 12,000 employees.
• The United States recorded the highest total layoffs.
• The Consumer and Retail industries experienced significant
  workforce reductions.
• Layoffs peaked during 2023.
• Several well-funded companies still laid off 100% of their
  employees, highlighting that high funding does not guarantee
  business sustainability.
  */

