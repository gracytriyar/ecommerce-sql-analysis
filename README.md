# E-commerce SQL Analysis

This project contains advanced SQL queries to analyze the delivery and sales performance of an e-commerce platform. The goal is to extract actionable insights using only SQL, with a focus on window functions, aggregations, and group-based logic.

> **Tools Used**: MySQL Workbench 8.0

---

## 🔍 Objective

Perform advanced SQL analysis on e-commerce transactional data to answer critical business questions related to delivery performance, seller reliability, revenue distribution, and monthly trends.

---

## 📁 Files

- `ecommerce_analysis.sql` – SQL file containing all queries used in this project.
- `ecommerce_analysis_output.pdf` – (Optional) Includes query output and visual screenshots.
- - [ecommerce_analysis.sql](ecommerce_analysis.sql) — SQL script with all queries used in this project.


---

## 📊 Key Questions Solved

1. Evaluate delivery performance by calculating how many days each order was delivered early or late.
2. Which region experienced the highest average delivery delays?
3. Do certain product categories experience more delivery delays than others?
4. Which product categories contribute the most to the total revenue?
5. Identify the top five active cities by order value/volume.
6. What is the average delivery delay per seller, and who are the most and least reliable sellers?
7. Identify customers in the top 10% based on total spending.
8. Which product categories generate the highest revenue margin?
9. How has the monthly sales trend evolved over time?
10. What is the average order value (AOV) each month, and how has it changed over time?

---

## ⚙️ SQL Concepts Used

- `JOIN`, `GROUP BY`, `ORDER BY`
- `CASE` statements
- `Window Functions` (`RANK()`, `DENSE_RANK()`, `ROW_NUMBER()`, `AVG() OVER`, etc.)
- `Subqueries`
- `Aggregate Functions` like `SUM`, `COUNT`, `AVG`

---

## 📌 Notes

- This analysis is based solely on SQL. No Excel or Python was used.
- Each customer placed only one order; therefore, churn or repeat behavior was not analyzed.


