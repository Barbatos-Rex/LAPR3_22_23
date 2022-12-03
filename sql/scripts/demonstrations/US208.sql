DECLARE
    productionId  PRODUCTIONFACTORS.ID%type;
    explorationId EXPLORATION.ID%type;
BEGIN
    SELECT ID into explorationId FROM EXPLORATION FETCH FIRST ROW ONLY;
    PRCUS208ADDPRODUCTIONFACTOR(1, explorationId, 'Adubo rico em vitaminas e minerais',
        'Pó','ISEP&Co.',productionId);
    PRCUS208ADDENTRYTOPRODUCTIONFACTOR(1,productionId,'Vitamina C','mg/L',10, 'Pó');
    PRCUS208ADDENTRYTOPRODUCTIONFACTOR(1,productionId,'Ferro','mg/L',15, 'Pó');
    PRCUS208ADDENTRYTOPRODUCTIONFACTOR(1,productionId,'Nitrogénio','ppm',110, 'Pó');
    PRCUS208ADDENTRYTOPRODUCTIONFACTOR(1,productionId,'Farinha','g/L',10, 'Pó');
end;


DECLARE
    productionId  PRODUCTIONFACTORS.ID%type;
    explorationId EXPLORATION.ID%type;
BEGIN
    SELECT ID into explorationId FROM EXPLORATION FETCH FIRST ROW ONLY;
    PRCUS208ADDPRODUCTIONFACTOR(1, explorationId, 'Adubo de crescimento rápido',
        'Aquoso','ISEP&Co.',productionId);
    PRCUS208ADDENTRYTOPRODUCTIONFACTOR(1,productionId,'Água','kg/L',.8, 'Pó');
    PRCUS208ADDENTRYTOPRODUCTIONFACTOR(1,productionId,'Café','mg/L',5, 'Pó');
    PRCUS208ADDENTRYTOPRODUCTIONFACTOR(1,productionId,'Redbul','ml',.3, 'Pó');
    PRCUS208ADDENTRYTOPRODUCTIONFACTOR(1,productionId,'Estrume','g',1, 'Pó');
end;