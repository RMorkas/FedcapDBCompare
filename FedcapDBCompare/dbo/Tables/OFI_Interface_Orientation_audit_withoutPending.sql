CREATE TABLE [dbo].[OFI_Interface_Orientation_audit_withoutPending] (
    [id]                   INT           IDENTITY (1, 1) NOT NULL,
    [clientid]             INT           NULL,
    [OFI_Office]           VARCHAR (50)  NULL,
    [ClientNo]             VARCHAR (50)  NULL,
    [CaseNo]               VARCHAR (50)  NULL,
    [Date]                 DATETIME      NULL,
    [Orientation_Attended] VARCHAR (50)  NULL,
    [New_Orientation_Date] DATETIME      NULL,
    [Dateadded]            DATETIME      NULL,
    [scheduleid]           INT           NULL,
    [Datesubmitted]        DATETIME      NULL,
    [Good_Cause_Notes]     VARCHAR (500) NULL
);

