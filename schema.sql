-- schema.sql
 CREATE DATABASE IF NOT EXISTS ecommerce_main;
 USE ecommerce_main;
 
 CREATE TABLE users (
   user_id       INT AUTO_INCREMENT PRIMARY KEY,
   name          VARCHAR(100) NOT NULL,
   email         VARCHAR(100) UNIQUE NOT NULL,
   password_hash VARCHAR(255) NOT NULL,
   phone         VARCHAR(15),
   address       TEXT,
   role          ENUM('customer','admin') DEFAULT 'customer',
   created_at    DATETIME DEFAULT CURRENT_TIMESTAMP
 );
 
 CREATE TABLE products (
   product_id  INT AUTO_INCREMENT PRIMARY KEY,
   name        VARCHAR(200) NOT NULL,
   description TEXT,
   category    VARCHAR(100) NOT NULL,
   price       DECIMAL(10,2) NOT NULL,
   stock_qty   INT NOT NULL DEFAULT 0,
   image_url   VARCHAR(255),
   created_at  DATETIME DEFAULT CURRENT_TIMESTAMP
 );
 
 CREATE TABLE cart (
   cart_id    INT AUTO_INCREMENT PRIMARY KEY,
   user_id    INT NOT NULL,
   product_id INT NOT NULL,
   quantity   INT NOT NULL DEFAULT 1,
   added_at   DATETIME DEFAULT CURRENT_TIMESTAMP,
   FOREIGN KEY (user_id)    REFERENCES users(user_id) ON DELETE CASCADE,
   FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
 );
 
 CREATE TABLE orders (
   order_id       VARCHAR(36) PRIMARY KEY,
   user_id        INT NOT NULL,
   total_amount   DECIMAL(10,2) NOT NULL,
   status         ENUM('pending','processing','shipped',
                       'delivered','cancelled') DEFAULT 'pending',
   payment_status ENUM('unpaid','paid','failed') DEFAULT 'unpaid',
   created_at     DATETIME DEFAULT CURRENT_TIMESTAMP,
   FOREIGN KEY (user_id) REFERENCES users(user_id)
 );
 
 CREATE TABLE order_items (
   item_id    INT AUTO_INCREMENT PRIMARY KEY,
   order_id   VARCHAR(36) NOT NULL,
   product_id INT NOT NULL,
   quantity   INT NOT NULL,
   unit_price DECIMAL(10,2) NOT NULL,
   FOREIGN KEY (order_id)   REFERENCES orders(order_id),
   FOREIGN KEY (product_id) REFERENCES products(product_id)
 );
 
 CREATE TABLE payments (
   payment_id     INT AUTO_INCREMENT PRIMARY KEY,
   order_id       VARCHAR(36) NOT NULL,
   amount         DECIMAL(10,2) NOT NULL,
   method         VARCHAR(50) NOT NULL,
   status         ENUM('success','failure','pending') NOT NULL,
   transaction_id VARCHAR(100),
   paid_at        DATETIME,
   FOREIGN KEY (order_id) REFERENCES orders(order_id)
);
