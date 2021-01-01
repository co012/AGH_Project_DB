CREATE PROCEDURE takeInvoiceForMonth
(@customerId INT, @date DATE)
AS
BEGIN

IF (SELECT RepresentingCompany FROM Customers WHERE CustomerId = @customerId) = 0 RETURN


SELECT Name,Street,StreetNumber,City,PostCode,NIP FROM CompanyInfo LEFT JOIN Customers ON Customers.CompanyId = CompanyInfo.CompanyId WHERE @customerId = CustomerId


SELECT MAX(Name),SUM(Quantity) AS Quantity, (SUM(Quantity) * MAX(UnitPrice)) AS Price 
FROM OrderDetails LEFT JOIN MenuItems ON OrderDetails.MenuItemId = MenuItems.MenuItemId 
WHERE OrderId IN (SELECT OrderId FROM Orders WHERE CustomerId = @customerId AND YEAR(OrderMadeDate) = YEAR(@date) AND MONTH(OrderMadeDate) = MONTH(@date) AND StatusId = 4) GROUP BY OrderDetails.MenuItemId

SELECT SUM(PriceWithoutDiscount) as TotalPriceWithoutDiscount,SUM(FinalPrice) AS TotalFinalPrice 
FROM Orders WHERE OrderId IN 
(SELECT OrderId FROM Orders WHERE CustomerId = @customerId AND YEAR(OrderMadeDate) = YEAR(@date) AND MONTH(OrderMadeDate) = MONTH(@date) AND StatusId = 4)
END