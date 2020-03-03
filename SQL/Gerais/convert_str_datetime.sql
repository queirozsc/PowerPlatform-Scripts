-- =============================================
-- Author:      Sergio Queiroz
-- Create date: 03/03/2020
-- Description: Converte string no formato yyyymmddhhmmss em datetime
--
-- Parameters:
--   @strdate - string no formato yyyymmddhhmmss
-- Returns:     Data no formato datetime
-- =============================================
DROP FUNCTION dbo.convert_str_datetime
GO
CREATE FUNCTION dbo.convert_str_datetime (@strdate VARCHAR(19))
RETURNS DATETIME
AS
    BEGIN
        DECLARE @result DATETIME

        SET @result = SUBSTRING(@strdate, 1, 4) + '-' + SUBSTRING(@strdate, 5, 2) + '-' + SUBSTRING(@strdate, 7, 2) + 'T' + SUBSTRING(@strdate, 9, 2) + ':' + SUBSTRING(@strdate, 11, 2) + ':' + SUBSTRING(@strdate, 13, 2)
        RETURN @result
    END
GO