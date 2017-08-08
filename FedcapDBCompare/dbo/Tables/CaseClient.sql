CREATE TABLE [dbo].[CaseClient] (
    [CaseClientId] INT IDENTITY (1, 1) NOT NULL,
    [CaseId]       INT NULL,
    [ClientId]     INT NULL,
    CONSTRAINT [PK_CaseClient] PRIMARY KEY CLUSTERED ([CaseClientId] ASC),
    CONSTRAINT [FK_CaseClient_Case] FOREIGN KEY ([CaseId]) REFERENCES [dbo].[Case] ([CaseId]),
    CONSTRAINT [FK_CaseClient_Client] FOREIGN KEY ([ClientId]) REFERENCES [dbo].[Client] ([ClientId])
);

