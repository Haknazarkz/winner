--DDL for table Course_schedule
CREATE TABLE Course_schedule(
  ders_kod VARCHAR2(1024) NOT NULL,
  year NUMBER(38,0) NOT NULL,
  term NUMBER(38,0) NOT NULL,
  section VARCHAR2(1024) NOT NULL,
  start_time VARCHAR2(1024));

--DDL for table Course_sections
CREATE TABLE Course_sections(
  ders_kod VARCHAR2(1024) NOT NULL,
  year NUMBER(38,0) NOT NULL,
  term NUMBER(38,0) NOT NULL,
  section VARCHAR2(1024) NOT NULL,
  type VARCHAR2(1024),
  emp_id NUMBER(38,0),
  hour_num NUMBER(38,0),
  credits VARCHAR2(1024) NOT NULL);

--DDL for table Course_selections
CREATE TABLE Course_selections(
  stud_id VARCHAR2(1024) NOT NULL,
  ders_kod VARCHAR2(1024) NOT NULL,
  year NUMBER(38,0) NOT NULL,
  term NUMBER(38,0) NOT NULL,
  section VARCHAR2(1024) NOT NULL,
  qiymet_yuz NUMBER(38,0),
  qiymet_herf VARCHAR2(1024),
  grading_type VARCHAR2(1024),
  practice NUMBER(38,0),
  reg_date DATE);
