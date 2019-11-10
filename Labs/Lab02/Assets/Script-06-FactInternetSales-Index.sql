--Execute INDIVIDUAL batches as directed

--Use the AdventureWorksDW2016 database
USE [AdventureWorksDW2016];
GO

--Select the following statement (lines 13-14) an then on the Query menu,
--select Display Estimated Execution Plan (you can also use the toolbar button (to the
--right of the blue check mark), or press Ctrl + L)
--This query retrieves all internet sales facts for a specific date
--In the execution plan, hover over the clustered index scan, and notice that it has used
--partition elimation, and has only required a scan of the 2011 partition
SELECT * FROM [dbo].[FactInternetSales_Partitioned] 
WHERE [OrderDateKey] = 20110531;
GO

--Display the estimated query execution plan for the following query (lines 19-20)
--Retrieving a single sales order number requires a complete scan of the table (all partitions)
SELECT * FROM [dbo].[FactInternetSales_Partitioned] 
WHERE [SalesOrderNumber] = N'SO44033';
GO

--Execute the following statement (lines 25-26) to create a non-clustered index to support the efficient
--retrieval of sales orders and their line items (notice the composite index)
CREATE NONCLUSTERED INDEX [NCI_FactInternetSales_Partitioned_SalesOrderNumber]
ON [dbo].[FactInternetSales_Partitioned]([SalesOrderNumber], [SalesOrderLineNumber]);
GO

--Display the estimated query execution plan for the last query, and notice that
--it will now use an index seek
SELECT * FROM [dbo].[FactInternetSales_Partitioned] 
WHERE [SalesOrderNumber] = N'SO44033';
GO

--Execute the following statements (lines 37-38) to turn statistics on
--to help measure query performance
SET STATISTICS IO ON;
SET STATISTICS TIME ON;
GO

--Execute the following statements (lines 43-44) to clear all buffers
--i.e. remove cached objects from memory
DBCC DROPCLEANBUFFERS;
DBCC FREEPROCCACHE;
GO

--Execute the following analytic query (lines 48-66)
SELECT
	[st].[SalesTerritoryRegion] AS [Region]
	,[pc].[EnglishProductCategoryName] AS [Category]
	,SUM([fis].[SalesAmount]) AS [Sales]
FROM
	[dbo].[FactInternetSales_Partitioned] AS [fis]
	INNER JOIN [dbo].[DimSalesTerritory] AS [st]
		ON [st].[SalesTerritoryKey] = [fis].[SalesTerritoryKey]
	INNER JOIN [dbo].[DimProduct] AS [p]
		ON [p].[ProductKey] = [fis].[ProductKey]
	INNER JOIN [dbo].[DimProductSubcategory] AS [ps]
		ON [ps].[ProductSubcategoryKey] = [p].[ProductSubcategoryKey]
	INNER JOIN [dbo].[DimProductCategory] AS [pc]
		ON [pc].[ProductCategoryKey] = [ps].[ProductCategoryKey]
WHERE
	[fis].[OrderDateKey] BETWEEN 20120101 AND 20121231
GROUP BY
	[st].[SalesTerritoryRegion]
	,[pc].[EnglishProductCategoryName];
GO

--In the Messages results tab, review the statistics, noting the overall time in milliseconds (ms)

--Execute the following statement (line 73) to create a clustered columnstore index on
--the FactInternetSales_Partitioned table
CREATE CLUSTERED COLUMNSTORE INDEX [CI_FactInternetSales_Partitioned] ON [dbo].[FactInternetSales_Partitioned] WITH (COMPRESSION_DELAY = 0);
GO

--Execute the following statements (lines 77-78) to clear all buffers
DBCC DROPCLEANBUFFERS;
DBCC FREEPROCCACHE;
GO

--Execute the following analytic query (lines 84-102)
--This is the same query executed prior to the creation of the clustered columnstore index
--You will then compare the performance difference in terms of time
SELECT
	[st].[SalesTerritoryRegion] AS [Region]
	,[pc].[EnglishProductCategoryName] AS [Category]
	,SUM([fis].[SalesAmount]) AS [Sales]
FROM
	[dbo].[FactInternetSales_Partitioned] AS [fis]
	INNER JOIN [dbo].[DimSalesTerritory] AS [st]
		ON [st].[SalesTerritoryKey] = [fis].[SalesTerritoryKey]
	INNER JOIN [dbo].[DimProduct] AS [p]
		ON [p].[ProductKey] = [fis].[ProductKey]
	INNER JOIN [dbo].[DimProductSubcategory] AS [ps]
		ON [ps].[ProductSubcategoryKey] = [p].[ProductSubcategoryKey]
	INNER JOIN [dbo].[DimProductCategory] AS [pc]
		ON [pc].[ProductCategoryKey] = [ps].[ProductCategoryKey]
WHERE
	[fis].[OrderDateKey] BETWEEN 20120101 AND 20121231
GROUP BY
	[st].[SalesTerritoryRegion]
	,[pc].[EnglishProductCategoryName];
GO

--Execute the last query once again (the clustered index is loaded into memory on first request)

--Execute the following statements (lines 108-109) to turn statistics off
SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
GO
