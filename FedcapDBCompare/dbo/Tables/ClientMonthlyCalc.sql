CREATE TABLE [dbo].[ClientMonthlyCalc] (
    [ClientMonthlyCalcId]                   INT             IDENTITY (1, 1) NOT NULL,
    [MonthDate]                             SMALLDATETIME   NULL,
    [CaseClientId]                          INT             NULL,
    [ClientCoreActualHours]                 INT             NULL,
    [ClientNonCoreActualHours]              INT             NULL,
    [ClientCoreScheduledHours]              INT             NULL,
    [ClientNonCoreScheduledHours]           INT             NULL,
    [ClientScheduledRemainingHours]         INT             NULL,
    [ClientFLSAActualHours]                 INT             NULL,
    [ClientFLSAScheduledHours]              INT             NULL,
    [ClientRemainingFLSAScheduledHours]     INT             NULL,
    [IsTeenParentWithNoHSGED]               BIT             NULL,
    [ClientVocEdMonths]                     INT             NULL,
    [ClientRemainingVocEdMonths]            INT             NULL,
    [ClientWEPHours]                        INT             NULL,
    [ClientRemainingWEPHours]               INT             NULL,
    [ClientOJTHours]                        INT             NULL,
    [ClientRemainingOJTHours]               INT             NULL,
    [ClientJSJRHoursFY]                     INT             NULL,
    [ClientRemainingJSJRHoursFY]            INT             NULL,
    [ClientJSJRConsecutiveHoursFY]          INT             NULL,
    [ClientRemainingJSJRConsecutiveHoursFY] INT             NULL,
    [AbsentHoursMonthCount]                 INT             NULL,
    [AbsentHoursYearCount]                  INT             NULL,
    [ClientEDREHoursFY]                     INT             NULL,
    [ClientRemainingEDREHoursFY]            INT             NULL,
    [FoodStampSubsidy]                      NUMERIC (18, 2) NULL,
    [TANSubsidy]                            NUMERIC (18, 2) NULL,
    [ChildCareSubsidy]                      BIT             NULL,
    [IsTwoParentCase]                       BIT             NULL,
    [IsChildUnderSix]                       BIT             NULL,
    [ClientFLSAAttendStatusScheduledHrs]    INT             NULL,
    [ClientOJTScheduledHrs]                 INT             NULL,
    [ClientJSJRScheduledHoursFY]            INT             NULL,
    [ClientVOCEDHrs]                        INT             NULL,
    [ClientVOCEDScheduledHrs]               INT             NULL,
    [ClientVocEdMonthsScheduled]            INT             NULL,
    [EmploymentScheduledHours]              INT             NULL,
    [EmploymentActualHours]                 INT             NULL,
    CONSTRAINT [PK_CaseMonthlyCalc] PRIMARY KEY CLUSTERED ([ClientMonthlyCalcId] ASC)
);


GO
CREATE NONCLUSTERED INDEX [CaseClientId]
    ON [dbo].[ClientMonthlyCalc]([CaseClientId] ASC)
    INCLUDE([MonthDate], [ClientCoreActualHours], [ClientNonCoreActualHours], [ClientCoreScheduledHours], [ClientNonCoreScheduledHours], [ClientScheduledRemainingHours], [ClientFLSAActualHours], [ClientFLSAScheduledHours], [ClientRemainingFLSAScheduledHours], [ClientVocEdMonths], [ClientRemainingVocEdMonths], [ClientOJTHours], [ClientJSJRHoursFY], [AbsentHoursMonthCount], [AbsentHoursYearCount], [FoodStampSubsidy], [TANSubsidy], [ClientFLSAAttendStatusScheduledHrs], [ClientOJTScheduledHrs], [ClientJSJRScheduledHoursFY], [ClientVOCEDHrs], [ClientVOCEDScheduledHrs], [ClientVocEdMonthsScheduled]);

