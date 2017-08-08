CREATE TABLE [dbo].[WorkflowAction] (
    [WorkflowActionId] INT           IDENTITY (1, 1) NOT NULL,
    [Description]      VARCHAR (100) NOT NULL,
    [Code]             VARCHAR (100) NOT NULL,
    [WorkflowBranchId] INT           NOT NULL,
    [Sequence_Number]  INT           NOT NULL,
    [FormName]         VARCHAR (50)  NULL,
    CONSTRAINT [PK_WorkflowActivity] PRIMARY KEY CLUSTERED ([WorkflowActionId] ASC),
    CONSTRAINT [FK_WorkflowActivity_WorkflowBranch] FOREIGN KEY ([WorkflowBranchId]) REFERENCES [dbo].[WorkflowBranch] ([WorkflowBranchId])
);

