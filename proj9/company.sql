-- Gabriel Leffew
-- CSC 256, Fall 2022, Project 9

drop schema if exists company cascade;
create schema company;

create table company.department (
    department_id integer not null,
    name text not null,
    manager_ssn varchar(100),
    primary key (department_id)
);
create table company.project (
    project_id integer not null,
    name text not null,
    department_id integer not null references company.department (department_id),
    primary key (project_id)
);
create table company.employee_project (
    employee_ssn varchar(100),
    project_id integer references company.project (project_id),
    hours integer,
    check (hours <= 60),
    primary key (employee_ssn)
);
create table company.employee (
    first_name text not null,
    last_name text not null,
    ssn varchar(100) not null references company.employee_project (employee_ssn),
    dob date not null,
    start_date date not null,
    email text,
    salary integer,
    supervisor_ssn varchar(100),
    department_id integer references company.department (department_id),
    primary key (email)
);
