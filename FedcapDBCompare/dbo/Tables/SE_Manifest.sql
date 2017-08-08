CREATE TABLE [dbo].[SE_Manifest] (
    [ID]            INT          IDENTITY (1, 1) NOT NULL,
    [DocSource]     VARCHAR (2)  NULL,
    [DocType]       VARCHAR (4)  NULL,
    [CaseNumber]    VARCHAR (10) NULL,
    [Suffix]        VARCHAR (2)  NULL,
    [Line]          VARCHAR (2)  NULL,
    [DOB]           DATETIME     NULL,
    [SSN]           VARCHAR (9)  NULL,
    [CIN]           VARCHAR (8)  NULL,
    [FirstName]     VARCHAR (20) NULL,
    [LastName]      VARCHAR (30) NULL,
    [MiddleInitial] VARCHAR (2)  NULL,
    [CreateDate]    DATETIME     NULL,
    [DCN]           VARCHAR (36) NULL,
    CONSTRAINT [PK_SE_Manifest] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UK_DCN]
    ON [dbo].[SE_Manifest]([DCN] ASC);

