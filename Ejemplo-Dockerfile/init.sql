CREATE SCHEMA store;

CREATE TABLE store.customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

INSERT INTO store.customers (name, email) VALUES
('Alice Johnson', 'alice@example.com'),
('Bob Smith', 'bob@example.com'),
('Carla Gomez', 'carla@example.com');

CREATE TABLE store.products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price NUMERIC(10,2) NOT NULL,
    stock INT DEFAULT 0
);

CREATE TABLE store.orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date TIMESTAMP DEFAULT NOW(),
    total NUMERIC(12,2) DEFAULT 0,
    CONSTRAINT fk_customer FOREIGN KEY (customer_id)
        REFERENCES store.customers (customer_id) ON DELETE CASCADE
);

CREATE TABLE store.order_details (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    price NUMERIC(10,2) NOT NULL,
    CONSTRAINT fk_order FOREIGN KEY (order_id)
        REFERENCES store.orders (order_id) ON DELETE CASCADE,
    CONSTRAINT fk_product FOREIGN KEY (product_id)
        REFERENCES store.products (product_id) ON DELETE CASCADE
);

CREATE INDEX idx_orders_customer_id ON store.orders(customer_id);
CREATE INDEX idx_order_items_order_id ON store.order_details(order_id);

INSERT INTO store.customers (name, email) VALUES
('Alice Johnson', 'alice@example.com'),
('Bob Smith', 'bob@example.com'),
('Carla Gomez', 'carla@example.com');

INSERT INTO store.products (name, price, stock) VALUES
('Laptop', 1200.50, 10),
('Mouse', 25.99, 50),
('Keyboard', 45.00, 30),
('Monitor', 220.00, 15);

INSERT INTO store.orders (customer_id, total)
VALUES (1, 1246.49);

INSERT INTO store.order_details (order_id, product_id, quantity, price)
VALUES 
(1, 1, 1, 1200.50),  
(1, 2, 1, 25.99),    
(1, 3, 1, 20.00);    
