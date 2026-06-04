-- Sales.Customers

-- 1. Find all customers where their Country is not specified (NULL or empty).

SELECT
    *
FROM Sales.Customers
WHERE Country IS NULL

-- 2. List the top 3 countries by average customer Score.

SELECT 
    Country,
    AVG(Score) AVG_SCORE_COUNTRY
FROM Sales.Customers
GROUP BY Country
ORDER BY AVG(Score) DESC

-- 3. Retrieve customers whose Score is above the overall average score.

-- SELECT *
-- FROM Sales.Customers
-- WHERE Score > (
--     SELECT AVG(Score)
--     FROM Sales.Customers
-- );

SELECT
    CustomerID,
    Score,
    AVG(Score) OVER () AS OverallAverageScore
FROM Sales.Customers
WHERE Score > (
    SELECT AVG(Score)
    FROM Sales.Customers
);

-- 4. Count the number of customers per country, only showing countries with more than 5 customers.

-- SELECT
--     Country,
--     COUNT(*) AS CustomersCount
-- FROM Sales.Customers
-- GROUP BY Country
-- HAVING COUNT(*) > 5;

SELECT
    *
FROM(
    SELECT
        DISTINCT(Country),
        COUNT(CustomerID) OVER(PARTITION BY Country) AS CUSTOMERS_COUNT_PER_COUNTRY
    FROM Sales.Customers
)t
WHERE CUSTOMERS_COUNT_PER_COUNTRY > 5

-- 5. Find customers who share the same LastName — list them alongside each other.

SELECT
    *
FROM(
    SELECT 
        *,
        COUNT(LastName) OVER(
            PARTITION BY LastName) as NAME_COUNT
    FROM Sales.Customers
)t
WHERE NAME_COUNT > 1

-- 6. Rank customers by Score within each Country using a window function.

SELECT
    *,
    DENSE_RANK() OVER(
        PARTITION BY Country 
        ORDER BY Score DESC)
FROM Sales.Customers

-- 7. Find the country with the single highest total combined Score.

SELECT TOP 1
    Country,
    SUM(COALESCE(Score, 0)) COUNTRY_COMBINED_SCORE
FROM Sales.Customers
GROUP BY Country
ORDER BY COUNTRY_COMBINED_SCORE DESC

-- ALTERNATIVE
WITH CountryScores AS (
    SELECT
        Country,
        SUM(COALESCE(Score, 0)) AS COUNTRY_COMBINED_SCORE
    FROM Sales.Customers
    GROUP BY Country
)
SELECT *
FROM (
    SELECT *,
           DENSE_RANK() OVER (ORDER BY COUNTRY_COMBINED_SCORE DESC) AS rnk
    FROM CountryScores
) t
WHERE rnk = 1;

-- 8. Return all customers whose full name (FirstName + LastName) contains the letter "an" (case-insensitive).

SELECT
    *
FROM(
    SELECT
        CONCAT(FirstName, ' ', LastName) as FULLNAME
    FROM Sales.Customers
)t
WHERE FULLNAME LIKE '%an%'

-- 9. Find customers who have placed more than 3 orders by joining with Sales.Orders.

SELECT
    C.CustomerID,
    COUNT(O.OrderID) ORDER_COUNT
FROM Sales.Customers C
INNER JOIN Sales.Orders O
ON C.CustomerID = O.CustomerID
GROUP BY C.CustomerID
HAVING COUNT(O.OrderID) >= 3

SELECT 
    *
FROM(
    SELECT
        C.*,
        COUNT(O.OrderID) OVER(PARTITION BY O.CustomerID) ORDER_COUNT
    FROM Sales.Customers C
    RIGHT JOIN Sales.Orders O
    ON C.CustomerID = O.CustomerID
)t
WHERE ORDER_COUNT >= 3

-- 10. Calculate the percentile rank of each customer's Score across all customers.

SELECT
    CustomerID,
    COALESCE(Score, 0) Score,
    PERCENT_RANK() OVER(ORDER BY COALESCE(Score, 0) ASC) PERCENTILE_RANK
FROM Sales.Customers

-- 11. Find the customer with the highest total Sales amount by joining with Sales.Orders.

SELECT TOP 1
    C.CustomerID,
    SUM(O.Sales) TOTAL_SALES
FROM Sales.Customers C
INNER JOIN Sales.Orders O
ON C.CustomerID = O.CustomerID
GROUP BY C.CustomerID
ORDER BY SUM(O.Sales) DESC

-- 12. List all customers who have never placed an order.

SELECT 
    C.*
FROM Sales.Customers C
LEFT JOIN Sales.Orders O
    ON C.CustomerID = O.CustomerID
WHERE O.CustomerID IS NULL;

--Alternative
SELECT 
    *
FROM Sales.Customers C
WHERE NOT EXISTS (
    SELECT 1
    FROM Sales.Orders O
    WHERE O.CustomerID = C.CustomerID
);

-- For each country, return only the customer with the highest Score.