-- ============================================================
-- U.S. SUPERSTORE SALES ANALYSIS
-- SQL PORTFOLIO PROJECT
-- Database: MySQL
-- ============================================================

-- This project analyzes customer behavior, regional performance,
-- product demand, shipping patterns, and sales trends using
-- transactional data from a U.S. Superstore.


-- ============================================================
-- 1. DATABASE SETUP
-- ============================================================

CREATE DATABASE IF NOT EXISTS superstore;

USE superstore;


-- ============================================================
-- 2. PREVIEW THE DATA
-- ============================================================

SELECT *
FROM superstore_sales
LIMIT 10;


-- ============================================================
-- 3. DATA VALIDATION
-- ============================================================

SELECT
    COUNT(*) AS total_rows
FROM superstore_sales;


SELECT
    COUNT(DISTINCT Customer_ID) AS customers,
    COUNT(DISTINCT Product_ID) AS products,
    COUNT(DISTINCT Order_ID) AS orders,
    COUNT(DISTINCT State) AS states,
    COUNT(DISTINCT City) AS cities
FROM superstore_sales;


-- ============================================================
-- 4. CHECK MISSING VALUES
-- ============================================================

SELECT
    SUM(Customer_ID IS NULL) AS missing_customers,
    SUM(Product_ID IS NULL) AS missing_products,
    SUM(Postal_Code IS NULL) AS missing_postal_codes,
    SUM(Sales IS NULL) AS missing_sales
FROM superstore_sales;


-- ============================================================
-- 5. CHECK DUPLICATE ROW IDS
-- ============================================================

SELECT
    Row_ID,
    COUNT(*) AS duplicate_count
FROM superstore_sales
GROUP BY Row_ID
HAVING COUNT(*) > 1;


-- ============================================================
-- 6. CUSTOMER SEGMENT ACTIVITY
-- ============================================================

SELECT
    Segment,
    COUNT(*) AS transaction_lines,
    COUNT(DISTINCT Order_ID) AS unique_orders
FROM superstore_sales
GROUP BY Segment
ORDER BY transaction_lines DESC;


-- ============================================================
-- 7. REGIONAL ACTIVITY
-- ============================================================

SELECT
    Region,
    COUNT(*) AS transaction_lines,
    COUNT(DISTINCT Order_ID) AS unique_orders
FROM superstore_sales
GROUP BY Region
ORDER BY transaction_lines DESC;


-- ============================================================
-- 8. TOP STATES BY ACTIVITY
-- ============================================================

SELECT
    State,
    COUNT(*) AS transaction_lines,
    COUNT(DISTINCT Order_ID) AS unique_orders
FROM superstore_sales
GROUP BY State
ORDER BY transaction_lines DESC
LIMIT 10;


-- ============================================================
-- 9. PRODUCT CATEGORY DEMAND
-- ============================================================

SELECT
    Category,
    COUNT(*) AS transaction_lines,
    COUNT(DISTINCT Order_ID) AS unique_orders
FROM superstore_sales
GROUP BY Category
ORDER BY transaction_lines DESC;


-- ============================================================
-- 10. TOP SUB-CATEGORIES BY DEMAND
-- ============================================================

SELECT
    Sub_Category,
    COUNT(*) AS transaction_lines,
    COUNT(DISTINCT Order_ID) AS unique_orders
FROM superstore_sales
GROUP BY Sub_Category
ORDER BY transaction_lines DESC
LIMIT 10;


-- ============================================================
-- 11. SHIPPING MODE
-- ============================================================

SELECT
    Ship_Mode,
    COUNT(*) AS transaction_lines,
    COUNT(DISTINCT Order_ID) AS unique_orders
FROM superstore_sales
GROUP BY Ship_Mode
ORDER BY transaction_lines DESC;


-- ============================================================
-- 12. ANNUAL ORDER ACTIVITY
-- ============================================================

SELECT
    YEAR(Order_Date) AS order_year,
    COUNT(DISTINCT Order_ID) AS unique_orders
FROM superstore_sales
GROUP BY YEAR(Order_Date)
ORDER BY order_year;


-- ============================================================
-- 13. MONTHLY ORDER ACTIVITY
-- ============================================================

