/*1. Create a database named ecommerce.*/
create DATABASE ecommerce;

/*Create three tables: customers, orders, and products.
---2. customers table---
2.1. id (primary key, auto-increment): unique identifier for each customer
2.2. name: customer's name
2.3. email: customer's email address
2.4. address: customer's address
*/
CREATE TABLE `ecommerce`.`customers` (`id` BIGINT NOT NULL AUTO_INCREMENT , `name` VARCHAR(100) NOT NULL , `email` VARCHAR(100) NOT NULL , `address` VARCHAR(500) NOT NULL , PRIMARY KEY (`id`));

/*
---3. orders table---
3.1. id (primary key, auto-increment): unique identifier for each order
3.2. customer_id (foreign key referencing customers.id): a customer who placed the order
3.3. order_date: date the order was placed
3.4. total_amount: total amount of the order
*/
CREATE TABLE `ecommerce`.`orders` (`id` BIGINT NOT NULL AUTO_INCREMENT , `customer_id` BIGINT NOT NULL ,  `order_date` DATETIME NOT NULL , `total_amount` INT NOT NULL ,PRIMARY KEY (`id`),CONSTRAINT FK_orders_customers FOREIGN KEY (customer_id) REFERENCES customers(id));

/*
---4. products table---
4.1. id (primary key, auto-increment): unique identifier for each product
4.2. name: product's name
4.3. price: product's price
4.4. description: product's description
*/
CREATE TABLE `ecommerce`.`products` (`id` BIGINT NOT NULL AUTO_INCREMENT , `name` VARCHAR(100) NOT NULL , `price` INT NOT NULL , `description` VARCHAR(200) NOT NULL , PRIMARY KEY (`id`));


-- 5. Retrieve all customers who have placed an order in the last 30 days.
SELECT * FROM customers 
JOIN orders on customers.id=orders.customer_id 
WHERE orders.order_date >= DATE_SUB(NOW(), INTERVAL 30 DAY);


-- 6. Get the total amount of all orders placed by each customer.
SELECT 
    c.id AS customer_id,
    c.name AS customer_name,
    SUM(o.total_amount) AS total_order_amount
FROM customers c
JOIN orders o ON c.id = o.customer_id
GROUP BY c.id;

-- 7. Update the price of Product C to 45.00.
UPDATE `products` 
set price = 45
WHERE id=3;
SELECT * FROM `products` 

-- 8. Add a new column discount to the products table.
ALTER TABLE `products` ADD `discount` INT NOT NULL AFTER `description`;

-- 9. Retrieve the top 3 products with the highest price.
SELECT * FROM `products` ORDER BY price DESC
LIMIT 3;

-- 10. Get the names of customers who have ordered Product A.
-- 10.1. There is no relationship between orders and products tables, so create a column product_id from orders table that refers the products table id
ALTER TABLE `orders`
ADD COLUMN `product_id` BIGINT NULL AFTER `customer_id`,
ADD CONSTRAINT FK_orders_products
    FOREIGN KEY (`product_id`)
    REFERENCES `products`(`id`);

-- 10.2. Retrieve names of customers.
SELECT DISTINCT c.name
FROM customers c
JOIN orders o ON c.id = o.customer_id
JOIN products p ON o.product_id = p.id 
WHERE p.name= 'laptop';

-- 11. Join the orders and customers tables to retrieve the customer's name and order date for each order.
SELECT DISTINCT c.name,o.order_date
FROM customers c
JOIN orders o ON c.id = o.customer_id;

-- 12. Retrieve the orders with a total amount greater than 150.00.
SELECT * from orders WHERE total_amount > 150;

-- 13. Normalize the database by creating a separate table for order items and updating the orders table to reference the order_items table.

-- 13.1. remove product reference from order table 
ALTER TABLE orders
DROP FOREIGN KEY FK_orders_products;

ALTER TABLE orders
DROP COLUMN product_id;


-- 13.2. Create order_items table that refers orders and product table

CREATE TABLE ecommerce.order_items (
    id BIGINT NOT NULL AUTO_INCREMENT,
    order_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    quantity INT NOT NULL,
    price INT NOT NULL,
    PRIMARY KEY (id),

    CONSTRAINT FK_order_items_orders
        FOREIGN KEY (order_id)
        REFERENCES orders(id)
        ON DELETE CASCADE,

    CONSTRAINT FK_order_items_products
        FOREIGN KEY (product_id)
        REFERENCES products(id)
);


-- 14. Retrieve the average total of all orders.
SELECT AVG(total_amount) AS average_order_total
FROM orders;