# Driving Business Decisions with SQL: U.S. Superstore Sales Analysis

## Overview

This project uses **MySQL** to analyze U.S. Superstore transaction data and answer business questions related to sales performance, customer behavior, product demand, regional performance, shipping, and sales trends.

The project goes beyond basic aggregation by using **CTEs, window functions, ranking functions, `CASE` expressions, date functions, and SQL views** to turn transaction-level data into actionable business insights.

## Business Questions

The analysis addresses questions such as:

1. Which regions and states generate the most sales?
2. Which product categories and sub-categories drive revenue?
3. Who are the highest-value customers?
4. How has sales performance changed over time?
5. Are there recurring seasonal sales patterns?
6. Which products perform best within their categories?
7. How does shipping performance vary by shipping mode?
8. How can customers be grouped into useful value tiers?

## Tools

- **MySQL**
- Aggregate functions
- `CASE` expressions
- Common Table Expressions (CTEs)
- Window functions
- `DENSE_RANK()`
- `LAG()`
- Date functions
- SQL views

## Data

The dataset contains **9,800 transaction-line records** from a U.S. Superstore, covering sales activity from **2015 through 2018**.

It includes:

- 4,922 unique orders
- 793 customers
- 1,861 products
- customer and geographic information
- product categories and sub-categories
- order and shipping dates
- shipping modes
- sales values

An important distinction in this analysis is that each row represents a **product line within an order**. Therefore, `COUNT(*)` represents transaction lines, while `COUNT(DISTINCT Order_ID)` is used when measuring unique orders.

The dataset is stored in:

```text
data/superstore_sales.csv
```

Additional information is available in [`data/README.md`](data/README.md).

## Analysis Workflow

### 1. Data Validation

The analysis begins by checking:

- total records
- unique customers
- unique products
- unique orders
- missing values
- duplicate row identifiers

This establishes the structure and quality of the imported data before analysis.

### 2. Sales Performance

Sales are analyzed across:

- regions
- states
- customer segments
- product categories
- product sub-categories

Window functions are also used to calculate each group's contribution to total sales.

### 3. Customer Analysis

Customer-level analysis includes:

- unique order counts
- lifetime sales
- average order value
- customer sales ranking
- customer value tiers

A reusable customer summary view is also created for future analysis.

### 4. Product Analysis

The project identifies:

- highest-selling categories
- highest-selling sub-categories
- top products by sales
- top-performing products within each category

Ranking functions are used to compare products within their respective groups.

### 5. Regional Performance

Sales are compared across regions and states.

The analysis also ranks product categories within each region to show how product performance varies geographically.

### 6. Sales Trends

Date functions and window functions are used to examine:

- annual sales
- monthly sales
- year-over-year growth
- cumulative revenue
- month-of-year seasonality

`LAG()` is used to compare each year's sales with the previous year.

### 7. Shipping Performance

Average, minimum, and maximum shipping times are calculated for each shipping mode using the difference between order and shipping dates.

## SQL Techniques Demonstrated

### Common Table Expressions

```sql
WITH yearly_sales AS (
    SELECT
        YEAR(Order_Date) AS order_year,
        SUM(Sales) AS total_sales
    FROM superstore_sales
    GROUP BY YEAR(Order_Date)
)
```

### Window Functions

```sql
SUM(monthly_revenue) OVER (
    ORDER BY sales_month
)
```

### Year-over-Year Analysis

```sql
LAG(total_sales) OVER (
    ORDER BY order_year
)
```

### Ranking

```sql
DENSE_RANK() OVER (
    PARTITION BY Category
    ORDER BY total_sales DESC
)
```

### Customer Segmentation

```sql
CASE
    WHEN lifetime_sales >= 10000 THEN 'High Value'
    WHEN lifetime_sales >= 5000 THEN 'Medium Value'
    ELSE 'Standard'
END
```

### Reusable Views

```sql
CREATE OR REPLACE VIEW customer_sales_summary AS
SELECT
    Customer_ID,
    Customer_Name,
    Segment,
    COUNT(DISTINCT Order_ID) AS unique_orders,
    SUM(Sales) AS lifetime_sales
FROM superstore_sales
GROUP BY
    Customer_ID,
    Customer_Name,
    Segment;
```

## Key Analytical Themes

The analysis focuses on turning transactional data into information that could support business decisions in areas such as:

- customer prioritization
- regional strategy
- product performance
- sales monitoring
- seasonal planning
- shipping evaluation

The project also distinguishes carefully between **transaction-line activity** and **unique orders**, avoiding the assumption that every row represents a separate customer order.

## Repository Structure

```text
superstore-sales-sql-analysis/
├── data/
│   ├── README.md
│   └── superstore_sales.csv
├── sql/
│   ├── README.md
│   └── superstore_sales_analysis.sql
├── LICENSE
└── README.md
```

## Reproducing the Analysis

1. Create a MySQL database.
2. Import `data/superstore_sales.csv` into a table named:

```text
superstore_sales
```

3. Ensure the order and shipping date fields are imported as date-compatible values.
4. Open:

```text
sql/superstore_sales_analysis.sql
```

5. Run the queries using MySQL Workbench or another MySQL-compatible environment.

The SQL script is divided into clearly labeled sections so individual analyses can be run independently.

## Improvements from the Original Analysis

This repository contains a refined version of the analysis originally published on my portfolio website.

The GitHub version makes a clearer distinction between transaction-line records and unique customer orders. It also organizes the analysis into a reproducible SQL workflow and demonstrates additional techniques including CTEs, window functions, ranking, running totals, year-over-year comparisons, and reusable views.

## Portfolio Article

A detailed write-up of the project is available on my portfolio:

https://tobiadenola.com/driving-business-decisions-with-sql-an-sql-analysis-of-u-s-superstore-sales/

## Author

**Oluwatobiloba Adenola**

Portfolio: https://tobiadenola.com/
