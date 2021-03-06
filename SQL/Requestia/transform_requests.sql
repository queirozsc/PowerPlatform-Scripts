-- =============================================
-- Author:      Sergio Queiroz
-- Create date: 03/03/2020
-- Description: Normaliza valores da tabela requests
-- =============================================
DROP PROCEDURE dbo.transform_requests
GO
CREATE PROCEDURE dbo.transform_requests
AS
    BEGIN
    /* conversoes de data hora*/
    UPDATE dbo.requests
    SET data_abertura = dbo.convert_str_datetime(opendate)
    , data_encerramento = dbo.convert_str_datetime(closedate)
    , data_ultima_acao = dbo.convert_str_datetime(lastaction)
    , data_resposta = dbo.convert_str_datetime(resptime)
    , data_resolucao = dbo.convert_str_datetime(resltime)
    , estagio = CASE
        WHEN UPPER(rstatus) LIKE '%AGUARD%SUBID%' THEN 'AGUARDANDO PUBLICACAO'
        WHEN UPPER(rstatus) LIKE '%AGUARD%SOL%' THEN 'AGUARDANDO SOLICITANTE'
        WHEN UPPER(rstatus) LIKE '%NOTIF%SOL%' THEN 'AGUARDANDO SOLICITANTE'
        WHEN UPPER(rstatus) LIKE '%AGUARD%TER%' THEN 'AGUARDANDO TERCEIRO'
        WHEN UPPER(rstatus) LIKE '%AGUARD%APROV%' THEN 'AGUARDANDO APROVACAO'
        WHEN UPPER(rstatus) LIKE '%ENC%APROV%' THEN 'AGUARDANDO APROVACAO'
        WHEN UPPER(rstatus) LIKE '%APROVADO%' THEN 'APROVADO'
        WHEN UPPER(rstatus) LIKE '%CANCEL%' THEN 'CANCELADO'
        WHEN UPPER(rstatus) LIKE '%ENCERR%' THEN 'ENCERRADO'
        WHEN UPPER(rstatus) LIKE '%EM%ATEND%' THEN 'EM ATENDIMENTO'
        WHEN UPPER(rstatus) LIKE '%REPROV%' THEN 'REPROVADO'
        WHEN UPPER(rstatus) LIKE '%AGUARD%ATEND%' THEN 'AGUARDANDO ATENDIMENTO'
        WHEN UPPER(rstatus) LIKE '%AGUARD%ATD%' THEN 'AGUARDANDO ATENDIMENTO'
        WHEN UPPER(rstatus) LIKE '%RET%SOLIC%' THEN 'AGUARDANDO ATENDIMENTO'
        WHEN UPPER(rstatus) LIKE '%RET%SOL%' THEN 'AGUARDANDO ATENDIMENTO'
        WHEN UPPER(rstatus) LIKE '%REABERTO%' THEN 'AGUARDANDO ATENDIMENTO'
        WHEN UPPER(rstatus) LIKE '%DEMANDA%NAO%SOLUC%' THEN 'AGUARDANDO ATENDIMENTO'
        WHEN UPPER(rstatus) LIKE '%DEMANDA%NÃO%SOLUC%' THEN 'AGUARDANDO ATENDIMENTO'
    END;

    /* calculos de tempos */
    UPDATE dbo.requests
    SET tempo_abertura = CASE
                            WHEN closed = '1' THEN dbo.working_hours_between_dates(data_abertura, data_encerramento)
                            ELSE dbo.working_hours_between_dates(data_abertura, GETDATE())
                        END
    , tempo_ultima_acao = CASE
                            WHEN closed = '1' THEN dbo.working_hours_between_dates(data_ultima_acao, data_encerramento)
                            ELSE dbo.working_hours_between_dates(data_ultima_acao, GETDATE())
                        END
    , tempo_resposta = CASE
                            WHEN closed = '1' THEN dbo.working_hours_between_dates(data_resposta, data_encerramento)
                            ELSE dbo.working_hours_between_dates(data_resposta, GETDATE())
                        END
    , tempo_resolucao = CASE
                            WHEN closed = '1' THEN dbo.working_hours_between_dates(data_resolucao, data_encerramento)
                            ELSE dbo.working_hours_between_dates(data_resolucao, GETDATE())
                        END;

    /* situacao do chamado */
    UPDATE dbo.requests
    SET situacao = 'FECHADO'
    WHERE closed = '1';

    /* chamados que sairam da fila */
    UPDATE dbo.requests
    SET fila_analistas = 'NAO'
    WHERE groupanal = 0;

    /* sla do chamado */
    UPDATE dbo.requests
    SET percentual_sla = CONVERT(FLOAT, a.tempo_resolucao)
        , tempo_resposta = CONVERT(FLOAT, a.tempo_resposta)
    FROM dbo.requests r
        JOIN dbo.ho_aux_requests a
            ON r.request = a.request;

    /* unidade do chamado */
    UPDATE requests
    SET unidade_atendimento = UPPER(a.qanswer)
    FROM requests r
        JOIN qanswer a
            ON qsessionform = a.qsession
    WHERE a.qsession = qsessionform
        AND a.question = 'GER_CONSUL_EMPCNPJ';

    /* cnpj da unidade */
    UPDATE requests
    SET cnpj = dbo.extract_string_numbers(unidade_atendimento)
    WHERE NOT dbo.extract_string_numbers(unidade_atendimento) IS NULL;

    /* corrige espacos no cnpj */
    UPDATE requests
    SET cnpj = '00.659.756/0005-90'
    WHERE unidade_atendimento = 'HOB HOSPITAL OFTALMOLÓGICO DE BRASÍLIA LTDA (HOLDING) 00.659.756 / 0005-90';


    /* mnemonico da hierarquia da unidade */
    UPDATE requests
    SET hierarquia = UPPER(u.hierarquia)
    FROM requests r
        JOIN unidade_negocio u
            ON r.cnpj = u.cnpj;
    
END
GO