DECLARE
    sectorId SECTOR.ID%type;
begin
    PRCUS206CREATESECTOR(1, 'Pear Field', 75201, 1, 4, sectorId);
    DBMS_OUTPUT.PUT_LINE('New Sector ID: ' || sectorId);
end;

declare
    sectorBody   SECTOR%rowtype;
    sectorCursor Sys_Refcursor;
begin
    sectorCursor := FNCUS206ORDERSECTORBYDESIGNATION(1);
    loop
        FETCH sectorCursor into sectorBody;
        exit when sectorCursor%notfound;
        DBMS_OUTPUT.PUT_LINE(sectorBody.ID || ' <-> ' || sectorBody.DESIGNATION);
    end loop;
end;

declare
    sectorBody   SECTOR%rowtype;
    sectorCursor Sys_Refcursor;
begin
    sectorCursor := FNCUS206ORDERSECTORBYSIZE(1, 'ASC');
    loop
        FETCH sectorCursor into sectorBody;
        exit when sectorCursor%notfound;
        DBMS_OUTPUT.PUT_LINE(sectorBody.AREA || ' <-> ' || sectorBody.DESIGNATION);
    end loop;
end;

declare
    productName  VARCHAR2(500);
    productType  VARCHAR2(500);
    sectorName   VARCHAR2(500);
    idSector     SECTOR.ID%type;
    sectorCursor Sys_Refcursor;
begin
    sectorCursor := FNCUS206ORDERSECTORBYCROP(1, 'PRODUCT', 'DESC');
    loop
        FETCH sectorCursor into idSector,sectorName,productName,productType;
        exit when sectorCursor%notfound;
        DBMS_OUTPUT.PUT_LINE(productName || ' <-> ' || ' <-> ' || productType || ' <-> ' ||
                             sectorName);
    end loop;
end;