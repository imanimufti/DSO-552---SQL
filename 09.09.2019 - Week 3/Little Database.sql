drop table if exists table_a;
drop table if exists table_b;

create table table_a(
	id int primary key,
	a varchar(100)
);
--VariableCharacter
--Primarykey will be unique

create table table_b(
	id int primary key,
	b varchar(100)
);
-- 100 represents the number of characters which can be entered.
-- Insert values into the tables

insert into table_a (id, a)
values (1, 'm'),
		(2, 'n'),
		(4, 'o');
		
insert into table_b (id, b)
values (2, 'p'),
		(3, 'q'),
		(5, 'r');

select * from table_a;
select * from table_b;

-- Inner Join -- Join the primary key
select * 
from table_a
inner join table_b
on table_a.id = table_b.id

-- OR 
select * 
from table_a
join table_b 
on table_a.id = table_b.id;

-- Left Outer Join(Left Join)

select *
from table_a
left join table_b
on table_a.id = table_b.id

-- Right Outer Join(Right join)

select *
from table_a
right join table_b
on table_a.id = table_b.id;

-- OR (Rewrite the previous query as a left join)

select *
from table_b
left join table_a
on table_a.id = table_b.id

-- Full Outer Join

select *
from table_a
full join table_b
on table_a.id = table_b.id;

-- Natural Join

select * 
from table_a
natural join table_b;

-- When you do natural join you dont specify the condition, 
-- because it will automatically join the common primary keys.

-- Cross Join

select *
from table_a
cross join table_b

--There's no need to specify

-- Self Join
select *
from table_a as x
join table_a as y
on x.id = y.id
-- OR
select *
from table_a as x
join table_a as y
using (id)


