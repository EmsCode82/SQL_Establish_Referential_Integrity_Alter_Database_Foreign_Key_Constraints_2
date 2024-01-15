-- --------------------------------------------------------------------------------
-- Name: Eric Shepard
-- Class: IT-111 
-- Abstract: Assignment 10.7
-- --------------------------------------------------------------------------------

-- --------------------------------------------------------------------------------
-- Options
-- --------------------------------------------------------------------------------
USE dbGetEmToBuyIt;     -- Get out of the master database
SET NOCOUNT ON; -- Report only errors

-- --------------------------------------------------------------------------------
--						Problem #10.7
-- --------------------------------------------------------------------------------

-- Drop Table Statements

IF OBJECT_ID ('TOrderProducts')	IS NOT NULL DROP TABLE TOrderProducts
IF OBJECT_ID ('TOrders')		IS NOT NULL DROP TABLE TOrders
IF OBJECT_ID ('TProducts')		IS NOT NULL DROP TABLE TProducts
IF OBJECT_ID ('TCustomers')		IS NOT NULL DROP TABLE TCustomers
IF OBJECT_ID ('TVendors')		IS NOT NULL DROP TABLE TVendors


-- --------------------------------------------------------------------------------
--	Step #1 : Create table 
-- --------------------------------------------------------------------------------

CREATE TABLE TCustomers
(
	 intCustomerID			INTEGER			NOT NULL
	,strFirstName			VARCHAR(255)	NOT NULL
	,strLastName			VARCHAR(255)	NOT NULL
	,strAddress				VARCHAR(255)	NOT NULL
	,strCity				VARCHAR(255)	NOT NULL
	,strState				VARCHAR(255)	NOT NULL
	,strZip					VARCHAR(255)	NOT NULL
	,dtmDateOfBirth			DATETIME		NOT NULL
	,strRace				VARCHAR(255)	NOT NULL
	,strGender				VARCHAR(255)	NOT NULL
	,CONSTRAINT TCustomers_PK PRIMARY KEY ( intCustomerID )
)

CREATE TABLE TOrders
(
	 intOrderID				INTEGER			NOT NULL
    ,intCustomerID          INTEGER         NOT NULL
	,strOrderNumber			VARCHAR(255)	NOT NULL
	,strStatus				VARCHAR(255)	NOT NULL
	,dtmOrderDate			DATETIME		NOT NULL
	,CONSTRAINT TOrders_PK PRIMARY KEY ( intOrderID )
)

CREATE TABLE TProducts
(
	 intProductID			INTEGER			NOT NULL
	,intVendorID            INTEGER         NOT NULL
	,strProductName			VARCHAR(255)	NOT NULL
	,monCostofProduct		MONEY			NOT NULL
	,monRetailCost			MONEY			NOT NULL
	,strProductCategory		VARCHAR(255)	NOT NULL
	,intInventory			INTEGER			NOT NULL
	,CONSTRAINT TProducts_PK PRIMARY KEY ( intProductID )
)

CREATE TABLE TOrderProducts
(
	 intOrderProductID      INTEGER         NOT NULL
	,intOrderID             INTEGER         NOT NULL
	,intProductID           INTEGER         NOT NULL
	,CONSTRAINT TOrderProducts_PK PRIMARY KEY ( intOrderProductID )
)

CREATE TABLE TVendors
(
	 intVendorID			INTEGER			NOT NULL
	,strVendorName			VARCHAR(255)	NOT NULL
	,strAddress				VARCHAR(255)	NOT NULL
	,strCity				VARCHAR(255)	NOT NULL
	,strState				VARCHAR(255)	NOT NULL
	,strZip					VARCHAR(255)	NOT NULL
	,strContactFirstName	VARCHAR(255)	NOT NULL
	,strContactLastName		VARCHAR(255)	NOT NULL
	,strContactPhone		VARCHAR(255)	NOT NULL
	,strContactEmail		VARCHAR(255)	NOT NULL
	,CONSTRAINT TVendors_PK PRIMARY KEY ( intVendorID )
)

