


CREATE proc [dbo].[Rpt_ResumeInfo_TANF]
@companyId int,
@DBName nvarchar(max),
@frmDate smalldatetime =null,
@toDate smalldatetime =null,
@filterWithDate bit =null,
@firstName nvarchar(max) =null,
@lastName nvarchar(max) =null,
@SSN nvarchar(max) =null,
@experience int =null,
@readingScore numeric(18,1) =null,
@mathScore numeric(18,1) =null,
@backgroundId int=null,
@educationId int=null,
@pcId int=null,
@drugTest bit =null,
@liftMax numeric(18,2) =null,
@canStand bit =null,
@canSit bit =null,
@hasDL bit =null,
@hasCDL bit =null,
@serveInArmy bit =null,
@isActivePostIPE bit =null,
@Where nvarchar(Max) =null
AS
Declare @SqlString NVARCHAR(Max) ,  @sqlHraCase Nvarchar(Max) , @maxFilter Nvarchar(Max) 

Set dateformat mdy

Set @sqlHraCase = ''

--IF(@experience > 0)
--Begin
----	SET @sectorFilter =	' Join
----						(
----							SELECT ResumeId FROM [dbo].[CV_Position]
----							group by ResumeId 
----							Having SUM(ISNULL([ExperienceYears],0)) >= ' + Cast(@experience as nvarchar(max)) + ' 
----						) AS sector
----						ON dbo.CV_BaseResume.ResumeId = sector.ResumeId '

----Set @sectorFilter = ' Outer Apply
----						(
----							SELECT top 1 ResumeId, SectorId, ExperienceYears FROM [dbo].[CV_Position]
----							where dbo.CV_BaseResume.ResumeId = ResumeId AND CV_Position.SectorId = SectorId
----							Order by ExperienceYears desc

----						) AS sector'
--END
--ELSE
--	SET @sectorFilter = ' '

--if(@zipCode > 0)
--	set @maxFilter = ' top 100 '
--else
--	set @maxFilter = ' '

Set @SqlString = N'


SELECT   distinct  dbo.CV_BaseResume.ResumeId, dbo.CV_BaseResume.HrCaseId, dbo.CV_BaseResume.FirstName, dbo.CV_BaseResume.LastName, HRACases_1.ClientNo AS HRACaseNumber, 
                         HRACases_1.Suffix, HRACases_1.LineNumber, HRACases_1.SSN, caseStatus.CaseNo AS CIN,dbo.CV_BaseResume.PhoneNumber, dbo.CV_BaseResume.HomePhone,
						 dbo.CV_BaseResume.Address, dbo.CV_BaseResume.City, dbo.CV_BaseResume.State, 
                         dbo.CV_BaseResume.ZipCode , dbo.CV_BaseResume.PhysicalResumePath,dbo.CV_BaseResume.Courses,dbo.CV_BaseResume.Certifications,
						 dbo.CV_BaseResume.[Skills], dbo.CV_BaseResume.[Languages], dbo.CV_BaseResume.ResumeTitle, dbo.CV_BaseResume.CreatedBy ,
						 dbo.CV_BaseResume.CreatedAt, dbo.CV_BaseResume.Email, ISNULL(dbo.CV_BaseResume.IsActive,0) AS IsActive,
						ISNULL(sector.ExperienceYears,0) as ExperienceYears,
						clientSite.SiteName  AS SiteName, ISNULL(HRACases_1.IsPrivilegeRequired,0) AS IsPrivilegeRequired

FROM            dbo.CV_BaseResume with(nolock) INNER JOIN
                [dbo].[Client] AS HRACases_1 with(nolock) ON dbo.CV_BaseResume.HrCaseId = HRACases_1.ClientId
				AND dbo.CV_BaseResume.CompanyId =  HRACases_1.CompanyId	Left Outer Join
				[dbo].[Case] AS caseStatus  WITH(nolock) ON HRACases_1.[ActiveCaseId] = caseStatus.CaseId LEFT OUTER JOIN
				[dbo].[Site] as clientSite WITH(nolock) on HRACases_1.SiteId = clientSite.SiteId LEFT OUTER JOIN
                dbo.ClientDetail with(nolock) ON HRACases_1.ClientId = dbo.ClientDetail.ClientId AND HRACases_1.CompanyId = dbo.ClientDetail.CompanyId LEFT OUTER JOIN
                dbo.CV_Education with(nolock) ON dbo.CV_BaseResume.ResumeId = dbo.CV_Education.ResumeId LEFT OUTER JOIN
                dbo.CV_Project with(nolock) ON dbo.CV_BaseResume.ResumeId = dbo.CV_Project.ResumeId LEFT OUTER JOIN
                dbo.CV_Position with(nolock) ON dbo.CV_BaseResume.ResumeId = dbo.CV_Position.ResumeId  
				Outer Apply
						(
							SELECT top 1 ResumeId, SectorId, SUM(ISNULL(ExperienceYears,0)) AS ExperienceYears  FROM [dbo].[CV_Position] with(nolock)
							where dbo.CV_BaseResume.ResumeId = ResumeId AND CV_Position.SectorId = SectorId
							group by ResumeId, SectorId
							Order by ExperienceYears desc

						) AS sector
