CREATE TABLE [dbo].[Fed_LogTables] (
    [TableId]     INT          IDENTITY (1, 1) NOT NULL,
    [TableName]   VARCHAR (80) NULL,
    [PKFieldName] VARCHAR (80) NULL,
    CONSTRAINT [PK_Fed_LogTables] PRIMARY KEY CLUSTERED ([TableId] ASC)
);

