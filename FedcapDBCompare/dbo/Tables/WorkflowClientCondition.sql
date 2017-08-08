CREATE TABLE [dbo].[WorkflowClientCondition] (
    [ClientId]            INT NOT NULL,
    [WorkflowConditionId] INT NOT NULL,
    CONSTRAINT [PK_WorkflowClientCondition] PRIMARY KEY CLUSTERED ([ClientId] ASC, [WorkflowConditionId] ASC),
    CONSTRAINT [FK_WorkflowClientCondition_WorkflowCondition] FOREIGN KEY ([WorkflowConditionId]) REFERENCES [dbo].[WorkflowCondition] ([WorkflowConditionId])
);

