SELECT *  
FROM sys.xml_schema_collections

--CREATE XML SCHEMA COLLECTION BookSchema AS
--N'<xsd:schema attributeFormDefault="unqualified" elementFormDefault="qualified" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
--	<xsd:element name="catalog">
--		<xsd:complexType>
--			<xsd:sequence>
--				<xsd:element name="book">
--					<xsd:complexType>
--							<xsd:attribute type="xsd:string" name="id" use="required" />												
--							<xsd:element type="xsd:string" name="author" />
--							<xsd:element type="xsd:string" name="title" />
--							<xsd:element type="xsd:string" name="genre" />
--							<xsd:element type="xsd:float" name="price" />
--							<xsd:element type="xsd:date" name="published_date" />
--							<xsd:element type="xsd:string" name="description" />						
--					</xsd:complexType>
--				</xsd:element>
--			</xsd:sequence>
--		</xsd:complexType>
--	</xsd:element>
--</xsd:schema>'
--GO

CREATE XML SCHEMA COLLECTION BookSchema AS
'<xs:schema attributeFormDefault="unqualified" elementFormDefault="qualified" xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xs:element name="catalog">
    <xs:complexType>
      <xs:sequence>
        <xs:element name="book" maxOccurs="unbounded" minOccurs="0">
          <xs:complexType>
            <xs:sequence>
              <xs:element type="xs:string" name="author"/>
              <xs:element type="xs:string" name="title"/>
              <xs:element type="xs:string" name="genre"/>
              <xs:element type="xs:float" name="price"/>
              <xs:element type="xs:date" name="publish_date"/>
              <xs:element type="xs:string" name="description"/>
            </xs:sequence>
            <xs:attribute type="xs:string" name="id" use="optional"/>
          </xs:complexType>
        </xs:element>
      </xs:sequence>
    </xs:complexType>
  </xs:element>
</xs:schema>'

DECLARE @xml XML(BookSchema) --Schema name
SELECT @xml = '<catalog>
   <book id="bk101">
      <author>Gambardella, Matthew</author>
      <title>XML Developer''s Guide</title>
      <genre>Computer</genre>
      <price>44.95</price>
      <publish_date>2000-10-01</publish_date>
      <description>An in-depth look at creating applications
      with XML.</description>
   </book>
   </catalog>'



















--CREATE DATABASE SampleDB;  
--GO  
--USE SampleDB;  
--GO  
--CREATE XML SCHEMA COLLECTION ManuInstructionsSchemaCollection AS  
--N'<?xml version="1.0" encoding="UTF-16"?>  
--<xsd:schema targetNamespace="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelManuInstructions"   
--   xmlns          ="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelManuInstructions"   
--   elementFormDefault="qualified"   
--   attributeFormDefault="unqualified"  
--   xmlns:xsd="http://www.w3.org/2001/XMLSchema" >  

--    <xsd:complexType name="StepType" mixed="true" >  
--        <xsd:choice  minOccurs="0" maxOccurs="unbounded" >   
--            <xsd:element name="tool" type="xsd:string" />  
--            <xsd:element name="material" type="xsd:string" />  
--            <xsd:element name="blueprint" type="xsd:string" />  
--            <xsd:element name="specs" type="xsd:string" />  
--            <xsd:element name="diag" type="xsd:string" />  
--        </xsd:choice>   
--    </xsd:complexType>  

--    <xsd:element  name="root">  
--        <xsd:complexType mixed="true">  
--            <xsd:sequence>  
--                <xsd:element name="Location" minOccurs="1" maxOccurs="unbounded">  
--                    <xsd:complexType mixed="true">  
--                        <xsd:sequence>  
--                            <xsd:element name="step" type="StepType" minOccurs="1" maxOccurs="unbounded" />  
--                        </xsd:sequence>  
--                        <xsd:attribute name="LocationID" type="xsd:integer" use="required"/>  
--                        <xsd:attribute name="SetupHours" type="xsd:decimal" use="optional"/>  
--                        <xsd:attribute name="MachineHours" type="xsd:decimal" use="optional"/>  
--                        <xsd:attribute name="LaborHours" type="xsd:decimal" use="optional"/>  
--                        <xsd:attribute name="LotSize" type="xsd:decimal" use="optional"/>  
--                    </xsd:complexType>  
--                </xsd:element>  
--            </xsd:sequence>  
--        </xsd:complexType>  
--    </xsd:element>  
--</xsd:schema>' ;  
--GO  

