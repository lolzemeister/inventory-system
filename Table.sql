CREATE TABLE product (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    supplier_id INT,
    category_id INT,
    selling_price DECIMAL(10, 2) NOT NULL,
    stock_quantity INT NOT NULL,
)