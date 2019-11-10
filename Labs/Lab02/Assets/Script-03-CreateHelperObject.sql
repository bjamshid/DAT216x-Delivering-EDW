--Execute the ENTIRE script
USE [AdventureWorksDW2016];
GO

--Creates a function to return partition details for a given schema and table
--This will be used to understand the partitions defined for a table
CREATE FUNCTION [dbo].[udfPartitionInfo](@SchemaName SYSNAME, @TableName SYSNAME)
RETURNS TABLE AS
RETURN
(
	SELECT
		[p].[partition_number]
		,[p].[rows]
	FROM
		[sys].[partitions] AS [p]
		INNER JOIN [sys].[tables] AS [t]
			ON [t].[object_id] = [p].[object_id]
		INNER JOIN [sys].[schemas] AS [s]
			ON [s].[schema_id] = [t].[schema_id]
	WHERE
		[s].[name] = @SchemaName
		AND [t].[name] = @TableName
		AND [p].[index_id] IN (0, 1)
);
GO
