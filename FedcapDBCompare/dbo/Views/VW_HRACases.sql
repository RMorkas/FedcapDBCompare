










CREATE VIEW [dbo].[VW_HRACases]
AS
--SELECT        HRACaseID, HRACaseNumber, Suffix, LineNumber, CIN, CaseSurname, CaseFirstName, CaseMiddleInit, PhoneNumber, StreetAddress, ApartmentNumber, 
--                         ResidenceBorough, City, State, ZipCode, DOB, SSN, FEGSCaseManager, FutureCaseManager, EffectiveDate, HRAServiceBorough, HRAOfficeNumber, CaseStatus, 
--                         TrackAssignment, CaseInitDate, LastAction, PageFlag, HRASpecialProgram, CurrEpisode, AppHRANumber, HRACaseType, HRACaseStatus, ReferralCode, 
--                         ReferralCycle, CellPhone, Email, FTROrientation, ExternalProvider, HoursAssigned, EBTCarfareDate, CaseProgress, SubTrackAssignment, 'R1' AS RegionCode, 
--                         1 AS CompanyId, 0 AS ActiveCaseId, 0 AS HSDiploma, 0 AS GED, 0 AS AssignedStaffMemberId
--FROM            [ALLSECTOR_PROD_R1].[FedCapWCR1].[dbo].[HRACases] with (nolock)
--UNION ALL
--SELECT        HRACaseID, HRACaseNumber, Suffix, LineNumber, CIN, CaseSurname, CaseFirstName, CaseMiddleInit, PhoneNumber, StreetAddress, ApartmentNumber, 
--                         ResidenceBorough, City, State, ZipCode, DOB, SSN, FEGSCaseManager, FutureCaseManager, EffectiveDate, HRAServiceBorough, HRAOfficeNumber, CaseStatus, 
--                         TrackAssignment, CaseInitDate, LastAction, PageFlag, HRASpecialProgram, CurrEpisode, AppHRANumber, HRACaseType, HRACaseStatus, ReferralCode, 
--                         ReferralCycle, CellPhone, Email, FTROrientation, ExternalProvider, HoursAssigned, EBTCarfareDate, CaseProgress, SubTrackAssignment, 'R2' AS RegionCode, 
--                         2 AS CompanyId, 0 AS ActiveCaseId, 0 AS HSDiploma, 0 AS GED, 0 AS AssignedStaffMemberId
--FROM            [ALLSECTOR_PROD_R2].[Arborfedcap].[dbo].[HRACases] with (nolock)
--UNION ALL
----SELECT        HRACaseID, HRACaseNumber, Suffix, LineNumber, CIN, CaseSurname, CaseFirstName, CaseMiddleInit, PhoneNumber, StreetAddress, ApartmentNumber, 
----                         ResidenceBorough, City, State, ZipCode, DOB, SSN, FEGSCaseManager, FutureCaseManager, EffectiveDate, HRAServiceBorough, HRAOfficeNumber, CaseStatus, 
----                         TrackAssignment, CaseInitDate, LastAction, PageFlag, HRASpecialProgram, CurrEpisode, AppHRANumber, HRACaseType, HRACaseStatus, ReferralCode, 
----                         ReferralCycle, CellPhone, Email, FTROrientation, ExternalProvider, HoursAssigned, EBTCarfareDate, CaseProgress, '' AS SubTrackAssignment, 
----                         'B2W' AS RegionCode, 7 AS CompanyId, 0 AS ActiveCaseId, 0 AS HSDiploma, 0 AS GED, 0 AS AssignedStaffMemberId
----FROM            [ALLSECTOR_BTW].[fedcapbtw].dbo.HRACases with (nolock)
----UNION ALL
--SELECT        ClientId AS HRACaseID, ClientNo AS HRACaseNumber, Suffix, LineNumber, CIN, CaseLastName AS CaseSurname, CaseFirstName, NULL AS CaseMiddleInit, 
--                         PhoneNumber, StreetAddress, ApartmentNumber, ResidenceBorough, City, State, ZipCode, DOB, SSN, NULL AS FEGSCaseManager, NULL AS FutureCaseManager, 
--                         EffectiveDate, HRAServiceBorough, ReferringOfficeNumber AS HRAOfficeNumber, CaseStatus, TrackAssignment, GETDATE() AS CaseInitDate, GETDATE() AS LastAction, PageFlag, 
--                         HRASpecialProgram, CurrEpisode, AppHRANumber, HRACaseType, HRACaseStatus, ReferralCode, ReferralCycle, CellPhone, Email, FTROrientation, 
--                         ExternalProvider, HoursAssigned, EBTCarfareDate, CaseProgress, '' AS SubTrackAssignment, 'LINC' AS RegionCode, 4 AS CompanyId, 0 AS ActiveCaseId, 
--                         HSDiploma, GED, AssignedStaffMemberId
--FROM            dbo.Client with (nolock)
--WHERE        CompanyId = 4
--UNION ALL
SELECT        ClientId AS HRACaseID, ClientNo AS HRACaseNumber, client.Suffix, client.LineNumber, cast(dbo.[case].CaseNo as varchar(50)) as CIN, CaseLastName AS CaseSurname, CaseFirstName, '' AS CaseMiddleInit, PhoneNumber, 
                         StreetAddress, ApartmentNumber, '' AS ResidenceBorough, City, State, ZipCode, DOB, SSN, '' AS FEGSCaseManager, '' AS FutureCaseManager, NULL AS EffectiveDate, 
                         HRAServiceBorough, ReferringOfficeNumber AS HRAOfficeNumber, ISNULL([case].StatusId, '') AS CaseStatus, '' as TrackAssignment, GETDATE() AS CaseInitDate, GETDATE() AS LastAction, 0 as PageFlag, 
                         0 as HRASpecialProgram, 0 as CurrEpisode, '' as AppHRANumber, 0 as HRACaseType, 0 as HRACaseStatus, '' as ReferralCode, '' as ReferralCycle, CellPhone, Email, null as FTROrientation, 
                         0 as ExternalProvider, 0 as HoursAssigned, null as EBTCarfareDate, 0 as CaseProgress, '' AS SubTrackAssignment, 'Maine' AS RegionCode, client.CompanyId, ActiveCaseId, cast(HSDiploma as int) AS HSDiploma, cast(GED as int) AS GED, AssignedStaffMemberId,
						 ISNULL(IsPrivilegeRequired,0) AS IsPrivilegeRequired
