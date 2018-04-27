CREATE TABLE [dbo].[Fed_MessageApiKey] (
    [MessageApiKeyId]  INT           IDENTITY (1, 1) NOT NULL,
    [CompanyId]        INT           NULL,
    [ApiKey]           VARCHAR (100) NULL,
    [ApiAuthorization] VARCHAR (150) NULL,
    CONSTRAINT [PK_Fed_MessageApiKey] PRIMARY KEY CLUSTERED ([MessageApiKeyId] ASC)
);

