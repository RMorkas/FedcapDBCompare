CREATE TABLE [dbo].[WorkflowBranch] (
    [WorkflowBranchId] INT           IDENTITY (1, 1) NOT NULL,
    [Description]      VARCHAR (50)  NOT NULL,
    [Code]             VARCHAR (50)  NOT NULL,
    [Sequence_Number]  INT           NOT NULL,
    [HelpText]         VARCHAR (512) NULL,
    [IsDev]            BIT           NULL,
    [IsUAT]            BIT           NULL,
    [IsStaging]        BIT           NULL,
    [IsProd]           BIT           NULL,
    CONSTRAINT [PK_WorkflowBranch] PRIMARY KEY CLUSTERED ([WorkflowBranchId] ASC)
);

