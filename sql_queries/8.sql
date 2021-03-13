--Design schedule of student on semester.

CREATE OR REPLACE TYPE objStudentDesign IS OBJECT ( 
  student_id        VARCHAR(200),
  year              NUMBER,
  term              NUMBER,
  course_code       VARCHAR(20),
   day_schedule      VARCHAR(20),
  hours_schedule_student NUMBER
);

---------------------------------------------------------------
CREATE OR REPLACE TYPE tblStudentDesign IS TABLE OF objStudentDesign;
-------------------------------------------------------------------
CREATE OR REPLACE PACKAGE pkgStudent AS
FUNCTION getStudentDesign(student_id IN VARCHAR, g_year NUMBER, g_term NUMBER) RETURN tblStudentDesign; 
END pkgStudent;
----------------------------------------------------------------
CREATE OR REPLACE PACKAGE BODY pkgStudent AS
FUNCTION getStudentDesign(student_id IN VARCHAR, g_year NUMBER, g_term NUMBER) RETURN tblStudentDesign                     
    IS
        tbl tblStudentDesign := tblStudentDesign();
    
    BEGIN
    FOR rec IN (SELECT 
        selections.stud_id AS STUDENT_ID, 
        schedule.year, 
        schedule.term AS SEMESTER, 
        schedule.ders_kod AS COURSE_CODE,
       (to_char(cast(schedule.start_time as DATE),'Day','NLS_DATE_LANGUAGE = ENGLISH')) as day_schedule,
        extract(HOUR from schedule.start_time) as hours_schedule_student ,
        selections.section 
FROM course_schedule schedule
        INNER JOIN course_selections selections ON
            schedule.ders_kod = selections.ders_kod AND 
            schedule.year = selections.year AND
            schedule.term = selections.term AND selections.section=schedule.section AND
            selections.stud_id = student_id AND
            schedule.year = g_year AND
            schedule.term = g_term
        GROUP BY schedule.year, schedule.term, schedule.ders_kod, selections.stud_id,schedule.start_time,selections.section 
        ORDER BY schedule.year,schedule.start_time asc,schedule.ders_kod asc)
        
        LOOP
            tbl.EXTEND;
            tbl(tbl.LAST) := objStudentDesign(rec.STUDENT_ID, 
                                    rec.year, 
                                    rec.SEMESTER, 
                                    rec.COURSE_CODE,
                                    rec.day_schedule,
                                    rec.hours_schedule_student);
        END LOOP;
        
        RETURN tbl;
    END getStudentDesign;
END pkgStudent;
---------------------------------------------------------------------------------------
SELECT * FROM TABLE(pkgStudent.getStudentDesign('F5969065974B1FFCAC09DB2E087F33D1A1465B69', 2017, 1)); 
