DECLARE
    refCursor Sys_Refcursor;
    clientId  BASKETORDER.CLIENT%type;
    basketId  BASKETORDER.BASKET%type;
    num       BASKETORDER.QUANTITY%type;
    drv       BASKETORDER.DRIVER%type;
    due       BASKETORDER.DUEDATE%type;
    ordDa     BASKETORDER.ORDERDATE%type;
    del       BASKETORDER.DELIVERYDATE%type;
    status    BASKETORDER.STATUS%type;
    addr      BASKETORDER.ADDRESS%type;
    ordNum    BASKETORDER.ORDERNUMBER%type;
    pay       BASKETORDER.PAYED%type;

BEGIN

    refCursor := FNCUS209LISTORDERSBYSTATUS('REGISTERED');
    LOOP
        FETCH refCursor into clientId,basketId,num,drv,ordDa,due,del,status,addr,ordNum,pay;
        EXIT WHEN refCursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Order Number: ' || ordNum || ' <=> '
            || 'Client ID: ' || clientId || ' <=> '
            || 'Basket ID: ' || basketId || ' <=> '
            || 'Order Date: ' || TO_CHAR(ordDa) || ' <=> '
            || 'Payed: ' || pay);
    end loop;
end;

DECLARE
    refCursor Sys_Refcursor;
    clientId  BASKETORDER.CLIENT%type;
    basketId  BASKETORDER.BASKET%type;
    num       BASKETORDER.QUANTITY%type;
    drv       BASKETORDER.DRIVER%type;
    due       BASKETORDER.DUEDATE%type;
    ordDa     BASKETORDER.ORDERDATE%type;
    del       BASKETORDER.DELIVERYDATE%type;
    status    BASKETORDER.STATUS%type;
    addr      BASKETORDER.ADDRESS%type;
    ordNum    BASKETORDER.ORDERNUMBER%type;
    pay       BASKETORDER.PAYED%type;

BEGIN

    refCursor := fncUS209ListOrdersByDateOfOrder();
    LOOP
        FETCH refCursor into clientId,basketId,num,drv,ordDa,due,del,status,addr,ordNum,pay;
        EXIT WHEN refCursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Order Number: ' || ordNum || ' <=> '
            || 'Client ID: ' || clientId || ' <=> '
            || 'Basket ID: ' || basketId || ' <=> '
            || 'Order Date: ' || TO_CHAR(ordDa) || ' <=> '
            || 'Payed: ' || pay);
    end loop;
end;

DECLARE
    refCursor Sys_Refcursor;
    clientId  BASKETORDER.CLIENT%type;
    basketId  BASKETORDER.BASKET%type;
    num       BASKETORDER.QUANTITY%type;
    drv       BASKETORDER.DRIVER%type;
    due       BASKETORDER.DUEDATE%type;
    ordDa     BASKETORDER.ORDERDATE%type;
    del       BASKETORDER.DELIVERYDATE%type;
    status    BASKETORDER.STATUS%type;
    addr      BASKETORDER.ADDRESS%type;
    ordNum    BASKETORDER.ORDERNUMBER%type;
    pay       BASKETORDER.PAYED%type;

BEGIN

    refCursor := fncUS209ListOrdersByClient(1);
    LOOP
        FETCH refCursor into clientId,basketId,num,drv,ordDa,due,del,status,addr,ordNum,pay;
        EXIT WHEN refCursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Order Number: ' || ordNum || ' <=> '
            || 'Client ID: ' || clientId || ' <=> '
            || 'Basket ID: ' || basketId || ' <=> '
            || 'Order Date: ' || TO_CHAR(ordDa) || ' <=> '
            || 'Payed: ' || pay);
    end loop;
end;

DECLARE
    refCursor Sys_Refcursor;
    clientId  BASKETORDER.CLIENT%type;
    basketId  BASKETORDER.BASKET%type;
    num       BASKETORDER.QUANTITY%type;
    drv       BASKETORDER.DRIVER%type;
    due       BASKETORDER.DUEDATE%type;
    ordDa     BASKETORDER.ORDERDATE%type;
    del       BASKETORDER.DELIVERYDATE%type;
    status    BASKETORDER.STATUS%type;
    addr      BASKETORDER.ADDRESS%type;
    ordNum    BASKETORDER.ORDERNUMBER%type;
    pay       BASKETORDER.PAYED%type;

BEGIN

    refCursor := fncUS209ListOrdersById();
    LOOP
        FETCH refCursor into clientId,basketId,num,drv,ordDa,due,del,status,addr,ordNum,pay;
        EXIT WHEN refCursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Order Number: ' || ordNum || ' <=> '
            || 'Client ID: ' || clientId || ' <=> '
            || 'Basket ID: ' || basketId || ' <=> '
            || 'Order Date: ' || TO_CHAR(ordDa) || ' <=> '
            || 'Payed: ' || pay);
    end loop;
end;

DECLARE
    refCursor Sys_Refcursor;
    clientId  BASKETORDER.CLIENT%type;
    basketId  BASKETORDER.BASKET%type;
    num       BASKETORDER.QUANTITY%type;
    drv       BASKETORDER.DRIVER%type;
    due       BASKETORDER.DUEDATE%type;
    ordDa     BASKETORDER.ORDERDATE%type;
    del       BASKETORDER.DELIVERYDATE%type;
    status    BASKETORDER.STATUS%type;
    addr      BASKETORDER.ADDRESS%type;
    ordNum    BASKETORDER.ORDERNUMBER%type;
    pay       BASKETORDER.PAYED%type;

BEGIN

    refCursor := fncUS209ListOrdersByOrderNumber();
    LOOP
        FETCH refCursor into clientId,basketId,num,drv,ordDa,due,del,status,addr,ordNum,pay;
        EXIT WHEN refCursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Order Number: ' || ordNum || ' <=> '
            || 'Client ID: ' || clientId || ' <=> '
            || 'Basket ID: ' || basketId || ' <=> '
            || 'Order Date: ' || TO_CHAR(ordDa) || ' <=> '
            || 'Payed: ' || pay);
    end loop;
end;

DECLARE
    refCursor Sys_Refcursor;
    clientId  BASKETORDER.CLIENT%type;
    basketId  BASKETORDER.BASKET%type;
    num       BASKETORDER.QUANTITY%type;
    drv       BASKETORDER.DRIVER%type;
    due       BASKETORDER.DUEDATE%type;
    ordDa     BASKETORDER.ORDERDATE%type;
    del       BASKETORDER.DELIVERYDATE%type;
    status    BASKETORDER.STATUS%type;
    addr      BASKETORDER.ADDRESS%type;
    ordNum    BASKETORDER.ORDERNUMBER%type;
    pay       BASKETORDER.PAYED%type;
    pri       NUMBER;

BEGIN

    refCursor := fncUS209ListOrdersByPrice();
    LOOP
        FETCH refCursor into clientId,basketId,num,drv,ordDa,due,del,status,addr,ordNum,pay,pri;
        EXIT WHEN refCursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Order Number: ' || ordNum || ' <=> '
            || 'Client ID: ' || clientId || ' <=> '
            || 'Basket ID: ' || basketId || ' <=> '
            || 'Order Date: ' || TO_CHAR(ordDa) || ' <=> '
            || 'Payed: ' || pay || ' <=> '
            || 'Order Price: ' || pri || ' <=> ');
    end loop;
end;
