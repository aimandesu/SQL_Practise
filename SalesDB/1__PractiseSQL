-- Sales.Orders & Sales.OrdersArchive

-- 1. Find all orders where the ShipDate is more than 7 days after the OrderDate.

SELECT
*
FROM (
    SELECT 
        OrderID, 
        OrderDate,
        ShipDate,
        DATEDIFF(day, OrderDate, ShipDate) DaysAfterOrderDate
    FROM Sales.Orders
)t
WHERE DaysAfterOrderDate > 7

-- 2. Count the number of orders per OrderStatus, ordered from highest to lowest count.

SELECT
    OrderStatus,
    COUNT(OrderStatus) OrderStatusCount
FROM Sales.Orders
GROUP BY OrderStatus
ORDER BY OrderStatusCount DESC


--3. Retrieve the top 5 customers (by CustomerID) with the highest total Sales from Sales.Orders.

SELECT TOP 5
    CustomerId,
    MAX(Sales) TotalSales
FROM Sales.Orders
GROUP BY CustomerID
ORDER BY TotalSales DESC


--4. Find all orders placed in the last 6 months that have not yet been shipped (ShipDate is NULL).

SELECT 
    OrderID,
    OrderDate,
    ShipDate,
    DATEDIFF(month, OrderDate, ShipDate) GAP_OF_6_MONTHS
FROM Sales.Orders
WHERE ShipDate IS NULL AND DATEDIFF(month, OrderDate, ShipDate) like 6

-- 5. Write a query that combines both Sales.Orders and Sales.OrdersArchive into one result set, removing duplicates.

SELECT 
    *
FROM Sales.Orders
    UNION
SELECT 
    *
FROM Sales.OrdersArchive;

-- 6. Find the month with the highest total quantity ordered across all orders.

WITH MonthlyTotalSales AS (
    SELECT
        MONTH(OrderDate) AS OrderMonth,
        SUM(Sales) OVER(
            PARTITION BY MONTH(OrderDate) 
            ORDER BY MONTH(OrderDate)) TotalSales
    FROM Sales.Orders
)

SELECT TOP 1 *
FROM MonthlyTotalSales
ORDER BY TotalSales DESC

-- 7. For each SalesPersonID, calculate their average order quantity and total quantity sold.

SELECT
    SalesPersonID,
    AVG(Sales) AVG_SALES,
    COUNT(Sales) SALES_COUNT
FROM Sales.Orders
GROUP BY SalesPersonID

-- 8. Identify orders where Quantity is above the average quantity of all orders.

-- SELECT 
--     *
-- FROM Sales.Orders
-- WHERE Quantity > (
--     SELECT AVG(Quantity)
--     FROM Sales.Orders
-- );

SELECT
    *
FROM(
    SELECT
        ProductID,
        Quantity,
        AVG(Quantity) OVER() AS AVG_QUANTITY
    FROM Sales.Orders
)t 
WHERE Quantity > AVG_QUANTITY

-- 9. Find all CustomerIDs that appear in Sales.OrdersArchive but NOT in Sales.Orders.

SELECT
    *
FROM Sales.OrdersArchive OA
    LEFT JOIN 
Sales.Orders O
    ON OA.OrderID = O.OrderID

-- 10. Rank all orders within each SalesPersonID partition by Quantity descending using a window function.

SELECT
    SalesPersonID,
    OrderID,
    Quantity,
    DENSE_RANK() OVER(
        PARTITION BY SalesPersonID 
        ORDER BY QUANTITY DESC) RANK_SALES_PERSON
FROM Sales.Orders

-- 11. Find the ProductID that had the highest total Quantity ordered across both tables combined.

SELECT
    ProductID,
    SUM(Quantity) QUANTITY,
    ROW_NUMBER() OVER(
        ORDER BY SUM(QUANTITY) DESC) RANK_PRODUCT
FROM Sales.Orders
GROUP BY ProductID

-- 12 .Count how many orders each customer has per OrderStatus using conditional aggregation.

SELECT
    CustomerID,
    COUNT(CASE WHEN OrderStatus = 'Delivered' THEN 1 END) AS DeliveredOrders,
    COUNT(CASE WHEN OrderStatus = 'Shipped' THEN 1 END) AS ShippedOrders
FROM Sales.Orders
GROUP BY CustomerID;

-- 13. Find all orders where the BillAddress and ShipAddress are different.

SELECT
    *
FROM Sales.Orders
WHERE BillAddress NOT LIKE ShipAddress
