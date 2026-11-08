-- Convenience store sample dataset for testing and demonstrations.
-- All suppliers are fictional and prices are illustrative CAD amounts.
-- Run once against empty tables after Table.sql; IDs are fixed.
-- Supplier IDs 6 and 20 are reserved for tests in indexes.sql. The bakery uses 9.
-- Sale IDs 1001-11000 are reserved for that script's generated test sales.
-- 8 suppliers, 8 categories, 32 products, 20 receipts, 70 receipt items,
-- 35 sales, 118 sale items and 1 inventory summary (292 rows total).
-- Activity spans 2026-09-01 through 2026-11-07; dates are local store time.
-- Stock and summary fields are snapshots after the final sale, assuming zero
-- opening stock and only these receipts and sales (no returns or adjustments).
-- Do not use stock or sales-summary adjustment triggers when loading snapshots.
-- Product, category and inventory sales counters all mean UNITS SOLD, not
-- transaction counts or revenue. Header totals sum quantity * unit cost/price.
-- Inventory value is remaining stock at CURRENT RETAIL prices, not cost value.
-- Revenue sums sales; expenses sum stock purchases only, excluding overhead.
-- No sales taxes or separate discount calculations are included. Stored sale
-- prices are historical: cola was $2.49 in sale 1 (currently $2.99); chocolate
-- was $1.99 in sale 15 (currently $2.49). Receipt costs also vary over time.
-- Lottery tickets represent physical scratch-ticket stock, not draw/payouts.
-- Coffee, tea and slushies are per-serving items; ingredients are out of scope.
-- Fresh food batches are received and sold on the same day; expiry is not tracked.
-- IDs identify rows; use timestamps, not IDs, to order inventory movements.
-- Demo cases:
--   * Product 7 sells out on Sep 22, is restocked Oct 11, and sells out Nov 6.
--   * Products 12, 25, 26 and 27 also end sold out; 14, 16 and 30 have 1 left.
--   * Products 19 and 31 have receipts but no sales; 20 and 32 have no activity.
--   * Category 8 has products and stock but no sales; supplier 8 has no products
--     or receipts. Supplier 5 spans categories 5, 7 and 8; category 7 uses two suppliers.
--   * Sale 17 buys one unit; sale 32 buys several units of a single product.
--   * Several dates have multiple sales; mixed-category baskets and larger
--     purchases support daily/monthly, category and supplier reporting.
--   * Optional contact fields include NULL values for missing supplier details.
-- Execute with a client that stops on SQL errors; roll back if loading fails.

BEGIN;

INSERT INTO supplier (supplier_id, supplier_name, contact_email, contact_phone, website_url) VALUES
    (1, 'Pacific Snack Distributors', 'orders@snacks.example', '250-555-0101', 'https://snacks.example'),
    (2, 'Coastal Beverage Supply', 'orders@drinks.example', '250-555-0102', 'https://drinks.example'),
    (3, 'Island Frozen Treats Wholesale', 'orders@frozen.example', '250-555-0103', NULL),
    (4, 'Victoria Candy & Bakery Supply', 'orders@candy.example', NULL, NULL),
    (5, 'West Coast General Merchandise', NULL, '250-555-0105', NULL),
    (7, 'Cedar Household Supplies', 'orders@household.example', '250-555-0107', NULL),
    (8, 'North Shore Backup Wholesale', NULL, '250-555-0108', NULL),
    (9, 'Harbour Bakery & Fresh Foods', 'orders@bakery.example', '250-555-0106', 'https://bakery.example');

INSERT INTO category (category_id, category_name, category_total_sales) VALUES
    (1, 'Chips & Savoury Snacks', 83),
    (2, 'Drinks, Coffee & Tea', 63),
    (3, 'Ice Cream & Frozen Treats', 41),
    (4, 'Candy, Chocolate & Cookies', 74),
    (5, 'Lottery & Convenience Essentials', 16),
    (6, 'Bakery & Fresh Food', 37),
    (7, 'Household & Personal Care', 20),
    (8, 'Seasonal Supplies', 0);

