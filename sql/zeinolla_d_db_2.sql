------ Один к одному
drop table if exists product_order;
drop table if exists orders;
drop table if exists product;
drop table if exists users;
drop table if exists user_data;
drop table if exists category;
drop table if exists discounts;

create table user_data
(
    id              serial8,
    document_number varchar not null,
    f_name          varchar not null,
    l_name          varchar not null,
    birthdate       date    not null,
    primary key (id)
);

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


------ Многие ко многим
create table discounts
(
    id       serial8,
    discount int8 not null,
    primary key (id)
);

create table orders
(
    id          serial8,
    discount_id int8,
    status      varchar   not null,
    date_time   timestamp not null,
    primary key (id),
    foreign key (discount_id) references discounts (id)
);

create table product_order
(
    id               serial8,
    product_id       int8 not null,
    orders_id        int8 not null,
    product_quantity int8 not null,
    primary key (id),
    foreign key (product_id) references product (id),
    foreign key (orders_id) references orders (id)
);

insert into discounts(discount)
values (5),
       (10),
       (15);

insert into orders(status, date_time, discount_id)
values ('Доставлен', '2022-01-12 12:45', 1),
       ('Отправлен', '2024-01-30 05:06', 3),
       ('Доставлен', '2024-01-02', 2);

insert into orders(status, date_time)
values ('Оформлен', '2024-02-22 21:16');

insert into product_order(product_id, orders_id, product_quantity)
values (1, 3, 6),
       (1, 1, 1),
       (3, 2, 2),
       (2, 4, 4),
       (3, 4, 6);

select o.*,
--        count(o.id) products_quantity,
       sum(po.product_quantity)                                                                products_quantity, -- за счёт группировки по o.id
--        sum(p.price * po.product_quantity) order_price
       sum(p.price * po.product_quantity - (d.discount * p.price / 100) * po.product_quantity) order_price
from orders o
         join product_order po on o.id = po.orders_id
         join product p on p.id = po.product_id
         join discounts d on o.discount_id = d.id
group by o.id
order by o.id;

--
select o.id,
       coalesce(o.discount_id, 0) discount,
       o.status,
       o.date_time,
       sum(po.product_quantity)                                                                             products_quantity,
       sum(p.price * po.product_quantity - (coalesce(d.discount, 0) * p.price / 100) * po.product_quantity) order_price
from orders o
         join product_order po on o.id = po.orders_id
         join product p on p.id = po.product_id
         left join discounts d on o.discount_id = d.id
group by o.id
order by o.id;









