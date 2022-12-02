DECLARE
    cId Number;
BEGIN
    cID := FNCUS205CREATECLIENT(1, '1190387@isep.ipp.pt', '4445-245, Alfena', '4445-245 Alfena', 'André Luís Gomes',
                                269845157, 'Qw€rty1234567', 10, 0, null);
    DBMS_OUTPUT.PUT_LINE('New system user ID is ' || cId);
end;

DECLARE
    cId Number;
BEGIN
    cID := FNCUS205CREATECLIENT(1, '1190387@isep.ipp.pt', '4445-245, Alfena', '4445-245 Alfena', 'André Luís Gomes',
                                269845157, 'Qw€rty1234567', 10, 0, null);
    DBMS_OUTPUT.PUT_LINE('New system user ID is ' || cId);
end;

DECLARE
    cId Number;
BEGIN
    cID := FNCUS205CREATECLIENT(1, '0190387@isep.ipp.pt', '4445-245, Alfena', '4445-245 Alfena', 'Andrew Luis Gomez',
                                269845158, 'Qw€rty1234567', 10, 0, null, 100,
                                133 * 50.12, 'A', 0);
    DBMS_OUTPUT.PUT_LINE('New system user ID is ' || cId);
end;

DECLARE
    cId Number;
BEGIN
    cID := FNCUS205CREATECLIENT(1, '0090387@isep.ipp.pt', null, null, 'Andrew Luis Gomez',
                                266842158, 'Qw€rty1234567', 10, 0, null, 100,
                                133 * 50.12, 'A', 0);
    DBMS_OUTPUT.PUT_LINE('New system user ID is ' || cId);
end;

call PRCUS205ALTERCLIENTLASTYEARINFO(2,100,5589781.22);
SELECT * FROM CLIENTVIEW;