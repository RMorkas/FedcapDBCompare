﻿CREATE TABLE [dbo].[CaseType] (
    [CaseTypeId]               INT          IDENTITY (1, 1) NOT NULL,
    [CompanyId]                INT          NULL,
    [TypeCode]                 VARCHAR (50) NULL,
    [TypeName]                 VARCHAR (80) NULL,
    [MinRequiredWeeklyAverage] INT          NULL,
    [MinRequiredCoreAvgHours]  INT          NULL,
    [WEPMaxHours]              INT          NULL,
    [OJTMaxHours]              INT          NULL,
    [JSJRMaxHours]             INT          NULL,
    [JSJRMaxCosecutive]        INT          NULL,
    [IsDev]                    BIT          NULL,
    [IsUAT]                    BIT          NULL,
    [IsStaging]                BIT          NULL,
    [IsProd]                   BIT          NULL,
    [IsTANFType]               BIT          NULL,
    CONSTRAINT [PK_CaseType] PRIMARY KEY CLUSTERED ([CaseTypeId] ASC)
);

