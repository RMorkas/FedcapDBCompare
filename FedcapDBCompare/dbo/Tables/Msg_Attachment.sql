CREATE TABLE [dbo].[Msg_Attachment] (
    [AttachId]              INT             IDENTITY (1, 1) NOT NULL,
    [MessageId]             INT             NULL,
    [AttachmentName]        VARCHAR (200)   NULL,
    [AttachmentDescription] VARCHAR (MAX)   NULL,
    [UriAttachId]           VARCHAR (MAX)   NULL,
    [FileBinary]            VARBINARY (MAX) NULL,
    CONSTRAINT [PK_Msg_Attachment] PRIMARY KEY CLUSTERED ([AttachId] ASC),
    CONSTRAINT [FK_Msg_Attachment_Msg_Message] FOREIGN KEY ([MessageId]) REFERENCES [dbo].[Msg_Message] ([MessageId])
);

