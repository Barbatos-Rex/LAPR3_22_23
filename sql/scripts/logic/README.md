# Database Logic

## Files to Include

* [CREATE PROCEDURES](./CREATE_PROCEDURES.sql)
* [DELETE PROCEDURES](./DELETE_PROCEDURES.sql)
* [CREATE FUNCTIONS](./CREATE_FUNCTIONS.sql)
* [DELETE FUNCTIONS](./DELETE_FUNCTIONS.sql)
* [CREATE TRIGGERS](./CREATE_TRIGGERS.sql)
* [DELETE TRIGGERS](./DELETE_TRIGGERS.sql)
* [CREATE VIEWS](./CREATE_VIEWS.sql)
* [DELETE VIEWS](./DELETE_VIEWS.sql)

## Procedures

### US205

#### prcUS205AlterClientLastYearInfo

This procedure has the objective of altering the client's information regarding last year operations, recieving the id
of the client,
the number of orders and the amount spent on said orders, updating said information.

```sql
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
```

```sql
DROP PROCEDURE prcUS205AlterClientLastYearInfo;
```

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
    SAVEPOINT BeforeCall;
    INSERT INTO SECTOR(DESIGNATION, AREA, EXPLORATION, CULTUREPLAN, PRODUCT)
    VALUES (designationParam, areaParam, explorationId, 0, productId) RETURNING ID INTO sectorId;
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
```

```sql
DROP PROCEDURE PRCUS206CREATESECTOR;
```

### US208

Como Gestor Agrícola, quero manter os fatores de produção classificados por tipo
(fertilizante, correctivo mineral, produto fitofármaco, etc.), incluindo a sua ficha técnica – que deve
ser persistida na base de dados.

Critério de Aceitação:

1. Um utilizador pode configurar fatores de produção.
2. É possível persistir na base de dados uma ficha técnica semelhante à da Fig. 3.
    1. O modelo de dados inclui as tabelas necessárias para persistir fichas técnicas
    2. Está disponível o código para persistir uma ficha técnica (nome comercial, fornecedor,
       tipo de fator de produção) e cada um dos seus elementos (categoria, como por exemplo
       SUSTÂNCIA ORGÂNICAS, substância, quantidade e unidade)

#### prcUS208AddProductionFactor

This function will add an entry to the production factors used in the exploration, receiving the id of the user
who called this function, the id of the exploration, the commercial name of the product, the formulation of the product,
the name of the supplier chain or enterprise and will return the id of said factor.

```sql
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
```

```sql
DROP FUNCTION prcUS208AddProductionFactor;
```

#### prcUS208AddEntryToProductionFactor

This function will add an entry to the composition of a certain production factor used in the exploration, receiving the
id of the user
who called this function, the id of the factor, the name of the entry, the unit of the entry (ex. mL, Kg/m^3, etc.),
the amount present on the product and the type of the entry.

```sql
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
```

```sql
DROP PROCEDURE prcUS208AddEntryToProductionFactor;
```

### prcUS209OrderBasket

This procedure will order a certain amount of a basket to an user; it will receive the id of the client, the id of the
basket,
the amount of baskets, the due date to pay the order, the address to deliver the basket, the probable date of deliver of
the product.
For that, this procedure will validate if the order (plus all the unpaid orders) surpasses the plafond of the client,
proceeding with the order if the plafond is not exceeded.

```sql
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
      AND PAYED='N';

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
```

```sql
DROP PROCEDURE prcUS209OrderBasket;
```

## Functions

### US205

Como Gestor Agrícola, quero gerir os meus clientes, empresas ou particulares, que
compram os bens produzidos na minha exploração agrícola. Um cliente é caracterizado por um
código interno, nome, número fiscal, email, morada de correspondência, morada de entrega,
plafond, número de incidentes, data do último incidente, número de encomendas colocadas no
último ano, valor total das encomendas colocadas no último ano. A morada deve incluir o código
postal que é utilizado para análises de vendas. O plafond é o limite máximo de crédito atribuído o
cliente – os clientes não podem ter um valor total de encomendas pendentes de pagamento superior
ao seu plafond. Os incidentes – pagamentos de encomendas que não foram efetuados na data de
vencimento, são caracterizados por cliente, valor, data em que ocorreram e data em que foram
sanados e devem ser registados. A cada cliente é atribuído um nível (A, B, C) que caracteriza o seu
valor para o negócio. Clientes que não tenham incidentes reportados nos últimos 12 meses e que
tenham um volume total de vendas (encomendas pagas) no mesmo período superior a 10000€ são
do nível A; clientes sem incidentes reportados nos últimos 12 meses e que tenham um volume total
de vendas (encomendas pagas) no mesmo período superior a 5000€ são do nível B; clientes que
tenham incidentes reportados nos últimos 12 meses são do nível C independentemente do volume
de vendas.

Critério de Aceitação:

1. Um utilizador pode inserir um novo Cliente na Base de Dados, com os dados que descrevem
   um cliente, sem a necessidade de escrever código SQL. Se a inserção for bem-sucedida, o utilizador
   é informado sobre o valor da chave primária do novo cliente
2. Quando o processo de inserção falha, o utilizador é informado sobre o erro que pode ter
   ocorrido.
3. O administrador pode executar um procedimento que atualiza o número e o valor total das
   encomendas colocadas no último ano por cada cliente
4. Criar uma View que agregue para cada cliente:
    1. o seu nível (A, B, C),
    2. a data do último incidente – ou a menção “Sem incidentes à data” caso não tenha
       incidentes reportados
    3. o volume total de vendas (encomendas pagas) nos últimos 12 meses e
    4. o volume total das encomendas já entregues mas ainda pendentes de pagamento.
5. implemente uma função que retorna o fator de risco de um cliente. O fator de risco de um
   cliente é dado pelo rácio entre o valor total dos incidentes observados nos últimos 12 meses e o
   número de encomendas colocadas depois do último incidente e ainda pendentes de pagamento. Por
   exemplo, um cliente que tenha um total de incidentes de 2400€ e tenha feito 3 encomendas depois
   do último incidente que ainda não pagou tem um fator de risco de 800€ (2400/3)

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
```

