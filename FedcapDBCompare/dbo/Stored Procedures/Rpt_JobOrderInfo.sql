

CREATE proc [dbo].[Rpt_JobOrderInfo]
@companyId int,
@frmDate smalldatetime =null,
@toDate smalldatetime =null,
@filterWithDate bit =null,
@jobTitle nvarchar(max) =null,
@employmentId int=null,
@educationId int=null,
@backgroundId int=null,
@experience int =null,
@pcId int=null,
@drugTest bit =null,
@liftMax numeric(18,2) =null,
@canStand bit =null,
@canSit bit =null,
@hasDL bit =null,
@hasCDL bit =null,
@jobLeadId int =null,
@frmWages numeric(18,2) =null,
@toWages numeric(18,2) =null,
@Where nvarchar(Max) =null,
@trNo	int =null,
@IsActive bit= null,
@zipCode int =null
AS
Declare @SqlString NVARCHAR(Max) ,  @sqlHraCase Nvarchar(Max) , @maxFilter Nvarchar(Max) 

Set dateformat mdy

Set @sqlHraCase = ''

--IF(@experience > 0)
--Begin
--	SET @sectorFilter =	' Join
--						(
--							SELECT ResumeId FROM [dbo].[CV_Position]
--							group by ResumeId 
--							Having SUM(ISNULL([ExperienceYears],0)) >= ' + Cast(@experience as nvarchar(max)) + ' 
--						) AS sector
--						ON dbo.CV_Resume.ResumeId = sector.ResumeId '
--END
--ELSE
--	SET @sectorFilter = ' '
if(@zipCode > 0)
	set @maxFilter = ' top 100 '
else
	set @maxFilter = ' '


Set @SqlString = N'

