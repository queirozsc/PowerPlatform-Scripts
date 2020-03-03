-- =============================================
-- Author:      Sergio Queiroz
-- Create date: 03/03/2020
-- Description: Tabela de chamados do Requestia
-- =============================================
DROP TABLE dbo.requests
GO
CREATE TABLE dbo.requests
(
    request VARCHAR(20) NOT NULL
    , client VARCHAR(50)
    , origanal VARCHAR(100)
    , curranal VARCHAR(100)
    , groupanal VARCHAR(10)
    , lastanal VARCHAR(100)
    , lastanlgrp VARCHAR(10)
    , origgroup VARCHAR(100)
    , currgroup VARCHAR(100)
    , lastgroup VARCHAR(100)
    , category VARCHAR(255)
    , rpriority VARCHAR(100)
    , product VARCHAR(255)
    , process VARCHAR(255)
    , rstatus VARCHAR(100)
    , reqtype VARCHAR(100)
    , reqsource VARCHAR(100)
    , reqlocation VARCHAR(100)
    , orgunit VARCHAR(100)
    , orgunit_root VARCHAR(100)
    , opendate VARCHAR(20)
    , closedate VARCHAR(20)
    , closed VARCHAR(10)
    , lastaction VARCHAR(20)
    , lastanalyst VARCHAR(20)
    , laststatus VARCHAR(20)
    , lastpriority VARCHAR(20)
    , lastreopen VARCHAR(20)
    , lastactionatend VARCHAR(20)
    , lastacttype VARCHAR(40)
    , respdate VARCHAR(20)
    , resptime VARCHAR(20)
    , resltime VARCHAR(20)
    , respmins VARCHAR(10)
    , reslmins VARCHAR(10)
    , respremains VARCHAR(10)
    , reslremains VARCHAR(10)
    , respmode VARCHAR(10)
    , reslmode VARCHAR(10)
    , nocompute VARCHAR(10)
    , workflow VARCHAR(255)
    , reqworkflow VARCHAR(20)
    , origcategory VARCHAR(255)
    , origproduct VARCHAR(255)
    , origprocess VARCHAR(255)
    , insertdate VARCHAR(20)
    , qform VARCHAR(100)
    , qsurvey VARCHAR(255)
    , qsessionform VARCHAR(10)
    , qsessionsurvey VARCHAR(10)
    , data_processamento DATETIME NOT NULL CONSTRAINT request_df_timestamp DEFAULT GETDATE()
    , data_abertura DATETIME 
    , data_encerramento DATETIME
    , data_ultima_acao DATETIME
    , data_resposta DATETIME
    , data_resolucao DATETIME
    , estagio VARCHAR(40) DEFAULT 'AGUARDANDO ATENDIMENTO'
    , percentual_sla FLOAT
    , prazo_resolucao VARCHAR(15) DEFAULT 'DENTRO DO PRAZO'
    , prazo_resposta VARCHAR(15) DEFAULT 'DENTRO DO PRAZO'
    , situacao VARCHAR(20) DEFAULT 'ABERTO'
    , tempo_resposta FLOAT    
)
GO
SELECT TOP 100 * 
FROM requests
ORDER BY request DESC