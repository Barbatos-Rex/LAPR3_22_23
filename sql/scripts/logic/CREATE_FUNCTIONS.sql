--DEPRECATED FOR CLIENTS--
CREATE OR REPLACE FUNCTION fncUS205CreateUser(userCallerId IN SYSTEMUSER.ID%type, userType IN VARCHAR2,
                                              userEmail IN SYSTEMUSER.EMAIL%TYPE,
                                              userPassword IN SYSTEMUSER.PASSWORD%TYPE) RETURN SYSTEMUSER.ID%TYPE AS
    userId    SYSTEMUSER.ID%TYPE;
    nullEmail SYSTEMUSER.ID%TYPE;
BEGIN
    SAVEPOINT BeforeCall;
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
        RAISE_APPLICATION_ERROR(-20002,
                                'User type is incorrect! It should be one of the following: [client,driver,farm,distribution]');
    end if;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('New System User ID: ' || userId);
    return userId;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK TO SAVEPOINT BeforeCall;
        RAISE;
end;

CREATE OR REPLACE FUNCTION fncUS205CreateClient(userCallerId IN SYSTEMUSER.ID%type, userEmail IN SYSTEMUSER.EMAIL%type,
                                                addressOfResidence IN ADDRESS.ZIPCODE%type,
                                                addressOfDelivery IN ADDRESS.ZIPCODE%type,
                                                clientName IN CLIENT.NAME%type, clientNIF IN CLIENT.NIF%type,
                                                userPassword in SYSTEMUSER.PASSWORD%type DEFAULT NULL,
                                                clientPlafond IN CLIENT.PLAFOND%type DEFAULT 100000,
                                                clientIncidents IN CLIENT.INCIDENTS%type DEFAULT 0,
                                                clientLastIncidentDate IN CLIENT.LASTINCIDENTDATE%type,
                                                clientLastYearOrders IN CLIENT.LASTYEARORDERS%type DEFAULT 0,
                                                clientLastYearSpent IN CLIENT.LASTYEARSPENT%type DEFAULT 0,
                                                clientPriority IN CLIENT.PRIORITYLEVEL%type DEFAULT 'B',
                                                clientLastYearIncidents IN CLIENT.LASTYEARINCIDENTS%type DEFAULT 0) RETURN SYSTEMUSER.ID%type AS

    clientId           SYSTEMUSER.ID%type;
    tmpDistrict        ADDRESS.DISTRICT%type;
    idAddressResidence ADDRESS.ID%type;
    idAddressDelivery  ADDRESS.ID%type;
    realPassword       SYSTEMUSER.PASSWORD%type;
    resAddr            ADDRESS.ZIPCODE%type;
    devAddr            ADDRESS.ZIPCODE%type;
BEGIN

    if (userPassword IS NULL) then
        realPassword := 'Qwerty123';
    else
        realPassword := userPassword;
    end if;

    if (COALESCE(addressOfDelivery, addressOfResidence) IS NULL) then
        RAISE_APPLICATION_ERROR(-20003, 'Zipcodes cannot be null');
    end if;
    devAddr := addressOfDelivery;
    resAddr := addressOfResidence;
    if (addressOfDelivery IS NULL) THEN
        devAddr := addressOfResidence;
    ELSIF (addressOfResidence IS NULL) THEN
        resAddr := addressOfDelivery;
    end if;
    INSERT INTO ADDRESS(zipcode) VALUES (devAddr) returning ID into idAddressDelivery;
    INSERT INTO ADDRESS(zipcode) VALUES (resAddr) returning ID into idAddressResidence;
    INSERT INTO SYSTEMUSER(EMAIL, PASSWORD) VALUES (userEmail, realPassword) returning ID INTO clientId;
    PRCUS213LOG(userCallerId, 'INSERT',
                'INSERT INTO SYSTEMUSER(EMAIL, PASSWORD) VALUES (' || userEmail || ',' || userPassword ||
                ') returning ID INTO clientId');

    INSERT INTO CLIENT(ID, ADDRESS, NAME, NIF, PLAFOND, INCIDENTS, LASTINCIDENTDATE, LASTYEARORDERS, LASTYEARSPENT,
                       ADDRESSOFDELIVERY, PRIORITYLEVEL, LASTYEARINCIDENTS)
    VALUES (clientId, idAddressResidence, clientName, clientNIF, clientPlafond, clientIncidents, clientLastIncidentDate,
            clientLastYearOrders, clientLastYearSpent, idAddressDelivery, clientPriority, clientLastYearIncidents);
    return clientId;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        RAISE_APPLICATION_ERROR(-20001, 'Email already exists in database!');
        return null;
    WHEN OTHERS THEN
        RAISE;
