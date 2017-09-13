CREATE  view [dbo].[vi_OFI_Interface_extension_WebService]
as
SELECT 
      top 100 percent 
      [ExtensionRequestid] as Unique_ID
	  ,clientno as Client_ID
      ,[TANF_EXTENSION_TYPE_CD]
	  ,TANF_EXTENSION_TYPE_CD_Description
      ,format([Proposed_Start], 'yyyy-MM-dd')  as PROPOSED_START_DT
      ,format([Proposed_end],'yyyy-MM-dd') as PROPOSED_END_DT
      ,replace(replace(isnull([Reason_text],''),char(13),' '),char(10),' ') as [Reason_text] 
      ,format([EXTENSION_REQUEST_DT],'yyyy-MM-dd') as [EXTENSION_REQUEST_DT]
      ,[FEDCAP_APPROVE_DENY_IND]
      ,[Verification_IND]
      ,[Re-consideration_IND] as [ReConsideration_IND]
      ,isnull([OFI_Office],'') as [OFI_Office]
	  ,isnull(staff_name,'') as [BTC Staff Member Name]
	  ,isnull([dbo].[ufn_FormatPhone_Digits_only](staff_phone),'') as [BTC Staff Member Phone], 
	  case isnull(Imaging_note,'')  when '' then 'N'  else 'Y' end as Verified_Doc_Flag 

  FROM [dbo].[OFI_Interface_Extension_Audit]  where datediff(d,getdate(),dateadded) < 3
    and clientno not like '%test%'
 order by ExtensionRequestid