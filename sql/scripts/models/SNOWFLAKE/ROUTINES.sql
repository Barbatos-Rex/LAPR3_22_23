CREATE OR REPLACE FUNCTION getEvolutionOfProductionIn(sector IN PRODUCTION.SECTORID%type, prod IN PRODUCTNAME.NAME%type,
                                                      y IN TIME.YEAR%type, m IN TIME.MONTH%type) RETURN NUMBER AS
    amountCurrent NUMBER(10, 0);
    amountPast    NUMBER(10, 0);
    tmpM          NUMBER(2, 0);
    tmpY          NUMBER(4, 0);
begin
    SELECT AMOUNT
    into amountCurrent
    FROM PRODUCTION
             JOIN PRODUCT P on P.PRODUCTID = PRODUCTION.PRODUCTID
             JOIN TIME T on T.TIMEID = PRODUCTION.TIMEID
    WHERE SECTORID = sector
      AND P.NAME = prod
      AND T.YEAR = y
      AND T.MONTH = m;
    tmpY := y;
    tmpM := m - 1;
    if (tmpM <= 0) THEN
        tmpM := 12;
        tmpY := tmpY - 1;
    end if;
    SELECT AMOUNT
    into amountPast
    FROM PRODUCTION
             JOIN PRODUCT P on P.PRODUCTID = PRODUCTION.PRODUCTID
             JOIN TIME T on T.TIMEID = PRODUCTION.TIMEID
    WHERE SECTORID = sector
      AND P.NAME = prod
      AND T.YEAR = tmpY
      AND T.MONTH = tmpM;
    return amountCurrent - amountPast;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        return NULL;
end;