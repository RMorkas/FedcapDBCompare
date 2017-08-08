CREATE TABLE [dbo].[ClientSanction] (
    [Clientid]           INT          NOT NULL,
    [Sanction_type]      VARCHAR (50) NOT NULL,
    [Sanction_StartDate] DATETIME     NULL,
    [Sanction_EndDate]   DATETIME     NULL,
    [Id]                 INT          IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_ClientSanction] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ClientSanction_ClientId] FOREIGN KEY ([Clientid]) REFERENCES [dbo].[Client] ([ClientId])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UK_ClientSanction]
    ON [dbo].[ClientSanction]([Clientid] ASC, [Sanction_type] ASC, [Sanction_StartDate] ASC);

