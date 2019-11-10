--Execute INDIVIDUAL batches as directed

--Use the AdventureWorksDW2016 database
USE [AdventureWorksDW2016];
GO

--Execute the following statement (line 9) to create a new filegroup for 2014 sales data
--Create a file group to manage the storage of 2014 internet sales facts
ALTER DATABASE [AdventureWorksDW2016] ADD FILEGROUP [InternetSales_2014];
GO

--Execute the following statement (lines 13-21) to create a new file in the new file group
ALTER DATABASE [AdventureWorksDW2016]
ADD FILE 
(
	NAME = [InternetSales_2014]
	,FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\AdventureWorksDW2016\InternetSales_2014.ndf'
	,SIZE = 100MB
	,MAXSIZE = 1GB
	,FILEGROWTH = 100MB)
TO FILEGROUP [InternetSales_2014];
GO

--Execute the following statement (lines 27-53) to create a staging table
--The staging table will be used to load 2013 sales data, and will be switched in
--to the partitioned table
CREATE TABLE [dbo].[FactInternetSales_Staging]
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
) ON [InternetSales_2013]
WITH (DATA_COMPRESSION = PAGE);
GO

--Execute the following statement (lines 58-87) to load the staging table
--with 2013 facts
INSERT
	[dbo].[FactInternetSales_Staging]
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
	[OrderDateKey] BETWEEN 20130101 AND 20131231;
GO

--Execute the following statement (lines 92-93) to create exactly the same structured clustered index
--as defined on the partitioned table. This is required.
CREATE CLUSTERED COLUMNSTORE INDEX [CI_FactInternetSales_Staging]
ON [dbo].[FactInternetSales_Staging];
GO

--Execute the following statement (lines 98-99) to create a similar structured non-clustered index
--as defined on the partitioned table (notice that the the partition column must be included)
CREATE NONCLUSTERED INDEX [NCI_FactInternetSales_Staging_SalesOrderNumber]
ON [dbo].[FactInternetSales_Staging] ([SalesOrderNumber], [SalesOrderLineNumber]) INCLUDE ([OrderDateKey]);
GO

--Execute the following statement (lines 104-105) to create a check constraint that verifies that
--the data is in the correct range. This is required.
ALTER TABLE [dbo].[FactInternetSales_Staging]
ADD CONSTRAINT [CK_FactInternetSales_Staging] CHECK ([OrderDateKey] BETWEEN 20130101 AND 20131231);
GO

--Execute the following statement (line 111) to review the partion row counts
--Notice that the last two partitions are empty. The second-last partition is about to be switched out;
--The last partition is required to allow future partition splitting
SELECT * FROM [dbo].[udfPartitionInfo](N'dbo', N'FactInternetSales_Partitioned');
GO

--Execute the following statement (line 116) to modify the partition scheme to insert
--a new partition for 2014
ALTER PARTITION SCHEME [AnnualSalesScheme] NEXT USED [InternetSales_2014];
GO

--Execute the following statement (line 121) to modify the partition function to split
--the range at 2014
ALTER PARTITION FUNCTION [AnnualSales]() SPLIT RANGE (20140101);
GO

--Execute the following statement (line 125) to review the partion row counts
SELECT * FROM [dbo].[udfPartitionInfo](N'dbo', N'FactInternetSales_Partitioned');
GO

--Execute the following statement (line 129) to switch in the staging data
ALTER TABLE [dbo].[FactInternetSales_Staging] SWITCH TO [dbo].[FactInternetSales_Partitioned] PARTITION 5;
GO

--Execute the following statement (line 133) to review the partion row counts
SELECT * FROM [dbo].[udfPartitionInfo](N'dbo', N'FactInternetSales_Partitioned');
GO
