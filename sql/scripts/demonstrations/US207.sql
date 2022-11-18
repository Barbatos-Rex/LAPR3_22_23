DECLARE
    result        sys_refcursor;
    designation   VARCHAR2(500);
    harvestAmount NUMERIC;
BEGIN
    result := FNCUS207ORDERSECTORBYMAXHARVEST(1,'DESC');

    LOOP
        FETCH result into designation,harvestAmount;
        EXIT WHEN result%notfound;
        DBMS_OUTPUT.PUT_LINE(designation || ' <-> ' || harvestAmount);
    end loop;
end;