```sql
DROP FUNCTION FNCUS205CREATEUSER;
```

#### fncUS205ClientRiskFactor

This function calculates the risk factor of a certain user. For that, it requires the id of the user; firstly, it finds
all the orders that are late an
then calculates the missing amount. Then it counts the number of incidents in the last 365 days and returns the ratio
between the missing amount and the number
of incidents in the last 365 days.

```sql
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
                   AND PAYED = 'N' AND CLIENT=clientId;
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
```

```sql
DROP FUNCTION fncUS205ClientRiskFactor;
```

#### fncUS205CreateClient

This function will create a client in the database. For that, the function will receive all the necessary information for validating if the password is not null
and if it is, will use the default one, verify if both addresses are null, if no more that one is null, the function will override the null one with
the value of the not null, then, finally, will create the user and the client taking into account all the information, logging any database alteration.

```sql
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
    PRCUS000LOG(userCallerId, 'INSERT',
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
```

```sql
DROP FUNCTION fncUS205CreateClient;
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
CREATE OR REPLACE FUNCTION fncUS206OrderSectorByDesignation(explorationId IN EXPLORATION.ID%type)
    RETURN SYS_REFCURSOR AS
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
```

```sql
DROP FUNCTION fncUS207OrderSectorByMaxHarvest;
```

#### fncUS207OrderSectorByRentability

To order the sectors, by harvest, in the most convenient way possible, this function will open a cursor for
the selection of the sectors from the exploration with *explorationId*, inner joining the sectors with the harvests on
their sectorId and inner joining, yet again, with the products on productId, grouping the results by sectorDesignation
and
productPrice, finding the average harvest of said group, multiplying the average amount by the price by unit of each
product
ordering such results, depending on the criteria passed as parameter by *orderType*, ascending or descending order.

After having the result, the function returns the cursor containing a list of elements
with the ```{SECTOR.DESIGNATION%type, NUMERIC}``` profile.

```sql
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
```

```sql
DROP FUNCTION fncUS207OrderSectorByRentability;
```

### US209

