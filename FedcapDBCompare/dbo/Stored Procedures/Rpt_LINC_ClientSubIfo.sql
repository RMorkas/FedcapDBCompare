

CREATE proc [dbo].[Rpt_LINC_ClientSubIfo]
@companyId int,
@firstName varchar(50) =null, 
@lastName varchar(50) =null,
@SSN varchar(9) =null,
@caseNumber varchar(10) =null,
@DiscardDate bit =null,
@frmDate smalldatetime =null,
@toDate smalldatetime =null,
@DateAsOf smalldatetime = null,
@caseManagerId int =null
AS
SELECT        dbo.Client.ClientId, dbo.Client.ClientNo + '-' + dbo.Client.Suffix + '-' + dbo.Client.LineNumber AS CaseNumber, 
                         dbo.Client.CaseLastName + ', ' + dbo.Client.CaseFirstName AS ClientName, dbo.Client.PhoneNumber, dbo.Client.CellPhone, dbo.Client.LINCID, 
                         dbo.Client.StreetAddress + ', ' + dbo.Client.City + ', ' + dbo.Client.State + ' ' + dbo.Client.ZipCode AS Address, dbo.Client.SSN, 
						 CASE 
							WHEN SubInfo.IsRentalArrears = 1 THEN 'Yes'
							WHEN SubInfo.IsRentalArrears = 0 THEN 'No'
							Else ''
						 END AS RentalArrears,
                         CASE 
							WHEN SubInfo.IsRentBreakDown = 1 THEN 'Yes'
							WHEN SubInfo.IsRentBreakDown = 0 THEN 'No'
							ELSE ''
						 END AS RentBreakDown,
						 SubInfo.ArrearsAmount, 
						 CASE
							WHEN SubInfo.IsRentalArrearsPaid = 1 THEN 'Yes'
							WHEN SubInfo.IsRentalArrearsPaid = 0 THEN 'No'
							ELSE ''
						 END AS RentalArrearsPaid, SubInfo.PaymentDate, SubInfo.PaymentAmount, 
						 CASE
							WHEN SubInfo.IsReferedToHomeBase = 1 THEN 'Yes'
							WHEN SubInfo.IsReferedToHomeBase = 0 THEN 'No'
							ELSE ''
						 END AS ReferedToHomeBase, 
                         SubInfo.HomeBaseDate, 
						 CASE
							WHEN SubInfo.IsB2WRetention = 1 THEN 'Yes'
							WHEN SubInfo.IsB2WRetention = 0 THEN 'No'
							ELSE ''
						 END AS B2WRetention,
						 CASE
							WHEN SubInfo.IsEmploymentWorks = 1 THEN 'Yes'
							WHEN SubInfo.IsEmploymentWorks = 0 THEN 'No'
							ELSE ''
						 END AS EmploymentWorks, SubInfo.LINCRenewalDate, 
						 CASE
							WHEN SubInfo.IsLINCRenewalSubmit = 1 THEN 'Yes'
							WHEN SubInfo.IsLINCRenewalSubmit = 0 THEN 'No'
							ELSE ''
						 END AS RenewalSubmit, SubInfo.LINCSubmittedDate, 
						 CASE
							WHEN SubInfo.LINCVoucherRenewed = 1 THEN 'Yes'
							WHEN SubInfo.LINCVoucherRenewed = 0 THEN 'No'
							ELSE ''
						 END AS VoucherRenewed, SubInfo.LINCVoucherDate, 
						 CASE
							WHEN SubInfo.CustomerAppearedInCourt = 1 THEN 'Yes'
							WHEN SubInfo.CustomerAppearedInCourt = 0 THEN 'No'
							ELSE ''
						 END AS AppearedInCourt, SubInfo.CourtDate, 
						 --CASE
							--WHEN SubInfo.IsNeedJob = 1 THEN 'Yes'
							--WHEN SubInfo.IsNeedJob = 1 THEN 'No'
							--ELSE ''
						 --END 
						 '' AS NeedJob, 
						 --CASE
							--WHEN SubInfo.IsReferredToAccManager = 1 THEN 'Yes'
							--WHEN SubInfo.IsReferredToAccManager = 0 THEN 'No'
							--ELSE ''
						 --END 
						 '' AS ReferredAccManager, --SubInfo.ReferralDateAM
						 '' AS ReferralDateAM, 
                         CASE
							WHEN SubInfo.IsReferredToHousing = 1 THEN 'Yes'
							WHEN SubInfo.IsReferredToHousing = 0 THEN 'No'
							Else ''
						 END AS ReferredHousing, SubInfo.HousingReferralDate,
                         ISNULL(SubInfo.LastUpdate,0) AS LastUpdate,
						 ISNULL(SubInfo.UpdatedAt,SubInfo.CreatedAt) AS UpdatedAt,dbo.Client.ReferralDate,
						 SubInfo.CaseManager, [dbo].[LINC_isContactMadeWithClient](dbo.Client.ClientId, @DateAsOf) AS MadeContact,
						 dbo.LINC_checkOutreachRequirement(dbo.Client.ClientId, @DateAsOf) AS MetOutreachRequirement,
						 ISNULL(SubInfo.UpdatedBy,SubInfo.CreatedBy) AS UpdatedBy

FROM            dbo.Client with(nolock) Cross apply
						 (SELECT  top 1 SubInfo.*,dbo.[User].FirstName + ' ' + dbo.[User].LastName as CaseManager FROm dbo.LINC_ClientSubInfo AS SubInfo left outer join
							dbo.[User] on dbo.[User].UserID = SubInfo.CaseManagerID
							
							WHERE ISNULL(UpdatedAt, CreatedAt) <= @DateAsOf AND  dbo.Client.ClientId = ClientId
							Order By UpdatedAt desc) AS SubInfo

WHERE        
(dbo.Client.CompanyId = @companyId)
AND
(Isnull(dbo.Client.IsDeleted,0) = 0)
AND
(Isnull(dbo.Client.IsActive,0) = 1)
AND
(@firstName IS NULL OR dbo.Client.CaseFirstName Like '%' + @firstName + '%')
AND
(@lastName IS NULL OR dbo.Client.CaseLastName Like '%' + @lastName + '%')
AND
(@SSN IS NULL OR dbo.Client.SSN Like '%' + @SSN + '%')
AND
(@caseNumber IS NULL OR dbo.Client.ClientNo Like '%' + @caseNumber + '%')
AND
(@caseManagerId IS NULL OR SubInfo.CaseManagerID = @caseManagerId)
AND
(@DiscardDate IS NULL OR
(
(dateadd(day,0,datediff(day,0, dbo.Client.ReferralDate))>= dateadd(day,0,datediff(day,0, @frmDate))) 
AND 
(dateadd(day,0,datediff(day,0, dbo.Client.ReferralDate))<= dateadd(day,0,datediff(day,0,@toDate)))
))
Order By dbo.Client.LINCID