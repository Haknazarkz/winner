--Subject ratings for the semester (list).

CREATE OR REPLACE TYPE objCourseRateByYear IS OBJECT ( 
  course_rate            NUMBER,
  course_code     VARCHAR(20),
  term            NUMBER,
  year            NUMBER
);

--------------------------------------------------------------
DROP TYPE objCourseRateByYear FORCE; 

CREATE OR REPLACE TYPE tblCourseRateByYear IS TABLE OF objCourseRateByYear;

--------------------------------------------------------------
CREATE OR REPLACE PACKAGE pkgCourse AS
    FUNCTION getCourseRateByYear(semester IN NUMBER, g_year NUMBER) RETURN tblCourseRateByYear; 
END pkgCourse;
--------------------------------------------------------------
CREATE OR REPLACE PACKAGE BODY pkgCourse AS
   FUNCTION getCourseRateByYear(semester IN NUMBER, g_year NUMBER) RETURN tblCourseRateByYear             
    IS
        tbl tblCourseRateByYear := tblCourseRateByYear();
        
        max_rate     NUMBER(10);
        course_code  VARCHAR(10);
        term         NUMBER(10);
        l_year       NUMBER(10);
        
        CURSOR cur IS SELECT 
            count(DERS_KOD) AS COURSE_RATE, 
            ders_kod AS COURSE_CODE,
            term AS SEMESTER,
            year
        FROM course_selections
                WHERE term = semester AND year = g_year AND ders_kod IS NOT NULL
            GROUP BY ders_kod, term, year
            ORDER BY COURSE_RATE DESC;
    
    BEGIN
    
        OPEN cur;
            LOOP FETCH cur INTO
                max_rate,
                course_code,
                term,
                l_year;
            EXIT WHEN cur%NOTFOUND;
            
            tbl.EXTEND;
            tbl(tbl.LAST) := objCourseRateByYear(max_rate, course_code, term, l_year);
            
            END LOOP;
        CLOSE cur;
        
    RETURN tbl;
    END getCourseRateByYear;
END pkgCourse; 


SELECT * FROM TABLE(pkgCourse.getCourseRateByYear(1, 2016)); 