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
    hub          VARCHAR2(5),
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
    hub               VARCHAR2(5),
    PRIMARY KEY (id)
);
CREATE TABLE CropWatering
(
    dateOfAction   date                    NOT NULL,
    sector         number(10)              NOT NULL,
    quantity       number(19, 2) DEFAULT 0 NOT NULL CHECK ( quantity >= 0 ),
    fieldRecording number(10)              NOT NULL,
    operation      NUMBER(10, 0)           NOT NULL,
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
    fieldRecording    number(10)    NOT NULL,
    productionFactors number(10)    NOT NULL,
    dateOfRecording   date DEFAULT SYSDATE,
    operation         NUMBER(10, 0) NOT NULL,
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
    address number(10) ,
    id      VARCHAR2(5)  NOT NULL,
    lat     VARCHAR2(10) NOT NULL,
    lon     VARCHAR(10)  NOT NULL,
    client  varchar2(5)  NOT NULL,
    PRIMARY KEY (id)
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
CREATE TABLE OPERATION
(
    id     NUMBER(10, 0) GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    status VARCHAR2(255) DEFAULT 'PENDING' CHECK ( status = 'PENDING' OR status = 'COMPLETED' OR status = 'CANCELED'),
    markedDate DATE NOT NULL
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
CREATE TABLE ReadingErrors
(
    sensor       varchar2(5),
    numberErrors number(20, 0) DEFAULT 0,
    PRIMARY KEY (sensor)
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
    id           VARCHAR2(5),
    sensorType   VARCHAR2(2)      NOT NULL,
    uniqueNumber NUMBER(2) UNIQUE NOT NULL,
    CONSTRAINT id
        PRIMARY KEY (id)
);
CREATE TABLE SensorReading
(
    dateOfReading date,
    sensor        VARCHAR2(5),
    reading       number(3) NOT NULL CHECK ( reading >= 0 AND reading <= 100),
    PRIMARY KEY (dateOfReading, sensor)
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



CREATE TABLE input_sensor
(
    id           NUMBER(10, 0) GENERATED ALWAYS AS IDENTITY,
    input_string VARCHAR2(25) NOT NULL,
    PRIMARY KEY (id)
);
CREATE TABLE input_hub
(
    id           NUMBER(10, 0) GENERATED ALWAYS AS IDENTITY,
    input_string VARCHAR2(25) NOT NULL,
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
    ADD CONSTRAINT FKClientUserAddressOfDelivery FOREIGN KEY (addressOfDelivery) REFERENCES Address (id);
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
    ADD CONSTRAINT FKCulturePlanSectorId FOREIGN KEY (sector) REFERENCES Sector (id);
ALTER TABLE Valve
    ADD CONSTRAINT FKValveTubularSystemId FOREIGN KEY (tubularSystem) REFERENCES TubularSystem (id);
ALTER TABLE FieldRecording
    ADD CONSTRAINT FKFieldRecordingExplorationId FOREIGN KEY (exploration) REFERENCES Exploration (id);
ALTER TABLE CropWatering
    ADD CONSTRAINT FKCropWateringSectorId FOREIGN KEY (sector) REFERENCES Sector (id);
ALTER TABLE Sector
    ADD CONSTRAINT FKSectorProductId FOREIGN KEY (product) REFERENCES Product (id);
ALTER TABLE SensorReading
    ADD CONSTRAINT FKSensorReadingSensorId FOREIGN KEY (sensor) REFERENCES SENSOR (id);
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
ALTER TABLE ProductionFactorsRecording
    ADD CONSTRAINT FKProductionFactorsRecordingOperationId FOREIGN KEY (operation) REFERENCES OPERATION (id);
ALTER TABLE CropWatering
    ADD CONSTRAINT FKCropWateringOperationId FOREIGN KEY (operation) REFERENCES OPERATION (id);
ALTER TABLE Client
    ADD CONSTRAINT FKClientHub FOREIGN KEY (hub) REFERENCES Hub (id);
ALTER TABLE BasketOrder
    ADD CONSTRAINT FKBasketOrderHub FOREIGN KEY (hub) REFERENCES Hub (id);