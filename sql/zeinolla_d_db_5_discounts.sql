drop table if exists product_discounts;
drop table if exists category_discounts;
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

create table product_discounts
(
    id          serial8,
    product_id  int8 default null,
    discount_id int8 not null,
    primary key (id),
    foreign key (product_id) references product (id),
    foreign key (discount_id) references discounts (id)
);

create table category_discounts
(
    id          serial8,
    category_id int8 default null,
    discount_id int8 not null,
    primary key (id),
    foreign key (category_id) references category (id),
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

insert into category_discounts(category_id, discount_id)
values (1, 2),
       (2, 3),
       (1, 1),
       (3, 6);

insert into product_discounts(product_id, discount_id)
values (1, 4),
       (3, 2),
       (4, 5),
       (6, 1);

-- скидка товаров по категориям
select p.*, sum(d.discount) final_discount, (100 - sum(d.discount)) / 100 * p.price final_price
from product p
         join category c on c.id = p.category_id
         join category_discounts cd on cd.category_id = c.id
         join discounts d on d.id = cd.discount_id
-- group by cd.category_id, p.id, p.category_id, p.name, p.price
group by p.id, c.id
order by c.id;

-- категорию с наиб процентом с лимитом
select c.*, sum(d.discount) total_discount
from category c
         join category_discounts cd on cd.category_id = c.id
         join discounts d on d.id = cd.discount_id
group by c.id
order by total_discount desc
limit 1; -- кол-во выводимых строк

update category_discounts
set discount_id = 6
where category_id = 2;
-- категорию с наиб процентом с подзапросом
select c.*, sum(d.discount) td
from category c
         join category_discounts cd on cd.category_id = c.id
         join discounts d on d.id = cd.discount_id
group by c.id
having sum(d.discount) = (select sum(d.discount) total_discount
                          from category_discounts cd
                                   join discounts d on d.id = cd.discount_id
                          group by cd.category_id
                          order by total_discount desc
                          limit 1);
-- max

-- подзапрос
select p.*
from product p
where p.price = (select max(p.price) from product p);


-- INNER JOIN
select c.name, avg(p.price)
from category c
         join product p on c.id = p.category_id
group by c.id;

delete
from product_discounts
where product_id = 4;
delete
from product
where category_id = 3;
-- LEFT JOIN
select c.name, coalesce(avg(p.price), 0)
from category c
         left join product p on c.id = p.category_id
group by c.id;

-- RIGHT JOIN
select c.name, coalesce(avg(p.price), 0)
from product p
         right join category c on p.category_id = c.id
group by c.id;

insert into product(category_id, name, price)
values (1, 'iPhone 4S', 500);
insert into product_discounts(product_id, discount_id)
values (7, 4);
insert into product_discounts(product_id, discount_id)
values (7, 1);
-- товары со скидками категорий и самого товара
select p.*,
       d1.disc                                                                 category_discount,
       d2.disc                                                                 product_discount,
       p.price - (coalesce(d1.disc, 0) + coalesce(d2.disc, 0)) * p.price / 100 final_price
from product p
         left join category c on c.id = p.category_id
         left join category_discounts cd on cd.category_id = c.id
         left join product_discounts pd on pd.product_id = p.id
         left join (select c1.id c_id, coalesce(sum(d.discount), 0) disc
                    from discounts d
                             join category_discounts cd1 on d.id = cd1.discount_id
                             join category c1 on cd1.category_id = c1.id
                    group by c1.id) d1 on d1.c_id = c.id
         left join (select p1.id p_id, coalesce(sum(d.discount), 0) disc
                    from discounts d
                             join product_discounts pd1 on d.id = pd1.discount_id
                             join product p1 on pd1.product_id = p1.id
                    group by p1.id) d2 on d2.p_id = p.id
group by p.id, c.id, d1.disc, d2.disc
order by c.id;