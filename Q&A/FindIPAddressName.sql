CREATE TABLE Routing
(
	NetworkName VARCHAR(100)
	,SourceIp VARCHAR(100)
	,DestinationIp VARCHAR(100)
)

INSERT INTO Routing
VALUES
('ABC','10.2.45.65','10.1.56.4')
,('LMN','192.45.56.125','10.1.45.4')
,('PQR','10.1.56.4','10.2.45.65')
,('GHI','192.45.56.125','10.2.45.65')
,('XYZ','178.45.1.16','10.1.45.4')

CREATE TABLE IpName
(
	IP VARCHAR(100)
	,Name VARCHAR(100)
)

INSERT INTO IpName
VALUES
('10.2.45.65','A')
,('192.45.56.125','B')
,('10.1.56.4','C')
,('178.45.1.16','D')
,('10.1.45.4','E')

SELECT * FROM Routing
SELECT * FROM IpName

SELECT A.NetworkName,A.SourceIp,B.Name AS SourceIpNAme,B.IP,A.DestinationIp,C.Name As DestinationIpName,C.IP
FROM Routing A
JOIN IpName B
ON A.SourceIp = B.IP
JOIN IpName C
ON A.DestinationIp = C.IP

SELECT A.NetworkName,A.DestinationIp,C.Name As DestinationIpName,C.IP
FROM Routing A
JOIN IpName C
ON A.DestinationIp = B.IP
