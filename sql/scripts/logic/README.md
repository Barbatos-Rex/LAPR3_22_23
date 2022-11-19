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