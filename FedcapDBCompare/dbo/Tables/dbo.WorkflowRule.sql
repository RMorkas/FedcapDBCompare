CREATE TABLE [dbo].[WorkflowRule] (
    [WorkflowId]                   INT IDENTITY (1, 1) NOT NULL,
    [CompanyId]                    INT NOT NULL,
    [WorkflowActionId]             INT NOT NULL,
    [WorkflowConditionId]          INT NULL,
    [WorkflowPrerequisiteActionId] INT NOT NULL,
    [WorkflowBranchId]             INT NULL,
    [DaysBeforePending]            INT NULL,
    [IsDev]                        BIT NULL,
    [IsUAT]                        BIT NULL,
    [IsStaging]                    BIT NULL,
    [IsProd]                       BIT NULL,
    CONSTRAINT [PK_Workflow] PRIMARY KEY CLUSTERED ([WorkflowId] ASC),
    CONSTRAINT [FK_Workflow_WorkflowActivityId] FOREIGN KEY ([WorkflowActionId]) REFERENCES [dbo].[WorkflowAction] ([WorkflowActionId]),
    CONSTRAINT [FK_Workflow_WorkflowCondition] FOREIGN KEY ([WorkflowConditionId]) REFERENCES [dbo].[WorkflowCondition] ([WorkflowConditionId]),
    CONSTRAINT [FK_Workflow_WorkflowPrerequisiteActivityId] FOREIGN KEY ([WorkflowPrerequisiteActionId]) REFERENCES [dbo].[WorkflowAction] ([WorkflowActionId])
);

