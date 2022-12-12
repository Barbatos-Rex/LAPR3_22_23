CREATE OR REPLACE VIEW LastFiveYearsEvolution AS
SELECT P.PRODUCTIONID,
       T.YEAR,
       T.MONTH,
       SECTORID,
       P2.NAME,
       AMOUNT,
       COALESCE(TO_CHAR(getEvolutionOfProductionIn(SECTORID, P2.NAME, T.YEAR, T.MONTH)),
                'Not possible to make a comparison with last month!') as EVOLUTION
FROM PRODUCTION P
         JOIN TIME T on T.TIMEID = P.TIMEID
         JOIN PRODUCT P2 on P2.PRODUCTID = P.PRODUCTID
WHERE T.YEAR >= TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY'), '9999') - 5;

CREATE OR REPLACE VIEW CompareSales AS
SELECT T1.MONTH,
       P.NAME                    as PRODUCT_NAME,
       T1.YEAR                   as FIRST_YEAR,
       S1.QUANTITY               as FIRST_YEAR_SALES,
       T2.YEAR                   as SECOND_YEAR,
       S2.QUANTITY               as SECOND_YEAR_SALES,
       S1.QUANTITY - S2.QUANTITY as YEARS_COMPARISON
FROM SALE S1
         JOIN TIME T1 on S1.TIMEID = T1.TIMEID
         JOIN PRODUCT P on P.PRODUCTID = S1.PRODUCTID,
     SALE S2
         JOIN TIME T2 on T2.TIMEID = S2.TIMEID
WHERE T1.MONTH = T2.MONTH
  AND S1.PRODUCTID = S2.PRODUCTID
  AND S1.CLIENTID = S2.CLIENTID;

CREATE OR REPLACE VIEW MensalEvolutionOfCultureTypes AS
SELECT DISTINCT T.YEAR,
                T.MONTH,
                TYPE,
                sum(QUANTITY) as Quantity,
                COALESCE(TO_CHAR(sum(QUANTITY) - (SELECT DISTINCT SUM(QUANTITY)
                                 FROM PRODUCT Child
                                          JOIN SALE S3 on Child.PRODUCTID = S3.PRODUCTID
                                          JOIN TIME T2 on T2.TIMEID = S3.TIMEID
                                 WHERE Child.TYPE = Parent.TYPE
                                   AND T2.TIMEID = (SELECT TIMEID
                                                    FROM TIME T3
                                                    WHERE (T3.MONTH = T.MONTH - 1 AND T3.YEAR = T.YEAR)
                                                       OR (T3.YEAR = T.YEAR - 1 AND T3.MONTH = 12)
                                                    ORDER BY YEAR DESC, MONTH FETCH FIRST ROW ONLY))),'There are no values to compare!') as COMPARISON
FROM PRODUCT Parent
         JOIN SALE S2 on Parent.PRODUCTID = S2.PRODUCTID
         JOIN TIME T on T.TIMEID = S2.TIMEID
GROUP BY T.YEAR, T.MONTH, TYPE
ORDER BY T.YEAR, T.MONTH;