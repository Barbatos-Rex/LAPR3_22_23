CREATE OR REPLACE PROCEDURE prcUS205AlterClientLastYearInfo(clientId IN SYSTEMUSER.ID%type,
                                                            numberOfOrders IN CLIENT.LASTYEARORDERS%type DEFAULT NULL,
                                                            spentOnOrders IN CLIENT.LASTYEARSPENT%type DEFAULT NULL) as


    newOrders CLIENT.LASTYEARORDERS%type;
    newSpent  CLIENT.LASTYEARSPENT%type;
BEGIN

    SELECT LASTYEARORDERS, LASTYEARSPENT INTO newOrders,newSpent FROM CLIENT WHERE ID = clientId;

    if (numberOfOrders IS NOT NULL) THEN
        newOrders := numberOfOrders;
    end if;

    if (spentOnOrders IS NOT NULL) THEN
        newSpent := spentOnOrders;
    end if;


    UPDATE CLIENT SET LASTYEARORDERS = newOrders, LASTYEARSPENT = newSpent WHERE CLIENT.ID = clientId;
end;



CREATE OR REPLACE PROCEDURE prcUS206CreateSector(userCallerId IN SYSTEMUSER.ID%type,
                                                 designationParam IN Sector.DESIGNATION%type,
                                                 areaParam IN SECTOR.AREA%type,
                                                 explorationId IN SECTOR.EXPLORATION%type,
                                                 productId IN SECTOR.PRODUCT%type, sectorId out SECTOR.ID%type) as
begin
    SAVEPOINT BeforeCall;
    INSERT INTO SECTOR(DESIGNATION, AREA, EXPLORATION, CULTUREPLAN, PRODUCT)
    VALUES (designationParam, areaParam, explorationId, 0, productId)
    RETURNING ID INTO sectorId;
    INSERT INTO AUDITLOG(DATEOFACTION, USERID, TYPE, COMMAND)
    VALUES (sysdate, userCallerId, 'INSERT', 'INSERT INTO SECTOR(DESIGNATION, AREA, EXPLORATION, CULTUREPLAN, PRODUCT)
    VALUES (designationParam, areaParam, explorationId, 0, productId);');
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Added sector to database');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Could not create entry to the database');
        ROLLBACK TO SAVEPOINT BeforeCall;
end;

CREATE OR REPLACE PROCEDURE prcUS208AddProductionFactor(userCallerId in SYSTEMUSER.ID%type,
                                                        fieldRecordingId IN FIELDRECORDING.EXPLORATION%type,
                                                        productName IN PRODUCTIONFACTORS.NAME%type,
                                                        productFormulation IN PRODUCTIONFACTORS.FORMULATION%type,
                                                        supplierName IN PRODUCTIONFACTORS.SUPPLIER%type,
                                                        productFactorId OUT PRODUCTIONFACTORS.ID%type) AS
    dateToUse DATE := sysdate;