--SELECT *  
--FROM sys.xml_schema_collections;  

--CREATE TABLE T (  
--        i int primary key,   
--        x xml (ManuInstructionsSchemaCollection));  
--GO 

--select * from T

---- Clean up  
--DROP TABLE T;  
--GO  
--DROP XML SCHEMA COLLECTION ManuInstructionsSchemaCollection;  
--Go  
--USE master;  
--GO  
--DROP DATABASE SampleDB;  


select * from sys.tables
select * from tblEmployee

--Create XSD of table in SQL Server
select top 0 * from tblEmployee for XML AUTO,XMLSCHEMA





CREATE XML SCHEMA COLLECTION XMLFileSchema AS
'<xs:schema attributeFormDefault="unqualified" elementFormDefault="qualified" xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xs:element name="us.mn.state.mdor.ecrv.extract.form.EcrvForm">
    <xs:complexType>
      <xs:sequence>
        <xs:element name="headerForm">
          <xs:complexType>
            <xs:sequence>
              <xs:element type="xs:int" name="crvNumberId"/>
              <xs:element type="xs:byte" name="countyCde"/>
            </xs:sequence>
          </xs:complexType>
        </xs:element>
        <xs:element name="buyersForm">
          <xs:complexType>
            <xs:sequence>
              <xs:element type="xs:string" name="organizations"/>
              <xs:element name="individuals">
                <xs:complexType>
                  <xs:sequence>
                    <xs:element name="us.mn.state.mdor.ecrv.extract.form.StandardBuyerSellerForm" maxOccurs="unbounded" minOccurs="0">
                      <xs:complexType>
                        <xs:sequence>
                          <xs:element type="xs:byte" name="id"/>
                          <xs:element type="xs:string" name="person"/>
                          <xs:element type="xs:string" name="firstName"/>
                          <xs:element type="xs:string" name="middleName"/>
                          <xs:element type="xs:string" name="lastName"/>
                          <xs:element type="xs:string" name="nameSuffix"/>
                          <xs:element type="xs:string" name="addressLine1"/>
                          <xs:element type="xs:string" name="addressLine2"/>
                          <xs:element type="xs:string" name="city"/>
                          <xs:element type="xs:string" name="stateOrProvince"/>
                          <xs:element type="xs:int" name="zip"/>
                          <xs:element type="xs:string" name="country"/>
                          <xs:element type="xs:string" name="email"/>
                          <xs:element type="xs:long" name="daytimePhone"/>
                          <xs:element type="xs:string" name="contactNotes"/>
                          <xs:element type="xs:string" name="foreignAddress"/>
                          <xs:element type="xs:string" name="privateIndicator"/>
                        </xs:sequence>
                      </xs:complexType>
                    </xs:element>
                  </xs:sequence>
                </xs:complexType>
              </xs:element>
            </xs:sequence>
          </xs:complexType>
        </xs:element>
        <xs:element name="sellersForm">
          <xs:complexType>
            <xs:sequence>
              <xs:element type="xs:string" name="organizations"/>
              <xs:element name="individuals">
                <xs:complexType>
                  <xs:sequence>
                    <xs:element name="us.mn.state.mdor.ecrv.extract.form.StandardBuyerSellerForm">
                      <xs:complexType>
                        <xs:sequence>
                          <xs:element type="xs:byte" name="id"/>
                          <xs:element type="xs:string" name="person"/>
                          <xs:element type="xs:string" name="firstName"/>
                          <xs:element type="xs:string" name="middleName"/>
                          <xs:element type="xs:string" name="lastName"/>
                          <xs:element type="xs:string" name="nameSuffix"/>
                          <xs:element type="xs:string" name="addressLine1"/>
                          <xs:element type="xs:string" name="addressLine2"/>
                          <xs:element type="xs:string" name="city"/>
                          <xs:element type="xs:string" name="stateOrProvince"/>
                          <xs:element type="xs:int" name="zip"/>
                          <xs:element type="xs:string" name="country"/>
                          <xs:element type="xs:string" name="email"/>
                          <xs:element type="xs:long" name="daytimePhone"/>
                          <xs:element type="xs:string" name="contactNotes"/>
                          <xs:element type="xs:string" name="foreignAddress"/>
                          <xs:element type="xs:string" name="privateIndicator"/>
                        </xs:sequence>
                      </xs:complexType>
                    </xs:element>
                  </xs:sequence>
                </xs:complexType>
              </xs:element>
            </xs:sequence>
          </xs:complexType>
        </xs:element>
        <xs:element name="propertyForm">
          <xs:complexType>
            <xs:sequence>
              <xs:element type="xs:byte" name="county"/>
              <xs:element type="xs:string" name="legalDescription"/>
              <xs:element type="xs:string" name="whatIsIncludedInSale"/>
              <xs:element type="xs:string" name="newBuildingsOnSaleYear"/>
              <xs:element type="xs:string" name="principalResidence"/>
              <xs:element type="xs:string" name="needsTimberDetails"/>
              <xs:element type="xs:string" name="needsApartmentDetails"/>
              <xs:element type="xs:string" name="needsAcreageDetails"/>
              <xs:element type="xs:string" name="displayMnPropertyAddress"/>
              <xs:element type="xs:string" name="displayParcel"/>
              <xs:element name="mnPropertyAddresses">
                <xs:complexType>
                  <xs:sequence>
                    <xs:element name="us.mn.state.mdor.ecrv.extract.form.PropertyAddressForm">
                      <xs:complexType>
                        <xs:sequence>
                          <xs:element type="xs:byte" name="id"/>
                          <xs:element type="xs:string" name="street1"/>
                          <xs:element type="xs:string" name="street2"/>
                          <xs:element type="xs:short" name="city"/>
                          <xs:element type="xs:int" name="zip"/>
                        </xs:sequence>
                      </xs:complexType>
                    </xs:element>
                  </xs:sequence>
                </xs:complexType>
              </xs:element>
              <xs:element name="plannedUses">
                <xs:complexType>
                  <xs:sequence>
                    <xs:element name="us.mn.state.mdor.ecrv.extract.form.PlannedUseForm">
                      <xs:complexType>
                        <xs:sequence>
                          <xs:element type="xs:byte" name="id"/>
                          <xs:element type="xs:string" name="tier1Cde"/>
                          <xs:element type="xs:string" name="tier2Cde"/>
                          <xs:element type="xs:string" name="primaryInd"/>
                        </xs:sequence>
                      </xs:complexType>
                    </xs:element>
                  </xs:sequence>
                </xs:complexType>
              </xs:element>
              <xs:element name="usesBeforeSale">
                <xs:complexType>
                  <xs:sequence>
                    <xs:element name="us.mn.state.mdor.ecrv.extract.form.PlannedUseForm">
                      <xs:complexType>
                        <xs:sequence>
                          <xs:element type="xs:byte" name="id"/>
                          <xs:element type="xs:string" name="tier1Cde"/>
                          <xs:element type="xs:string" name="tier2Cde"/>
                          <xs:element type="xs:string" name="primaryInd"/>
                        </xs:sequence>
                      </xs:complexType>
                    </xs:element>
                  </xs:sequence>
                </xs:complexType>
              </xs:element>
              <xs:element name="parcels">
                <xs:complexType>
                  <xs:sequence>
                    <xs:element name="us.mn.state.mdor.ecrv.extract.form.ParcelForm">
                      <xs:complexType>
                        <xs:sequence>
                          <xs:element type="xs:byte" name="id"/>
                          <xs:element type="xs:string" name="primary"/>
                          <xs:element type="xs:string" name="parcelId"/>
                        </xs:sequence>
                      </xs:complexType>
                    </xs:element>
                  </xs:sequence>
                </xs:complexType>
              </xs:element>
              <xs:element type="xs:string" name="propertyPrograms"/>
            </xs:sequence>
          </xs:complexType>
        </xs:element>
        <xs:element name="salesAgreementForm">
          <xs:complexType>
            <xs:sequence>
              <xs:element name="deedContractDate">
                <xs:complexType>
                  <xs:simpleContent>
                    <xs:extension base="xs:date">
                      <xs:attribute type="xs:string" name="class"/>
                    </xs:extension>
                  </xs:simpleContent>
                </xs:complexType>
              </xs:element>
              <xs:element type="xs:float" name="totPurchaseAmt"/>
              <xs:element type="xs:float" name="downPmtEquity"/>
              <xs:element type="xs:float" name="sellerPdPts"/>
              <xs:element type="xs:float" name="specialAssesmtAmt"/>
              <xs:element type="xs:string" name="financeType"/>
              <xs:element type="xs:string" name="personalPropertyIncludedInTotal"/>
              <xs:element type="xs:string" name="didBuyerLease"/>
              <xs:element type="xs:string" name="didSellerLease"/>
              <xs:element type="xs:byte" name="sellerLeaseMonths"/>
              <xs:element type="xs:string" name="guaranteeRentIncome"/>
              <xs:element type="xs:string" name="deedPayoff"/>
              <xs:element type="xs:string" name="buyerPartInterest"/>
              <xs:element type="xs:string" name="receivedInTrade"/>
              <xs:element type="xs:string" name="likeKindExchange"/>
              <xs:element type="xs:string" name="agreement2YrsOld"/>
              <xs:element type="xs:string" name="financeArrangements"/>
              <xs:element name="personalProperties">
                <xs:complexType>
                  <xs:sequence>
                    <xs:element name="us.mn.state.mdor.ecrv.extract.form.PersonalPropertyForm" maxOccurs="unbounded" minOccurs="0">
                      <xs:complexType>
                        <xs:sequence>
                          <xs:element type="xs:byte" name="id"/>
                          <xs:element type="xs:string" name="selected"/>
                          <xs:element type="xs:string" name="propertyDescription"/>
                          <xs:element type="xs:float" name="propertyValue"/>
                        </xs:sequence>
                      </xs:complexType>
                    </xs:element>
                  </xs:sequence>
                </xs:complexType>
              </xs:element>
            </xs:sequence>
          </xs:complexType>
        </xs:element>
        <xs:element name="supplementaryForm">
          <xs:complexType>
            <xs:sequence>
              <xs:element type="xs:string" name="relatedInd"/>
              <xs:element type="xs:string" name="taxExemptInd"/>
              <xs:element type="xs:string" name="governmentInd"/>
              <xs:element type="xs:string" name="nameChangeInd"/>
              <xs:element type="xs:string" name="legalActionInd"/>
              <xs:element type="xs:string" name="giftInd"/>
              <xs:element type="xs:string" name="buyerAppraisalInd"/>
              <xs:element type="xs:float" name="buyerAppraisalAmt"/>
              <xs:element type="xs:string" name="sellerAppraisalInd"/>
              <xs:element type="xs:byte" name="sellerAppraisalAmt"/>
              <xs:element type="xs:string" name="adjacentPropertyInd"/>
              <xs:element type="xs:string" name="nonMarketPriceInd"/>
              <xs:element type="xs:string" name="nonMarketPriceComment"/>
              <xs:element type="xs:string" name="nonListedInd"/>
              <xs:element type="xs:string" name="nonListedComment"/>
            </xs:sequence>
          </xs:complexType>
        </xs:element>
        <xs:element type="xs:string" name="submitterForm"/>
      </xs:sequence>
    </xs:complexType>
  </xs:element>
