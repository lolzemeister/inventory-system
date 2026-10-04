CREATE TABLE product (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    supplier_id INT,
    category_id INT,
    selling_price DECIMAL(10, 2) NOT NULL,
    stock_quantity INT NOT NULL,
)

CREATE TABLE category (
    category_id INT,
    category_name VARCHAR(100),

    PRIMARY KEY (category_id)
)

CREATE TABLE sale_item (
    sale_item_id INT PRIMARY KEY,
    sale_id INT,
    product_id INT,
    quantity INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL
)

CREATE TABLE sale (
    sale_id INT,
    sale_date DATETIME NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,

    PRIMARY KEY (sale_id)
)

CREATE TABLE stock_receipt_item (
    stock_receipt_item_id INT,
    stock_receipt_id INT,
    product_id INT,
    quantity INT NOT NULL,
    unit_cost DECIMAL(10, 2) NOT NULL,

    PRIMARY KEY (stock_receipt_item_id)
)

CREATE TABLE stock_receipt (
    stock_receipt_id INT,
    receipt_date DATETIME NOT NULL,
    supplier_id INT,
    total_cost DECIMAL(10, 2) NOT NULL,

    PRIMARY KEY (stock_receipt_id)
)

CREATE TABLE supplier (
    supplier_id INT,
    supplier_name VARCHAR(100),
    contact_email VARCHAR(100),
    contact_phone VARCHAR(15),
    website_url VARCHAR(100),

    PRIMARY KEY (supplier_id)
)