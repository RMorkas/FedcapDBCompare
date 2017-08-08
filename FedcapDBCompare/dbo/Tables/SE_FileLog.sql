CREATE TABLE [dbo].[SE_FileLog] (
    [ID]           INT           IDENTITY (1, 1) NOT NULL,
    [FileStatus]   VARCHAR (100) NULL,
    [StatusDate]   DATETIME      NULL,
    [EvaluationID] VARCHAR (8)   NULL,
    [FileDate]     DATETIME      NULL,
    [FileName]     VARCHAR (50)  NULL,
    CONSTRAINT [PK_SE_FileLog] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UK_FileName]
    ON [dbo].[SE_FileLog]([FileName] ASC);