end;


CREATE OR REPLACE FUNCTION fncUS205ClientRiskFactor(clientId IN CLIENT.ID%TYPE) RETURN NUMERIC AS
    result     NUMERIC;
    tmp        NUMERIC;
    itr        Sys_Refcursor;
    basketId   BASKET.ID%type;
    amount     BASKETORDER.QUANTITY%type;
    incidentsN NUMERIC;
BEGIN
    OPEN itr FOR SELECT BASKETORDER.BASKET, BASKETORDER.QUANTITY
                 FROM BASKETORDER
                          JOIN CLIENT C2 on C2.ID = BASKETORDER.CLIENT
                 WHERE ORDERDATE >= COALESCE(LASTINCIDENTDATE, TO_DATE('01/01/0001', 'DD/MM/YYYY'))
                   AND PAYED = 'N'
                   AND CLIENT = clientId;
    result := 0;
    LOOP
        FETCH itr INTO basketId,amount;
        EXIT WHEN itr%notfound;
        SELECT BASKET.PRICE
        into tmp
        FROM BASKET;
        result := result + tmp * amount;
    end loop;

    SELECT count(*)
    into incidentsN
    FROM BASKETORDER
    WHERE PAYED = 'N'
      AND CLIENT = clientId
      AND ORDERDATE >= SYSDATE - 365
      AND DUEDATE < SYSDATE;
    return result / incidentsN;
EXCEPTION
    WHEN ZERO_DIVIDE THEN
        return 0;
end;

CREATE OR REPLACE FUNCTION fncUS206OrderSectorByDesignation(explorationId IN EXPLORATION.ID%type)
    RETURN SYS_REFCURSOR AS
    result Sys_Refcursor;
BEGIN
    OPEN result for SELECT * FROM SECTOR WHERE EXPLORATION = explorationId ORDER BY DESIGNATION;
    return result;
end;

CREATE OR REPLACE FUNCTION fncUS206OrderSectorBySize(explorationId IN EXPLORATION.ID%type,
                                                     orderType IN VARCHAR2 DEFAULT 'ASC')
    RETURN SYS_REFCURSOR AS
    result Sys_Refcursor;
BEGIN
    if (orderType = 'DESC') then
        OPEN result for SELECT * FROM SECTOR WHERE EXPLORATION = explorationId ORDER BY AREA DESC;
    else
        OPEN result for SELECT * FROM SECTOR WHERE EXPLORATION = explorationId ORDER BY AREA;
    end if;
    return result;
end;

CREATE OR REPLACE FUNCTION fncUS206OrderSectorByCrop(explorationId IN EXPLORATION.ID%type, arg IN VARCHAR2,
                                                     orderType IN VARCHAR2 DEFAULT 'ASC')
    RETURN SYS_REFCURSOR AS
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

CREATE OR REPLACE FUNCTION fncUS207OrderSectorByMaxHarvest(explorationId IN EXPLORATION.ID%type,
                                                           orderType IN VARCHAR2 DEFAULT 'ASC')
    RETURN SYS_REFCURSOR AS
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

CREATE OR REPLACE FUNCTION fncUS207OrderSectorByRentability(explorationId IN EXPLORATION.ID%type,
                                                            orderType IN VARCHAR2 DEFAULT 'ASC')
    RETURN SYS_REFCURSOR as
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

CREATE OR REPLACE FUNCTION fncUS209ListOrdersByStatus(orderStatus BASKETORDER.STATUS%type) RETURN SYS_REFCURSOR AS
    result Sys_Refcursor;
BEGIN
    OPEN result FOR SELECT * FROM BASKETORDER WHERE STATUS = orderStatus;
    return result;
end;

CREATE OR REPLACE FUNCTION fncUS209ListOrdersByDateOfOrder RETURN SYS_REFCURSOR AS
    result Sys_Refcursor;
BEGIN
    OPEN result FOR SELECT * FROM BASKETORDER ORDER BY ORDERDATE;
    return result;
end;

CREATE OR REPLACE FUNCTION fncUS209ListOrdersByClient(idClient BASKETORDER.CLIENT%type) RETURN SYS_REFCURSOR AS
    result Sys_Refcursor;
BEGIN
    OPEN result FOR SELECT * FROM BASKETORDER WHERE CLIENT = idClient ORDER BY ORDERDATE;
    return result;
