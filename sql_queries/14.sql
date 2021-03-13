--Find in which subject the students received the most retakes.

CREATE OR REPLACE TYPE objRetakeSubject IS OBJECT (
  retake_count         NUMBER,
  ders_kod         VARCHAR(200)
);
----------------------------------------------

CREATE OR REPLACE TYPE tblRetakeSubject IS TABLE OF objRetakeSubject;
----------------------------------------------

CREATE OR REPLACE PACKAGE pkgFinance AS
FUNCTION getRetakeSubject RETURN tblRetakeSubject;
END pkgFinance;


----------------------------------------------

CREATE OR REPLACE PACKAGE BODY pkgFinance AS

    FUNCTION getRetakeSubject RETURN tblRetakeSubject AS 

        tbl tblRetakeSubject := tblRetakeSubject();
        
        retake_count NUMBER(20);
        ders_kod    VARCHAR(200);
        

    BEGIN
    
        FOR rec IN (SELECT retake_count,ders_kod FROM (SELECT count(STUD_ID) AS retake_count,ders_kod
                      FROM course_selections
                      WHERE QIYMET_HERF = 'F' OR QIYMET_HERF = 'FX' GROUP BY ders_kod
                      ORDER BY retake_count DESC)where rownum=1)
    
        LOOP
          retake_count := rec.retake_count;
           ders_kod := rec.ders_kod;
            
            tbl.EXTEND;
            tbl(tbl.LAST) := objRetakeSubject(retake_count,ders_kod );

      END LOOP;
   RETURN(tbl);

    END getRetakeSubject;

END pkgFinance;
----------------------------------------------
SELECT * FROM TABLE(pkgFinance.getRetakeSubject());


                      