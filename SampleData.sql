--Dataset by ChatGPT 6 Astra

-- Sample inventory dataset for testing and demonstrations.
-- All suppliers and contact details are fictional. Monetary values are CAD.
-- Prerequisite: the seven tables from Table.sql must already exist.
-- Table.sql currently has a trailing comma in product and lacks statement
-- terminators; those existing schema issues are not changed by this data file.
-- Run once against empty tables; fixed primary keys make this non-idempotent.
-- Only INSERT statements are executed. No tables or existing rows are changed.
-- Parent rows precede their children for compatibility with foreign keys.
-- Stock is a snapshot after the last sale on 2026-10-10, assuming zero opening
-- stock and only the receipts and sales below (no returns or adjustments).
-- Product quantities already include these transactions; load into plain tables
-- without stock-adjustment triggers to avoid applying the movements twice.
-- Sale/receipt totals equal quantity * unit price/cost summed over their lines;
-- no additional tax, shipping, or header-level discounts are included.
-- Historical sale prices and receipt costs deliberately vary in a few cases.
--
-- Demo cases:
--   Product 7: sold out (0 units); product 12: low stock (1 unit).
--   Product 16: low stock (2 units).
--   Product 19: stocked but never sold (15 units).
--   Product 20: new catalogue entry, no receipts or sales (0 units).
--   Suppliers 3, 4, and 5: missing optional contact fields (NULL).
--   Product 19: apostrophe in its name, correctly escaped as a SQL literal.
--   Transactions span September and October for date/grouping demonstrations.
--
-- Row counts: supplier=5, category=5, product=20, stock_receipt=10, stock_receipt_item=35, sale=15, sale_item=48.

INSERT INTO supplier (supplier_id, supplier_name, contact_email, contact_phone, website_url) VALUES
    (1, 'Cedar Desk Supplies', 'orders@cedardesk.example', '250-555-0101', 'https://cedardesk.example'),
    (2, 'Harbor Tech Distribution', 'sales@harbortech.example', '250-555-0102', 'https://harbortech.example'),
    (3, 'Island Storage Wholesale', 'orders@islandstorage.example', '250-555-0103', NULL),
    (4, 'Pacific Networking', 'sales@pacificnetworking.example', NULL, 'https://pacificnetworking.example'),
    (5, 'Coastline Office Comforts', NULL, '250-555-0105', NULL);

INSERT INTO category (category_id, category_name) VALUES
    (1, 'Stationery'),
    (2, 'Computer Accessories'),
    (3, 'Data Storage'),
    (4, 'Networking'),
    (5, 'Desk Essentials');

INSERT INTO product (product_id, product_name, supplier_id, category_id, selling_price, stock_quantity) VALUES
    (1, 'A5 Notebook', 1, 1, 6.99, 61),
    (2, 'Ballpoint Pens - 12 Pack', 1, 1, 4.99, 103),
    (3, 'Sticky Notes - 3 Pack', 1, 1, 3.49, 86),
    (4, 'A4 Copy Paper - 500 Sheets', 1, 1, 8.99, 53),
    (5, 'Wireless Mouse', 2, 2, 24.99, 16),
    (6, 'USB Keyboard', 2, 2, 34.99, 10),
    (7, 'USB-C Hub', 2, 2, 49.99, 0),
    (8, 'Aluminum Laptop Stand', 2, 2, 39.99, 7),
    (9, '64 GB USB Flash Drive', 3, 3, 12.99, 36),
    (10, '1 TB External SSD', 3, 3, 109.99, 3),
    (11, '128 GB SD Card', 3, 3, 24.99, 12),
    (12, '2 TB External Hard Drive', 3, 3, 79.99, 1),
    (13, 'Cat6 Ethernet Cable - 2 m', 4, 4, 8.99, 35),
    (14, 'Dual-Band Wi-Fi Router', 4, 4, 89.99, 3),
    (15, '5-Port Gigabit Switch', 4, 4, 39.99, 7),
    (16, 'USB Wi-Fi Adapter', 4, 4, 19.99, 2),
    (17, 'LED Desk Lamp', 5, 5, 29.99, 9),
    (18, 'Large Mouse Pad', 5, 5, 9.99, 25),
    (19, 'Typist''s Wrist Rest', 5, 5, 14.99, 15),
    (20, 'Bamboo Desk Organizer', 5, 5, 19.99, 0);

INSERT INTO stock_receipt (stock_receipt_id, receipt_date, supplier_id, total_cost) VALUES
    (1, '2026-09-01 09:00:00', 1, 592.00),
    (2, '2026-09-02 09:30:00', 2, 623.00),
    (3, '2026-09-03 10:00:00', 3, 748.50),
    (4, '2026-09-04 10:30:00', 4, 549.00),
    (5, '2026-09-05 11:00:00', 5, 278.00),
    (6, '2026-09-15 09:00:00', 1, 289.50),
    (7, '2026-09-16 09:30:00', 2, 309.00),
    (8, '2026-09-17 10:00:00', 3, 302.25),
    (9, '2026-09-18 10:30:00', 4, 267.00),
    (10, '2026-09-19 11:00:00', 5, 139.00);

