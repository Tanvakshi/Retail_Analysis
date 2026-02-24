-- RETAIL AUDIT - Identify profit-traps 
-- - Top 3 loss making products - sales report - 1) category-wise, 2) City wise
-- chart Discount_impact (sales vs. profit)
-- build dashboard to show leadership which inventory to liquidate 

SELECT * FROM retail_analysis.samplesuperstore;
----------------------------------------------------------------
with Categorywise_Profit as
(
Select 
	Category,
    `Sub-Category`,
	sum(Profit) as `total profit per item type`,
    DENSE_RANK() OVER(PARTITION BY Category ORDER BY SUM(Profit) ASC) AS product_rank_Categorywise
from samplesuperstore
group by Category, `Sub-Category`
)
,

Citywise_Profit as
(
Select 
    City,
    Category,
    `Sub-Category`,
	sum(Profit) as `total profit per City`,
    DENSE_RANK() OVER(PARTITION BY City ORDER BY SUM(Profit) ASC) AS product_rank_Citywise
from samplesuperstore
group by City, Category, `Sub-Category`
)
, 

Discount_Impact AS 
(
    SELECT 
        Discount, 
        SUM(Profit) AS Total_Profit,
        SUM(Sales) AS Total_Sales
    FROM samplesuperstore
    GROUP BY Discount
)
 SELECT * FROM Categorywise_Profit WHERE product_rank_Categorywise < 4;
----------------------------------------

with Citywise_Profit as
(
Select 
    City,
    Category,
    `Sub-Category`,
	sum(Profit) as `total profit per City`,
    DENSE_RANK() OVER(PARTITION BY City ORDER BY SUM(Profit) ASC) AS product_rank_Citywise
from samplesuperstore
group by City, Category, `Sub-Category`
)
SELECT * FROM Citywise_Profit WHERE product_rank_Citywise<4
 ;
----------------------------------------------------
 
WITH Discount_Impact AS 
(
    SELECT 
        Discount, 
        SUM(Profit) AS Total_Profit,
        SUM(Sales) AS Total_Sales
    FROM samplesuperstore
    GROUP BY Discount
)
 SELECT * FROM Discount_Impact 
 group by Discount
 Order by Discount asc;
