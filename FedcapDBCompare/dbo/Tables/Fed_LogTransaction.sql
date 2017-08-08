CREATE TABLE [dbo].[Fed_LogTransaction] (
    [TranSavedId]  INT          IDENTITY (1, 1) NOT NULL,
    [TableId]      INT          NULL,
    [PKFieldValue] INT          NULL,
    [Sequence]     INT          NULL,
    [SavedBy]      VARCHAR (80) NULL,
    [SavedAt]      DATETIME     NULL,
    CONSTRAINT [PK_Fed_LogTransactionSave] PRIMARY KEY CLUSTERED ([TranSavedId] ASC),
    CONSTRAINT [FK_Fed_LogTransactionCreated_Fed_LogTables] FOREIGN KEY ([TableId]) REFERENCES [dbo].[Fed_LogTables] ([TableId])
);