INSERT INTO product (product_id, product_name, supplier_id, category_id, selling_price, stock_quantity, total_product_sales) VALUES
    (1, 'Classic Potato Chips 200 g', 1, 1, 3.49, 82, 18),
    (2, 'Nacho Cheese Tortilla Chips 235 g', 1, 1, 3.99, 129, 31),
    (3, 'Salted Pretzels 150 g', 1, 1, 2.49, 82, 8),
    (4, 'Butter Popcorn 100 g', 1, 1, 3.49, 50, 10),
    (5, 'Cola 500 mL', 2, 2, 2.99, 46, 10),
    (6, 'Fresh Brewed Coffee 12 oz', 2, 2, 2.49, 23, 10),
    (7, 'Blue Raspberry Slushie 16 oz', 2, 2, 3.49, 0, 15),
    (8, 'Black Tea 12 oz', 2, 2, 1.99, 16, 6),
    (9, 'Vanilla Ice Cream Bar', 3, 3, 3.49, 32, 8),
    (10, 'Chocolate Ice Cream Cone', 3, 3, 4.49, 2, 12),
    (11, 'Strawberry Ice Cream Cup', 3, 3, 3.99, 15, 6),
    (12, 'Ice Cream Sandwich', 3, 3, 2.99, 0, 15),
    (13, 'Gummy Bears 150 g', 4, 4, 3.49, 47, 23),
    (14, 'Milk Chocolate Bar 100 g', 4, 4, 2.49, 1, 25),
    (15, 'Assorted Candy Mix 200 g', 4, 4, 3.99, 13, 9),
    (16, 'Chocolate Chip Cookies 6-Pack', 4, 4, 4.99, 1, 17),
    (17, 'Scratch Lottery Ticket - $5', 5, 5, 5.00, 13, 9),
    (18, 'Pocket Notebook', 5, 5, 3.49, 33, 7),
    (19, 'Pencil Pack - 4 Count', 5, 5, 2.49, 15, 0),
    (20, 'USB Flash Drive 32 GB', 5, 5, 12.99, 0, 0),
    (21, 'Sparkling Water 500 mL', 2, 2, 1.99, 21, 15),
    (22, 'Orange Juice 1 L', 2, 2, 4.99, 11, 7),
    (23, 'Trail Mix 150 g', 1, 1, 4.49, 12, 8),
    (24, 'Roasted Peanuts 150 g', 1, 1, 2.99, 8, 8),
    (25, 'Blueberry Muffin', 9, 6, 2.99, 0, 16),
    (26, 'Cheese Croissant', 9, 6, 3.99, 0, 11),
    (27, 'Turkey Sandwich', 9, 6, 6.49, 0, 10),
    (28, 'AA Batteries 4-Pack', 5, 7, 7.99, 9, 3),
    (29, 'Travel Tissue Pack', 7, 7, 1.49, 24, 6),
    (30, 'Hand Sanitizer 60 mL', 7, 7, 3.99, 1, 11),
    (31, 'Pocket Rain Poncho', 5, 8, 5.99, 6, 0),
    (32, 'Knit Gloves - Pair', 5, 8, 8.99, 0, 0);

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
    (10, '2026-09-19 11:00:00', 5, 42.45),
    (11, '2026-10-11 08:00:00', 2, 120.40),
    (12, '2026-10-11 09:00:00', 1, 210.10),
    (13, '2026-10-12 07:00:00', 3, 56.60),
    (14, '2026-10-12 07:30:00', 4, 111.10),
    (15, '2026-10-12 06:30:00', 9, 24.35),
    (16, '2026-10-13 07:30:00', 5, 128.00),
    (17, '2026-10-13 08:00:00', 7, 40.80),
    (18, '2026-10-20 06:30:00', 9, 28.30),
    (19, '2026-10-29 08:00:00', 2, 45.00),
    (20, '2026-11-01 06:30:00', 9, 20.60);

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
    (35, 10, 19, 5, 1.25),
    (36, 11, 7, 10, 1.20),
    (37, 11, 5, 24, 1.50),
    (38, 11, 6, 20, 0.80),
    (39, 11, 8, 12, 0.55),
    (40, 11, 21, 24, 0.75),
    (41, 11, 22, 12, 2.65),
    (42, 12, 1, 30, 1.85),
    (43, 12, 2, 40, 2.20),
    (44, 12, 23, 20, 2.25),
    (45, 12, 24, 16, 1.35),
    (46, 13, 10, 8, 2.80),
    (47, 13, 11, 6, 2.40),
    (48, 13, 12, 12, 1.65),
    (49, 14, 14, 20, 1.20),
    (50, 14, 15, 12, 2.05),
    (51, 14, 16, 10, 2.55),
    (52, 14, 13, 20, 1.85),
    (53, 15, 25, 6, 1.20),
    (54, 15, 26, 4, 1.85),
    (55, 15, 27, 3, 3.25),
    (56, 16, 17, 10, 4.55),
    (57, 16, 18, 10, 1.80),
    (58, 16, 28, 12, 4.00),
    (59, 16, 31, 6, 2.75),
    (60, 17, 29, 30, 0.60),
    (61, 17, 30, 12, 1.90),
    (62, 18, 25, 6, 1.25),
    (63, 18, 26, 4, 1.90),
    (64, 18, 27, 4, 3.30),
    (65, 19, 5, 12, 1.55),
    (66, 19, 21, 12, 0.80),
    (67, 19, 22, 6, 2.80),
    (68, 20, 25, 4, 1.25),
    (69, 20, 26, 3, 1.90),
    (70, 20, 27, 3, 3.30);

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
    (15, '2026-10-10 13:35:00', 25.43),
    (16, '2026-10-11 10:15:00', 13.46),
    (17, '2026-10-11 16:45:00', 1.99),
    (18, '2026-10-12 08:15:00', 18.45),
    (19, '2026-10-12 12:30:00', 49.88),
    (20, '2026-10-13 09:10:00', 14.96),
    (21, '2026-10-13 18:40:00', 32.43),
    (22, '2026-10-15 13:20:00', 32.38),
    (23, '2026-10-18 10:05:00', 31.43),
    (24, '2026-10-20 08:20:00', 25.43),
    (25, '2026-10-20 12:15:00', 54.38),
    (26, '2026-10-22 16:30:00', 39.40),
    (27, '2026-10-25 14:10:00', 60.32),
    (28, '2026-10-28 11:35:00', 34.86),
    (29, '2026-10-30 17:50:00', 73.79),
    (30, '2026-10-31 18:25:00', 49.92),
    (31, '2026-11-01 12:10:00', 53.38),
    (32, '2026-11-02 09:05:00', 7.47),
    (33, '2026-11-04 14:45:00', 87.75),
    (34, '2026-11-06 16:20:00', 40.37),
    (35, '2026-11-07 19:10:00', 123.66);

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
    (48, 15, 13, 3, 3.49),
    (49, 16, 7, 2, 3.49),
    (50, 16, 21, 1, 1.99),
    (51, 16, 23, 1, 4.49),
    (52, 17, 21, 1, 1.99),
    (53, 18, 25, 1, 2.99),
    (54, 18, 26, 1, 3.99),
    (55, 18, 27, 1, 6.49),
    (56, 18, 6, 2, 2.49),
    (57, 19, 25, 5, 2.99),
    (58, 19, 26, 3, 3.99),
    (59, 19, 27, 2, 6.49),
    (60, 19, 22, 2, 4.99),
    (61, 20, 28, 1, 7.99),
    (62, 20, 29, 2, 1.49),
    (63, 20, 30, 1, 3.99),
    (64, 21, 17, 2, 5.00),
    (65, 21, 1, 3, 3.49),
    (66, 21, 5, 2, 2.99),
    (67, 21, 24, 2, 2.99),
    (68, 22, 7, 3, 3.49),
    (69, 22, 12, 3, 2.99),
    (70, 22, 14, 2, 2.49),
    (71, 22, 21, 4, 1.99),
    (72, 23, 16, 2, 4.99),
    (73, 23, 15, 2, 3.99),
    (74, 23, 23, 3, 4.49),
    (75, 24, 25, 2, 2.99),
    (76, 24, 26, 2, 3.99),
    (77, 24, 27, 1, 6.49),
    (78, 24, 6, 2, 2.49),
    (79, 25, 25, 4, 2.99),
    (80, 25, 26, 2, 3.99),
    (81, 25, 27, 3, 6.49),
    (82, 25, 22, 3, 4.99),
    (83, 26, 10, 3, 4.49),
    (84, 26, 11, 3, 3.99),
    (85, 26, 9, 4, 3.49),
    (86, 27, 2, 6, 3.99),
    (87, 27, 3, 4, 2.49),
    (88, 27, 4, 3, 3.49),
    (89, 27, 24, 3, 2.99),
    (90, 27, 18, 2, 3.49),
    (91, 28, 7, 2, 3.49),
    (92, 28, 5, 4, 2.99),
    (93, 28, 8, 3, 1.99),
    (94, 28, 21, 5, 1.99),
    (95, 29, 13, 8, 3.49),
    (96, 29, 14, 6, 2.49),
    (97, 29, 15, 4, 3.99),
    (98, 29, 16, 3, 4.99),
    (99, 30, 17, 4, 5.00),
    (100, 30, 28, 2, 7.99),
    (101, 30, 29, 4, 1.49),
    (102, 30, 30, 2, 3.99),
    (103, 31, 25, 4, 2.99),
    (104, 31, 26, 3, 3.99),
    (105, 31, 27, 3, 6.49),
    (106, 31, 22, 2, 4.99),
    (107, 32, 6, 3, 2.49),
    (108, 33, 1, 6, 3.49),
    (109, 33, 2, 8, 3.99),
    (110, 33, 23, 4, 4.49),
    (111, 33, 24, 3, 2.99),
    (112, 33, 21, 4, 1.99),
    (113, 34, 12, 10, 2.99),
    (114, 34, 7, 3, 3.49),
    (115, 35, 10, 6, 4.49),
    (116, 35, 14, 14, 2.49),
    (117, 35, 16, 6, 4.99),
    (118, 35, 30, 8, 3.99);

