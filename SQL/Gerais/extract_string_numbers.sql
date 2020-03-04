-- =============================================
-- Author:      Sergio Queiroz
-- Create date: 04/03/2020
-- Description: Extrai a parte numerica de uma string
--
-- Parameters:
--   @strmixed - string no formato combinando texto e numeros, ex: 'HOB HOSPITAL OFTALMOLÓGICO DE BRASÍLIA LTDA 00.649.756/0001-66'
-- Returns: - string contendo apenas a parte numerica, ex: '00.649.756/0001-66'
-- =============================================
DROP FUNCTION dbo.extract_string_numbers
GO
CREATE FUNCTION dbo.extract_string_numbers (@strmixed VARCHAR(400))
RETURNS VARCHAR(30)
AS
    BEGIN
        DECLARE @result VARCHAR(30)

        SELECT @result = value
        FROM STRING_SPLIT(@strmixed, ' ')
        WHERE RTRIM(value) <> ''
            AND PATINDEX('[0-9]%', value) = 1

        RETURN @result
    END
GO