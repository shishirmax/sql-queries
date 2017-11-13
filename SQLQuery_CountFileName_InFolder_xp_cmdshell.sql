select count(*) as tblRowCount,UPPER(DATENAME(M,EOMONTH(sale_date)))+' '+CONVERT(VARCHAR(50),DATEPART(YEAR,EOMONTH(sale_date))) AS Monthly from tblSales_24102017
group by EOMONTH(sale_date)
order by EOMONTH(sale_date)

--UPPER(DATENAME(M,EOMONTH(ResultDate)))+' '+CONVERT(VARCHAR(50),DATEPART(YEAR,EOMONTH(ResultDate)))

DECLARE @path varchar(500)
SET @path = 'C:\MyFolder\MyFile.txt'
DECLARE @result INT
EXEC master.dbo.xp_fileexist @path, @result OUTPUT
SELECT @result

DECLARE @cmd nvarchar(500)
SET @cmd = 'dir C:\MyFolder\'
CREATE TABLE #DirOutput(
     files varchar(500))

INSERT INTO #DirOutput
EXEC master.dbo.xp_cmdshell @cmd

SELECT *
FROM #DirOutput


declare @files table (ID int IDENTITY, FileName varchar(100))
insert into @files execute xp_cmdshell 'dir C:\MyFolder\ /b'
select * from @files where FileName IS NOT NULL

