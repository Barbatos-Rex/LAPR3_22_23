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


CREATE OR REPLACE VIEW AuditSimpleScan AS
SELECT USERID       as "User Id",
       EMAIL        as "User Email",
       DATEOFACTION as "Date of Action",
       TYPE         as "Action Type"
FROM AUDITLOG
         JOIN SYSTEMUSER S on AUDITLOG.USERID = S.ID
ORDER BY "Date of Action";

CREATE OR REPLACE VIEW AuditCompleteScan AS
SELECT USERID       as "User Id",
       EMAIL        as "User Email",
       DATEOFACTION as "Date of Action",
       TYPE         as "Action Type",
       COMMAND      as "Command Performed"
FROM AUDITLOG
         JOIN SYSTEMUSER S on AUDITLOG.USERID = S.ID
ORDER BY "Date of Action";