SELECT 
TOP 10
    *
FROM dbo.apartment


-- finding the unique values

-- Facilities
SELECT
    *
FROM(
    SELECT DISTINCT 
        TRIM(value) AS Facility
    FROM dbo.apartment
    CROSS APPLY STRING_SPLIT(Facilities, ',')
)t
WHERE Facility NOT LIKE '%[0-9]%'

SELECT 
    -- A.ads_id,
    -- P.AdsID,
    P.Id AS Id,
    -- TRIM(F.value) AS Facility,
    FACI.Id as FacilityId
FROM dbo.apartment A
LEFT JOIN dbo.Property P
    ON A.ads_id = P.AdsID
OUTER APPLY STRING_SPLIT(A.facilities, ',') F
INNER JOIN dbo.Facility FACI
    ON TRIM(F.value) = FACI.Category
WHERE TRIM(F.value) NOT LIKE '%[0-9]%' AND P.Id IS NOT NULL;

-- Property Type
SELECT DISTINCT 
        TRIM(value) AS [Type]
    FROM dbo.apartment
    CROSS APPLY STRING_SPLIT(property_type, '/')

-- Furnishing Status
SELECT
    DISTINCT(furnished)
FROM dbo.apartment

-- Region

SELECT DISTINCT
    TRIM(LEFT([location], CHARINDEX('-', [location]) - 1)) AS Name
FROM dbo.Apartment
WHERE [location] LIKE '%-%';

-- Location
SELECT DISTINCT
    TRIM(RIGHT(
        [location],
        LEN([location]) - CHARINDEX('-', [location])
    )) AS Name
FROM dbo.Apartment
WHERE [location] LIKE '%-%';

-- Additional Facilities (Benefit)
SELECT 
    *
FROM(
    SELECT DISTINCT 
        TRIM(value) AS Benefit
    FROM dbo.apartment
    CROSS APPLY STRING_SPLIT(additional_facilities, ',')
)t
WHERE Benefit NOT LIKE ''

SELECT 
    -- A.ads_id,
    -- P.AdsID,
    P.Id AS Id,
    -- TRIM(F.value) AS Facility,
    Benefit.Id as BenefitID
FROM dbo.apartment A
LEFT JOIN dbo.Property P
    ON A.ads_id = P.AdsID
OUTER APPLY STRING_SPLIT(A.additional_facilities, ',') F
INNER JOIN dbo.Benefit Benefit
    ON TRIM(F.value) = Benefit.Description
WHERE TRIM(F.value) NOT LIKE '%[0-9]%' AND P.Id IS NOT NULL;

-- Property

SELECT TOP 10
    A.ads_id AS Id,
    A.prop_name AS PropertyName,
    A.completion_year AS CompletionYear,
    A.rooms AS Rooms,
    A.bathroom AS Bathrooms,
    A.parking AS ParkingSpots,
    A.size AS SizeSqft,
    FS.Id AS FurnishingStatusId,
    PT.Id AS PropertyTypeID,
    L.Id AS LocationID
FROM dbo.Apartment A
LEFT JOIN dbo.FurnishingStatus FS
    ON A.furnished = FS.Status
LEFT JOIN dbo.PropertyType PT
    ON A.property_type = PT.[Type]
LEFT JOIN dbo.[Location] L
    ON TRIM(RIGHT(
        A.[location],
        LEN(A.[location]) - CHARINDEX('-', A.[location])
    )) 
    = L.Name


-- Generates a random date between January 1, 2020 and December 31, 2025
DECLARE @MinDate DATE = '2020-01-01';
DECLARE @MaxDate DATE = '2025-12-31';

SELECT 
    -- TOP 10
    P.Id AS PropertyId,
    TRY_CAST(
        REPLACE(
            REPLACE(
                REPLACE(
                    REPLACE(monthly_rent, ',', ''),
                    'RM', ''
                ),
                'per month', ''
            ),
            ' ',
            ''
        ) AS INT
    ) AS MonthlyRent,
    (
        SELECT DATEADD(
            DAY, 
            ABS(CHECKSUM(NEWID())) % (DATEDIFF(DAY, @MinDate, @MaxDate) + 1), 
            @MinDate
        ) 
    ) AS ListedAt
FROM dbo.apartment A
LEFT JOIN dbo.Property P
ON A.prop_name LIKE P.PropertyName


-- insert into the tables

-- Facilities
-- INSERT INTO dbo.Facility (Name, Category)
-- SELECT
--     '' AS Name,
--     Facility AS Category
-- FROM (
--     SELECT DISTINCT
--         TRIM(value) AS Facility
--     FROM dbo.Apartment
--     CROSS APPLY STRING_SPLIT(Facilities, ',')
-- ) t
-- WHERE Facility NOT LIKE '%[0-9]%';

--Propery Facilities

