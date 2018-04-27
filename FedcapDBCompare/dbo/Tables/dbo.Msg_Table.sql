CREATE TABLE [dbo].[Msg_Table] (
    [TableId]   INT          IDENTITY (1, 1) NOT NULL,
    [TableName] VARCHAR (80) NULL,
    [IsDev]     BIT          NULL,
    [IsUAT]     BIT          NULL,
    [IsStaging] BIT          NULL,
    [IsProd]    BIT          NULL,
    CONSTRAINT [PK_Msg_Table] PRIMARY KEY CLUSTERED ([TableId] ASC)
);

