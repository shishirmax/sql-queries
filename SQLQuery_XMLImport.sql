--create table tblXMLData(
--id int identity,
--XMLData xml,
--loadedDate datetime)

insert into tblXMLData(XMLData,loadedDate)
select CONVERT(xml,BulkColumn) As BulkColumn, GETDATE()
from openrowset(BULK 'D:\Edina\DataExtract\Generated Error\13_607265.xml',SINGLE_BLOB)As x

select * from tblXMLData

select ASCII('‘')
select ASCII('¼')
select ASCII('°')
select ASCII('’')
select ASCII('”')
--truncate table tblxmlData
--drop table tblxmlData

--declare @xml as xml,@hDoc as int, @sql nvarchar(max)
--select @xml = xmldata from tblXMLData
--exec sp_xml_preparedocument @hDoc output, @xml

--exec sp_xml_removedocument @hDoc


--create table tblXMLDataWithFileName(
--id int identity(1,1),
--XMLData xml,
--loadedDate datetime,
--XMLFilename varchar(max))

--select * from tblXMLDataWithFileName

--alter procedure sp_ImportXMLFileWithFilename
--@filename varchar(max)
--as
--begin
--declare @query varchar(max)
--set @query = 
--N'insert into tblXMLDataWithFileName(XMLData,loadedDate,'''+@filename+''')
--select CONVERT(xml,BulkColumn) As BulkColumn, GETDATE()
--from openrowset(BULK ''D:\Edina\DataExtract\Generated Error\' + @filename + ''',SINGLE_BLOB)As x'
--execute (@query)
--end

--sp_ImportXMLFileWithFilename 'testXml.xml'


--declare @XMLDoc XML
--declare @XMLDocId int
--set @XMLDoc = (select XMLData from tblXMLData where id = 14)

--exec sys.sp_xml_preparedocument @XMLDocId output, @XMLDoc

--select * from openxml(@XMLDocId,'/us.mn.state.mdor.ecrv.extract.form.EcrvForm/') ox;