SELECT
    MONTH(Order_Date) AS month_number,
    MONTHNAME(Order_Date) AS month_name,
    COUNT(DISTINCT Order_ID) AS unique_orders
FROM superstore_sales
GROUP BY
    MONTH(Order_Date),
    MONTHNAME(Order_Date)
ORDER BY month_number;


-- ============================================================
-- 14. MOST ACTIVE CUSTOMERS
-- ============================================================

SELECT
    Customer_Name,
    COUNT(DISTINCT Order_ID) AS unique_orders,
    COUNT(*) AS transaction_lines
FROM superstore_sales
GROUP BY Customer_Name
ORDER BY unique_orders DESC
LIMIT 10;


-- ============================================================
-- 15. TOTAL SALES
-- ============================================================

SELECT
    ROUND(SUM(Sales), 2) AS total_sales
FROM superstore_sales;


-- ============================================================
-- 16. SALES BY REGION
-- ============================================================

SELECT
    Region,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(
        100 * SUM(Sales) /
        SUM(SUM(Sales)) OVER (),
        2
    ) AS pct_of_total_sales
FROM superstore_sales
GROUP BY Region
ORDER BY total_sales DESC;


-- ============================================================
-- 17. TOP STATES BY SALES
-- ============================================================

SELECT
    State,
    ROUND(SUM(Sales), 2) AS total_sales
FROM superstore_sales
GROUP BY State
ORDER BY total_sales DESC
LIMIT 10;


-- ============================================================
-- 18. SALES BY CUSTOMER SEGMENT
-- ============================================================

SELECT
    Segment,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(AVG(Sales), 2) AS avg_transaction_line_sales,
    ROUND(
        100 * SUM(Sales) /
        SUM(SUM(Sales)) OVER (),
        2
    ) AS pct_of_total_sales
FROM superstore_sales
GROUP BY Segment
ORDER BY total_sales DESC;


-- ============================================================
-- 19. SALES BY PRODUCT CATEGORY
-- ============================================================

SELECT
    Category,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(
        100 * SUM(Sales) /
        SUM(SUM(Sales)) OVER (),
        2
    ) AS pct_of_total_sales
FROM superstore_sales
GROUP BY Category
ORDER BY total_sales DESC;


-- ============================================================
-- 20. TOP SUB-CATEGORIES BY SALES
-- ============================================================

SELECT
    Sub_Category,
    ROUND(SUM(Sales), 2) AS total_sales
FROM superstore_sales
GROUP BY Sub_Category
ORDER BY total_sales DESC
LIMIT 10;


-- ============================================================
-- 21. TOP PRODUCTS BY SALES
-- ============================================================

SELECT
    Product_Name,
    ROUND(SUM(Sales), 2) AS total_sales,
    COUNT(DISTINCT Order_ID) AS unique_orders
FROM superstore_sales
GROUP BY Product_Name
ORDER BY total_sales DESC
LIMIT 10;


-- ============================================================
-- 22. AVERAGE ORDER VALUE
-- ============================================================

SELECT
    ROUND(
        SUM(Sales) /
        COUNT(DISTINCT Order_ID),
        2
    ) AS average_order_value
FROM superstore_sales;


-- ============================================================
-- 23. CUSTOMER LIFETIME SALES
-- ============================================================

SELECT
    Customer_ID,
    Customer_Name,
    ROUND(SUM(Sales), 2) AS lifetime_sales,
    COUNT(DISTINCT Order_ID) AS unique_orders
FROM superstore_sales
GROUP BY
    Customer_ID,
    Customer_Name
ORDER BY lifetime_sales DESC
LIMIT 10;


-- ============================================================
-- 24. CUSTOMER SALES RANKING
-- Demonstrates CTE + DENSE_RANK
-- ============================================================

WITH customer_sales AS (
    SELECT
        Customer_ID,
        Customer_Name,
        SUM(Sales) AS lifetime_sales,
        COUNT(DISTINCT Order_ID) AS unique_orders
    FROM superstore_sales
    GROUP BY
        Customer_ID,
        Customer_Name
)

SELECT
    Customer_ID,
    Customer_Name,
    ROUND(lifetime_sales, 2) AS lifetime_sales,
    unique_orders,
    DENSE_RANK() OVER (
        ORDER BY lifetime_sales DESC
    ) AS customer_rank