FROM            dbo.Client as client with (nolock) inner join dbo.[case] with (nolock) on client.ActiveCaseId = dbo.[case].CaseId
WHERE        client.CompanyId = 8
UNION ALL
SELECT        ClientId AS HRACaseID, CaseNo AS HRACaseNumber,dbo.[case].Suffix, dbo.[case].LineNumber, CIN, CaseLastName AS CaseSurname, CaseFirstName, NULL AS CaseMiddleInit, 
                         PhoneNumber, StreetAddress, ApartmentNumber, ResidenceBorough, City, State, ZipCode, DOB, SSN, NULL AS FEGSCaseManager, NULL AS FutureCaseManager, 
                         EffectiveDate, HRAServiceBorough, ReferringOfficeNumber AS HRAOfficeNumber, ISNULL([case].StatusId, '') AS CaseStatus, '' as TrackAssignment, GETDATE() AS CaseInitDate, GETDATE() AS LastAction, 0 as PageFlag, 
                         0 as HRASpecialProgram, 0 as CurrEpisode, '' as AppHRANumber, 0 as HRACaseType, 0 as HRACaseStatus, '' as ReferralCode, '' as ReferralCycle, CellPhone, Email, null as FTROrientation, 
                         0 as ExternalProvider, 0 as HoursAssigned, null as EBTCarfareDate, 0 as CaseProgress, '' AS SubTrackAssignment, 'CRS' AS RegionCode, 9 AS CompanyId, client.ActiveCaseId, 
                         HSDiploma, GED, AssignedStaffMemberId, ISNULL(IsPrivilegeRequired,0) AS IsPrivilegeRequired
FROM            dbo.Client as client with (nolock) inner join dbo.[case] with (nolock) on client.ActiveCaseId = dbo.[case].CaseId
WHERE        client.CompanyId = 9









GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[18] 4[18] 2[45] 3) )"
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
         Top = -672
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 48
         Width = 284
         Width = 1500
         Width = 1590
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VW_HRACases';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VW_HRACases';

