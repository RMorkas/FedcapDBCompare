CREATE TABLE [dbo].[OFI_CaringForChildUnder1] (
    [Id]                  INT      IDENTITY (1, 1) NOT NULL,
    [ClientId]            INT      NULL,
    [CaringForChidUnder1] BIT      NULL,
    [StartDate]           DATETIME NULL,
    [EndDate]             DATETIME NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [UK_OFI_CaringForChildUnder1]
    ON [dbo].[OFI_CaringForChildUnder1]([ClientId] ASC, [StartDate] ASC);

