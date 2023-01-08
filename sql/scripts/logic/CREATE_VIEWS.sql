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




--NOTE:
--      The Sector part of this View may not work because ProductionFactorsRecording does not have sector. However,
--      if ProductionFactorsRecording had a sector, another problem would arise, the conflict
--      between ProductionFactorsRecording and CropWatering sectors, because the way the join was design.
--
--      To mitigate such problem, there are two options: Either restrain the "JOIN" clauses with "RIGHT JOIN" assuring that
--      there is no conflicts or using the "COALESCE" function to make sure that there are no null sectors
CREATE OR REPLACE VIEW OperationCalendar AS
SELECT O.ID                           as OPERATION_ID,
       O.STATUS                       as OPERATION_STATUS,
       O.MARKEDDATE                   as OPERATION_DATE,
       fncUS210GetOperationType(O.ID) as OPERATION_TYPE,
       SECTOR
FROM OPERATION O
         JOIN CROPWATERING CW ON O.ID=CW.OPERATION
         JOIN ProductionFactorsRecording PF ON O.ID=PF.OPERATION
ORDER BY OPERATION_DATE DESC;