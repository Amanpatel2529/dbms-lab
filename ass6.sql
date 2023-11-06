--Write a stored procedure, namely, troc_grade for the categorisation of student 
--if marks scored by student in examination is less than or equal to 1500 and marks greater than or equal
-- to 990, then student will be placed in distinction category.
--If marks scored are between 989 and 900, category is first class. if marks 899 and 825 category is 'higher second class'.
--write a pl/sql block for using procedure, created with above requirement

--1) Create table stud_marks with 3 fields - rollno, name, total_marks
--2) Create table result with 3 fields - rollno, name, class


SQL> create table stud_marks(
    rollno int primary key,
    name varchar(20),
    total_marks int
);

--created table successfully.

SQL> create table result(
    rollno int references stud_marks(rollno),
    name varchar(20),
    class varchar(20)
);

--created table successfully

SQL> edit procedure.sql
------------------------------------------------------------------------------------------
create or replace procedure troc_grade(rollno IN int, name IN varchar, total_marks IN int)
as
class_val varchar(20);
begin
insert into stud_marks
values(rollno, name, total_marks);
if (total_marks > 990 and total_marks < 1500) then
class_val := 'distinction';
elsif (total_marks < 989 and total_marks > 900) then
class_val := 'first class';
elsif (total_marks < 899 and total_marks > 825) then
class_val := 'higher second class';
else
class_val := 'pass';
end if;
insert into result
values(rollno, name, class_val);
end troc_grade;
/
------------------------------------------------------------------------------------------

SQL> @procedure_name.sql

--created procedure successfully

SQL> test.sql
-----------------------------
begin
troc_grade(3, 'Jack', 850);
end;
/
-----------------------------

SQL> @test.sql

inserted 1 value successfully

SQL> select * from stud_marks;

| ROLLNO | NAME | TOTAL_MARKS |
|--------|------|-------------|
| 3      | Jack | 850         |

SQL> select * from result;

| ROLLNO | NAME | CLASS               |
|--------|------|---------------------|
| 3      | Jack | higher second class |