FROM customer_sales
ORDER BY customer_rank;


-- ============================================================
-- 25. CUSTOMER VALUE TIERS
-- Demonstrates CASE
-- ============================================================

WITH customer_sales AS (
    SELECT
        Customer_ID,
        Customer_Name,
        SUM(Sales) AS lifetime_sales
    FROM superstore_sales
    GROUP BY
        Customer_ID,
        Customer_Name
)

SELECT
    Customer_ID,
    Customer_Name,
    ROUND(lifetime_sales, 2) AS lifetime_sales,

    CASE
        WHEN lifetime_sales >= 10000
            THEN 'High Value'

        WHEN lifetime_sales >= 5000
            THEN 'Medium Value'

        ELSE 'Standard'
    END AS customer_tier

FROM customer_sales
ORDER BY lifetime_sales DESC;


-- ============================================================
-- 26. CUSTOMER TIER SUMMARY
-- ============================================================

WITH customer_sales AS (
    SELECT
        Customer_ID,
        Customer_Name,
        SUM(Sales) AS lifetime_sales
    FROM superstore_sales
    GROUP BY
        Customer_ID,
        Customer_Name
),

customer_tiers AS (
    SELECT
        Customer_ID,
        Customer_Name,
        lifetime_sales,

        CASE
            WHEN lifetime_sales >= 10000
                THEN 'High Value'

            WHEN lifetime_sales >= 5000
                THEN 'Medium Value'

            ELSE 'Standard'
        END AS customer_tier

    FROM customer_sales
)

SELECT
    customer_tier,
    COUNT(*) AS customers,
    ROUND(AVG(lifetime_sales), 2) AS avg_customer_sales,
    ROUND(SUM(lifetime_sales), 2) AS total_sales
FROM customer_tiers
GROUP BY customer_tier
ORDER BY total_sales DESC;


-- ============================================================
-- 27. YEARLY SALES TREND
-- ============================================================

SELECT
    YEAR(Order_Date) AS order_year,
    ROUND(SUM(Sales), 2) AS total_sales
FROM superstore_sales
GROUP BY YEAR(Order_Date)
ORDER BY order_year;


-- ============================================================
-- 28. YEAR-OVER-YEAR SALES GROWTH
-- Demonstrates CTE + LAG
-- ============================================================

WITH yearly_sales AS (
    SELECT
        YEAR(Order_Date) AS order_year,
        SUM(Sales) AS total_sales
    FROM superstore_sales
    GROUP BY YEAR(Order_Date)
)

SELECT
    order_year,
    ROUND(total_sales, 2) AS total_sales,

    ROUND(
        LAG(total_sales) OVER (
            ORDER BY order_year
        ),
        2
    ) AS previous_year_sales,

    ROUND(
        100 * (
            total_sales -
            LAG(total_sales) OVER (
                ORDER BY order_year
            )
        ) /
        LAG(total_sales) OVER (
            ORDER BY order_year
        ),
        2
    ) AS yoy_growth_pct

FROM yearly_sales
ORDER BY order_year;


-- ============================================================
-- 29. MONTHLY SALES TREND
-- ============================================================

SELECT
    DATE_FORMAT(
        Order_Date,
        '%Y-%m'
    ) AS sales_month,

    ROUND(
        SUM(Sales),
        2
    ) AS total_sales

FROM superstore_sales
GROUP BY
    DATE_FORMAT(
        Order_Date,
        '%Y-%m'
    )

ORDER BY sales_month;


-- ============================================================
-- 30. RUNNING TOTAL OF SALES
-- Demonstrates CTE + window function
-- ============================================================

WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(
            Order_Date,
            '%Y-%m'
        ) AS sales_month,

        SUM(Sales) AS monthly_revenue

    FROM superstore_sales

    GROUP BY
        DATE_FORMAT(
            Order_Date,
            '%Y-%m'
        )
)

SELECT
    sales_month,

    ROUND(
        monthly_revenue,
        2
    ) AS monthly_revenue,

    ROUND(
        SUM(monthly_revenue) OVER (
            ORDER BY sales_month
        ),
        2
    ) AS cumulative_revenue

FROM monthly_sales
ORDER BY sales_month;


-- ============================================================
-- 31. MONTH-OF-YEAR SEASONALITY
-- ============================================================

