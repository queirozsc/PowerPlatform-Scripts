DROP VIEW dbo.medicao_contrato
GO
CREATE VIEW dbo.medicao_contrato
WITH SCHEMABINDING -- fonte: https://www.sqlservertutorial.net/sql-server-views/sql-server-indexed-view/
AS
    SELECT r.request chamado
        , r.percentual_sla
        , r.situacao
        , r.unidade_atendimento
        , r.hierarquia
        , r.data_abertura
        , r.client solicitante
        , r.curranal analista
        , a1.qanswer fornecedor
        , a2.qanswer servico
        , a3.qanswer nota_fiscal
        , CONVERT(VARCHAR(10), CONVERT(DATE, a4.qanswer, 111), 103) data_vencimento
        , a5.qanswer valor
    FROM dbo.requests r
        LEFT JOIN dbo.qanswer a1
            ON r.qsessionform = a1.qsession AND a1.question = 'CONTAS_PGTO_Forne'
        LEFT JOIN dbo.qanswer a2
            ON r.qsessionform = a2.qsession AND a2.question = 'CONTAS_PGTO_DescServProd'
        LEFT JOIN dbo.qanswer a3
            ON r.qsessionform = a3.qsession AND a3.question = 'FAC_Observacao'
        LEFT JOIN dbo.qanswer a4
            ON r.qsessionform = a4.qsession AND a4.question = 'CONTAS_PGTO_Vencimento'
        LEFT JOIN dbo.qanswer a5
            ON r.qsessionform = a5.qsession AND a5.question = 'CONTAS_PGTO_Valorr'
    WHERE r.category = 'Facilities'
        AND r.product = 'Servicos'
        AND r.process = 'Medição de Contratos'
GO
CREATE INDEX medicao_contrato_ix_fornecedor ON medicao_contrato (fornecedor)
GO
SELECT *
FROM medicao_contrato
WHERE fornecedor LIKE 'BRASIL TELECOM%'
    AND hierarquia = 'BR|SUL|HOSAG'
ORDER BY chamado