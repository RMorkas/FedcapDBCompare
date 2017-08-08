CREATE PROC [dbo].[UpdateSentToFedcapAcademy] @companyId INT
AS
     UPDATE dbo.FedcapAcademy
       SET
           IsSentToFedcapAcademy = 1
     WHERE EnrollmentId in
     (
         SELECT EnrollmentId
         FROM dbo.FedcapAcademy acad WITH (NOLOCK)
         WHERE acad.CompanyId = @companyId
               AND ISNULL(acad.IsDeleted, 0) = 0
               AND ISNULL(acad.IsSentToFedcapAcademy, 0) = 0
               AND ((DATEADD(day, 0, DATEDIFF(day, 0, acad.StartDate)) <= DATEADD(day, 0, DATEDIFF(day, 0, GETDATE())))
                    AND (DATEADD(day, 0, DATEDIFF(day, 0, acad.EndDate)) >= DATEADD(day, 0, DATEDIFF(day, 0, GETDATE()))))
     );