
--Find most popular courses for semester.

CREATE OR REPLACE TYPE objPopularCourse AS OBJECT (
    max_count NUMBER,
    course_code VARCHAR(20),
    prac_teacher NUMBER
);
----------------------------------------------
CREATE OR REPLACE TYPE tblPopularCourse IS TABLE OF objPopularCourse; 
----------------------------------------------
CREATE OR REPLACE PACKAGE pkgCourse AS
    FUNCTION getPopularCourse(p_term INT, p_year INT) RETURN tblPopularCourse;
END pkgCourse;
----------------------------------------------
CREATE OR REPLACE PACKAGE BODY pkgCourse AS

    FUNCTION getPopularCourse(p_term INT, p_year INT) RETURN tblPopularCourse                           
    IS 
        tbl tblPopularCourse := tblPopularCourse();

        max_count NUMBER(20);
        d_kod VARCHAR(50);
        prac NUMBER(20);

        CURSOR cur IS SELECT maximum, 
            DERS_KOD, 
            PRACTICE 
        FROM (
            SELECT count(*) AS maximum, 
                DERS_KOD, 
                PRACTICE 
            FROM 
            COURSE_SELECTIONS 
                WHERE PRACTICE IS NOT NULL AND DERS_KOD IS NOT NULL AND YEAR = p_year AND TERM = p_term
            GROUP BY DERS_KOD, PRACTICE
            ORDER BY maximum DESC 
 ) s
    where ROWNUM = 1;

    BEGIN
    OPEN cur;
        LOOP FETCH cur INTO  
            max_count,
            d_kod,
            prac;
        EXIT WHEN cur%NOTFOUND;

            tbl.EXTEND; 
            tbl(tbl.LAST) := objPopularCourse(max_count, d_kod, prac); 
        
        END LOOP;
   CLOSE cur;
   
   RETURN tbl;
   END getPopularCourse;
END pkgCourse; 
----------------------------------------------
SELECT * FROM TABLE(pkgCourse.getPopularCourse(1, 2016));



         
