--Calculate the teachers “loading” (how many hours Teacher have for given semester)

CREATE OR REPLACE TYPE objTeacherLoaded IS OBJECT ( --Task6
  emp_id            NUMBER,
  year              NUMBER,
  term              NUMBER,
  total_hours       NUMBER
);
-------------------------------------------------------------------
CREATE OR REPLACE TYPE tblTeacher IS TABLE OF objTeacherLoaded; 

-------------------------------------------------------------------
CREATE OR REPLACE PACKAGE pkgTeacher AS
FUNCTION getTeacherTotalHours(teacher_id IN NUMBER) RETURN tblTeacher;     
END pkgTeacher;

-------------------------------------------------------------------
CREATE OR REPLACE PACKAGE BODY pkgTeacher AS
       FUNCTION getTeacherTotalHours(teacher_id IN NUMBER) RETURN tblTeacher                 
     AS
    tbl tblTeacher := tblTeacher(); 
    BEGIN
    FOR rec IN (SELECT emp_id AS TEACHER_ID, 
                       year, 
                       term AS SEMESTER, 
                       sum(hour_num) AS TOTAL_HOURS 
                FROM course_sections 
                    WHERE hour_num is not null and emp_id = teacher_id  
                    GROUP BY year, emp_id, term 
                    ORDER BY year)  LOOP
            tbl.EXTEND;
            tbl(tbl.LAST) := objTeacherLoaded(rec.TEACHER_ID, 
                                    rec.year, 
                                    rec.SEMESTER, 
                                    rec.TOTAL_HOURS);
        END LOOP;
        
        RETURN tbl;
    END getTeacherTotalHours;
    
END pkgTeacher;

SELECT * FROM TABLE(pkgTeacher.getTeacherTotalHours(10166));  