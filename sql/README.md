# Database Naming Conventions, Documents and Scripts

This document serves as the aggregation of all the small reports related to the database
that are scattered along this project. This project will have into account the following topics:

1. [Database Naming Conventions](#database-naming-conventions)
2. [Docs](#docs)
3. [Scripts](#scripts)
4. [Database Physical Structure](#database-physical-structure)
5. [Database Logic](#database-logic)


# Database Naming Conventions

## Rules

* **Table names** must not include protected keywords for Oracle SQL (ex. User, Dual, Start, etc.)
* **Table names** must follow the proper Camel case with the first letter of name capitalized (ex. Sensor, WaterSensor, Fertilizer, etc. What not to follow: sensor, waterSensor, PoTassicfertilizer,etc.)
* **Table Attributes** must follow proper camel case with first character not capitalized (ex. amount, numberOfSensors, cultivationType, etc.),
* **Table Attributes Constraints**, if inside table creation, may (or may not) have a dedicated name (ex. check (regex_like(code,"\d{8}\w{3}"))).
* **Table Attributes Constraints**, if outside table, as an alter table, it must have a name as the following form CC[TABLE_NAME]_[DESCRIPTION], where CC is the type of constraint (see constraint table in use), [TABLE_NAME] is the name of the table and [DESCRIPTION] is a description to identify what the constraint aims to achieve
* **Primary Key[s]** must be as simple as possible, using camel case, with first character uncapitalized, and, in preference, one word long (ex. code, name, id. What not to follow: idOfTeam, teamId, teamID, ID, Id, iD, idTeam, etc.)
* **Foreign Key[s]** must follow the same rules as **Primary Key[s]** and the name must be related to the relation that results in the **Foreign Key[s]** (ex. Assume entity *Music (M)* has multiple *CD (C)*, *M* "1" -> "1..N" *C*, then the **Foreign Key[s]** name in entity *Music* must be **cd**, and not cdCode, codeOfCd, fkCD, cdFK, etc. )
* Functions must follow the convention fncUS[NNN][Designation], where NNN is the number of the US stated in the requirements and the description the function main goal, in Camel Case
* Procedures must follow the convention prcUS[NNN][Designation], where NNN is the number of the US stated in the requirements and the description the procedure main goal, in Camel Case
* Triggers must follow the convention trg[Designation], where designation is the triggers main goal, in Camel Case
## Table Resume

|         Database Entity         | Rule                                                                                                                                                                                                                                                                                                                              |
|:-------------------------------:|:----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|         **Table Name**          | Must not include protected keywords for Oracle SQL (ex. User, Dual, Start, etc.)                                                                                                                                                                                                                                                  |
|                                 | Must follow the proper Camel case with the first letter of name capitalized (ex. Sensor, WaterSensor, Fertilizer, etc. What not to follow: sensor, waterSensor, PoTassicfertilizer,etc.)                                                                                                                                          |
|       **Table Attribute**       | Must follow proper camel case with first character not capitalized (ex. amount, numberOfSensors, cultivationType, etc.)                                                                                                                                                                                                           |
| **Table Attributes Constraint** | If inside table creation, may (or may not) have a dedicated name (ex. check (regex_like(code,"\d{8}\w{3}"))).                                                                                                                                                                                                                     |
|                                 | If outside table, as an alter table, it must have a name as the following form CC[TABLE_NAME]_[DESCRIPTION], where CC is the type of constraint (see constraint table in use), [TABLE_NAME] is the name of the table and [DESCRIPTION] is a description to identify what the constraint aims to achieve                           |
|       **Primary Key[s]**        | Must be as simple as possible, using camel case, with first character uncapitalized, and, in preference, one word long (ex. code, name, id. What not to follow: idOfTeam, teamId, teamID, ID, Id, iD, idTeam, etc.)                                                                                                               |
|       **Foreign Key[s]**        | Must follow the same rules as **Primary Key[s]** and the name must be related to the relation that results in the **Foreign Key[s]** (ex. Assume entity *Music (M)* has multiple *CD (C)*, *M* "1" -> "1..N" *C*, then the **Foreign Key[s]** name in entity *Music* must be **cd**, and not cdCode, codeOfCd, fkCD, cdFK, etc. ) |
|          **Function**           | Functions must follow the convention fncUS[NNN][Designation], where NNN is the number of the US stated in the requirements and the description the function main goal, in Camel Case                                                                                                                                              |                                                                                                                                                                                                                                                                                                                        |
|          **Procedure**          | Procedures must follow the convention prcUS[NNN][Designation], where NNN is the number of the US stated in the requirements and the description the procedure main goal, in Camel Case                                                                                                                                            |
|           **Trigger**           | Triggers must follow the convention trg[Designation], where designation is the triggers main goal, in Camel Case                                                                                                                                                                                                                  |


## Constraints Table

| Constraint Name | Constraint Key |
|:---------------:|:--------------:|
|   Foreign Key   |     **FK**     |
|   Primary Key   |     **PK**     |
|    Not Null     |     **NN**     |
|     Unique      |     **UQ**     |
|     Default     |     **DF**     |
|      Index      |     **ID**     |

Note: The SQL syntax is case insensitive, so for everything that is related to Camel case, it only applies to diagrams and documentation.

# Docs

* [Check isolated file](./docs/README.md)


# Scripts

* [Check isolated file (Database Structure)](./scripts/structure/README.md)
* [Check isolated file (Database Logic)](./scripts/logic/README.md)

# Database Physical Structure

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
    id number(10),
    PRIMARY KEY (id)
);
CREATE TABLE AuditLog
(
    id           number(10),
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
    id             number(10),
    dateOfCreation date       NOT NULL,
    price          number(19) NOT NULL,
    PRIMARY KEY (id)
);
CREATE TABLE BasketOrder
(
    client   number(10) NOT NULL,
    basket   number(10) NOT NULL,
    quantity number(10) NOT NULL,
    driver   number(10) NOT NULL,
    PRIMARY KEY (client,
                 basket)
);
CREATE TABLE BasketProduct
(
    basket  number(10) NOT NULL,
    product number(10) NOT NULL,
    PRIMARY KEY (basket,
                 product)
);
CREATE TABLE Building
(
    id          number(10),
    exploration number(10) NOT NULL,
    PRIMARY KEY (id)
);
CREATE TABLE Client
(
    id      number(10) NOT NULL,
    address number(10),
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
    id      number(10),
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
CREATE TABLE FieldRecording_ProductionFactors
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
    id    number(10),
    price number(10, 2) DEFAULT 0 NOT NULL,
    PRIMARY KEY (id)
);
CREATE TABLE ProductionEntry
(
    id    number(10)    NOT NULL,
    value varchar2(255) NOT NULL,
    unit  number(10)    NOT NULL,
    type  varchar2(255) NOT NULL,
    PRIMARY KEY (id)
);
CREATE TABLE ProductionFactors
(
    id          number(10),
    name        varchar2(255) NOT NULL,
    formulation varchar2(255) NOT NULL,
    PRIMARY KEY (id)
);
CREATE TABLE ProductionZones
(
    id number(10) NOT NULL,
    PRIMARY KEY (id)
);
CREATE TABLE Sector
(
    id                  number(10),
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
    id      number(10),
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
    id       number(10),
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
    id            number(10),
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
ALTER TABLE FieldRecording_ProductionFactors
    ADD CONSTRAINT FKFieldRecor49323 FOREIGN KEY (fieldRecording) REFERENCES FieldRecording (exploration);
ALTER TABLE FieldRecording_ProductionFactors
    ADD CONSTRAINT FKFieldRecor728316 FOREIGN KEY (productionFactors) REFERENCES ProductionFactors (id);
ALTER TABLE BasketOrder
    ADD CONSTRAINT FKBasketOrde555898 FOREIGN KEY (driver) REFERENCES Driver (id);
ALTER TABLE BasketProduct
    ADD CONSTRAINT FKBasketProd161831 FOREIGN KEY (basket) REFERENCES Basket (id);
ALTER TABLE BasketProduct
    ADD CONSTRAINT FKBasketProd544770 FOREIGN KEY (product) REFERENCES Product (id);
ALTER TABLE AuditLog
    ADD CONSTRAINT FKAuditLog926921 FOREIGN KEY (userId) REFERENCES SystemUser (id);
```

## Delete Database

```sql
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
DROP TABLE FieldRecording_ProductionFactors CASCADE CONSTRAINTS PURGE;
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

# Database Logic

## Files to Include

* [CREATE PROCEDURES](./CREATE_PROCEDURES.sql)
* [DELETE PROCEDURES](./DELETE_PROCEDURES.sql)
* [CREATE FUNCTIONS](./CREATE_FUNCTIONS.sql)
* [DELETE FUNCTIONS](./DELETE_FUNCTIONS.sql)
* [CREATE TRIGGERS](./CREATE_TRIGGERS.sql)
* [DELETE TRIGGERS](./DELETE_TRIGGERS.sql)

## Procedures

### US206

#### prcUS206CreateSector

This procedure has the objective to create a sector in the database, receiving the necessary parameters for such
functionality and archiving the
command on the AuditLog Table. This procedure will also return an out only variable with the sector id created.

```sql
CREATE OR REPLACE PROCEDURE prcUS206CreateSector(userCallerId IN SYSTEMUSER.ID%type,
                                                 designationParam IN Sector.DESIGNATION%type,
                                                 areaParam IN SECTOR.AREA%type,
                                                 explorationId IN SECTOR.EXPLORATION%type,
                                                 productId IN SECTOR.PRODUCT%type, sectorId out SECTOR.ID%type) as
begin
    INSERT INTO SECTOR(DESIGNATION, AREA, EXPLORATION, CULTUREPLAN, PRODUCT)
    VALUES (designationParam, areaParam, explorationId, 0, productId);
    INSERT INTO AUDITLOG(DATEOFACTION, USERID, TYPE, COMMAND)
    VALUES (sysdate, userCallerId, 'INSERT', 'INSERT INTO SECTOR(DESIGNATION, AREA, EXPLORATION, CULTUREPLAN, PRODUCT)
    VALUES (designationParam, areaParam, explorationId, 0, productId);');

    SELECT ID
    into sectorId
    FROM SECTOR
    WHERE DESIGNATION = designationParam
      AND PRODUCT = productId
      AND EXPLORATION = explorationId
    ORDER BY ID DESC FETCH FIRST ROW ONLY;
end;
```

```sql
DROP PROCEDURE PRCUS206CREATESECTOR;
```

## Functions

### US205

Como Gestor Agrícola, quero gerir os meus clientes, empresas ou particulares, que
compram os bens produzidos na minha exploração agrícola.

Critério de Aceitação:

1. Um utilizador pode inserir um novo Cliente no Base de Dados, com os dados que descrevem
   um cliente, sem a necessidade de escrever código SQL. Se a inserção for bem-sucedida, o utilizador
   é informado sobre o valor da chave primária do novo cliente
2. Quando o processo de inserção falha, o utilizador é informado sobre o erro que pode ter
   ocorrido.

#### fncUS205CreateUser

To create an SystemUser into the database, this function will receive all the necessary information for its
functionality and will
try to create the user, archiving as records the results. Firstly, the function will validate if the chosen email is not
yet taken,
if that is not the case, the function will raise an error.

Then, the function will register the SystemUser, associating with the correct type of SystemUser via the *userType*
variable
creating the record into the correct table. The function will print the user id and will return such value.

```sql
CREATE OR REPLACE FUNCTION fncUS205CreateUser(userCallerId IN SYSTEMUSER.ID%type, userType IN VARCHAR2,
                                              userEmail IN SYSTEMUSER.EMAIL%TYPE,
                                              userPassword IN SYSTEMUSER.PASSWORD%TYPE) RETURN SYSTEMUSER.ID%TYPE AS
    userId    SYSTEMUSER.ID%TYPE;
    nullEmail SYSTEMUSER.ID%TYPE;
BEGIN
    SELECT EMAIL into nullEmail FROM SYSTEMUSER WHERE EMAIL = userEmail;

    if (nullEmail is not null) then
        RAISE_APPLICATION_ERROR(-20001, 'Email already exists in database!');
    end if;

    INSERT INTO SYSTEMUSER(EMAIL, PASSWORD) VALUES (userEmail, userPassword);
    INSERT INTO AUDITLOG(DATEOFACTION, USERID, TYPE, COMMAND)
    VALUES (sysdate, userCallerId, 'INSERT',
            'INSERT INTO SYSTEMUSER(EMAIL, PASSWORD) VALUES (' || userEmail || ',' || userPassword || ');');
    SELECT ID into userId FROM SYSTEMUSER WHERE EMAIL = userEmail;
    if (lower(userType) = 'client') then
        INSERT INTO CLIENT(ID) VALUES (userId);
        INSERT INTO AUDITLOG(DATEOFACTION, USERID, TYPE, COMMAND)
        VALUES (sysdate, userCallerId, 'INSERT', 'INSERT INTO CLIENT(ID) VALUES (' || userId || ');');
    elsif (lower(userType) = 'driver') then
        INSERT INTO DRIVER(ID) VALUES (userId);
        INSERT INTO AUDITLOG(DATEOFACTION, USERID, TYPE, COMMAND)
        VALUES (sysdate, userCallerId, 'INSERT', 'INSERT INTO DRIVER(ID) VALUES (' || userId || ');');
    elsif (lower(userType) = 'farm') then
        INSERT INTO FARMINGMANAGER(ID) VALUES (userId);
        INSERT INTO AUDITLOG(DATEOFACTION, USERID, TYPE, COMMAND)
        VALUES (sysdate, userCallerId, 'INSERT', 'INSERT INTO FARMINGMANAGER(ID) VALUES (' || userId || ');');
    elsif (lower(userType) = 'distribution') then
        INSERT INTO DISTRIBUTIONMANAGER(ID) VALUES (userId);
        INSERT INTO AUDITLOG(DATEOFACTION, USERID, TYPE, COMMAND)
        VALUES (sysdate, userCallerId, 'INSERT', 'INSERT INTO DISTRIBUTIONMANAGER(ID) VALUES (' || userId || ');');
    else
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20001,
                                'User type is incorrect! It should be one of the following: [client,driver,farm,distribution]');
    end if;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('New System User ID: ' || userId);
    return userId;
end;
```

```sql
DROP FUNCTION FNCUS205CREATEUSER;
```

### US206

Como Gestor Agrícola, quero manter a estrutura da minha exploração agrícola – contendo
um conjunto de Setores – atualizada, ou seja, quero especificar cada um dos Setores. As suas
características, como tipo de cultivo e cultivo, devem ser configuradas.

Critério de Aceitação:

1. Um utilizador pode criar Setores numa exploração agrícola Biológica especificando suas
   características.
2. É possível definir novos tipos de características parametrizadas, como tipo de cultura ou
   cultura entre outras.
3. Um utilizador podem listar os Setores de sua exploração agrícola ordenados por ordem
   alfabética.
4. Um utilizador podem listar os Setores de sua exploração agrícola ordenados por tamanho, em
   ordem crescente ou decrescente.
5. Um utilizador podem listar os Setores de sua exploração agrícola ordenados por tipo de cultura
   e cultura.

#### fncUS206OrderSectorByDesignation

To order the sectors in the most convenient way possible, this function will open a cursor for
the selection of the sectors from the exploration with *explorationId* and order them (the sectors) by their
designation, alphabetically.

After having the result, the function returns the cursor containing a list of elements
with the ```Sector%ROWTYPE``` profile.

```sql
CREATE OR REPLACE FUNCTION fncUS206OrderSectorByDesignation(explorationId IN EXPLORATION.ID%type) RETURN SYS_REFCURSOR AS
    result Sys_Refcursor;
BEGIN
    OPEN result for SELECT * FROM SECTOR WHERE EXPLORATION = explorationId ORDER BY DESIGNATION;
    return result;
end;
```

```sql
DROP FUNCTION fncUS206OrderSectorByDesignation;
```

#### fncUS206OrderSectorBySize

To order the sectors, by size, in the most convenient way possible, this function will open a cursor for
the selection of the sectors from the exploration with *explorationId* and order them (the sectors) by their
area by, depending on the criteria passed as parameter by *orderType*, ascending or descending order.

After having the result, the function returns the cursor containing a list of elements with the ```Sector%ROWTYPE```
profile.

```sql
CREATE OR REPLACE FUNCTION fncUS206OrderSectorBySize(explorationId IN EXPLORATION.ID%type,
                                                     orderType IN VARCHAR2 DEFAULT 'ASC') RETURN SYS_REFCURSOR AS
    result Sys_Refcursor;
BEGIN
    if (orderType = 'DESC') then
        OPEN result for SELECT * FROM SECTOR WHERE EXPLORATION = explorationId ORDER BY AREA DESC;
    else
        OPEN result for SELECT * FROM SECTOR WHERE EXPLORATION = explorationId ORDER BY AREA;
    end if;
    return result;
end;
```

```sql
DROP FUNCTION fncUS206OrderSectorBySize;
```

#### fncUS206OrderSectorByCrop

To order the sectors, by crop type or name (depending on the argument *arg*), in the most convenient way possible, this
function will open a cursor for
the selection of the sectors from the exploration with *explorationId*, inner joining the sectors with the products on
their productId and order such results,
depending on the criteria passed as parameter by *orderType*, ascending or descending order.

After having the result, the function returns the cursor containing a list of elements
with the ```{SECTOR.ID%type, SECTOR.DESIGNATION%type, PRODUCT.NAME%type, PRODUCT.TYPE%type}``` profile.

```sql
CREATE OR REPLACE FUNCTION fncUS206OrderSectorByCrop(explorationId IN EXPLORATION.ID%type,
                                                     arg IN VARCHAR2 DEFAULT 'TYPE',
                                                     orderType IN VARCHAR2 DEFAULT 'ASC') RETURN SYS_REFCURSOR AS
    result Sys_Refcursor;
BEGIN
    if (arg = 'TYPE') then
        if (orderType = 'DESC') then
            OPEN result for SELECT SECTOR.ID, DESIGNATION, P.NAME, P.TYPE
                            FROM SECTOR
                                     JOIN PRODUCT P on P.ID = SECTOR.PRODUCT
                            WHERE EXPLORATION = explorationId
                            ORDER BY P.TYPE DESC;
        else
            OPEN result for SELECT SECTOR.ID, DESIGNATION, P.NAME, P.TYPE
                            FROM SECTOR
                                     JOIN PRODUCT P on P.ID = SECTOR.PRODUCT
                            WHERE EXPLORATION = explorationId
                            ORDER BY P.TYPE;
        end if;

    else
        if (orderType = 'DESC') then
            OPEN result for SELECT SECTOR.ID, DESIGNATION, P.NAME, P.TYPE
                            FROM SECTOR
                                     JOIN PRODUCT P on P.ID = SECTOR.PRODUCT
                            WHERE EXPLORATION = explorationId
                            ORDER BY P.NAME DESC;
        else
            OPEN result for SELECT SECTOR.ID, DESIGNATION, P.NAME, P.TYPE
                            FROM SECTOR
                                     JOIN PRODUCT P on P.ID = SECTOR.PRODUCT
                            WHERE EXPLORATION = explorationId
                            ORDER BY P.NAME;
        end if;
    end if;
    return result;
end;
```

```sql
DROP FUNCTION fncUS206OrderSectorByCrop;
```

### US207

Como Gestor Agrícola, quero saber o quão rentáveis são os setores da minha exploração
agrícola.

Critério de Aceitação:

1. Um utilizador pode listar os Setores de sua exploração agrícola ordenados por ordem
   decrescente da quantidade de produção em uma determinada safra, medida em toneladas por
   hectare.
2. Um utilizador pode listar os Setores de sua exploração agrícola ordenados por ordem
   decrescente do lucro por hectare em uma determinada safra, medido em K€ por hectare.

#### fncUS207OrderSectorByMaxHarvest

To order the sectors, by harvest, in the most convenient way possible, this function will open a cursor for
the selection of the sectors from the exploration with *explorationId*, inner joining the sectors with the harvests on
their sectorId, grouping the results by sectorId and sectorDesignation, finding the maximum harvest of said group and
order such results,
depending on the criteria passed as parameter by *orderType*, ascending or descending order.

After having the result, the function returns the cursor containing a list of elements
with the ```{SECTOR.DESIGNATION%type, HARVEST.NUMBEROFUNITS%type}``` profile.

```sql
CREATE OR REPLACE FUNCTION fncUS207OrderSectorByMaxHarvest(explorationId IN EXPLORATION.ID%type,
                                                           orderType IN VARCHAR2 DEFAULT 'ASC') RETURN SYS_REFCURSOR AS
    result SYS_REFCURSOR;
BEGIN
    if (orderType = 'DESC') then
        OPEN result FOR SELECT S.DESIGNATION, max(H.NUMBEROFUNITS) as HARVEST
                        FROM SECTOR S
                                 JOIN HARVEST H on S.ID = H.SECTOR
                        WHERE S.EXPLORATION = explorationId
                        GROUP BY S.ID, S.DESIGNATION
                        ORDER BY HARVEST DESC;
    else
        OPEN result FOR SELECT S.DESIGNATION, max(H.NUMBEROFUNITS) as HARVEST
                        FROM SECTOR S
                                 JOIN HARVEST H on S.ID = H.SECTOR
                        WHERE S.EXPLORATION = explorationId
                        GROUP BY S.ID, S.DESIGNATION
                        ORDER BY HARVEST;
    end if;
    return result;
end;
```

```sql
DROP FUNCTION fncUS207OrderSectorByMaxHarvest;
```

####  fncUS207OrderSectorByRentability

To order the sectors, by harvest, in the most convenient way possible, this function will open a cursor for
the selection of the sectors from the exploration with *explorationId*, inner joining the sectors with the harvests on
their sectorId and inner joining, yet again, with the products on productId, grouping the results by sectorDesignation and 
productPrice, finding the average harvest of said group, multiplying the average amount by the price by unit of each product
ordering such results, depending on the criteria passed as parameter by *orderType*, ascending or descending order.

After having the result, the function returns the cursor containing a list of elements
with the ```{SECTOR.DESIGNATION%type, NUMERIC}``` profile.


```sql
CREATE OR REPLACE FUNCTION fncUS207OrderSectorByRentability(explorationId IN EXPLORATION.ID%type,
                                                            orderType IN VARCHAR2 DEFAULT 'ASC') RETURN SYS_REFCURSOR as
    result Sys_Refcursor;
BEGIN
    IF (orderType = 'DESC') then
        OPEN result FOR SELECT S.DESIGNATION, avg(H.NUMBEROFUNITS) * P.PRICE
                        FROM SECTOR S
                                 JOIN PRODUCT P on P.ID = S.PRODUCT
                                 JOIN HARVEST H on S.ID = H.SECTOR
                        WHERE S.EXPLORATION = explorationId
                        GROUP BY S.DESIGNATION, P.PRICE
                        ORDER BY 2 DESC;
    else
        OPEN result FOR SELECT S.DESIGNATION, avg(H.NUMBEROFUNITS) * P.PRICE
                        FROM SECTOR S
                                 JOIN PRODUCT P on P.ID = S.PRODUCT
                                 JOIN HARVEST H on S.ID = H.SECTOR
                        WHERE S.EXPLORATION = explorationId
                        GROUP BY S.DESIGNATION, P.PRICE
                        ORDER BY 2;
    end if;
    return result;
end;
```

```sql
DROP FUNCTION fncUS207OrderSectorByRentability;
```

## Triggers

### trgCreateMeteorologicStation

This triggers guarantees that any sector that is inserted into the database will receive its
own meteorologic station with the generic name 'Station' that can be altered in the future.

```sql
CREATE OR REPLACE TRIGGER trgCreateMeteorologicStation
    BEFORE INSERT
    ON SECTOR
    FOR EACH ROW
    WHEN ( new.METEOROLOGICSTATION is NULL )
BEGIN
    INSERT INTO METEOROLOGICSTATION(NAME) VALUES ('Station') returning ID into :new.METEOROLOGICSTATION;
end;
```
```sql
DROP TRIGGER trgCreateMeteorologicStation;
```
### trgCreateFieldRecording

This triggers auto creates the field recording of an exploration upon its creation

```sql
CREATE OR REPLACE TRIGGER trgCreateFieldRecording
    AFTER INSERT
    ON EXPLORATION
    FOR EACH ROW
BEGIN
    INSERT INTO FIELDRECORDING VALUES (:NEW.ID);
end;
```
```sql
DROP TRIGGER trgCreateFieldRecording;
```
### trgFindFieldRecording

This triggers guarantees that an harvest is connected to the correct field report

```sql
CREATE OR REPLACE TRIGGER trgFindFieldRecording
    BEFORE INSERT
    ON HARVEST
    FOR EACH ROW
    WHEN ( new.FIELDRECORDING IS NULL )

BEGIN
    SELECT EXPLORATION into :new.FIELDRECORDING FROM SECTOR WHERE ID = :new.SECTOR;
end;
```

```sql
DROP TRIGGER trgFindFieldRecording;
```