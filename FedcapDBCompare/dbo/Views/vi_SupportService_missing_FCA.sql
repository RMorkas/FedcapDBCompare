create view vi_SupportService_missing_FCA
as
SELECT client.ClientNo, ss.StartDate,ss.EndDate, ss.CreatedAt, ServiceDescription, ss.CreatedBy
  FROM [dbo].[ClientSupportService] ss inner join client on client.clientid = ss.ClientId
  and  islocked =0 and datediff(d,'02/10/2017',ss.CreatedAt) < 0 and clientno not like '%test%'
