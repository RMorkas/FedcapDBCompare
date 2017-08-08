CREATE TABLE [dbo].[SE_FileBinary] (
    [ID]          INT             IDENTITY (1, 1) NOT NULL,
    [FileName]    VARCHAR (50)    NULL,
    [FileContent] VARBINARY (MAX) NULL,
    [CreateDate]  DATETIME        CONSTRAINT [DF_SE_FileBinary_CreateDate] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_SE_FileBinary] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UK_FileName]
    ON [dbo].[SE_FileBinary]([FileName] ASC);