WHERE
dbo.CV_BaseResume.CompanyId = ' + Cast(@companyId as nvarchar(max)) + 
' 
AND 
IsNull(dbo.CV_BaseResume.[IsDeleted],0) = 0 
AND 
( ' + '''' + Cast(@filterWithDate as nvarchar(max)) + '''' + ' = 1 OR
(
(dateadd(day,0,datediff(day,0,dbo.CV_BaseResume.CreatedAt))>= dateadd(day,0,datediff(day,0, ' + '''' + CONVERT(nvarchar(max),@frmDate,101) + '''' +'))) 
AND 
(dateadd(day,0,datediff(day,0,dbo.CV_BaseResume.CreatedAt))<= dateadd(day,0,datediff(day,0,' + '''' + CONVERT(nvarchar(max),@toDate,101) + '''' +'))) 
)
) '
 + 
' AND (' + '''' + @firstName + '''' + ' = '''' OR dbo.CV_BaseResume.FirstName like ' + '''' + '%'  + @firstName + '%' + '''' + ')'
+
' AND (' + '''' + @lastName + '''' + ' = '''' OR dbo.CV_BaseResume.LastName like ' + '''' + '%'  + @lastName + '%' + '''' + ')'
+
' AND (' + '''' + @SSN + '''' + ' = '''' OR HRACases_1.SSN = ' + '''' + @SSN + '''' + ')'
+ 
' AND (' + '' +  Cast(@readingScore as nvarchar(max)) + '' + ' = ''0'' OR ISNULL(dbo.ClientDetail.TabeReading,0) >= ' +  Cast(@readingScore as nvarchar(max)) + ')'
+ 
' AND (' + '' +  Cast(@mathScore as nvarchar(max))  + '' + ' = ''0'' OR ISNULL(dbo.ClientDetail.TabeMath,0) >= ' +  Cast(@mathScore as nvarchar(max)) + ')'
+ 
' AND ( ' + '' + Cast(@backgroundId as nvarchar(max)) + '' + ' = ''0''  OR ' + 'ISNULL(dbo.ClientDetail.BackgroundId,0) <= ' + Cast(@backgroundId as nvarchar(max)) + ')'
+
' AND ( ' + '' + Cast(@educationId as nvarchar(max)) + '' + ' =  ''0''   OR ' + 'ISNULL(dbo.CV_Education.DegreeTypeId,0) >= ' + Cast(@educationId as nvarchar(max)) + ')'
+
' AND ( ' + '' + Cast(@pcId as nvarchar(max)) + '' + ' = ''0''  OR ' + 'ISNULL(dbo.ClientDetail.ComputerLevelId,297) >= ' + Cast(@pcId as nvarchar(max)) + ')'
+
' AND ( ' + '' + Cast(@drugTest as nvarchar(max)) + '' + ' = ''0''  OR ' + 'ISNULL(dbo.ClientDetail.CanPassDrug,0) = ' + Cast(@drugTest as nvarchar(max)) + ')'
+
' AND ( ' + '' + Cast(@liftMax as nvarchar(max)) + '' + ' = ''0''  OR ' + 'ISNULL(dbo.ClientDetail.LiftMax,0) >= ' + Cast(@liftMax as nvarchar(max)) + ')'
+
' AND ( ' + '' + Cast(@canStand as nvarchar(max)) + '' + ' = ''0''  OR ' + 'ISNULL(dbo.ClientDetail.CanStandLongPeriod,0) = ' + Cast(@canStand as nvarchar(max)) + ')'
+
' AND ( ' + '' + Cast(@canSit as nvarchar(max)) + '' + ' = ''0''  OR ' + 'ISNULL(dbo.ClientDetail.CanSitLongPeriod,0) = ' + Cast(@canSit as nvarchar(max)) + ')'
+
' AND ( ' + '' + Cast(@hasDL as nvarchar(max)) + '' + ' = ''0''  OR ' + 'ISNULL(dbo.ClientDetail.HasPersonalDriverLicense,0) = ' + Cast(@hasDL as nvarchar(max)) + ')'
+
' AND ( ' + '' + Cast(@hasCDL as nvarchar(max)) + '' + ' = ''0''  OR ' + 'ISNULL(dbo.ClientDetail.HasCommercialDriverLicense,0) = ' + Cast(@hasCDL as nvarchar(max)) + ')'
+
' AND ( ' + '' + Cast(@serveInArmy as nvarchar(max)) + '' + ' = ''0''  OR ' + 'ISNULL(dbo.ClientDetail.IsServedInArmy,0) = ' + Cast(@serveInArmy as nvarchar(max)) + ')'
+
' AND ( ' + '' + Cast(@isActivePostIPE as nvarchar(max)) + '' + ' = ''0''  OR ' + ' caseStatus.StatusId <> ''c'' )'
+
' AND ( ' + '' + Cast(@experience as nvarchar(max)) + '' + ' = ''0''  OR ' + 'ISNULL(sector.ExperienceYears,0) >= ' + Cast(@experience as nvarchar(max)) + ')'
+
@Where
+
' Order by ISNULL(sector.ExperienceYears,0) desc '

execute(@sqlHraCase + @SqlString )
--print @SqlString
--AND (( (dbo.CV_Position.SectorId = 2 AND ISNULL(sector.ExperienceYears,0) >= 0)) OR ( (dbo.ClientDetail.FirstPreferSectorId = 2 AND ISNULL(sector.ExperienceYears,0) >= 0)) OR ( (dbo.ClientDetail.SecondPreferSectorId = 2 AND ISNULL(sector.ExperienceYears,0) >= 0)) OR ( (dbo.ClientDetail.ThirdPreferSectorId = 2 AND ISNULL(sector.ExperienceYears,0) >= 0)))