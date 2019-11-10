--Execute the ENTIRE script
USE [AdventureWorks2016];
GO

--Insert a new product (source product BK-R19B-54)
INSERT
	[Production].[Product]
	(
		[Name]
        ,[ProductNumber]
        ,[MakeFlag]
        ,[FinishedGoodsFlag]
        ,[Color]
        ,[SafetyStockLevel]
        ,[ReorderPoint]
        ,[StandardCost]
        ,[ListPrice]
        ,[Size]
        ,[SizeUnitMeasureCode]
        ,[WeightUnitMeasureCode]
        ,[Weight]
        ,[DaysToManufacture]
        ,[ProductLine]
        ,[Class]
        ,[Style]
        ,[ProductSubcategoryID]
        ,[ProductModelID]
        ,[SellStartDate]
		,[SpanishName]
		,[FrenchName]
	)
	VALUES
	(
		N'Road-750 Black, 54'
		,N'BK-R19B-54'
		,1
		,1
		,N'Black'
		,100
		,75
		,343.6496
		,539.99
		,52
		,N'CM'
		,N'LB'
		,20.42
		,4
		,N'R'
		,N'L'
		,N'U'
		,2
		,31
		,'20160610'
		,N'Carretera: 750, negra, 52'
		,N'Vélo de route 750 noir, 52'
	);
GO

--Change the ReorderPoint for source product BK-R93R-62 (to trigger a Type 1 change)
UPDATE
	[Production].[Product]
SET
	[ReorderPoint] = 150
WHERE
	[ProductNumber] = N'BK-R93R-62';
GO

--Change the ListPrice for source product BK-T79Y-46 (to trigger a Type 2 change)
UPDATE
	[Production].[Product]
SET
	[ListPrice] = 2484.07
WHERE
	[ProductNumber] = N'BK-T79Y-46';
GO
