# Retail Sales & Holiday Impact Analysis

## Project Overview

This project analyzes historical retail sales data from 45 stores across multiple departments to identify the drivers of sales performance, evaluate the impact of promotional markdowns, and understand holiday sales behavior.

The analysis was conducted using **SQL Server** for data **engineering and preparation**, and **Power BI** for data modeling, visualization, and business insight generation.

---

## Dataset

The project uses three source tables:

### Stores

Contains store-level information:

* Store
* Store Type
* Store Size

### Features

Contains weekly store-level attributes:

* Temperature
* Fuel Price
* CPI
* Unemployment
* MarkDown1–5
* IsHoliday

### Sales

Contains weekly sales transactions:

* Store
* Department
* Date
* Weekly Sales
* IsHoliday

---

## Data Engineering & Data Quality Assessment

Before analysis, a complete data quality assessment was performed in SQL Server:

* Validated row counts and date ranges
* Checked for duplicate records
* Verified business keys and table grain
* Investigated missing values
* Validated table joins before modeling

### Key Business Decisions

During profiling, missing values were identified in several fields:

| Field           | Missing Records            |
| --------------- | -------------------------- |
| Temperature     | 4                          |
| Fuel Price      | 16                         |
| CPI             | 585                        |
| Unemployment    | 598                        |
| MarkDown Fields | Significant missing values |

Analysis showed that markdown data was unavailable for parts of the historical period due to data collection and system limitations rather than representing zero promotional activity.

Therefore:

* Missing Markdown values were retained as NULLs in the fact table.
* NULL Markdown values were **not treated as zero**, preventing misleading promotion analysis.
* CPI and Unemployment NULL values were documented and preserved to maintain data integrity.
* Temperature and Fuel Price missing values were considered immaterial due to low occurrence.

---

## Data Model

A star schema was designed for Power BI.

### Fact Table

The **fact_weekly_sales** was created after data engineering and analysis.

Contains:

* Store
* Department
* Date
* Weekly Sales
* Holiday Flag
* MarkDown1–5
* CPI
* Unemployment
* Temperature
* Fuel Price

### Dimension Tables

* DimDate
* DimStore
* DimDept

This structure supports scalable reporting, time intelligence calculations, and future forecasting models.

---

## Business Questions Addressed

### 1. Which stores drive holiday sales performance?

* Holiday sales contribution by store
* Holiday lift percentage by store
* Store ranking during holiday periods

### 2. Which departments respond to markdowns?

* Sales during markdown periods
* Markdown efficiency analysis
* Department-level promotion performance

### 3. Is holiday uplift consistent across store types?

* Comparison of holiday performance across store categories
* Holiday vs non-holiday sales analysis

### 4. Which stores are macro-sensitive?

* Impact of CPI and unemployment on sales
* Identification of economically sensitive stores

---

## Tools Used

* SQL Server
* Power BI
* DAX
* Data Modeling
* Data Quality Assessment
* Business Intelligence

---

## Key Skills Demonstrated

* Data Cleaning & Validation
* Data Quality Assessment
* SQL Querying
* Star Schema Design
* Dimensional Modeling
* DAX Measures
* Business Analysis
* Retail Analytics
* Dashboard Development
* Insight Generation

---

## Dashboard Features

* Executive KPI Overview
* Weekly Sales Trend Analysis
* Holiday Performance Analysis
* Markdown Effectiveness Analysis
* Store Performance Ranking
* Macroeconomic Impact Analysis
* Interactive Filtering and Drill-down Capabilities

---

## Outcome

The project transformed raw retail transaction data into an analytical model capable of supporting strategic decisions around promotions, holiday planning, store performance evaluation, and future sales forecasting.
