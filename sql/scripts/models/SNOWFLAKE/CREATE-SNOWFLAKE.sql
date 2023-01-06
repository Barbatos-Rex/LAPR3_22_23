--SNOWFLAKE MODEL--
CREATE TABLE CLIENT
(
    clientId number(10, 0) NOT NULL,
    nif      number(9, 0)  NOT NULL CHECK ( REGEXP_LIKE(nif, '^[1-4]\d{8}') ),
    PRIMARY KEY (clientId)
);
CREATE TABLE PRODUCT
(
    productId NUMBER(10, 0) NOT NULL,
    type      VARCHAR2(255) NOT NULL,
    name      VARCHAR2(255) NOT NULL,
    PRIMARY KEY (productId)
);
CREATE TABLE PRODUCTNAME
(
    name VARCHAR2(255) NOT NULL PRIMARY KEY
);
CREATE TABLE PRODUCTTYPE
(
    type VARCHAR2(255) NOT NULL PRIMARY KEY
);
CREATE TABLE PRODUCTION
(
    productionId NUMBER(10, 0) NOT NULL,
    timeId       NUMBER(10, 0) NOT NULL,
    sectorId     NUMBER(10, 0) NOT NULL,
    productId    NUMBER(10, 0) NOT NULL,
    amount       NUMBER(10, 0) NOT NULL,
    PRIMARY KEY (productionId)
);
CREATE TABLE SALE
(
    saleId    NUMBER(10, 0) NOT NULL,
    timeId    NUMBER(10, 0) NOT NULL,
    clientId  NUMBER(10, 0) NOT NULL,
    productId NUMBER(10, 0) NOT NULL,
    quantity  NUMBER(10, 0) NOT NULL,
    hub       VARCHAR2(5)   NOT NULL,
    PRIMARY KEY (saleId)
);
CREATE TABLE SECTOR
(
    sectorId    NUMBER(10, 0) NOT NULL,
    name        VARCHAR2(255) NOT NULL,
    exploration NUMBER(10, 0) NOT NULL,
    PRIMARY KEY (sectorId)
);
CREATE TABLE TIME
(
    timeId NUMBER(10, 0) NOT NULL PRIMARY KEY,
    year   NUMBER(4, 0)  NOT NULL,
    month  NUMBER(2, 0)  NOT NULL CHECK ( month BETWEEN 1 AND 12)
);
CREATE TABLE MONTH
(
    month NUMBER(2) NOT NULL CHECK ( month BETWEEN 1 AND 12) PRIMARY KEY
);
CREATE TABLE YEAR
(
    year NUMBER(4) NOT NULL PRIMARY KEY
);
CREATE TABLE HUB
(
    hubId   VARCHAR2(5)  NOT NULL PRIMARY KEY,
    hubType VARCHAR2(10) NOT NULL
);
CREATE TABLE HubType
(
    hubType VARCHAR2(10) NOT NULL PRIMARY KEY
);


ALTER TABLE HUB
    ADD CONSTRAINT FKHubHubType FOREIGN KEY (hubType) REFERENCES HubType (hubType);


ALTER TABLE PRODUCT
    ADD CONSTRAINT FKProductNameId FOREIGN KEY (name) REFERENCES PRODUCTNAME (name);
ALTER TABLE PRODUCT
    ADD CONSTRAINT FKProductTypeId FOREIGN KEY (type) REFERENCES PRODUCTTYPE (type);

ALTER TABLE PRODUCTION
    ADD CONSTRAINT FKProductionSectorId FOREIGN KEY (sectorId) REFERENCES SECTOR (sectorId);
ALTER TABLE PRODUCTION
    ADD CONSTRAINT FKProductionProductId FOREIGN KEY (productId) REFERENCES PRODUCT (productId);
ALTER TABLE PRODUCTION
    ADD CONSTRAINT FKProductionTimeId FOREIGN KEY (timeId) REFERENCES TIME (timeId);


ALTER TABLE SALE
    ADD CONSTRAINT FKSaleClientId FOREIGN KEY (clientId) REFERENCES CLIENT (clientId);
