CREATE TABLE [dbo].[WorkflowAction] (
    [WorkflowActionId] INT           IDENTITY (1, 1) NOT NULL,
    [Description]      VARCHAR (100) NOT NULL,
    [Code]             VARCHAR (100) NOT NULL,
    [WorkflowBranchId] INT           NOT NULL,
    [Sequence_Number]  INT           NOT NULL,
    [FormName]         VARCHAR (50)  NULL,
    [IsHidden]         BIT           CONSTRAINT [DF_WorkflowAction_IsHidden] DEFAULT ((0)) NOT NULL,
    [IsDev]            BIT           NULL,
    [IsUAT]            BIT           NULL,
    [IsStaging]        BIT           NULL,
    [IsProd]           BIT           NULL,
    CONSTRAINT [PK_WorkflowActivity] PRIMARY KEY CLUSTERED ([WorkflowActionId] ASC),
    CONSTRAINT [FK_WorkflowActivity_WorkflowBranch] FOREIGN KEY ([WorkflowBranchId]) REFERENCES [dbo].[WorkflowBranch] ([WorkflowBranchId])
);