INSERT INTO stock_receipt_item (stock_receipt_item_id, stock_receipt_id, product_id, quantity, unit_cost) VALUES
    (1, 1, 1, 50, 3.00),
    (2, 1, 2, 80, 2.00),
    (3, 1, 3, 60, 1.20),
    (4, 1, 4, 40, 5.25),
    (5, 2, 5, 12, 14.00),
    (6, 2, 6, 8, 21.00),
    (7, 2, 7, 5, 31.00),
    (8, 2, 8, 6, 22.00),
    (9, 3, 9, 25, 6.50),
    (10, 3, 10, 4, 75.00),
    (11, 3, 11, 10, 13.00),
    (12, 3, 12, 3, 52.00),
    (13, 4, 13, 30, 3.50),
    (14, 4, 14, 4, 55.00),
    (15, 4, 15, 6, 24.00),
    (16, 4, 16, 8, 10.00),
    (17, 5, 17, 8, 16.00),
    (18, 5, 18, 20, 4.00),
    (19, 5, 19, 10, 7.00),
    (20, 6, 1, 20, 3.10),
    (21, 6, 2, 40, 2.00),
    (22, 6, 3, 30, 1.25),
    (23, 6, 4, 20, 5.50),
    (24, 7, 5, 8, 14.50),
    (25, 7, 6, 5, 21.00),
    (26, 7, 8, 4, 22.00),
    (27, 8, 9, 15, 6.25),
    (28, 8, 10, 2, 73.00),
    (29, 8, 11, 5, 12.50),
    (30, 9, 13, 20, 3.25),
    (31, 9, 14, 2, 54.00),
    (32, 9, 15, 4, 23.50),
    (33, 10, 17, 4, 16.00),
    (34, 10, 18, 10, 4.00),
    (35, 10, 19, 5, 7.00);

INSERT INTO sale (sale_id, sale_date, total_amount) VALUES
    (1, '2026-09-06 10:15:00', 45.45),
    (2, '2026-09-07 14:20:00', 102.96),
    (3, '2026-09-08 11:05:00', 202.97),
    (4, '2026-09-09 16:40:00', 147.96),
    (5, '2026-09-10 12:30:00', 89.96),
    (6, '2026-09-12 15:45:00', 224.94),
    (7, '2026-09-20 10:10:00', 115.82),
    (8, '2026-09-22 13:25:00', 114.97),
    (9, '2026-09-24 11:50:00', 155.95),
    (10, '2026-09-26 14:05:00', 176.93),
    (11, '2026-09-28 16:15:00', 129.92),
    (12, '2026-10-01 09:45:00', 86.35),
    (13, '2026-10-03 12:10:00', 257.96),
    (14, '2026-10-06 15:00:00', 129.94),
    (15, '2026-10-10 13:35:00', 211.93);

INSERT INTO sale_item (sale_item_id, sale_id, product_id, quantity, unit_price) VALUES
    (1, 1, 1, 2, 6.99),
    (2, 1, 2, 1, 4.99),
    (3, 1, 3, 1, 3.49),
    (4, 1, 5, 1, 22.99),
    (5, 2, 6, 1, 34.99),
    (6, 2, 7, 1, 49.99),
    (7, 2, 13, 2, 8.99),
    (8, 3, 10, 1, 109.99),
    (9, 3, 9, 1, 12.99),
    (10, 3, 12, 1, 79.99),
    (11, 4, 14, 1, 89.99),
    (12, 4, 15, 1, 39.99),
    (13, 4, 13, 2, 8.99),
    (14, 5, 17, 1, 29.99),
    (15, 5, 18, 2, 9.99),
    (16, 5, 8, 1, 39.99),
    (17, 6, 7, 3, 49.99),
    (18, 6, 16, 2, 19.99),
    (19, 6, 6, 1, 34.99),
    (20, 7, 4, 5, 8.99),
    (21, 7, 2, 10, 4.99),
    (22, 7, 1, 3, 6.99),
    (23, 8, 7, 1, 49.99),
    (24, 8, 5, 1, 24.99),
    (25, 8, 8, 1, 39.99),
    (26, 9, 12, 1, 79.99),
    (27, 9, 9, 2, 12.99),
    (28, 9, 11, 2, 24.99),
    (29, 10, 16, 3, 19.99),
    (30, 10, 14, 1, 89.99),
    (31, 10, 13, 3, 8.99),
    (32, 11, 5, 2, 24.99),
    (33, 11, 6, 1, 34.99),
    (34, 11, 13, 5, 8.99),
    (35, 12, 1, 4, 6.99),
    (36, 12, 2, 6, 4.99),
    (37, 12, 3, 3, 3.49),
    (38, 12, 4, 2, 8.99),
    (39, 13, 10, 2, 109.99),
    (40, 13, 11, 1, 24.99),
    (41, 13, 9, 1, 12.99),
    (42, 14, 17, 2, 29.99),
    (43, 14, 18, 3, 9.99),
    (44, 14, 8, 1, 39.99),
    (45, 15, 14, 1, 84.99),
    (46, 15, 15, 2, 39.99),
    (47, 15, 16, 1, 19.99),
    (48, 15, 13, 3, 8.99);
