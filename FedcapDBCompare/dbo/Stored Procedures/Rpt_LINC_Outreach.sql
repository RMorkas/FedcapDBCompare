


CREATE proc [dbo].[Rpt_LINC_Outreach]
@companyId int,
@firstName varchar(50) =null, 
@lastName varchar(50) =null,
@SSN varchar(9) =null,
@caseNumber varchar(10) =null,
@DiscardDate bit =null,
@frmDate smalldatetime =null,
@toDate smalldatetime =null,
@DateType int= null,
@caseManagerId int =null

AS
SELECT        dbo.Client.ClientId, dbo.Client.ClientNo + '-' + dbo.Client.Suffix + '-' + dbo.Client.LineNumber AS CaseNumber, 
                         dbo.Client.CaseLastName + ', ' + dbo.Client.CaseFirstName AS ClientName, dbo.Client.PhoneNumber, dbo.Client.CellPhone,
                         dbo.Client.LINCID, 
                         dbo.Client.StreetAddress + ', ' + dbo.Client.City + ', ' + dbo.Client.State + ' ' + dbo.Client.ZipCode AS Address,
						 dbo.Client.SSN,
                         dbo.LINC_OutreachAttempt.OutreachDate, dbo.Enumes.Item AS OutreachMethod, dbo.LINC_OutreachAttempt.OutreachTime, 
                         dbo.LINC_OutreachAttempt.FedCapExtension, dbo.LINC_OutreachAttempt.OutreachDuration, Enumes_1.Item AS OutreachOutCome, 
                         CASE
							When ISNULL(dbo.LINC_OutreachAttempt.IsFollowUpScheduled,0) = 0 THEN 'NO'
							else 'YES'
						 END AS FollowUpScheduled

						 , dbo.LINC_OutreachAttempt.FollowUpDate, 
						 CASE 
							When ISNULL(dbo.LINC_OutreachAttempt.IsCustomerAttended,0) = 0 THEN 'NO'
							else 'YES'
						 END AS CustomerAttended,
                         dbo.LINC_OutreachAttempt.OutreachComment,dbo.Client.ReferralDate ,dbo.LINC_OutreachAttempt.CreatedAt, DATEADD(wk,DATEDIFF(wk,0,dbo.Client.ReferralDate),4) [WeekEndOfReferral],
						 DATEADD(wk,DATEDIFF(wk,0,dbo.LINC_OutreachAttempt.CreatedAt),4) [WeekEndOfCreateAt], dbo.LINC_OutreachAttempt.CreatedBy,
						 dbo.[User].FirstName + ' ' + dbo.[User].LastName AS CaseManager,
						 [dbo].[LINC_GetOutreachIndex](dbo.LINC_OutreachAttempt.ClientId, dbo.LINC_OutreachAttempt.OutreachDate) AS OutreachIndex
FROM            dbo.Client with(nolock) INNER JOIN
                         dbo.LINC_OutreachAttempt with(nolock) ON dbo.Client.ClientId = dbo.LINC_OutreachAttempt.ClientId INNER JOIN
                         dbo.Enumes ON dbo.LINC_OutreachAttempt.OutreachMethodId = dbo.Enumes.EnumId INNER JOIN
                         dbo.Enumes AS Enumes_1 ON dbo.LINC_OutreachAttempt.OutreachOutComeId = Enumes_1.EnumId INNER JOIN
                         dbo.LINC_ClientSubInfo with(nolock) ON dbo.Client.ClientId = dbo.LINC_ClientSubInfo.ClientId LEFT OUTER JOIN
                         dbo.[User] ON dbo.LINC_ClientSubInfo.CaseManagerID = dbo.[User].UserID
WHERE        
(dbo.Client.CompanyId = @companyId)
AND
(Isnull(dbo.Client.IsDeleted,0) = 0)
AND
(Isnull(dbo.Client.IsActive,0) = 1)
AND
(ISNULL(LINC_ClientSubInfo.LastUpdate,0) = 1)
AND
(@firstName IS NULL OR dbo.Client.CaseFirstName Like '%' + @firstName + '%')
AND
(@lastName IS NULL OR dbo.Client.CaseLastName Like '%' + @lastName + '%')
AND
(@SSN IS NULL OR dbo.Client.SSN Like '%' + @SSN + '%')
AND
(@caseNumber IS NULL OR dbo.Client.ClientNo Like '%' + @caseNumber + '%')
AND
(@caseManagerId IS NULL OR dbo.LINC_ClientSubInfo.CaseManagerID = @caseManagerId)
AND
(@DiscardDate IS NULL OR

(@DateType = 1 AND
(
(dateadd(day,0,datediff(day,0, dbo.LINC_OutreachAttempt.CreatedAt))>= dateadd(day,0,datediff(day,0, @frmDate))) 
AND 
(dateadd(day,0,datediff(day,0, dbo.LINC_OutreachAttempt.CreatedAt))<= dateadd(day,0,datediff(day,0,@toDate)))
))
OR
(@DateType = 0 AND
(
(dateadd(day,0,datediff(day,0, dbo.Client.ReferralDate))>= dateadd(day,0,datediff(day,0, @frmDate))) 
AND 
(dateadd(day,0,datediff(day,0, dbo.Client.ReferralDate))<= dateadd(day,0,datediff(day,0,@toDate)))
))
OR
(@DateType = 2 AND
(
(dateadd(day,0,datediff(day,0, dbo.LINC_OutreachAttempt.OutreachDate))>= dateadd(day,0,datediff(day,0, @frmDate))) 
AND 
(dateadd(day,0,datediff(day,0, dbo.LINC_OutreachAttempt.OutreachDate))<= dateadd(day,0,datediff(day,0,@toDate)))
))

)
--AND
--(@DiscardDate IS NULL OR
--)
--AND
--(@DiscardDate IS NULL OR
--)
Order By dbo.Client.LINCID