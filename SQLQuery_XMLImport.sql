create table tblXMLData(
id int identity,
XMLData xml,
loadedDate datetime)

insert into tblXMLData(XMLData,loadedDate)
select CONVERT(xml,BulkColumn) As BulkColumn, GETDATE()
from openrowset(BULK 'D:\Edina\DataExtract\Generated Error\04_607123.xml',SINGLE_BLOB)As x

select * from tblXMLData

--truncate table tblxmlData
drop table tblxmlData

--declare @xml as xml,@hDoc as int, @sql nvarchar(max)
--select @xml = xmldata from tblXMLData
--exec sp_xml_preparedocument @hDoc output, @xml

--exec sp_xml_removedocument @hDoc

alter procedure sp_ImportXMLFile
@filename varchar(max)
as
begin
declare @query varchar(max)
set @query = 
'insert into tblXMLData(XMLData,loadedDate,'+@filename+')
select CONVERT(xml,BulkColumn) As BulkColumn, GETDATE()
from openrowset(BULK ''D:\Edina\DataExtract\Generated Error\'+@filename+'''+,SINGLE_BLOB)As x'
execute (@query)
end

sp_ImportXMLFile '01_605836.xml'


declare @XMLDoc XML
declare @XMLDocId int
set @XMLDoc = (select XMLData from tblXMLData where id = 1)

exec sys.sp_xml_preparedocument @XMLDocId output, @XMLDoc

select * from openxml(@XMLDocId,'/us.mn.state.mdor.ecrv.extract.form.EcrvForm/') ox;