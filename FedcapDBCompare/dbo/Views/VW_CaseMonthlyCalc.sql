




CREATE View [dbo].[VW_CaseMonthlyCalc]
AS
SELECT        CaseId, CompanyId, IsActive, CaseNo, CaseTypeId, TypeCode, TypeName, EngagmentStatus, StartDate, EndDate, MonthDate, RemainingDaysOfTheMonth, 
                         CaseRequiredHours, CaseCoreMin, CaseScheduledRemainingHours, CaseCountableHours, CaseCoreActualHours, CaseNonCoreActualHours, 
                         CaseCoreScheduledHours, CaseNonCoreScheduledHours, CaseFLSAActualHours, CaseFLSAScheduledHours, CaseRemainingFLSAScheduledHours, 
                         CaseVocEdMonths, CaseRemainingVocEdMonths, CaseVocEdMonthsScheduled, CaseAbsentHoursMonthCount, CaseAbsentHoursYearCount, FoodStampSubsidy, TANSubsidy, FLSAMaxHours, 
                         FLSAMaxHours - CaseFLSAActualHours AS CaseRemianingFLSAHours, CaseRequiredHours - CaseCountableHours AS CaseRequiredRemainingHours, 
                         dbo.getCriticalImapactDeadline(MonthDate, (CaseRequiredHours - CaseCountableHours), CaseTypeId) AS DeadlineDate, SiteId, SiteName,
						 CaseFLSAAttendStatusScheduledHrs, CaseOJTActualHrs, CaseOJTScheduledHrs, CaseJSJRActualHoursFY, CaseJSJRScheduledHoursFY, CaseVOCEDActualHrs, CaseVOCEDScheduledHrs,
						 IsPrivilegeRequired, StatusId, StaffName, dbo.IsClientSanction(MonthDate, CaseId) AS IsClientSanction,
						 dbo.IsClientExempted(MonthDate, CaseId) AS IsClientExempted
