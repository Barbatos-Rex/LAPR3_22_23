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
    dateOfAction date          NOT NULL,
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
    dateOfCreation date       NOT NULL,
    price          number(19) NOT NULL,
    PRIMARY KEY (id)
);
CREATE TABLE BasketOrder
(
    client       number(10) NOT NULL,
    basket       number(10) NOT NULL,
    quantity     number(10) NOT NULL,
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
    quantity number(10) DEFAULT 1,
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
    id                number(10)                 NOT NULL,
    address           number(10)                 NOT NULL,
    name              varchar2(255)              NOT NULL,
    nif               number(10)                 NOT NULL,
    plafond           number(10)  DEFAULT 100000 NOT NULL,
    incidents         number(10)  DEFAULT 0      NOT NULL,
    lastIncidentDate  date,
    lastYearOrders    number(10)  DEFAULT 0      NOT NULL,
    lastYearSpent     number(10)  DEFAULT 0      NOT NULL,
    addressOfDelivery number(10)                 NOT NULL,
    priorityLevel     varchar2(1) DEFAULT 'B'    NOT NULL,
    lastYearIncidents number(10)  DEFAULT 0      NOT NULL,
    PRIMARY KEY (id)
);
CREATE TABLE CropWatering
(
    dateOfAction   date                    NOT NULL,
    sector         number(10)              NOT NULL,
    quantity       number(19, 2) DEFAULT 0 NOT NULL,
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
    dateOfRecording   date       NOT NULL,
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
    price number(10, 2) DEFAULT 0 NOT NULL,
    PRIMARY KEY (id)
);
CREATE TABLE ProductionEntry
(
    id    number(10)    NOT NULL,
    value number(10)    NOT NULL,
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
    password varchar2(255) NOT NULL,
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
    ADD CONSTRAINT FKDriver730052 FOREIGN KEY (id) REFERENCES SystemUser (id);
ALTER TABLE FarmingManager
    ADD CONSTRAINT FKFarmingMan732235 FOREIGN KEY (id) REFERENCES SystemUser (id);
ALTER TABLE Client
    ADD CONSTRAINT FKClient543685 FOREIGN KEY (id) REFERENCES SystemUser (id);
ALTER TABLE Client
    ADD CONSTRAINT FKClient934999 FOREIGN KEY (addressOfDelivery) REFERENCES Address (id);
ALTER TABLE DistributionManager
    ADD CONSTRAINT FKDistributi353489 FOREIGN KEY (id) REFERENCES SystemUser (id);
ALTER TABLE Stable
    ADD CONSTRAINT FKStable341189 FOREIGN KEY (id) REFERENCES Building (id);
ALTER TABLE Silos
    ADD CONSTRAINT FKSilos108898 FOREIGN KEY (id) REFERENCES Building (id);
ALTER TABLE MachineryGarage
    ADD CONSTRAINT FKMachineryG460850 FOREIGN KEY (id) REFERENCES Building (id);
ALTER TABLE ProductionZones
    ADD CONSTRAINT FKProduction977652 FOREIGN KEY (id) REFERENCES Building (id);
ALTER TABLE SprinklingSystem
    ADD CONSTRAINT FKSprinkling599100 FOREIGN KEY (id) REFERENCES Building (id);
ALTER TABLE Sector
    ADD CONSTRAINT FKSector30749 FOREIGN KEY (exploration) REFERENCES Exploration (id);
ALTER TABLE Building
    ADD CONSTRAINT FKBuilding437043 FOREIGN KEY (exploration) REFERENCES Exploration (id);
ALTER TABLE ProductionEntry
    ADD CONSTRAINT FKProduction589054 FOREIGN KEY (id) REFERENCES ProductionFactors (id);
ALTER TABLE SprinklingSystem
    ADD CONSTRAINT FKSprinkling29700 FOREIGN KEY (primarySystem) REFERENCES TubularSystem (id);
ALTER TABLE SprinklingSystem
    ADD CONSTRAINT FKSprinkling163735 FOREIGN KEY (secondarySystem) REFERENCES TubularSystem (id);
ALTER TABLE Sensor
    ADD CONSTRAINT FKSensor813125 FOREIGN KEY (station) REFERENCES MeteorologicStation (id);
ALTER TABLE Sector
    ADD CONSTRAINT FKSector385534 FOREIGN KEY (meteorologicStation) REFERENCES MeteorologicStation (id);
ALTER TABLE ExplorationClientele
    ADD CONSTRAINT FKExploratio361648 FOREIGN KEY (client) REFERENCES Client (id);
ALTER TABLE ExplorationClientele
    ADD CONSTRAINT FKExploratio583177 FOREIGN KEY (exploration) REFERENCES Exploration (id);
ALTER TABLE Exploration
    ADD CONSTRAINT FKExploratio60216 FOREIGN KEY (address) REFERENCES Address (id);
ALTER TABLE Client
    ADD CONSTRAINT FKClient395964 FOREIGN KEY (address) REFERENCES Address (id);
ALTER TABLE Hub
    ADD CONSTRAINT FKHub655166 FOREIGN KEY (address) REFERENCES Address (id);
ALTER TABLE BasketOrder
    ADD CONSTRAINT FKBasketOrde928632 FOREIGN KEY (client) REFERENCES Client (id);
ALTER TABLE BasketOrder
    ADD CONSTRAINT FKBasketOrde897679 FOREIGN KEY (basket) REFERENCES Basket (id);
ALTER TABLE CulturePlan
    ADD CONSTRAINT FKCulturePla684700 FOREIGN KEY (sprinklingSystem) REFERENCES SprinklingSystem (id);
ALTER TABLE CulturePlan
    ADD CONSTRAINT FKCulturePla243895 FOREIGN KEY (exploration) REFERENCES Exploration (id);
ALTER TABLE CulturePlan
    ADD CONSTRAINT FKCulturePla394823 FOREIGN KEY (sector) REFERENCES Sector (id);
ALTER TABLE Valve
    ADD CONSTRAINT FKValve616812 FOREIGN KEY (tubularSystem) REFERENCES TubularSystem (id);
ALTER TABLE FieldRecording
    ADD CONSTRAINT FKFieldRecor807369 FOREIGN KEY (exploration) REFERENCES Exploration (id);
ALTER TABLE CropWatering
    ADD CONSTRAINT FKCropWateri752379 FOREIGN KEY (sector) REFERENCES Sector (id);
ALTER TABLE Sector
    ADD CONSTRAINT FKSector700073 FOREIGN KEY (product) REFERENCES Product (id);
ALTER TABLE Harvest
    ADD CONSTRAINT FKHarvest999070 FOREIGN KEY (sector) REFERENCES Sector (id);
ALTER TABLE CropWatering
    ADD CONSTRAINT FKCropWateri427095 FOREIGN KEY (fieldRecording) REFERENCES FieldRecording (exploration);
ALTER TABLE Harvest
    ADD CONSTRAINT FKHarvest791186 FOREIGN KEY (fieldRecording) REFERENCES FieldRecording (exploration);
ALTER TABLE MeteorologicData
    ADD CONSTRAINT FKMeteorolog41417 FOREIGN KEY (fieldRecording) REFERENCES FieldRecording (exploration);
ALTER TABLE MeteorologicData
    ADD CONSTRAINT FKMeteorolog357263 FOREIGN KEY (station) REFERENCES MeteorologicStation (id);
ALTER TABLE ProductionFactorsRecording
    ADD CONSTRAINT FKFieldRecor49323 FOREIGN KEY (fieldRecording) REFERENCES FieldRecording (exploration);
ALTER TABLE ProductionFactorsRecording
    ADD CONSTRAINT FKFieldRecor728316 FOREIGN KEY (productionFactors) REFERENCES ProductionFactors (id);
ALTER TABLE BasketOrder
    ADD CONSTRAINT FKBasketOrde555898 FOREIGN KEY (driver) REFERENCES Driver (id);
ALTER TABLE BasketProduct
    ADD CONSTRAINT FKBasketProd161831 FOREIGN KEY (basket) REFERENCES Basket (id);
ALTER TABLE BasketProduct
    ADD CONSTRAINT FKBasketProd544770 FOREIGN KEY (product) REFERENCES Product (id);
ALTER TABLE AuditLog
    ADD CONSTRAINT FKAuditLog926921 FOREIGN KEY (userId) REFERENCES SystemUser (id);
ALTER TABLE BasketOrder
    ADD CONSTRAINT FKBasketOrde901265 FOREIGN KEY (address) REFERENCES Address (id);
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
INSERT INTO SYSTEMUSER(ID, EMAIL, PASSWORD)
VALUES (0, 'system@system.sys', 'qwerty123');

INSERT INTO EXPLORATION(ID)
VALUES (1);

INSERT INTO PRODUCT(ID, NAME, TYPE)
VALUES (1, 'Carrot', 'TEMPORARY');
INSERT INTO PRODUCT(ID, NAME, TYPE)
VALUES (2, 'Apple', 'PERMANENT');
INSERT INTO PRODUCT(ID, NAME, TYPE)
VALUES (3, 'Honey', 'TEMPORARY');
INSERT INTO PRODUCT(ID, NAME, TYPE)
VALUES (4, 'Pears', 'PERMANENT');

INSERT INTO SECTOR(ID, DESIGNATION, AREA, EXPLORATION, CULTUREPLAN, PRODUCT)
VALUES (1, 'Carrot Filed', 1500, 1, 0, 1);
INSERT INTO SECTOR(ID, DESIGNATION, AREA, EXPLORATION, CULTUREPLAN, PRODUCT)
VALUES (2, 'Apple Filed', 150000, 1, 0, 2);
INSERT INTO SECTOR(ID, DESIGNATION, AREA, EXPLORATION, CULTUREPLAN, PRODUCT)
VALUES (3, 'Beehive', 15, 1, 0, 3);
INSERT INTO SECTOR(ID, DESIGNATION, AREA, EXPLORATION, CULTUREPLAN, PRODUCT)
VALUES (4, 'Pears Field', 10200, 1, 0, 4);

INSERT INTO HARVEST(DATEOFHARVEST, SECTOR, NUMBEROFUNITS)
VALUES (SYSDATE, 1, 100);
INSERT INTO HARVEST(DATEOFHARVEST, SECTOR, NUMBEROFUNITS)
VALUES (TO_DATE('8/10/2022', 'DD/MM/YYYY'), 1, 8);
INSERT INTO HARVEST(DATEOFHARVEST, SECTOR, NUMBEROFUNITS)
VALUES (TO_DATE('10/10/2022', 'DD/MM/YYYY'), 1, 30);
INSERT INTO HARVEST(DATEOFHARVEST, SECTOR, NUMBEROFUNITS)
VALUES (TO_DATE('9/10/2022', 'DD/MM/YYYY'), 1, 87);

INSERT INTO HARVEST(DATEOFHARVEST, SECTOR, NUMBEROFUNITS)
VALUES (SYSDATE, 2, 1000);
INSERT INTO HARVEST(DATEOFHARVEST, SECTOR, NUMBEROFUNITS)
VALUES (TO_DATE('8/10/2022', 'DD/MM/YYYY'), 2, 80);
INSERT INTO HARVEST(DATEOFHARVEST, SECTOR, NUMBEROFUNITS)
VALUES (TO_DATE('10/10/2022', 'DD/MM/YYYY'), 2, 300);
INSERT INTO HARVEST(DATEOFHARVEST, SECTOR, NUMBEROFUNITS)
VALUES (TO_DATE('9/10/2022', 'DD/MM/YYYY'), 2, 870);

INSERT INTO HARVEST(DATEOFHARVEST, SECTOR, NUMBEROFUNITS)
VALUES (SYSDATE, 3, 100);
INSERT INTO HARVEST(DATEOFHARVEST, SECTOR, NUMBEROFUNITS)
VALUES (TO_DATE('8/10/2022', 'DD/MM/YYYY'), 3, 8);
INSERT INTO HARVEST(DATEOFHARVEST, SECTOR, NUMBEROFUNITS)
VALUES (TO_DATE('10/10/2022', 'DD/MM/YYYY'), 3, 200);
INSERT INTO HARVEST(DATEOFHARVEST, SECTOR, NUMBEROFUNITS)
VALUES (TO_DATE('9/10/2022', 'DD/MM/YYYY'), 3, 87);

INSERT INTO HARVEST(DATEOFHARVEST, SECTOR, NUMBEROFUNITS)
VALUES (SYSDATE, 4, 150);
INSERT INTO HARVEST(DATEOFHARVEST, SECTOR, NUMBEROFUNITS)
VALUES (TO_DATE('8/10/2022', 'DD/MM/YYYY'), 4, 86);
INSERT INTO HARVEST(DATEOFHARVEST, SECTOR, NUMBEROFUNITS)
VALUES (TO_DATE('10/10/2022', 'DD/MM/YYYY'), 4, 2);
INSERT INTO HARVEST(DATEOFHARVEST, SECTOR, NUMBEROFUNITS)
VALUES (TO_DATE('9/10/2022', 'DD/MM/YYYY'), 4, 0);


-- Console report visualization --

DECLARE
    val NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Data Report:');
    FOR I IN (SELECT TABLE_NAME FROM USER_TABLES)
        LOOP
            EXECUTE IMMEDIATE 'SELECT count(*) FROM ' || i.table_name INTO val;
            DBMS_OUTPUT.PUT_LINE(i.table_name || ' ==> ' || val);
        END LOOP;
END;
```

### Result Report

#### Exploration

<!DOCTYPE html>
<html>
  
<body>
<table border="0" style="border-collapse:collapse">
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
</html>

#### FieldRecording

<!DOCTYPE html>
<html>
  
<body>
<table border="0" style="border-collapse:collapse">
<tr>
  <th>EXPLORATION</th>
</tr>
<tr>
  <td>1</td>
</tr>
</table>
</body>
</html>

#### Harvest

<!DOCTYPE html>
<html>
<body>
<table border="0" style="border-collapse:collapse">
<tr>
  <th>DATEOFHARVEST</th>
  <th>SECTOR</th>
  <th>NUMBEROFUNITS</th>
  <th>FIELDRECORDING</th>
</tr>
<tr>
  <td>2022-11-19 00:08:56</td>
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
  <td>2022-11-19 00:09:04</td>
  <td>2</td>
  <td>1000</td>
  <td>1</td>
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
  <td>2022-11-19 00:09:04</td>
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
  <td>2022-11-19 00:09:05</td>
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
</table>
</body>
</html>

#### MeteorologicStation

<!DOCTYPE html>
<html>
  
<body>
<table border="0" style="border-collapse:collapse">
<tr>
  <th>ID</th>
  <th>NAME</th>
</tr>
<tr>
  <td>2</td>
  <td>Station</td>
</tr>
<tr>
  <td>3</td>
  <td>Station</td>
</tr>
<tr>
  <td>4</td>
  <td>Station</td>
</tr>
<tr>
  <td>5</td>
  <td>Station</td>
</tr>
</table>
</body>
</html>

#### Product

<!DOCTYPE html>
<html>
  
<body>
<table border="0" style="border-collapse:collapse">
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
  <td>0.90</td>
</tr>
</table>
</body>
</html>

#### Sector

<!DOCTYPE html>
<html>
  
<body>
<table border="0" style="border-collapse:collapse">
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
  <td>2</td>
  <td>0</td>
  <td>1</td>
</tr>
<tr>
  <td>2</td>
  <td>Apple Filed</td>
  <td>150000</td>
  <td>1</td>
  <td>3</td>
  <td>0</td>
  <td>2</td>
</tr>
<tr>
  <td>3</td>
  <td>Beehive</td>
  <td>15</td>
  <td>1</td>
  <td>4</td>
  <td>0</td>
  <td>3</td>
</tr>
<tr>
  <td>4</td>
  <td>Pears Field</td>
  <td>10200</td>
  <td>1</td>
  <td>5</td>
  <td>0</td>
  <td>4</td>
</tr>
</table>
</body>
</html>

#### SystemUser

  
<body>
<table border="0" style="border-collapse:collapse">
<tr>
  <th>ID</th>
  <th>EMAIL</th>
  <th>PASSWORD</th>
</tr>
<tr>
  <td>0</td>
  <td>system@system.sys</td>
  <td>qwerty123</td>
</tr>
</table>
</body>