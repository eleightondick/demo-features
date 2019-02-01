USE AdventureWorks2012;
GO

SET STATISTICS IO ON;

SELECT qh.BusinessEntityID,
	   qh.QuotaDate,
	   qh.SalesQuota,
	   py.SalesQuota AS PreviousYearQuota
	FROM Sales.SalesPersonQuotaHistory qh
		LEFT OUTER JOIN Sales.SalesPersonQuotaHistory py 
			ON py.BusinessEntityID = qh.BusinessEntityID 
				AND py.QuotaDate = (SELECT MAX(py2.QuotaDate) 
										FROM Sales.SalesPersonQuotaHistory py2 
										WHERE py2.BusinessEntityID = qh.BusinessEntityID 
										  AND py2.QuotaDate < qh.QuotaDate)
	ORDER BY BusinessEntityID, QuotaDate;
GO

SELECT BusinessEntityID, 
	   QuotaDate, 
	   SalesQuota,
	   LAG(SalesQuota, 1, NULL) 
			OVER(PARTITION BY BusinessEntityID ORDER BY QuotaDate) AS PreviousYearQuota 
	FROM Sales.SalesPersonQuotaHistory
	ORDER BY BusinessEntityID, QuotaDate;
GO

SELECT BusinessEntityID, 
	   QuotaDate, 
	   SalesQuota,
	   LAG(SalesQuota, 1, NULL) 
			OVER(PARTITION BY BusinessEntityID ORDER BY QuotaDate) AS PreviousYearQuota,
	   LEAD(SalesQuota, 1, SalesQuota * 1.10) 
			OVER(PARTITION BY BusinessEntityID ORDER BY QuotaDate) AS NextYearQuota
	FROM Sales.SalesPersonQuotaHistory
	ORDER BY BusinessEntityID, QuotaDate;
GO