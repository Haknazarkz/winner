--Find most clever flow of students by the average rating for one subject in one teacher

CREATE OR REPLACE TYPE objCleverStudents IS OBJECT ( 
  student_id        VARCHAR(200),
  teacher_id        NUMBER,
  course_code       VARCHAR(20),
  Average_rate      NUMBER);
  
-----------------------------------------------------------------

CREATE OR REPLACE TYPE tblCleverStudents IS TABLE OF objCleverStudents;

-----------------------------------------------------------------
CREATE OR REPLACE PACKAGE pkgStudent AS
FUNCTION getCleverStudents(teacher_id NUMBER, course_code VARCHAR) RETURN tblCleverStudents;         
END pkgStudent;

------------------------------------------------------------------
CREATE OR REPLACE PACKAGE BODY pkgStudent AS

FUNCTION getCleverStudents(teacher_id NUMBER, course_code VARCHAR) RETURN tblCleverStudents                   
    AS
    tbl tblCleverStudents := tblCleverStudents();

    BEGIN
    FOR rec IN ( SELECT stud_id AS STUDENT_ID,practice AS TEACHER_ID, 
        DERS_KOD AS COURSE_CODE,qiymet_yuz as AVERAGE_RATE from course_selections where 
          qiymet_yuz >(select round(avg(qiymet_yuz),2) 
          from course_selections  where practice = teacher_id  and DERS_KOD = course_code) 
        AND  QIYMET_YUZ IS NOT NULL 
        AND practice IS NOT NULL 
        AND practice = teacher_id 
        AND DERS_KOD = course_code
    GROUP BY practice, DERS_KOD, stud_id,qiymet_yuz
    ORDER BY Average_Rate DESC)
    
   
        
        LOOP
            tbl.EXTEND;
            tbl(tbl.LAST) := objCleverStudents(rec.STUDENT_ID, 
                                    rec.TEACHER_ID, 
                                    rec.COURSE_CODE, 
                                    rec.AVERAGE_RATE);
        END LOOP;
    RETURN tbl;    
    END getCleverStudents;
END pkgStudent;

SELECT * FROM TABLE(pkgStudent.getCleverStudents(6361, 'FIN 307')); 