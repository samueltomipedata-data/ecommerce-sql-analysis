CREATE DATABASE ecommerce_project;
USE ecommerce_project;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(50),
    city VARCHAR(50)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    price DECIMAL(10,2)
    );
    
    CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO customers VALUES
(1, 'Tomi', 'Abuja'),
(2, 'Ada', 'Lagos'),
(3, 'John', 'Port Harcourt');

INSERT INTO products VALUES
(1, 'Cake', 5000),
(2, 'Bread', 1500),
(3, 'Cookies', 2000);

INSERT INTO orders VALUES
(1, 1, '2024-01-01'),
(2, 2, '2024-01-02'),
(3, 1, '2024-01-03');

INSERT INTO order_items VALUES
(1, 1, 1, 2),
(2, 1, 2, 1),
(3, 2, 3, 3),
(4, 3, 1, 1);

SELECT *
FROM ecommerce_project.customers;

USE ecommerce_project;
SHOW TABLES;

SELECT * FROM products;
SELECT * FROM orders;

-- TOTAL REVENUE --

SELECT SUM(p.price * oi.quantity) AS total_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id;

-- TOP CUSTOMERS --

SELECT c.name, SUM(p.price * oi.quantity) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY c.name
ORDER BY total_spent DESC;

-- BEST SELLING PRODUCTS --

SELECT p.product_name, SUM(oi.quantity) AS total_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sold DESC;

-- REVENUE PER CUSTOMER --

SELECT c.name, SUM(p.price * oi.quantity) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY c.name
ORDER BY total_spent DESC;

-- MONTHLY SALES TREND --

SELECT DATE_FORMAT(o.order_date, '%Y-%m') AS month,
       SUM(p.price * oi.quantity) AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY month
ORDER BY month;

-- TOP-SELLING PRODUCT --

SELECT p.product_name, SUM(oi.quantity) AS total_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sold DESC
LIMIT 1;

-- AVERAGE ORDER VALUE --

SELECT AVG(order_total) AS avg_order_value
FROM (
    SELECT o.order_id,
           SUM(p.price * oi.quantity) AS order_total
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    GROUP BY o.order_id
) AS sub;


-- CUSTOMER RANKING --

SELECT name, total_spent,
       RANK() OVER (ORDER BY total_spent DESC) AS rank_position
FROM (
    SELECT c.name,
           SUM(p.price * oi.quantity) AS total_spent
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    GROUP BY c.name
) AS ranked;