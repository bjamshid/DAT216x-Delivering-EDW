IF EXISTS(SELECT * FROM [sys].[databases] WHERE [name] = N'AdventureWorks2016')
BEGIN
	ALTER DATABASE [AdventureWorks2016] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
END;
GO
RESTORE DATABASE [AdventureWorks2016] FROM  DISK = N'F:\Labs\Setup\Backups\AdventureWorks2016-DAT216x-Baseline.bak'
WITH
	FILE = 1
	,MOVE N'AdventureWorks2016CTP3_Data' TO N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\AdventureWorks2016_Data.mdf'
	,MOVE N'AdventureWorks2016CTP3_Log' TO N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\AdventureWorks2016_Log.ldf'
	,MOVE N'AdventureWorks2016CTP3_mod' TO N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\AdventureWorks2016_mod'
	,NOUNLOAD
	,REPLACE
	,STATS = 100;
GO