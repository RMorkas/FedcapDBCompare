CREATE TABLE [dbo].[OFI_Income] (
    [Id]                   INT             IDENTITY (1, 1) NOT NULL,
    [ClientId]             INT             NULL,
    [Type]                 VARCHAR (5)     NULL,
    [StartDate]            DATETIME        NULL,
    [EndDate]              DATETIME        NULL,
    [VerificationType]     VARCHAR (2)     NULL,
    [Hours]                INT             NULL,
    [Amount]               DECIMAL (18, 2) NULL,
    [HourlyRate]           DECIMAL (18, 2) NULL,
    [VerificationDate]     DATETIME        NULL,
    [PeriodType]           VARCHAR (1)     NULL,
    [SourceType]           VARCHAR (70)    NULL,
    [SourcePhoneExtension] VARCHAR (10)    NULL,
    [SourcePhoneNumber]    VARCHAR (10)    NULL,
    [SourceContactName]    VARCHAR (50)    NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UK_OFI_Income]
    ON [dbo].[OFI_Income]([ClientId] ASC, [Type] ASC, [StartDate] ASC);

