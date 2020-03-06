-- =============================================
-- Author:      Sergio Queiroz
-- Create date: 06/03/2020
-- Description: Calcula o numero de horas uteis entre duas datas
--
-- Parameters:
--   @startdate - data inicial
--   @enddate - data final
-- Returns: - numero de horas uteis, considerando 08 horas de trabalho por dia
-- =============================================
DROP FUNCTION dbo.working_hours_between_dates
GO
CREATE FUNCTION dbo.working_hours_between_dates(@startdate DATETIME, @enddate DATETIME)
RETURNS DECIMAL(18,2)
AS
    BEGIN
        DECLARE @totalworkdays INT, @totaltimediff DECIMAL(18,2)

        /* diferenca em dias */
        SET @totalworkdays = DATEDIFF(DAY, @startdate, @enddate)
                            - (DATEDIFF(WEEK, @startdate, @enddate) * 2)
                            - CASE WHEN DATENAME(WEEKDAY, @startdate) = 'Sunday' THEN 1 ELSE 0 END
                            + CASE WHEN DATENAME(WEEKDAY, @enddate) = 'Saturday' THEN 1 ELSE 0 END;

        /* converte para horas */
        SET @totaltimediff = ( SELECT DATEDIFF(SECOND, (SELECT CONVERT(TIME, @startdate)), (SELECT CONVERT(TIME, @enddate)) ) / 3600.0);

        /* considera 08 horas uteis por dia */
        RETURN  (SELECT(@totalworkdays * 8.00) + @totaltimediff)
    END
GO