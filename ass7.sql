create table O_RollCall(roll_no number(3), name varchar2(20))
insert into O_RollCall values(1,'ashitosh');
insert into O_RollCall values(2,'sainath');
insert into O_RollCall values(3,'swaroop');

select * from O_RollCall;

ROLL_NO	NAME
1	ashitosh
2	sainath
3	swaroop

create table N_RollCall(roll_no number(3), name varchar2(20))


declare
cursor cur1 is 
select roll_no, name from O_RollCall;

cursor cur2 is
select roll_no from N_Rollcall;

r number(3);
rno number(3);
nm varchar2(20);


begin
open cur1; 
open cur2;

loop
fetch cur1 into rno,nm;
fetch cur2 into r;
exit when cur1%found=false;
if r <> rno then
insert into N_RollCall values(rno,nm);
end if;


end loop; 
close cur1;

end;

select * from O_RollCall;
ROLL_NO	NAME
1	ashitosh
2	sainath
3	swaroop