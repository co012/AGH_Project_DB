CREATE FUNCTION getMonthlyRaportAboutReservations(@date DATE)
RETURNS @reservationsReportTable TABLE (BranchId INT, ReservationsNumber INT, ReservationsFromCompanies INT)
AS
BEGIN
DECLARE @branchCursor CURSOR;
DECLARE @branchId INT;
SET @branchCursor = CURSOR FOR SELECT BranchId FROM Branches;

OPEN @branchCursor;
FETCH NEXT FROM @branchCursor INTO @branchId;

WHILE @@FETCH_STATUS = 0
BEGIN
	DECLARE @reservationsNumber INT;
	DECLARE @reservationsFromCompaniesNumber INT;

	SELECT @reservationsNumber = COUNT(*) FROM ReservationsInfo LEFT JOIN Orders ON Orders.OrderId = ReservationsInfo.OrderId 
	WHERE YEAR(@date) = YEAR(OrderMadeDate) AND DATEPART(MONTH,@date) = DATEPART(MONTH,OrderMadeDate) AND BranchId = @branchId;

	SELECT @reservationsFromCompaniesNumber = COUNT(*) FROM ReservationsInfo LEFT JOIN Orders ON Orders.OrderId = ReservationsInfo.OrderId LEFT JOIN Customers ON Orders.CustomerId = Customers.CustomerId
	WHERE YEAR(@date) = YEAR(OrderMadeDate) AND DATEPART(MONTH,@date) = DATEPART(MONTH,OrderMadeDate) AND BranchId = @branchId AND RepresentingCompany = 1;

	INSERT INTO @reservationsReportTable VALUES (@branchId,@reservationsNumber,@reservationsFromCompaniesNumber);

	FETCH NEXT FROM @branchCursor INTO @branchId;

END;

CLOSE @branchCursor;
DEALLOCATE @branchCursor;

RETURN;
END;