CREATE TRIGGER CheckIfReservationCanBeMadeTrigger
ON ReservationsInfo
INSTEAD OF INSERT
AS
BEGIN
SET NOCOUNT ON

IF 0 < (SELECT COUNT(ReservationsInfo.OrderId) FROM inserted AS R LEFT JOIN ReservationsInfo ON ReservationsInfo.TableId = R.TableId 
AND NOT (R.ReservedTo <= ReservationsInfo.ReservedFrom OR ReservationsInfo.ReservedTo <= R.ReservedFrom))
BEGIN
RAISERROR('Given Reservations are colliding with another reservarion',-1,-1);
RETURN
END

IF 0 < (SELECT COUNT(Tables.TableId) FROM inserted AS R LEFT JOIN Tables ON Tables.TableId = R.TableId 
AND NOT (R.ReservedTo <= Tables.UnavailableFrom OR Tables.UnavailableTo <= R.ReservedFrom))
BEGIN
RAISERROR('Given Reservations are colliding with tables unavailability',-1,-1);
RETURN
END
INSERT INTO ReservationsInfo SELECT * FROM inserted 
SET NOCOUNT OFF
END