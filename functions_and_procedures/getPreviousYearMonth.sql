CREATE FUNCTION getPreviousYearMonth (@YM INT)
RETURNS INT
AS
BEGIN
IF @YM % 100 = 1 RETURN @YM - 89;
RETURN @YM - 1;
END