DROP TABLE dbo.unidade_negocio
GO
CREATE TABLE dbo.unidade_negocio (
    cnpj VARCHAR(18) NOT NULL
    , razao_social VARCHAR(150) NOT NULL
    , endereco VARCHAR(150) NULL
    , bairro VARCHAR(150) NULL
    , cidade VARCHAR(150) NULL
    , cep VARCHAR(10) NULL
    , hierarquia VARCHAR(80) NOT NULL
    , data_processamento DATETIME NOT NULL CONSTRAINT unidade_negocio_df_timestamp DEFAULT GETDATE()
)
GO
CREATE INDEX unidade_negocio_ix_cnpj ON dbo.unidade_negocio (cnpj)
GO
CREATE INDEX unidade_negocio_ix_hierarquia ON dbo.unidade_negocio (hierarquia)
GO
SELECT * FROM dbo.unidade_negocio