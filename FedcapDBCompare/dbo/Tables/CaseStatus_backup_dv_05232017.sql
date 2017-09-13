CREATE TABLE [dbo].[CaseStatus_backup_dv_05232017] (
    [id]                INT          IDENTITY (1, 1) NOT NULL,
    [Caseid]            INT          NOT NULL,
    [Status]            NVARCHAR (2) NOT NULL,
    [Status_StartDate]  DATETIME     NULL,
    [Status_EndDate]    DATETIME     NULL,
    [CaseClosureReason] VARCHAR (10) NULL
);

