USE [covid_database];

-- Check for null values
SELECT * FROM [Corona] WHERE [Province] IS NULL;

-- If null values are present, update them to zeros for all columns
UPDATE [Corona]
SET Confirmed = ISNULL(Confirmed, 0),
Deaths = ISNULL(Deaths, 0)
WHERE Confirmed IS NULL OR Deaths IS NULL;

-- Check for total number of rows 
SELECT COUNT(*) AS total_rows FROM [Corona];

-- Check what is start date and end date
SELECT 
MIN(Date) AS start_date,
MAX(Date) AS end_date
FROM [Corona]

-- Number of month present in the dataset
SELECT COUNT(DISTINCT MONTH(Date)) AS num_months
FROM [Corona];

-- Find monthly average for confirmed, deaths, recovered
SELECT
FORMAT(Date, 'yyyy-MM') AS month,
AVG(CAST(Confirmed AS INT)) AS
monthly_average_confirmed,
AVG(CAST(Deaths AS INT)) AS
monthly_avg_deaths,
AVG(CAST(Recovered AS INT)) AS
monthly_avg_recovered
FROM
[Corona]
GROUP BY
FORMAT(Date, 'yyyy-MM')
ORDER BY
month;

-- Find most frequent value for confirmed, deaths, recovered for each month
WITH MonthlyCounts AS (
SELECT
YEAR(Date) AS year,
MONTH(Date) AS month,
Confirmed,
Deaths,
Recovered,
ROW_NUMBER()OVER (PARTITION BY YEAR(Date), MONTH(Date), Confirmed, Deaths,Recovered ORDER BY COUNT(*) DESC) AS m
FROM
[Corona]
GROUP BY YEAR(Date), Month(Date), Confirmed, Deaths, Recovered
)
SELECT
year,
month,
confirmed,
deaths,
recovered
FROM MonthlyCounts
WHERE m=1;

-- Find min values for confirmed, deaths, recovered per month

SELECT 
YEAR(Date) AS year,
MIN(confirmed) AS min_confirmed,
MIN(deaths) AS min_deaths,
MIN(recovered) AS min_recovered
FROM [Corona]
GROUP BY
YEAR(Date)
ORDER BY
YEAR(Date)ASC;


SELECT
 YEAR(Date) AS year,
 MAX(confirmed) AS max_confirmed,
 MAX(deaths) AS max_deaths,
 MAX(recovered) AS max_recovered
FROM Corona
GROUP BY YEAR(Date)
ORDER BY YEAR(Date) ASC;

SELECT
MONTH(Date) AS Month,
YEAR(Date) AS YEAR,
SUM(Confirmed) AS TotalConfirmedCases,
SUM(Deaths) AS TotalDeaths,
SUM(Recovered) AS TotalRecovered
FROM 
Corona
GROUP BY
YEAR(Date), MONTH(Date)
ORDER BY
YEAR(Date), MONTH(Date);


SELECT
 SUM(CAST(Confirmed AS INT)) AS TotalConfirmedCases,
 AVG(CAST(Confirmed AS INT)) AS AverageConfirmedCases,
 VAR(CAST(Confirmed AS INT)) AS ConfirmedCasesVariance,
 STDEV(CAST(Confirmed AS INT)) AS ConfirmedCasesStandardDeviation
FROM Corona
;


SELECT
 YEAR(Date) AS Year,
 MONTH(Date) AS Month,
 SUM(CAST(Deaths AS INT)) AS TotalDeathCases,
 AVG(CAST(Deaths AS INT)) AS AverageDeathCases,
 VAR(CAST(Deaths AS INT)) AS DeathCasesVariance,
 STDEV(CAST(Deaths AS INT)) AS DeathCaseSTDEV
FROM Corona
GROUP BY YEAR(Date), MONTH(Date)
ORDER BY Year, Month;SELECT
 YEAR(Date) AS Year,
 MONTH(Date) AS Month,
 SUM(CAST(Recovered AS INT)) AS TotalRecoveredCases,
 AVG(CAST(Recovered AS INT)) AS AverageRecoveredCases,
 VAR(CAST(Recovered AS INT)) AS RecoveredCasesVariance,
 STDEV(CAST(Recovered AS INT)) AS RecoveredCasesStandardDeviation
FROM Corona
GROUP BY YEAR(Date), MONTH(Date)
ORDER BY Year, Month;SELECT CONVERT(varchar(50),[Country_Region]) AS Country_Region,MAX(Confirmed) AS HighestConfirmedCases 
FROM [Corona]
GROUP BYCONVERT(varchar(50),[Country_Region])ORDER BY HighestConfirmedCases DESC;SELECT
 Country_Region,
 MIN(Deaths) AS LowestDeathCases
FROM Corona
GROUP BY Country_Region
ORDER BY LowestDeathCases ASC;SELECT CONVERT(varchar(50),[Country_Region]) AS Country_Region,MIN(Deaths) AS LowestDeathsCases 
FROM [Corona]
GROUP BYCONVERT(varchar(50),[Country_Region])ORDER BY LowestDeathsCases ASC;SELECT TOP 5
 Country_Region,
 SUM(TRY_CAST(REPLACE(Recovered, '/', '') AS BIGINT)) AS TotalRecoveredCases
FROM Corona
GROUP BY Country_Region
ORDER BY TotalRecoveredCases DESC;SELECT TOP 5
CONVERT(varchar(50),
[Country_Region]) AS Country_Region,
SUM(CAST(REPLACE(Recovered, ',', '') AS BIGINT)) AS 
TotalRecoveredCases
FROM
Corona
GROUP BY
CONVERT(varchar(50),
[Country_Region])
ORDER BY
TotalRecoveredCases DESC;
