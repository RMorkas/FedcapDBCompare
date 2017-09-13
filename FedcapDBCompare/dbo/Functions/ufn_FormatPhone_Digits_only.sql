Create FUNCTION [dbo].[ufn_FormatPhone_Digits_only]
    (@PhoneNumber VARCHAR(32))
RETURNS VARCHAR(32)
AS
  BEGIN
    DECLARE  @Phone CHAR(32)

    SET @Phone = @PhoneNumber

    -- cleanse phone number string
    WHILE PATINDEX('%[^0-9]%',@PhoneNumber) > 0
      SET @PhoneNumber = REPLACE(@PhoneNumber,
               SUBSTRING(@PhoneNumber,PATINDEX('%[^0-9]%',@PhoneNumber),1),'')


    RETURN @PhoneNumber
  END