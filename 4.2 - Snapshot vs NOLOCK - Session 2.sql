USE AdventureWorks2012;
GO

-- Start an update transaction
BEGIN TRANSACTION
	UPDATE Sales.SalesPerson
		SET SalesQuota = 1.00;

-- Roll it back after we're finished
ROLLBACK
USE master;
GO

-- Commit it on the last run
COMMIT
GO