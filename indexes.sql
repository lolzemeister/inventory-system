-- indexes.sql
-- creates temp data to show how indexes can be used to speed up queries
-- show how UNIQUE indexes can be used to enforce uniqueness


-- uncomment following lines to rerun test
-- DROP INDEX idx_sale_date ON sale;
-- DROP INDEX temp_supplier_email ON supplier;
-- DELETE FROM sale WHERE sale_id >= 1000;


SET SESSION cte_max_recursion_depth = 20000;

-- slow query which will later be optimized with indexes

INSERT INTO sale (sale_id, sale_date, total_amount)
WITH RECURSIVE date_series AS (
    SELECT 1 as i
    UNION ALL
    SELECT i + 1 FROM date_series WHERE i < 10000

)

SELECT 1000 + i,
         DATE_ADD('2026-01-01 10:00:00', INTERVAL (i * 50) MINUTE), 2.00 + MOD(i, 50)
FROM date_series;

ANALYZE TABLE sale;

SELECT COUNT(*) AS total_sales FROM sale; -- expect 10015 (10000 created sales + 15 from dataset)

-- speed up query
EXPLAIN
SELECT sale_id, sale_date, total_amount
FROM sale
WHERE sale_date >= '2026-02-01 09:00:00' AND sale_date < '2026-02-02 09:00:00';
CREATE INDEX idx_sale_date ON sale(sale_date);

EXPLAIN
SELECT sale_id, sale_date, total_amount
FROM sale
WHERE sale_date >= '2026-02-01 09:00:00' AND sale_date < '2026-02-02 09:00:00';


-- uniqueness with unique index

CREATE UNIQUE INDEX temp_supplier_email ON supplier (contact_email);

EXPLAIN
SELECT * FROM supplier WHERE contact_email = 'orders@drinks.example';

-- duplicate email - test should fail (uncomment to test)
-- INSERT INTO supplier (supplier_id, supplier_name, contact_email)
-- VALUES (20, 'Duplicate Supplier', 'orders@drinks.example');


-- test should succeed, null will not be a duplicate
INSERT INTO supplier (supplier_id, supplier_name, contact_email)
VALUES (6, 'Null Email Test', NULL);


-- clean test data
DELETE FROM supplier WHERE supplier_id = 6;