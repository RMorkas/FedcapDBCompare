CREATE TABLE [dbo].[Historical_SupportServices] (
    [Id]               INT             IDENTITY (1, 1) NOT NULL,
    [ImportDate]       DATETIME        NULL,
    [ClientNo]         VARCHAR (15)    NULL,
    [ClientLastName]   VARCHAR (30)    NULL,
    [ClientFirstName]  VARCHAR (30)    NULL,
    [ClientMiddleName] VARCHAR (30)    NULL,
    [ServiceCode]      VARCHAR (5)     NULL,
    [IssuanceDate]     DATETIME        NULL,
    [IssuanceAmount]   DECIMAL (18, 2) NULL,
    [Processed]        BIT             NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

