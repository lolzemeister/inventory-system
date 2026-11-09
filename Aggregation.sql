-- checks the top selling categoires with at least 20 items sold in total, and shows the number of distinct products sold in each category

SELECT
    category.category_id,       -- show id of each category
    category.category_name, -- show name of each category
    COUNT(DISTINCT product.product_id) AS distinct_product_count, -- counts how many different products in the category sold at least once
    SUM(sale_item.quantity) AS total_quantity_sold -- sums up the total quantity of products sold in each distinct category
FROM category -- select from the category table
JOIN product ON product.category_id = category.category_id --matches each product to its category using the category_id
JOIN sale_item ON sale_item.product_id = product.product_id --matches each sale item to its product using the product_id
GROUP BY category.category_id -- puts all sale items for the same category into one group to get one summary for each category
HAVING SUM(sale_item.quantity) > 20 -- keeps the categories that have sold more than 20 items in total
ORDER BY total_quantity_sold DESC; -- shows the hgihest totals first. 
