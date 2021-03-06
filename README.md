# **Goal of the Project**
Due to the **pandemic**, university students switched to distance learning and this mainly affected freshmen who did not see the walls of the university and do not know the learning environment.
The our main goal is to help students **understand** the university environment and to **quickly** master the environment.

The main opportunities does our project provide:
  * Teacher ratings - in the open access will be a rating of teachers for understanding the situation.
  * Retake analysis - analysis of student retakes and understanding the dangers of lessons.
  * Teacher schedule - you will have access to teacher's schedule so that you can supplement knowledge with in your free time.
  * Top of students - there will be a top students in the public domain for understanding the situation.
  * Student GPA - automated calculator for your gpa.


# **Implementation**
  * Graphical user interface: **JavaFX**
  * Scope of the project: **85 day**
  

# **Built with**
  * PL/SQL
  * JAVA
  
  We have chosen PL/SQL - the procedural extension of Oracle corporation to implement the database and connect Java using the library JDBC to access various database operations.
  
 # **General questions**
 1. Find most popular courses for semester. 
 2. Find most popular teacher in section for semester.
 3. Calculate GPA of student for the semester and total.
 4. Find students who didn’t register any subjects for one semester.
 5. Calculate how much money the student spent on retakes for the given semester (included) and total spent.
 6. Calculate the teachers “loading” (how many hours Teacher have for given semester).
 7. Design schedule of teacher on semester.
 8. Design schedule of student on semester.
 9. Display how many subjects and credits was selected by student.
 10. Find most clever flow of students by the average rating for one subject in one teacher.
 11. Teacher rating for the semester (list).
 12. Subject ratings for the semester (list).
 13. Calculate total number of retakes for all time and display the profit.
 14. Find in which subject the students received the most retakes.
 15. Display how many students have chosen a certain teacher.
 
 # **Dataset for the Project** 
 Link for dataset which will be used in project: 
 https://drive.google.com/drive/folders/1-SwKFCy8hYWSHwghscZel7OHsQQOCU4M?usp=sharing
 
 # **Table description** 
 1. Course_schedule – information about subjects
* ders_kod VARCHAR2(1024) NOT NULL – course code (code of subject)
* year NUMBER(38,0) NOT NULL – year when subject was conducted
* term NUMBER(38,0) NOT NULL – 1 – Fall, 2-Spring
* section VARCHAR2(1024) NOT NULL – sections 
* start_time TIMESTAMP – time of subject on week by schedule

 2. Course_sections – information about teachers
* ders_kod VARCHAR2(1024) NOT NULL – course code (code of subject)
* year NUMBER(38,0) NOT NULL – year when subject was conducted
* term NUMBER(38,0) NOT NULL – 1 – Fall, 2-Spring
* section VARCHAR2(1024) NOT NULL – sections
* type VARCHAR2(1024) – N, L – lection P- practice
* emp_id NUMBER(38,0) – id teacher, instructor
* hour_num NUMBER(38,0) – how many hours for semester
* credits VARCHAR2(1024) NOT NULL – number of credits

3. Course_selections – information about students
* stud_id VARCHAR2(1024) NOT NULL – id student
* ders_kod VARCHAR2(1024) NOT NULL – course code (code of subject)
* year NUMBER(38,0) NOT NULL – year
* term NUMBER(38,0) NOT NULL - 1 – Fall, 2-Spring
* section VARCHAR2(1024) – section
* qiymet_yuz NUMBER(38,0) – total mark of the course
* qiymet_herf VARCHAR2(1024) – total mark of the course
* grading_type VARCHAR2(1024) – PNP –pass no pass, N - standart
* practice NUMBER(38,0) – practice teacher
* reg_date DATE – registration time

# **Use-case UML diagram**
<p align="center">
  <img src="https://user-images.githubusercontent.com/49248372/109021122-caaeb380-76e4-11eb-9efa-8583485f0727.jpg" width="1250" height="800" title="Use-case UML diagram">
</p>


# **ER diagram**
![photo_2021-03-06_22-31-19](https://user-images.githubusercontent.com/49248372/110213784-b67c6a80-7ecb-11eb-9bdc-d68fd20e5c95.jpg)



# Speed performance evaluation
So in this part, using the java function System.currentTimeMillis, we calculated speed performance of the queries:

1)(20+51+20+24+52)/5 =33.4 milliseconds 	-- query 1                                                    

2)(26+41+29+18+29)/5 = 28.6 milliseconds	-- query 2

3)(12+7+6+4+12)/5 = 8.2 milliseconds		--query 7

4)(53+48+51+44+41)/5 = 47.4 milliseconds	--query 8

5)(71+50+46+18+24)/5 = 41.8 milliseconds	--query 10

6)(38+30+34+55+50)/5 = 41.4 milliseconds	--query 11

7)(23+23+37+37+43)/5 = 32.6 milliseconds	--query 12

Java function code and example, you can find by this link: 
https://github.com/Haknazarkz/winner/tree/main/Speed%20performance%20evaluation

