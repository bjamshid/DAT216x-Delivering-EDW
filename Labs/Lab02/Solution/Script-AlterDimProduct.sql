USE [AdventureWorksDW2016];
GO
/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON; SET ANSI_PADDING ON; SET ANSI_WARNINGS ON;
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.FactResellerSales
	DROP CONSTRAINT FK_FactResellerSales_DimReseller
GO
ALTER TABLE dbo.DimReseller SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.FactResellerSales
	DROP CONSTRAINT FK_FactResellerSales_DimEmployee
GO
ALTER TABLE dbo.DimEmployee SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.FactInternetSales
	DROP CONSTRAINT FK_FactInternetSales_DimSalesTerritory
GO
ALTER TABLE dbo.FactResellerSales
	DROP CONSTRAINT FK_FactResellerSales_DimSalesTerritory
GO
ALTER TABLE dbo.DimSalesTerritory SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.FactInternetSales
	DROP CONSTRAINT FK_FactInternetSales_DimPromotion
GO
ALTER TABLE dbo.FactResellerSales
	DROP CONSTRAINT FK_FactResellerSales_DimPromotion
GO
ALTER TABLE dbo.DimPromotion SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.FactInternetSales
	DROP CONSTRAINT FK_FactInternetSales_DimDate
GO
ALTER TABLE dbo.FactInternetSales
	DROP CONSTRAINT FK_FactInternetSales_DimDate1
GO
ALTER TABLE dbo.FactInternetSales
	DROP CONSTRAINT FK_FactInternetSales_DimDate2
GO
ALTER TABLE dbo.FactProductInventory
	DROP CONSTRAINT FK_FactProductInventory_DimDate
GO
ALTER TABLE dbo.FactResellerSales
	DROP CONSTRAINT FK_FactResellerSales_DimDate
GO
ALTER TABLE dbo.FactResellerSales
	DROP CONSTRAINT FK_FactResellerSales_DimDate1
GO
ALTER TABLE dbo.FactResellerSales
	DROP CONSTRAINT FK_FactResellerSales_DimDate2
GO
ALTER TABLE dbo.DimDate SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.FactInternetSales
	DROP CONSTRAINT FK_FactInternetSales_DimCustomer
GO
ALTER TABLE dbo.DimCustomer SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.FactInternetSales
	DROP CONSTRAINT FK_FactInternetSales_DimCurrency
GO
ALTER TABLE dbo.FactResellerSales
	DROP CONSTRAINT FK_FactResellerSales_DimCurrency
GO
ALTER TABLE dbo.DimCurrency SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.DimProduct
	DROP CONSTRAINT FK_DimProduct_DimProductSubcategory