SELECT  ' + @maxFilter + '  dbo.CV_JobOrder.JobOrderId, dbo.Employer.FirstName AS EmployerName, dbo.EmployerLocation.Address, dbo.EmployerLocation.City, dbo.EmployerLocation.State, 
                         dbo.EmployerLocation.ZipCode, dbo.CV_JobOrder.JobTitle, dbo.CV_JobOrder.VisibilitySiteId, 
						 Case 
							When Enumes_1.Item = ''Private'' then ''Accessible to '' + dbo.[User].FirstName + '' '' + dbo.[User].LastName
							When Enumes_1.Item = ''Site Wide'' then ''Accessible to '' + dbo.[Site].SiteName
							When Enumes_1.Item = ''Project Wide'' then ''Accessible to '' + dbo.Company.CompanyName
							When Enumes_1.Item = ''Public'' then ''Accessible to Public''
							ELSE ''''
							END AS VisibilityType, 
						 Enumes_2.Item AS EmploymentType, 
                         dbo.CV_JobOrder.JobOpeningDate, dbo.CV_JobOrder.SectorId, Sector.SetcorName AS SectorName, dbo.CV_JobOrder.Duration, dbo.CV_JobOrder.FromWages, 
                         dbo.CV_JobOrder.ToWages, dbo.CV_JobOrder.EducationId, Enumes_4.Item AS DegreeType, dbo.CV_JobOrder.MinExperience, 
                         dbo.CV_JobOrder.PermittedBackgroundId, dbo.Enumes.Item AS BackgroundType, dbo.CV_JobOrder.SummaryDesc, dbo.CV_JobOrder.Skills, 
                         dbo.CV_JobOrder.Certifications, dbo.CV_JobOrder.Languages, dbo.CV_JobOrder.CreatedBy, dbo.CV_JobOrder.CreatedAt, 
						 dbo.CV_JobOrder.JobLeadUserId, dbo.[User].FirstName + '' '' + dbo.[User].LastName AS JobLeadName,
						 dbo.CV_JobOrder.JobVisibilityId, dbo.CV_JobOrder.CompanyId, Enumes_1.Item As SecurityType, OpenVacancies,
						 dbo.CV_JobOrder.JobOrderTrNo, dbo.CV_JobOrder.IsActive, dbo.CV_JobOrder.JobClosingDate
FROM            dbo.CV_JobOrder with(nolock) INNER JOIN
                         dbo.EmployerLocation with(nolock) ON dbo.CV_JobOrder.EmployerLocationId = dbo.EmployerLocation.EmpLocationId INNER JOIN
                         dbo.Employer with(nolock) ON dbo.EmployerLocation.EmployerId = dbo.Employer.EmployerId INNER JOIN
						 dbo.Company with(nolock) ON dbo.CV_JobOrder.CompanyId = dbo.Company.CompanyId LEFT OUTER JOIN
                         dbo.Enumes with(nolock) ON dbo.CV_JobOrder.PermittedBackgroundId = dbo.Enumes.EnumId LEFT OUTER JOIN
                         dbo.[User] with(nolock) ON dbo.CV_JobOrder.JobLeadUserId = dbo.[User].UserID LEFT OUTER JOIN
                         dbo.[Site] with(nolock) ON dbo.[CV_JobOrder].VisibilitySiteId = dbo.[Site].SiteId LEFT OUTER JOIN
                         dbo.Enumes AS Enumes_4 ON dbo.CV_JobOrder.EducationId = Enumes_4.EnumId LEFT OUTER JOIN
                         dbo.Sector AS Sector ON dbo.CV_JobOrder.SectorId = Sector.SectorId LEFT OUTER JOIN
                         dbo.Enumes AS Enumes_2 ON dbo.CV_JobOrder.EmploymentTypeId = Enumes_2.EnumId LEFT OUTER JOIN
                         dbo.Enumes AS Enumes_1 ON dbo.CV_JobOrder.JobVisibilityId = Enumes_1.EnumId ' + ' 
WHERE
--dbo.CV_JobOrder.CompanyId = ' + Cast(@companyId as nvarchar(max)) + 
' 
--AND 
IsNull(dbo.CV_JobOrder.[IsDeleted],0) = 0 
AND 
( ' + '''' + Cast(@filterWithDate as nvarchar(max)) + '''' + ' = 1 OR
	(
		(dateadd(day,0,datediff(day,0,dbo.CV_JobOrder.CreatedAt))>= dateadd(day,0,datediff(day,0, ' + '' + CONVERT(nvarchar(max),@frmDate,101) + '' +'))) 
		AND 
		(dateadd(day,0,datediff(day,0,dbo.CV_JobOrder.CreatedAt))<= dateadd(day,0,datediff(day,0,' + '' + CONVERT(nvarchar(max),@toDate,101) + '' +'))) 
	)
) '
 + 
' AND ( ' + '''' + @jobTitle + '''' + ' = '''' OR dbo.CV_JobOrder.JobTitle like ' + '''' + '%'  + @jobTitle + '%' + '''' + ')'
+
' AND ( ' + '''' + Cast(@employmentId as nvarchar(max)) + '''' + ' = ''0''  OR ' + 'dbo.CV_JobOrder.EmploymentTypeId = ' + Cast(@employmentId as nvarchar(max)) + ')'
+ 
' AND ( ' + '''' + Cast(@educationId as nvarchar(max)) + '''' + ' =  ''0''   OR ' + 'dbo.CV_JobOrder.EducationId >= ' + Cast(@educationId as nvarchar(max)) + ')'
+
' AND ( ' + '''' + Cast(@backgroundId as nvarchar(max)) + '''' + ' = ''0''  OR ' + 'dbo.CV_JobOrder.PermittedBackgroundId >= ' + Cast(@backgroundId as nvarchar(max)) + ')'
+
' AND ( ' + '''' + Cast(@experience as nvarchar(max)) + '''' + ' = ''0''  OR ' + 'dbo.CV_JobOrder.MinExperience >= ' + Cast(@experience as nvarchar(max)) + ')'
+
' AND ( ' + '' + Cast(@pcId as nvarchar(max)) + '' + ' = ''0''  OR ' + 'ISNULL(dbo.CV_JobOrder.ComputerLevelId,297) >= ' + Cast(@pcId as nvarchar(max)) + ')'
+
' AND ( ' + '' + Cast(@drugTest as nvarchar(max)) + '' + ' = ''0''  OR ' + 'ISNULL(dbo.CV_JobOrder.RequiredDrugTest,0) = ' + Cast(@drugTest as nvarchar(max)) + ')'
+
' AND ( ' + '' + Cast(@liftMax as nvarchar(max)) + '' + ' = ''0''  OR ' + 'ISNULL(dbo.CV_JobOrder.LiftMax,0) >= ' + Cast(@liftMax as nvarchar(max)) + ')'
+
' AND ( ' + '' + Cast(@canStand as nvarchar(max)) + '' + ' = ''0''  OR ' + 'ISNULL(dbo.CV_JobOrder.CanStandLongPeriod,0) = ' + Cast(@canStand as nvarchar(max)) + ')'
+
' AND ( ' + '' + Cast(@canSit as nvarchar(max)) + '' + ' = ''0''  OR ' + 'ISNULL(dbo.CV_JobOrder.CanSitLongPeriod,0) = ' + Cast(@canSit as nvarchar(max)) + ')'
+
' AND ( ' + '' + Cast(@hasDL as nvarchar(max)) + '' + ' = ''0''  OR ' + 'ISNULL(dbo.CV_JobOrder.HasPersonalDriverLicense,0) = ' + Cast(@hasDL as nvarchar(max)) + ')'
+
' AND ( ' + '' + Cast(@hasCDL as nvarchar(max)) + '' + ' = ''0''  OR ' + 'ISNULL(dbo.CV_JobOrder.HasCommercialDriverLicense,0) = ' + Cast(@hasCDL as nvarchar(max)) + ')'
+
'
AND	(
		( ' + '' + Cast(@frmWages as nvarchar(max)) + '' + ' = ''0''  OR ' + 'ISNULL(dbo.CV_JobOrder.FromWages,0) >= ' + Cast(@frmWages as nvarchar(max)) + ')'  + '
		AND 
		( ' + '' + Cast(@toWages as nvarchar(max)) + '' + ' = ''0''  OR ' + 'ISNULL(dbo.CV_JobOrder.ToWages,0) <= ' + Cast(@toWages as nvarchar(max)) + ')'  + '
	)
'
+
' AND ( ' + '' + Cast(@jobLeadId as nvarchar(max)) + '' + ' = ''0''  OR ' + 'dbo.CV_JobOrder.JobLeadUserId = ' + Cast(@jobLeadId as nvarchar(max)) + ')'
+
' AND ( ' + '' + Cast(@trNo as nvarchar(max)) + '' + ' = ''0''  OR ' + 'ISNULL(dbo.CV_JobOrder.JobOrderTrNo,0) = ' + Cast(@trNo as nvarchar(max)) + ')'
+
' AND ( ' + '' + Cast(@IsActive as nvarchar(max)) + '' + ' = ''0''  OR ' + 'ISNULL(dbo.CV_JobOrder.IsActive,0) = ' + Cast(@IsActive as nvarchar(max)) + ')'
+
@Where


execute (@sqlHraCase + @SqlString )
