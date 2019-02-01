USE AdventureWorks2012;
GO

CREATE DATABASE AdventureWorks2012_SS
	ON (NAME = AdventureWorks2012_Data, FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\AdventureWorks2012_SS_Data.ss')
	AS SNAPSHOT OF AdventureWorks2012;
GO

-- Create bad table for use in duplicate key demo
IF OBJECT_ID('Sales.BadTable') IS NOT NULL
	DROP TABLE Sales.BadTable;

CREATE TABLE [Sales].[BadTable](
	[SalesOrderID] [int] NOT NULL,
	[OrderDate] [datetime] NOT NULL);

INSERT INTO Sales.BadTable (SalesOrderID, OrderDate)
	SELECT SalesOrderID, OrderDate FROM Sales.SalesOrderHeader
	UNION ALL
	SELECT SalesOrderID, OrderDate FROM Sales.SalesOrderHeader
	UNION ALL
	SELECT SalesOrderID, OrderDate FROM Sales.SalesOrderHeader;
GO