-- --------------------------------------------------------------------------------
--	Step #2 : Establish Referential Integrity
-- --------------------------------------------------------------------------------
-- 
--	#    Child                          Parent                     Column
--  -    -------                          ----------               -------------
--  1    TOrders                        TCustomers                 intCustomerID
--  2    TProducts                      TVendors                   intVendorID
--  3    TOrderProducts                 TOrders                    intOrderID
--  4    TOrderProducts                 TProducts                  intProduct

--1
ALTER TABLE TOrders ADD CONSTRAINT TOrders_TCustomers_FK 
Foreign KEY (intCustomerID) REFERENCES TCustomers (intCustomerID)

--2
ALTER TABLE TProducts ADD CONSTRAINT TProducts_TVendors_FK 
Foreign KEY (intVendorID) REFERENCES TVendors (intVendorID)

--3
ALTER TABLE TOrderProducts ADD CONSTRAINT TOrderProducts_TOrders_FK 
Foreign KEY (intOrderID) REFERENCES TOrders (intOrderID)

--4
ALTER TABLE TOrderProducts ADD CONSTRAINT TOrderProducts_TProducts_FK 
Foreign KEY (intProductID) REFERENCES TProducts (intProductID)


-- --------------------------------------------------------------------------------
--	Step #3 : Add Data - INSERTS
-- --------------------------------------------------------------------------------

INSERT INTO TCustomers (intCustomerID, strFirstName, strLastName, strAddress, strCity, strState, strZip, dtmDateOfBirth, strRace, strGender)
VALUES				  (1, 'James', 'Jones', '321 Elm St.', 'Cincinnati', 'Oh', '45201', '1/1/1997', 'Hispanic', 'Male')
					 ,(2, 'Sally', 'Smith', '987 Main St.', 'Norwood', 'Oh', '45218', '12/1/1999', 'African-American', 'Female')
					 ,(3, 'Jose', 'Hernandez', '1569 Windisch Rd.', 'West Chester', 'Oh', '45069', '9/23/1998', 'Hispanic', 'Male')
					 ,(4, 'Lan', 'Kim', '44561 Oak Ave.', 'Milford', 'Oh', '45246', '6/11/1999', 'Asian', 'Male')

INSERT INTO TOrders ( intOrderID, intCustomerID, strOrderNumber, strStatus, dtmOrderDate)
VALUES				 ( 1, 4, '10101010', 'Shipped', '8/28/2017')
					,( 2, 3, '20202020', 'Ordered', '8/28/2007')
					,( 3, 1, '30303030', 'Delivered', '6/28/2017')
					,( 4, 2, '40404040', 'Delivered', '5/28/2007')

INSERT INTO TVendors ( intVendorID, strVendorName, strAddress, strCity, strState, strZip, strContactFirstName, strContactLastName, strContactPhone, strContactEmail)
VALUES				 (1, 'TreesRUs', '321 Elm St.', 'Cincinnati', 'Oh', '45201', 'Iwana', 'Cleantooth', '555-555-5555', 'Icleantooth@treesrus.com')
					,(2, 'ShirtsRUs', '987 Main St.', 'Norwood', 'Oh', '45218', 'Eilene', 'Totheright' , '666-666-6666', 'etotheright@shirtsrus.com')
					,(3, 'ToysRUs', '1569 Windisch Rd.', 'West Chester', 'Oh', '45069', 'Mike', 'Metosing', '888-888-8888', 'mmetosing@toysrus.com')					  

INSERT INTO TProducts( intProductID, intVendorID, strProductName, monCostofProduct, monRetailCost, strProductCategory, intInventory)
VALUES				 (1, 1, 'Toothpicks', .10, .40, 'Every Day', 100000)
					,(2, 2, 'T-Shirts', 5.10, 15.40, 'Apparel', 2000)
				    ,(3, 3,'uPlay', 44.10, 85.40, 'Electronics', 300)

