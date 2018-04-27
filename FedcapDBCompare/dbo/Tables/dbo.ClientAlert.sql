CREATE TABLE [dbo].[ClientAlert] (
    [ClientAlertId]         INT           IDENTITY (1, 1) NOT NULL,
    [CompanyId]             INT           NOT NULL,
    [WorkflowBranchId]      INT           NULL,
    [FunctionName]          VARCHAR (50)  NOT NULL,
    [AlertMessage]          VARCHAR (100) NULL,
    [HasCustomAlertMessage] BIT           CONSTRAINT [DF_ClientAlert_HasCustomAlertMessage] DEFAULT ((0)) NOT NULL,
    [IsDev]                 BIT           NULL,
    [IsUAT]                 BIT           NULL,
    [IsStaging]             BIT           NULL,
    [IsProd]                BIT           NULL,
    CONSTRAINT [PK_ClientAlert] PRIMARY KEY CLUSTERED ([ClientAlertId] ASC),
    CONSTRAINT [FK_ClientAlert_WorkflowBranch] FOREIGN KEY ([WorkflowBranchId]) REFERENCES [dbo].[WorkflowBranch] ([WorkflowBranchId])
);

