CREATE TABLE [dbo].[WorkflowClientAction] (
    [WorkflowClientActionId] INT          IDENTITY (1, 1) NOT NULL,
    [ClientId]               INT          NOT NULL,
    [WorkflowActionId]       INT          NOT NULL,
    [CreatedBy]              VARCHAR (50) NULL,
    [CreatedAt]              DATETIME     NULL,
    [SourceTable]            VARCHAR (50) NULL,
    [SourceRecId]            INT          NULL,
    [SourceTableId]          INT          NULL,
    [IsActive]               BIT          CONSTRAINT [DF_WorkflowClientAction_IsActive] DEFAULT ((1)) NOT NULL,
    [IsDeleted]              BIT          CONSTRAINT [DF_WorkflowClientAction_IsDeleted] DEFAULT ((0)) NOT NULL,
    [UpdatedBy]              VARCHAR (50) NULL,
    [UpdatedAt]              DATETIME     NULL,
    CONSTRAINT [PK_WorkflowClientActivity] PRIMARY KEY CLUSTERED ([WorkflowClientActionId] ASC),
    CONSTRAINT [FK_WorkflowClientAction_Fed_LogTables] FOREIGN KEY ([SourceTableId]) REFERENCES [dbo].[Fed_LogTables] ([TableId]),
    CONSTRAINT [FK_WorkflowClientActivity_WorkflowActivity] FOREIGN KEY ([WorkflowActionId]) REFERENCES [dbo].[WorkflowAction] ([WorkflowActionId])
);

