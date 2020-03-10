-- =============================================
-- Author:      Sergio Queiroz
-- Create date: 04/03/2020
-- Description: Tabela de respostas do chamado do Requestia
-- =============================================
DROP TABLE dbo.qanswer
GO
CREATE TABLE dbo.qanswer
(
    qsession VARCHAR(20)
    ,  question VARCHAR(400)
    , qanswer VARCHAR(400)
    , qanswered VARCHAR(10)
    , qanswerdate VARCHAR(20)
    , qshow VARCHAR(10)
    , qorder VARCHAR(10)
    , qupdated VARCHAR(10)
    , data_processamento DATETIME NOT NULL CONSTRAINT qanswer_df_timestamp DEFAULT GETDATE()
)
GO
CREATE INDEX qanswer_ix_qsession ON qanswer (qsession)
GO
CREATE INDEX qanswer_ix_qsession_question ON qanswer (qsession, question)