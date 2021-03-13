--Calculate how much money the student spent on retakes for the given semester (included) and total spent.

CREATE OR REPLACE TYPE objStudentRetakes IS OBJECT ( 
  student_id        VARCHAR(200),
  year              NUMBER,
  semester          NUMBER,
  quantity          NUMBER,
  semester_sum      NUMBER,
  total_quantity    NUMBER,
  total_sum         NUMBER
);

----------------------------------------------
CREATE OR REPLACE TYPE tblStudentRetakes IS TABLE OF objStudentRetakes;
----------------------------------------------
CREATE OR REPLACE PACKAGE pkgStudent AS
FUNCTION getStudentRetakes(student_id VARCHAR, g_year NUMBER, g_term NUMBER) RETURN tblStudentRetakes; 
END pkgStudent;
----------------------------------------------
CREATE OR REPLACE PACKAGE BODY pkgStudent AS
FUNCTION getStudentRetakes(student_id VARCHAR, g_year NUMBER, g_term NUMBER) RETURN tblStudentRetakes                
    IS
        tbl tblStudentRetakes := tblStudentRetakes();
 
    BEGIN
  FOR rec IN (SELECT 
        cs.STUD_ID, 
        cs.YEAR, 
        cs.TERM AS SEMESTER, 
        count(*) AS SEMESTER_SUM, 
        (SELECT count(*) AS SEMESTER_SUM FROM course_selections WHERE STUD_ID = cs.STUD_ID) AS TOTAL_SUM,  
        (SELECT DISTINCT CREDITS FROM course_sections WHERE YEAR = cs.YEAR AND TERM = cs.TERM) AS CREDIT
    FROM course_selections cs
         WHERE 
            cs.QIYMET_HERF IN ('F', 'FX') AND 
            cs.STUD_ID = student_id AND
            cs.YEAR = g_year AND
            cs.TERM = g_term
            GROUP BY cs.YEAR, cs.TERM, cs.STUD_ID)
        LOOP
            
            tbl.EXTEND;
            tbl(tbl.LAST) := objStudentRetakes(rec.stud_id, 
                                               rec.year, 
                                               rec.SEMESTER, 
                                               rec.SEMESTER_SUM,
                                               rec.SEMESTER_SUM * 25000 * rec.CREDIT, 
                                               rec.TOTAL_SUM,
                                               rec.TOTAL_SUM * 25000 * rec.CREDIT);

      END LOOP;
   RETURN(tbl);
   END getStudentRetakes;

END pkgStudent;

SELECT * FROM TABLE(pkgStudent.getstudentretakes('A41A708C44F7128B95A0A52E697FF319102077BF', 2016, 1));


