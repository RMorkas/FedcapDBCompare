CREATE view [dbo].[vi_OFI_Interface_SuportService]
as
 
	 SELECT [clientno] as [client_ID]
      ,[OFI office]
      ,[Service_Type_Code]
      ,[Item_Service_Type]
      ,[Item_CAP_amt]
      ,[Frequency]
      ,[Amount]
      ,[Child_Being_Served]
      ,[Hours]
      ,[Start_Dt]
      ,[END_Dt]
      ,[Estimate]
      ,'' + replace(Replace([Description],CHAR(10),' ') , char(13),' ') + '' as [Description]
      ,[Work_Site]
      ,[Provider_Type]
      ,[Provider_Vendor_Name]
      ,[Provider_Vendor_Tax_ID_Number]
      ,[Street1]
      ,[Street2]
      ,[City]
      ,[State]
      ,[Zip]
      ,[Payment_To_Vendor_Flag]
      ,[Requesting Case Manager]
      ,[FCAStart_Dt]
      ,[FCAEnd_Dt], Receipt_Invoice

  FROM [dbo].[OFI_Interface_SupportService_Audit] with (Nolock)  where datediff(d,dateadded, getdate()) = 0
    and clientno not like '%test%' and datesubmitted is null 