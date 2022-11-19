# Files to Include

* [CREATE TABLES](./CREATE_TABLES.sql)
* [INITIAL BOOT](./INITIAL_BOOT.sql)
* [DELETE DATABASE](./DELETE_DATABASE.sql)

<!--* [CLEAR DATABASE](./CLEAR_DATABASE.sql)  Will be DEPRECATED-->

# Database Physical Structure

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
  <head>
    <title></title>
    <meta charset="UTF-8">
  </head>
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

### FieldRecording

<!DOCTYPE html>
<html>
  <head>
    <title></title>
    <meta charset="UTF-8">
  </head>
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

### Harvest

<!DOCTYPE html>
<html>
  <head>
    <title></title>
    <meta charset="UTF-8">
  </head>
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

### MeteorologicStation

<!DOCTYPE html>
<html>
  <head>
    <title></title>
    <meta charset="UTF-8">
  </head>
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

### Product

<!DOCTYPE html>
<html>
  <head>
    <title></title>
    <meta charset="UTF-8">
  </head>
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

### Sector

<!DOCTYPE html>
<html>
  <head>
    <title></title>
    <meta charset="UTF-8">
  </head>
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

### SystemUser

  <head>
    <title></title>
    <meta charset="UTF-8">
  </head>
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








