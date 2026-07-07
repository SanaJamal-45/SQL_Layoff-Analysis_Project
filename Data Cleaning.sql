/* 												
										SQL DATA CLEANING PROJECT - LAYOFFS DATASET

Project Goal:
Clean a real-world layoffs dataset by removing duplicate records,
standardizing inconsistent values, handling missing data, converting
data types, and preparing the dataset for analysis.

Cleaning Process:
1. Create a staging table
2. Remove duplicate records
3. Standardize inconsistent values
4. Handle missing values
5. Remove unnecessary records
6. Remove helper columns  

STEP 1 - Explore Original Dataset
Review the raw data before making any modifications.
*/

SELECT * 
FROM layoffs;

/* 
STEP 2 - Create a Staging Table
Never clean the original dataset directly.
Instead, create a copy so the raw data remains unchanged.
*/

CREATE TABLE layoffs_staging
LIKE layoffs;

INSERT layoffs_staging
SELECT * 
FROM layoffs;

SELECT * 
FROM layoffs_staging;

/*
STEP 3 - Identify Duplicate Records

Use ROW_NUMBER() to assign a sequence number to rows that have
identical values across all important columns.

Rows with row_num > 1 are duplicates.
*/

WITH dupliacte_CTE AS
(
SELECT *, ROW_NUMBER () OVER (PARTITION BY 
company, location, industry, total_laid_off, percentage_laid_off, `date`, stage,
country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT * 
FROM dupliacte_CTE
WHERE row_num > 1;

/* 
STEP 4 - Create a Second Staging Table

A new table is created to permanently store the row numbers,
allowing duplicate records to be deleted safely.
*/

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/* 
Step 5- Insert all records while generating row numbers.
*/
INSERT INTO layoffs_staging2
SELECT *, ROW_NUMBER () OVER (PARTITION BY 
company, location, industry, total_laid_off, percentage_laid_off, `date`, stage,
country, funds_raised_millions) AS row_num
FROM layoffs_staging;

/*
STEP 6 - Remove Duplicate Records
Records with row_num greater than 1 are duplicate entries and
can safely be removed.
*/
SELECT* 
FROM layoffs_staging2
WHERE row_num > 1;

DELETE 
FROM layoffs_staging2
WHERE row_num > 1;

/*
STEP 7 - Standardize Text Values

Remove unnecessary spaces and make categorical values consistent.

This improves data quality and prevents the same category from
being treated as different values.
*/
-- Remove leading and trailing spaces from company names.
SELECT company, TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

-- Review all unique industry names.
SELECT DISTINCT industry
FROM layoffs_staging2;

-- "Crypto", "Crypto Currency", etc.
-- should all be stored as "Crypto".

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

-- Check for inconsistent country names.

SELECT DISTINCT country 
FROM layoffs_staging2
ORDER BY 1;

-- Standardize values like:
-- United States
-- United States.

SELECT *
FROM layoffs_staging2
WHERE country LIKE 'United States%';

UPDATE layoffs_staging2
SET country = 'United States'
WHERE country LIKE 'United States%';

/*
STEP 8 - Convert Date Format

The original date column is stored as text.

Convert the text into proper DATE format so SQL date functions
can be used later during analysis.
*/

SELECT `date`, STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

/*
STEP 9 - Handle Missing Values

First identify missing values, then populate them whenever
reliable information exists.
*/

SELECT * 
FROM layoffs_staging2
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

-- Empty strings are converted to NULL
-- for easier handling.

UPDATE layoffs_staging2
SET industry = null
WHERE industry = '';

/*
Some companies appear multiple times.

If one record contains the industry while another record for the
same company/location is missing it, we can populate the missing
value using a self join.
*/

SELECT t1.industry, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company = t2.company 
AND t1.location = t2.location
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company = t2.company 
AND t1.location = t2.location
SET t1.industry = t2.industry
WHERE t1.industry IS NULL 
AND t2.industry IS NOT NULL;

/*
Some records still contain NULL values because there is no
matching record available from which the missing information
can be inferred.

These values are left unchanged to avoid introducing
incorrect information.
*/

/*
STEP 10 - Remove Records with No Layoff Information

If both total_laid_off and percentage_laid_off are NULL,
the record provides no useful layoff information and is removed.
*/

DELETE 
FROM layoffs_staging2
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

select *
from layoffs_staging2;

/*
STEP 11 - Remove Helper Column

The row_num column was only required for duplicate detection
and is no longer needed.
*/

ALTER TABLE layoffs_staging2
drop column row_num;


/*Final Cleaned Dataset

The data is now:
- Duplicate-free
- Standardized
- Properly formatted
- Missing values handled where possible
- Ready for Exploratory Data Analysis (EDA)
*/

SELECT *
FROM layoffs_staging2;