SQL> create table library(
  2  book_id int primary key,
  3  book_name varchar(20),
  4  book_price int
  5  );

Table created.

SQL> desc library;
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 BOOK_ID                                   NOT NULL NUMBER(38)
 BOOK_NAME                                          VARCHAR2(20)
 BOOK_PRICE                                         NUMBER(38)

SQL> create table library_audit_row(
  2  book_id int references library(book_id),
  3  book_name varchar(20),
  4  book_price int,
  5  audit_change varchar(20),
  6  update_time date
  7  );

Table created.

SQL> desc  library_audit_row;
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 BOOK_ID                                            NUMBER(38)
 BOOK_NAME                                          VARCHAR2(20)
 BOOK_PRICE                                         NUMBER(38)
 AUDIT_CHANGE                                       VARCHAR2(20)
 UPDATE_TIME                                        DATE

SQL> create table library_audit_stmp(
  2  audit_history_id int primary key,
  3  audit_change varchar(20),
  4  user_name varchar(20),
  5  update_time date
  6  );

Table created.

SQL> desc library_audit_stmp;
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 AUDIT_HISTORY_ID                          NOT NULL NUMBER(38)
 AUDIT_CHANGE                                       VARCHAR2(20)
 USER_NAME                                          VARCHAR2(20)
 UPDATE_TIME                                        DATE

SQL> insert into library
  2  values(1, 'Harry Potter', 250);

1 row created.

SQL> insert into library
  2  values(2, 'Davinci code', 500);

1 row created.

SQL> insert into library
  2  values(3, 'Game of thrones', 1000);

1 row created.

SQL> insert into library
  2  values(4, 'SQL plus book', 1500);

1 row created.

SQL> insert into library
  2  values(5, 'Mathematics book', 2000);

1 row created.

SQL> select * from library;

   BOOK_ID BOOK_NAME            BOOK_PRICE
---------- -------------------- ----------
         1 Harry Potter                250
         2 Davinci code                500
         3 Game of thrones            1000
         4 SQL plus book              1500
         5 Mathematics book           2000

SQL> edit trigger.sql

create or replace trigger library_trigger
after
update or delete on library
for each row
declare
audit_change varchar(10);
begin
if deleting then
audit_change := 'delete';
end if;
if updating then
audit_change := 'update';
end if;
insert into library_audit_row
values(:old.book_id, :old.book_name, :old.book_price, audit_change, current_timestamp);
end;
/

SQL> @trigger.sql

Trigger created.

SQL> update library set book_name='HP' where book_id=2;

1 row updated.

SQL> select * from library_audit_row;

   BOOK_ID BOOK_NAME            BOOK_PRICE AUDIT_CHANGE         UPDATE_TI
---------- -------------------- ---------- -------------------- ---------
         2 Davinci code                500 update               26-SEP-23

SQL> delete from library where book_id=5;

1 row deleted.

SQL> select * from library_audit_row;

   BOOK_ID BOOK_NAME            BOOK_PRICE AUDIT_CHANGE         UPDATE_TI
---------- -------------------- ---------- -------------------- ---------
         2 Davinci code                500 update               26-SEP-23
         5 Mathematics book           2000 delete               26-SEP-23

SQL> create sequence audit_seq
  2  start with 1;

Sequence created.

SQL> edit trig2_50.sql

create or replace trigger trig50
before update or delete on library
declare
audit_change varchar(20);
begin
if deleting then
audit_change := 'delete';
end if;
if updating then
audit_change := 'update';
end if;
insert into library_audit_stmp
values(audit_seq.nextval, audit_change, USER, current_timestamp);
end;
/

SQL> @trig2_50.sql

Trigger created.

SQL> update library set book_name = 'Java book' where book_id = 3;

1 row updated.

SQL> select * from library_audit_stmp;

AUDIT_HISTORY_ID AUDIT_CHANGE         USER_NAME            UPDATE_TI
---------------- -------------------- -------------------- ---------
               1 update               SYSTEM               26-SEP-23

SQL> select * from library_audit_row;

   BOOK_ID BOOK_NAME            BOOK_PRICE AUDIT_CHANGE         UPDATE_TI
---------- -------------------- ---------- -------------------- ---------
         2 Davinci code                500 update               26-SEP-23
         5 Mathematics book           2000 delete               26-SEP-23
         3 Game of thrones            1000 update               26-SEP-23