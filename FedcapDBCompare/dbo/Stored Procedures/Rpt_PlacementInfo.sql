


CREATE proc [dbo].[Rpt_PlacementInfo]
@companyId int,
@DBName VARCHAR(max),
@frmDate smalldatetime =null,
@toDate smalldatetime =null,
@ISFIADateNotNull bit =null,
@ISFIADateNull bit =null,
@Where VARCHAR(Max) =null,
@frmCreatedmDate smalldatetime =null,
@toCreatedDate smalldatetime =null,
@filterWithCreatedDate bit =null
AS
Declare @SqlString VARCHAR(Max)  , @sqlLoginTable VARCHAR(Max) , @sqlHraCase VARCHAR(Max), @serverName VARCHAR(max)


Set dateformat mdy

IF(@companyId = 7)
	BEGIN
		Set @serverName = 'ALLSECTOR_BTW'
		set @DBName = 'fedcapbtw'
	END
else
	Set @serverName = 'ALLSECTOR'

Set @sqlLoginTable = 
'Declare @LoginTable Table
(
	[UserID] [varchar](40) NOT NULL,
	[LastName] [varchar](40) NULL,
	[FirstName] [varchar](40) NULL
)

INSERT INTO @LoginTable 
SELECT  UserID , LastName , FirstName FROM  OPENQUERY(' + @serverName + ', ' + ''''+ 'Select  UserID , Rtrim(LastName) AS LastName , RTRIM(FirstName) AS FirstName From ' + @DBName + '.dbo.LoginTable' + '''' + ') 

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
SELECT  HRACaseID , HRACaseNumber , Suffix , LineNumber , CIN , Rtrim(CaseSurname) AS CaseSurname , Rtrim(CaseFirstName) AS CaseFirstName , SSN FROM  OPENQUERY(' + @serverName + ', ' + '''' + 'Select  HRACaseID , HRACaseNumber , Suffix ,LineNumber, CIN , CaseSurname , CaseFirstName , SSN From ' + @DBName + '.dbo.HRACases' + '''' + ')

'

Set @SqlString = '

SELECT        dbo.PlacementEntry.PlacementEntryID, dbo.PlacementEntry.HRACaseID, HRACases_1.SSN, HRACases_1.HRACaseNumber, HRACases_1.Suffix, HRACases_1.LineNumber,HRACases_1.CIN,
                         HRACases_1.CaseSurname, HRACases_1.CaseFirstName, dbo.PlacementEntry.CellPhone, dbo.PlacementEntry.HomePhone, dbo.PlacementEntry.SiteId, 
                         dbo.Site.SiteName, dbo.PlacementEntry.EmployerId, dbo.Employer.FirstName AS EmployerName, dbo.Employer.IndustryId, dbo.Enumes.Item AS IndustryName, dbo.PlacementEntry.SectorId, 
                         Sector.SetcorName, Title.Title, 
						 isnull(dbo.PlacementEntry.SalaryRate , 0) AS SalaryRate,
						 CASE
						 WHEN isnull(dbo.PlacementEntry.SalaryRate , 0) = 0 THEN ' + '''' + 'Hour' + '''' +
'						 WHEN isnull(dbo.PlacementEntry.SalaryRate , 0) = 1 THEN ' + '''' + 'Bi-Weekly' + '''' +
'						 WHEN isnull(dbo.PlacementEntry.SalaryRate , 0) = 2 THEN ' + '''' + 'Annual' + '''' +
'						 Else ''''''''
						 End AS SalaryType, dbo.PlacementEntry.Salary,Isnull(dbo.PlacementEntry.SalaryPerHour , 0) AS SalaryPerHour,
						 
						 dbo.PlacementEntry.PlacementTypeId, 
                         EnumType.Item AS PlacementTypeDesc, dbo.PlacementEntry.PlacementSourceId, EnumSource.Item AS PlacementSourceDesc, dbo.PlacementEntry.HoursPerWeek, 
                         dbo.PlacementEntry.JobStart, dbo.PlacementEntry.EndDate, dbo.PlacementEntry.MatchedByUserId, MatchedUsers.FirstName AS MatchFirstName, 
                         MatchedUsers.LastName AS MatchLastName, dbo.PlacementEntry.PlacementLeadUserId, LeadUsers.FirstName AS LeadFirstName, 
                         LeadUsers.LastName AS LeadLastName,dbo.PlacementEntry.EmpLocationId,
						 EnumBilling.Item AS BillingType,
						 CASE
							WHEN ISNULL(HasBenefits,0) = 0 THEN ''NO''
							ELSE ''YES''
						 END AS HasBenefitsDesc,FIAEntryDate,dbo.PlacementEntry.CreatedAt,SecondJobStartDate,
						 dbo.[User].FirstName + '' '' + dbo.[User].LastName as RetentionName, EnumCustStatus.Item As CustomerStatus, EnumEmployType.Item as EmploymentType,
						 AssistedUsers.FirstName + '' '' + AssistedUsers.LastName AS AssistedBy, 0 As IsPrivilegeRequired, EnumNonBillableReason.Item AS NonBillableReason
