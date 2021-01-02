CREATE TYPE OrderDetailsTable AS TABLE (MenuItemId INT,Quantity INT)
GO
CREATE TYPE ReservationTable AS TABLE (TableId INT, ReservedFor VARCHAR(255),ReservedFrom DATETIME, ReservedTo DATETIME)
GO

CREATE PROCEDURE makeOrder
(@branchId INT,@customerId INT,@discountType INT, @orderServeDate DATETIME,@orderDetails OrderDetailsTable READONLY,@reservations ReservationTable READONLY)
AS
BEGIN

DECLARE @priceWithoutDiscount MONEY = (SELECT SUM(UnitPrice * Quantity) FROM MenuItems LEFT JOIN @orderDetails od ON MenuItems.MenuItemId = od.MenuItemId);
DECLARE @finalPrice MONEY;
DECLARE @discount REAL;

SET @discount = CASE @discountType
	WHEN 1 THEN dbo.calculateDiscountWithId1(@customerId)
	WHEN 2 THEN dbo.calculateDiscountWithId2(@customerId)
	WHEN 3 THEN dbo.calculateDiscountWithId3(@customerId)
	WHEN 4 THEN dbo.calculateDiscountWithId4(@customerId)
	WHEN 5 THEN dbo.calculateDiscountWithId5(@customerId)
	ELSE 0
END;

SET @finalPrice = @priceWithoutDiscount * (1 - @discount)

DECLARE @withReservation BIT = (SELECT (CASE COUNT(*) WHEN 0 THEN 0 ELSE 1 END)  FROM @reservations)

DECLARE @orderIdTable TABLE(orderId INT);
INSERT INTO Orders(BranchId,CustomerId,StatusId,WithReservation,PriceWithoutDiscount,DiscountTypeId,Discount,FinalPrice,Paid,OrderMadeDate,OrderServeDate)
OUTPUT inserted.OrderId INTO @orderIdTable
VALUES(@branchId,@customerId,1,@withReservation,@priceWithoutDiscount,@discountType,@discount,@finalPrice,0,GETDATE(),@orderServeDate);

DECLARE @orderId INT = (SELECT TOP 1 orderId FROM @orderIdTable);

INSERT INTO OrderDetails SELECT @orderId,MenuItemId,Quantity FROM @orderDetails;
INSERT INTO ReservationsInfo SELECT @orderId,* FROM @reservations


END
