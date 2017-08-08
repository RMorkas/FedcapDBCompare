CREATE TABLE [dbo].[SE_QuestionEntries] (
    [ID]                INT           IDENTITY (1, 1) NOT NULL,
    [EvaluationID]      VARCHAR (8)   NULL,
    [QuestionID]        VARCHAR (3)   NULL,
    [MapID]             VARCHAR (3)   NULL,
    [AnswerID]          VARCHAR (3)   NULL,
    [AnswerText]        VARCHAR (20)  NULL,
    [DateCreated]       DATETIME      NULL,
    [JustificationText] VARCHAR (256) NULL,
    CONSTRAINT [PK_SE_QuestionEntries] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UK_QuestionEntries]
    ON [dbo].[SE_QuestionEntries]([EvaluationID] ASC, [QuestionID] ASC);

