--Find students who didn’t register any subjects for one semester.

CREATE OR REPLACE TYPE objNoneRegStudents AS OBJECT (
    max_count NUMBER,
    student_id VARCHAR(200),
    term NUMBER,
    s_year NUMBER
);

----------------------------------------------
CREATE OR REPLACE TYPE tblNoneRegStudents IS TABLE OF objNoneRegStudents;
----------------------------------------------
CREATE OR REPLACE PACKAGE pkgStudent AS
FUNCTION getNoneRegStudents RETURN tblNoneRegStudents;
END pkgStudent;
----------------------------------------------
CREATE OR REPLACE PACKAGE BODY pkgStudent AS

    FUNCTION getNoneRegStudents RETURN tblNoneRegStudents AS 

        tbl tblNoneRegStudents := tblNoneRegStudents();

        max_count NUMBER(20);
    	stud_id VARCHAR(200);
    	term NUMBER(20);
        year NUMBER(20);

        CURSOR cur IS SELECT 
                count(*) AS s_count, 
                cs.stud_id, 
                cs.term,
                cs.year
              FROM COURSE_SELECTIONS cs 
                WHERE cs.reg_date IS NULL AND cs.attended IS NULL 
                GROUP BY cs.year, cs.term, cs.stud_id 
                ORDER BY s_count;

    BEGIN
        OPEN cur;
            LOOP FETCH cur INTO  
                max_count,
                stud_id,
                term,
                year;
            EXIT WHEN cur%NOTFOUND;

                tbl.EXTEND;
                tbl(tbl.LAST) := objNoneRegStudents(max_count, stud_id, term, year);
                
        END LOOP;
    CLOSE cur;

    RETURN tbl;
    END getNoneRegStudents;

END pkgStudent;
----------------------------------------------
SELECT * FROM TABLE(pkgStudent.getNoneRegStudents());



