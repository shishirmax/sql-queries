# Exporting data using bcp

SQL Server has a number of command prompt utilities that assist with database operations. All of these can be invoked from PowerShell using the Invoke-Expression cmdlet.

bcp is a well-known utility that allows for the fast import and export of data. The data transfer can be fairly straightforward; for example, if taking all the records from a table to a CSV file. It could also be more complex, which will require supplying a format file to specify the structure of the data. If we wanted to export all the records from the Album table in the Chinook database using a trusted connection with character data type, the bcp command will look like the following:

```sql
bcp Chinook.dbo.Album out C:\Temp\results.txt -T -c
```

To do this within PowerShell, we can compose the same command expression and pass it to Invoke-Expression:

```powershell
$database = "Chinook"
$schema = "dbo"
$table = "Album"
$filename = "C:\Temp\results.txt"

$bcp = "bcp $($database).$($schema).$($table) out $filename -T -c"
Invoke-Expression $bcp
```