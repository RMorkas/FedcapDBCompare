CREATE TABLE [dbo].[Company] (
    [CompanyId]                    INT             NOT NULL,
    [Code]                         VARCHAR (50)    NULL,
    [ActiveDirectoryName]          VARCHAR (100)   NULL,
    [CompanyName]                  VARCHAR (100)   NULL,
    [Address]                      VARCHAR (100)   NULL,
    [City]                         VARCHAR (50)    NULL,
    [State]                        VARCHAR (50)    NULL,
    [ZipCode]                      INT             NULL,
    [Email]                        VARCHAR (50)    NULL,
    [ResumePath]                   VARCHAR (80)    NULL,
    [IVRNumber]                    VARCHAR (20)    NULL,
    [MinWage]                      NUMERIC (18, 2) NULL,
    [VocEdMaxMonths]               INT             NULL,
    [FolderPath]                   NVARCHAR (256)  NULL,
    [IsActive]                     BIT             CONSTRAINT [DF_Company_IsActive] DEFAULT ((0)) NOT NULL,
    [IsWorkflowFeatureEnabled]     BIT             NULL,
    [IsClientAlertsFeatureEnabled] BIT             NULL,
    [IsClientFormsFeatureEnabled]  BIT             NULL,
    [IsEnrollFedcapAcademyEnabled] BIT             NULL,
    CONSTRAINT [PK_Companies] PRIMARY KEY CLUSTERED ([CompanyId] ASC)
);

