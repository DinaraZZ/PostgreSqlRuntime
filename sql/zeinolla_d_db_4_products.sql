drop table if exists product_characteristics;
drop table if exists characteristics;
drop table if exists product;
drop table if exists category;


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
    primary key (id),
    foreign key (category_id) references category (id)
);

create table characteristics
(
    id          serial8,
    category_id int8    not null,
    name        varchar not null,
    primary key (id),
    foreign key (category_id) references category (id)
);

create table product_characteristics
(
    id                 serial8,
    product_id         int8    not null,
    characteristics_id int8    not null,
    description        varchar not null,
    primary key (id),
    foreign key (product_id) references product (id),
    foreign key (characteristics_id) references characteristics (id)
);

insert into category(name)
values ('Процессоры'),
       ('Мониторы');

insert into product(category_id, name)
values (1, 'Intel Core I9 9900'),
       (1, 'AMD Ryzen R7 7700'),
       (2, 'Samsung SU556270'),
       (2, 'AOC Z215S659');

insert into characteristics(category_id, name)
values (1, 'Производитель'),
       (1, 'Количество ядер'),
       (1, 'Сокет'),
       (2, 'Производитель'),
       (2, 'Диагональ'),
       (2, 'Матрица'),
       (2, 'Разрешение');

insert into product_characteristics (product_id, characteristics_id, description)
values (1, 1, 'Intel'),
       (1, 2, '8'),
       (1, 3, '1250'),
       (2, 1, 'Samsung'),
       (2, 2, '12'),
       (2, 3, 'AM4'),
       (3, 4, 'Samsung'),
       (3, 5, '27'),
       (3, 6, 'TN'),
       (3, 7, '2560*1440'),
       (4, 4, 'AOS'),
       (4, 5, '21.5'),
       (4, 6, 'AH-IPS'),
       (4, 7, '1920*1080');

-- все характ, к категории монитор
select c.name Мониторы
from characteristics c
         join category cat on c.category_id = cat.id
where cat.id = '2';

-- 3 (товар)
select p.name Товар, c.name Характеристики
from characteristics c,
     category cat
         join product p on cat.id = p.category_id
where p.id = '4'
  and c.category_id = cat.id;

--
select p.name Товар, c.name Категория, c2.name Характеристики, pc.description Описание
from product_characteristics pc
         join product p on pc.product_id = p.id
         join category c on p.category_id = c.id
         join characteristics c2 on pc.characteristics_id = c2.id
where p.id = 3;