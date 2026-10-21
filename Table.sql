CREATE TABLE category (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL,
    category_total_sales INT NOT NULL DEFAULT 0
);

CREATE TABLE supplier (
    supplier_id INT PRIMARY KEY,
    supplier_name VARCHAR(100) NOT NULL,
    contact_email VARCHAR(100),
    contact_phone VARCHAR(15),
    website_url VARCHAR(100)
);

CREATE TABLE product (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    supplier_id INT NOT NULL,
    category_id INT NOT NULL,
    selling_price DECIMAL(10, 2) NOT NULL CHECK (selling_price >= 0),
    product_stock_quantity INT NOT NULL CHECK (product_stock_quantity >= 0),
    total_product_sales INT NOT NULL DEFAULT 0,

    FOREIGN KEY (supplier_id) REFERENCES supplier(supplier_id),
    FOREIGN KEY (category_id) REFERENCES category(category_id)
);

CREATE TABLE sale (
    sale_id INT PRIMARY KEY,
    sale_date DATETIME NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL CHECK (total_amount >= 0)
);

CREATE TABLE sale_item (
    sale_item_id INT PRIMARY KEY,
    sale_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10, 2) NOT NULL CHECK (unit_price >= 0),

    FOREIGN KEY (sale_id) REFERENCES sale(sale_id),
    FOREIGN KEY (product_id) REFERENCES product(product_id)
);

CREATE TABLE stock_receipt (
    stock_receipt_id INT PRIMARY KEY,
    receipt_date DATETIME NOT NULL,
    supplier_id INT NOT NULL,
    total_cost DECIMAL(10, 2) NOT NULL CHECK (total_cost >= 0),

    FOREIGN KEY (supplier_id) REFERENCES supplier(supplier_id)
);

CREATE TABLE stock_receipt_item (
    stock_receipt_item_id INT PRIMARY KEY,
    stock_receipt_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_cost DECIMAL(10, 2) NOT NULL CHECK (unit_cost >= 0),

    FOREIGN KEY (stock_receipt_id) REFERENCES stock_receipt(stock_receipt_id),
    FOREIGN KEY (product_id) REFERENCES product(product_id)
);

CREATE TABLE inventory (
    inventory_id INT PRIMARY KEY,
    inventory_name VARCHAR(100) NOT NULL,
    total_quantity_in_stock INT NOT NULL CHECK (total_quantity_in_stock >= 0),
    total_inventory_sales INT NOT NULL DEFAULT 0,
    total_inventory_value INT NOT NULL DEFAULT 0,
    total_revenue INT NOT NULL DEFAULT 0,
    total_expenses INT NOT NULL DEFAULT 0
)