-- INSERT INTO dbo.PropertyFacility(Id, FacilityId)
-- SELECT 
--     -- A.ads_id,
--     -- P.AdsID,
--     P.Id AS Id,
--     -- TRIM(F.value) AS Facility,
--     FACI.Id as FacilityId
-- FROM dbo.apartment A
-- LEFT JOIN dbo.Property P
--     ON A.ads_id = P.AdsID
-- OUTER APPLY STRING_SPLIT(A.facilities, ',') F
-- INNER JOIN dbo.Facility FACI
--     ON TRIM(F.value) = FACI.Category
-- WHERE TRIM(F.value) NOT LIKE '%[0-9]%' AND P.Id IS NOT NULL;

-- -- Benefit
-- INSERT INTO dbo.Benefit([Description])
-- SELECT 
--     *
-- FROM(
--     SELECT DISTINCT 
--         TRIM(value) AS Benefit
--     FROM dbo.apartment
--     CROSS APPLY STRING_SPLIT(additional_facilities, ',')
-- )t
-- WHERE Benefit NOT LIKE ''

-- PropertyBenefit

-- INSERT INTO dbo.PropertyBenefit(Id, BenefitID)
-- SELECT 
--     -- A.ads_id,
--     -- P.AdsID,
--     P.Id AS Id,
--     -- TRIM(F.value) AS Facility,
--     Benefit.Id as BenefitID
-- FROM dbo.apartment A
-- LEFT JOIN dbo.Property P
--     ON A.ads_id = P.AdsID
-- OUTER APPLY STRING_SPLIT(A.additional_facilities, ',') F
-- INNER JOIN dbo.Benefit Benefit
--     ON TRIM(F.value) = Benefit.Description
-- WHERE TRIM(F.value) NOT LIKE '%[0-9]%' AND P.Id IS NOT NULL;

-- Property Type

-- INSERT INTO dbo.PropertyType
-- SELECT DISTINCT 
--         TRIM(value) AS [Type]
--     FROM dbo.apartment
--     CROSS APPLY STRING_SPLIT(property_type, '/')

-- Furnished Status

-- INSERT INTO dbo.FurnishingStatus
-- SELECT
--     DISTINCT(furnished)
-- FROM dbo.apartment

-- Region

-- INSERT INTO dbo.Region
-- SELECT DISTINCT
--     TRIM(LEFT([location], CHARINDEX('-', [location]) - 1)) AS Name
-- FROM dbo.Apartment
-- WHERE [location] LIKE '%-%';

-- Location
-- INSERT INTO dbo.Location (RegionID, Name)
-- SELECT DISTINCT
--     R.Id AS RegionID,
--     TRIM(SUBSTRING(
--         A.[location],
--         CHARINDEX('-', A.[location]) + 1,
--         LEN(A.[location])
--     )) AS Name
-- FROM dbo.Apartment A
-- INNER JOIN dbo.Region R
--     ON R.Name = TRIM(LEFT(A.[location], CHARINDEX('-', A.[location]) - 1))
-- WHERE A.[location] LIKE '%-%';

--Property

-- INSERT INTO dbo.Property
-- (
--     PropertyName,
--     CompletionYear,
--     Rooms,
--     Bathrooms,
--     ParkingSpots,
--     SizeSqft,
--     FurnishingStatusID,
--     PropertyTypeID,
--     LocationID,
--     AdsId
-- )
-- SELECT
--     *
-- FROM(
--     SELECT 
--     -- A.ads_id,
--     A.prop_name AS PropertyName,
--     A.completion_year AS CompletionYear,
--     A.rooms AS Rooms,
--     A.bathroom AS Bathrooms,
--     A.parking AS ParkingSpots,
--     A.size AS SizeSqft,
--     FS.Id AS FurnishingStatusID,
--     PT.Id AS PropertyTypeID,
--     L.Id AS LocationID,
--     A.ads_id AS AdsId
-- FROM dbo.Apartment A
-- LEFT JOIN dbo.FurnishingStatus FS
--     ON A.furnished = FS.Status
-- LEFT JOIN dbo.PropertyType PT
--     ON A.property_type = PT.[Type]
-- LEFT JOIN dbo.[Location] L
--     ON TRIM(RIGHT(
--         A.[location],
--         LEN(A.[location]) - CHARINDEX('-', A.[location])
--     )) 
--     = L.Name
-- )t
-- WHERE PropertyName IS NOT NULL
-- AND FurnishingStatusId IS NOT NULL

--LIsting

-- INSERT INTO dbo.Listing
-- SELECT 
--     -- TOP 10
--     P.Id AS PropertyId,
--     TRY_CAST(
--         REPLACE(
--             REPLACE(
--                 REPLACE(
--                     REPLACE(monthly_rent, ',', ''),
--                     'RM', ''
--                 ),
--                 'per month', ''
--             ),
--             ' ',
--             ''
--         ) AS INT
--     ) AS MonthlyRent,
--     DATEADD(
--         DAY,
--         ABS(CHECKSUM(NEWID())) % (DATEDIFF(DAY, @MinDate, @MaxDate) + 1),
--         @MinDate
--     ) AS ListedAt
-- FROM dbo.apartment A
-- LEFT JOIN dbo.Property P
-- ON A.ads_id = P.AdsID
-- WHERE P.PropertyName IS NOT NULL
-- AND P.FurnishingStatusId IS NOT NULL

-- check information columns
SELECT
    COLUMN_NAME,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Property';