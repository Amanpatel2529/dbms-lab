SQL> Create table Borrower(
    rollno int primary key,
    name varchar(10),
    date_of_issue date,
    name_of_book varchar(20),
    status varchar(2)
);

Created table successfully.

SQL> insert into borrower values(3, 'john', '7-14-2023', 'SQL', 'I');

Inserted 1 value successfully.

SQL> create table fine(
    rollno int references Borrower(rollno),
    cdate date,
    amt int
)

SQL>edit first.sql
-------------------------------------------------------------------------------------
declare
date_of_issue date;
days_since_issue int;
person_rollno int;
book_name varchar(20);
fine int := 0;
begin
dbms_output.put_line('Enter the rollno of person');
person_rollno := &person_rollno;
dbms_output.put_line('Enter the name of book');
book_name := &book_name;

select date_of_issue into date_of_issue 
from Borrower
where rollno = person_rollno and name_of_book=book_name;

days_since_issue := current_date - date_of_issue;
if(days_since_issue > 15 and days_since_issue < 30) then
fine := 5 * (days_since_issue-15);
elsif(days_since_issue > 30) then
fine := (5*15) + 50 * (days_since_issue - 30);
end if;
update Borrower
set status='R' where rollno = person_rollno;
if(fine != 0) then
insert into fine
values(person_rollno, current_date, fine);
end if;
exception 
when no_data_found then
dbms_output.put_line('Did not find data!');
end;
/
-------------------------------------------------------------------------------------
SQL> @first.sql

Enter the rollno of person
person_rollno: 1
old value of person_rollno:
new value of person_rollno: 1

Enter the name of book
book_name: 'Harry Potter'
old value of book_name
new value of book_name: 'Harry Potter'

updated 1 row successfully
inserted 1 row successfully


SQL> select * from Borrower

| ROLLNO | NAME | DATE_OF_ISSUE | NAME_OF_BOOK | STATUS |
|--------|------|---------------|--------------|--------|
| 1      | jay  | 01-09-2023    | Harry Potter | R      |
| 2      | jack | 01-08-2023    | Davinci Code | I      |
| 3      | john | 14-07-2023    | SQL          | I      |

SQL> select * from fine

| ROLLNO | CDATE      | AMT |
|--------|------------|-----|
| 1      | 20-09-2023 | 25  |