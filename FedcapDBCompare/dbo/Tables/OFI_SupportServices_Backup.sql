CREATE TABLE [dbo].[OFI_SupportServices_Backup] (
    [Id]        INT             IDENTITY (1, 1) NOT NULL,
    [ClientId]  INT             NULL,
    [Code]      VARCHAR (5)     NULL,
    [Frequency] INT             NULL,
    [Amount]    DECIMAL (18, 2) NULL,
    [StartDate] DATETIME        NULL,
    [EndDate]   DATETIME        NULL,
    CONSTRAINT [PK_OFI_SupportServices_Backup] PRIMARY KEY CLUSTERED ([Id] ASC)
);

