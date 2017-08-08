CREATE TABLE [dbo].[Msg_MessageService] (
    [ServiceId]     INT           IDENTITY (1, 1) NOT NULL,
    [CompanyId]     INT           NULL,
    [MethodName]    VARCHAR (200) NULL,
    [ProcessedDate] SMALLDATETIME NULL,
    [IsProcessed]   BIT           NULL,
    [MessageCount]  INT           NULL,
    [ErrorMessage]  VARCHAR (MAX) NULL,
    CONSTRAINT [PK_Msg_MessageService] PRIMARY KEY CLUSTERED ([ServiceId] ASC)
);

