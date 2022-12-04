--Address--
DECLARE
    addr ADDRESS.ID%type;
    val  ADDRESS.DISTRICT%type;
BEGIN
    ---Insert to test boundary
    INSERT INTO ADDRESS(ZIPCODE) VALUES ('Dummy') RETURNING ID into addr;
    ---Fetch correct entry
    SELECT DISTRICT into val FROM ADDRESS where ID = addr;
    ----Assert values
    if (val <> 'PORTO') then
        raise_application_error(-20002, 'Assertion failed, default value for district is not "PORTO"!');
    end if;
    ----Clean up excess
    DELETE ADDRESS WHERE ID = addr;
end;

--Audit Log--
DECLARE
    id_ AuditLog.ID%type;
    val AuditLog.DATEOFACTION%type;
BEGIN
    ---Insert to test boundary
    INSERT INTO AUDITLOG(userid, type, command) VALUES (0, 'TEST', 'TEST') RETURNING ID into id_;
    ---Fetch correct entry
    SELECT DATEOFACTION into val FROM AUDITLOG where ID = id_;
    ----Assert values
    ----Clean up excess
    DELETE ADDRESS WHERE id_ = ID;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        raise_application_error(-20002, 'Assertion failed, default value for dateofaction is null!');
        DELETE ADDRESS WHERE id_ = ID;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error');
        RAISE;
end;
--Basket--
DECLARE
    id_ BASKET.ID%type;
BEGIN
    INSERT INTO BASKET(PRICE) VALUES (-11) RETURNING ID into id_;
    DELETE ADDRESS WHERE id_ = ID;
    raise_application_error(-20002, 'Assertion failed, constraint violated for value -11 on PRICE!');
EXCEPTION
    WHEN VALUE_ERROR THEN
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error');
end;

DECLARE
    id_ BASKET.ID%type;
    val BASKET.PRICE%type;
BEGIN
    INSERT INTO BASKET(PRICE) VALUES (5) RETURNING ID into id_;
    SELECT DATEOFACTION into val FROM AUDITLOG where ID = id_;
    DELETE ADDRESS WHERE id_ = ID;
    DBMS_OUTPUT.PUT_LINE('Error');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        raise_application_error(-20002, 'Assertion failed, constraint violated for value -11 on PRICE!');
    WHEN OTHERS THEN
end;




