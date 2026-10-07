CREATE DATABASE arrowstack_sales;
USE arrowstack_sales;

CREATE TABLE sales (
    Order_ID VARCHAR(20),
    Order_Date DATE,
    Region VARCHAR(20),
    State VARCHAR(50),
    Category VARCHAR(50),
    Product VARCHAR(50),
    Customer_ID VARCHAR(20),
    Quantity INT,
    Unit_Price DECIMAL(12,2),
    Discount DECIMAL(5,2),
    Gross_Sales DECIMAL(14,2),
    Sales DECIMAL(14,2),
    Cost DECIMAL(14,2),
    Profit DECIMAL(14,2),
    Status VARCHAR(20)
);
-- ============================================================
-- 1. DATA OVERVIEW
-- ============================================================
-- Total number of records
select count(*) from sales;

-- Preview sample records
select * from sales limit 10;

-- ============================================================
-- 2. KEY BUSINESS KPIs
-- ============================================================

-- Total Sales
select sum(Sales) as total_sales from sales;

-- Total Completed Orders
SELECT SUM(Sales) AS total_sales FROM sales WHERE Status ='Completed';
SELECT COUNT(*) AS total_orders from sales where Status ='Completed';

-- Average Order Value (AOV)
SELECT 
SUM(Sales) /COUNT(*) AS AOV
FROM sales
WHERE Status ='Completed';

-- Total Profit
SELECT SUM(Profit) as total_profit
from sales 
where  Status ='Completed';

-- Profit Margin
SELECT 
ROUND(
      SUM(Profit) /SUM(Sales)*100,
      2
      ) AS profit_margin_pct
      from sales 
      where Status ='Completed';

-- ============================================================
-- 3. REGIONAL PERFORMANCE
-- ============================================================

-- Sales by Region
select 
region ,
round(sum(Sales), 2) as total_sales 
from sales
where Status ='Completed'
group by Region
order by total_sales desc;

-- Sales and Profit by Region
select 
category ,round(sum(sales),2) as total_sales 
from sales 
where status ='Completed'
group by Category
order by total_sales desc;

-- Regional Profit Margin
SELECT
    DATE_FORMAT(Order_Date, '%Y-%m') AS month,
    ROUND(SUM(Sales), 2) AS total_sales
FROM sales
WHERE Status = 'Completed'
GROUP BY DATE_FORMAT(Order_Date, '%Y-%m')
ORDER BY month;

-- ============================================================
-- 4. CATEGORY PERFORMANCE
-- ============================================================

-- Sales by Category
SELECT
    Status,
    COUNT(*) AS order_count
FROM sales
GROUP BY Status
ORDER BY order_count DESC;

-- Category Sales, Profit and Margin
SELECT
    ROUND(
        SUM(CASE WHEN Status = 'Completed' THEN 1 ELSE 0 END)
        / COUNT(*) * 100,
        2
    ) AS completion_rate_pct
FROM sales;

-- ============================================================
-- 5. MONTHLY SALES TREND
-- ============================================================

-- Monthly Sales
SELECT
    Product,
    ROUND(SUM(Sales), 2) AS total_sales
FROM sales
WHERE Status = 'Completed'
GROUP BY Product
ORDER BY total_sales DESC;

-- ============================================================
-- 6. ORDER STATUS ANALYSIS
-- ============================================================

-- Order Count by Status
SELECT
    Product,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit
FROM sales
WHERE Status = 'Completed'
GROUP BY Product
ORDER BY total_profit DESC;

-- Order Completion Rate
-- Note: This is not a marketing conversion rate because
-- the dataset does not contain leads or visitor data.
SELECT
    Region,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit
FROM sales
WHERE Status = 'Completed'
GROUP BY Region
ORDER BY total_profit DESC;

-- ============================================================
-- 7. PRODUCT PERFORMANCE
-- ============================================================

-- Sales by Product
SELECT
    Region,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND(SUM(Profit) / SUM(Sales) * 100, 2) AS profit_margin_pct
FROM sales
WHERE Status = 'Completed'
GROUP BY Region
ORDER BY profit_margin_pct DESC;

-- Product Sales and Profit
SELECT
    Category,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND(SUM(Profit) / SUM(Sales) * 100, 2) AS profit_margin_pct
FROM sales
WHERE Status = 'Completed'
GROUP BY Category
ORDER BY total_sales DESC;

-- ============================================================
-- END OF SALES ANALYSIS
-- ============================================================
