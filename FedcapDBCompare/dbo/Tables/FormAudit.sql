CREATE TABLE [dbo].[FormAudit] (
    [FormAuditId]  INT          IDENTITY (1, 1) NOT NULL,
    [FormId]       INT          NULL,
    [FormRecordId] INT          NOT NULL,
    [SavedDate]    DATETIME     NOT NULL,
    [SavedBy]      VARCHAR (80) NOT NULL,
    [TransType]    VARCHAR (20) NOT NULL,
    CONSTRAINT [PK_FormAudit] PRIMARY KEY CLUSTERED ([FormAuditId] ASC),
    CONSTRAINT [FK_FormAudit_FormInfo] FOREIGN KEY ([FormId]) REFERENCES [dbo].[FormInfo] ([FormId])
);

