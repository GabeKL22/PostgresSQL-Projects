drop schema if exists company cascade;
create schema company;


create table company.department (
    department_id int primary key,
    name text not null,
    manager_ssn text
);


create table company.employee (
    first_name text not null,
    last_name text not null,
    ssn text primary key,
    dob date not null,
    start_date date not null,
    email text,
    salary decimal(10,2),
    supervisor_ssn text references company.employee(ssn),
    department_id int references company.department(department_id)
);


create table company.project (
    project_id int primary key,
    name text not null,
    department_id int not null references company.department(department_id)
);


create table company.employee_project (
    employee_ssn text references company.employee(ssn),
    project_id int references company.project(project_id),
    hours int,
    primary key(employee_ssn, project_id),
    check (hours < 60)
);


alter table company.department
    add constraint department_manager_ssn_fkey
    foreign key (manager_ssn) references company.employee(ssn);
