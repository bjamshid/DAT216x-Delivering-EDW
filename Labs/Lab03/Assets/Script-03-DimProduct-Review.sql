--Execute the ENTIRE script
USE [AdventureWorksDW2016];
GO

--Review a selection of products loaded to the DimProduct table
SELECT * FROM [dbo].[DimProduct] WHERE [ProductAlternateKey] IN (N'BK-R19B-54', N'BK-R93R-62', N'BK-T79Y-46');
GO

/*
First result:
  BK-R19B-54: No product record exists
  BK-R93R-62: ReorderPoint is 75
  BK-T79Y-46: ListPrice is 2384.07

Second result:
  BK-R19B-54: Product exists
  BK-R93R-62: ReorderPoint is now updated to 100 (Type 1 change)
  BK-T79Y-46: ListPrice (expired version) is 2384.07
  BK-T79Y-46: ListPrice (current version) is 2484.07
*/