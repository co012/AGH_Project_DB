CREATE FUNCTION getPreviousYearQuater(@YQ INT)
RETURNS INT
AS
BEGIN
IF @YQ % 10 = 1 RETURN @YQ - 7;
RETURN @YQ - 1;
END