CREATE FUNCTION [dbo].[ufn_FormatPhone]
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

    -- skip foreign phones
    IF (SUBSTRING(@PhoneNumber,1,1) = '1'
         OR SUBSTRING(@PhoneNumber,1,1) = '+'
         OR SUBSTRING(@PhoneNumber,1,1) = '0')
       AND LEN(@PhoneNumber) > 11
      RETURN @Phone

    -- build US standard phone number
    SET @Phone = @PhoneNumber

    SET @PhoneNumber = '(' + SUBSTRING(@PhoneNumber,1,3) + ') ' +
             SUBSTRING(@PhoneNumber,4,3) + '-' + SUBSTRING(@PhoneNumber,7,4)

    IF LEN(@Phone) - 10 > 1
      SET @PhoneNumber = @PhoneNumber + ' X' + SUBSTRING(@Phone,11,LEN(@Phone) - 10)

    RETURN @PhoneNumber
  END