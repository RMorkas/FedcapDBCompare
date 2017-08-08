CREATE VIEW dbo.VW_APDetailedReport
AS
WITH AccountPayable(RecordID, GLDate, BatchName, BatchCreationDate, BatchCreator, VendorName, ChartsOfAccounts, BatchEntrySeg, SegmentValue, InvoiceNumber, 
InvoiceDate, InvoiceDescription, InvoiceAmount, Response, CheckNumber, CheckDate, CheckAmount, VoidDate, DistributionAmt, InvoiceStatus, PaymentStatusFlag, CompanyId, 
AccountId, LineOfBusinessId, DivisionId, DepartmentId, ProjectId, LocationId, FUT, Custom) AS (SELECT        RecordID, GLDate, BatchName, BatchCreationDate, BatchCreator, 
                                                                                                                                                                                                                                       VendorName, ChartsOfAccounts, BatchEntrySeg, SegmentValue, 
                                                                                                                                                                                                                                       InvoiceNumber, InvoiceDate, InvoiceDescription, InvoiceAmount, 
                                                                                                                                                                                                                                       Response, CheckNumber, CheckDate, CheckAmount, VoidDate, 
                                                                                                                                                                                                                                       DistributionAmt, InvoiceStatus, PaymentStatusFlag, 
                                                                                                                                                                                                                                       dbo.Split(ChartsOfAccounts, '.', 1) AS CompanyId, 
                                                                                                                                                                                                                                       dbo.Split(ChartsOfAccounts, '.', 2) AS AccountId, 
                                                                                                                                                                                                                                       dbo.Split(ChartsOfAccounts, '.', 3) AS LineOfBusinessId, 
                                                                                                                                                                                                                                       dbo.Split(ChartsOfAccounts, '.', 4) AS DivisionId, 
                                                                                                                                                                                                                                       dbo.Split(ChartsOfAccounts, '.', 5) AS DepartmentId, 
                                                                                                                                                                                                                                       dbo.Split(ChartsOfAccounts, '.', 6) AS ProjectId, 
                                                                                                                                                                                                                                       dbo.Split(ChartsOfAccounts, '.', 7) AS LocationId, 
                                                                                                                                                                                                                                       dbo.Split(ChartsOfAccounts, '.', 8) AS FUT, dbo.Split(ChartsOfAccounts, 
                                                                                                                                                                                                                                       '.', 9) AS Custom
                                                                                                                                                                                                              FROM            dbo.APDetailedReport)
    SELECT        AccountPayable.RecordID, AccountPayable.GLDate, AccountPayable.BatchName, AccountPayable.BatchCreationDate, AccountPayable.BatchCreator, 
                              AccountPayable.VendorName, AccountPayable.ChartsOfAccounts, AccountPayable.BatchEntrySeg, AccountPayable.SegmentValue, AccountPayable.InvoiceNumber, 
                              AccountPayable.InvoiceDate, AccountPayable.InvoiceDescription, AccountPayable.InvoiceAmount, AccountPayable.Response, AccountPayable.CheckNumber, 
                              AccountPayable.CheckDate, AccountPayable.CheckAmount, AccountPayable.VoidDate, AccountPayable.DistributionAmt, AccountPayable.InvoiceStatus, 
                              AccountPayable.PaymentStatusFlag, AccountPayable.CompanyId, dbo.ACC_Company.CompanyName, AccountPayable.AccountId, dbo.ACC_Account.AccountName, 
                              AccountPayable.LineOfBusinessId, dbo.ACC_LineOfBusiness.LineOfBusinessDesc, AccountPayable.DivisionId, dbo.ACC_Division.DivisionName, 
                              AccountPayable.DepartmentId, dbo.ACC_Department.DepartmentName, AccountPayable.ProjectId, dbo.ACC_Project.ProjectName, AccountPayable.LocationId, 
                              dbo.ACC_Location.LocationName, AccountPayable.FUT, AccountPayable.Custom
     FROM            AccountPayable AS AccountPayable LEFT OUTER JOIN
                              dbo.ACC_LineOfBusiness ON AccountPayable.LineOfBusinessId = dbo.ACC_LineOfBusiness.LineOfBusinessId LEFT OUTER JOIN
                              dbo.ACC_Location ON AccountPayable.LocationId = dbo.ACC_Location.LocationId LEFT OUTER JOIN
                              dbo.ACC_Project ON AccountPayable.ProjectId = dbo.ACC_Project.ProjectId LEFT OUTER JOIN
                              dbo.ACC_Department ON AccountPayable.DepartmentId = dbo.ACC_Department.DepartmentId LEFT OUTER JOIN
                              dbo.ACC_Division ON AccountPayable.DivisionId = dbo.ACC_Division.DivisionId LEFT OUTER JOIN
                              dbo.ACC_Account ON AccountPayable.AccountId = dbo.ACC_Account.AccountId LEFT OUTER JOIN
                              dbo.ACC_Company ON AccountPayable.CompanyId = dbo.ACC_Company.CompanyId

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
         Configuration = "(H (1[50] 4[25] 3) )"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1[50] 2[25] 3) )"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1[56] 3) )"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4[76] 3) )"
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
         Begin Table = "ACC_Location"
            Begin Extent = 
               Top = 230
               Left = 868
               Bottom = 325
               Right = 1038
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ACC_Project"
            Begin Extent = 
               Top = 120
               Left = 856
               Bottom = 215
               Right = 1026
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ACC_Department"
            Begin Extent = 
               Top = 288
               Left = 52
               Bottom = 383
               Right = 236
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ACC_Division"
            Begin Extent = 
               Top = 11
               Left = 700
               Bottom = 106
               Right = 870
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ACC_LineOfBusiness"
            Begin Extent = 
               Top = 174
               Left = 48
               Bottom = 269
               Right = 242
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ACC_Account"
            Begin Extent = 
               Top = 99
               Left = 55
               Bottom = 193
               Right = 225
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ACC_Company"
            Begin Extent = 
               Top = 0
               Left = 59
               Bottom = 95
               Right = 232
          ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VW_APDetailedReport';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'  End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "AccountPayable"
            Begin Extent = 
               Top = 0
               Left = 440
               Bottom = 221
               Right = 630
            End
            DisplayFlags = 280
            TopColumn = 21
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 38
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
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1800
         Alias = 2385
         Table = 1860
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VW_APDetailedReport';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VW_APDetailedReport';

