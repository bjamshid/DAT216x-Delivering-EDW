--Execute INDIVIDUAL batches as directed

--Use the AdventureWorksDW2016 database
USE [AdventureWorksDW2016];
GO

--Execute the following statements (lines 8-12) to create multiple file groups
ALTER DATABASE [AdventureWorksDW2016] ADD FILEGROUP [InternetSales_2009];
ALTER DATABASE [AdventureWorksDW2016] ADD FILEGROUP [InternetSales_2010];
ALTER DATABASE [AdventureWorksDW2016] ADD FILEGROUP [InternetSales_2011];
ALTER DATABASE [AdventureWorksDW2016] ADD FILEGROUP [InternetSales_2012];
ALTER DATABASE [AdventureWorksDW2016] ADD FILEGROUP [InternetSales_2013];
GO

--IMPORTANT: Verify that you have created the
--C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\AdventureWorksDW2016 folder
--as directed in the lab

--Execute the following statements (lines 21-69) to create multiple files,
--with one file assigned to a file group
ALTER DATABASE [AdventureWorksDW2016]
ADD FILE 
(
	NAME = [InternetSales_2009]
	,FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\AdventureWorksDW2016\InternetSales_2009.ndf'
	,SIZE = 100MB
	,MAXSIZE = 1GB
	,FILEGROWTH = 100MB)
TO FILEGROUP [InternetSales_2009];
GO
ALTER DATABASE [AdventureWorksDW2016]
ADD FILE 
(
	NAME = [InternetSales_2010]
	,FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\AdventureWorksDW2016\InternetSales_2010.ndf'
	,SIZE = 100MB
	,MAXSIZE = 1GB
	,FILEGROWTH = 100MB)
TO FILEGROUP [InternetSales_2010];
GO
ALTER DATABASE [AdventureWorksDW2016]
ADD FILE 
(
	NAME = [InternetSales_2011]
	,FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\AdventureWorksDW2016\InternetSales_2011.ndf'
	,SIZE = 100MB
	,MAXSIZE = 1GB
	,FILEGROWTH = 100MB)
TO FILEGROUP [InternetSales_2011];
GO
ALTER DATABASE [AdventureWorksDW2016]
ADD FILE 
(
	NAME = [InternetSales_2012]
	,FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\AdventureWorksDW2016\InternetSales_2012.ndf'
	,SIZE = 100MB
	,MAXSIZE = 1GB
	,FILEGROWTH = 100MB)
TO FILEGROUP [InternetSales_2012];
GO
ALTER DATABASE [AdventureWorksDW2016]
ADD FILE 
(
	NAME = [InternetSales_2013]
	,FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\AdventureWorksDW2016\InternetSales_2013.ndf'
	,SIZE = 100MB
	,MAXSIZE = 1GB
	,FILEGROWTH = 100MB)
TO FILEGROUP [InternetSales_2013];
GO

--Verify the creation of the files in the
--C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\AdventureWorksDW2016 folder

--Execute the following statement (lines 77-85) to create a partition function
--to determine assignment of facts by a date key integer
CREATE PARTITION FUNCTION [AnnualSales](INT) AS RANGE RIGHT
FOR VALUES
(               
				-- Partition 1  -- Before 2010
	20100101	-- Partition 2  -- 2010
	,20110101	-- Partition 3  -- 2011
	,20120101	-- Partition 4  -- 2012
	,20130101	-- Partition 5  -- 2013 (and beyond)
);
GO

--Execute the following statements (lines 90-93) to test the partition function
SELECT 19700531, $partition.[AnnualSales](19700531)
UNION ALL SELECT 20110531, $partition.[AnnualSales](20110531)
UNION ALL SELECT 20120531, $partition.[AnnualSales](20120531)
UNION ALL SELECT 20160531, $partition.[AnnualSales](20160531);
GO

