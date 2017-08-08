CREATE Proc [dbo].[UpdateExemptionRequestStatus]
as

update [dbo].[ExemptionRequest]
set RequestStatus = 2
where ExemptionRequestId in
(
select er.ExemptionRequestId
from [dbo].[ExemptionRequest] er

outer apply
(
    select top 1 'Approved' as RequestStatus from [dbo].OFI_ExemptionHistory exemption
    where exemption.ClientId = er.ClientId and er.ReasonExemptionId = exemption.ExemptionTypeId 
    and Abs(DateDiff(dd, exemption.StartDate, er.DateFrom)) <= 45
) Exemption_approved

where er.RequestStatus = 1 and er.IsDeleted = 0 and Exemption_approved.RequestStatus is not null
)