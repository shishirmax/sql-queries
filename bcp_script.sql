**Create Table before importing data using BCP Script**
CREATE TABLE websitedata(ListingId NVARCHAR(MAX),CreatedDate NVARCHAR(MAX),Rating NVARCHAR(MAX),Type NVARCHAR(MAX),WebsiteUserId NVARCHAR(MAX),LastName NVARCHAR(MAX),FirstName NVARCHAR(MAX),Email NVARCHAR(MAX),PhoneNumber NVARCHAR(MAX))


**BCP Script**

bcp dbo.<tablename> in <file location in local folder> -S <server_name> -d <database_name> -U <username> -P <password> -a 16384 -b 20000 -q -c -t"||"

bcp dbo.<tablename> in <file location in local folder> -S tcp:<server_name> -d <database_name> -U <servername>.<username> -P <password> -a 16384 -b 20000 -q -c -t","