</xs:schema>'

DECLARE @xml XML(XMLFileSchema) --Schema name
SELECT @xml = '<us.mn.state.mdor.ecrv.extract.form.EcrvForm>
	<headerForm>
		<crvNumberId>590652</crvNumberId>
		<countyCde>18</countyCde>
	</headerForm>
	<buyersForm>
		<organizations/>
		<individuals>
			<us.mn.state.mdor.ecrv.extract.form.StandardBuyerSellerForm>
				<id>2</id>
				<person>true</person>
				<firstName>Linda</firstName>
				<middleName>J</middleName>
				<lastName>Lichty</lastName>
				<nameSuffix/>
				<addressLine1>15686 Heywood Court</addressLine1>
				<addressLine2/>
				<city>Apple Valley</city>
				<stateOrProvince>MN</stateOrProvince>
				<zip>55124</zip>
				<country>US</country>
				<email>linda.lichty@charter.net</email>
				<daytimePhone>6128014351</daytimePhone>
				<contactNotes/>
				<foreignAddress>false</foreignAddress>
				<privateIndicator>false</privateIndicator>
			</us.mn.state.mdor.ecrv.extract.form.StandardBuyerSellerForm>
			<us.mn.state.mdor.ecrv.extract.form.StandardBuyerSellerForm>
				<id>1</id>
				<person>true</person>
				<firstName>Scott</firstName>
				<middleName>A</middleName>
				<lastName>Lichty</lastName>
				<nameSuffix/>
				<addressLine1>15686 Heywood Court</addressLine1>
				<addressLine2/>
				<city>Apple Valley</city>
				<stateOrProvince>MN</stateOrProvince>
				<zip>55124</zip>
				<country>US</country>
				<email>linda.lichty@charter.net</email>
				<daytimePhone>6128014351</daytimePhone>
				<contactNotes/>
				<foreignAddress>false</foreignAddress>
				<privateIndicator>false</privateIndicator>
			</us.mn.state.mdor.ecrv.extract.form.StandardBuyerSellerForm>
		</individuals>
	</buyersForm>
	<sellersForm>
		<organizations/>
		<individuals>
			<us.mn.state.mdor.ecrv.extract.form.StandardBuyerSellerForm>
				<id>1</id>
				<person>true</person>
				<firstName>Patricia</firstName>
				<middleName>M.</middleName>
				<lastName>Curry</lastName>
				<nameSuffix/>
				<addressLine1>3803 m. Baltusrol Path</addressLine1>
				<addressLine2/>
				<city>Lecanto</city>
				<stateOrProvince>FL</stateOrProvince>
				<zip>34461</zip>
				<country>US</country>
				<email/>
				<daytimePhone>6782975992</daytimePhone>
				<contactNotes/>
				<foreignAddress>false</foreignAddress>
				<privateIndicator>false</privateIndicator>
			</us.mn.state.mdor.ecrv.extract.form.StandardBuyerSellerForm>
		</individuals>
	</sellersForm>
	<propertyForm>
		<county>18</county>
		<legalDescription>That part of Auditor’s Lots 23 and 22 “Auditor Subdivision of Government Lots 2, 3, 4, 5 and NE¼NW¼, Sec. 24, Twp. 135, Rge. 29&quot; and part of Government Lot 6, Sec. 24, Twp. 135, Rge. 29 which is bounded on the East by Hubert Lake, on the West by the public highway constructed and maintained by Nisswa, and known as ‘Camp Lincoln Road’, on the South by the Southerly boundary line, and such line extended, of Lot 23 of Auditor’s Subdivision, on the North by a line parallel with said South line of said Lot 23, and its westerly extension, 106.5 feet Northerly therefrom when measured at right angles</legalDescription>
		<whatIsIncludedInSale>A</whatIsIncludedInSale>
		<newBuildingsOnSaleYear>false</newBuildingsOnSaleYear>
		<principalResidence>false</principalResidence>
		<needsTimberDetails>false</needsTimberDetails>
		<needsApartmentDetails>false</needsApartmentDetails>
		<needsAcreageDetails>false</needsAcreageDetails>
		<displayMnPropertyAddress>true</displayMnPropertyAddress>
		<displayParcel>true</displayParcel>
		<mnPropertyAddresses>
			<us.mn.state.mdor.ecrv.extract.form.PropertyAddressForm>
				<id>1</id>
				<street1>23092 Camp Lincoln Road</street1>
				<street2/>
				<city>1600</city>
				<zip>56468</zip>
			</us.mn.state.mdor.ecrv.extract.form.PropertyAddressForm>
		</mnPropertyAddresses>
		<plannedUses>
			<us.mn.state.mdor.ecrv.extract.form.PlannedUseForm>
				<id>2</id>
				<tier1Cde>RESID</tier1Cde>
				<tier2Cde>SINGLEFAM</tier2Cde>
				<primaryInd>true</primaryInd>
			</us.mn.state.mdor.ecrv.extract.form.PlannedUseForm>
		</plannedUses>
		<usesBeforeSale>
			<us.mn.state.mdor.ecrv.extract.form.PlannedUseForm>
				<id>1</id>
				<tier1Cde>RESID</tier1Cde>
				<tier2Cde>SINGLEFAM</tier2Cde>
				<primaryInd>false</primaryInd>
			</us.mn.state.mdor.ecrv.extract.form.PlannedUseForm>
		</usesBeforeSale>
		<parcels>
			<us.mn.state.mdor.ecrv.extract.form.ParcelForm>
				<id>1</id>
				<primary>true</primary>
				<parcelId>28102000023A009</parcelId>
			</us.mn.state.mdor.ecrv.extract.form.ParcelForm>
		</parcels>
		<propertyPrograms/>
	</propertyForm>
	<salesAgreementForm>
		<deedContractDate class="sql-date">2016-10-31</deedContractDate>
		<totPurchaseAmt>450000.0000</totPurchaseAmt>
		<downPmtEquity>90000.0000</downPmtEquity>
		<sellerPdPts>0.0000</sellerPdPts>
		<specialAssesmtAmt>0.0000</specialAssesmtAmt>
		<financeType>MORTGAGE</financeType>
		<personalPropertyIncludedInTotal>true</personalPropertyIncludedInTotal>
		<didBuyerLease>false</didBuyerLease>
		<didSellerLease>false</didSellerLease>
		<sellerLeaseMonths>0</sellerLeaseMonths>
		<guaranteeRentIncome>false</guaranteeRentIncome>
		<deedPayoff>false</deedPayoff>
		<buyerPartInterest>false</buyerPartInterest>
		<receivedInTrade>false</receivedInTrade>
		<likeKindExchange>false</likeKindExchange>
		<agreement2YrsOld>false</agreement2YrsOld>
		<financeArrangements/>
		<personalProperties>
			<us.mn.state.mdor.ecrv.extract.form.PersonalPropertyForm>
				<id>5</id>
				<selected>false</selected>
				<propertyDescription>concrete outdoor furniture</propertyDescription>
				<propertyValue>400.0000</propertyValue>
			</us.mn.state.mdor.ecrv.extract.form.PersonalPropertyForm>
			<us.mn.state.mdor.ecrv.extract.form.PersonalPropertyForm>
				<id>9</id>
				<selected>false</selected>
				<propertyDescription>shed contents</propertyDescription>
				<propertyValue>2000.0000</propertyValue>
			</us.mn.state.mdor.ecrv.extract.form.PersonalPropertyForm>
			<us.mn.state.mdor.ecrv.extract.form.PersonalPropertyForm>
				<id>8</id>
				<selected>false</selected>
				<propertyDescription>antique buffet</propertyDescription>
				<propertyValue>3000.0000</propertyValue>
			</us.mn.state.mdor.ecrv.extract.form.PersonalPropertyForm>
			<us.mn.state.mdor.ecrv.extract.form.PersonalPropertyForm>
				<id>7</id>
				<selected>false</selected>
				<propertyDescription>Boat &amp; Boat house contents</propertyDescription>
				<propertyValue>5000.0000</propertyValue>
			</us.mn.state.mdor.ecrv.extract.form.PersonalPropertyForm>
			<us.mn.state.mdor.ecrv.extract.form.PersonalPropertyForm>
				<id>10</id>
				<selected>false</selected>
				<propertyDescription>trailer</propertyDescription>
				<propertyValue>500.0000</propertyValue>
			</us.mn.state.mdor.ecrv.extract.form.PersonalPropertyForm>
			<us.mn.state.mdor.ecrv.extract.form.PersonalPropertyForm>
				<id>6</id>
				<selected>false</selected>
				<propertyDescription>Washer/Dryer</propertyDescription>
				<propertyValue>600.0000</propertyValue>
			</us.mn.state.mdor.ecrv.extract.form.PersonalPropertyForm>
			<us.mn.state.mdor.ecrv.extract.form.PersonalPropertyForm>
				<id>1</id>
				<selected>false</selected>
				<propertyDescription>Dock &amp; Raft</propertyDescription>
				<propertyValue>4000.0000</propertyValue>
			</us.mn.state.mdor.ecrv.extract.form.PersonalPropertyForm>
			<us.mn.state.mdor.ecrv.extract.form.PersonalPropertyForm>
				<id>3</id>
				<selected>false</selected>
				<propertyDescription>beds, dressers, sofas</propertyDescription>
				<propertyValue>2000.0000</propertyValue>
			</us.mn.state.mdor.ecrv.extract.form.PersonalPropertyForm>
			<us.mn.state.mdor.ecrv.extract.form.PersonalPropertyForm>
				<id>4</id>
				<selected>false</selected>
				<propertyDescription>rugs</propertyDescription>
				<propertyValue>1000.0000</propertyValue>
			</us.mn.state.mdor.ecrv.extract.form.PersonalPropertyForm>
			<us.mn.state.mdor.ecrv.extract.form.PersonalPropertyForm>
				<id>2</id>
				<selected>false</selected>
				<propertyDescription>Stove/Refrigerator</propertyDescription>
				<propertyValue>1800.0000</propertyValue>
			</us.mn.state.mdor.ecrv.extract.form.PersonalPropertyForm>
			<us.mn.state.mdor.ecrv.extract.form.PersonalPropertyForm>
				<id>12</id>
				<selected>false</selected>
				<propertyDescription>Window Coverings</propertyDescription>
				<propertyValue>2000.0000</propertyValue>
			</us.mn.state.mdor.ecrv.extract.form.PersonalPropertyForm>
			<us.mn.state.mdor.ecrv.extract.form.PersonalPropertyForm>
				<id>11</id>
				<selected>false</selected>
				<propertyDescription>dining table &amp; chairs &amp; granite island</propertyDescription>
				<propertyValue>2000.0000</propertyValue>
			</us.mn.state.mdor.ecrv.extract.form.PersonalPropertyForm>
		</personalProperties>
	</salesAgreementForm>
	<supplementaryForm>
		<relatedInd>false</relatedInd>
		<taxExemptInd>false</taxExemptInd>
		<governmentInd>false</governmentInd>
		<nameChangeInd>false</nameChangeInd>
		<legalActionInd>false</legalActionInd>
		<giftInd>false</giftInd>
		<buyerAppraisalInd>true</buyerAppraisalInd>
		<buyerAppraisalAmt>0.0000</buyerAppraisalAmt>
		<sellerAppraisalInd>false</sellerAppraisalInd>
		<sellerAppraisalAmt>0</sellerAppraisalAmt>
		<adjacentPropertyInd>false</adjacentPropertyInd>
		<nonMarketPriceInd>false</nonMarketPriceInd>
		<nonMarketPriceComment/>
		<nonListedInd>false</nonListedInd>
		<nonListedComment/>
	</supplementaryForm>
	<submitterForm/>
</us.mn.state.mdor.ecrv.extract.form.EcrvForm>'

CREATE TABLE [xmlBookDataImport] (
    [id] nvarchar(255),
    [author] nvarchar(255),
    [title] nvarchar(255),
    [genre] nvarchar(255),
    [price] decimal(28,10),
    [publish_date] datetime,
    [description] nvarchar(255),
    [ImportDate] datetime DEFAULT (getdate())
)

select * from [xmlBookDataImport]