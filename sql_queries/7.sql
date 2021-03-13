-- Design schedule of teacher on semester


CREATE OR REPLACE TYPE objTeacherDesign IS OBJECT (  
  emp_id            NUMBER,
  year              NUMBER,
  term              NUMBER,
  course_code       VARCHAR(20),
  day_schedule      VARCHAR(20),
  hours_schedule_teacher NUMBER
);

-------------------------------------------------------------

CREATE OR REPLACE TYPE tblTeacherDesign IS TABLE OF objTeacherDesign; 

--------------------------------------------------------------

CREATE OR REPLACE PACKAGE pkgTeacher AS
FUNCTION getTeacherDesign(teacher_id IN NUMBER, g_year NUMBER, g_term NUMBER) RETURN tblTeacherDesign;  
END pkgTeacher;

----------------------------------------------------------------
CREATE OR REPLACE PACKAGE BODY pkgTeacher AS
        FUNCTION getTeacherDesign(teacher_id IN NUMBER, g_year NUMBER, g_term NUMBER) RETURN tblTeacherDesign          
    IS
        tbl tblTeacherDesign := tblTeacherDesign();
    BEGIN
    
    FOR rec IN (SELECT 
        sections.emp_id AS TEACHER_ID, 
        schedule.year, 
        schedule.term AS SEMESTER, 
        schedule.ders_kod AS COURSE_CODE,
        (to_char(cast(schedule.start_time as DATE),'Day','NLS_DATE_LANGUAGE = ENGLISH')) as day_schedule,
        extract(HOUR from schedule.start_time) as hours_schedule_teacher
    FROM course_schedule schedule
    INNER JOIN course_sections sections ON
        schedule.ders_kod = sections.ders_kod  AND 
        schedule.term = sections.term AND
        sections.emp_id = teacher_id AND
        schedule.year = g_year AND
        schedule.term = g_term
        GROUP BY schedule.year, schedule.term, schedule.ders_kod, sections.emp_id,schedule.start_time
        ORDER BY schedule.year,schedule.start_time ASC)
        
        LOOP
            tbl.EXTEND;
            tbl(tbl.LAST) := objTeacherDesign(rec.TEACHER_ID, 
                                    rec.year, 
                                    rec.SEMESTER, 
                                    rec.COURSE_CODE,
                                    rec.day_schedule,
                                    rec.hours_schedule_teacher);
        END LOOP;
        
        RETURN tbl;
    END getTeacherDesign;

END pkgTeacher;

SELECT * FROM TABLE(pkgTeacher.getTeacherDesign(10166, 2017, 1));   


