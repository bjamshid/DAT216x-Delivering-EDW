IF EXISTS(SELECT * FROM [sys].[databases] WHERE [name] = N'AdventureWorksDW2016')
BEGIN
	ALTER DATABASE [AdventureWorksDW2016] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
END;
GO
RESTORE DATABASE [AdventureWorksDW2016] FROM  DISK = N'F:\Labs\Setup\Backups\AdventureWorksDW2016-DAT216x-Baseline.bak'
WITH
	FILE = 1
	,MOVE N'AdventureWorksDW2014_Data' TO N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\AdventureWorksDW2016_Data.mdf'
	,MOVE N'AdventureWorksDW2014_Log' TO N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\AdventureWorksDW2016_Log.ldf'
	,NOUNLOAD
	,REPLACE
	,STATS = 100
	,NORECOVERY;
GO
RESTORE DATABASE [AdventureWorksDW2016] FROM  DISK = N'F:\Labs\Setup\Backups\AdventureWorksDW2016-DAT216x-Lab02Completed-Diff.bak'
WITH
	FILE = 1
	,MOVE N'AdventureWorksDW2014_Data' TO N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\AdventureWorksDW2016_Data.mdf'
	,MOVE N'AdventureWorksDW2014_Log' TO N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\AdventureWorksDW2016_Log.ldf'
	,NOUNLOAD
	,REPLACE
	,STATS = 100
	,RECOVERY;
GO