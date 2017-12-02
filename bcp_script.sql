CREATE TABLE websitedata(ListingId NVARCHAR(MAX),CreatedDate NVARCHAR(MAX),Rating NVARCHAR(MAX),Type NVARCHAR(MAX),WebsiteUserId NVARCHAR(MAX),LastName NVARCHAR(MAX),FirstName NVARCHAR(MAX),Email NVARCHAR(MAX),PhoneNumber NVARCHAR(MAX))

bcp dbo.websitedata in D:\EdinaRealityWorbixAnalytics\DataExtract\FTPFiles\Files_18092017\website-data.txt -S contata.database.windows.net -d Edina -U contata.admin -P C@ntata123 -a 16384 -b 20000 -q -c -t"||"

bcp dbo.tblHomeSpotter in D:\Edina\HomeSpotterFeed\29Nov17\edina_contata_sessions.csv -S tcp:contata.database.windows.net -d Edina_qa -U contata.admin@contata -P C@ntata123 -a 16384 -b 20000 -q -c -t","