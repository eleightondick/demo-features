USE AdventureWorks2012;
GO

-- Select the data from the table to show it without changes
SELECT BusinessEntityID, TerritoryID, SalesQuota
	FROM Sales.SalesPerson
	WHERE TerritoryID IS NOT NULL
	ORDER BY BusinessEntityID;
GO

-- Now start an update in another session

-- Try selecting the data
SELECT BusinessEntityID, TerritoryID, SalesQuota
	FROM Sales.SalesPerson
	WHERE TerritoryID IS NOT NULL
	ORDER BY BusinessEntityID;
GO

-- Try again, this time with NOLOCK
SELECT BusinessEntityID, TerritoryID, SalesQuota
	FROM Sales.SalesPerson WITH(NOLOCK)
	WHERE TerritoryID IS NOT NULL
	ORDER BY BusinessEntityID;
GO

-- What happened?

-- Rollback the other session

-- Turn on snapshot isolation
USE master;
ALTER DATABASE AdventureWorks2012
	SET ALLOW_SNAPSHOT_ISOLATION ON;
GO

USE AdventureWorks2012;
GO

-- Start the update again in the other session

-- Enable snapshot isolation
SET TRANSACTION ISOLATION LEVEL SNAPSHOT;

-- Try selecting the data
SELECT BusinessEntityID, TerritoryID, SalesQuota
	FROM Sales.SalesPerson
	WHERE TerritoryID IS NOT NULL
	ORDER BY BusinessEntityID;
GO

-- What happened?

-- Rollback the other session

-- Turn on READ COMMITTED SNAPSHOT
USE master;
ALTER DATABASE AdventureWorks2012
	SET READ_COMMITTED_SNAPSHOT ON;
GO

USE AdventureWorks2012;
GO

-- Start the update again in the other session

-- Try selecting the data
SELECT BusinessEntityID, TerritoryID, SalesQuota
	FROM Sales.SalesPerson
	WHERE TerritoryID IS NOT NULL
	ORDER BY BusinessEntityID;
GO

-- What happened?

-- Commit the change in the other session

-- Select one more time to show that the change has now happened
SELECT BusinessEntityID, TerritoryID, SalesQuota
	FROM Sales.SalesPerson
	WHERE TerritoryID IS NOT NULL
	ORDER BY BusinessEntityID;
GO
