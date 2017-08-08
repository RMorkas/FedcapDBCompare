CREATE view [dbo].[vi_OFI_Interface_Exemption]
as
SELECT top 100 percent 
	 clientno  Client_ID
	 ,[Name] 
	 ,Exemption_Type
	 ,convert(varchar(20), Start_dt, 101) as Start_dt, convert(varchar(20),End_dt,101) as End_dt,  [BTC Staff Member Name],[BTC Staff Member Phone]
	 ,[OFI Office] as [Referring OFI Office]
	 ,CFD_Name, Imaging_note
  FROM [dbo].[OFI_interface_exemption_audit] where datediff(d,[dateadded], getdate()) = 0 
  and clientno not like '%test%'
  order by clientno
