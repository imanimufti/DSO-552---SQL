-- What is the organization heirarchy structure of the company?
-- List all employees who work for each manager.

select * 
from employee;

select m.first_name as manager, e.first_name as employee
from employee as m
join employee as e --based on...
on  m.employee_id = e.manager_id

-- Update the previous query to show who is the manager, and show all employees (inclusive of the managers)

select m.first_name as manager, e.first_name as employee
from employee as m
full join employee as e --based on...
on  m.employee_id = e.manager_id

-- Who is the boss?
select m.first_name as manager, e.first_name as employee
from employee as m
full join employee as e --based on...
on  m.employee_id = e.manager_id
where m.first_name is null;

-- Who is the boss? To show full names
select concat(m.first_name, ' ', m.last_name) as manager,
		concat(e.first_name, ' ', e.last_name) as employee
from employee as m
full join employee as e --based on...
on  m.employee_id = e.manager_id
where m.first_name is null