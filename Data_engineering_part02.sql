select * from Features_dataset
select * from sales_dataset
select * from stores_dataset

/* Start with data engineering part 02 */
--1.1 Verifying Date data type (check if the date already stored correctly)
SELECT
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'Sales_dataset'
AND COLUMN_NAME = 'Date';

SELECT
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'Features_dataset'
AND COLUMN_NAME = 'Date';

-- 2.1 Validating key Uniqueness 

SELECT
    COUNT(*) AS TotalRows,
    COUNT(DISTINCT CONCAT(Store,'_',CONVERT(VARCHAR,[Date],23))) AS UniqueRows
FROM Features_dataset;

SELECT
    COUNT(*) AS TotalRows,
    COUNT(DISTINCT CONCAT(Store,'_',CONVERT(VARCHAR,[Date],23))) AS UniqueRows
FROM sales_dataset;

SELECT
    COUNT(*) AS TotalRows,
    COUNT(DISTINCT CONCAT(Store,'_',Dept,'_',CONVERT(VARCHAR,[Date],23))) AS UniqueRows
FROM sales_dataset;
