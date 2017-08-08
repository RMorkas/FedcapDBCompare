

CREATE VIEW [dbo].[Search_VW_Placement]
AS
SELECT        dbo.PlacementEntry.PlacementEntryID, dbo.PlacementEntry.HRACaseID, dbo.PlacementEntry.EmpLocationId, HRACases_1.CaseFirstName, 
                         HRACases_1.CaseSurname, HRACases_1.HRACaseNumber, HRACases_1.Suffix, HRACases_1.LineNumber, HRACases_1.SSN, HRACases_1.CIN, 
                         dbo.Employer.FirstName, dbo.EmployerLocation.Address, dbo.EmployerLocation.City, dbo.EmployerLocation.State, dbo.EmployerLocation.ZipCode, 
                         dbo.PlacementEntry.Title, dbo.PlacementEntry.CompanyId, CONVERT(varchar(MAX), dbo.PlacementEntry.JobStart, 101) AS JobStart, CONVERT(varchar(MAX), 
                         dbo.PlacementEntry.EndDate, 101) AS EndDate, HRACases_1.IsPrivilegeRequired
FROM            dbo.PlacementEntry with(nolock) INNER JOIN
                         dbo.VW_HRACases AS HRACases_1 with(nolock) ON dbo.PlacementEntry.HRACaseID = HRACases_1.HRACaseID AND 
                         dbo.PlacementEntry.CompanyId = HRACases_1.CompanyId INNER JOIN
                         dbo.Employer with(nolock) ON dbo.PlacementEntry.EmployerId = dbo.Employer.EmployerId INNER JOIN
                         dbo.EmployerLocation with(nolock) ON dbo.PlacementEntry.EmpLocationId = dbo.EmployerLocation.EmpLocationId
WHERE        (ISNULL(dbo.PlacementEntry.IsDeleted, 0) = 0)
GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[43] 4[19] 2[27] 3) )"
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
         Begin Table = "Employer"
            Begin Extent = 
               Top = 180
               Left = 229
               Bottom = 292
               Right = 399
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PlacementEntry"
            Begin Extent = 
               Top = 0
               Left = 469
               Bottom = 244
               Right = 688
            End
            DisplayFlags = 280
            TopColumn = 27
         End
         Begin Table = "HRACases_1"
            Begin Extent = 
               Top = 5
               Left = 829
               Bottom = 239
               Right = 1030
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "EmployerLocation"
            Begin Extent = 
               Top = 9
               Left = 186
               Bottom = 164
               Right = 356
            End
            DisplayFlags = 280
            TopColumn = 1
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 20
         Width = 284
         Width = 1800
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
         Column = 3945
         Alias = ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'Search_VW_Placement';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'900
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'Search_VW_Placement';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'Search_VW_Placement';

