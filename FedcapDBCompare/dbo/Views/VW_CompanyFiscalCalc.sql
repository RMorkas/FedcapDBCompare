

CREATE VIEW [dbo].[VW_CompanyFiscalCalc]
AS
SELECT        CompanyFiscalYearId, CompanyId, MinWage, VocEdMaxMonths, StartDate, EndDate, TotalEDREHours, TotalActualHours, EDREThreshold, 
                         CASE WHEN companyCalc2.EDREThreshold < 0.3 THEN Ceiling((0.3 - companyCalc2.EDREThreshold) * companyCalc2.TotalActualHours) 
                         ELSE 0 END AS RemaingCoreEDREHours, dbo.getIsTeenParentWithNoHSGEDCount(CompanyId, StartDate, EndDate) AS IsTeenParentWithNoHSGEDCount
FROM            (SELECT        CompanyFiscalYearId, CompanyId, MinWage, VocEdMaxMonths, StartDate, EndDate, TotalEDREHours, TotalActualHours, 
                                                    TotalEDREHours / CASE WHEN companyCalc.TotalActualHours = 0 THEN 1 ELSE companyCalc.TotalActualHours END AS EDREThreshold
                          FROM            (SELECT        dbo.CompanyFiscalYear.CompanyFiscalYearId, dbo.Company.CompanyId, dbo.Company.MinWage, dbo.Company.VocEdMaxMonths, 
                                                                              dbo.CompanyFiscalYear.StartDate, dbo.CompanyFiscalYear.EndDate, dbo.getTotalEDREHours(dbo.Company.CompanyId, 
                                                                              dbo.CompanyFiscalYear.StartDate, dbo.CompanyFiscalYear.EndDate) AS TotalEDREHours, 
                                                                              dbo.getTotalActualHours(dbo.Company.CompanyId, dbo.CompanyFiscalYear.StartDate, dbo.CompanyFiscalYear.EndDate) 
                                                                              AS TotalActualHours
                                                    FROM            dbo.Company with(nolock) INNER JOIN
                                                                              dbo.CompanyFiscalYear with(nolock) ON dbo.Company.CompanyId = dbo.CompanyFiscalYear.CompanyId) AS companyCalc) AS companyCalc2


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
         Configuration = "(H (4 [30] 2 [40] 3))"
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
         Configuration = "(H (4 [50] 3))"
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
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "companyCalc2"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 224
               Right = 241
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
      Begin ColumnWidths = 9
         Width = 284
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
         Column = 1440
         Alias = 900
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VW_CompanyFiscalCalc';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VW_CompanyFiscalCalc';

