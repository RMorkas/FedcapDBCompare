﻿CREATE TABLE [dbo].[Historical_B2WReferral] (
    [Id]                   INT          IDENTITY (1, 1) NOT NULL,
    [ImportDate]           DATETIME     NULL,
    [Processed]            BIT          NULL,
    [Scheduled]            BIT          NULL,
    [HraCaseNumber]        VARCHAR (13) NULL,
    [Suffix]               VARCHAR (3)  NULL,
    [LineNumber]           VARCHAR (3)  NULL,
    [Cin]                  VARCHAR (9)  NULL,
    [LastName]             VARCHAR (18) NULL,
    [FirstName]            VARCHAR (11) NULL,
    [MiddleInitial]        VARCHAR (2)  NULL,
    [ApplicantRegDate]     VARCHAR (11) NULL,
    [Gender]               VARCHAR (2)  NULL,
    [SSN]                  VARCHAR (10) NULL,
    [DOB]                  VARCHAR (11) NULL,
    [LocalOfficeCode]      VARCHAR (4)  NULL,
    [HRAIndividualStatus]  VARCHAR (3)  NULL,
    [DTSClientId]          VARCHAR (11) NULL,
    [ClientDemoChangeDate] VARCHAR (11) NULL,
    [AgencyCode]           VARCHAR (4)  NULL,
    [WorkSiteCode]         VARCHAR (6)  NULL,
    [ProgramStartDate]     VARCHAR (11) NULL,
    [AssignedHours]        VARCHAR (3)  NULL,
    [RequiredHours]        VARCHAR (3)  NULL,
    [EBTStartDate]         VARCHAR (11) NULL,
    [OrientationStartDate] VARCHAR (5)  NULL,
    [TerminationDate]      VARCHAR (12) NULL,
    [DTSAssignmentId]      VARCHAR (11) NULL,
    [CycleStartDate]       VARCHAR (10) NULL,
    [HRACaseId]            INT          NULL,
    [Mon]                  CHAR (1)     NULL,
    [Tue]                  CHAR (1)     NULL,
    [Wed]                  CHAR (1)     NULL,
    [Thu]                  CHAR (1)     NULL,
    [Fri]                  CHAR (1)     NULL,
    [Sat]                  CHAR (1)     NULL,
    [Sun]                  CHAR (1)     NULL,
    CONSTRAINT [PK_Historical_B2WReferral] PRIMARY KEY CLUSTERED ([Id] ASC)
);

