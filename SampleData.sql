-- Convenience store sample dataset for testing and demonstrations.
-- All suppliers are fictional and prices are illustrative CAD amounts.
-- Run once against empty tables after Table.sql; IDs are fixed.
-- 5 suppliers, 5 categories, 20 products, 10 receipts, 35 receipt items,
-- 15 sales and 48 sale items (138 rows total).
-- Stock is a snapshot after the last sale on 2026-10-10, assuming zero opening
-- stock and only these receipts and sales (no returns or adjustments).
-- Do not use stock-adjustment triggers when loading these snapshot quantities.
-- Receipt/sale header totals equal the sum of their line quantities times costs/prices.
-- No sales taxes or discounts included. Lottery ticket represents physical
-- scratch-ticket stock, not a lottery draw or payout system.
-- Coffee, tea and slushies are represented as per-serving sellable items;
-- ingredient-level inventory is out of scope.
-- Demo cases: product 7 sold out; 12 and 16 low stock; 19 never sold;
-- product 20 new with no receipts or sales.

INSERT INTO supplier (supplier_id, supplier_name, contact_email, contact_phone, website_url) VALUES
    (1, 'Pacific Snack Distributors', 'orders@snacks.example', '250-555-0101', 'https://snacks.example'),
    (2, 'Coastal Beverage Supply', 'orders@drinks.example', '250-555-0102', 'https://drinks.example'),
    (3, 'Island Frozen Treats Wholesale', 'orders@frozen.example', '250-555-0103', NULL),
    (4, 'Victoria Candy & Bakery Supply', 'orders@candy.example', NULL, NULL),
    (5, 'West Coast General Merchandise', NULL, '250-555-0105', NULL);

INSERT INTO category (category_id, category_name) VALUES
    (1, 'Chips & Savoury Snacks'),
    (2, 'Drinks, Coffee & Tea'),
    (3, 'Ice Cream & Frozen Treats'),
    (4, 'Candy, Chocolate & Cookies'),
    (5, 'Lottery & Convenience Essentials');

INSERT INTO product (product_id, product_name, supplier_id, category_id, selling_price, stock_quantity) VALUES
    (1, 'Classic Potato Chips 200 g', 1, 1, 3.49, 61),
    (2, 'Nacho Cheese Tortilla Chips 235 g', 1, 1, 3.99, 103),
    (3, 'Salted Pretzels 150 g', 1, 1, 2.49, 86),
    (4, 'Butter Popcorn 100 g', 1, 1, 3.49, 53),
    (5, 'Cola 500 mL', 2, 2, 2.99, 16),
    (6, 'Fresh Brewed Coffee 12 oz', 2, 2, 2.49, 10),
    (7, 'Blue Raspberry Slushie 16 oz', 2, 2, 3.49, 0),
    (8, 'Black Tea 12 oz', 2, 2, 1.99, 7),
    (9, 'Vanilla Ice Cream Bar', 3, 3, 3.49, 36),
    (10, 'Chocolate Ice Cream Cone', 3, 3, 4.49, 3),
    (11, 'Strawberry Ice Cream Cup', 3, 3, 3.99, 12),
    (12, 'Ice Cream Sandwich', 3, 3, 2.99, 1),
    (13, 'Gummy Bears 150 g', 4, 4, 3.49, 35),
    (14, 'Milk Chocolate Bar 45 g', 4, 4, 2.49, 3),
    (15, 'Sour Candy 120 g', 4, 4, 3.99, 7),
    (16, 'Chocolate Chip Cookies 6-Pack', 4, 4, 4.99, 2),
    (17, 'Scratch Lottery Ticket - $5', 5, 5, 5.00, 9),
    (18, 'Pocket Notebook', 5, 5, 3.49, 25),
    (19, 'Pencil Pack - 4 Count', 5, 5, 2.49, 15),
    (20, 'USB Flash Drive 32 GB', 5, 5, 12.99, 0);

INSERT INTO stock_receipt (stock_receipt_id, receipt_date, supplier_id, total_cost) VALUES
    (1, '2026-09-01 09:00:00', 1, 393.50),
    (2, '2026-09-02 09:30:00', 2, 32.15),
    (3, '2026-09-03 10:00:00', 3, 92.35),
    (4, '2026-09-04 10:30:00', 4, 90.60),
    (5, '2026-09-05 11:00:00', 5, 83.00),
    (6, '2026-09-15 09:00:00', 1, 193.50),
    (7, '2026-09-16 09:30:00', 2, 18.20),
    (8, '2026-09-17 10:00:00', 3, 50.25),
    (9, '2026-09-18 10:30:00', 4, 47.60),
    (10, '2026-09-19 11:00:00', 5, 42.45);

