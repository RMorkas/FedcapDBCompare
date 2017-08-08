CREATE TABLE [dbo].[WorkflowClientBranch] (
    [WorkflowClientBranchId] INT      IDENTITY (1, 1) NOT NULL,
    [ClientId]               INT      NOT NULL,
    [WorkflowBranchId]       INT      NOT NULL,
    [CreatedAt]              DATETIME CONSTRAINT [DF_WorkflowClientBranch_CreatedAt] DEFAULT (getdate()) NULL,
    [LastUpdated]            DATETIME NULL,
    [IsActive]               BIT      CONSTRAINT [DF_WorkflowClientBranch_IsActive] DEFAULT ((1)) NOT NULL,
    [SourceRecId]            INT      NULL,
    [SourceTableId]          INT      NULL,
    CONSTRAINT [PK_WorkflowClientBranch] PRIMARY KEY CLUSTERED ([WorkflowClientBranchId] ASC),
    CONSTRAINT [FK_WorkflowClientBranch_Fed_LogTables] FOREIGN KEY ([SourceTableId]) REFERENCES [dbo].[Fed_LogTables] ([TableId]),
    CONSTRAINT [FK_WorkflowClientBranch_WorkflowBranch] FOREIGN KEY ([WorkflowBranchId]) REFERENCES [dbo].[WorkflowBranch] ([WorkflowBranchId])
);

