select * from Features_dataset
select * from sales_dataset
select * from stores_dataset

/* Start with data engineering part 03 */
-- 4.1 Creations / validation of inegrated fact table for PowerBI dashbaord 

SELECT

    s.Store,
    s.Dept,
    s.[Date],
    s.Weekly_Sales,

    st.Type,
    st.Size,

    f.Temperature,
    f.Fuel_Price,

    f.MarkDown1,
    f.MarkDown2,
    f.MarkDown3,
    f.MarkDown4,
    f.MarkDown5,

    f.CPI,
    f.Unemployment,

    s.IsHoliday

INTO fact_weekly_sales

FROM sales_dataset s

LEFT JOIN Features_dataset f
       ON s.Store = f.Store
      AND s.[Date] = f.[Date]

LEFT JOIN stores_dataset st
       ON s.Store = st.Store;
-- Check if the table is created correctly 

Select * from fact_weekly_sales

-- 4.2.1 Test | Validation of Join shold be equial 
select count(*) as sales_raw
from sales_dataset -- 421570 

select count(*) as Sales_raw
from fact_weekly_sales -- 421570 | Correct

-- 4.2.2 Test | Missing store information should be 0 
SELECT COUNT(*) AS MissingStoreAttributes
FROM fact_weekly_sales
WHERE Type IS NULL; -- 0 | Correct

-- 4.2.3 Test | Missing Feature information sould be Zero or very low
SELECT COUNT(*) AS MissingFeatures
FROM fact_weekly_sales
WHERE Temperature IS NULL; -- 69 | very low we consider as Correct


-- 4.2.4 Test | Sales raw without a matching features records should be 0
SELECT COUNT(*) AS OrphanSalesRows
FROM sales_dataset s
LEFT JOIN Features_dataset f
       ON s.Store = f.Store
      AND s.[Date] = f.[Date]
WHERE f.Store IS NULL; -- 0 | Correct

-- 4.2.5 Test | Sales Total validation should be equal 
SELECT
    SUM(Weekly_Sales) AS OriginalSales
FROM sales_dataset; -- 6737307147.77974

SELECT
    SUM(Weekly_Sales) AS FactSales
FROM fact_weekly_sales -- 6737307147.77975 | Correct

-- 4.2.6 Test | Final test to check newly created table count is >1 

SELECT
    Store,
    Dept,
    [Date],
    COUNT(*) AS Records
FROM fact_weekly_sales
GROUP BY
    Store,
    Dept,
    [Date]
HAVING COUNT(*) > 1;