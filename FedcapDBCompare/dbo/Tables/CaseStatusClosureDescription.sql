CREATE TABLE [dbo].[CaseStatusClosureDescription] (
    [Id]                  INT IDENTITY (1, 1) NOT NULL,
    [CaseStatusHistoryId] INT NOT NULL,
    [DescriptionId]       INT NOT NULL,
    CONSTRAINT [PK_CaseStatusClosureDescription] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_CaseStatusClosureDescription_OFI_CodeDescription] FOREIGN KEY ([DescriptionId]) REFERENCES [dbo].[CodeDescription] ([DescrID])
);

