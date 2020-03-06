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
    , groupanal VARCHAR(1)
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
    , tempo_abertura FLOAT
    , data_encerramento DATETIME
    , data_ultima_acao DATETIME
    , tempo_ultima_acao FLOAT
    , data_resposta DATETIME
    , tempo_resposta FLOAT
    , data_resolucao DATETIME
    , tempo_resolucao FLOAT
    , estagio VARCHAR(40) DEFAULT 'AGUARDANDO ATENDIMENTO'
    , percentual_sla FLOAT
    , prazo_resolucao VARCHAR(15) DEFAULT 'DENTRO DO PRAZO'
    , prazo_resposta VARCHAR(15) DEFAULT 'DENTRO DO PRAZO'
    , situacao VARCHAR(20) DEFAULT 'ABERTO'
    , unidade_atendimento VARCHAR(400)
    , cnpj VARCHAR(18) DEFAULT '00.649.756/0006-70'
    , hierarquia VARCHAR(20)
    , fila_analistas VARCHAR(3) DEFAULT 'SIM'
)
GO
CREATE INDEX request_ix_request ON requests (request)
GO
CREATE INDEX request_ix_closed ON requests (closed)
GO
CREATE INDEX request_ix_qsessionform ON requests (qsessionform)
GO
CREATE INDEX request_ix_data_abertura ON requests (data_abertura)
GO
CREATE INDEX request_ix_data_encerramento ON requests (data_encerramento)
GO
CREATE INDEX request_ix_percentual_sla ON requests (percentual_sla)
GO
CREATE INDEX request_ix_prazo_resolucao ON requests (prazo_resolucao)
GO
CREATE INDEX request_ix_prazo_resposta ON requests (prazo_resposta)
GO
CREATE INDEX request_ix_situacao ON requests (situacao)
GO
CREATE INDEX request_ix_unidade_atendimento ON requests (unidade_atendimento)
GO
CREATE INDEX request_ix_cnpj ON requests (cnpj)
GO
CREATE INDEX request_ix_hierarquia ON requests (hierarquia)
GO
CREATE INDEX request_ix_fila_analistas ON requests (fila_analistas)
GO
/*
SELECT TOP 100 * 
FROM requests
WHERE hierarquia LIKE 'BR|NE%'
    AND category = 'Tecnologia da Informacao'
ORDER BY request DESC

SELECT *
FROM requests
WHERE hierarquia IS NULL

SELECT unidade_atendimento, dbo.extract_string_numbers(unidade_atendimento),  count(1)
FROM requests
GROUP BY unidade_atendimento, dbo.extract_string_numbers(unidade_atendimento)
ORDER BY 2 DESC

UPDATE requests
SET cnpj = '00.659.756/0005-90'
WHERE unidade_atendimento = 'HOB HOSPITAL OFTALMOLÓGICO DE BRASÍLIA LTDA (HOLDING) 00.659.756 / 0005-90'

SELECT unidade_atendimento, count(1)
FROM requests
GROUP BY unidade_atendimento
ORDER BY 2 desc

CLÍNICA E CIRURGIA DE OLHOS DR. ARMANDO A GUESER LTDA 00.181.085/0006-66 (COSC - SÃO CRISTOVÃO)


SELECT *
FROM unidade_negocio
WHERE cnpj like '%00.649.756/0001-66%'

SELECT dbo.extract_string_numbers('HOB HOSPITAL OFTALMOLÓGICO DE BRASÍLIA LTDA 00.649.756/0001-66')
    , PATINDEX('%__.___.___/____-__%', 'HOB HOSPITAL OFTALMOLÓGICO DE BRASÍLIA LTDA 00.649.756/0001-66')
    , STUFF('HOB HOSPITAL OFTALMOLÓGICO DE BRASÍLIA LTDA 00.649.756/0001-66', 45, 18, '')

SELECT value
FROM STRING_SPLIT('HOB HOSPITAL OFTALMOLÓGICO DE BRASÍLIA LTDA 00.649.756/0001-66', ' ')
WHERE RTRIM(value) <> ''
    AND PATINDEX('[0-9]%', value) = 1



*/