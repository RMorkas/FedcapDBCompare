CREATE TABLE [dbo].[SE_Dropdowns] (
    [ID]           INT          IDENTITY (1, 1) NOT NULL,
    [EvaluationID] VARCHAR (8)  NULL,
    [Group]        VARCHAR (10) NULL,
    [Name]         VARCHAR (18) NULL,
    [Code]         VARCHAR (12) NULL,
    [CodeText]     VARCHAR (80) NULL,
    CONSTRAINT [PK_SE_Dropdowns] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UK_Dropdowns]
    ON [dbo].[SE_Dropdowns]([EvaluationID] ASC, [Group] ASC, [Name] ASC);

