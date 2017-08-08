
CREATE VIEW [dbo].[Search_VW_JobReferral]
AS
SELECT        dbo.CV_JobReferral.JobReferralId, dbo.CV_JobReferral.CompanyId, dbo.CV_JobReferral.ClientId, dbo.VW_HRACases.CaseFirstName, 
                         dbo.VW_HRACases.CaseSurname, dbo.VW_HRACases.HRACaseNumber, dbo.VW_HRACases.Suffix, dbo.VW_HRACases.LineNumber, dbo.VW_HRACases.SSN, 
                         dbo.VW_HRACases.CIN, dbo.CV_JobReferral.InterviewDate, dbo.CV_JobReferral.InterviewTime, dbo.CV_JobOrder.JobTitle, 
                         dbo.Employer.FirstName AS EmployerName, dbo.EmployerLocation.Address, dbo.EmployerLocation.City, dbo.EmployerLocation.State, 
                         dbo.EmployerLocation.ZipCode, dbo.VW_HRACases.IsPrivilegeRequired
FROM            dbo.CV_JobReferral WITH (nolock) INNER JOIN
                         dbo.VW_HRACases WITH (nolock) ON dbo.CV_JobReferral.ClientId = dbo.VW_HRACases.HRACaseID AND 
                         dbo.CV_JobReferral.CompanyId = dbo.VW_HRACases.CompanyId INNER JOIN
                         dbo.CV_JobOrder WITH (nolock) ON dbo.CV_JobReferral.JobOrderId = dbo.CV_JobOrder.JobOrderId INNER JOIN
                         dbo.EmployerLocation WITH (nolock) ON dbo.CV_JobOrder.EmployerLocationId = dbo.EmployerLocation.EmpLocationId INNER JOIN
                         dbo.Employer WITH (nolock) ON dbo.EmployerLocation.EmployerId = dbo.Employer.EmployerId
WHERE        (dbo.CV_JobReferral.IsDeleted = 0)


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
         Begin Table = "VW_HRACases"
            Begin Extent = 
               Top = 6
               Left = 246
               Bottom = 135
               Right = 447
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CV_JobOrder"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 267
               Right = 282
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "EmployerLocation"
            Begin Extent = 
               Top = 270
               Left = 38
               Bottom = 399
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Employer"
            Begin Extent = 
               Top = 270
               Left = 246
               Bottom = 399
               Right = 416
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CV_JobReferral"
            Begin Extent = 
               Top = 6
               Left = 485
               Bottom = 135
               Right = 716
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
         Or ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'Search_VW_JobReferral';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'= 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'Search_VW_JobReferral';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'Search_VW_JobReferral';

