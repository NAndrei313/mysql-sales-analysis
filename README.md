# Sales Database Analysis with SQL

## 📊 Project Overview

This project represents a complete analysis of a sales database using MySQL. It simulates the backend of an e-commerce platform, with four key tables: `customers`, `products`, `orders`, and `order_items`. The purpose of the analysis was to clean, structure, and extract meaningful business insights from transactional data.

The goal of this project is to demonstrate my ability to:
- Import and clean raw data
- Design and enforce database relationships
- Perform descriptive and business-focused SQL analytics
- Identify improvement opportunities based on sales performance

---

## 🛠 Technologies Used

- MySQL 8+
- dbdiagram.io (for ERD)
- VSCode / DBeaver
- GitHub

---

## 🧱 Database Structure (ERD)

The Entity-Relationship Diagram defines the relationships:
- One `customer` can place many `orders`
- Each `order` can contain multiple `order_items`
- Each `order_item` refers to a single `product`

*You can find the ERD image in the repository under `erd.png`.*

---

## 🧹 Data Cleaning Steps

- Converted `order_date` from string (`'DD/MM/YYYY'`) to SQL `DATE` format
- Handled missing values (`NULLs`) and excluded invalid records
- Fixed inconsistent entries (e.g., negative quantities)
- Removed logically incorrect records (e.g., NULL `order_id` or `product_id`)

---

## 🔍 Key SQL Functions and Techniques Used

- `JOIN` (INNER JOIN, LEFT JOIN)
- `GROUP BY`, `ORDER BY`
- `HAVING` for post-aggregation filtering
- `COUNT()`, `SUM()`, `AVG()`, `ROUND()`
- `DATE_FORMAT()` for time-based aggregations
- `ALTER TABLE`, `ADD CONSTRAINT`, `UPDATE`, `DROP COLUMN`
- `STR_TO_DATE()` for date parsing
- Subqueries and nested filtering

---

## 📈 Business Insights Extracted

- **Top-selling products** by units and by revenue
- **Highest spending customers** and **loyalty patterns**
- **Country-wise customer distribution** and average revenue
- **Monthly and daily sales trends**
- **Unusual sales behavior**, such as:
  - High volume but low revenue products
  - Customers who buy in bulk but order rarely

---

## 💡 Value for Business

This analysis could help a real business to:
- Optimize stock levels based on product demand
- Identify underperforming items
- Personalize offers for top customers
- Detect seasonal trends to boost marketing strategies
- Improve customer segmentation by behavior and geography

---

## 📂 Project Files

- `customers.csv`, `orders.csv`, `products.csv`, `order_items.csv`: Sample data
- `project_analysis.sql`: Full SQL code used for cleaning and analysis
- `erd.png`: Entity-Relationship Diagram of the database
- `README.md`: This documentation

---

## 🚀 Next Improvements

- Build a dashboard with Power BI or Tableau for visual insights
- Add automation scripts to load and process data regularly
- Store data in a more normalized format for scalability
- Connect with APIs or scraping for real-time datasets

---

## 🔗 Connect with Me

If you’re a recruiter or a fellow data enthusiast, feel free to connect with me on [[LinkedIn](https://www.linkedin.com)](https://www.linkedin.com/in/andrei-neagu-30a37011a/) or check my other projects!
