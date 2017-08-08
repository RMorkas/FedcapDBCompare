
CREATE VIEW [dbo].[VW_Resumes]
AS
SELECT        dbo.CV_BaseResume.ResumeId, dbo.CV_BaseResume.HrCaseId, dbo.CV_BaseResume.FirstName, dbo.CV_BaseResume.LastName, 
                         dbo.VW_HRACases.HRACaseNumber, dbo.VW_HRACases.Suffix, dbo.VW_HRACases.LineNumber, dbo.VW_HRACases.SSN, dbo.VW_HRACases.CIN, 
                         dbo.CV_BaseResume.Address, dbo.CV_BaseResume.City, dbo.CV_BaseResume.State, dbo.CV_BaseResume.ZipCode, dbo.CV_BaseResume.CompanyId
FROM            dbo.CV_BaseResume with(nolock) INNER JOIN
                         dbo.VW_HRACases with(nolock) ON dbo.CV_BaseResume.HrCaseId = dbo.VW_HRACases.HRACaseID AND 
                         dbo.CV_BaseResume.CompanyId = dbo.VW_HRACases.CompanyId
WHERE        (dbo.CV_BaseResume.IsDeleted = 0)
GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[54] 4[20] 2[15] 3) )"
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
         Left = -46
      End
      Begin Tables = 
         Begin Table = "VW_HRACases"
            Begin Extent = 
               Top = 49
               Left = 556
               Bottom = 322
               Right = 757
            End
            DisplayFlags = 280
            TopColumn = 32
         End
         Begin Table = "CV_BaseResume"
            Begin Extent = 
               Top = 6
               Left = 84
               Bottom = 236
               Right = 282
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
      Begin ColumnWidths = 15
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
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 3000
         Alias = 900
         Table = 3885
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VW_Resumes';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VW_Resumes';

