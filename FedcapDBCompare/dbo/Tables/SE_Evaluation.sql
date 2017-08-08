CREATE TABLE [dbo].[SE_Evaluation] (
    [ID]            INT          IDENTITY (1, 1) NOT NULL,
    [EvaluationID]  VARCHAR (8)  NULL,
    [CaseNumber]    VARCHAR (10) NULL,
    [Suffix]        VARCHAR (2)  NULL,
    [Line]          VARCHAR (2)  NULL,
    [SSN]           VARCHAR (9)  NULL,
    [CIN]           VARCHAR (8)  NULL,
    [Track]         VARCHAR (10) NULL,
    [DomainID]      VARCHAR (20) NULL,
    [UserID]        VARCHAR (20) NULL,
    [VendorID]      VARCHAR (6)  NULL,
    [Outcome]       VARCHAR (20) NULL,
    [DateCompleted] DATETIME     NULL,
    [DocID]         VARCHAR (30) NULL,
    [DCN]           VARCHAR (45) NULL,
    [GridRule]      VARCHAR (6)  NULL,
    CONSTRAINT [PK_SE_Evaluation] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UK_DCN]
    ON [dbo].[SE_Evaluation]([DCN] ASC);

