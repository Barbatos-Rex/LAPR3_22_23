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
    VALUES (cId, small, 2, 'REGISTERED', addressDelId, 'Y', SYSDATE - 3);
    INSERT INTO BASKETORDER(CLIENT, BASKET, QUANTITY, STATUS, ADDRESS, PAYED, ORDERDATE)
    VALUES (cId, average, 3, 'REGISTERED', addressDelId, 'Y', SYSDATE - 23);
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
    VALUES (cId, small, 2, 'REGISTERED', addressDelId, 'N', SYSDATE - 100, SYSDATE - 90);
    INSERT INTO BASKETORDER(CLIENT, BASKET, QUANTITY, STATUS, ADDRESS, PAYED, ORDERDATE, DUEDATE)
    VALUES (cId, average, 3, 'REGISTERED', addressDelId, 'N', SYSDATE - 23, SYSDATE - 13);
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
    FOR I IN (SELECT TABLE_NAME FROM USER_TABLES)
        LOOP
            EXECUTE IMMEDIATE 'SELECT count(*) FROM ' || i.table_name INTO val;
            DBMS_OUTPUT.PUT_LINE(i.table_name || ' ==> ' || val);
        END LOOP;
END;