ALTER TABLE SALE
    ADD CONSTRAINT FKSaleProductId FOREIGN KEY (productId) REFERENCES PRODUCT (productId);
ALTER TABLE SALE
    ADD CONSTRAINT FKSaleTimeId FOREIGN KEY (timeId) REFERENCES TIME (timeId);

ALTER TABLE TIME
    ADD CONSTRAINT FKTimeMonthId FOREIGN KEY (month) REFERENCES MONTH (month);
ALTER TABLE TIME
    ADD CONSTRAINT FKTimeYearId FOREIGN KEY (year) REFERENCES YEAR (year);

ALTER TABLE SALE
    ADD CONSTRAINT FKSaleHub FOREIGN KEY (hub) REFERENCES HUB (hubId);

--OPTIONAL BOOT--
DECLARE
    timeC NUMBER(8, 0) := 1;
BEGIN
    FOR yearCounter IN 2016..2021
        LOOP
            INSERT INTO YEAR(YEAR) VALUES (yearCounter);
            FOR monthCounter IN 1..12
                LOOP
                    if (yearCounter = 2016) then
                        INSERT INTO MONTH(MONTH) VALUES (monthCounter);
                    end if;
                    INSERT INTO TIME(TIMEID, YEAR, MONTH) VALUES (timeC, yearCounter, monthCounter);
                    timeC := timeC + 1;
                end loop;
        end loop;
end;

INSERT INTO PRODUCTTYPE(TYPE)
VALUES ('Permanent');
INSERT INTO PRODUCTTYPE(TYPE)
VALUES ('Temporary');

INSERT INTO PRODUCTNAME(NAME)
VALUES ('Apple');
INSERT INTO PRODUCTNAME(NAME)
VALUES ('Pear');
INSERT INTO PRODUCTNAME(NAME)
VALUES ('Banana');
INSERT INTO PRODUCTNAME(NAME)
VALUES ('Honey');
INSERT INTO PRODUCTNAME(NAME)
VALUES ('Carrot');
INSERT INTO PRODUCTNAME(NAME)
VALUES ('Potato');
INSERT INTO PRODUCTNAME(NAME)
VALUES ('Strawberry');
INSERT INTO PRODUCTNAME(NAME)
VALUES ('Asparagus');



