--Execute the ENTIRE script
USE [AdventureWorksDW2016];
GO

--Review the count of date records, and maximum date record loaded to the 
--DimDate table
SELECT
	COUNT(*) AS [DateRecords]
	,MAX([DateKey]) AS [MaxDateKey]
FROM
	[dbo].[DimDate];
GO

/*
First result:
  DateRecords: 3652 
  MaxDateKey:  20141231

Second result:
  DateRecords: 4564 
  MaxDateKey:  20170630
*/
