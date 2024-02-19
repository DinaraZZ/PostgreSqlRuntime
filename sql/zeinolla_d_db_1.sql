drop table if exists humans;

create table humans
(
    id         serial8,
    first_name varchar                      not null,
    birthdate  date                         not null,
    position   varchar default 'Unemployed' not null,
    income     int4    default 0            not null,
    primary key (id)
);

insert into humans (first_name, birthdate, position, income)
values ('Mark', '1992-02-07', 'Developer', 2600),
       ('Jordan', '1999-05-12', 'Designer', 1900);

insert into humans (first_name, birthdate, position, income)
values ('Dan', '2000-01-06', 'Banker', 2000);

insert into humans (first_name, birthdate, position, income)
values ('Bill', '2005-09-02', 'Manager', 1800),
       ('Joe', '1985-04-04', 'Director', 3500);

insert into humans(first_name, birthdate)
values ('Leo', '1995-01-06');

update humans
set position = 'Developer',
    income   = 2300
where id = 6;

update humans
set income = 1.1 * income
where position = 'Developer';

-- delete from humans; удаляет все записи

delete
from humans
where position = 'Banker';

-- алиас - имя после поля заданное
select *
from humans;

select h.first_name Имя, h.position Должность
from humans h;

insert into humans(first_name, birthdate)
values ('Eugene', '1998-01-06');

select *
from humans
where position != 'Unemployed';

select *
from humans
where birthdate >= '1990-01-01'
  and birthdate < '2000-01-01';

select *
from humans
where birthdate between '1990-01-01' and '1999-12-31';

select *
from humans h
where h.position = 'Developer'
   or h.position = 'Designer';

select *
from humans h
where h.position in ('Developer', 'Designer');

select *
from humans h
where h.position = 'Developer' and h.income < 3000
   or h.position = 'Designer' and h.income < 2000;

-- a%, %a, %a% (startsWith, endsWith, contains)
select *
from humans h
where first_name like 'J%';

select h.position, count(h.id) quantity
from humans h
group by h.position
order by quantity desc;
--asc

/*select h.position, h.first_name
from humans h
group by h.position, h.first_name;*/

select count(id) employed_count
from humans
where position != 'Unemployed';

select position, avg(income) average_income, count(id) quantity
from humans
where position != 'Unemployed'
group by position
order by average_income desc;

-- select
-- from
-- join
-- where
--group by
-- order by