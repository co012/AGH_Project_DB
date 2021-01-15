CREATE PROCEDURE replaceMenu(@replacement MenuReplacement READONLY)
AS
BEGIN
UPDATE MenuItems SET LastTimeRemoved = GETDATE() WHERE MenuItemId in (SELECT OldMenuItemId FROM @replacement) AND MenuItemId IN (SELECT MenuItemId FROM MenuView)
DELETE FROM UnavailiableMenuItems WHERE MenuItemId IN (SELECT OldMenuItemId FROM @replacement)
UPDATE MenuItems SET LastTimeAdded = GETDATE() WHERE MenuItemId in (SELECT NewMenuItemId FROM @replacement)

END