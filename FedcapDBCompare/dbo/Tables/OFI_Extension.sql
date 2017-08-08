CREATE TABLE [dbo].[OFI_Extension] (
    [Id]        INT            IDENTITY (1, 1) NOT NULL,
    [ClientId]  INT            NULL,
    [Type]      VARCHAR (5)    NULL,
    [Status]    VARCHAR (5)    NULL,
    [Denial]    VARCHAR (5)    NULL,
    [StartDate] DATETIME       NULL,
    [EndDate]   DATETIME       NULL,
    [Reason]    VARCHAR (2000) NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UK_OFI_Extension]
    ON [dbo].[OFI_Extension]([ClientId] ASC, [Type] ASC, [StartDate] ASC);

