CREATE TABLE [dbo].[Property] (
[Id] int NOT NULL IDENTITY(1,1),
[PropertyName] varchar(200),
[CompletionYear] int,
[Rooms] nvarchar(50),
[Bathrooms] int,
[ParkingSpots] int,
[SizeSqft] nvarchar(50),
[LocationID] int,
[PropertyTypeId] int,
[FurnishingStatusID] int,
PRIMARY KEY ([Id])
);

CREATE TABLE [dbo].[FurnishingStatus] (
[Id] int NOT NULL IDENTITY(1,1),
[Status] nvarchar(50),
PRIMARY KEY ([Id])
);

CREATE TABLE [dbo].[PropertyFacility] (
[Id] int NOT NULL IDENTITY(1,1),
[FacilityId] int,
PRIMARY KEY ([Id])
);

CREATE TABLE [dbo].[PropertyBenefit] (
[Id] int NOT NULL IDENTITY(1,1),
[BenefitID] int,
PRIMARY KEY ([Id])
);

CREATE TABLE [dbo].[Benefit] (
[Id] int NOT NULL IDENTITY(1,1),
[Description] nvarchar(50),
PRIMARY KEY ([Id])
);

CREATE TABLE [dbo].[apartment] (
[ads_id] int NOT NULL,
[prop_name] varchar(200),
[completion_year] float(53),
[monthly_rent] nvarchar(50),
[location] nvarchar(50) NOT NULL,
[property_type] nvarchar(50) NOT NULL,
[rooms] nvarchar(50),
[parking] float(53),
[bathroom] float(53),
[size] nvarchar(50) NOT NULL,
[furnished] nvarchar(50),
[facilities] nvarchar(200),
[additional_facilities] nvarchar(100),
[region] nvarchar(50) NOT NULL
);

CREATE TABLE [dbo].[PropertyType] (
[Id] int NOT NULL IDENTITY(1,1),
[Type] nvarchar(50),
PRIMARY KEY ([Id])
);

CREATE TABLE [dbo].[Facility] (
[Id] int NOT NULL IDENTITY(1,1),
[Name] nvarchar(50),
[Category] nvarchar(50),
PRIMARY KEY ([Id])
);

CREATE TABLE [dbo].[Location] (
[Id] int NOT NULL IDENTITY(1,1),
[RegionID] int,
[Name] nvarchar(50),
PRIMARY KEY ([Id])
);

CREATE TABLE [dbo].[Listing] (
[Id] int NOT NULL IDENTITY(1,1),
[PropertyID] int,
[MonthlyRent] int,
[ListedAt] date,
PRIMARY KEY ([Id])
);

CREATE TABLE [dbo].[Region] (
[Id] int NOT NULL IDENTITY(1,1),
[Name] nvarchar(50),
PRIMARY KEY ([Id])
);


ALTER TABLE [dbo].[Property]
ADD CONSTRAINT [FK_Property_FurnishingStatus]
FOREIGN KEY ([FurnishingStatusID]) 
REFERENCES [dbo].[FurnishingStatus]([Id])
ON DELETE NO ACTION
ON UPDATE NO ACTION;



ALTER TABLE [dbo].[Property]
ADD CONSTRAINT [FK_Property_PropertyType]
FOREIGN KEY ([PropertyTypeId]) 
REFERENCES [dbo].[PropertyType]([Id])
ON DELETE NO ACTION
ON UPDATE NO ACTION;



ALTER TABLE [dbo].[Property]
ADD CONSTRAINT [FK_Property_Location]
FOREIGN KEY ([LocationID]) 
REFERENCES [dbo].[Location]([Id])
ON DELETE NO ACTION
ON UPDATE NO ACTION;



ALTER TABLE [dbo].[PropertyFacility]
ADD CONSTRAINT [FK_2]
FOREIGN KEY ([Id]) 
REFERENCES [dbo].[Property]([Id])
ON DELETE NO ACTION
ON UPDATE NO ACTION;



ALTER TABLE [dbo].[PropertyFacility]
ADD CONSTRAINT [FK_PropertyFacility_Facility]
FOREIGN KEY ([FacilityId]) 
REFERENCES [dbo].[Facility]([Id])
ON DELETE NO ACTION
ON UPDATE NO ACTION;



ALTER TABLE [dbo].[PropertyBenefit]
ADD CONSTRAINT [FK_PropertyBenefits_Benefit]
FOREIGN KEY ([BenefitID]) 
REFERENCES [dbo].[Benefit]([Id])
ON DELETE NO ACTION
ON UPDATE NO ACTION;



ALTER TABLE [dbo].[PropertyBenefit]
ADD CONSTRAINT [FK_1]
FOREIGN KEY ([Id]) 
REFERENCES [dbo].[Property]([Id])
ON DELETE NO ACTION
ON UPDATE NO ACTION;



ALTER TABLE [dbo].[Location]
ADD CONSTRAINT [FK_Location_Region]
FOREIGN KEY ([RegionID]) 
REFERENCES [dbo].[Region]([Id])
ON DELETE NO ACTION
ON UPDATE NO ACTION;



ALTER TABLE [dbo].[Listing]
ADD CONSTRAINT [FK_3]
FOREIGN KEY ([PropertyID]) 
REFERENCES [dbo].[Property]([Id])
ON DELETE CASCADE
ON UPDATE CASCADE;



