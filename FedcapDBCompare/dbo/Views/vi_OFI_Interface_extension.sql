CREATE view [dbo].[vi_OFI_Interface_extension]
as
SELECT 
      top 100 percent 
      [ClientNo] as Client_ID
      ,[TANF_EXTENSION_TYPE_CD]
	  ,TANF_EXTENSION_TYPE_CD_Description
      ,convert(varchar(50), [Proposed_Start], 101)  as PROPOSED_START_DT
      ,convert(varchar(50), [Proposed_end],101) as PROPOSED_END_DT
      ,isnull([Reason_text],'') as [Reason_text]
      ,convert(varchar(50),[EXTENSION_REQUEST_DT],101) as [EXTENSION_REQUEST_DT]
      ,[FEDCAP_APPROVE_DENY_IND]
      ,[Verification_IND]
      ,[Re-consideration_IND] as [ReConsideration_IND]
      ,isnull([OFI_Office],'') as [OFI_Office]
	  ,isnull(staff_name,'') as [BTC Staff Member Name]
	  ,isnull(staff_phone,'') as [BTC Staff Member Phone], Imaging_note

  FROM [dbo].[OFI_Interface_Extension_Audit]  where datediff(d,getdate(),dateadded) = 0 
    and clientno not like '%test%'
 order by client_id
