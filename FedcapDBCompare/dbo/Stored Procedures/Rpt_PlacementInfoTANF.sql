



CREATE proc [dbo].[Rpt_PlacementInfoTANF]
@companyId int,
@DBName nvarchar(max),
@frmDate smalldatetime =null,
@toDate smalldatetime =null,
@ISFIADateNotNull bit =null,
@ISFIADateNull bit =null,
@Where nvarchar(Max) =null,
@frmCreatedmDate smalldatetime =null,
@toCreatedDate smalldatetime =null,
@filterWithCreatedDate bit =null
AS
Declare @SqlString NVARCHAR(Max) , @extendSqlString Nvarchar(Max) , @sqlScript Nvarchar(Max) ,@filter NVARCHAR(Max)

Set dateformat mdy


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
                         dbo.PlacementEntry.JobStart, dbo.PlacementEntry.EndDate, dbo.PlacementEntry.MatchedByUserId, MatchedUsers.LastName AS MatchLastName, 
                         MatchedUsers.FirstName AS MatchFirstName, dbo.PlacementEntry.PlacementLeadUserId, LeadUsers.LastName AS LeadLastName, 
                         LeadUsers.FirstName AS LeadFirstName,dbo.PlacementEntry.EmpLocationId,
						 EnumBilling.Item AS BillingType,
						 CASE
							WHEN ISNULL(HasBenefits,0) = 0 THEN ''NO''
							ELSE ''YES''
						 END AS HasBenefitsDesc,FIAEntryDate,dbo.PlacementEntry.CreatedAt,SecondJobStartDate,
						 dbo.[User].FirstName + '' '' + dbo.[User].LastName as RetentionName, EnumCustStatus.Item As CustomerStatus, EnumEmployType.Item as EmploymentType,
						 '''' AS AssistedBy, HRACases_1.IsPrivilegeRequired , '''' AS NonBillableReason,
						 dbo.[CaseType].TypeCode
FROM            dbo.PlacementEntry with(nolock) INNER JOIN
                         [dbo].[VW_HRACases] AS HRACases_1 WITH(NOLOCK) ON dbo.PlacementEntry.HRACaseID = HRACases_1.HRACaseID  AND
						 dbo.PlacementEntry.CompanyId = HRACases_1.CompanyId INNER JOIN
                         dbo.Site ON dbo.PlacementEntry.SiteId = dbo.Site.SiteId INNER JOIN
                         dbo.Employer with(nolock) ON dbo.PlacementEntry.EmployerId = dbo.Employer.EmployerId INNER JOIN
                         dbo.Enumes ON dbo.Employer.IndustryId = dbo.Enumes.EnumId INNER JOIN
                         dbo.Sector AS Sector ON dbo.PlacementEntry.SectorId = Sector.SectorId INNER JOIN
                         dbo.Enumes AS EnumType ON dbo.PlacementEntry.PlacementTypeId = EnumType.EnumId INNER JOIN
                         dbo.Enumes AS EnumSource ON dbo.PlacementEntry.PlacementSourceId = EnumSource.EnumId LEFT OUTER JOIN
                         dbo.[User] AS MatchedUsers ON dbo.PlacementEntry.MatchedByUserId = MatchedUsers.UserID LEFT OUTER JOIN
                         dbo.[User] AS LeadUsers ON dbo.PlacementEntry.PlacementLeadUserId = LeadUsers.UserID  INNER JOIN 
						 dbo.SectorTitle AS Title ON dbo.PlacementEntry.TitleId = Title.SectorTitleId Left Outer Join
						 dbo.Enumes AS EnumBilling ON dbo.PlacementEntry.BillingTypeId = EnumBilling.EnumId Left Outer Join
						 dbo.[User] ON dbo.PlacementEntry.[RetentionSpecialistId] = dbo.[User].UserID Left Outer JOIN
                         dbo.Enumes AS EnumCustStatus ON dbo.PlacementEntry.CustomerStatusId = EnumCustStatus.EnumId Left Outer JOIN
                         dbo.Enumes AS EnumEmployType ON dbo.PlacementEntry.EmploymentTypeId = EnumEmployType.EnumId LEFT OUTER JOIN
				    dbo.[Case] with(nolock) ON HRACases_1.ActiveCaseId = dbo.[Case].[CaseId] LEFT OUTER JOIN  
				    dbo.[CaseType] with(nolock) ON dbo.[Case].[CaseTypeId] = dbo.[CaseType].[CaseTypeId]  '
SET @filter =' 
WHERE
dbo.PlacementEntry.CompanyId = ' + Cast(@companyId as nvarchar(max)) + 
' 
AND 
IsNull(dbo.PlacementEntry.[IsDeleted],0) = 0  --AND dbo.PlacementEntry.PlacementEntryID < 100
AND 
( ' + '''' + Cast(@ISFIADateNull as nvarchar(max)) + '''' + ' = 1 OR
(
(dateadd(day,0,datediff(day,0,dbo.PlacementEntry.FIAEntryDate))>= dateadd(day,0,datediff(day,0, ' + '''' + CONVERT(nvarchar(max),@frmDate,101) + '''' +'))) 
AND 
(dateadd(day,0,datediff(day,0,dbo.PlacementEntry.FIAEntryDate))<= dateadd(day,0,datediff(day,0,' + '''' + CONVERT(nvarchar(max),@toDate,101) + '''' +'))) 
)
)
AND 
( ' + '''' + Cast(@ISFIADateNotNull as nvarchar(max)) + '''' + ' = 1 OR dbo.PlacementEntry.FIAEntryDate IS NULL )
AND 
( ' + '''' + Cast(@filterWithCreatedDate as nvarchar(max)) + '''' + ' = 1 OR
(
(dateadd(day,0,datediff(day,0,dbo.PlacementEntry.CreatedAt))>= dateadd(day,0,datediff(day,0, ' + '''' + CONVERT(nvarchar(max),@frmCreatedmDate,101) + '''' +'))) 
AND 
(dateadd(day,0,datediff(day,0,dbo.PlacementEntry.CreatedAt))<= dateadd(day,0,datediff(day,0,' + '''' + CONVERT(nvarchar(max),@toCreatedDate,101) + '''' +'))) 
)
) '


--SET @sqlScript = (@SqlString + ' ' + @extendSqlString)
--print(@sqlScript)
exec (@SqlString + ' ' + @filter + ' ' + @Where)
--execute(@SqlString)


