CREATE TABLE [dbo].[OFI_CaringForDisabledHistory] (
    [Id]                            INT      IDENTITY (1, 1) NOT NULL,
    [ClientId]                      INT      NULL,
    [CaringForDisabledFamilyMember] BIT      NULL,
    [StartDate]                     DATETIME NULL,
    [EndDate]                       DATETIME NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UK_OFI_CaringForDisabledHistory]
    ON [dbo].[OFI_CaringForDisabledHistory]([ClientId] ASC, [StartDate] ASC);

