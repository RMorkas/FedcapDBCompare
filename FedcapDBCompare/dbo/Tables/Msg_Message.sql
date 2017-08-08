CREATE TABLE [dbo].[Msg_Message] (
    [MessageId]      INT           IDENTITY (1, 1) NOT NULL,
    [TypeId]         INT           NULL,
    [ReasonId]       INT           NULL,
    [TriggerTableId] INT           NULL,
    [TriggerPKId]    INT           NULL,
    [CompanyId]      INT           NULL,
    [ClientId]       INT           NULL,
    [MsgTo]          VARCHAR (50)  NULL,
    [MsgFrom]        VARCHAR (50)  NULL,
    [Subject]        VARCHAR (200) NULL,
    [Body]           VARCHAR (MAX) NULL,
    [Footer]         VARCHAR (MAX) NULL,
    [EmailType]      VARCHAR (20)  NULL,
    [UriMessageId]   VARCHAR (MAX) NULL,
    [MessageStatus]  VARCHAR (50)  NULL,
    [SentBy]         VARCHAR (50)  NULL,
    [SentAt]         SMALLDATETIME NULL,
    CONSTRAINT [PK_Msg_Message] PRIMARY KEY CLUSTERED ([MessageId] ASC),
    CONSTRAINT [FK_Msg_Message_Msg_Reason] FOREIGN KEY ([ReasonId]) REFERENCES [dbo].[Msg_Reason] ([ReasonId]),
    CONSTRAINT [FK_Msg_Message_Msg_Table] FOREIGN KEY ([TriggerTableId]) REFERENCES [dbo].[Msg_Table] ([TableId]),
    CONSTRAINT [FK_Msg_Message_Msg_Type] FOREIGN KEY ([TypeId]) REFERENCES [dbo].[Msg_Type] ([TypeId])
);

