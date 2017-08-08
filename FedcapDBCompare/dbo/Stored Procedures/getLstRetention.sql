



CREATE proc [dbo].[getLstRetention]
@companyId int,
@DBName nvarchar(max),
@dateAsOf smalldatetime =null,
@onlyAvailable bit =null,
@Where nvarchar(Max) =null
AS
Declare @SqlString NVARCHAR(Max) , @sqlLoginTable Nvarchar(Max) , @sqlHraCase Nvarchar(Max)


Set dateformat mdy

Set @sqlLoginTable = 
'Declare @LoginTable Table
(
	[UserID] [varchar](40) NOT NULL,
	[LastName] [varchar](40) NULL,
	[FirstName] [varchar](40) NULL
)

INSERT INTO @LoginTable 
SELECT  UserID , LastName , FirstName FROM  OPENQUERY(ALLSECTOR, ' + ''''+ 'Select  UserID , Rtrim(LastName) AS LastName , RTRIM(FirstName) AS FirstName From ' + @DBName + '.dbo.LoginTable' + '''' + ') 

'

Set @sqlHraCase = 'Declare @HRACases Table(
	[HRACaseID] [int],
	[HRACaseNumber] [varchar](10) NULL,
	[Suffix] [varchar](2) NULL,
	[LineNumber] [varchar](2) NULL,
	[CIN] [varchar](9) NULL,
	[CaseSurname] [varchar](50) NULL,
	[CaseFirstName] [varchar](50) NULL,
	[SSN] [varchar](9) NULL
) 

INSERT INTO @HRACases 
SELECT  HRACaseID , HRACaseNumber , Suffix , LineNumber , CIN , Rtrim(CaseSurname) AS CaseSurname , Rtrim(CaseFirstName) AS CaseFirstName , SSN FROM  OPENQUERY(ALLSECTOR, ' + '''' + 'Select  HRACaseID , HRACaseNumber , Suffix ,LineNumber, CIN , CaseSurname , CaseFirstName , SSN From ' + @DBName + '.dbo.HRACases' + '''' + ')

'

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
						 0 AS IsPrivilegeRequired, 
						 '' '' AS CaseStatusDescription,
						 NULL AS SanctionEffectiveDate,
						 NULL AS ExemptionEffectiveDate
FROM            dbo.PlacementEntry with(nolock) INNER JOIN
                         @HRACases AS HRACases_1 ON dbo.PlacementEntry.HRACaseID = HRACases_1.HRACaseID INNER JOIN
                         dbo.Site ON dbo.PlacementEntry.SiteId = dbo.Site.SiteId INNER JOIN
                         dbo.Enumes AS EnumType ON dbo.PlacementEntry.PlacementTypeId = EnumType.EnumId INNER JOIN
                         dbo.Enumes AS EnumSource ON dbo.PlacementEntry.PlacementSourceId = EnumSource.EnumId LEFT OUTER JOIN
                         @LoginTable AS MatchedUsers ON dbo.PlacementEntry.MatchedByUserId = MatchedUsers.UserID LEFT OUTER JOIN
                         @LoginTable AS LeadUsers ON dbo.PlacementEntry.PlacementLeadUserId = LeadUsers.UserID INNER JOIN 
						 dbo.Enumes AS EnumBilling ON dbo.PlacementEntry.BillingTypeId = EnumBilling.EnumId Left Outer Join
						 dbo.[User] ON dbo.PlacementEntry.[RetentionSpecialistId] = dbo.[User].UserID
						 CROSS APPLY
						 (			
							select PlacementEntryID from 
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
execute( @sqlLoginTable + @sqlHraCase + @SqlString )

--AND   ISNULL(dbo.PlacementPeriod.IsLostJob,0) = 0 AND ISNULL(dbo.PlacementPeriod.IsReplaced,0) = 0 AND PlacementPeriod.PlacementRetentionId IS NULL

--AND 
--( 
--	( 
--		dateadd(day,0,datediff(day,0,dbo.PlacementPeriod.AvailabilityDate)) <= dateadd(day,0,datediff(day,0,'5/17/2016')) 
--		AND 
--		dateadd(day,0,datediff(day,0,'5/17/2016')) < dateadd(day,0,datediff(day,0,dbo.PlacementPeriod.ExpirationDate))
 
--	AND 
--	(
--		dbo.PlacementEntry.EndDate IS NULL		
--		OR 
--		dateadd(day,0,datediff(day,0,PlacementPeriod.AvailabilityDate)) < dateadd(day,0,datediff(day,0,dbo.PlacementEntry.EndDate))) 
--	)
--)