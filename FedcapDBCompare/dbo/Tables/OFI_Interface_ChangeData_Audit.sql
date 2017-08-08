CREATE TABLE [dbo].[OFI_Interface_ChangeData_Audit] (
    [id]                       INT            IDENTITY (1, 1) NOT NULL,
    [OFI office]               VARCHAR (50)   NULL,
    [changeDate]               DATETIME       NULL,
    [clientno]                 VARCHAR (50)   NULL,
    [Sanction_complied_ind]    VARCHAR (10)   NULL,
    [Sanction_complied_Dt]     DATETIME       NULL,
    [Updated_ChangeEnd_Dt]     DATETIME       NULL,
    [dateadded]                DATETIME       NULL,
    [noteID]                   INT            NULL,
    [clientid]                 INT            NULL,
    [note]                     VARCHAR (5000) NULL,
    [datesubmitted]            DATETIME       NULL,
    [ASPIRE_Sanction_Expunged] VARCHAR (100)  NULL,
    [imaging_Note]             VARCHAR (1000) NULL
);

