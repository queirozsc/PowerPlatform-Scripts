-- =============================================
-- Author:      Sergio Queiroz
-- Create date: 04/03/2020
-- Description: Tabela de sessoes do Requestia
-- =============================================
DROP TABLE dbo.qsession
GO
CREATE TABLE dbo.qsession
(
    qsession VARCHAR(20)
    ,  qsessiontitle VARCHAR(20)
    , qclient VARCHAR(50)
    , qform VARCHAR(100)
    , qversion VARCHAR(20)
    , qstatus VARCHAR(10)
    , qanswerdate VARCHAR(20)
    , qexpdate VARCHAR(20)
    , qapplication VARCHAR(10)
    , qsurveytipe VARCHAR(10)
    , reqlocation VARCHAR(10)
    , data_processamento DATETIME NOT NULL CONSTRAINT qsession_df_timestamp DEFAULT GETDATE()
)
