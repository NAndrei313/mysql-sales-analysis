-- First, we need to import our tables and check the current data.
-- Let's see the data in each table.
SELECT *
FROM customers;
-- Defining the primary key for the 'customers' table.
-- This column ('id') will be the unique identifier for each customer.
ALTER TABLE customers
ADD PRIMARY KEY (id);

SELECT *
FROM products;
-- Defining the primary key for the 'products' table.
-- This column ('id') will uniquely identify each product.
ALTER TABLE products
ADD PRIMARY KEY (id)
;

SELECT *
FROM order_items;
-- Defining the primary key for the 'order_items' table.
-- This column ('id') uniquely identifies each order item.
ALTER TABLE order_items
ADD PRIMARY KEY (id);
-- Adding a foreign key constraint for 'order_id' in the 'order_items' table.
-- This foreign key references the 'id' column in the 'orders' table, establishing a relationship between orders and order items.
ALTER TABLE order_items
ADD CONSTRAINT fk_order
FOREIGN KEY (order_id) REFERENCES orders(id);
-- Adding a foreign key constraint for 'product_id' in the 'order_items' table.
-- This foreign key references the 'id' column in the 'products' table, establishing a relationship between order items and products.
ALTER TABLE order_items
ADD CONSTRAINT fk_product
FOREIGN KEY (product_id) REFERENCES products(id);

SELECT *
FROM orders;
-- Defining the primary key for the 'orders' table.
-- This column ('id') uniquely identifies each order.
ALTER TABLE orders
ADD PRIMARY KEY (id);
-- Adding a foreign key constraint for 'customer_id' in the 'orders' table.
-- This foreign key references the 'id' column in the 'customers' table, establishing a relationship between orders and customers.
ALTER TABLE orders
ADD CONSTRAINT fk_customer
FOREIGN KEY (customer_id) REFERENCES customers(id);
-- First, we need to address the issue that the `order_date` column is not in the correct `DATETIME` format.
-- Currently, the dates are stored as strings in the format `YYYY/MM/DD`, so we will create a new temporary column for `DATETIME` values.

-- Adding a new column `order_date_temp` of type `DATETIME` to store the correct date format.
ALTER TABLE orders
ADD COLUMN order_date_temp DATETIME;

-- We will update the new column `order_date_temp` by converting the old `order_date` string values to `DATETIME` format.
-- Using the `STR_TO_DATE` function to convert the date in the format `DD/MM/YYYY` to `DATETIME`.
UPDATE orders
SET order_date_temp = STR_TO_DATE(order_date, '%d/%m/%Y');

-- After the conversion, we can safely remove the old `order_date` column.
ALTER TABLE orders
DROP COLUMN order_date;

-- Renaming `order_date_temp` to `order_date` to restore the original column name, but now in `DATETIME` format.
ALTER TABLE orders
CHANGE COLUMN order_date_temp order_date DATETIME;

-- Optional: if we want to store the date without the time portion, we can modify the column to be of type `DATE` (only date, no time).
ALTER TABLE orders
MODIFY COLUMN order_date_temp DATE;

-- Now, drop the `order_date` column (if it still exists).
ALTER TABLE orders
DROP COLUMN order_date;
-- Finally, make sure the `order_date` column is now of type `DATE`, storing only the date part.
ALTER TABLE orders
CHANGE COLUMN order_date_temp order_date DATE;
-- We can verify that the column is now correctly formatted and contains valid data.
SELECT *
FROM orders;

# Data Cleaning

-- Find orders without a date (these could be excluded or manually completed)
SELECT * FROM orders WHERE order_date IS NULL;

-- Customers without a country (you can mark as 'Unknown' or exclude from country-based analysis)
SELECT * FROM customers WHERE country IS NULL;

-- Orders with a price of 0 or negative quantities (exclude or analyze separately)
SELECT * FROM order_items WHERE price <= 0 OR quantity < 0;
SELECT *
FROM order_items;
-- We observed that item 3, which was sold with a quantity of -2, has a price of 120. We also saw in the order_items table that the same product_id was sold with a quantity of 2 at the same price of 120.
-- We can correct the quantity for product_id 3 to 2 because that is the correct value.
-- For product_id 4, which was sold for a price of 0, we can leave it as it is because it does not affect our analysis.

-- Update the quantity for the product with negative quantity
UPDATE order_items
SET quantity = 2
WHERE product_id = product_id AND quantity = -2;

