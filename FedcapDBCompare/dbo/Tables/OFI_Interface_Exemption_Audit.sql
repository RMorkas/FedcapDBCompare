CREATE TABLE [dbo].[OFI_Interface_Exemption_Audit] (
    [id]                     INT            IDENTITY (1, 1) NOT NULL,
    [clientid]               INT            NULL,
    [clientno]               VARCHAR (50)   NULL,
    [name]                   VARCHAR (50)   NULL,
    [Exemption_Type]         VARCHAR (50)   NULL,
    [start_dt]               DATETIME       NULL,
    [end_dt]                 DATETIME       NULL,
    [BTC Staff Member Name]  VARCHAR (50)   NULL,
    [BTC Staff Member Phone] VARCHAR (50)   NULL,
    [OFI office]             VARCHAR (50)   NULL,
    [datesubmitted]          DATETIME       NULL,
    [dateadded]              DATETIME       NULL,
    [CFD_Name]               VARCHAR (50)   NULL,
    [ExemptionRequestId]     INT            NULL,
    [imaging_Note]           VARCHAR (1000) NULL
);

