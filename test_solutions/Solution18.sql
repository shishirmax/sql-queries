CREATE TABLE tblURL
(
	URL VARCHAR(100)
)

INSERT INTO tblURL
VALUES
('www.amazon.com')
,('www.amazon.ca')
,('www.amazon.uk')
,('www.amazon.in')SELECT URL,CHARINDEX('.',URL,5),LEN(URL),SUBSTRING(URL,CHARINDEX('.',URL,5),LEN(URL)) FROM tblURLCREATE TABLE tblCountry(	Suffix VARCHAR(100)	,Country VARCHAR(100))INSERT INTO tblCountryVALUES('.com','United States')
,('.uk','United Kingdom')
,('.in','India')
,('.ca','Canada')

--Solution
SELECT A.URL, B.Country
FROM tblURL A
JOIN tblCountry B
ON PARSENAME(A.URL,1) = REPLACE(B.Suffix,'.','')

SELECT A.URL, B.Country
FROM tblURL A
JOIN tblCountry B
ON SUBSTRING(A.URL,CHARINDEX('.',A.URL,5),LEN(A.URL)) = B.Suffix