INSERT INTO TOrderProducts( intOrderProductID, intOrderID, intProductID)
VALUES				 (1, 2, 3)
					,(2, 1, 1)
					,(3, 2, 2)
					,(4, 3, 2)
					,(5, 4, 1)
						  
SELECT TC.strFirstName as 'First Name', TC.strLastName as 'Last Name', TC.strAddress as 'Address', TC.strCity as 'City', TC.strState as 'State', TC.strZip as 'Zip', TC.strGender as 'Gender', TC.strRace as 'Race', TC.dtmDateOfBirth as 'Birth Date',
	   TOR.strOrderNumber as 'Order Number', TOR.dtmOrderDate 'Order Date', TOR.strStatus as 'Status'

FROM TCustomers as TC
    ,TOrders as TOR

WHERE TC.intCustomerID = TOR.intCustomerID

ORDER BY TOR.dtmOrderDate ASC



SELECT TC.strFirstName as 'First Name', TC.strLastName as 'Last Name', TC.strAddress as 'Address', TC.strCity as 'City', TC.strState as 'State', TC.strZip as 'Zip', TC.strGender as 'Gender', TC.strRace as 'Race', TC.dtmDateOfBirth as 'Birth Date',
	   TOR.strOrderNumber as 'Order Number', TOR.dtmOrderDate 'Order Date', TOR.strStatus as 'Status'

FROM TCustomers as TC
    ,TOrders as TOR

WHERE TC.intCustomerID = TOR.intCustomerID
  and TC.strLastName = 'Smith'

ORDER BY TOR.dtmOrderDate ASC


SELECT TC.strFirstName as 'First Name', TC.strLastName as 'Last Name', TC.strAddress as 'Address', TC.strCity as 'City', TC.strState as 'State', TC.strZip as 'Zip', TC.strGender as 'Gender', TC.strRace as 'Race', TC.dtmDateOfBirth as 'Birth Date',
	   TOR.strOrderNumber as 'Order Number', TOR.dtmOrderDate 'Order Date', TOR.strStatus as 'Status',
	   TP.strProductName as 'Product Name', TP.monCostofProduct as 'Price', TP.monRetailCost as 'Retail Price', TP.strProductCategory as 'Product Category', TP.intInventory as 'In Stock'

FROM TCustomers as TC
    ,TOrders as TOR
	,TOrderProducts as TORP
	,TProducts as TP

WHERE TC.intCustomerID = TOR.intCustomerID
  and TC.strLastName = 'Kim'

ORDER BY TOR.dtmOrderDate ASC


SELECT TV.strVendorName as 'Vendor Name', TV.strAddress as 'Address', TV.strCity as 'City', TV.strState as 'State', TV.strZip as 'Zip', TV.strContactFirstName as 'Contact First Name', TV.strContactLastName as 'Contact Last Name', TV.strContactPhone as 'Contact Phone Number', TV.strContactEmail as 'Contact Email',
	   TP.strProductName as 'Product Name', TP.monCostOfProduct as 'Price', TP.monRetailCost as 'Retail Price', TP.strProductCategory as 'Product Category', TP.intInventory as 'In Stock'

FROM TVendors as TV
	,TProducts as TP

WHERE TV.intVendorID = TP.intVendorID


SELECT TV.strVendorName as 'Vendor Name', TV.strAddress as 'Address', TV.strCity as 'City', TV.strState as 'State', TV.strZip as 'Zip', TV.strContactFirstName as 'Contact First Name', TV.strContactLastName as 'Contact Last Name', TV.strContactPhone as 'Contact Phone Number', TV.strContactEmail as 'Contact Email',
	   TP.strProductName as 'Product Name', TP.monCostOfProduct as 'Price', TP.monRetailCost as 'Retail Price', TP.strProductCategory as 'Product Category', TP.intInventory as 'In Stock'

FROM TVendors as TV
	,TProducts as TP

WHERE TV.intVendorID = TP.intVendorID
  and TV.strContactLastName = 'Metosing'
