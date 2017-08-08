CREATE view [dbo].[vi_OFI_Interface_ChangeData]
as
SELECT distinct top 10000

	 clientno as Client_Identifier
	 ,case Sanction_Complied_Ind when '0' then '' when 1 then 'Y' else Sanction_Complied_Ind end as ASPIRE_Sanction_Complied_Ind
	 , CASE CONVERT(VARCHAR(20), Sanction_complied_Dt,101) WHEN '01/01/1900' THEN '' ELSE CONVERT(VARCHAR(20), Sanction_complied_Dt,101) END  as ASPIRE_Sanction_Complied_Dt,
	 '' as ASPIRE_Sanction_Expunged
	 --for now as per Martin we are keeping all Sanction fields blank
	 -- case [Sanction_complied_ind] when 0 then  'N' else 'Y' end as Sanction_Complied_Ind
	     -- ,case cast([Sanction_complied_Dt] as varchar(50)) when 'Jan  1 1900 12:00AM' then '' else  cast([Sanction_complied_Dt] as varchar(50)) end as [Sanction_complied_Dt] ,

		   --'12/08/2016' as Sanction_Inappropriate_Dt
      ,CASE CONVERT(VARCHAR(20), changedate,101) WHEN '01/01/1900' THEN '' ELSE CONVERT(VARCHAR(20), changedate,101) END as ASPIRE_ChangeNote_Date
	  ,'' + replace(replace(isnull(note,''),char(13), ' '),char(10),' ')  +  '' as ASPIRE_Change_NOTES, [OFI office] as [Referring OFI Office], Imaging_note 

  FROM [dbo].[OFI_Interface_changedata_Audit] where datediff(d,[dateadded], getdate()) = 0 and isnull([note],'') <> ''
  and clientno not like '%test%' order by clientno


