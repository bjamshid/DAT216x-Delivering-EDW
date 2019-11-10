--Execute the ENTIRE script
USE [AdventureWorksDW2016];
GO

--Creates a function to convert date values to date keys in YYYMMDD integer format
--This will be used to reload data into an optimized DimProduct table
CREATE FUNCTION [dbo].[udfConvertDateToDateKey](@Date DATE)
RETURNS INT
AS
BEGIN
	RETURN (YEAR(@Date) * 10000) + (MONTH(@Date) * 100) + DAY(@Date);
END;
GO
