CREATE VIEW dbo.Search_VW_JobOrder
AS
SELECT        dbo.CV_JobOrder.JobOrderId, dbo.CV_JobOrder.CompanyId, dbo.CV_JobOrder.JobOrderTrNo, dbo.Employer.FirstName AS EmployerName, 
                         dbo.EmployerLocation.Address, dbo.EmployerLocation.City, dbo.EmployerLocation.State, dbo.EmployerLocation.ZipCode, dbo.CV_JobOrder.JobTitle, 
                         dbo.CV_JobOrder.VisibilitySiteId, Enumes_1.Item AS VisibilityType, Enumes_2.Item AS EmploymentType, dbo.CV_JobOrder.JobOpeningDate, 
                         dbo.CV_JobOrder.SectorId, dbo.Sector.SetcorName, dbo.CV_JobOrder.Duration, dbo.CV_JobOrder.FromWages, dbo.CV_JobOrder.ToWages, 
                         dbo.CV_JobOrder.EducationId, Enumes_4.Item AS DegreeType, dbo.CV_JobOrder.MinExperience, dbo.CV_JobOrder.PermittedBackgroundId, 
                         dbo.Enumes.Item AS BackgroundType, dbo.CV_JobOrder.SummaryDesc, dbo.CV_JobOrder.Skills, dbo.CV_JobOrder.Certifications, dbo.CV_JobOrder.Languages, 
                         dbo.CV_JobOrder.JobLeadUserId, dbo.[User].FirstName + ' ' + dbo.[User].LastName AS JobLeadBy, dbo.CV_JobOrder.OpenVacancies
FROM            dbo.CV_JobOrder WITH (nolock) INNER JOIN
                         dbo.EmployerLocation WITH (nolock) ON dbo.CV_JobOrder.EmployerLocationId = dbo.EmployerLocation.EmpLocationId INNER JOIN
                         dbo.Employer WITH (nolock) ON dbo.EmployerLocation.EmployerId = dbo.Employer.EmployerId INNER JOIN
                         dbo.Sector WITH (nolock) ON dbo.CV_JobOrder.SectorId = dbo.Sector.SectorId LEFT OUTER JOIN
                         dbo.[User] WITH (nolock) ON dbo.CV_JobOrder.JobLeadUserId = dbo.[User].UserID LEFT OUTER JOIN
                         dbo.Enumes WITH (nolock) ON dbo.CV_JobOrder.PermittedBackgroundId = dbo.Enumes.EnumId LEFT OUTER JOIN
                         dbo.Enumes AS Enumes_4 WITH (nolock) ON dbo.CV_JobOrder.EducationId = Enumes_4.EnumId LEFT OUTER JOIN
                         dbo.Enumes AS Enumes_2 WITH (nolock) ON dbo.CV_JobOrder.EmploymentTypeId = Enumes_2.EnumId LEFT OUTER JOIN
                         dbo.Enumes AS Enumes_1 WITH (nolock) ON dbo.CV_JobOrder.JobVisibilityId = Enumes_1.EnumId
WHERE        (dbo.CV_JobOrder.IsDeleted = 0)
GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[49] 4[13] 2[12] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1[40] 4[36] 3) )"
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
         Configuration = "(H (1[67] 3) )"
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
         Begin Table = "CV_JobOrder"
            Begin Extent = 
               Top = 4
               Left = 235
               Bottom = 255
               Right = 450
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "EmployerLocation"
            Begin Extent = 
               Top = 0
               Left = 671
               Bottom = 188
               Right = 875
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Employer"
            Begin Extent = 
               Top = 0
               Left = 1089
               Bottom = 152
               Right = 1259
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Sector"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 135
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "User"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 267
               Right = 235
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Enumes"
            Begin Extent = 
               Top = 285
               Left = 334
               Bottom = 414
               Right = 504
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Enumes_4"
            Begin Extent = 
               Top = 274
               Left = 520
               Bottom = 403
               Right = 690
            End
            DisplayFlag', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'Search_VW_JobOrder';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N's = 280
            TopColumn = 0
         End
         Begin Table = "Enumes_2"
            Begin Extent = 
               Top = 173
               Left = 691
               Bottom = 302
               Right = 861
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Enumes_1"
            Begin Extent = 
               Top = 0
               Left = 9
               Bottom = 216
               Right = 179
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
      Begin ColumnWidths = 31
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
         Width = 1605
         Width = 1665
         Width = 1500
         Width = 1500
         Width = 1995
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'Search_VW_JobOrder';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'Search_VW_JobOrder';

