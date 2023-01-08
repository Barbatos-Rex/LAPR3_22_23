--STAR MODEL--
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
    exploration VARCHAR2(255) NOT NULL,
    PRIMARY KEY (sectorId)
);
CREATE TABLE TIME
(
    timeId NUMBER(10, 0) NOT NULL PRIMARY KEY,
    year   NUMBER(4, 0)  NOT NULL,
    month  NUMBER(2, 0)  NOT NULL CHECK ( month BETWEEN 1 AND 12)
);
-- CREATE TABLE HUB
-- (
--     hubId   VARCHAR2(5)   NOT NULL PRIMARY KEY,
--     hubType VARCHAR2(255) NOT NULL
-- );


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
-- ALTER TABLE SALE
--     ADD CONSTRAINT FKSaleHubId FOREIGN KEY (hub) references HUB (hubId);


--OPTIONAL BOOT--
DECLARE
--     yearCounter  NUMBER(4, 0);
--     monthCounter NUMBER(2, 0);
    timeC             NUMBER(8, 0)  := 1;
    saleCounter       NUMBER(10, 0) := 0;
    productionCounter NUMBER(10, 0) := 0;
    hubId             HUB.HUBID%type;

BEGIN
    FOR yearCounter IN 2016..2021
        LOOP
            FOR monthCounter IN 1..12
                LOOP
                    INSERT INTO TIME(TIMEID, YEAR, MONTH) VALUES (timeC, yearCounter, monthCounter);
                    timeC := timeC + 1;
                end loop;
        end loop;

    INSERT INTO PRODUCT(PRODUCTID, TYPE, NAME) VALUES (1, 'Permanent', 'Apple');
    INSERT INTO PRODUCT(PRODUCTID, TYPE, NAME) VALUES (2, 'Permanent', 'Pear');
    INSERT INTO PRODUCT(PRODUCTID, TYPE, NAME) VALUES (3, 'Permanent', 'Banana');
    INSERT INTO PRODUCT(PRODUCTID, TYPE, NAME) VALUES (4, 'Permanent', 'Honey');
    INSERT INTO PRODUCT(PRODUCTID, TYPE, NAME) VALUES (5, 'Temporary', 'Carrot');
    INSERT INTO PRODUCT(PRODUCTID, TYPE, NAME) VALUES (6, 'Temporary', 'Potato');
    INSERT INTO PRODUCT(PRODUCTID, TYPE, NAME) VALUES (7, 'Temporary', 'Strawberry');
    INSERT INTO PRODUCT(PRODUCTID, TYPE, NAME) VALUES (8, 'Temporary', 'Asparagus');

    INSERT INTO CLIENT(clientId, nif) VALUES (1, 239745158);
    INSERT INTO CLIENT(clientId, nif) VALUES (2, 219743157);
    INSERT INTO CLIENT(clientId, nif) VALUES (3, 239735153);

    INSERT INTO SECTOR(sectorId, name, exploration) VALUES (1, 'Carrot Field', 1);
    INSERT INTO SECTOR(sectorId, name, exploration) VALUES (2, 'Carrot Field', 2);
    INSERT INTO SECTOR(sectorId, name, exploration) VALUES (3, 'Carrot Field', 3);
    INSERT INTO SECTOR(sectorId, name, exploration) VALUES (4, 'Potato Field', 1);
    INSERT INTO SECTOR(sectorId, name, exploration) VALUES (5, 'Potato Field', 2);
    INSERT INTO SECTOR(sectorId, name, exploration) VALUES (6, 'Potato Field', 3);
    INSERT INTO SECTOR(sectorId, name, exploration) VALUES (7, 'Strawberry Field', 1);
    INSERT INTO SECTOR(sectorId, name, exploration) VALUES (8, 'Strawberry Field', 2);
    INSERT INTO SECTOR(sectorId, name, exploration) VALUES (9, 'Strawberry Field', 3);
    INSERT INTO SECTOR(sectorId, name, exploration) VALUES (10, 'Asparagus Field', 1);
    INSERT INTO SECTOR(sectorId, name, exploration) VALUES (11, 'Asparagus Field', 2);
    INSERT INTO SECTOR(sectorId, name, exploration) VALUES (12, 'Asparagus Field', 3);
    INSERT INTO SECTOR(sectorId, name, exploration) VALUES (13, 'Apple Orchard', 1);
    INSERT INTO SECTOR(sectorId, name, exploration) VALUES (14, 'Apple Orchard', 2);
    INSERT INTO SECTOR(sectorId, name, exploration) VALUES (15, 'Apple Orchard', 3);
    INSERT INTO SECTOR(sectorId, name, exploration) VALUES (16, 'Pear Orchard', 1);
    INSERT INTO SECTOR(sectorId, name, exploration) VALUES (17, 'Pear Orchard', 2);
    INSERT INTO SECTOR(sectorId, name, exploration) VALUES (18, 'Pear Orchard', 3);
    INSERT INTO SECTOR(sectorId, name, exploration) VALUES (19, 'Banana Orchard', 1);
    INSERT INTO SECTOR(sectorId, name, exploration) VALUES (20, 'Banana Orchard', 2);
    INSERT INTO SECTOR(sectorId, name, exploration) VALUES (21, 'Banana Orchard', 3);
    INSERT INTO SECTOR(sectorId, name, exploration) VALUES (22, 'Beehive', 1);
    INSERT INTO SECTOR(sectorId, name, exploration) VALUES (23, 'Beehive', 2);
    INSERT INTO SECTOR(sectorId, name, exploration) VALUES (24, 'Beehive', 3);


    FOR clientCounter IN 1..3
        LOOP
            FOR timeCounter IN 1..72
                LOOP
                    FOR productCounter IN 1..8
                        LOOP
                            INSERT INTO SALE(saleId, timeId, clientId, productId, quantity, hub)
                            VALUES (saleCounter, timeCounter, clientCounter, productCounter,
                                    ROUND(DBMS_RANDOM.VALUE(1, 100000)), hubId);
                            saleCounter := saleCounter + 1;
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