INSERT INTO inventory (inventory_id, inventory_name, total_quantity_in_stock, total_inventory_sales, total_inventory_value, total_revenue, total_expenses) VALUES
    (1, 'Main Store Inventory', 692, 334, 2349.71, 1200.75, 1828.85);

COMMIT;

-- Expected results for the companion demos with this expanded dataset.
-- Their original expected-count comments describe the smaller dataset.
-- Run null_queries.sql and outer_join_queries.sql on the base data; IDs below
-- describe result sets, not guaranteed row order unless a query uses ORDER BY.
--
-- null_queries.sql:
--   contact_email = NULL: 0 rows.
--   contact_email IS NULL or <=> NULL: 2 rows (suppliers 5 and 8).
--   NOT (website_url = 'https://snacks.example'): 2 rows (suppliers 2 and 9).
--   website_url <> that URL OR website_url IS NULL: 7 rows (all except 1).
--   Website truth values: TRUE for 1, FALSE for 2 and 9, UNKNOWN for 3,4,5,7,8.
--   Email NOT IN suppliers (1,2): 4 rows (suppliers 3,4,7,9).
--   Email NOT IN suppliers (1,5), including NULL: 0 rows.
--   Filtering NULL from that subquery, or the guarded NOT EXISTS version:
--     5 rows (suppliers 2,3,4,7,9).
--   Product sales summary: 32 rows; products 19,20,31,32 have NULL units_raw
--     and 0 total_units_sold.
--
-- outer_join_queries.sql:
--   Both unsold-product queries: 4 rows (products 19,20,31,32).
--   Product sale-line counts: 32 rows, with zero for those same four products.
--     COUNT(si.sale_item_id) counts sale lines, despite the units_sold alias;
--     SUM(si.quantity) gives units sold (product 1 has 5 lines and 18 units).
--   Products without receipts: 2 rows (products 20 and 32).
--
-- indexes.sql:
--   35 base sales + 10000 generated sales = 10035 rows.
--   All non-NULL supplier emails are unique; suppliers 5 and 8 have NULL emails.
--   The temporary supplier 6 can be inserted with another NULL email and deleted
--     without affecting seeded suppliers or their products and receipts.
--   Generated sales have no items and are intentionally excluded from this
--     snapshot. Run the checks below before the index demo or after removing
--     its generated sales (IDs 1001-11000).

