CREATE TABLE [dbo].[DTSAssignmentHistory] (
    [AssignmentHistoryId] INT          IDENTITY (1, 1) NOT NULL,
    [ClientId]            INT          NULL,
    [WorkSiteCode]        VARCHAR (6)  NULL,
    [ProgramStartDate]    DATETIME     NULL,
    [TerminationDate]     DATETIME     NULL,
    [DTSAssignmentId]     VARCHAR (11) NULL,
    CONSTRAINT [PK_DTSAssignmentHistory] PRIMARY KEY CLUSTERED ([AssignmentHistoryId] ASC)
);

