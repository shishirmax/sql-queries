create procedure SP_GenerateReport
@startDate				datetime,
@endDate				datetime
As
Begin

select
IBH.ibh_id,
IBD.ibd_hdrid,
IBH.ibh_payee,
FA.fa_code,
IBH.ibh_creationdate,
IBD.ibd_datedue as DueDate,
IBH.ibh_printpayon as PayOnDate,
IBH.ibh_checkno as CheckNo,
IBD.ibd_clientNo as ClientNo,
IBD.ibd_matterno as MatterNo,
CAST(IBD.ibd_clientNo as varchar(50)) +'.'+ CAST(IBD.ibd_matterno as varchar(50)) as ClientMatter,
IBH.ibh_payee as PayeeCode,
FA.fa_name as PayeeName,
IBH.ibh_printdatetime as PrintDate,
IBD.ibd_usAmount as Amount,
IBD.ibd_fee as PTFMFee,
IBH.ibh_firmcode as FirmCode
from invbriefhdr IBH
join invbriefdtl IBD on IBH.ibh_id = IBD.ibd_hdrid
join fgnassoc FA on IBH.ibh_payee = FA.fa_code
where 
--month(IBH.ibh_creationdate) = 01 and year(IBH.ibh_creationdate) = 2017
--month(IBH.ibh_creationdate) between 01 and 03 and year(IBH.ibh_creationdate) = 2017
month(IBH.ibh_creationdate) between month(@startDate) and month(@endDate) and year(IBH.ibh_creationdate) = 2017
and IBH.ibh_firmcode = 'WGSB' and FA.fa_firmcode = 'WGSB'
order by IBH.ibh_creationdate

End



--CAST(CONVERT(VARCHAR(20), ibh_creationDate, 101) AS DATETIME)  between convert(DATETIME, ''' + @startDate + ''', 101) AND  convert(DATETIME, ''' + @endDate + ''', 101)