SELECT *
FROM orders;

# Analyze Data

-- How many total orders were placed?
SELECT COUNT(*) AS total_orders 
FROM orders;

-- How many unique customers made purchases?
SELECT COUNT(DISTINCT id) AS unique_customers 
FROM customers;

-- How many different products were sold?
SELECT COUNT(DISTINCT product_id) AS sold_product 
FROM order_items;

-- How many product categories are available?
SELECT DISTINCT category
FROM products; 

SELECT *
FROM order_items;
SELECT *
FROM products;

-- Top sold products by number of units sold
SELECT prod.name, SUM(order_items.quantity) AS total_units
FROM order_items
JOIN products prod ON order_items.product_id = prod.id
GROUP BY prod.name
ORDER BY total_units DESC;

-- Products with the highest total revenue
SELECT products.name, SUM(order_items.quantity * order_items.price) AS total_revenue
FROM order_items
JOIN products ON order_items.product_id = products.id
GROUP BY products.name
ORDER BY total_revenue ASC;

-- Average price per product category
SELECT products.category, ROUND(AVG(order_items.price), 2) AS avg_price
FROM order_items
JOIN products ON order_items.product_id = products.id
GROUP BY products.category;

-- Top 3 customers based on total spending across all orders
SELECT customers.name, SUM(order_items.quantity * order_items.price) AS total_spent
FROM customers
JOIN orders ON customers.id = orders.customer_id
JOIN order_items ON orders.id = order_items.order_id
GROUP BY customers.id
ORDER BY total_spent DESC
LIMIT 3;

-- Number of customers who placed more than one order
SELECT customers.name, COUNT(order_items.order_id) AS num_of_order
FROM customers
JOIN orders ON customers.id = orders.customer_id
JOIN order_items ON orders.id = order_items.order_id
GROUP BY customers.id
ORDER BY num_of_order DESC;

-- Countries with the highest number of registered customers
SELECT country, COUNT(*) AS num_clients
FROM customers
GROUP BY country
ORDER BY num_clients DESC;

-- Month with the highest total sales revenue
SELECT DATE_FORMAT(orders.order_date, '%Y-%m') AS month, 
	SUM(order_items.quantity * order_items.price) AS total_sales
FROM orders
JOIN order_items ON orders.id = order_items.order_id
GROUP BY month
ORDER BY total_sales DESC
LIMIT 1;

-- Monthly trend of order volume (number of orders placed per month)
SELECT DATE_FORMAT(orders.order_date, '%Y-%m') AS month,
COUNT(DISTINCT orders.id) AS num_of_orders
FROM orders
WHERE orders.order_date IS NOT NULL
GROUP BY month;

-- Daily sales overview to identify unusually high or low performing days
SELECT orders.order_date, 
	SUM(order_items.quantity * order_items.price) AS daily_sales
FROM orders
JOIN order_items ON orders.id = order_items.order_id
WHERE orders.order_date IS NOT NULL
GROUP BY orders.order_date
ORDER BY daily_sales DESC;

-- Products with high sales volume but low total revenue 
-- (i.e., many units sold but generating limited income)
SELECT products.name, 
	SUM(order_items.quantity) AS units_sold, 
    SUM(order_items.quantity * order_items.price) AS total_revenue
FROM products
JOIN order_items ON products.id = order_items.product_id
GROUP BY products.name
HAVING units_sold > 10 AND total_revenue < 100;

-- Customers who purchase large quantities but place orders infrequently
-- (e.g., fewer than or equal to 2 orders, but more than 20 total items purchased)
SELECT customers.name, 
	COUNT(orders.id) AS orders_count, 
	SUM(order_items.quantity) AS total_qty
FROM customers
JOIN orders ON customers.id = orders.customer_id
JOIN order_items ON orders.id = order_items.order_id
GROUP BY customers.id, customers.name
HAVING orders_count <= 2 AND total_qty > 20;

-- Countries with the highest average revenue per customer
-- (total revenue from that country divided by number of distinct customers)
SELECT customers.country, 
	ROUND(SUM(order_items.quantity * order_items.price)/COUNT(DISTINCT customers.id), 2) AS revenue_per_client
FROM customers
JOIN orders ON customers.id = orders.customer_id
JOIN order_items ON orders.id = order_items.order_id
GROUP BY customers.country
ORDER BY revenue_per_client DESC;