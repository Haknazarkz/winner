--Teacher rating for the semester (list)

CREATE OR REPLACE TYPE objTeachersRateByYear IS OBJECT ( --task11
  rate            NUMBER,
  teacher_id      NUMBER,
  term            NUMBER,
  year            NUMBER
);

------------------------------------------------------------------------
CREATE OR REPLACE TYPE tblTeachersRateByYear IS TABLE OF objTeachersRateByYear; 

------------------------------------------------------------------------
CREATE OR REPLACE PACKAGE pkgTeacher AS
FUNCTION getTeachersRateByYear(semester IN NUMBER, g_year NUMBER) RETURN tblTeachersRateByYear;  --Function For Task11
END pkgTeacher;

------------------------------------------------------------------------

CREATE OR REPLACE PACKAGE BODY pkgTeacher AS
    
    FUNCTION getTeachersRateByYear(semester IN NUMBER, g_year NUMBER) RETURN tblTeachersRateByYear --Function Task11
    IS
        tbl tblTeachersRateByYear := tblTeachersRateByYear();
        
        max_rate    NUMBER(10);
        teacher_id  NUMBER(10);
        term        NUMBER(10);
        l_year      NUMBER(10);
        
        CURSOR cur IS SELECT 
            count(practice) AS TEACHER_RATE, 
            practice AS TEACHER_ID,
            term AS SEMESTER,
            year
        FROM course_selections
            WHERE term = semester AND year = g_year AND practice IS NOT NULL
        GROUP BY practice, term, year
        ORDER BY TEACHER_RATE DESC;
    
    BEGIN
    
        OPEN cur;
            LOOP FETCH cur INTO
                max_rate,
                teacher_id,
                term,
                l_year;
            EXIT WHEN cur%NOTFOUND;
            
            tbl.EXTEND;
            tbl(tbl.LAST) := objTeachersRateByYear(max_rate, teacher_id, term, l_year);
            
            END LOOP;
        CLOSE cur;
        
    RETURN tbl;
    END getTeachersRateByYear;
END pkgTeacher;

SELECT * FROM TABLE(pkgTeacher.getTeachersRateByYear(2, 2016));