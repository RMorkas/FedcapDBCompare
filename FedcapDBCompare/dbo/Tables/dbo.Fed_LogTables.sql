CREATE TABLE [dbo].[Fed_LogTables] (
    [TableId]     INT          IDENTITY (1, 1) NOT NULL,
    [TableName]   VARCHAR (80) NULL,
    [PKFieldName] VARCHAR (80) NULL,
    [IsDev]       BIT          NULL,
    [IsUAT]       BIT          NULL,
    [IsStaging]   BIT          NULL,
    [IsProd]      BIT          NULL,
    [TesColumn] INT NULL, 
    CONSTRAINT [PK_Fed_LogTables] PRIMARY KEY CLUSTERED ([TableId] ASC)
);

