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