--Execute the following statement (lines 97-105) to create a partition scheme
--to determine the mapping between partitions and file groups
CREATE PARTITION SCHEME [AnnualSalesScheme]
AS PARTITION [AnnualSales] TO
(
	[InternetSales_2009]
	,[InternetSales_2010]
	,[InternetSales_2011]
	,[InternetSales_2012]
	,[InternetSales_2013]
);
GO

--Execute the following statement (lines 110-135) to create the FactInternetSales_Partitioned
--table on the AnnualSalesScheme (using OrderDateKey as the partition column)
CREATE TABLE [dbo].[FactInternetSales_Partitioned]
(
	[ProductKey] [smallint] NOT NULL,
	[OrderDateKey] [int] NOT NULL,
	[DueDateKey] [int] NOT NULL,
	[ShipDateKey] [int] NOT NULL,
	[CustomerKey] [int] NOT NULL,
	[PromotionKey] [int] NOT NULL,
	[CurrencyKey] [int] NOT NULL,
	[SalesTerritoryKey] [int] NOT NULL,
	[SalesOrderNumber] [nvarchar](20) NOT NULL,
	[SalesOrderLineNumber] [tinyint] NOT NULL,
	[RevisionNumber] [tinyint] NOT NULL,
	[OrderQuantity] [smallint] NOT NULL,
	[UnitPrice] [money] NOT NULL,
	[ExtendedAmount] [money] NOT NULL,
	[UnitPriceDiscountPct] [float] NOT NULL,
	[DiscountAmount] [float] NOT NULL,
	[ProductStandardCost] [money] NOT NULL,
	[TotalProductCost] [money] NOT NULL,
	[SalesAmount] [money] NOT NULL,
	[TaxAmt] [money] NOT NULL,
	[Freight] [money] NOT NULL,
	[CarrierTrackingNumber] [nvarchar](25) NULL,
	[CustomerPONumber] [nvarchar](25) NULL
) ON [AnnualSalesScheme]([OrderDateKey]);
GO

--Execute the following statement (lines 140-141) to add a foreign key constraint
--to the ProductKey column
ALTER TABLE [dbo].[FactInternetSales_Partitioned] WITH NOCHECK
ADD CONSTRAINT [FK_FactInternetSales_Partitioned_ProductKey_DimProduct_ProductKey] FOREIGN KEY ([ProductKey]) REFERENCES [dbo].[DimProduct]([ProductKey]);
GO

--Execute the following statement (lines 146-147) to disable the foreign key constraint
--(This will improve the load performance into the fact table)
--Note: That integrity is checked with lookup operations during the fact table load
ALTER TABLE [dbo].[FactInternetSales_Partitioned]
NOCHECK CONSTRAINT [FK_FactInternetSales_Partitioned_ProductKey_DimProduct_ProductKey];
GO

--Execute the following statement (lines 153-182) to load the table with
--all facts prior to 2013
INSERT
	[dbo].[FactInternetSales_Partitioned]
SELECT
	[ProductKey]
	,[OrderDateKey]
	,[DueDateKey]
	,[ShipDateKey]
	,[CustomerKey]
	,[PromotionKey]
	,[CurrencyKey]
	,[SalesTerritoryKey]
	,[SalesOrderNumber]
	,[SalesOrderLineNumber]
	,[RevisionNumber]
	,[OrderQuantity]
	,[UnitPrice]
	,[ExtendedAmount]
	,[UnitPriceDiscountPct]
	,[DiscountAmount]
	,[ProductStandardCost]
	,[TotalProductCost]
	,[SalesAmount]
	,[TaxAmt]
	,[Freight]
	,[CarrierTrackingNumber]
	,[CustomerPONumber]
FROM
	[dbo].[FactInternetSales]
WHERE
	[OrderDateKey] < 20130101;
GO

--Execute the following statement (line 186) to review the partion row counts
SELECT * FROM [dbo].[udfPartitionInfo](N'dbo', N'FactInternetSales_Partitioned');
GO