end;

CREATE OR REPLACE FUNCTION fncUS209ListOrdersById RETURN SYS_REFCURSOR AS
    result Sys_Refcursor;
BEGIN
    OPEN result FOR SELECT * FROM BASKETORDER ORDER BY BASKETORDER.ORDERNUMBER;
    return result;
end;

CREATE OR REPLACE FUNCTION fncUS209ListOrdersByOrderNumber RETURN SYS_REFCURSOR AS
    result Sys_Refcursor;
BEGIN
    OPEN result FOR SELECT * FROM BASKETORDER ORDER BY BASKETORDER.ORDERNUMBER;
    return result;
end;

CREATE OR REPLACE FUNCTION fncUS209ListOrdersByPrice RETURN SYS_REFCURSOR AS
    result Sys_Refcursor;
BEGIN
    OPEN result FOR SELECT CLIENT,
                           BASKET,
                           QUANTITY,
                           DRIVER,
                           ORDERDATE,
                           DUEDATE,
                           DELIVERYDATE,
                           STATUS,
                           ADDRESS,
                           ORDERNUMBER,
                           B.PRICE * PA.QUANTITY as PRICE
                    FROM BASKETORDER PA
                             JOIN BASKET B on B.ID = PA.BASKET
                    ORDER BY PRICE DESC;
    return result;
end;


CREATE OR REPLACE FUNCTION fncUS210GetOperationType(operationId OPERATION.ID%type) RETURN VARCHAR2 AS
    counter INTEGER := 0;
BEGIN
    SELECT count(*) INTO counter FROM PRODUCTIONFACTORSRECORDING WHERE OPERATION = operationId;
    if (counter > 0) THEN
        return 'Production Factor';
    else
        return 'Crop Watering';
    end if;

end;



CREATE OR REPLACE FUNCTION fncUS212GetTheNthSensorReading(entryNumber IN NUMBER(21, 0)) RETURN VARCHAR2(25) AS
    result   VARCHAR2(25);
    tmp      VARCHAR2(25);
    readings NUMBER(20, 0);
    cur      SYS_REFCURSOR;
    tmpC     NUMBER(20, 0);
BEGIN
    result := NULL;
    SELECT count(*) into readings FROM input_sensor;
    if (entryNumber > readings) THEN
        RAISE_APPLICATION_ERROR(-20005, 'There is no entry for the ' || entryNumber || ' position! There are only ' ||
                                        readings || ' entries!');
    end if;
    OPEN cur FOR SELECT * from input_sensor;
    LOOP
        FETCH cur INTO tmp;
        EXIT WHEN cur%notfound;
        if (tmpC = entryNumber) THEN
            result := tmp;
        end if;
        tmpc := tmpC + 1;
    end loop;
    close cur;
    return result;
end;

CREATE OR REPLACE FUNCTION fncUS212IsValidReading(reading IN varchar,
                                                  id OUT VARCHAR2,
                                                  sensorType OUT VARCHAR2,
                                                  value OUT NUMBER,
                                                  uniqueNum OUT NUMBER,
                                                  readingDate OUT date) RETURN boolean AS

    iden       VARCHAR2(5);
    senType    VARCHAR2(2);
    val        VARCHAR2(3);
    idNum      VARCHAR2(2);
    charDate   VARCHAR2(13);
    flag       BOOLEAN      := TRUE;
    dateformat varchar2(15) := 'DDMMYYYYHH:MI';

BEGIN

    iden := SUBSTR(reading, 0, 5);
    senType := SUBSTR(reading, 6, 2);
    val := SUBSTR(reading, 8, 3);
    idNum := SUBSTR(reading, 11, 2);
    charDate := SUBSTR(reading, 13);

    if (iden is null OR senType is null OR val is null OR idNum is null OR charDate is null) then
        flag := FALSE;
    end if;
    id := iden;
    if (NOT (senType = 'HS' OR senType = 'PL' OR senType = 'TS' OR senType = 'VV' OR senType = 'TA'
        OR senType = 'HA' OR senType = 'PA')) THEN
        flag := false;
    end if;
    sensorType := senType;
    if (TO_NUMBER(val, '999') > 100 OR TO_NUMBER(val, '999') < 0) THEN
        flag := false;
    end if;
    value := TO_NUMBER(val, '999');
    uniqueNum := TO_NUMBER(idNum, '99');
    readingDate := TO_DATE(charDate, dateformat);
    return flag;
EXCEPTION
    WHEN OTHERS THEN
        return false;
end;