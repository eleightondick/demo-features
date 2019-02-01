USE AdventureWorks2012;
GO

SET STATISTICS IO ON;

-- Running total - cursor
DECLARE @runningTotal money;
DECLARE @curTerritoryID int;
DECLARE @curSalesOrderID int;
DECLARE @curOrderDate datetime;
DECLARE @curSubTotal money;
DECLARE @lastTerritoryID int;

DECLARE @wkTotals TABLE (TerritoryID int,
						 SalesOrderID int,
						 OrderDate datetime,
						 SubTotal money,
						 RunningTotal money);

DECLARE cOrders CURSOR FOR
	SELECT h.TerritoryID, h.SalesOrderID, h.OrderDate, h.SubTotal
		FROM sales.SalesOrderHeader h
		WHERE h.OrderDate BETWEEN '12/1/2005' AND '12/31/2005'
		ORDER BY h.TerritoryID, h.OrderDate, h.SalesOrderID;

SET @lastTerritoryID = -1;

OPEN cOrders;
FETCH NEXT FROM cOrders INTO @curTerritoryID, @curSalesOrderID, @curOrderDate, @curSubTotal;
WHILE @@FETCH_STATUS = 0 BEGIN
	IF @curTerritoryID <> @lastTerritoryID BEGIN
		SET @runningTotal = 0.00;
		SET @lastTerritoryID = @curTerritoryID;
	END

	SET @runningTotal = @runningTotal + @curSubTotal;
	INSERT INTO @wkTotals (TerritoryID, SalesOrderID, OrderDate, SubTotal, RunningTotal)
		VALUES (@curTerritoryID, @curSalesOrderID, @curOrderDate, @curSubTotal, @runningTotal);

	FETCH NEXT FROM cOrders INTO @curTerritoryID, @curSalesOrderID, @curOrderDate, @curSubTotal;
END

CLOSE cOrders;
DEALLOCATE cOrders;

SELECT TerritoryID, OrderDate, SalesOrderID, SubTotal, RunningTotal
	FROM @wkTotals
	ORDER BY TerritoryID, OrderDate, SalesOrderID;
GO

-- Running total - correlated subquery
SELECT h.TerritoryID, h.SalesOrderID, h.OrderDate, h.SubTotal, 
		(SELECT SUM(h2.SubTotal) 
			FROM Sales.SalesOrderHeader h2 
			WHERE h2.TerritoryID = h.TerritoryID 
			  AND h2.OrderDate BETWEEN '12/1/2005' AND '12/31/2005' 
			  AND h2.SalesOrderID <= h.SalesOrderID) AS RunningTotal
	FROM sales.SalesOrderHeader h
	WHERE h.OrderDate BETWEEN '12/1/2005' AND '12/31/2005'
	ORDER BY h.TerritoryID, h.OrderDate, h.SalesOrderID;
GO

-- Running total - join
SELECT h.TerritoryID, h.SalesOrderID, h.OrderDate, h.SubTotal, 
		SUM(h2.SubTotal) AS RunningTotal
	FROM Sales.SalesOrderHeader h
		INNER JOIN Sales.SalesOrderHeader h2 ON h2.TerritoryID = h.TerritoryID 
											AND h2.OrderDate BETWEEN '12/1/2005' AND '12/31/2005' 
											AND h2.SalesOrderID <= h.SalesOrderID
	WHERE h.OrderDate BETWEEN '12/1/2005' AND '12/31/2005'
	GROUP BY h.TerritoryID, h.OrderDate, h.SalesOrderID, h.SubTotal
	ORDER BY h.TerritoryID, h.OrderDate, h.SalesOrderID;
GO

-- Running total - window function
SELECT h.TerritoryID, h.SalesOrderID, h.OrderDate, h.SubTotal, 
		SUM(h.SubTotal) OVER(PARTITION BY h.TerritoryID ORDER BY h.OrderDate, h.SalesOrderID)
	FROM sales.SalesOrderHeader h
	WHERE h.OrderDate BETWEEN '12/1/2005' AND '12/31/2005'
	ORDER BY h.TerritoryID, h.OrderDate, h.SalesOrderID;
GO

-- Running totals - last 3 orders
SELECT h.TerritoryID, 
	   h.SalesOrderID, 
	   h.OrderDate, 
	   h.SubTotal, 
	   SUM(h.SubTotal) OVER(PARTITION BY h.TerritoryID 
							ORDER BY h.OrderDate, h.SalesOrderID
							ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)
	FROM sales.SalesOrderHeader h
	WHERE h.OrderDate BETWEEN '12/1/2005' AND '12/31/2005'
	ORDER BY h.TerritoryID, h.OrderDate, h.SalesOrderID;
GO