--Display how many subjects and credits was selected by student

CREATE OR REPLACE TYPE objStudentCredit IS OBJECT ( 
  student_id        VARCHAR(200),
  year              NUMBER,
  semester          NUMBER,
  total_subjects       VARCHAR(20),
  total_credits           NUMBER
);

---------------------------------------------------------------
DROP TYPE objStudentCredit FORCE; 

---------------------------------------------------------------

CREATE OR REPLACE TYPE tblStudentCredit IS TABLE OF objStudentCredit;

---------------------------------------------------------------
CREATE OR REPLACE PACKAGE pkgStudent AS
FUNCTION getStudentCredit(student_id IN VARCHAR, p_year NUMBER, p_term NUMBER) RETURN tblStudentCredit; 
END pkgStudent;

---------------------------------------------------------------
CREATE OR REPLACE PACKAGE BODY pkgStudent AS    
FUNCTION getStudentCredit(student_id IN VARCHAR, p_year NUMBER, p_term NUMBER) RETURN tblStudentCredit                  
    IS
        tbl tblStudentCredit := tblStudentCredit();
        c NUMBER(5);
            
    BEGIN
    SELECT DISTINCT CREDITS INTO c FROM course_sections;
    for cur IN (SELECT count(*) as total_subjects FROM(
            SELECT  selections.stud_id , 
                    schedule.year, 
                    schedule.term , 
                    schedule.ders_kod,
                    schedule.section
                FROM course_schedule schedule
                    INNER JOIN course_selections selections ON
                        schedule.ders_kod = selections.ders_kod AND schedule.section=selections.section and
                        schedule.year = selections.year AND
                        schedule.term = selections.term AND
                        selections.stud_id = student_id AND
                        schedule.year = p_year AND
                        schedule.term = p_term
                    GROUP BY schedule.year, schedule.term, schedule.ders_kod, selections.stud_id,schedule.section
                    ORDER BY schedule.year))
        LOOP
        FOR cur1 IN (SELECT  selections.stud_id AS student, 
                    schedule.year, 
                    schedule.term AS semester
                FROM course_schedule schedule
                    INNER JOIN course_selections selections ON
                        schedule.year = selections.year AND
                        schedule.term = selections.term AND
                        selections.stud_id = student_id AND
                        selections.year = p_year AND
                        selections.term = p_term
                    GROUP BY schedule.year, schedule.term,  selections.stud_id
                    ORDER BY schedule.year)
                    LOOP
                tbl.EXTEND;
                tbl(tbl.LAST) := objStudentCredit(cur1.student,
                                                cur1.year,
                                                cur1.semester,
                                                cur.total_subjects,
                                                cur.total_subjects*c);
        END LOOP;
       END LOOP;
   
        RETURN tbl;
    END getStudentCredit;

END pkgStudent;

SELECT * FROM TABLE(pkgStudent.getStudentCredit('F5969065974B1FFCAC09DB2E087F33D1A1465B69',2016,1));