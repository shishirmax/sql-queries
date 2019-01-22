--https://stackoverflow.com/questions/54302106/need-to-get-multiple-value-from-a-table-in-the-left-join#54302106
CREATE TABLE tblFolders 
(
	ID INT,
	FolderName VARCHAR(100),
	CreatedBy INT,
	ModifiedBy INT,
)

INSERT INTO tblFolders
VALUES
(1,'SIMPLE',5,6)
,(2,'SIMPLE1',8,1)

CREATE TABLE tblUsersMapping
(
	ID INT,
	Version1UserID  INT,
	Version2UserID     INT,
)

INSERT INTO tblUsersMapping
VALUES
(1,1,500)
,(2,2,465)
,(3,3,12)
,(4,4,85)
,(5,5,321)
,(6,6,21)
,(7,7,44)
,(8,8,884)

SELECT * FROM tblFolders
SELECT * FROM tblUsersMapping

SELECT 
	A.ID
	,A.FolderName
	,B.Version2UserID
	,C.Version2UserID
FROM tblFolders A
JOIN tblUsersMapping B
on A.CreatedBy = B.Version1UserID
JOIN tblUsersMapping C
on A.ModifiedBy = C.Version1UserID


SELECT 
	tblFolders.ID
	,tblFolders.FolderName
	--,(SELECT Version2UserID FROM tblUsersMapping WHERE Version1UserID IN (SELECT CreatedBy FROM tblFolders))
	--,(SELECT Version2UserID FROM tblUsersMapping WHERE Version1UserID IN (SELECT ModifiedBy FROM tblFolders))
FROM tblFolders



SELECT id, 
foldername, 
(SELECT version2userid from tblUsersMapping where Version1UserID=tblfolders.CreatedBy) AS CreatedBy,
(SELECT version2userid from tblUsersMapping where Version1UserID=tblfolders.ModifiedBy) AS ModifiedBy
FROM   tblfolders