-- create a retsocking list, adds products that are low in stock and have sold enough units before
-- then removes entires from the list for products that have been restock
-- and shows whats still on the list

CREATE TABLE restocking_list ( -- create a new restocking list
    product_id INT PRIMARY KEY,
    FOREIGN KEY (product_id) REFERENCES product(product_id)
);

INSERT INTO restocking_list (product_id) -- adds products to the restocking list that are low in stock and have sold enough units before
SELECT product_id
FROM product -- checks the product tables
WHERE stock_quantity <= 5 -- checks that produtcs that have 5 or less in stock
AND total_product_sales >= 5; -- and also check the proucts that have sold at least 5 units in total

DELETE FROM restocking_list  -- removes products from the restocking list that have been restocked
WHERE product_id IN ( -- removes an entry if its id appears in the list of products that have been restocked
    SELECT product_id
    FROM product 
    WHERE stock_quantity >= 10 -- returns id of products that have 10 or more units in stock
);

SELECT product_id, product_name, stock_quantity 
FROM product 
WHERE product_id IN ( -- gets the id of products that are still on the restocking list
    SELECT product_id
    FROM restocking_list
)
ORDER BY product_id; -- sorts the results by the product id in ascending order