------ Один к одному
drop table if exists users;
drop table if exists user_data;

create table users
(
    id           serial8,
    user_data_id int8    not null,
    login        varchar not null,
    password     varchar not null,
    primary key (id),
    unique (user_data_id),
    foreign key (user_data_id) references user_data (id)
);

create table user_data
(
    id              serial8,
    document_number varchar not null,
    f_name          varchar not null,
    l_name          varchar not null,
    birthdate       date    not null,
    primary key (id)
);

insert into user_data(document_number, f_name, l_name, birthdate)
values ('US1', 'NameFirst', 'LastNameFirst', '2001-01-01'),
       ('US2', 'NameSecond', 'LastNameSecond', '2002-02-02');

insert into users(user_data_id, login, password)
values (1, 'LoginFirst', '1111'),
       (2, 'LoginSecond', '2222');

-- аллиасы (u, ud)
select u.id, u.login, ud.f_name, ud.l_name
from users u
         join user_data ud on ud.id = u.user_data_id;


------ Один ко многим
drop table if exists category;
drop table if exists product;

create table category
(
    id   serial8,
    name varchar not null,
    primary key (id)
);

create table product
(
    id          serial8,
    category_id int8,
    name        varchar not null,
    price       int8    not null,
    primary key (id),
    foreign key (category_id) references category (id)
);

insert into category(name)
values ('Smartphone'),
       ('Car');

insert into product(category_id, name, price)
values ('1', 'iPhone 12 Pro', 1000),
       ('2', 'Kia Rio', 10000),
       ('1', 'Samsung Galaxy S5', '1200');

select c.name, p.name, p.price
from category c
         join product p on c.id = p.category_id
group by c.id, p.id
order by c.name, p.price desc;

select c.name, round(avg(p.price)) average_price
from product p
         join category c on c.id = p.category_id
group by c.id
order by average_price desc;
