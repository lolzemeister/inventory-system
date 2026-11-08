-- outer_join_queries.sql
-- show that subquery can be rewritten as an outer join
-- use to find products that have not been sold


-- subquery: expected result: 2 rows (product_id 19 and 20)(not been sold)
SELECT product_id, product_name
FROM product
WHERE product_id NOT IN (
    SELECT DISTINCT product_id FROM sale_item);

-- equivalent left outer join
SELECT p.product_id, p.product_name
FROM product p 
LEFT OUTER JOIN sale_item si ON p.product_id = si.product_id
WHERE si.sale_item_id IS NULL;


-- join showing units sold per item (19 and 20 should show 0 units)
SELECT p.product_id, p.product_name, COUNT(si.sale_item_id) AS units_sold
FROM product p
LEFT OUTER JOIN sale_item si ON p.product_id = si.product_id
GROUP BY p.product_id, p.product_name
ORDER BY p.product_id;


-- products that have not been received in stock (not in stock_receipt_item) 
-- should show 1 row (product_id 20)
SELECT p.product_id, p.product_name
FROM product p
LEFT OUTER JOIN stock_receipt_item sri ON sri.product_id = p.product_id
WHERE sri.stock_receipt_item_id IS NULL;