INSERT INTO stock_receipt_item (stock_receipt_item_id, stock_receipt_id, product_id, quantity, unit_cost) VALUES
    (1, 1, 1, 50, 1.75),
    (2, 1, 2, 80, 2.10),
    (3, 1, 3, 60, 1.10),
    (4, 1, 4, 40, 1.80),
    (5, 2, 5, 12, 1.45),
    (6, 2, 6, 8, 0.75),
    (7, 2, 7, 5, 1.15),
    (8, 2, 8, 6, 0.50),
    (9, 3, 9, 25, 2.15),
    (10, 3, 10, 4, 2.70),
    (11, 3, 11, 10, 2.30),
    (12, 3, 12, 3, 1.60),
    (13, 4, 13, 30, 1.80),
    (14, 4, 14, 4, 1.15),
    (15, 4, 15, 6, 2.00),
    (16, 4, 16, 8, 2.50),
    (17, 5, 17, 8, 4.50),
    (18, 5, 18, 20, 1.75),
    (19, 5, 19, 10, 1.20),
    (20, 6, 1, 20, 1.80),
    (21, 6, 2, 40, 2.15),
    (22, 6, 3, 30, 1.15),
    (23, 6, 4, 20, 1.85),
    (24, 7, 5, 8, 1.50),
    (25, 7, 6, 5, 0.80),
    (26, 7, 8, 4, 0.55),
    (27, 8, 9, 15, 2.20),
    (28, 8, 10, 2, 2.75),
    (29, 8, 11, 5, 2.35),
    (30, 9, 13, 20, 1.85),
    (31, 9, 14, 2, 1.20),
    (32, 9, 15, 4, 2.05),
    (33, 10, 17, 4, 4.55),
    (34, 10, 18, 10, 1.80),
    (35, 10, 19, 5, 1.25);

INSERT INTO sale (sale_id, sale_date, total_amount) VALUES
    (1, '2026-09-06 10:15:00', 15.95),
    (2, '2026-09-07 14:20:00', 12.96),
    (3, '2026-09-08 11:05:00', 10.97),
    (4, '2026-09-09 16:40:00', 13.46),
    (5, '2026-09-10 12:30:00', 13.97),
    (6, '2026-09-12 15:45:00', 22.94),
    (7, '2026-09-20 10:10:00', 67.82),
    (8, '2026-09-22 13:25:00', 8.47),
    (9, '2026-09-24 11:50:00', 17.95),
    (10, '2026-09-26 14:05:00', 27.93),
    (11, '2026-09-28 16:15:00', 25.92),
    (12, '2026-10-01 09:45:00', 52.35),
    (13, '2026-10-03 12:10:00', 16.46),
    (14, '2026-10-06 15:00:00', 22.46),
    (15, '2026-10-10 13:35:00', 25.43);

INSERT INTO sale_item (sale_item_id, sale_id, product_id, quantity, unit_price) VALUES
    (1, 1, 1, 2, 3.49),
    (2, 1, 2, 1, 3.99),
    (3, 1, 3, 1, 2.49),
    (4, 1, 5, 1, 2.49),
    (5, 2, 6, 1, 2.49),
    (6, 2, 7, 1, 3.49),
    (7, 2, 13, 2, 3.49),
    (8, 3, 10, 1, 4.49),
    (9, 3, 9, 1, 3.49),
    (10, 3, 12, 1, 2.99),
    (11, 4, 14, 1, 2.49),
    (12, 4, 15, 1, 3.99),
    (13, 4, 13, 2, 3.49),
    (14, 5, 17, 1, 5.00),
    (15, 5, 18, 2, 3.49),
    (16, 5, 8, 1, 1.99),
    (17, 6, 7, 3, 3.49),
    (18, 6, 16, 2, 4.99),
    (19, 6, 6, 1, 2.49),
    (20, 7, 4, 5, 3.49),
    (21, 7, 2, 10, 3.99),
    (22, 7, 1, 3, 3.49),
    (23, 8, 7, 1, 3.49),
    (24, 8, 5, 1, 2.99),
    (25, 8, 8, 1, 1.99),
    (26, 9, 12, 1, 2.99),
    (27, 9, 9, 2, 3.49),
    (28, 9, 11, 2, 3.99),
    (29, 10, 16, 3, 4.99),
    (30, 10, 14, 1, 2.49),
    (31, 10, 13, 3, 3.49),
    (32, 11, 5, 2, 2.99),
    (33, 11, 6, 1, 2.49),
    (34, 11, 13, 5, 3.49),
    (35, 12, 1, 4, 3.49),
    (36, 12, 2, 6, 3.99),
    (37, 12, 3, 3, 2.49),
    (38, 12, 4, 2, 3.49),
    (39, 13, 10, 2, 4.49),
    (40, 13, 11, 1, 3.99),
    (41, 13, 9, 1, 3.49),
    (42, 14, 17, 2, 5.00),
    (43, 14, 18, 3, 3.49),
    (44, 14, 8, 1, 1.99),
    (45, 15, 14, 1, 1.99),
    (46, 15, 15, 2, 3.99),
    (47, 15, 16, 1, 4.99),
    (48, 15, 13, 3, 3.49);