-- finds sales with at least one iteem in the sale that has a quantity of 5 or more, and shows the sale id, date, and total amount of each sale

SELECT 
    sale.sale_id,   -- show the id of each sale
    sale.sale_date, -- show the date of each sale
    sale.total_amount -- show the total amount of each sale
FROM sale
WHERE EXISTS ( -- keeps the current sale if the subquery finds at least one sale item with a quantity of 5 or more
    SELECT sale_item.sale_id -- select the sale id from the sale_item table
    FROM sale_item -- looks in the sale item table where each row is a line on the receipt for a sale
    WHERE sale_item.sale_id = sale.sale_id -- looks only at the sale itesm that belong to the current sale
    AND sale_item.quantity >= 5 -- keeps the sale if at least one of the items in the sale has a quantity of 5 or more
)
ORDER BY sale.sale_id;
 