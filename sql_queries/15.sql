--Display how many students have chosen a certain teacher.

CREATE OR REPLACE TYPE objTeacher IS OBJECT (
  stud_count         NUMBER,
  ders_kod         VARCHAR(200),
  emp_id           VARCHAR(200)
);
----------------------------------------------

CREATE OR REPLACE TYPE tblTeacher IS TABLE OF objTeacher;
----------------------------------------------

CREATE OR REPLACE PACKAGE pkgTeacher AS
FUNCTION getTeacher RETURN tblTeacher;
END pkgTeacher;


----------------------------------------------

CREATE OR REPLACE PACKAGE BODY pkgTeacher AS

    FUNCTION getTeacher RETURN tblTeacher AS 

        tbl tblTeacher := tblTeacher();
        
        stud_count NUMBER(20);
        ders_kod    VARCHAR(200);
        emp_id      VARCHAR(200);
        

    BEGIN
    
        FOR rec IN (SELECT count(sel.stud_id) AS stud_count,ss.ders_kod,ss.emp_id 
        FROM course_selections sel JOIN course_sections ss ON  ss.ders_kod=sel.ders_kod GROUP BY ss.ders_kod,ss.emp_id)
    
        LOOP
          stud_count := rec.stud_count;
           ders_kod := rec.ders_kod;
           emp_id := rec.emp_id;
            
            tbl.EXTEND;
            tbl(tbl.LAST) := objTeacher(stud_count,ders_kod,emp_id);

      END LOOP;
   RETURN(tbl);

    END getTeacher;

END pkgTeacher;
----------------------------------------------
SELECT * FROM TABLE(pkgTeacher.getTeacher());









