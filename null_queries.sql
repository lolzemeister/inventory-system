-- null_queries.sql
-- show ternary logic (true, false, null/unknown)
-- how to write queries that handle null values


-- truth table
SELECT NULL = NULL AS null_equals_null, -- expect null
    --    NULL IS NULL AS null_is_null, -- expect true
    --    NULL IS NOT NULL AS null_is_not_null; -- expect false
       NULL <=> NULL AS null_safe_equals_null, -- expect true
       TRUE AND NULL AS true_and_null, -- expect null
       FALSE AND NULL AS false_and_null, -- expect false
       TRUE OR NULL AS true_or_null, -- expect true
       FALSE OR NULL AS false_or_null, -- expect null
       NOT NULL AS not_null; -- expect null

    
-- expect 0 rows, compare to null gives unknown
SELECT supplier_id, supplier_name, contact_email FROM supplier
WHERE contact_email = NULL;

-- expect 1 row, IS NULL gives true
SELECT supplier_id, supplier_name, contact_email FROM supplier
WHERE contact_email IS NULL;

-- expect 1 row, null safe operator 
SELECT supplier_id, supplier_name, contact_email FROM supplier
WHERE contact_email <=> NULL;


-- expect 1 row, supplier 2 (supplier 1 has the given website and 3,4,5 have null websites)
SELECT supplier_id, supplier_name FROM supplier
WHERE NOT (website_url = 'https://snacks.example');

-- expect 4 rows, supplier 1 has the given website and 2 has a different website, and 3,4,5 have null websites
SELECT supplier_id, supplier_name FROM supplier
WHERE website_url <> 'https://snacks.example' OR website_url IS NULL;

-- show all truth values for each row
SELECT supplier_id,
    (website_url = 'https://snacks.example') IS TRUE AS is_true,
    (website_url = 'https://snacks.example') IS FALSE AS is_false,
    (website_url = 'https://snacks.example') IS UNKNOWN AS is_unknown
FROM supplier;


-- expect 2 rows (3,4) (not 1,2, and 5 has a null email)
SELECT supplier_id, supplier_name FROM supplier
WHERE contact_email NOT IN (SELECT contact_email FROM supplier WHERE supplier_id IN (1,2));


-- same but now contains supplier 5 with a null email, expected 0 rows (not in a, NULL never true)
SELECT supplier_id, supplier_name FROM supplier
WHERE contact_email NOT IN (SELECT contact_email FROM supplier WHERE supplier_id IN (1,5));


-- expect 3 rows (2,3,4), fix first query to remove nulls 
SELECT supplier_id, supplier_name FROM supplier
WHERE contact_email NOT IN (SELECT contact_email FROM supplier WHERE supplier_id IN (1,5) AND contact_email IS NOT NULL);


-- expect 3 rows (2,3,4) using not exists (null safe)
SELECT s.supplier_id, s.supplier_name
FROM supplier s
WHERE s.contact_email IS NOT NULL 
    AND NOT EXISTS (SELECT 1 FROM supplier t WHERE t.supplier_id IN (1,5) AND t.contact_email = s.contact_email);



-- Outer joins produce nulls
-- expected 20 rows, produce nulls (units_raw in 19 and 20 should be null, total_units_sold should be 0)
SELECT p.product_id, p.product_name,
    SUM(si.quantity) AS units_raw,
    COALESCE(SUM(si.quantity), 0) AS total_units_sold
FROM product p
LEFT OUTER JOIN sale_item si ON si.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY p.product_id;


