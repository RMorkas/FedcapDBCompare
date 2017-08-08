CREATE TABLE [dbo].[OFI_ExemptionHistory] (
    [Id]              INT      IDENTITY (1, 1) NOT NULL,
    [ClientId]        INT      NULL,
    [ExemptionTypeId] INT      NULL,
    [StartDate]       DATETIME NULL,
    [EndDate]         DATETIME NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

