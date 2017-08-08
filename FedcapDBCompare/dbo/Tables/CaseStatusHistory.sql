CREATE TABLE [dbo].[CaseStatusHistory] (
    [id]                INT           IDENTITY (1, 1) NOT NULL,
    [Caseid]            INT           NOT NULL,
    [Status]            NVARCHAR (2)  NOT NULL,
    [Status_StartDate]  DATETIME      NULL,
    [Status_EndDate]    DATETIME      NULL,
    [CaseClosureReason] VARCHAR (200) NULL,
    CONSTRAINT [PK_CaseStatusHistory] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_CaseStatusHistory_CaseId] FOREIGN KEY ([Caseid]) REFERENCES [dbo].[Case] ([CaseId])
);

