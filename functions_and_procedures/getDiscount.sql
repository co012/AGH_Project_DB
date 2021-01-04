CREATE FUNCTION getDiscount(@discountId INT,@customerId INT)
RETURNS REAL
AS
BEGIN
RETURN CASE @discountId
	WHEN 1 THEN dbo.calculateDiscountWithId1(@customerId)
	WHEN 2 THEN dbo.calculateDiscountWithId2(@customerId)
	WHEN 3 THEN dbo.calculateDiscountWithId3(@customerId)
	WHEN 4 THEN dbo.calculateDiscountWithId4(@customerId)
	WHEN 5 THEN dbo.calculateDiscountWithId5(@customerId)
	ELSE 0
END;

END