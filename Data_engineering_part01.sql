create database data_engineering 
use data_engineering
/* Importing and run the following datasets */

Select * from features_dataset
Select * from sales_dataset
select * from stores_dataset

/* Start with data engineering process part 01*/
-- Profiling each datasets (Table)
-- 1.1 Check total rows
select count(*) as Total_Raws 
from features_dataset

Select count(*) as Total_Raws
from stores_dataset

Select count(*) as Total_Raws
from sales_dataset

-- 1.2 Examin the table structure 
exec sp_help 'stores_dataset'; 
exec sp_help 'sales_dataset';
exec sp_help 'features_dataset';
-- or
SELECT
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'stores_dataset';

--1.3 Checking the data range for sales dataset
select 
min(date) as start_date,
max(date) as End_date
from sales_dataset -- So the date range is '2010-02-05 till 2012-02-05'

--1.4.1 Checking the missing values | Store_dataset 
SELECT
    SUM(CASE WHEN Store IS NULL THEN 1 ELSE 0 END) AS Missing_Store,
    SUM(CASE WHEN Type IS NULL THEN 1 ELSE 0 END) AS Missing_Type,
    SUM(CASE WHEN Size IS NULL THEN 1 ELSE 0 END) AS Missing_Size
FROM Stores_dataset; 
-- Resutl | No missing values All good :)

--1.4.2 Checking the missing values | Features_dataset 
SELECT
    SUM(CASE WHEN Store IS NULL THEN 1 ELSE 0 END) AS Missing_Store,
    SUM(CASE WHEN [Date] IS NULL THEN 1 ELSE 0 END) AS Missing_Date,
    SUM(CASE WHEN Temperature IS NULL THEN 1 ELSE 0 END) AS Missing_Temperature,
    SUM(CASE WHEN Fuel_Price IS NULL THEN 1 ELSE 0 END) AS Missing_Fuel_Price,
    SUM(CASE WHEN MarkDown1 IS NULL THEN 1 ELSE 0 END) AS Missing_MD1,
    SUM(CASE WHEN MarkDown2 IS NULL THEN 1 ELSE 0 END) AS Missing_MD2,
    SUM(CASE WHEN MarkDown3 IS NULL THEN 1 ELSE 0 END) AS Missing_MD3,
    SUM(CASE WHEN MarkDown4 IS NULL THEN 1 ELSE 0 END) AS Missing_MD4,
    SUM(CASE WHEN MarkDown5 IS NULL THEN 1 ELSE 0 END) AS Missing_MD5,
    SUM(CASE WHEN CPI IS NULL THEN 1 ELSE 0 END) AS Missing_CPI,
    SUM(CASE WHEN Unemployment IS NULL THEN 1 ELSE 0 END) AS Missing_Unemployment
FROM Features_dataset;  
-- Result | Missing the following values 
/* 

| Column       | Missing Count | Action  Plan            | Percentage 
| ------------ | ------------- | ----------------------- |---------------
| Temperature  | 4             | (very small)            | 0.05%
| Fuel_Price   | 16            | (very small)            | 0.20%
| CPI          | 585           | Investigate first       | 7.14%
| Unemployment | 598           | Investigate first       | 7.30%

*/ 

-- 1.4.3 Checking the missing values | Sales_dataset 
SELECT
    SUM(CASE WHEN Store IS NULL THEN 1 ELSE 0 END) AS Missing_Store,
    SUM(CASE WHEN Dept IS NULL THEN 1 ELSE 0 END) AS Missing_Dept,
    SUM(CASE WHEN [Date] IS NULL THEN 1 ELSE 0 END) AS Missing_Date,
    SUM(CASE WHEN Weekly_Sales IS NULL THEN 1 ELSE 0 END) AS Missing_Sales
FROM Sales_dataset;
-- Result | Missing the following values 
/*
| Column        | Missing Count | Action  Plan            | Percentage 
| ------------- | ------------- | ----------------------- |---------------
| Missing_sales | 1285          | Investigate             | 0.3%
*/

/* Before we do futher data engineering we need to do investigate is to where the missing values occur
A) For Features_datasets | At first we check whether the missing values are concetrated in specific year */

SELECT
    YEAR([Date]) AS YearNo,
    COUNT(*) AS Records,
    SUM(CASE WHEN CPI IS NULL THEN 1 ELSE 0 END) AS Missing_CPI,
    SUM(CASE WHEN Unemployment IS NULL THEN 1 ELSE 0 END) AS Missing_Unemployment
FROM Features_dataset
GROUP BY YEAR([Date])
ORDER BY YearNo;
-- Following year 2013 have some missing values 
/*
YearNo |	Records	| Missing_CPI |	Missing_Unemployment
2010	    2160	    0	        0
2011	    2340	    0	        0
2012	    2340	    0	        13
2013	    1350	    585	        585
*/
-- B) For Sales_datasets | At first we check whether the missing values are concetrated in specific year */
--select * from sales_dataset
SELECT
    YEAR([Date]) AS YearNo,
    COUNT(*) AS Records,
    SUM(CASE WHEN weekly_sales IS NULL THEN 1 ELSE 0 END) AS Missing_WeeklySales,
    SUM(CASE WHEN IsHoliday IS NULL THEN 1 ELSE 0 END) AS Missing_Holiday
FROM Sales_dataset
GROUP BY YEAR([Date])
ORDER BY YearNo;

-- Following are the result
/*
YearNo	|   Records	|   Missing_WeeklySales	|   Missing_Holiday
2010	    140679	    390             	    0
2011	    153453	    483	                    0
2012	    127438	    412	                    0
*/

-- 1.5 Checking of Duplicate keys 
-- 1.5.1 Stores_dataset
SELECT
    Store,
    COUNT(*) AS Records
FROM Stores_dataset
GROUP BY Store
HAVING COUNT(*) > 1;

-- 1.5.2 Feature_dataset
SELECT
    Store,
    [Date],
    COUNT(*) AS Records
FROM Features_dataset
GROUP BY Store, [Date]
HAVING COUNT(*) > 1;

-- 1.5.3 sales_datasets
SELECT 
    store,
    dept,
    [date],
    count(*) as Records
FROM SALES_DATASET
GROUP BY store, dept, [date]
HAVING COUNT(*)>0;
-- Result | Non of record found as duplicate

-- 1.6 Check Distinct Counts 
-- Stores
SELECT COUNT(DISTINCT Store) AS Total_Stores
FROM Stores_dataset; -- 45
-- Departments 
SELECT COUNT(DISTINCT dept) AS Total_Departments
FROM Sales_dataset; --81

-- 1.7 Investigate Markdown Availability

SELECT
    YEAR([Date]) AS Year_No,
    COUNT(*) AS Total_Records,
    COUNT(MarkDown1) AS MD1_Available
FROM Features_dataset
GROUP BY YEAR([Date])
ORDER BY Year_No;
