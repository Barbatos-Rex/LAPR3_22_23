# Database Physical Structure

## Technology

A database is an organized collection of structured information, or data, typically stored electronically in a computer system.
A database is usually controlled by a database management system (DBMS). Together, the data and the DBMS, along with the applications 
that are associated with them, are referred to as a database system, often shortened to just database.

Data within the most common types of databases in operation today is typically modeled in rows and columns in a series of
tables to make processing and data querying efficient. The data can then be easily accessed, managed, modified, updated, 
controlled, and organized. Most databases use structured query language (SQL) for writing and querying data.
Popular examples are:
* [Oracle XE](https://www.oracle.com/database/technologies/appdev/xe.html)
* [My SQL](https://www.mysql.com/)
* [SQL Server](https://www.microsoft.com/pt-br/sql-server/sql-server-downloads)
* [PostgreSQL](https://www.postgresql.org/)

Nevertheless, there are other types of databases that deviate from such specification, non-relational (or no SQL) databases.
A NoSQL, or non relational database, allows unstructured and semi structured (making use of schemas) data to be stored and manipulated (in contrast to 
a relational database, which defines how all data inserted into the database must be composed). NoSQL databases grew popular 
as web applications became more common and more complex.
Popular examples are:
* [Mongo DB](https://www.mongodb.com/)
* [Apache Cassandra](https://cassandra.apache.org/_/index.html)
* [Neo4J](https://neo4j.com/)
* [Redis](https://redis.io/)

[Reference](https://www.oracle.com/pt/database/what-is-database/)

Relational databases work with structured data. They support ACID transactional consistency and provide a flexible way to 
structure data that is not possible with other database technologies. Key features of relational databases include the 
ability to make two tables look like one, join multiple tables together on key fields, create complex indexes that perform 
well and are easy to manage, and maintain data integrity for maximum data accuracy.

The relational database is a system of storing and retrieving data in which the content of the data is stored in tables, 
rows, columns, or fields. When you have multiple pieces of information that need to be related to one another then it is 
important to store them in this type of format; otherwise, you would just end up with a bunch of unrelated facts and figures
without any ties between them.

There are many benefits associated with using a relational database for managing your data needs. For instance, if you want
to view all the contacts in your phone book (or other types) then all you would need to do is enter one query into the search 
bar and instantly see every contact listed there. This saves time from having to manually go through.

The relational database benefits are discussed briefly.

1. **Simplicity of Model**

In contrast to other types of database models, the relational database model is much simpler. It does not require any complex queries because it has no query processing or structuring so simple SQL queries are enough to handle the data.

2. **Ease of Use**

Users can easily access/retrieve their required information within seconds without indulging in the complexity of the database. Structured Query Language (SQL) is used to execute complex queries.

3. **Accuracy**

A key feature of relational databases is that they’re strictly defined and well-organized, so data doesn’t get duplicated. Relational databases have accuracy because of their structure with no data duplication.

4.  **Data Integrity**

RDBMS databases are also widely used for data integrity as they provide consistency across all tables. The data integrity ensures the features like accuracy and ease of use.

5. **Normalization**
As data becomes more and more complex, the need for efficient ways of storing it increases. Normalization is a method that breaks down information into manageable chunks to reduce storage size. Data can be broken up into different levels with any level requiring preparation before moving onto another level of normalizing your data.

Database normalization also ensures that a relational database has no variety or variance in its structure and can be manipulated accurately. This ensures that integrity is maintained when using data from this database for your business decisions.

6. **Collaboration**

Multiple users can access the database to retrieve information at the same time and even if data is being updated.

7. **Security**

Data is secure as Relational Database Management System allows only authorized users to directly access the data. No unauthorized user can access the information.


Although there are more benefits of using relational databases, it has some limitations also. Let’s see the limitations or disadvantages of using the relational database.

1. **Maintenance Problem**

The maintenance of the relational database becomes difficult over time due to the increase in the data. Developers and programmers have to spend a lot of time maintaining the database.

2. **Cost**

The relational database system is costly to set up and maintain. The initial cost of the software alone can be quite pricey for smaller businesses, but it gets worse when you factor in hiring a professional technician who must also have expertise with that specific kind of program.

3. **Physical Storage**

A relational database is comprised of rows and columns, which requires a lot of physical memory because each operation performed depends on separate storage. The requirements of physical memory may increase along with the increase of data.

4. **Lack of Scalability**

While using the relational database over multiple servers, its structure changes and becomes difficult to handle, especially when the quantity of the data is large. Due to this, the data is not scalable on different physical storage servers. Ultimately, its performance is affected i.e. lack of availability of data and load time etc. As the database becomes larger or more distributed with a greater number of servers, this will have negative effects like latency and availability issues affecting overall performance.

5. **Complexity in Structure**

Relational databases can only store data in tabular form which makes it difficult to represent complex relationships between objects. This is an issue because many applications require more than one table to store all the necessary data required by their application logic.

6. **Decrease in performance over time**

The relational database can become slower, not just because of its reliance on multiple tables. When there is a large number of tables and data in the system, it causes an increase in complexity. It can lead to slow response times over queries or even complete failure for them depending on how many people are logged into the server at a given time.

[Reference](https://databasetown.com/relational-database-benefits-and-limitations/)

For this project a **Relational Database (SQL Database)** was chosen due to having more upsides than downsides and for the downsides.


## Files to Include

* [CREATE TABLES](./CREATE_TABLES.sql)
* [INITIAL BOOT](./INITIAL_BOOT.sql)
* [DELETE DATABASE](./DELETE_DATABASE.sql)

<!--* [CLEAR DATABASE](./CLEAR_DATABASE.sql)  Will be DEPRECATED-->

The database that will be used in this project will
be [Oracle 18c](https://docs.oracle.com/en/database/oracle/oracle-database/18/)

For clarification on the naming conventions used on this database
see [this document](./../../conventions/Database%20Naming%20Conventions.md)

## Table Creation and Alters

```sql
-- TABLES --
CREATE TABLE Address
(
    id       number(10) GENERATED BY DEFAULT AS IDENTITY,
    zipcode  VARCHAR2(255),
    district VARCHAR2(255) DEFAULT 'PORTO',
    PRIMARY KEY (id)
);
CREATE TABLE AuditLog
(
    id           number(10) GENERATED BY DEFAULT AS IDENTITY,
    dateOfAction date DEFAULT SYSDATE,
    userId       number(10)    NOT NULL,
    type         varchar2(255) NOT NULL,
    command      varchar2(500) NOT NULL,
    PRIMARY KEY (id,
                 dateOfAction,
                 userId)
);
CREATE TABLE Basket
(
    id             number(10) GENERATED BY DEFAULT AS IDENTITY,
    dateOfCreation date DEFAULT SYSDATE,
    price          number(15, 2) NOT NULL CHECK ( price > 0 ),
    PRIMARY KEY (id)
);
CREATE TABLE BasketOrder
(
    client       number(10) NOT NULL,
    basket       number(10) NOT NULL,
    quantity     number(10) NOT NULL CHECK ( quantity > 0 ),
    driver       number(10),
    orderDate    date          DEFAULT SYSDATE,
    dueDate      date          DEFAULT SYSDATE + 10,
    deliveryDate date          DEFAULT SYSDATE + 30,
    status       VARCHAR2(255) DEFAULT 'REGISTERED',
    address      number(10) NOT NULL,
    orderNumber  number(10) GENERATED ALWAYS AS IDENTITY,
    payed        VARCHAR2(1)   DEFAULT 'N',
    PRIMARY KEY (client,
                 basket, orderDate)
);
CREATE TABLE BasketProduct
(
    basket   number(10) NOT NULL,
    product  number(10) NOT NULL,
    quantity number(10) DEFAULT 1 CHECK ( quantity > 0 ),
    PRIMARY KEY (basket,
                 product)
);
CREATE TABLE Building
(
    id          number(10) GENERATED BY DEFAULT AS IDENTITY,
    exploration number(10) NOT NULL,
    PRIMARY KEY (id)
);
CREATE TABLE Client
(
    id                number(10)                   NOT NULL,
    address           number(10)                   NOT NULL,
    name              varchar2(255)                NOT NULL,
    nif               number(9)                    NOT NULL CHECK ( REGEXP_LIKE(nif, '^[1-4]\d{8}') ),
    plafond           number(10)    DEFAULT 100000 NOT NULL CHECK ( plafond >= 0 ),
    incidents         number(10)    DEFAULT 0      NOT NULL CHECK ( incidents >= 0 ),
    lastIncidentDate  date          DEFAULT SYSDATE,
    lastYearOrders    number(10)    DEFAULT 0      NOT NULL CHECK ( lastYearOrders >= 0 ),
    lastYearSpent     number(20, 2) DEFAULT 0      NOT NULL CHECK ( lastYearSpent >= 0 ),
    addressOfDelivery number(10)                   NOT NULL,
    priorityLevel     varchar2(1)   DEFAULT 'B'    NOT NULL CHECK ( REGEXP_LIKE(priorityLevel, '[ABC]') ),
    lastYearIncidents number(10)    DEFAULT 0      NOT NULL CHECK ( lastYearIncidents >= 0 ),
    PRIMARY KEY (id)
);
CREATE TABLE CropWatering
(
    dateOfAction   date                    NOT NULL,
    sector         number(10)              NOT NULL,
    quantity       number(19, 2) DEFAULT 0 NOT NULL CHECK ( quantity >= 0 ),
    fieldRecording number(10)              NOT NULL,
    PRIMARY KEY (dateOfAction,
                 sector)
);
CREATE TABLE CulturePlan
(
    sprinklingSystem number(10) NOT NULL,
    exploration      number(10) NOT NULL,
    sector           number(10) NOT NULL,
    PRIMARY KEY (sprinklingSystem,
                 exploration)
);
CREATE TABLE DistributionManager
(
    id number(10) NOT NULL,
    PRIMARY KEY (id)
);
CREATE TABLE Driver
(
    id number(10) NOT NULL,
    PRIMARY KEY (id)
);
CREATE TABLE Exploration
(
    id      number(10) GENERATED BY DEFAULT AS IDENTITY,
    address number(10),
    PRIMARY KEY (id)
);
CREATE TABLE ExplorationClientele
(
    client      number(10) NOT NULL,
    exploration number(10) NOT NULL,
    PRIMARY KEY (client,
                 exploration)
);
CREATE TABLE FarmingManager
(
    id number(10) NOT NULL,
    PRIMARY KEY (id)
);
CREATE TABLE FieldRecording
(
    exploration number(10) NOT NULL,
    PRIMARY KEY (exploration)
);
CREATE TABLE ProductionFactorsRecording
(
    fieldRecording    number(10) NOT NULL,
    productionFactors number(10) NOT NULL,
    dateOfRecording   date DEFAULT SYSDATE,
    PRIMARY KEY (fieldRecording,
                 productionFactors,
                 dateOfRecording)
);
CREATE TABLE Harvest
(
    dateOfHarvest  date       NOT NULL,
    sector         number(10) NOT NULL,
    numberOfUnits  number(10) NOT NULL,
    fieldRecording number(10) NOT NULL,
    PRIMARY KEY (dateOfHarvest,
                 sector)
);
CREATE TABLE Hub
(
    address number(10) NOT NULL
);
CREATE TABLE MachineryGarage
(
    id number(10) NOT NULL,
    PRIMARY KEY (id)
);
CREATE TABLE MeteorologicData
(
    fieldRecording  number(10) NOT NULL,
    station         number(10) NOT NULL,
    dateOfRecording number(10) NOT NULL,
    PRIMARY KEY (fieldRecording,
                 station,
                 dateOfRecording)
);
CREATE TABLE MeteorologicStation
(
    id   number(10) GENERATED AS IDENTITY,
    name VARCHAR2(255),
    PRIMARY KEY (id)
);
CREATE TABLE Product
(
    name  varchar2(255)           NOT NULL,
    type  varchar2(255)           NOT NULL,
    id    number(10) GENERATED BY DEFAULT AS IDENTITY,
    price number(10, 2) DEFAULT 1 NOT NULL CHECK ( price > 0 ),
    PRIMARY KEY (id)
);
CREATE TABLE ProductionEntry
(
    id    number(10)    NOT NULL,
    value number(10)    NOT NULL CHECK ( value >= 0 ),
    unit  varchar2(255) NOT NULL,
    type  varchar2(255) NOT NULL,
    name  varchar2(255) NOT NULL,
    PRIMARY KEY (id, name)
);
CREATE TABLE ProductionFactors
(
    id          number(10) GENERATED BY DEFAULT AS IDENTITY,
    name        varchar2(255) NOT NULL,
    formulation varchar2(255) NOT NULL,
    supplier    varchar2(255) NOT NULL,
    PRIMARY KEY (id)
);
CREATE TABLE ProductionZones
(
    id number(10) NOT NULL,
    PRIMARY KEY (id)
);
CREATE TABLE Sector
(
    id                  number(10) GENERATED BY DEFAULT AS IDENTITY,
    designation         varchar2(255) NOT NULL,
    area                number(19)    NOT NULL,
    exploration         number(10)    NOT NULL,
    meteorologicStation number(10)    NOT NULL,
    culturePlan         number(10)    NOT NULL,
    product             number(10)    NOT NULL,
    PRIMARY KEY (id)
);
CREATE TABLE Sensor
(
    id      number(10) GENERATED BY DEFAULT AS IDENTITY,
    station number(10) NOT NULL,
    CONSTRAINT id
        PRIMARY KEY (id)
);
CREATE TABLE Silos
(
    id number(10) NOT NULL,
    PRIMARY KEY (id)
);
CREATE TABLE SprinklingSystem
(
    id              number(10)    NOT NULL,
    type            varchar2(255) NOT NULL,
    distribution    varchar2(255) NOT NULL,
    primarySystem   number(10)    NOT NULL,
    secondarySystem number(10)    NOT NULL,
    PRIMARY KEY (id)
);
CREATE TABLE Stable
(
    id number(10) NOT NULL,
    PRIMARY KEY (id)
);
CREATE TABLE SystemUser
(
    id       number(10) GENERATED BY DEFAULT AS IDENTITY,
    email    varchar2(255) NOT NULL UNIQUE,
    password varchar2(255) DEFAULT 'Qw&rty12345678',
    PRIMARY KEY (id)
);
CREATE TABLE TubularSystem
(
    id number(10),
    PRIMARY KEY (id)
);
CREATE TABLE Valve
(
    id            number(10) GENERATED BY DEFAULT AS IDENTITY,
    tubularSystem number(10) NOT NULL,
    PRIMARY KEY (id)
);

-- Alter --

ALTER TABLE Driver
    ADD CONSTRAINT FKDriverUserId FOREIGN KEY (id) REFERENCES SystemUser (id);
ALTER TABLE FarmingManager
    ADD CONSTRAINT FKFarmingManagerUserId FOREIGN KEY (id) REFERENCES SystemUser (id);
ALTER TABLE Client
    ADD CONSTRAINT FKClientUserId FOREIGN KEY (id) REFERENCES SystemUser (id);
ALTER TABLE Client
    ADD CONSTRAINT FKClientUserId FOREIGN KEY (addressOfDelivery) REFERENCES Address (id);
ALTER TABLE DistributionManager
    ADD CONSTRAINT FKDistributionManagerUserId FOREIGN KEY (id) REFERENCES SystemUser (id);
ALTER TABLE Stable
    ADD CONSTRAINT FKStableBuildingId FOREIGN KEY (id) REFERENCES Building (id);
ALTER TABLE Silos
    ADD CONSTRAINT FKSilosBuildingId FOREIGN KEY (id) REFERENCES Building (id);
ALTER TABLE MachineryGarage
    ADD CONSTRAINT FKMachineryGarageBuildingId FOREIGN KEY (id) REFERENCES Building (id);
ALTER TABLE ProductionZones
    ADD CONSTRAINT FKProductionZonesBuildingId FOREIGN KEY (id) REFERENCES Building (id);
ALTER TABLE SprinklingSystem
    ADD CONSTRAINT FKSprinklingSystemBuildingId FOREIGN KEY (id) REFERENCES Building (id);
ALTER TABLE Sector
    ADD CONSTRAINT FKSectorExplorationId FOREIGN KEY (exploration) REFERENCES Exploration (id);
ALTER TABLE Building
    ADD CONSTRAINT FKBuildingExplorationId FOREIGN KEY (exploration) REFERENCES Exploration (id);
ALTER TABLE ProductionEntry
    ADD CONSTRAINT FKProductionEntryProductionFactorsId FOREIGN KEY (id) REFERENCES ProductionFactors (id);
ALTER TABLE SprinklingSystem
    ADD CONSTRAINT FKSprinklingSystemTubularSystemPrimary FOREIGN KEY (primarySystem) REFERENCES TubularSystem (id);
ALTER TABLE SprinklingSystem
    ADD CONSTRAINT FKSprinklingSystemTubularSystemSecondary FOREIGN KEY (secondarySystem) REFERENCES TubularSystem (id);
ALTER TABLE Sensor
    ADD CONSTRAINT FKSensorMeteorologicStationId FOREIGN KEY (station) REFERENCES MeteorologicStation (id);
ALTER TABLE Sector
    ADD CONSTRAINT FKSectorMeteorologicStationId FOREIGN KEY (meteorologicStation) REFERENCES MeteorologicStation (id);
ALTER TABLE ExplorationClientele
    ADD CONSTRAINT FKExplorationClienteleClientId FOREIGN KEY (client) REFERENCES Client (id);
ALTER TABLE ExplorationClientele
    ADD CONSTRAINT FKExplorationClienteleExplorationId FOREIGN KEY (exploration) REFERENCES Exploration (id);
ALTER TABLE Exploration
    ADD CONSTRAINT FKExplorationAddressId FOREIGN KEY (address) REFERENCES Address (id);
ALTER TABLE Client
    ADD CONSTRAINT FKClientAddressId FOREIGN KEY (address) REFERENCES Address (id);
ALTER TABLE Hub
    ADD CONSTRAINT FKHubAddressId FOREIGN KEY (address) REFERENCES Address (id);
ALTER TABLE BasketOrder
    ADD CONSTRAINT FKBasketOrderClientId FOREIGN KEY (client) REFERENCES Client (id);
ALTER TABLE BasketOrder
    ADD CONSTRAINT FKBasketOrderBasketId FOREIGN KEY (basket) REFERENCES Basket (id);
ALTER TABLE CulturePlan
    ADD CONSTRAINT FKCulturePlanSprinklingSystemId FOREIGN KEY (sprinklingSystem) REFERENCES SprinklingSystem (id);
ALTER TABLE CulturePlan
    ADD CONSTRAINT FKCulturePlanExplorationId FOREIGN KEY (exploration) REFERENCES Exploration (id);
ALTER TABLE CulturePlan
    ADD CONSTRAINT FKCulturePlanExplorationId FOREIGN KEY (sector) REFERENCES Sector (id);
ALTER TABLE Valve
    ADD CONSTRAINT FKValveTubularSystemId FOREIGN KEY (tubularSystem) REFERENCES TubularSystem (id);
ALTER TABLE FieldRecording
    ADD CONSTRAINT FKFieldRecordingExplorationId FOREIGN KEY (exploration) REFERENCES Exploration (id);
ALTER TABLE CropWatering
    ADD CONSTRAINT FKCropWateringSectorId FOREIGN KEY (sector) REFERENCES Sector (id);
ALTER TABLE Sector
    ADD CONSTRAINT FKSectorProductId FOREIGN KEY (product) REFERENCES Product (id);
ALTER TABLE Harvest
    ADD CONSTRAINT FKHarvestSectorId FOREIGN KEY (sector) REFERENCES Sector (id);
ALTER TABLE CropWatering
    ADD CONSTRAINT FKCropWateringFieldRecordingId FOREIGN KEY (fieldRecording) REFERENCES FieldRecording (exploration);
ALTER TABLE Harvest
    ADD CONSTRAINT FKHarvestFieldRecordingId FOREIGN KEY (fieldRecording) REFERENCES FieldRecording (exploration);
ALTER TABLE MeteorologicData
    ADD CONSTRAINT FKMeteorologicDataFieldRecordingId FOREIGN KEY (fieldRecording) REFERENCES FieldRecording (exploration);
ALTER TABLE MeteorologicData
    ADD CONSTRAINT FKMeteorologicDataMeteorologicStationId FOREIGN KEY (station) REFERENCES MeteorologicStation (id);
ALTER TABLE ProductionFactorsRecording
    ADD CONSTRAINT FKProductionFactorsRecordingFieldRecordingId FOREIGN KEY (fieldRecording) REFERENCES FieldRecording (exploration);
ALTER TABLE ProductionFactorsRecording
    ADD CONSTRAINT FKProductionFactorsRecordingProductionFactorsId FOREIGN KEY (productionFactors) REFERENCES ProductionFactors (id);
ALTER TABLE BasketOrder
    ADD CONSTRAINT FKBasketOrderDriverId FOREIGN KEY (driver) REFERENCES Driver (id);
ALTER TABLE BasketProduct
    ADD CONSTRAINT FKBasketProductBasketId FOREIGN KEY (basket) REFERENCES Basket (id);
ALTER TABLE BasketProduct
    ADD CONSTRAINT FKBasketProductProductId FOREIGN KEY (product) REFERENCES Product (id);
ALTER TABLE AuditLog
    ADD CONSTRAINT FKAuditLogSystemUserId FOREIGN KEY (userId) REFERENCES SystemUser (id);
ALTER TABLE BasketOrder
    ADD CONSTRAINT FKBasketOrderAddressId FOREIGN KEY (address) REFERENCES Address (id);
```

## Delete Database

```sql
--DELETE DATABASE--
DROP TABLE Address CASCADE CONSTRAINTS PURGE;
DROP TABLE AuditLog CASCADE CONSTRAINTS PURGE;
DROP TABLE Basket CASCADE CONSTRAINTS PURGE;
DROP TABLE BasketOrder CASCADE CONSTRAINTS PURGE;
DROP TABLE BasketProduct CASCADE CONSTRAINTS PURGE;
DROP TABLE Building CASCADE CONSTRAINTS PURGE;
DROP TABLE Client CASCADE CONSTRAINTS PURGE;
DROP TABLE CropWatering CASCADE CONSTRAINTS PURGE;
DROP TABLE CulturePlan CASCADE CONSTRAINTS PURGE;
DROP TABLE DistributionManager CASCADE CONSTRAINTS PURGE;
DROP TABLE Driver CASCADE CONSTRAINTS PURGE;
DROP TABLE Exploration CASCADE CONSTRAINTS PURGE;
DROP TABLE ExplorationClientele CASCADE CONSTRAINTS PURGE;
DROP TABLE FarmingManager CASCADE CONSTRAINTS PURGE;
DROP TABLE FieldRecording CASCADE CONSTRAINTS PURGE;
DROP TABLE PRODUCTIONFACTORSRECORDING CASCADE CONSTRAINTS PURGE;
DROP TABLE Harvest CASCADE CONSTRAINTS PURGE;
DROP TABLE Hub CASCADE CONSTRAINTS PURGE;
DROP TABLE MachineryGarage CASCADE CONSTRAINTS PURGE;
DROP TABLE MeteorologicData CASCADE CONSTRAINTS PURGE;
DROP TABLE MeteorologicStation CASCADE CONSTRAINTS PURGE;
DROP TABLE Product CASCADE CONSTRAINTS PURGE;
DROP TABLE ProductionEntry CASCADE CONSTRAINTS PURGE;
DROP TABLE ProductionFactors CASCADE CONSTRAINTS PURGE;
DROP TABLE ProductionZones CASCADE CONSTRAINTS PURGE;
DROP TABLE Sector CASCADE CONSTRAINTS PURGE;
DROP TABLE Sensor CASCADE CONSTRAINTS PURGE;
DROP TABLE Silos CASCADE CONSTRAINTS PURGE;
DROP TABLE SprinklingSystem CASCADE CONSTRAINTS PURGE;
DROP TABLE Stable CASCADE CONSTRAINTS PURGE;
DROP TABLE SystemUser CASCADE CONSTRAINTS PURGE;
DROP TABLE TubularSystem CASCADE CONSTRAINTS PURGE;
DROP TABLE Valve CASCADE CONSTRAINTS PURGE;
```

## Initial Boot

```sql
DECLARE
    systemId     Systemuser.ID%type;
    large        BASKET.ID%type;
    average      BASKET.ID%type;
    small        BASKET.ID%type;
    addressResId ADDRESS.ID%type;
    addressDelId ADDRESS.ID%type;
    cId          SYSTEMUSER.ID%type;
BEGIN
    INSERT INTO SYSTEMUSER(EMAIL, PASSWORD)
    VALUES ('system@system.sys', 'qwerty123')
    returning ID into systemId;

    INSERT INTO EXPLORATION(ID) VALUES (1);
    COMMIT;

    INSERT INTO PRODUCT(ID, NAME, TYPE, PRICE) VALUES (1, 'Carrot', 'TEMPORARY', 1);
    INSERT INTO PRODUCT(ID, NAME, TYPE, PRICE) VALUES (2, 'Apple', 'PERMANENT', .80);
    INSERT INTO PRODUCT(ID, NAME, TYPE, PRICE) VALUES (3, 'Honey', 'TEMPORARY', 3);
    INSERT INTO PRODUCT(ID, NAME, TYPE, PRICE) VALUES (4, 'Pears', 'PERMANENT', .75);
    COMMIT;
    INSERT INTO SECTOR(ID, DESIGNATION, AREA, EXPLORATION, CULTUREPLAN, PRODUCT)
    VALUES (1, 'Carrot Filed', 1500, 1, 0, 1);
    INSERT INTO SECTOR(ID, DESIGNATION, AREA, EXPLORATION, CULTUREPLAN, PRODUCT)
    VALUES (2, 'Apple Filed', 150000, 1, 0, 2);
    INSERT INTO SECTOR(ID, DESIGNATION, AREA, EXPLORATION, CULTUREPLAN, PRODUCT) VALUES (3, 'Beehive', 15, 1, 0, 3);
    INSERT INTO SECTOR(ID, DESIGNATION, AREA, EXPLORATION, CULTUREPLAN, PRODUCT)
    VALUES (4, 'Pears Field', 10200, 1, 0, 4);
    COMMIT;
    INSERT INTO HARVEST(DATEOFHARVEST, SECTOR, NUMBEROFUNITS) VALUES (SYSDATE, 1, 100);
    INSERT INTO HARVEST(DATEOFHARVEST, SECTOR, NUMBEROFUNITS) VALUES (TO_DATE('8/10/2022', 'DD/MM/YYYY'), 1, 8);
    INSERT INTO HARVEST(DATEOFHARVEST, SECTOR, NUMBEROFUNITS) VALUES (TO_DATE('10/10/2022', 'DD/MM/YYYY'), 1, 30);
    INSERT INTO HARVEST(DATEOFHARVEST, SECTOR, NUMBEROFUNITS) VALUES (TO_DATE('9/10/2022', 'DD/MM/YYYY'), 1, 87);
    COMMIT;
    INSERT INTO HARVEST(DATEOFHARVEST, SECTOR, NUMBEROFUNITS) VALUES (SYSDATE, 2, 1000);
    INSERT INTO HARVEST(DATEOFHARVEST, SECTOR, NUMBEROFUNITS) VALUES (TO_DATE('8/10/2022', 'DD/MM/YYYY'), 2, 80);
    INSERT INTO HARVEST(DATEOFHARVEST, SECTOR, NUMBEROFUNITS) VALUES (TO_DATE('10/10/2022', 'DD/MM/YYYY'), 2, 300);
    INSERT INTO HARVEST(DATEOFHARVEST, SECTOR, NUMBEROFUNITS) VALUES (TO_DATE('9/10/2022', 'DD/MM/YYYY'), 2, 870);
    COMMIT;
    INSERT INTO HARVEST(DATEOFHARVEST, SECTOR, NUMBEROFUNITS) VALUES (SYSDATE, 3, 100);
    INSERT INTO HARVEST(DATEOFHARVEST, SECTOR, NUMBEROFUNITS) VALUES (TO_DATE('8/10/2022', 'DD/MM/YYYY'), 3, 8);
    INSERT INTO HARVEST(DATEOFHARVEST, SECTOR, NUMBEROFUNITS) VALUES (TO_DATE('10/10/2022', 'DD/MM/YYYY'), 3, 200);
    INSERT INTO HARVEST(DATEOFHARVEST, SECTOR, NUMBEROFUNITS) VALUES (TO_DATE('9/10/2022', 'DD/MM/YYYY'), 3, 87);
    COMMIT;
    INSERT INTO HARVEST(DATEOFHARVEST, SECTOR, NUMBEROFUNITS) VALUES (SYSDATE, 4, 150);
    INSERT INTO HARVEST(DATEOFHARVEST, SECTOR, NUMBEROFUNITS) VALUES (TO_DATE('8/10/2022', 'DD/MM/YYYY'), 4, 86);
    INSERT INTO HARVEST(DATEOFHARVEST, SECTOR, NUMBEROFUNITS) VALUES (TO_DATE('10/10/2022', 'DD/MM/YYYY'), 4, 2);
    INSERT INTO HARVEST(DATEOFHARVEST, SECTOR, NUMBEROFUNITS) VALUES (TO_DATE('9/10/2022', 'DD/MM/YYYY'), 4, 0);
    COMMIT;
    INSERT INTO BASKET(PRICE) VALUES (100) RETURNING ID INTO average;
    INSERT INTO BASKET(PRICE) VALUES (10) RETURNING ID INTO small;
    INSERT INTO BASKET(PRICE) VALUES (10000) RETURNING ID INTO large;
    COMMIT;
    INSERT INTO BASKETPRODUCT(BASKET, PRODUCT, QUANTITY) VALUES (small, 1, 3);
    INSERT INTO BASKETPRODUCT(BASKET, PRODUCT, QUANTITY) VALUES (small, 2, 5);
    INSERT INTO BASKETPRODUCT(BASKET, PRODUCT, QUANTITY) VALUES (small, 4, 2);
    COMMIT;
    INSERT INTO BASKETPRODUCT(BASKET, PRODUCT, QUANTITY) VALUES (average, 1, 10);
    INSERT INTO BASKETPRODUCT(BASKET, PRODUCT, QUANTITY) VALUES (average, 2, 15);
    INSERT INTO BASKETPRODUCT(BASKET, PRODUCT, QUANTITY) VALUES (average, 4, 10);
    INSERT INTO BASKETPRODUCT(BASKET, PRODUCT, QUANTITY) VALUES (average, 3, 15);
    COMMIT;
    INSERT INTO BASKETPRODUCT(BASKET, PRODUCT, QUANTITY) VALUES (large, 1, 100);
    INSERT INTO BASKETPRODUCT(BASKET, PRODUCT, QUANTITY) VALUES (large, 2, 150);
    INSERT INTO BASKETPRODUCT(BASKET, PRODUCT, QUANTITY) VALUES (large, 4, 100);
    INSERT INTO BASKETPRODUCT(BASKET, PRODUCT, QUANTITY) VALUES (large, 3, 150);
    COMMIT;
    INSERT INTO ADDRESS(ZIPCODE, DISTRICT)
    VALUES ('Rua da funda 400, 4445-245 Alfena', 'Porto')
    RETURNING ID into addressResId;
    INSERT INTO ADDRESS(ZIPCODE, DISTRICT)
    VALUES ('Rua primeiro de maio 960, 4445-245 Alfena', 'Porto')
    RETURNING ID into addressDelId;
    COMMIT;
    INSERT INTO SYSTEMUSER(EMAIL, PASSWORD) VALUES ('tomcat@java.com', 'Catalina') RETURNING ID INTO cId;
    INSERT INTO CLIENT(ID, ADDRESS, NAME, NIF, PLAFOND, INCIDENTS, LASTINCIDENTDATE, LASTYEARORDERS, LASTYEARSPENT,
                       ADDRESSOFDELIVERY, PRIORITYLEVEL, LASTYEARINCIDENTS)
    VALUES (cID, addressResId, 'Apache Tomcat', 212345678, 100000, 0, null, 1, 100, addressDelId, 'A', 0);
    COMMIT;

    INSERT INTO BASKETORDER(CLIENT, BASKET, QUANTITY, STATUS, ADDRESS, PAYED, ORDERDATE)
    VALUES (cId, small, 2, 'DELIVERED', addressDelId, 'Y', SYSDATE - 3);
    INSERT INTO BASKETORDER(CLIENT, BASKET, QUANTITY, STATUS, ADDRESS, PAYED, ORDERDATE)
    VALUES (cId, average, 3, 'DELIVERED', addressDelId, 'Y', SYSDATE - 23);
    INSERT INTO BASKETORDER(CLIENT, BASKET, QUANTITY, STATUS, ADDRESS, PAYED, ORDERDATE)
    VALUES (cId, large, 10, 'REGISTERED', addressDelId, 'Y', SYSDATE);
    INSERT INTO BASKETORDER(CLIENT, BASKET, QUANTITY, STATUS, ADDRESS, PAYED, ORDERDATE)
    VALUES (cId, small, 1, 'REGISTERED', addressDelId, 'Y', SYSDATE - 10);
    COMMIT;

    INSERT INTO SYSTEMUSER(EMAIL, PASSWORD) VALUES ('gradle@copy-maven.org', 'IwishIwasMav€n') RETURNING ID into cID;
    INSERT INTO CLIENT(ID, ADDRESS, NAME, NIF, PLAFOND, INCIDENTS, LASTINCIDENTDATE, LASTYEARORDERS, LASTYEARSPENT,
                       ADDRESSOFDELIVERY, PRIORITYLEVEL, LASTYEARINCIDENTS)
    VALUES (cID, addressResId, 'Apache Mav... I mean, Gradle', 112345678, 1, 10, SYSDATE - 10, 10, 10000000,
            addressDelId, 'C', 10);
    COMMIT;
    INSERT INTO BASKETORDER(CLIENT, BASKET, QUANTITY, STATUS, ADDRESS, PAYED, ORDERDATE, DUEDATE)
    VALUES (cId, small, 2, 'DELIVERED', addressDelId, 'N', SYSDATE - 100, SYSDATE - 90);
    INSERT INTO BASKETORDER(CLIENT, BASKET, QUANTITY, STATUS, ADDRESS, PAYED, ORDERDATE, DUEDATE)
    VALUES (cId, average, 3, 'DELIVERED', addressDelId, 'N', SYSDATE - 23, SYSDATE - 13);
    INSERT INTO BASKETORDER(CLIENT, BASKET, QUANTITY, STATUS, ADDRESS, PAYED, ORDERDATE)
    VALUES (cId, large, 10, 'REGISTERED', addressDelId, 'N', SYSDATE);
    INSERT INTO BASKETORDER(CLIENT, BASKET, QUANTITY, STATUS, ADDRESS, PAYED, ORDERDATE, DUEDATE)
    VALUES (cId, small, 1, 'REGISTERED', addressDelId, 'N', SYSDATE - 10, SYSDATE);
    COMMIT;

end;


DECLARE
    val NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Data Report:');
    DBMS_OUTPUT.PUT_LINE('Table ==> Number of Entries');
    DBMS_OUTPUT.PUT_LINE('===========================');
    FOR I IN (SELECT TABLE_NAME FROM USER_TABLES ORDER BY TABLE_NAME)
        LOOP
            EXECUTE IMMEDIATE 'SELECT count(*) FROM ' || i.table_name INTO val;
            DBMS_OUTPUT.PUT_LINE(i.table_name || ' ==> ' || val);
        END LOOP;
END;
```

### Result Report

#### ADDRESS

<body>
<table style="border-collapse:collapse">
<tr>
  <th>ID</th>
  <th>ZIPCODE</th>
  <th>DISTRICT</th>
</tr>
<tr>
  <td>31</td>
  <td>Rua da funda 400, 4445-245 Alfena</td>
  <td>Porto</td>
</tr>
<tr>
  <td>32</td>
  <td>Rua primeiro de maio 960, 4445-245 Alfena</td>
  <td>Porto</td>
</tr>
</table>
</body>


#### BASKET
    
<body>
<table style="border-collapse:collapse">
<tr>
  <th>ID</th>
  <th>DATEOFCREATION</th>
  <th>PRICE</th>
</tr>
<tr>
  <td>19</td>
  <td>2022-12-04 17:06:19</td>
  <td>100</td>
</tr>
<tr>
  <td>20</td>
  <td>2022-12-04 17:06:19</td>
  <td>10</td>
</tr>
<tr>
  <td>21</td>
  <td>2022-12-04 17:06:19</td>
  <td>10000</td>
</tr>
</table>
</body>


#### BASKETORDER
    
<body>
<table style="border-collapse:collapse">
<tr>
  <th>CLIENT</th>
  <th>BASKET</th>
  <th>QUANTITY</th>
  <th>DRIVER</th>
  <th>ORDERDATE</th>
  <th>DUEDATE</th>
  <th>DELIVERYDATE</th>
  <th>STATUS</th>
  <th>ADDRESS</th>
  <th>ORDERNUMBER</th>
  <th>PAYED</th>
</tr>
<tr>
  <td>40</td>
  <td>19</td>
  <td>3</td>
  <td>null</td>
  <td>2022-11-11 17:06:20</td>
  <td>2022-11-21 17:06:20</td>
  <td>2023-01-03 17:06:20</td>
  <td>DELIVERED</td>
  <td>32</td>
  <td>30</td>
  <td>N</td>
</tr>
<tr>
  <td>40</td>
  <td>21</td>
  <td>10</td>
  <td>null</td>
  <td>2022-12-04 17:06:20</td>
  <td>2022-12-14 17:06:20</td>
  <td>2023-01-03 17:06:20</td>
  <td>REGISTERED</td>
  <td>32</td>
  <td>31</td>
  <td>N</td>
</tr>
<tr>
  <td>40</td>
  <td>20</td>
  <td>1</td>
  <td>null</td>
  <td>2022-11-24 17:06:20</td>
  <td>2022-12-04 17:06:20</td>
  <td>2023-01-03 17:06:20</td>
  <td>REGISTERED</td>
  <td>32</td>
  <td>32</td>
  <td>N</td>
</tr>
<tr>
  <td>39</td>
  <td>20</td>
  <td>2</td>
  <td>null</td>
  <td>2022-12-01 17:06:20</td>
  <td>2022-12-14 17:06:20</td>
  <td>2023-01-03 17:06:20</td>
  <td>DELIVERED</td>
  <td>32</td>
  <td>25</td>
  <td>Y</td>
</tr>
<tr>
  <td>39</td>
  <td>19</td>
  <td>3</td>
  <td>null</td>
  <td>2022-11-11 17:06:20</td>
  <td>2022-12-14 17:06:20</td>
  <td>2023-01-03 17:06:20</td>
  <td>DELIVERED</td>
  <td>32</td>
  <td>26</td>
  <td>Y</td>
</tr>
<tr>
  <td>39</td>
  <td>21</td>
  <td>10</td>
  <td>null</td>
  <td>2022-12-04 17:06:20</td>
  <td>2022-12-14 17:06:20</td>
  <td>2023-01-03 17:06:20</td>
  <td>REGISTERED</td>
  <td>32</td>
  <td>27</td>
  <td>Y</td>
</tr>
<tr>
  <td>39</td>
  <td>20</td>
  <td>1</td>
  <td>null</td>
  <td>2022-11-24 17:06:20</td>
  <td>2022-12-14 17:06:20</td>
  <td>2023-01-03 17:06:20</td>
  <td>REGISTERED</td>
  <td>32</td>
  <td>28</td>
  <td>Y</td>
</tr>
<tr>
  <td>40</td>
  <td>20</td>
  <td>2</td>
  <td>null</td>
  <td>2022-08-26 17:06:20</td>
  <td>2022-09-05 17:06:20</td>
  <td>2023-01-03 17:06:20</td>
  <td>DELIVERED</td>
  <td>32</td>
  <td>29</td>
  <td>N</td>
</tr>
</table>
</body>


#### BASKETPRODUCT
    
<body>
<table style="border-collapse:collapse">
<tr>
  <th>BASKET</th>
  <th>PRODUCT</th>
  <th>QUANTITY</th>
</tr>
<tr>
  <td>19</td>
  <td>2</td>
  <td>15</td>
</tr>
<tr>
  <td>19</td>
  <td>4</td>
  <td>10</td>
</tr>
<tr>
  <td>19</td>
  <td>3</td>
  <td>15</td>
</tr>
<tr>
  <td>21</td>
  <td>1</td>
  <td>100</td>
</tr>
<tr>
  <td>21</td>
  <td>2</td>
  <td>150</td>
</tr>
<tr>
  <td>21</td>
  <td>4</td>
  <td>100</td>
</tr>
<tr>
  <td>21</td>
  <td>3</td>
  <td>150</td>
</tr>
<tr>
  <td>20</td>
  <td>1</td>
  <td>3</td>
</tr>
<tr>
  <td>20</td>
  <td>2</td>
  <td>5</td>
</tr>
<tr>
  <td>20</td>
  <td>4</td>
  <td>2</td>
</tr>
<tr>
  <td>19</td>
  <td>1</td>
  <td>10</td>
</tr>
</table>
</body>


#### Client
    
<body>
<table style="border-collapse:collapse">
<tr>
  <th>ID</th>
  <th>ADDRESS</th>
  <th>NAME</th>
  <th>NIF</th>
  <th>PLAFOND</th>
  <th>INCIDENTS</th>
  <th>LASTINCIDENTDATE</th>
  <th>LASTYEARORDERS</th>
  <th>LASTYEARSPENT</th>
  <th>ADDRESSOFDELIVERY</th>
  <th>PRIORITYLEVEL</th>
  <th>LASTYEARINCIDENTS</th>
</tr>
<tr>
  <td>39</td>
  <td>31</td>
  <td>Apache Tomcat</td>
  <td>212345678</td>
  <td>100000</td>
  <td>0</td>
  <td>null</td>
  <td>1</td>
  <td>100</td>
  <td>32</td>
  <td>A</td>
  <td>0</td>
</tr>
<tr>
  <td>40</td>
  <td>31</td>
  <td>Apache Mav... I mean, Gradle</td>
  <td>112345678</td>
  <td>1</td>
  <td>10</td>
  <td>2022-11-24 17:06:20</td>
  <td>10</td>
  <td>10000000</td>
  <td>32</td>
  <td>C</td>
  <td>10</td>
</tr>
</table>
</body>


#### EXPLORATION
    
<body>
<table style="border-collapse:collapse">
<tr>
  <th>ID</th>
  <th>ADDRESS</th>
</tr>
<tr>
  <td>1</td>
  <td>null</td>
</tr>
</table>
</body>


#### FIELDRECORDING
    
<body>
<table style="border-collapse:collapse">
<tr>
  <th>EXPLORATION</th>
</tr>
<tr>
  <td>1</td>
</tr>
</table>
</body>


#### HARVEST
    
<body>
<table style="border-collapse:collapse">
<tr>
  <th>DATEOFHARVEST</th>
  <th>SECTOR</th>
  <th>NUMBEROFUNITS</th>
  <th>FIELDRECORDING</th>
</tr>
<tr>
  <td>2022-10-08</td>
  <td>2</td>
  <td>80</td>
  <td>1</td>
</tr>
<tr>
  <td>2022-10-10</td>
  <td>2</td>
  <td>300</td>
  <td>1</td>
</tr>
<tr>
  <td>2022-10-09</td>
  <td>2</td>
  <td>870</td>
  <td>1</td>
</tr>
<tr>
  <td>2022-12-04 17:06:19</td>
  <td>3</td>
  <td>100</td>
  <td>1</td>
</tr>
<tr>
  <td>2022-10-08</td>
  <td>3</td>
  <td>8</td>
  <td>1</td>
</tr>
<tr>
  <td>2022-10-10</td>
  <td>3</td>
  <td>200</td>
  <td>1</td>
</tr>
<tr>
  <td>2022-10-09</td>
  <td>3</td>
  <td>87</td>
  <td>1</td>
</tr>
<tr>
  <td>2022-12-04 17:06:19</td>
  <td>4</td>
  <td>150</td>
  <td>1</td>
</tr>
<tr>
  <td>2022-10-08</td>
  <td>4</td>
  <td>86</td>
  <td>1</td>
</tr>
<tr>
  <td>2022-10-10</td>
  <td>4</td>
  <td>2</td>
  <td>1</td>
</tr>
<tr>
  <td>2022-10-09</td>
  <td>4</td>
  <td>0</td>
  <td>1</td>
</tr>
<tr>
  <td>2022-12-04 17:06:19</td>
  <td>1</td>
  <td>100</td>
  <td>1</td>
</tr>
<tr>
  <td>2022-10-08</td>
  <td>1</td>
  <td>8</td>
  <td>1</td>
</tr>
<tr>
  <td>2022-10-10</td>
  <td>1</td>
  <td>30</td>
  <td>1</td>
</tr>
<tr>
  <td>2022-10-09</td>
  <td>1</td>
  <td>87</td>
  <td>1</td>
</tr>
<tr>
  <td>2022-12-04 17:06:19</td>
  <td>2</td>
  <td>1000</td>
  <td>1</td>
</tr>
</table>
</body>


#### METEOROLOGICSTATION

<body>
<table style="border-collapse:collapse">
<tr>
  <th>ID</th>
  <th>NAME</th>
</tr>
<tr>
  <td>45</td>
  <td>Station</td>
</tr>
<tr>
  <td>46</td>
  <td>Station</td>
</tr>
<tr>
  <td>47</td>
  <td>Station</td>
</tr>
<tr>
  <td>48</td>
  <td>Station</td>
</tr>
</table>
</body>


#### PRODUCT

<body>
<table style="border-collapse:collapse">
<tr>
  <th>NAME</th>
  <th>TYPE</th>
  <th>ID</th>
  <th>PRICE</th>
</tr>
<tr>
  <td>Carrot</td>
  <td>TEMPORARY</td>
  <td>1</td>
  <td>1.00</td>
</tr>
<tr>
  <td>Apple</td>
  <td>PERMANENT</td>
  <td>2</td>
  <td>0.80</td>
</tr>
<tr>
  <td>Honey</td>
  <td>TEMPORARY</td>
  <td>3</td>
  <td>3.00</td>
</tr>
<tr>
  <td>Pears</td>
  <td>PERMANENT</td>
  <td>4</td>
  <td>0.75</td>
</tr>
</table>
</body>


#### SECTOR

<body>
<table style="border-collapse:collapse">
<tr>
  <th>ID</th>
  <th>DESIGNATION</th>
  <th>AREA</th>
  <th>EXPLORATION</th>
  <th>METEOROLOGICSTATION</th>
  <th>CULTUREPLAN</th>
  <th>PRODUCT</th>
</tr>
<tr>
  <td>1</td>
  <td>Carrot Filed</td>
  <td>1500</td>
  <td>1</td>
  <td>45</td>
  <td>0</td>
  <td>1</td>
</tr>
<tr>
  <td>2</td>
  <td>Apple Filed</td>
  <td>150000</td>
  <td>1</td>
  <td>46</td>
  <td>0</td>
  <td>2</td>
</tr>
<tr>
  <td>3</td>
  <td>Beehive</td>
  <td>15</td>
  <td>1</td>
  <td>47</td>
  <td>0</td>
  <td>3</td>
</tr>
<tr>
  <td>4</td>
  <td>Pears Field</td>
  <td>10200</td>
  <td>1</td>
  <td>48</td>
  <td>0</td>
  <td>4</td>
</tr>
</table>
</body>


#### SYSTEMUSER

<body>
<table style="border-collapse:collapse">
<tr>
  <th>ID</th>
  <th>EMAIL</th>
  <th>PASSWORD</th>
</tr>
<tr>
  <td>40</td>
  <td>gradle@copy-maven.org</td>
  <td>IwishIwasMav€n</td>
</tr>
<tr>
  <td>38</td>
  <td>system@system.sys</td>
  <td>qwerty123</td>
</tr>
<tr>
  <td>39</td>
  <td>tomcat@java.com</td>
  <td>Catalina</td>
</tr>
</table>
</body>

**NOTE**: Some Ids may alter because of usage of Identity on Insertion!