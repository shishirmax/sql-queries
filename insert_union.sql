INSERT INTO <schema_name>.<Table_Name>
(
<Table_Column1>,
<Table_Column2>,
<Table_Column3>,
<Table_Column>,
DateColumn)
SELECT <Table_Column1>,<Table_Column2>,<Table_Column3>,1,getdate() from
(
SELECT 
<Table_Column1>,<Table_Column2> As <Table_Alias>,1 As <Table_Alias>
from <schema_name>.<Table_Name>
UNION
select
<Table_Column1>,<Table_Column2> As <Table_Alias>,2 As <Table_Alias>
from <schema_name>.<Table_Name>
) X