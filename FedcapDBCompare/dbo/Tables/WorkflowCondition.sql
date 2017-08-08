CREATE TABLE [dbo].[WorkflowCondition] (
    [WorkflowConditionId] INT           IDENTITY (1, 1) NOT NULL,
    [ConditionName]       VARCHAR (100) NOT NULL,
    [Code]                VARCHAR (100) NOT NULL,
    CONSTRAINT [PK_WorkflowCondition] PRIMARY KEY CLUSTERED ([WorkflowConditionId] ASC)
);