FROM            dbo.PlacementEntry with(nolock) INNER JOIN
                         @HRACases AS HRACases_1 ON dbo.PlacementEntry.HRACaseID = HRACases_1.HRACaseID INNER JOIN
                         dbo.Site ON dbo.PlacementEntry.SiteId = dbo.Site.SiteId INNER JOIN
                         dbo.Employer with(nolock) ON dbo.PlacementEntry.EmployerId = dbo.Employer.EmployerId INNER JOIN
                         dbo.Enumes ON dbo.Employer.IndustryId = dbo.Enumes.EnumId INNER JOIN
                         dbo.Sector AS Sector ON dbo.PlacementEntry.SectorId = Sector.SectorId INNER JOIN
                         dbo.Enumes AS EnumType ON dbo.PlacementEntry.PlacementTypeId = EnumType.EnumId INNER JOIN
                         dbo.Enumes AS EnumSource ON dbo.PlacementEntry.PlacementSourceId = EnumSource.EnumId LEFT OUTER JOIN
                         @LoginTable AS MatchedUsers ON dbo.PlacementEntry.MatchedByUserId = MatchedUsers.UserID LEFT OUTER JOIN
                         @LoginTable AS LeadUsers ON dbo.PlacementEntry.PlacementLeadUserId = LeadUsers.UserID INNER JOIN 
						 dbo.SectorTitle AS Title ON dbo.PlacementEntry.TitleId = Title.SectorTitleId INNER JOIN
						 dbo.Enumes AS EnumBilling ON dbo.PlacementEntry.BillingTypeId = EnumBilling.EnumId Left Outer Join
						 dbo.[User] ON dbo.PlacementEntry.[RetentionSpecialistId] = dbo.[User].UserID Left Outer JOIN
                         dbo.Enumes AS EnumCustStatus ON dbo.PlacementEntry.CustomerStatusId = EnumCustStatus.EnumId Left Outer JOIN
                         dbo.Enumes AS EnumEmployType ON dbo.PlacementEntry.EmploymentTypeId = EnumEmployType.EnumId LEFT OUTER JOIN
                         @LoginTable AS AssistedUsers ON dbo.PlacementEntry.AssistedById = AssistedUsers.UserID LEFT OUTER JOIN
                         dbo.Enumes AS EnumNonBillableReason with(nolock) ON dbo.PlacementEntry.NotBillableReasonId = EnumNonBillableReason.EnumId
WHERE
dbo.PlacementEntry.CompanyId = ' + Cast(@companyId as VARCHAR(max)) + 
' 
AND 
IsNull(dbo.PlacementEntry.[IsDeleted],0) = 0 
AND 
( ' + '''' + Cast(@ISFIADateNull as VARCHAR(max)) + '''' + ' = 1 OR
(
(dateadd(day,0,datediff(day,0,dbo.PlacementEntry.FIAEntryDate))>= dateadd(day,0,datediff(day,0, ' + '''' + CONVERT(VARCHAR(max),@frmDate,101) + '''' +'))) 
AND 
(dateadd(day,0,datediff(day,0,dbo.PlacementEntry.FIAEntryDate))<= dateadd(day,0,datediff(day,0,' + '''' + CONVERT(VARCHAR(max),@toDate,101) + '''' +'))) 
)
)
AND 
( ' + '''' + Cast(@ISFIADateNotNull as VARCHAR(max)) + '''' + ' = 1 OR dbo.PlacementEntry.FIAEntryDate IS NULL )
AND 
( ' + '''' + Cast(@filterWithCreatedDate as VARCHAR(max)) + '''' + ' = 1 OR
(
(dateadd(day,0,datediff(day,0,dbo.PlacementEntry.CreatedAt))>= dateadd(day,0,datediff(day,0, ' + '''' + CONVERT(VARCHAR(max),@frmCreatedmDate,101) + '''' +'))) 
AND 
(dateadd(day,0,datediff(day,0,dbo.PlacementEntry.CreatedAt))<= dateadd(day,0,datediff(day,0,' + '''' + CONVERT(VARCHAR(max),@toCreatedDate,101) + '''' +'))) 
)
) '
+ 
@Where


execute( @sqlLoginTable + @sqlHraCase + @SqlString )