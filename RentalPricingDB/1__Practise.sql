-------------------------------------------------------------
-- ===================== QUESTIONS ==========================
-------------------------------------------------------------

-- Key Points Reasoning
-- WHERE ISNUMERIC(LOCATION_NAME) = 0 -> THIS IS DONE BECAUSE OUR DATA LOCATION_NAME FROM TABLE LOCATION HAS NUMBER VALUES SOMEHOW INSTEAD OF VARCHAR

-- Window Functions

-- 1.Rank properties by monthly rent within each location. Show the top 3 most expensive per location.

SELECT
    *
FROM(
    SELECT 
    Loc.Name AS LOCATION_NAME,
    L.MonthlyRent AS MONTHLY_RENT,
    ROW_NUMBER() OVER(
        PARTITION BY Loc.Name 
        ORDER BY MonthlyRent DESC) AS RANKING
    FROM dbo.Listing L
    INNER JOIN dbo.Property P
        ON L.PropertyID = P.Id
    INNER JOIN dbo.[Location] Loc
        ON Loc.Id = P.LocationID
)t
WHERE ISNUMERIC(LOCATION_NAME) = 0
AND
RANKING <= 3

-- 2.For each property listed, show the previous listing's rent and the difference from the current one, ordered by ListedAt date.

SELECT 
    P.PropertyName,
    L.MonthlyRent AS MONTHLY_RENT,
    L.ListedAt AS DATE_LISTED,
    LAG(L.MonthlyRent) OVER(
        PARTITION BY P.Id 
        ORDER BY L.ListedAt
    ) AS PREVIOUS_RENT,
    L.MonthlyRent - LAG(L.MonthlyRent) OVER(
        PARTITION BY P.Id 
        ORDER BY L.ListedAt
    ) AS RENT_DIFFERENCE

FROM dbo.Listing L
INNER JOIN dbo.Property P
    ON L.PropertyID = P.Id
ORDER BY P.Id, L.ListedAt;

-- 3.Divide all properties into 4 rent quartiles. Show each property's name, rent, and which quartile it falls in.

SELECT
    DISTINCT
    P.PropertyName,
    L.MonthlyRent AS MONTHLY_RENT,
    NTILE(4) OVER(ORDER BY L.MonthlyRent) BUCKETS
FROM dbo.Listing L
INNER JOIN dbo.Property P
    ON L.PropertyID = P.Id
INNER JOIN dbo.[Location] Loc
    ON Loc.Id = P.LocationID
ORDER BY MONTHLY_RENT, BUCKETS ASC

-- 4.For each property type, find the single newest property by CompletionYear. Return one row per type.

SELECT 
    *
FROM(
    SELECT
        P.PropertyName,
        CompletionYear,
        PT.[Type],
        ROW_NUMBER() OVER(
            PARTITION BY PT.[Type] 
            ORDER BY CompletionYear DESC) RANKING
    FROM dbo.Property P
        INNER JOIN dbo.PropertyType PT
    ON P.PropertyTypeId = PT.Id
)t
WHERE RANKING LIKE 1


-- 5.Calculate a running total of MonthlyRent ordered by ListedAt date — simulating cumulative revenue intake.

SELECT
    P.PropertyName,
    L.MonthlyRent,
    L.ListedAt,
    SUM(L.MonthlyRent) OVER (
        ORDER BY L.ListedAt ASC, 
        L.Id ASC) AS CUMULATIVE_REVENUE
FROM dbo.Property P
INNER JOIN dbo.Listing L
    ON P.Id = L.PropertyID
ORDER BY L.ListedAt ASC

-- 6.What percentile does each property's rent fall in across all listings? Show properties above the 75th percentile.
-- 7.Rank properties by number of bathrooms. Handle ties without gaps in rank. Which rank has the most properties?
-- 8.For each region, show each property alongside the cheapest rent ever listed in that region.

-- CTEs

-- 9. Build a recursive CTE that segments properties into tiers: Budget (<2000), Mid (2000–4000), Premium (>4000) and counts each tier.
-- 10. Write a multi-CTE query: first compute average rent per location, then find locations whose average is above the global average.
-- 11. Chain 3 CTEs: (1) count facilities per property, (2) count benefits per property, (3) join both and rank properties by total perks.
-- 12. Using a CTE, identify properties whose rent is more than 1.5 standard deviations above the mean rent for their property type.
-- 13. Listings can have multiple entries for the same property. Use a CTE to return only the most recent listing per property.

-- Aggregates

-- 14. Find locations that have more than 5 listed properties AND whose average rent exceeds the overall average rent.
-- 15. Show each property type's count of properties, split by furnishing status (Furnished vs Unfurnished) as pivot columns.
-- 16. Write one query that returns rent totals grouped by: (Region), (PropertyType), and (Region + PropertyType) together.
-- 17. Use ROLLUP to show total monthly rent by Region → Location → Property, with subtotals at each level.
-- 18. For each property, list all its facility names in a single comma-separated column.
-- 19. Find the median monthly rent across all listings. SQL Server has no MEDIAN() — compute it manually.
-- 20. How many unique locations have at least one property listed in each furnishing status category?

-- Joins

-- 21. Find pairs of properties in the same location that have the same number of rooms but different rents. Show the rent difference.
-- 22. Find all properties that have never been listed (no row in Listing). Return PropertyName and CompletionYear.
-- 23. Write a single query joining Property, Location, Region, PropertyType, and FurnishingStatus to produce a full property profile.
-- 24. For each location, use CROSS APPLY to get the top 2 most expensive properties listed there.
-- 25. Find properties that have at least one facility AND at least one benefit. Write it using EXISTS, then rewrite it using JOINs. Compare the plans.

-- Subqueries

-- 26. For each property, show how its rent compares to the average rent of all properties in the same region.
-- 27. Find regions that have no properties at all. Write it with NOT IN, then with NOT EXISTS, then discuss the NULL-safety difference.
-- 28. Add a column to each listing showing how many other listings share the same PropertyID (i.e. how many times was this property listed).
-- 29. Using a derived table (not a CTE), find the average rent of the top 10 most expensive properties per region.

-- Stored Procedure Design

-- 30. Write a stored procedure sp_GetListings that accepts @PageNumber, @PageSize, @LocationID (optional), and returns paginated listings with total row count.
-- 31. Write sp_SearchProperties accepting optional filters: @MinRent, @MaxRent, @PropertyTypeId, @FurnishingStatusId, @RegionId. Handle NULLs gracefully.
-- 32. Write sp_GetPropertyStats that returns three result sets: overall stats, stats per region, stats per property type — in one stored procedure.
-- 33. Write sp_UpsertListing that inserts a new listing if the PropertyID doesn't exist in Listing, or updates the rent and date if it does.
-- 34. Write sp_TransferPropertyListing that moves a listing from one property to another, wrapped in a transaction with proper error handling and rollback.

-- Advanced Patterns

-- 35. Properties listed multiple times may have gaps in listing dates. Find properties that had a gap of more than 90 days between consecutive listings.
-- 36. Find the top 2 highest-rent properties for each combination of PropertyType + FurnishingStatus.
-- 37. Pivot the data to show columns for each PropertyType name, with rows being Regions, and values being average rent.
-- 38. Identify listings whose rent is more than 2 standard deviations from the mean. Flag them as 'High Outlier' or 'Low Outlier'.
-- 39. A property is 'churning' if it was listed more than 3 times. Find churning properties, count their listings, and show days between first and last listing.
-- 40. What percentage of properties have ALL three facility categories covered? (Assume Category has at least 3 distinct values — compute dynamically.)
