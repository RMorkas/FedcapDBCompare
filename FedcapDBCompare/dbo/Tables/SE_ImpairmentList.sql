CREATE TABLE [dbo].[SE_ImpairmentList] (
    [ID]             INT           IDENTITY (1, 1) NOT NULL,
    [EvaluationID]   VARCHAR (8)   NULL,
    [ImpairmentCode] VARCHAR (11)  NULL,
    [ImpairmentText] VARCHAR (124) NULL,
    [FileName]       VARCHAR (50)  NULL,
    CONSTRAINT [PK_SE_ImpairmentList] PRIMARY KEY CLUSTERED ([ID] ASC)
);

