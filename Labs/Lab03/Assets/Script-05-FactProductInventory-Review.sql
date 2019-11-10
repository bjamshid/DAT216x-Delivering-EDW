--Execute the ENTIRE script
USE [AdventureWorksDW2016];
GO

--Retrieve the count of product inventory fact records for 30 June, 2016
SELECT
	COUNT(*) AS [InventoryRecords]
FROM
	[dbo].[FactProductInventory]
WHERE
	[DateKey] = 20160630;
GO

/*
First result:
  InventoryRecords: 0

Second result:
  InventoryRecords: 432
*/
