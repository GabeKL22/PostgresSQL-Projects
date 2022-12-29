-- Gabriel Leffew
-- CSC 256, Fall 2022, Project 10

------------------------------------------------------------------------------
-- Step 0. Run the create_tables.sql script to initialize the tables and
-- constraints.

BEGIN;  -- do not remove this line

------------------------------------------------------------------------------
-- Step 1. Insert/update data without violating constraints as follows:

-- company.employee data
insert into company.employee values ('Alba', 'Larsen', '888665555', '1981-11-10', '2010-01-01', 'Lason@company.com', 55000, null);
insert into company.employee values ('Sebastian', 'Mcdaniel', '987654321', '1981-06-20', '2010-01-01', 'Mcdaniel@company.org', 43000, '888665555');
insert into company.employee values ('June', 'Robinson', '333445555', '1997-12-08', '2010-01-01', 'Robinson@company.com', 40000, '888665555');
insert into company.employee values ('Melody', 'Holloway', '123456789', '1995-01-09', '2010-01-01', 'mholloway@company.org', 30000, '333445555');
insert into company.employee values ('Ismael', 'Price', '999887777', '2008-01-19', '2010-01-01', 'ismael.price@company.org', 25000, '987654321');
insert into company.employee values ('Wyatt', 'Rivera', '666884444', '1992-09-15', '2010-01-01', 'wyatt.rivera@company.org', 38000, '333445555');
insert into company.employee values ('Rhonda', 'Cooke', '453453453', '2002-07-31', '2010-01-01', 'rhonda.cooke@company.org', 25000, '333445555');
insert into company.employee values ('Wilda', 'Chambers', '987987987', '1999-03-29', '2010-01-01', 'wilda.chambers@company.org', 25000, '987654321');



-- company.department data
insert into company.department values (4, 'Administration', '987654321');
insert into company.department values (1, 'HQ', '888665555');
insert into company.department values (5, 'Research', '333445555');

update company.employee set department_id = 1 where first_name = 'Alba'; 
update company.employee set department_id = 4 where first_name = 'Sebastian' or first_name = 'Wilda' or first_name = 'Ismael';
update company.employee set department_id = 5 where first_name = 'Melody' or first_name = 'June' or first_name = 'Wyatt' or first_name = 'Rhonda'; 

-- company.project data
insert into company.project values (1, 'ProductX', 5);
insert into company.project values (2, 'ProductY', 5);
insert into company.project values(3, 'ProductZ', 5);
insert into company.project values (7, 'ProductAlpha', 5);
insert into company.project values (8, 'ProductBeta', 5);
insert into company.project values (10, 'Automation', 4);
insert into company.project values (20, 'Reorganization', 1);
insert into company.project values (30, 'Benefits', 4);

-- company.employee_project data
insert into company.employee_project values ('123456789', 1, 33);
insert into company.employee_project values ('123456789', 2, 8);
insert into company.employee_project values ('666884444', 3, 40);
insert into company.employee_project values ('453453453', 1, 20);
insert into company.employee_project values ('453453453', 2, 20);
insert into company.employee_project values ('333445555', 2, 10);
insert into company.employee_project values ('333445555', 3, 10);
insert into company.employee_project values ('333445555', 10, 10);
insert into company.employee_project values ('333445555', 20, 10);
insert into company.employee_project values ('999887777', 30, 30);
insert into company.employee_project values ('999887777', 10, 10);
insert into company.employee_project values ('987987987', 10, 35);
insert into company.employee_project values ('987987987', 30, 5);
insert into company.employee_project values ('987654321', 30, 20);
insert into company.employee_project values ('987654321', 20, 15);
insert into company.employee_project values ('888665555', 20, null);

-- select * from company.employee;
-- select * from company.department;
-- select * from company.project;
-- select * from company.employee_project;




------------------------------------------------------------------------------
-- Step 2. Write an update statement to ensure that all employees have an email
-- address that has the form "<first_name>.<last_name>@company.org" where
-- first_name and last_name are lower case. Use a returning clause to output
-- the results.

update company.employee set 
email = lower(concat(first_name, '.', last_name, '@company.org'))
where email <> concat(first_name, '.', last_name, '@company.org')
returning *;

--select * from company.employee;


------------------------------------------------------------------------------
-- Step 3. Write an update statement to increase the salary by 10% for
-- employees that work on the "ProductZ" project. Use a returning clause to
-- output the results.

-- update company.employee set salary = (salary * 1.10)
-- join company.department on company.employee.department_id = company.department.department_id
-- join company.project on company.department.department_id = company.project.department_id
-- where company.project.project_id = 3
-- returning *;

with t as (
    select company.employee.ssn from company.employee
    inner join company.department using(department_id)
    inner join company.project using(department_id)
    where company.project.name = 'ProductZ'
)
update company.employee
set salary = (salary*1.10)
where employee.ssn in (select t.ssn from t)
returning *;

------------------------------------------------------------------------------
-- Step 4. Write a delete statement to remove all the projects that have no
-- employees working on them. Use a returning clause to output the results.


delete from company.project 
where project_id not in (select project_id from company.employee_project)
returning *;


ROLLBACK; -- do not remove this line
