--Execute INDIVIDUAL batches as directed

--Use the AdventureWorksDW2016 database
USE [AdventureWorksDW2016];
GO

--Execute the following statement (line 9) to determine data compression savings
--for ROW compression
EXEC sp_estimate_data_compression_savings 'dbo', 'FactInternetSales_Partitioned', NULL, NULL, 'ROW';
GO

--Calculate the size_with_requested_compressions_setting(KB) value divided by the
--size_with_current_compression_setting(KB) value to determine the ROW reduction percentage

--Execute the following statement (line 18) to determine data compression savings
--for PAGE compression
EXEC sp_estimate_data_compression_savings 'dbo', 'FactInternetSales_Partitioned', NULL, NULL, 'PAGE';
GO

--Calculate the size_with_requested_compressions_setting(KB) value divided by the
--size_with_current_compression_setting(KB) value to determine the PAGE reduction percentage

--Execute the following statements (lines 25-26) to compress the FactInternetSales_Partitioned
--table by using PAGE compression
ALTER TABLE [dbo].[FactInternetSales_Partitioned]
REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE);
GO

--Execute the following statement (line 31) to review the space used for the
--FactInternetSales_Partitioned table
EXEC sp_spaceused 'dbo.FactInternetSales_Partitioned';
GO
