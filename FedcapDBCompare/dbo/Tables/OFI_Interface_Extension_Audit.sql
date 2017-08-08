CREATE TABLE [dbo].[OFI_Interface_Extension_Audit] (
    [id]                                 INT            IDENTITY (1, 1) NOT NULL,
    [OFI_Office]                         VARCHAR (50)   NULL,
    [ClientNo]                           VARCHAR (50)   NULL,
    [ExtensionRequestid]                 INT            NULL,
    [TANF_EXTENSION_TYPE_CD]             VARCHAR (50)   NULL,
    [Proposed_Start]                     DATETIME       NULL,
    [Proposed_end]                       DATETIME       NULL,
    [Reason_text]                        VARCHAR (2000) NULL,
    [EXTENSION_REQUEST_DT]               DATETIME       NULL,
    [FEDCAP_APPROVE_DENY_IND]            VARCHAR (50)   NULL,
    [Verification_IND]                   VARCHAR (50)   NULL,
    [Re-consideration_IND]               VARCHAR (50)   NULL,
    [Clientid]                           INT            NULL,
    [Companyid]                          INT            NULL,
    [dateadded]                          DATETIME       NULL,
    [datesubmitted]                      DATETIME       NULL,
    [TANF_EXTENSION_TYPE_CD_Description] VARCHAR (200)  NULL,
    [staff_name]                         VARCHAR (50)   NULL,
    [staff_phone]                        VARCHAR (50)   NULL,
    [imaging_Note]                       VARCHAR (1000) NULL
);

