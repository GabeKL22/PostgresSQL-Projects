drop schema todo cascade;
create schema todo;


create table todo."user" (
  first_name text not null,
  last_name text not null,
  email text primary key,
  dob date --, created timestamp default now()
);

create table todo.todo (
  todo_id integer,
  item text,
  user_email text,
  primary key (todo_id)
);



insert into todo."user"
values ('Bob', 'Builder', 'bob@example.com', '1969-04-20');

