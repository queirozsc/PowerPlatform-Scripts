-- =============================================
-- Author:      Sergio Queiroz
-- Create date: 03/03/2020
-- Description: Tabela auxiliar de chamados do Requestia
--              Como o campo de percentual do SLA eh calculado na aplicacao, a Requestia aplicou o calculo e gerou um arquivo auxiliar (?) para que tenhamos a informacao no banco de dados
-- =============================================
DROP TABLE dbo.ho_aux_requests
GO
CREATE TABLE dbo.ho_aux_requests
(
    request VARCHAR(20) NOT NULL
    , tempo_resolucao VARCHAR(15)
    , prazo_resl VARCHAR(15)
    , tempo_resposta VARCHAR(15)
    , prazo_resp VARCHAR(15)
    , data_processamento DATETIME NOT NULL CONSTRAINT ho_aux_request_df_timestamp DEFAULT GETDATE()
)
GO
CREATE INDEX ho_aux_request_ix_request ON ho_aux_requests (request)
GO
/*
SELECT * from ho_aux_requests
*/