CREATE FUNCTION getPossibleDiscounts (@customerId INT)
RETURNS @possibleDiscounts TABLE (DiscountId INT,DiscountValue REAL)
AS
BEGIN

    IF (SELECT RepresentingCompany FROM Customers WHERE CustomerId = @customerId) = 0 
    BEGIN
        DECLARE @discount1 REAL = dbo.calculateDiscountWithId1(@customerId);
        IF @discount1 > 0 INSERT INTO @possibleDiscounts VALUES (1,@discount1);

        DECLARE @discount2 REAL = dbo.calculateDiscountWithId2(@customerId);
        IF @discount2 > 0 INSERT INTO @possibleDiscounts VALUES (2,@discount2);
        
        DECLARE @discount3 REAL = dbo.calculateDiscountWithId3(@customerId);
        IF @discount3 > 0 INSERT INTO @possibleDiscounts VALUES (3,@discount3);
    END 
    ELSE 
    BEGIN
        DECLARE @discount4 REAL = dbo.calculateDiscountWithId4(@customerId);
        IF @discount4 > 0 INSERT INTO @possibleDiscounts VALUES (4,@discount4);

        DECLARE @discount5 REAL = dbo.calculateDiscountWithId5(@customerId);
        IF @discount5 > 0 INSERT INTO @possibleDiscounts VALUES (5,@discount5);
    END

    RETURN;
END