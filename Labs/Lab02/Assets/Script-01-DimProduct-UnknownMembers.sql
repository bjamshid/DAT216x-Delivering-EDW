--Execute INDIVIDUAL batches as directed

--Use the AdventureWorksDW2016 database
USE [AdventureWorksDW2016];
GO

--Review the DimProductCategory table records
--Note the absence of an "Unknown" record
SELECT * FROM [dbo].[DimProductCategory];
GO

--Execute the following statements (lines 14-37) to insert an "Unknown" record
--and then review the DimProductCategory table records 
SET IDENTITY_INSERT [dbo].[DimProductCategory] ON;
GO
INSERT
	[dbo].[DimProductCategory]
	(
		[ProductCategoryKey]
		,[ProductCategoryAlternateKey]
		,[EnglishProductCategoryName]
		,[SpanishProductCategoryName]
		,[FrenchProductCategoryName]
	)
	VALUES
	(
		-1
		,-1
		,N'[Unknown Product Category]'
		,N'[Unknown Product Category]'
		,N'[Unknown Product Category]'
	);
GO
SET IDENTITY_INSERT [dbo].[DimProductCategory] OFF;
GO
SELECT * FROM [dbo].[DimProductCategory];
GO

--Execute all remaining statements (lines 41-98) to insert an "Unknown" member into
--the DimProductSubcategory and DimProduct tables
SET IDENTITY_INSERT [dbo].[DimProductSubcategory] ON;
GO
INSERT
	[dbo].[DimProductSubcategory]
	(
		[ProductSubcategoryKey]
		,[ProductSubcategoryAlternateKey]
		,[EnglishProductSubcategoryName]
		,[SpanishProductSubcategoryName]
		,[FrenchProductSubcategoryName]
		,[ProductCategoryKey]
	)
	VALUES
	(
		-1
		,-1
		,N'[Unknown Product Subcategory]'
		,N'[Unknown Product Subcategory]'
		,N'[Unknown Product Subcategory]'
		,-1
	);
GO
SET IDENTITY_INSERT [dbo].[DimProductSubcategory] OFF;
GO
SET IDENTITY_INSERT [dbo].[DimProduct] ON;
GO
INSERT
	[dbo].[DimProduct]
	(
		[ProductKey]
		,[ProductAlternateKey]
		,[ProductSubcategoryKey]
		,[EnglishProductName]
		,[SpanishProductName]
		,[FrenchProductName]
		,[FinishedGoodsFlag]
		,[Color]
		,[StartDate]
	)
	VALUES
	(
		-1
		,N'[UNKNOWN]'
		,-1
		,N'[Unknown Product]'
		,N'[Unknown Product]'
		,N'[Unknown Product]'
		,0
		,N'NA'
		,'20030701'
	);
GO
SET IDENTITY_INSERT [dbo].[DimProduct] OFF;
GO
SELECT TOP(5) * FROM [dbo].[DimProductSubcategory] ORDER BY [ProductSubcategoryKey];
GO
SELECT TOP(5) * FROM [dbo].[DimProduct] ORDER BY [ProductKey];
GO
