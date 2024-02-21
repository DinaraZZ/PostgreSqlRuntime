drop table if exists "user";
drop table if exists category;
drop table if exists article;
drop table if exists commentary;

create table "user"
(
    id         serial8,
    login      varchar not null,
    first_name varchar not null,
    last_name  varchar not null,
    primary key (id)
);

create table category
(
    id   serial8,
    name varchar,
    primary key (id)
);

create table article
(
    id          serial8,
    category_id int8    not null,
    user_id     int8    not null,
    status      bool default false,
    title       varchar not null,
    content     text,
    primary key (id),
    foreign key (category_id) references category (id),
    foreign key (user_id) references "user" (id)
);

create table commentary
(
    id         serial8,
    user_id    int8 not null,
    article_id int8 not null,
    comment    text not null,
    primary key (id),
    foreign key (user_id) references "user" (id)
);

insert into "user" (login, first_name, last_name)
values ('jack_nb', 'Jack', 'Brown'),
       ('ben_10', 'Ben', 'Tan'),
       ('jess_ca', 'Jessica', 'Fox');

insert into category (name)
values ('Horror'),
       ('Detective'),
       ('Comedy');

insert into article (category_id, user_id, status, title, content)
values (1, 3, true, 'House by the River', 'There was a black house located near the river.'),
       (3, 2, false, 'White chicks', 'Two detectives dressed like two daughters of a rich man');

insert into commentary(user_id, article_id, comment)
values (1, 1, 'Good'),
       (3, 1, 'Very interesting!');

-- кол-во опубликованных статаей, которые написал каждый польз
select concat(u.first_name, ' ', u.last_name) full_name, count(a.id) articles_number
from "user" u
         join article a on u.id = a.user_id
where a.status = true
group by u.id;

-- все статьи: id, category name, user name, title, status, кол-во комментариев
select a.id,
       c.name                                 category,
       concat(u.first_name, ' ', u.last_name) author,
       a.title,
       a.status,
       count(cm.id)                           comments_number
from article a
         join "user" u on a.user_id = u.id
         join category c on a.category_id = c.id
         join commentary cm on a.id = cm.article_id
group by a.id, c.name, author;