INSERT INTO PRODUCT(PRODUCTID, TYPE, NAME)
VALUES (1, 'Permanent', 'Apple');
INSERT INTO PRODUCT(PRODUCTID, TYPE, NAME)
VALUES (2, 'Permanent', 'Pear');
INSERT INTO PRODUCT(PRODUCTID, TYPE, NAME)
VALUES (3, 'Permanent', 'Banana');
INSERT INTO PRODUCT(PRODUCTID, TYPE, NAME)
VALUES (4, 'Permanent', 'Honey');
INSERT INTO PRODUCT(PRODUCTID, TYPE, NAME)
VALUES (5, 'Temporary', 'Carrot');
INSERT INTO PRODUCT(PRODUCTID, TYPE, NAME)
VALUES (6, 'Temporary', 'Potato');
INSERT INTO PRODUCT(PRODUCTID, TYPE, NAME)
VALUES (7, 'Temporary', 'Strawberry');
INSERT INTO PRODUCT(PRODUCTID, TYPE, NAME)
VALUES (8, 'Temporary', 'Asparagus');
INSERT INTO CLIENT(clientId, nif)
VALUES (1, 239745158);
INSERT INTO CLIENT(clientId, nif)
VALUES (2, 219743157);
INSERT INTO CLIENT(clientId, nif)
VALUES (3, 239735153);
INSERT INTO SECTOR(sectorId, name, exploration)
VALUES (1, 'Carrot Field', 1);
INSERT INTO SECTOR(sectorId, name, exploration)
VALUES (2, 'Carrot Field', 2);
INSERT INTO SECTOR(sectorId, name, exploration)
VALUES (3, 'Carrot Field', 3);
INSERT INTO SECTOR(sectorId, name, exploration)
VALUES (4, 'Potato Field', 1);
INSERT INTO SECTOR(sectorId, name, exploration)
VALUES (5, 'Potato Field', 2);
INSERT INTO SECTOR(sectorId, name, exploration)
VALUES (6, 'Potato Field', 3);
INSERT INTO SECTOR(sectorId, name, exploration)
VALUES (7, 'Strawberry Field', 1);
INSERT INTO SECTOR(sectorId, name, exploration)
VALUES (8, 'Strawberry Field', 2);
INSERT INTO SECTOR(sectorId, name, exploration)
VALUES (9, 'Strawberry Field', 3);
INSERT INTO SECTOR(sectorId, name, exploration)
VALUES (10, 'Asparagus Field', 1);
INSERT INTO SECTOR(sectorId, name, exploration)
VALUES (11, 'Asparagus Field', 2);
INSERT INTO SECTOR(sectorId, name, exploration)
VALUES (12, 'Asparagus Field', 3);
INSERT INTO SECTOR(sectorId, name, exploration)
VALUES (13, 'Apple Orchard', 1);
INSERT INTO SECTOR(sectorId, name, exploration)
VALUES (14, 'Apple Orchard', 2);
INSERT INTO SECTOR(sectorId, name, exploration)
VALUES (15, 'Apple Orchard', 3);
INSERT INTO SECTOR(sectorId, name, exploration)
VALUES (16, 'Pear Orchard', 1);
INSERT INTO SECTOR(sectorId, name, exploration)
VALUES (17, 'Pear Orchard', 2);
INSERT INTO SECTOR(sectorId, name, exploration)
VALUES (18, 'Pear Orchard', 3);
INSERT INTO SECTOR(sectorId, name, exploration)
VALUES (19, 'Banana Orchard', 1);
INSERT INTO SECTOR(sectorId, name, exploration)
VALUES (20, 'Banana Orchard', 2);
INSERT INTO SECTOR(sectorId, name, exploration)
VALUES (21, 'Banana Orchard', 3);
INSERT INTO SECTOR(sectorId, name, exploration)
VALUES (22, 'Beehive', 1);
INSERT INTO SECTOR(sectorId, name, exploration)
VALUES (23, 'Beehive', 2);
INSERT INTO SECTOR(sectorId, name, exploration)
VALUES (24, 'Beehive', 3);

INSERT INTO HubType(hubType)
VALUES ('Client');
INSERT INTO HubType(hubType)
VALUES ('Enterprise');
INSERT INTO HubType(hubType)
VALUES ('Producer');

INSERT INTO HUB(hubId, hubType)
VALUES ('H1', 'Client');
INSERT INTO HUB(hubId, hubType)
VALUES ('H2', 'Enterprise');
INSERT INTO HUB(hubId, hubType)
VALUES ('H3', 'Producer');
INSERT INTO HUB(hubId, hubType)
VALUES ('H4', 'Producer');

DECLARE
    saleCounter       NUMBER(10, 0) := 1;
    productionCounter NUMBER(10, 0) := 0;
BEGIN
    FOR hubCounter IN (SELECT hubId FROM HUB)
        LOOP
            FOR clientCounter IN 1..3
                LOOP
                    FOR timeCounter IN 1..72
                        LOOP
                            FOR productCounter IN 1..8
                                LOOP
                                    INSERT INTO SALE(saleId, timeId, clientId, productId, quantity, hub)
                                    VALUES (saleCounter, timeCounter, clientCounter, productCounter,
                                            ROUND(DBMS_RANDOM.VALUE(1, 100000)), hubCounter);
                                    saleCounter := saleCounter + 1;
                                end loop;
                        end loop;
                end loop;
        end loop;
    FOR sectorCounter IN 1..24
        LOOP
            FOR timeCounter IN 1..72
                LOOP
                    FOR productCounter IN 1..8
                        LOOP
                            productionCounter := productionCounter + 1;
                            INSERT INTO PRODUCTION(productionId, timeId, sectorId, productId, amount)
                            VALUES (productionCounter, timeCounter, sectorCounter, productCounter,
                                    ROUND(DBMS_RANDOM.VALUE(1, 100000)));
                            COMMIT;
                        end loop;
                end loop;
        end loop;
end;