#### fncUS209ListOrdersByStatus
This function will simply return a cursor with the result of all the orders
with a certain status
````sql
CREATE OR REPLACE FUNCTION fncUS209ListOrdersByStatus(orderStatus BASKETORDER.STATUS%type) RETURN SYS_REFCURSOR AS
    result Sys_Refcursor;
BEGIN
    OPEN result FOR SELECT * FROM BASKETORDER WHERE STATUS = orderStatus;
    return result;
end;
````

```sql
DROP FUNCTION fncUS209ListOrdersByStatus;
```

#### fncUS209ListOrdersByDateOfOrder
This function will simply return a cursor with the result of all the orders
sorted by order by their ordering date
```sql
CREATE OR REPLACE FUNCTION fncUS209ListOrdersByDateOfOrder RETURN SYS_REFCURSOR AS
    result Sys_Refcursor;
BEGIN
    OPEN result FOR SELECT * FROM BASKETORDER ORDER BY ORDERDATE;
    return result;
end;
```

```sql
DROP FUNCTION fncUS209ListOrdersByDateOfOrder;
```

#### fncUS209ListOrdersByClient
This function will simply return a cursor with the result of all the orders of a certain client
sorted by order by their ordering date
```sql
CREATE OR REPLACE FUNCTION fncUS209ListOrdersByClient(idClient BASKETORDER.CLIENT%type) RETURN SYS_REFCURSOR AS
    result Sys_Refcursor;
BEGIN
    OPEN result FOR SELECT * FROM BASKETORDER WHERE CLIENT = idClient ORDER BY ORDERDATE;
    return result;
end;
```

```sql
DROP FUNCTION fncUS209ListOrdersByClient;
```

#### fncUS209ListOrdersById
This function will simply return a cursor with the result of all the orders 
sorted by order by their number

```sql
CREATE OR REPLACE FUNCTION fncUS209ListOrdersById RETURN SYS_REFCURSOR AS
    result Sys_Refcursor;
BEGIN
    OPEN result FOR SELECT * FROM BASKETORDER ORDER BY BASKETORDER.ORDERNUMBER;
    return result;
end;
```

```sql
DROP FUNCTION fncUS209ListOrdersById;
```

#### fncUS209ListOrdersByOrderNumber

This function will simply return a cursor with the result of all the orders 
sorted by order number

```sql
CREATE OR REPLACE FUNCTION fncUS209ListOrdersByOrderNumber RETURN SYS_REFCURSOR AS
    result Sys_Refcursor;
BEGIN
    OPEN result FOR SELECT * FROM BASKETORDER ORDER BY BASKETORDER.ORDERNUMBER;
    return result;
end;
```

```sql
DROP FUNCTION fncUS209ListOrdersByOrderNumber;
```

#### fncUS209ListOrdersByPrice

This function will list all orders by their price. For that, it is necessary to
join the table of orders with the table of baskets to obtain the price of the basket, multiplying by
the number of ordered baskets.

```sql
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
```
```sql
DROP FUNCTION fncUS209ListOrdersByPrice;
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

## Views

### ClientView

This view has the objective of presenting all the information about all the clients in a convenient way. To calculate
the number of orders that
have been payed by each client, a sub-query that counts every entry on the orders by client, is payed and whose date is
after 365 days in the past was used.
To calculate the number of orders still awaiting payment, but delivered, a sub-query that counts every entry on the
orders by client,
is not payed and is delivered.

```sql
CREATE OR REPLACE VIEW ClientView AS
SELECT ID                                                          AS "Client's ID",
       NAME                                                        AS "Client's Name",
       PRIORITYLEVEL                                               AS "Client Level",
       COALESCE(TO_CHAR(LASTINCIDENTDATE), 'No incidents to date') AS "Reported Incidents",
       (SELECT count(*)
        FROM BASKETORDER B
        WHERE CParent.ID = B.CLIENT
          AND B.PAYED = 'Y'
          AND B.ORDERDATE > SYSDATE - 365)                         AS "Number of payed orders",
       (SELECT count(*)
        FROM BASKETORDER
        WHERE CLIENT = CParent.ID
          AND STATUS = 'DELIVERED'
          AND PAYED = 'N')                                         AS "Number of orders awaiting payment"
FROM CLIENT CParent;
```

```sql
DROP VIEW CLIENTVIEW;
```