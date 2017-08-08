CREATE TABLE [dbo].[OFI_SupportServices] (
    [Id]        INT             IDENTITY (1, 1) NOT NULL,
    [ClientId]  INT             NULL,
    [Code]      VARCHAR (5)     NULL,
    [Frequency] INT             NULL,
    [Amount]    DECIMAL (18, 2) NULL,
    [StartDate] DATETIME        NULL,
    [EndDate]   DATETIME        NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UK_OFI_SupportServices]
    ON [dbo].[OFI_SupportServices]([ClientId] ASC, [Code] ASC, [StartDate] ASC);

