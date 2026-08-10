-- Create a Sales Table:
CREATE TABLE sales (
    order_id INT,
    customer_id INT,
    product VARCHAR(100),
    region VARCHAR(50),
    quantity INT,
    revenue DECIMAL(10,2),
    order_date DATE
);

-- Insert Sample Data
INSERT INTO sales VALUES
(1, 101, 'Laptop', 'North', 1, 80000, '2026-01-10'),
(2, 102, 'Mouse', 'North', 2, 3000, '2026-01-12'),
(3, 103, 'Laptop', 'South', 1, 80000, '2026-02-05'),
(4, 104, 'Keyboard', 'West', 3, 9000, '2026-02-10'),
(5, 105, 'Monitor', 'North', 2, 40000, '2026-03-01'),
(6, 106, 'Laptop', 'West', 2, 160000, '2026-03-15');

SELECT *
FROM sales;


-- Run Analytical Queries:

-- Total Revenue
SELECT SUM(revenue) AS total_revenue
FROM sales;

-- Revenue by Region
SELECT
    region,
    SUM(revenue) AS revenue
FROM sales
GROUP BY region
ORDER BY revenue DESC;

-- Top Products
SELECT
    product,
    SUM(revenue) AS revenue
FROM sales
GROUP BY product
ORDER BY revenue DESC;

