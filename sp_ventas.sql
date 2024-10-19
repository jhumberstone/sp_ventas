create or alter procedure sp_ventas as
begin
 /*Seleccion de las ventas en línea y sus dimensiones fecha, producto, cliente, región y promoción*/
 begin try
	SELECT        FactInternetSales.SalesOrderNumber, FactInternetSales.OrderDate, FactInternetSales.DueDate, FactInternetSales.ShipDate, FactInternetSales.SalesAmount, DimProduct.EnglishProductName, 
                         DimProductSubcategory.EnglishProductSubcategoryName, DimProductCategory.EnglishProductCategoryName, DimCustomer.BirthDate, datediff(year,DimCustomer.BirthDate,GETDATE()) as Age,DimCustomer.MaritalStatus, DimCustomer.Gender, DimPromotion.EnglishPromotionName, 
                         DimSalesTerritory.SalesTerritoryRegion, DimSalesTerritory.SalesTerritoryCountry, DimSalesTerritory.SalesTerritoryGroup
	FROM            DimSalesTerritory INNER JOIN
                         DimPromotion INNER JOIN
                         DimProductSubcategory INNER JOIN
                         DimProduct ON DimProductSubcategory.ProductSubcategoryKey = DimProduct.ProductSubcategoryKey INNER JOIN
                         DimProductCategory ON DimProductSubcategory.ProductCategoryKey = DimProductCategory.ProductCategoryKey INNER JOIN
                         FactInternetSales ON DimProduct.ProductKey = FactInternetSales.ProductKey INNER JOIN
                         DimCurrency ON FactInternetSales.CurrencyKey = DimCurrency.CurrencyKey INNER JOIN
                         DimCustomer ON FactInternetSales.CustomerKey = DimCustomer.CustomerKey ON DimPromotion.PromotionKey = FactInternetSales.PromotionKey ON DimSalesTerritory.SalesTerritoryKey = FactInternetSales.SalesTerritoryKey
 end try
 begin catch
 /*Mostrar error en caso de fallo */
 select GETDATE() as fecha_error, 'sp_ventas' as objeto, ERROR_NUMBER() num_error, ERROR_LINE() linea_error, ERROR_MESSAGE() mensaje_error 
 into #tmp_error_log
 end catch
end;