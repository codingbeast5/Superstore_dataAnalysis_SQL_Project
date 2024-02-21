-- Q1 Establish the relationship between the tables as per the ER diagram.

USE superstore1

ALTER TABLE orderslist
ALTER COLUMN orderID nvarchar(255) NOT NULL

ALTER TABLE orderslist
ADD CONSTRAINT pk_orderID PRIMARY KEY (orderID)

ALTER TABLE EachOrderBreakdown
ALTER COLUMN orderID nvarchar(255) NOT NULL

ALTER TABLE EachOrderBreakdown
ADD CONSTRAINT fk_orderID FOREIGN KEY (orderID) REFERENCES orderslist(orderID)

-- Q2 Split City State Country into 3 individual columns namely ‘City’, ‘State’, ‘Country’.

ALTER TABLE orderslist
ADD city nvarchar(255),
    state nvarchar(255),
	country nvarchar(255);

UPDATE orderslist
SET city = PARSENAME(REPLACE([CITY STATE COUNTRY],',','.'), 3),
    state = PARSENAME(REPLACE([CITY STATE COUNTRY],',','.'), 2),
    country = PARSENAME(REPLACE([CITY STATE COUNTRY],',','.'), 1);

SELECT * FROM orderslist

ALTER TABLE orderslist
DROP COLUMN [city state country]

-- Q3 Add a new Category Column using the following mapping as per the first 3 characters in the
-- Product Name Column:
  -- a. TEC- Technology
  -- b. OFS – Office Supplies
  -- c. FUR - Furniture

SELECT * FROM EachOrderBreakdown

ALTER TABLE EachOrderBreakdown
ADD category NVARCHAR(255)

UPDATE EachOrderBreakdown
SET category = CASE WHEN LEFT(ProductName, 3) = 'OFS' THEN 'Office Supplies'
                    WHEN LEFT(ProductName, 3) = 'TEC' THEN 'Technology'
					WHEN LEFT(ProductName, 3) = 'FUR' THEN 'Furniture'
				END;

--Q4 Delete the first 4 characters from the ProductName Column.

UPDATE  EachOrderBreakdown
SET productname = SUBSTRING(productname, 5, LEN(productname)-4)

UPDATE  EachOrderBreakdown
SET productname = SUBSTRING(productname, 2, LEN(productname)-1)
WHERE category = 'Technology'

-- Q5 Remove duplicate rows from EachOrderBreakdown table, if all column values are matching

with  cte as(
SELECT *, ROW_NUMBER() OVER( PARTITION BY orderID, productName, Discount, Sales, Profit, Quantity, SubCategory, Category
ORDER BY OrderID)
AS rn FROM EachOrderBreakdown
)
DELETE from cte
WHERE rn > 1

--Q6. Replace blank with NA in OrderPriority Column in OrdersList table

SELECT * FROM Orderslist

UPDATE Orderslist
SET orderpriority = 'NA'
WHERE orderpriority = ' ';
