select * from temp

CREATE TABLE Temp2
(
 value varchar(3),
 documentation varchar(100)
);

declare @xml XML
SELECT @xml = myXML from temp;

select @xml;
WITH XMLNAMESPACES ('http://www.w3.org/2001/XMLSchema' as xsd)
SELECT 
	  node.value('@value', 'nvarchar(32)')
	, node.value('(./annotation/documentation/text())[1]','varchar(50)') as Documentation
 --,doc.nod.value('@documentation', 'varchar(100)')
FROM 
    @xml.nodes('/xsd:schema/xsd:simpleType[@name="county"]/xsd:restriction/xsd:enumeration') AS enum(node)
 --CROSS APPLY node.nodes('/xsd:annotation/xsd:documentation/xsd:annotation/xsd:documentation') doc(nod)








DECLARE @xml xml
SET @xml = 
'<GespeicherteDaten>
<strategieWuerfelFelder Type="strategieWuerfelFelder">
    <Felder X="3" Y="3" Z="3">
        <Feld X="1" Y="1" Z="1">
            <strategieWuerfelFeld Type="strategieWuerfelFeld">
                <Name>Name</Name>
                <Beschreibung>Test</Beschreibung>
            </strategieWuerfelFeld>
        </Feld>
        <Feld X="1" Y="1" Z="2">
            <strategieWuerfelFeld Type="strategieWuerfelFeld">
                <Name>Name2</Name>
                <Beschreibung>Test2</Beschreibung>
            </strategieWuerfelFeld>
        </Feld>
    </Felder>
</strategieWuerfelFelder></GespeicherteDaten>'

SELECT 
    b.value('@X', 'int') as X
  , b.value('@Y', 'int') as Y
  , b.value('@Z', 'int') as Z
  , b.value('(./strategieWuerfelFeld/Name/text())[1]','Varchar(50)') as [Name]
  , b.value('../@X','int') as Felder_X
  , b.value('../@Y','int') as Felder_Y
  , b.value('../@Z','int') as Felder_Z  
FROM @xml.nodes('/GespeicherteDaten/strategieWuerfelFelder/Felder/Feld') as a(b) 


DECLARE @xml xml
SET @xml = 
'
<s:schema xmlns:c="http://schemas.ecrv.mdor.state.mn.us/mnCounties" xmlns:s="http://www.w3.org/2001/XMLSchema" targetNamespace="http://schemas.ecrv.mdor.state.mn.us/mnCounties" elementFormDefault="qualified">
  <s:simpleType name="county">
    <s:annotation>
      <s:documentation>
				Represents the counties in Minnesota
	  </s:documentation>
    </s:annotation>
    <s:restriction base="s:string">
	<s:enumeration value="01">
        <s:annotation>
          <s:documentation>Aitkin</s:documentation>
        </s:annotation>
      </s:enumeration>
	  <s:enumeration value="02">
        <s:annotation>
          <s:documentation>Anoka</s:documentation>
        </s:annotation>
      </s:enumeration>
	</s:restriction>
  </s:simpleType>
</s:schema>
'
declare @xml XML
SELECT @xml = myXML from temp;

select @xml;
WITH XMLNAMESPACES ('http://www.w3.org/2001/XMLSchema' as xsd)
SELECT
	node.value('@value','int') as [Value]
	,node.value('(./xsd:annotation/xsd:documentation/text())[1]','varchar(50)') as Documentation
FROM @xml.nodes('/xsd:schema/xsd:simpleType/xsd:restriction/xsd:enumeration') AS enum(node)