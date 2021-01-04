CREATE TYPE OrderDetailsTable AS TABLE (MenuItemId INT,Quantity INT)
GO
CREATE TYPE ReservationTable AS TABLE (TableId INT, ReservedFor VARCHAR(255),ReservedFrom DATETIME, ReservedTo DATETIME)
GO
CREATE TYPE MenuReplacement AS TABLE (OldMenuItemId INT,NewMenuItemId INT NOT NULL)
