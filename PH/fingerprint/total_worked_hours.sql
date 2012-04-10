CREATE OR REPLACE FUNCTION total_worked_hours(character varying, character varying, character varying, character varying)
  RETURNS character varying AS
$BODY$
DECLARE
    timein1C   ALIAS FOR $1;
    timeout1C  ALIAS FOR $2;
    timein2C   ALIAS FOR $3;
    timeout2C  ALIAS FOR $4;
    timein1  timestamp without time zone;
    timein2  timestamp without time zone;
    timeout2 timestamp without time zone;
    timeout1 timestamp without time zone;
    result1 interval;
    result1C varchar(4);
    result2 interval;
    result2C varchar(4);
    result  interval;
    finalresult varchar(20);
BEGIN

    IF timein1C != '' THEN
        IF timeout1C != '' THEN
            timein1  := CAST(timein1C  as timestamp);
            timeout1 := CAST(timeout1C as timestamp);
            result1  := timeout1 - timein1;
        ELSE
            result1C := '0';
        END IF;
    ELSE
        result1C := '0';
    END IF;

    IF timein2C != '' THEN
        IF timeout2C != '' THEN
            timein2  := CAST(timein2C  as timestamp);
            timeout2 := CAST(timeout2C as timestamp);
            result2  := timeout2 - timein2;
        ELSE
            result2C := '0';
        END IF;
    ELSE
        result2C := '0';
    END IF;

    IF result1C = '0' THEN
        IF result2C = '0' THEN
            finalresult := '';
        ELSE 
            result := result2;
            finalresult := CAST(result as varchar);
        END IF;
    ELSE
        IF result2C = '0' THEN
            result := result1;
            finalresult := CAST(result as varchar);
        ELSE
            result := result1 + result2;
            finalresult := CAST(result as varchar);
        END IF;
    END IF;
  
    
    return finalresult;
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION total_worked_hours(character varying, character varying, character varying, character varying)
  OWNER TO postgres;


