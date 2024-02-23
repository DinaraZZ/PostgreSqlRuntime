drop table if exists product_category_discounts;
drop table if exists discounts;
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
    price       int8    not null,
    primary key (id),
    foreign key (category_id) references category (id)
);

create table discounts
(
    id       serial8,
    discount int8 not null,
    primary key (id)
);

create table product_category_discounts
(
    id          serial8,
    category_id int8 default null,
    product_id  int8 default null,
    discount_id int8 not null,
    primary key (id),
    foreign key (category_id) references category (id),
    foreign key (product_id) references product (id),
    foreign key (discount_id) references discounts (id)
);

insert into category(name)
values ('Smartphone'),
       ('Car'),
       ('Book');

insert into product(category_id, name, price)
values (1, 'iPhone 12 Pro', 1000),
       (2, 'Kia Rio', 10000),
       (1, 'Samsung Galaxy S5', 1200),
       (3, 'Alice in Wonderland', 15),
       (3, 'Billy Milligan', 16),
       (2, 'Toyota Corolla', 1200);

insert into discounts(discount)
values (2),
       (10),
       (5),
       (15),
       (20),
       (50);

insert into product_category_discounts(category_id, product_id, discount_id)
values (1, null, 2); --otdelno tabl