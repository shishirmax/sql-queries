select * from sys.tables

select * from tblEmailResults
sp_help tblEmailResults
select max(EmailResultsId) from tblEmailResults

select * from tblWebsiteData
sp_help tblWebsiteData
select max(WebsiteDataId) from tblWebsiteData

select * from tblSales
sp_help tblSales
select max(SalesId) from tblSales

select * from tblDynamicsCRM_POC
select * from tblPropertyForm

select * from xmlimport
select * from xmltab
select * from xtab

sp_helptext sp_xml_preparedocument 

select * from tblHeaderForm
select * from tblbuyersForm
select * from tblSellersForm
select * from tblPropertyForm
select * from tblSalesAgreementForm
select * from tblSupplementaryForm


sp_helptext fn_diagramobjects

select convert(date,getdate(),101)
exec dbo.sp_MSgetdbversion