GO
ALTER TABLE dbo.DimProductSubcategory SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_DimProduct
	(
	ProductKey smallint NOT NULL IDENTITY (1, 1),
	ProductAlternateKey nvarchar(25) NULL,
	ProductSubcategoryKey int NOT NULL,
	WeightUnitMeasureCode nchar(3) NULL,
	SizeUnitMeasureCode nchar(3) NULL,
	EnglishProductName nvarchar(50) NOT NULL,
	SpanishProductName nvarchar(50) NOT NULL,
	FrenchProductName nvarchar(50) NOT NULL,
	StandardCost money NULL,
	FinishedGoodsFlag bit NOT NULL,
	Color nvarchar(15) NOT NULL,
	SafetyStockLevel smallint NULL,
	ReorderPoint smallint NULL,
	ListPrice money NULL,
	Size nvarchar(50) NULL,
	SizeRange nvarchar(50) NULL,
	Weight float(53) NULL,
	DaysToManufacture int NULL,
	ProductLine nchar(2) NULL,
	DealerPrice money NULL,
	Class nchar(2) NULL,
	Style nchar(2) NULL,
	ModelName nvarchar(50) NULL,
	LargePhoto varbinary(MAX) NULL,
	EnglishDescription nvarchar(400) NULL,
	FrenchDescription nvarchar(400) NULL,
	ChineseDescription nvarchar(400) NULL,
	ArabicDescription nvarchar(400) NULL,
	HebrewDescription nvarchar(400) NULL,
	ThaiDescription nvarchar(400) NULL,
	GermanDescription nvarchar(400) NULL,
	JapaneseDescription nvarchar(400) NULL,
	TurkishDescription nvarchar(400) NULL,
	StartDateKey int NOT NULL,
	EndDateKey int NOT NULL CONSTRAINT [DF_DimProduct_EndDateKey] DEFAULT (99991231),
	IsCurrent AS CAST(CASE WHEN EndDateKey = 99991231 THEN 1 ELSE 0 END AS BIT) PERSISTED
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_DimProduct SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_DimProduct ON
GO
IF EXISTS(SELECT * FROM dbo.DimProduct)
	 EXEC('INSERT INTO dbo.Tmp_DimProduct (ProductKey, ProductAlternateKey, ProductSubcategoryKey, WeightUnitMeasureCode, SizeUnitMeasureCode, EnglishProductName, SpanishProductName, FrenchProductName, StandardCost, FinishedGoodsFlag, Color, SafetyStockLevel, ReorderPoint, ListPrice, Size, SizeRange, Weight, DaysToManufacture, ProductLine, DealerPrice, Class, Style, ModelName, LargePhoto, EnglishDescription, FrenchDescription, ChineseDescription, ArabicDescription, HebrewDescription, ThaiDescription, GermanDescription, JapaneseDescription, TurkishDescription, StartDateKey, EndDateKey)
		SELECT CONVERT(smallint, ProductKey), ProductAlternateKey, ISNULL(ProductSubcategoryKey, -1), WeightUnitMeasureCode, SizeUnitMeasureCode, EnglishProductName, SpanishProductName, FrenchProductName, StandardCost, FinishedGoodsFlag, Color, SafetyStockLevel, ReorderPoint, ListPrice, Size, SizeRange, Weight, DaysToManufacture, ProductLine, DealerPrice, Class, Style, ModelName, LargePhoto, EnglishDescription, FrenchDescription, ChineseDescription, ArabicDescription, HebrewDescription, ThaiDescription, GermanDescription, JapaneseDescription, TurkishDescription, [dbo].[udfConvertDateToDateKey](StartDate), [dbo].[udfConvertDateToDateKey](ISNULL(EndDate, ''99991231'')) FROM dbo.DimProduct WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_DimProduct OFF
GO
ALTER TABLE dbo.FactInternetSales
	DROP CONSTRAINT FK_FactInternetSales_DimProduct
GO
ALTER TABLE dbo.FactProductInventory
	DROP CONSTRAINT FK_FactProductInventory_DimProduct
GO
ALTER TABLE dbo.FactResellerSales
	DROP CONSTRAINT FK_FactResellerSales_DimProduct
GO
DROP TABLE dbo.DimProduct
GO
EXECUTE sp_rename N'dbo.Tmp_DimProduct', N'DimProduct', 'OBJECT' 
GO
ALTER TABLE dbo.DimProduct ADD CONSTRAINT
	PK_DimProduct_ProductKey PRIMARY KEY CLUSTERED 
	(
	ProductKey
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.DimProduct ADD CONSTRAINT
	AK_DimProduct_ProductAlternateKey_StartDate UNIQUE NONCLUSTERED 
	(
	ProductAlternateKey,
	StartDateKey
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.DimProduct ADD CONSTRAINT
	FK_DimProduct_DimProductSubcategory FOREIGN KEY
	(
	ProductSubcategoryKey
	) REFERENCES dbo.DimProductSubcategory
	(
	ProductSubcategoryKey
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_FactResellerSales
	(
	ProductKey smallint NOT NULL,
	OrderDateKey int NOT NULL,
	DueDateKey int NOT NULL,
	ShipDateKey int NOT NULL,
	ResellerKey int NOT NULL,
	EmployeeKey int NOT NULL,
	PromotionKey int NOT NULL,
	CurrencyKey int NOT NULL,
	SalesTerritoryKey int NOT NULL,
	SalesOrderNumber nvarchar(20) NOT NULL,
	SalesOrderLineNumber tinyint NOT NULL,
	RevisionNumber tinyint NULL,
	OrderQuantity smallint NULL,
	UnitPrice money NULL,
	ExtendedAmount money NULL,
	UnitPriceDiscountPct float(53) NULL,
	DiscountAmount float(53) NULL,
	ProductStandardCost money NULL,
	TotalProductCost money NULL,
	SalesAmount money NULL,
	TaxAmt money NULL,
	Freight money NULL,
	CarrierTrackingNumber nvarchar(25) NULL,
	CustomerPONumber nvarchar(25) NULL,
	OrderDate datetime NULL,
	DueDate datetime NULL,
	ShipDate datetime NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_FactResellerSales SET (LOCK_ESCALATION = TABLE)
GO
IF EXISTS(SELECT * FROM dbo.FactResellerSales)
	 EXEC('INSERT INTO dbo.Tmp_FactResellerSales (ProductKey, OrderDateKey, DueDateKey, ShipDateKey, ResellerKey, EmployeeKey, PromotionKey, CurrencyKey, SalesTerritoryKey, SalesOrderNumber, SalesOrderLineNumber, RevisionNumber, OrderQuantity, UnitPrice, ExtendedAmount, UnitPriceDiscountPct, DiscountAmount, ProductStandardCost, TotalProductCost, SalesAmount, TaxAmt, Freight, CarrierTrackingNumber, CustomerPONumber, OrderDate, DueDate, ShipDate)
		SELECT CONVERT(smallint, ProductKey), OrderDateKey, DueDateKey, ShipDateKey, ResellerKey, EmployeeKey, PromotionKey, CurrencyKey, SalesTerritoryKey, SalesOrderNumber, SalesOrderLineNumber, RevisionNumber, OrderQuantity, UnitPrice, ExtendedAmount, UnitPriceDiscountPct, DiscountAmount, ProductStandardCost, TotalProductCost, SalesAmount, TaxAmt, Freight, CarrierTrackingNumber, CustomerPONumber, OrderDate, DueDate, ShipDate FROM dbo.FactResellerSales WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.FactResellerSales
GO
EXECUTE sp_rename N'dbo.Tmp_FactResellerSales', N'FactResellerSales', 'OBJECT' 
GO
ALTER TABLE dbo.FactResellerSales ADD CONSTRAINT
	PK_FactResellerSales_SalesOrderNumber_SalesOrderLineNumber PRIMARY KEY CLUSTERED 
	(
	SalesOrderNumber,
	SalesOrderLineNumber
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.FactResellerSales ADD CONSTRAINT
	FK_FactResellerSales_DimCurrency FOREIGN KEY
	(
	CurrencyKey
	) REFERENCES dbo.DimCurrency
	(
	CurrencyKey
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.FactResellerSales ADD CONSTRAINT
	FK_FactResellerSales_DimDate FOREIGN KEY
	(
	OrderDateKey
	) REFERENCES dbo.DimDate
	(
	DateKey
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.FactResellerSales ADD CONSTRAINT
	FK_FactResellerSales_DimDate1 FOREIGN KEY
	(
	DueDateKey
	) REFERENCES dbo.DimDate
	(
	DateKey
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.FactResellerSales ADD CONSTRAINT
	FK_FactResellerSales_DimDate2 FOREIGN KEY
	(
	ShipDateKey
	) REFERENCES dbo.DimDate
	(
	DateKey
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.FactResellerSales ADD CONSTRAINT
	FK_FactResellerSales_DimEmployee FOREIGN KEY
	(
	EmployeeKey
	) REFERENCES dbo.DimEmployee
	(
	EmployeeKey
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.FactResellerSales ADD CONSTRAINT
	FK_FactResellerSales_DimProduct FOREIGN KEY
	(
	ProductKey
	) REFERENCES dbo.DimProduct
	(
	ProductKey
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.FactResellerSales ADD CONSTRAINT
	FK_FactResellerSales_DimPromotion FOREIGN KEY
	(
	PromotionKey
	) REFERENCES dbo.DimPromotion
	(
	PromotionKey
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.FactResellerSales ADD CONSTRAINT
	FK_FactResellerSales_DimReseller FOREIGN KEY
	(
	ResellerKey
	) REFERENCES dbo.DimReseller
	(
	ResellerKey
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.FactResellerSales ADD CONSTRAINT
	FK_FactResellerSales_DimSalesTerritory FOREIGN KEY
	(
	SalesTerritoryKey
	) REFERENCES dbo.DimSalesTerritory
	(
	SalesTerritoryKey
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_FactProductInventory
	(
	ProductKey smallint NOT NULL,
	DateKey int NOT NULL,
	UnitCost money NOT NULL,
	UnitsBalance int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_FactProductInventory SET (LOCK_ESCALATION = TABLE)
GO
IF EXISTS(SELECT * FROM dbo.FactProductInventory)
	 EXEC('INSERT INTO dbo.Tmp_FactProductInventory (ProductKey, DateKey, UnitCost, UnitsBalance)
		SELECT CONVERT(smallint, ProductKey), DateKey, UnitCost, UnitsBalance FROM dbo.FactProductInventory WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.FactProductInventory
GO
EXECUTE sp_rename N'dbo.Tmp_FactProductInventory', N'FactProductInventory', 'OBJECT' 
GO
ALTER TABLE dbo.FactProductInventory ADD CONSTRAINT
	PK_FactProductInventory PRIMARY KEY CLUSTERED 
	(
	ProductKey,
	DateKey
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.FactProductInventory ADD CONSTRAINT
	FK_FactProductInventory_DimDate FOREIGN KEY
	(
	DateKey
	) REFERENCES dbo.DimDate
	(
	DateKey
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.FactProductInventory ADD CONSTRAINT
	FK_FactProductInventory_DimProduct FOREIGN KEY
	(
	ProductKey
	) REFERENCES dbo.DimProduct
	(
	ProductKey
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_FactInternetSales
	(
	ProductKey smallint NOT NULL,
	OrderDateKey int NOT NULL,
	DueDateKey int NOT NULL,
	ShipDateKey int NOT NULL,
	CustomerKey int NOT NULL,
	PromotionKey int NOT NULL,
	CurrencyKey int NOT NULL,
	SalesTerritoryKey int NOT NULL,
	SalesOrderNumber nvarchar(20) NOT NULL,
	SalesOrderLineNumber tinyint NOT NULL,
	RevisionNumber tinyint NOT NULL,
	OrderQuantity smallint NOT NULL,
	UnitPrice money NOT NULL,
	ExtendedAmount money NOT NULL,
	UnitPriceDiscountPct float(53) NOT NULL,
	DiscountAmount float(53) NOT NULL,
	ProductStandardCost money NOT NULL,
	TotalProductCost money NOT NULL,
	SalesAmount money NOT NULL,
	TaxAmt money NOT NULL,
	Freight money NOT NULL,
	CarrierTrackingNumber nvarchar(25) NULL,
	CustomerPONumber nvarchar(25) NULL,
	OrderDate datetime NULL,
	DueDate datetime NULL,
	ShipDate datetime NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_FactInternetSales SET (LOCK_ESCALATION = TABLE)
GO
IF EXISTS(SELECT * FROM dbo.FactInternetSales)
	 EXEC('INSERT INTO dbo.Tmp_FactInternetSales (ProductKey, OrderDateKey, DueDateKey, ShipDateKey, CustomerKey, PromotionKey, CurrencyKey, SalesTerritoryKey, SalesOrderNumber, SalesOrderLineNumber, RevisionNumber, OrderQuantity, UnitPrice, ExtendedAmount, UnitPriceDiscountPct, DiscountAmount, ProductStandardCost, TotalProductCost, SalesAmount, TaxAmt, Freight, CarrierTrackingNumber, CustomerPONumber, OrderDate, DueDate, ShipDate)
		SELECT CONVERT(smallint, ProductKey), OrderDateKey, DueDateKey, ShipDateKey, CustomerKey, PromotionKey, CurrencyKey, SalesTerritoryKey, SalesOrderNumber, SalesOrderLineNumber, RevisionNumber, OrderQuantity, UnitPrice, ExtendedAmount, UnitPriceDiscountPct, DiscountAmount, ProductStandardCost, TotalProductCost, SalesAmount, TaxAmt, Freight, CarrierTrackingNumber, CustomerPONumber, OrderDate, DueDate, ShipDate FROM dbo.FactInternetSales WITH (HOLDLOCK TABLOCKX)')
GO
ALTER TABLE dbo.FactInternetSalesReason
	DROP CONSTRAINT FK_FactInternetSalesReason_FactInternetSales
GO
DROP TABLE dbo.FactInternetSales
GO
EXECUTE sp_rename N'dbo.Tmp_FactInternetSales', N'FactInternetSales', 'OBJECT' 
GO
ALTER TABLE dbo.FactInternetSales ADD CONSTRAINT
	PK_FactInternetSales_SalesOrderNumber_SalesOrderLineNumber PRIMARY KEY CLUSTERED 
	(
	SalesOrderNumber,
	SalesOrderLineNumber
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.FactInternetSales ADD CONSTRAINT
	FK_FactInternetSales_DimCurrency FOREIGN KEY
	(
	CurrencyKey
	) REFERENCES dbo.DimCurrency
	(
	CurrencyKey
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.FactInternetSales ADD CONSTRAINT
	FK_FactInternetSales_DimCustomer FOREIGN KEY
	(
	CustomerKey
	) REFERENCES dbo.DimCustomer
	(
	CustomerKey
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.FactInternetSales ADD CONSTRAINT
	FK_FactInternetSales_DimDate FOREIGN KEY
	(
	OrderDateKey
	) REFERENCES dbo.DimDate
	(
	DateKey
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.FactInternetSales ADD CONSTRAINT
	FK_FactInternetSales_DimDate1 FOREIGN KEY
	(
	DueDateKey
	) REFERENCES dbo.DimDate
	(
	DateKey
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.FactInternetSales ADD CONSTRAINT
	FK_FactInternetSales_DimDate2 FOREIGN KEY
	(
	ShipDateKey
	) REFERENCES dbo.DimDate
	(
	DateKey
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.FactInternetSales ADD CONSTRAINT
	FK_FactInternetSales_DimProduct FOREIGN KEY
	(
	ProductKey
	) REFERENCES dbo.DimProduct
	(
	ProductKey
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.FactInternetSales ADD CONSTRAINT
	FK_FactInternetSales_DimPromotion FOREIGN KEY
	(
	PromotionKey
	) REFERENCES dbo.DimPromotion
	(
	PromotionKey
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.FactInternetSales ADD CONSTRAINT
	FK_FactInternetSales_DimSalesTerritory FOREIGN KEY
	(
	SalesTerritoryKey
	) REFERENCES dbo.DimSalesTerritory
	(
	SalesTerritoryKey
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.FactInternetSalesReason ADD CONSTRAINT
	FK_FactInternetSalesReason_FactInternetSales FOREIGN KEY
	(
	SalesOrderNumber,
	SalesOrderLineNumber
	) REFERENCES dbo.FactInternetSales
	(
	SalesOrderNumber,
	SalesOrderLineNumber
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.FactInternetSalesReason SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