BEGIN
    SAVEPOINT BeforeCall;
    INSERT INTO PRODUCTIONFACTORS(NAME, FORMULATION, SUPPLIER)
    VALUES (productName, productFormulation, supplierName)
    returning ID into productFactorId;

    INSERT INTO AUDITLOG(DATEOFACTION, USERID, TYPE, COMMAND)
    VALUES (dateToUse, userCallerId, 'INSERT', 'INSERT INTO PRODUCTIONFACTORS(NAME, FORMULATION,SUPPLIER)
    VALUES (' || productName || ',' || productFormulation || ',' || supplierName || ')');

    INSERT INTO PRODUCTIONFACTORSRECORDING(FIELDRECORDING, PRODUCTIONFACTORS, DATEOFRECORDING)
    VALUES (fieldRecordingId, productFactorId, dateToUse);
    INSERT INTO AUDITLOG(DATEOFACTION, USERID, TYPE, COMMAND)
    VALUES (dateToUse, userCallerId, 'INSERT', 'INSERT INTO PRODUCTIONFACTORSRECORDING(FIELDRECORDING, PRODUCTIONFACTORS, DATEOFRECORDING)
    VALUES (' || fieldRecordingId || ',' || productFactorId || ',' || dateToUse || ')');
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Added factor to the database');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Could not create the entry for the product');
        ROLLBACK TO SAVEPOINT BeforeCall;
end;

CREATE OR REPLACE PROCEDURE prcUS208AddEntryToProductionFactor(userCallerId in SYSTEMUSER.ID%type,
                                                               productFactorId in PRODUCTIONFACTORS.ID%type,
                                                               entryName IN PRODUCTIONENTRY.NAME%type,
                                                               unitName IN PRODUCTIONENTRY.UNIT%type,
                                                               unitValue IN PRODUCTIONENTRY.VALUE%type,
                                                               unitType IN PRODUCTIONENTRY.TYPE%type) AS
BEGIN
    SAVEPOINT BeforeCall;
    INSERT INTO PRODUCTIONENTRY(ID, VALUE, UNIT, TYPE, NAME)
    VALUES (productFactorId, unitValue, unitName, unitType, entryName);
    INSERT INTO AUDITLOG(DATEOFACTION, USERID, TYPE, COMMAND)
    VALUES (sysdate, userCallerId, 'INSERT', 'INSERT INTO PRODUCTIONENTRY(ID, VALUE, UNIT, TYPE, NAME)
    VALUES (' || productFactorId || ',' || unitValue || ',' || unitName || ',' || unitType || ',' || entryName || ')');
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Added entry to the database');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Could add the entry for the product');
        ROLLBACK TO SAVEPOINT BeforeCall;
end;

CREATE OR REPLACE PROCEDURE prcUS209OrderBasket(clientId IN SYSTEMUSER.ID%type, basketId IN BASKETORDER.BASKET%type,
                                                numberOfBaskets IN BASKETORDER.QUANTITY%type,
                                                orderDueDate IN BASKETORDER.DUEDATE%type DEFAULT SYSDATE + 10,
                                                deliveryAddress IN BASKETORDER.ADDRESS%type DEFAULT NULL,
                                                orderDeliveryDate IN BASKETORDER.DELIVERYDATE%type DEFAULT SYSDATE + 30) AS

    unpaidValue   NUMERIC;
    basketPrice   NUMERIC;
    orderPrice    NUMERIC;
    clientPlafond NUMERIC;
BEGIN

    SELECT (SELECT sum(P.PRICE)
            FROM BASKET
                     JOIN BASKETPRODUCT B on BASKET.ID = B.BASKET
                     JOIN PRODUCT P on P.ID = B.PRODUCT
            WHERE BASKET.ID = PARENT.BASKET) * PARENT.QUANTITY
    into unpaidValue
    FROM BASKETORDER PARENT
    WHERE CLIENT = clientId
      AND PAYED = 'N';

    SELECT sum(P.PRICE)
    into basketPrice
    FROM BASKETPRODUCT B
             JOIN PRODUCT P on P.ID = B.PRODUCT
    WHERE B.BASKET = basketId;

    orderPrice := basketPrice * numberOfBaskets;
    SELECT PLAFOND into clientPlafond from CLIENT where ID = clientId;

    if (clientPlafond < orderPrice + unpaidValue) then
        raise_application_error(-20005, 'Order exceeds client plafond limit!');
    end if;

    INSERT INTO BASKETORDER(CLIENT, BASKET, QUANTITY, DUEDATE, DELIVERYDATE, ADDRESS)
    VALUES (clientId, basketId, numberOfBaskets, orderDueDate, orderDeliveryDate, deliveryAddress);

end;

CREATE OR REPLACE PROCEDURE prcUS212TransferInputsToSensorReadings(userCallerID IN SYSTEMUSER.ID%type,
                                                                   numberValid OUT NUMBER,
                                                                   numberInvalid OUT NUMBER) AS
    numValid    NUMBER(20, 0) := 0;
    numInvalid  NUMBER(20, 0) := 0;
    CUR         SYS_REFCURSOR;
    reading     VARCHAR2(25);
    rid         input_sensor.ID%type;
    idSen       VARCHAR2(5);
    senType     VARCHAR2(2);
    value       NUMBER(3);
    uniqueNum   NUMBER(2);
    readingDate date;
    counter     NUMBER(10, 0) := 0;

BEGIN
    open CUR for SELECT * FROM input_sensor;
    LOOP
        FETCH CUR into rid,reading;
        EXIT WHEN CUR%NOTFOUND;
        if (FNCUS212ISVALIDREADING(reading, idSen, senType, value, uniqueNum, readingDate)) then
            numValid := numValid + 1;
            SELECT count(*) into counter FROM SENSOR WHERE SENSOR.ID = idSen;
            if (counter = 0) THEN
                INSERT INTO SENSOR(id, sensortype, uniquenumber) VALUES (idSen, senType, uniqueNum);
                prcUS213LOG(userCallerID, 'INSERT', 'INSERT INTO SENSOR(id, sensortype, uniquenumber) VALUES (' ||
                                                    idSen || ',' || senType || ',' || uniqueNum || ')');
            end if;
            INSERT INTO SENSORREADING(DATEOFREADING, SENSOR, READING) VALUES (readingDate, idSen, value);
            prcUS213LOG(userCallerID, 'INSERT', ' INSERT INTO SENSORREADING(DATEOFREADING, SENSOR, READING) VALUES (' ||
                                                readingDate || ',' || idSen || ',' || value || ')');
            DELETE INPUT_SENSOR WHERE ID = rid;
        else
            numInvalid := numInvalid + 1;
        end if;
    end LOOP;
    numberValid := numValid;
    numberInvalid := numInvalid;
end;

CREATE OR REPLACE PROCEDURE prcUS213LOG(callerId IN SYSTEMUSER.ID%type, logType IN AUDITLOG.TYPE%type,
                                        logCommand IN AUDITLOG.COMMAND%type) AS
BEGIN
    INSERT INTO AUDITLOG(DATEOFACTION, USERID, TYPE, COMMAND) VALUES (sysdate, callerId, logType, logCommand);
end;

CREATE OR REPLACE PROCEDURE prcUS215UpdateHub AS
    cur     SYS_REFCURSOR;
    str     VARCHAR2(25);
    code    VARCHAR(5);
    lat_    VARCHAR2(10);
    lon_    VARCHAR2(10);
    cliCode VARCHAR2(5);
BEGIN
    OPEN cur FOR SELECT input_string FROM INPUT_HUB;
    LOOP
        FETCH CUR INTO str;
        EXIT WHEN cur%NOTFOUND;
        FETCH regexp_substr(str, '[^;]+') into code,lat_,lon_,clicode;
        INSERT INTO HUB(ID, LAT, LON, CLIENT) VALUES (code, lat_, lon_, cliCode);
    end loop;
end;

CREATE OR REPLACE PROCEDURE prcUS215AlterDefaultClientHub(callerId SYSTEMUSER.ID%type, alterUserId SYSTEMUSER.ID%type,
                                                          hubId HUB.ID%type) AS
BEGIN
    UPDATE CLIENT SET hub=hubId WHERE ID = alterUserId;
    prcUS213LOG(callerId, 'UPDATE', 'UPDATE CLIENT SET hub=' || hubId || 'WHERE ID=' || alterUserId);
end;

CREATE OR REPLACE PROCEDURE prcUS215AlterBasketOrderHub(callerId SYSTEMUSER.ID%type,
                                                        basketOrderId BASKETORDER.ORDERNUMBER%type,
                                                        hubId Hub.ID%TYPE) AS
BEGIN
    UPDATE BASKETORDER SET hub=hubId WHERE ORDERNUMBER = basketOrderId;
    prcUS213LOG(callerId, 'UPDATE', 'UPDATE BASKETORDER SET hub=' || hubId || 'WHERE ORDERNUMBER=' || basketOrderId);
END;