FROM            (SELECT        CaseId, CompanyId, IsActive, CaseNo, CaseTypeId, TypeCode, TypeName, dbo.getEngagmentStatus(CaseId, MonthDate, CaseTypeId) AS EngagmentStatus, StartDate, EndDate, 
                                                    MonthDate, RemainingDaysOfTheMonth, CaseRequiredHours, CaseCoreMin, CaseScheduledRemainingHours, 
                                                    CASE WHEN CaseCoreActualHours >= CaseCoreMin THEN (CaseCoreActualHours + CaseNonCoreActualHours) 
                                                    ELSE CaseCoreActualHours END AS CaseCountableHours, 
													(CaseCoreActualHours + dbo.getFLSACreditHours(CaseId, MonthDate) + dbo.getSatisfactoryAttendCreditHours(CaseId, MonthDate)) AS CaseCoreActualHours,
													CaseNonCoreActualHours, CaseCoreScheduledHours, 
                                                    CaseNonCoreScheduledHours, CaseFLSAActualHours, CaseFLSAScheduledHours, CaseRemainingFLSAScheduledHours, CaseVocEdMonths, 
                                                    CaseRemainingVocEdMonths, CaseVocEdMonthsScheduled, CaseAbsentHoursMonthCount, CaseAbsentHoursYearCount, FoodStampSubsidy, TANSubsidy, 
                                                    CAST((ISNULL(FoodStampSubsidy, 0) + ISNULL(TANSubsidy, 0)) / ISNULL(MinWage, 1) AS Numeric(18, 0)) AS FLSAMaxHours, SiteId, SiteName,
													CaseFLSAAttendStatusScheduledHrs, CaseOJTActualHrs, CaseOJTScheduledHrs,CaseJSJRActualHoursFY, CaseJSJRScheduledHoursFY, CaseVOCEDActualHrs, CaseVOCEDScheduledHrs,
													IsPrivilegeRequired, StatusId, StaffName

                          FROM            (SELECT        dbo.[Case].CaseId, dbo.[Case].CompanyId, dbo.[Case].IsActive, dbo.[Case].CaseNo, dbo.CaseType.CaseTypeId, dbo.CaseType.TypeCode, 
                                                                              dbo.CaseType.TypeName, dbo.[Case].StartDate, dbo.[Case].EndDate, dbo.ClientMonthlyCalc.MonthDate, 
                                                                              dbo.getRemainingDays(dbo.ClientMonthlyCalc.MonthDate) AS RemainingDaysOfTheMonth, 
                                                                              CEILING(dbo.CaseType.MinRequiredWeeklyAverage * 4.33) AS CaseRequiredHours, 
                                                                              CEILING(dbo.CaseType.MinRequiredCoreAvgHours * 4.33) AS CaseCoreMin, 
																			  SUM(ISNULL(dbo.ClientMonthlyCalc.ClientCoreActualHours,0))
                                                                              AS CaseCoreActualHours, SUM(ISNULL(dbo.ClientMonthlyCalc.ClientNonCoreActualHours,0)) AS CaseNonCoreActualHours, 
                                                                              SUM(ISNULL(dbo.ClientMonthlyCalc.ClientCoreScheduledHours,0)) AS CaseCoreScheduledHours, 
                                                                              SUM(ISNULL(dbo.ClientMonthlyCalc.ClientNonCoreScheduledHours,0)) AS CaseNonCoreScheduledHours, 
                                                                              SUM(ISNULL(dbo.ClientMonthlyCalc.ClientScheduledRemainingHours,0)) AS CaseScheduledRemainingHours, 
                                                                              SUM(ISNULL(dbo.ClientMonthlyCalc.ClientFLSAActualHours,0)) AS CaseFLSAActualHours, 
																			  SUM(ISNULL(dbo.ClientMonthlyCalc.ClientFLSAScheduledHours,0)) AS CaseFLSAScheduledHours, 
																			  SUM(ISNULL(dbo.ClientMonthlyCalc.ClientRemainingFLSAScheduledHours,0)) AS CaseRemainingFLSAScheduledHours, 
                                                                              SUM(ISNULL(dbo.ClientMonthlyCalc.ClientVocEdMonths,0)) AS CaseVocEdMonths, 
																			  SUM(ISNULL(dbo.ClientMonthlyCalc.ClientRemainingVocEdMonths,0)) AS CaseRemainingVocEdMonths,
																			  SUM(ISNULL(dbo.ClientMonthlyCalc.ClientVocEdMonthsScheduled,0)) AS CaseVocEdMonthsScheduled, 
																			  SUM(ISNULL(dbo.ClientMonthlyCalc.AbsentHoursMonthCount,0)) AS CaseAbsentHoursMonthCount, 
                                                                              SUM(ISNULL(dbo.ClientMonthlyCalc.AbsentHoursYearCount,0)) AS CaseAbsentHoursYearCount, 
																			  ISNULL(dbo.ClientMonthlyCalc.FoodStampSubsidy,0) AS FoodStampSubsidy, 
                                                                              ISNULL(dbo.ClientMonthlyCalc.TANSubsidy,0) AS TANSubsidy, ISNULL(dbo.Company.MinWage,1) AS MinWage, office.SiteId, office.SiteName,
																			  SUM(ISNULL(dbo.ClientMonthlyCalc.ClientFLSAAttendStatusScheduledHrs,0)) AS CaseFLSAAttendStatusScheduledHrs,
																			  SUM(ISNULL(dbo.ClientMonthlyCalc.ClientOJTHours,0)) AS CaseOJTActualHrs,
																			  SUM(ISNULL(dbo.ClientMonthlyCalc.ClientOJTScheduledHrs,0)) AS CaseOJTScheduledHrs,
																			  SUM(ISNULL(dbo.ClientMonthlyCalc.ClientJSJRHoursFY,0)) AS CaseJSJRActualHoursFY,
																			  SUM(ISNULL(dbo.ClientMonthlyCalc.ClientJSJRScheduledHoursFY,0)) AS CaseJSJRScheduledHoursFY,
																			  SUM(ISNULL(dbo.ClientMonthlyCalc.ClientVOCEDHrs,0)) AS CaseVOCEDActualHrs,
																			  SUM(ISNULL(dbo.ClientMonthlyCalc.ClientVOCEDScheduledHrs,0)) AS CaseVOCEDScheduledHrs,
																			  ISNULL(clientPrivielege.IsPrivilegeRequired,0) AS IsPrivilegeRequired,
																			  dbo.[Case].StatusId, clientPrivielege.StaffName
                                                    FROM            dbo.[Case] with(nolock) inner join
                                                                              dbo.Site AS office with(nolock) ON dbo.[Case].SiteId = office.SiteId inner join
                                                                              dbo.CaseType with(nolock) ON dbo.[Case].CaseTypeId = dbo.CaseType.CaseTypeId inner join
                                                                              dbo.CaseClient with(nolock) ON dbo.[Case].CaseId = dbo.CaseClient.CaseId inner join
                                                                              dbo.ClientMonthlyCalc with(nolock) ON dbo.CaseClient.CaseClientId = dbo.ClientMonthlyCalc.CaseClientId inner join
                                                                              dbo.Company with(nolock) ON dbo.[Case].CompanyId = dbo.Company.CompanyId 
																			  Outer Apply
																			 (
																				SELECT Top 1 ISNULL(c.IsPrivilegeRequired,0) AS IsPrivilegeRequired, staff.FirstName + ' ' + staff.LastName as StaffName
																				 
																				FROM dbo.Client c with(nolock) INNER JOIN
																				dbo.CaseClient cc with(nolock) ON c.ClientId = cc.ClientId left outer join
																				dbo.[User] staff with(nolock) on c.AssignedStaffMemberId = staff.UserID
																				WHERE 
																				cc.CaseId = dbo.[Case].CaseId
																				AND
																				c.CompanyId = CompanyId
																				--AND
																				--(ExemptionEffectiveDate is null OR ExemptionEffectiveDate >= MonthDate )
																				--order by IsPrivilegeRequired desc
																				--AND
																				--ISNULL(c.IsPrivilegeRequired,0) = 1

																			 ) AS clientPrivielege
                                                    GROUP BY dbo.[Case].CaseId, dbo.[Case].CompanyId, dbo.[Case].CaseNo, dbo.CaseType.TypeCode, dbo.CaseType.TypeName, dbo.[Case].IsActive, 
                                                                              dbo.[Case].StartDate, dbo.CaseType.MinRequiredWeeklyAverage, dbo.ClientMonthlyCalc.MonthDate, 
                                                                              dbo.CaseType.MinRequiredCoreAvgHours, dbo.ClientMonthlyCalc.FoodStampSubsidy, dbo.ClientMonthlyCalc.TANSubsidy, 
                                                                              dbo.Company.MinWage, dbo.[Case].EndDate, office.SiteId, office.SiteName, dbo.CaseType.CaseTypeId,
																			  clientPrivielege.IsPrivilegeRequired, StatusId, clientPrivielege.StaffName) AS caseCalc) AS caseCalcInfo
GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4[30] 2[40] 3) )"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4[50] 3) )"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4[60] 2) )"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4) )"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 3
   End
   Begin DiagramPane = 
      PaneHidden = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "caseCalc"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 135
               Right = 322
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 33
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 3615
         Alias = 2910
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VW_CaseMonthlyCalc';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VW_CaseMonthlyCalc';

