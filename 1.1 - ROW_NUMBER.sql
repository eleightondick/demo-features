USE AdventureWorks2012;
GO

-- A simple example
SELECT sp.BusinessEntityID, p.FirstName, p.LastName, 
		ROW_NUMBER() OVER(ORDER BY p.LastName, p.FirstName) AS rowNumber
	FROM Sales.SalesPerson sp
		INNER JOIN Person.Person p ON p.BusinessEntityID = sp.BusinessEntityID
	ORDER BY p.LastName, p.FirstName;
GO

-- Same example, different order than query
SELECT sp.BusinessEntityID, p.FirstName, p.LastName, 
		ROW_NUMBER() OVER(ORDER BY p.LastName, p.FirstName) AS rowNumber
	FROM Sales.SalesPerson sp
		INNER JOIN Person.Person p ON p.BusinessEntityID = sp.BusinessEntityID
	ORDER BY sp.BusinessEntityID;
GO

SET STATISTICS IO ON;

-- First row from a subquery - old method (TOP 1)
SELECT h.SalesOrderID, h.OrderDate, d.SalesOrderDetailID, d.ProductID, d.OrderQty, d.UnitPrice, d.LineTotal
	FROM Sales.SalesOrderHeader h
		INNER JOIN (SELECT * FROM Sales.SalesOrderDetail d1 WHERE d1.SalesOrderDetailID = (SELECT TOP 1 SalesOrderDetailID FROM Sales.SalesOrderDetail d2 WHERE d2.SalesOrderID = d1.SalesOrderID ORDER BY d2.LineTotal DESC)) d ON d.SalesOrderID = h.SalesOrderID;
GO

-- First row from a subquery using ROW_NUMBER and CTEs
WITH DetailRows AS
	(SELECT SalesOrderID, SalesOrderDetailID, ProductID, OrderQty, UnitPrice, LineTotal, 
			ROW_NUMBER() OVER(PARTITION BY SalesOrderID ORDER BY LineTotal DESC) rowNumber
		FROM Sales.SalesOrderDetail)
SELECT h.SalesOrderID, h.OrderDate, d.SalesOrderDetailID, d.ProductID, d.OrderQty, d.UnitPrice, d.LineTotal
	FROM Sales.SalesOrderHeader h
		INNER JOIN DetailRows d ON d.SalesOrderID = h.SalesOrderID AND d.rowNumber = 1;
GO

-- Duplicate row problem
SELECT SalesOrderID, OrderDate
	FROM Sales.BadTable
	ORDER BY SalesOrderID;
GO

WITH DuplicateBuster AS
	(SELECT SalesOrderID, OrderDate, 
			ROW_NUMBER() OVER(PARTITION BY SalesOrderID ORDER BY OrderDate) rowNumber
		FROM Sales.BadTable)
SELECT SalesOrderID, OrderDate, rowNumber
	FROM DuplicateBuster
	ORDER BY SalesOrderID;
GO

WITH DuplicateBuster AS
	(SELECT SalesOrderID, OrderDate, 
			ROW_NUMBER() OVER(PARTITION BY SalesOrderID ORDER BY OrderDate) rowNumber
		FROM Sales.BadTable)
DELETE FROM DuplicateBuster
	WHERE rowNumber <> 1;
GO

SELECT SalesOrderID, OrderDate
	FROM Sales.BadTable
	ORDER BY SalesOrderID;
GO