-- Optional read-only checks: run these separately after loading.
-- Each query should return zero rows. These do not maintain snapshot fields
-- after future transactions; recompute those fields when changing the dataset.
/*
-- Product stock and units sold must reconcile to transaction lines.
SELECT p.product_id, p.stock_quantity, p.total_product_sales
FROM product p
WHERE p.stock_quantity <>
    (SELECT COALESCE(SUM(r.quantity), 0) FROM stock_receipt_item r WHERE r.product_id = p.product_id)
    - (SELECT COALESCE(SUM(s.quantity), 0) FROM sale_item s WHERE s.product_id = p.product_id)
   OR p.total_product_sales <>
    (SELECT COALESCE(SUM(s.quantity), 0) FROM sale_item s WHERE s.product_id = p.product_id);

-- Category counters include all units sold by their products.
SELECT c.category_id
FROM category c
WHERE c.category_total_sales <>
    (SELECT COALESCE(SUM(s.quantity), 0)
     FROM product p JOIN sale_item s ON s.product_id = p.product_id
     WHERE p.category_id = c.category_id);

-- Header amounts must match their lines; ROUND avoids floating-point noise.
SELECT s.sale_id
FROM sale s
WHERE ROUND(s.total_amount, 2) <>
    (SELECT ROUND(COALESCE(SUM(i.quantity * i.unit_price), 0), 2)
     FROM sale_item i WHERE i.sale_id = s.sale_id);

SELECT r.stock_receipt_id
FROM stock_receipt r
WHERE ROUND(r.total_cost, 2) <>
    (SELECT ROUND(COALESCE(SUM(i.quantity * i.unit_cost), 0), 2)
     FROM stock_receipt_item i WHERE i.stock_receipt_id = r.stock_receipt_id);

-- Every receipt must come from the product's assigned supplier.
SELECT i.stock_receipt_item_id
FROM stock_receipt_item i
JOIN stock_receipt r ON r.stock_receipt_id = i.stock_receipt_id
JOIN product p ON p.product_id = i.product_id
WHERE r.supplier_id <> p.supplier_id;

-- The single-store summary must reconcile to the detailed data.
SELECT inventory_id
FROM inventory
WHERE total_quantity_in_stock <> (SELECT COALESCE(SUM(stock_quantity), 0) FROM product)
   OR total_inventory_sales <> (SELECT COALESCE(SUM(quantity), 0) FROM sale_item)
   OR ROUND(total_inventory_value, 2) <>
      (SELECT ROUND(COALESCE(SUM(stock_quantity * selling_price), 0), 2) FROM product)
   OR ROUND(total_revenue, 2) <> (SELECT ROUND(COALESCE(SUM(total_amount), 0), 2) FROM sale)
   OR ROUND(total_expenses, 2) <> (SELECT ROUND(COALESCE(SUM(total_cost), 0), 2) FROM stock_receipt);
*/
