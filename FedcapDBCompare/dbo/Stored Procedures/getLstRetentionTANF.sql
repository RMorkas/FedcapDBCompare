CREATE proc [dbo].[getLstRetentionTANF]
@companyId int,
@DBName nvarchar(max),
@dateAsOf smalldatetime =null,
@onlyAvailable bit =null,
@Where nvarchar(Max) =null
AS
Declare @SqlString NVARCHAR(Max) , @sqlLoginTable Nvarchar(Max) , @sqlHraCase Nvarchar(Max)

Set dateformat mdy

Set @SqlString = N'

SELECT  distinct      dbo.PlacementEntry.PlacementEntryID, dbo.PlacementEntry.HRACaseID, HRACases_1.SSN, HRACases_1.HRACaseNumber, HRACases_1.Suffix, HRACases_1.LineNumber,HRACases_1.CIN,
                         HRACases_1.CaseSurname, HRACases_1.CaseFirstName, dbo.PlacementEntry.SiteId, 
                         dbo.Site.SiteName,	 dbo.PlacementEntry.PlacementTypeId,
                         EnumType.Item AS PlacementTypeDesc, dbo.PlacementEntry.PlacementSourceId, EnumSource.Item AS PlacementSourceDesc, dbo.PlacementEntry.HoursPerWeek, 
                         dbo.PlacementEntry.JobStart, dbo.PlacementEntry.EndDate, dbo.PlacementEntry.MatchedByUserId, MatchedUsers.LastName AS MatchLastName, 
                         MatchedUsers.FirstName AS MatchFirstName, dbo.PlacementEntry.PlacementLeadUserId, LeadUsers.LastName AS LeadLastName, 
                         LeadUsers.FirstName AS LeadFirstName,dbo.PlacementEntry.EmpLocationId,
						 EnumBilling.Item AS BillingType,
						 FIAEntryDate,dbo.PlacementEntry.CreatedAt, dbo.[User].FirstName + '' '' + dbo.[User].LastName as RetentionName,
						 HRACases_1.IsPrivilegeRequired, 
						 dbo.[CaseStatus_Def].InternalDescription AS CaseStatusDescription,
						 dbo.[Client].SanctionEffectiveDate AS SanctionEffectiveDate,
						 dbo.[Client].ExemptionEffectiveDate AS ExemptionEffectiveDate
FROM            dbo.PlacementEntry with(nolock) INNER JOIN
                         [dbo].[VW_HRACases] AS HRACases_1 with(nolock) ON dbo.PlacementEntry.HRACaseID = HRACases_1.HRACaseID AND
						 dbo.PlacementEntry.[CompanyId] = HRACases_1.[CompanyId] INNER JOIN
                         dbo.Site with(nolock) ON dbo.PlacementEntry.SiteId = dbo.Site.SiteId INNER JOIN
                         dbo.Enumes AS EnumType with(nolock) ON dbo.PlacementEntry.PlacementTypeId = EnumType.EnumId INNER JOIN
						 dbo.[Case] ON dbo.[Case].CaseId = HRACases_1.ActiveCaseId INNER JOIN 
						 dbo.[Client] ON dbo.[Client].ClientId = HRACases_1.HRACaseID INNER JOIN 
						 dbo.[CaseStatus_Def] ON dbo.[CaseStatus_Def].InternalStatusCode = dbo.[Case].StatusId AND dbo.[CaseStatus_Def].CompanyId = dbo.PlacementEntry.[CompanyId] INNER JOIN 
                         dbo.Enumes AS EnumSource with(nolock) ON dbo.PlacementEntry.PlacementSourceId = EnumSource.EnumId LEFT OUTER JOIN
                         [dbo].[User] AS MatchedUsers with(nolock) ON dbo.PlacementEntry.MatchedByUserId = MatchedUsers.UserID LEFT OUTER JOIN
                         [dbo].[User] AS LeadUsers with(nolock) ON dbo.PlacementEntry.PlacementLeadUserId = LeadUsers.UserID LEFT OUTER JOIN 
						 dbo.Enumes AS EnumBilling with(nolock) ON dbo.PlacementEntry.BillingTypeId = EnumBilling.EnumId Left Outer Join
						 dbo.[User] with(nolock) ON dbo.PlacementEntry.[RetentionSpecialistId] = dbo.[User].UserID						 
						 CROSS APPLY
						(			
							select  PlacementEntryID from 
							dbo.PlacementPeriod with(nolock)
							WHERE
							dbo.PlacementPeriod.PlacementEntryID = dbo.PlacementEntry.PlacementEntryID
							AND 
							( ' + '''' + Cast(@onlyAvailable as nvarchar(max)) + '''' + ' = 0 OR
								(
									(
										(dateadd(day,0,datediff(day,0,dbo.PlacementPeriod.AvailabilityDate)) <= dateadd(day,0,datediff(day,0, ' + '''' + CONVERT(nvarchar(max),@dateAsOf,101) + '''' +'))) 
										AND 
										(dateadd(day,0,datediff(day,0,dbo.PlacementPeriod.ExpirationDate)) > dateadd(day,0,datediff(day,0,' + '''' + CONVERT(nvarchar(max),@dateAsOf,101) + '''' +'))) 

									AND 
									(
										dbo.PlacementEntry.EndDate IS NULL	OR 
										 dateadd(day,0,datediff(day,0,PlacementPeriod.AvailabilityDate)) < dateadd(day,0,datediff(day,0,dbo.PlacementEntry.EndDate)))
									)
									AND PlacementPeriod.PlacementRetentionId IS NULL
								)

							)
							AND 
							( ' + '''' + Cast(@onlyAvailable as nvarchar(max)) + '''' + ' = 1 OR
								(
									(dateadd(day,0,datediff(day,0,dbo.PlacementPeriod.ExpirationDate - 1)) > dateadd(day,0,datediff(day,0,' + '''' + CONVERT(nvarchar(max),@dateAsOf,101) + '''' +'))) 
								)
							)
							AND
							ISNULL(dbo.PlacementPeriod.IsLostJob,0) = 0
							AND
							ISNULL(dbo.PlacementPeriod.IsReplaced,0) = 0

						) as period
WHERE
dbo.PlacementEntry.CompanyId = ' + Cast(@companyId as nvarchar(max)) + 
' 
AND 
IsNull(dbo.PlacementEntry.[IsDeleted],0) = 0  --AND dbo.PlacementEntry.PlacementEntryID < 100

'
+ 
@Where
--print( @SqlString )
execute(@SqlString )