SELECT
    MONTH(Order_Date) AS month_number,
    MONTHNAME(Order_Date) AS month_name,

    ROUND(
        SUM(Sales),
        2
    ) AS total_sales,

    ROUND(
        AVG(Sales),
        2
    ) AS avg_transaction_line_sales

FROM superstore_sales

GROUP BY
    MONTH(Order_Date),
    MONTHNAME(Order_Date)

ORDER BY total_sales DESC;


-- ============================================================
-- 32. SHIPPING PERFORMANCE
-- ============================================================

SELECT
    Ship_Mode,

    ROUND(
        AVG(
            DATEDIFF(
                Ship_Date,
                Order_Date
            )
        ),
        2
    ) AS avg_shipping_days,

    MIN(
        DATEDIFF(
            Ship_Date,
            Order_Date
        )
    ) AS minimum_shipping_days,

    MAX(
        DATEDIFF(
            Ship_Date,
            Order_Date
        )
    ) AS maximum_shipping_days

FROM superstore_sales

GROUP BY Ship_Mode
ORDER BY avg_shipping_days;


-- ============================================================
-- 33. REGIONAL SALES RANKING
-- ============================================================

WITH regional_sales AS (
    SELECT
        Region,
        SUM(Sales) AS total_sales
    FROM superstore_sales
    GROUP BY Region
)

SELECT
    Region,

    ROUND(
        total_sales,
        2
    ) AS total_sales,

    DENSE_RANK() OVER (
        ORDER BY total_sales DESC
    ) AS regional_rank

FROM regional_sales
ORDER BY regional_rank;


-- ============================================================
-- 34. CATEGORY PERFORMANCE WITHIN REGIONS
-- ============================================================

SELECT
    Region,
    Category,

    ROUND(
        SUM(Sales),
        2
    ) AS total_sales,

    DENSE_RANK() OVER (
        PARTITION BY Region
        ORDER BY SUM(Sales) DESC
    ) AS category_rank_within_region

FROM superstore_sales

GROUP BY
    Region,
    Category

ORDER BY
    Region,
    category_rank_within_region;


-- ============================================================
-- 35. TOP PRODUCT IN EACH CATEGORY
-- ============================================================

WITH product_sales AS (
    SELECT
        Category,
        Product_Name,
        SUM(Sales) AS total_sales
    FROM superstore_sales
    GROUP BY
        Category,
        Product_Name
),

ranked_products AS (
    SELECT
        Category,
        Product_Name,
        total_sales,

        DENSE_RANK() OVER (
            PARTITION BY Category
            ORDER BY total_sales DESC
        ) AS product_rank

    FROM product_sales
)

SELECT
    Category,
    Product_Name,
    ROUND(
        total_sales,
        2
    ) AS total_sales

FROM ranked_products

WHERE product_rank = 1
ORDER BY Category;


-- ============================================================
-- 36. CREATE REUSABLE CUSTOMER SALES VIEW
-- ============================================================

CREATE OR REPLACE VIEW customer_sales_summary AS

SELECT
    Customer_ID,
    Customer_Name,
    Segment,

    COUNT(
        DISTINCT Order_ID
    ) AS unique_orders,

    ROUND(
        SUM(Sales),
        2
    ) AS lifetime_sales,

    ROUND(
        SUM(Sales) /
        COUNT(DISTINCT Order_ID),
        2
    ) AS avg_order_value

FROM superstore_sales

GROUP BY
    Customer_ID,
    Customer_Name,
    Segment;


-- ============================================================
-- 37. QUERY CUSTOMER SALES VIEW
-- ============================================================

SELECT *
FROM customer_sales_summary
ORDER BY lifetime_sales DESC
LIMIT 20;


-- ============================================================
-- 38. FINAL BUSINESS SUMMARY
-- ============================================================

SELECT
    COUNT(*) AS transaction_lines,
    COUNT(DISTINCT Order_ID) AS total_orders,
    COUNT(DISTINCT Customer_ID) AS total_customers,
    COUNT(DISTINCT Product_ID) AS total_products,

    ROUND(
        SUM(Sales),
        2
    ) AS total_sales,

    ROUND(
        SUM(Sales) /
        COUNT(DISTINCT Order_ID),
        2
    ) AS average_order_value

FROM superstore_sales;
