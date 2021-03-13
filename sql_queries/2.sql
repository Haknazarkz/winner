--Find most popular teacher in section for semester.

CREATE OR REPLACE TYPE objPopularTeacher IS OBJECT ( 
  max_count         NUMBER,
  ders_kod         VARCHAR(200),
  practice_id       NUMBER,
  lecture_id           VARCHAR(200)
);

----------------------------------------------
CREATE OR REPLACE TYPE tblPopularTeacher IS TABLE OF objPopularTeacher;
----------------------------------------------
CREATE OR REPLACE PACKAGE pkgTeacher AS
FUNCTION getPopularTeacher(p_term INT, p_year INT, t_code VARCHAR) RETURN tblPopularTeacher;
END pkgTeacher;
----------------------------------------------
CREATE OR REPLACE PACKAGE BODY pkgTeacher AS

    FUNCTION getPopularTeacher(p_term INT, p_year INT, t_code VARCHAR) RETURN tblPopularTeacher 
    IS
        tbl tblPopularTeacher := tblPopularTeacher();
        max_count NUMBER(20);
        subject VARCHAR(10);
      practice_id NUMBER(20);
      lecture_id VARCHAR(10);

    BEGIN
  FOR rec IN (SELECT maximum,ders_kod,practice,emp_id 
    FROM(select count(*) maximum,sc.ders_kod,sel.practice,sc.emp_id,sc.year,sc.term
    from course_selections sel join course_sections sc
    on sc.ders_kod=sel.ders_kod and  sc.emp_id IS NOT NULL AND sel.practice IS NOT NULL and
          sc.year = p_year AND 
          sc.term = p_term AND 
          sc.ders_kod = t_code
        GROUP BY sc.ders_kod,sel.practice,sc.emp_id,sc.year,sc.term
        ORDER BY maximum DESC) where rownum=1)
    
        LOOP
          max_count := rec.maximum;
           practice_id := rec.EMP_ID;
           lecture_id := rec.PRACTICE;
            subject := rec.ders_kod;
            
            tbl.EXTEND;
            tbl(tbl.LAST) := objPopularTeacher(max_count, subject,practice_id, lecture_id);

      END LOOP;
   RETURN(tbl);
   END getPopularTeacher;
END pkgTeacher;

----------------------------------------------
SELECT * FROM TABLE(pkgTeacher.getPopularTeacher(1, 2015, 'CSS 307'));



