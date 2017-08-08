CREATE TABLE [dbo].[Fed_LogTransactionData] (
    [DataSavedId]    INT            IDENTITY (1, 1) NOT NULL,
    [TranSavedId]    INT            NULL,
    [ChildTableName] VARCHAR (80)   NULL,
    [ChildPKValue]   INT            NULL,
    [FieldName]      VARCHAR (80)   NULL,
    [OldValue]       NVARCHAR (MAX) NULL,
    [NewValue]       NVARCHAR (MAX) NULL,
    [SavedBy]        VARCHAR (80)   NULL,
    [SavedAt]        DATETIME       NULL,
    CONSTRAINT [PK_Fed_LogTransactionData] PRIMARY KEY CLUSTERED ([DataSavedId] ASC),
    CONSTRAINT [FK_Fed_LogTransactionData_Fed_LogTransactionCreated] FOREIGN KEY ([TranSavedId]) REFERENCES [dbo].[Fed_LogTransaction] ([TranSavedId])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'If equal NULL is parent ELSE is PK of the Child for the parent and', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Fed_LogTransactionData', @level2type = N'COLUMN', @level2name = N'ChildPKValue';

