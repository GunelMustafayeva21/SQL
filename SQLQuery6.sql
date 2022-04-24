create database SocialNetwork
use SocialNetwork

create table People(
id int primary key identity(1,1),
name nvarchar(50),
surname nvarchar(50),
age int)
drop table People
insert into People values ('Lexi', 'Rivera', 18)
insert into People values ('Brent', 'Rivera', 19)
insert into People values ('Lexi', 'Hensler', 20)
insert into People values ('Alan', 'Stokes', 17)
insert into People values ('Andrew', 'Dawilla', 16)
insert into People values ('Ben', 'Azelart', 21)

create table Users(
id int primary key identity(1,1),
login nvarchar(100) unique not null,
password nvarchar(10) unique not null,
email nvarchar(100) unique not null,
PeopleId int references People(id))

drop table Users

insert into Users values ('LRivera', 'lexi123', 'LexiRVR@code.edu.az', 3)
insert into Users values ('BRivera', 'brent456', 'BrentRVR@code.edu.az', 4)
insert into Users values ('LHensler', 'lexi987', 'LexiH@code.edu.az', 5)
insert into Users values ('AStokes', 'alan000', 'AlanS@code.edu.az', 6)

delete from Users

create table Posts(
id int primary key identity(1,1),
content nvarchar(1000),
sharedTime date,
UserId int references Users(id),
likeCount int,
isDeleted bit default 'false')

insert into Posts values ('Hello, how r u?', '2010-12-04', 2, 100, 0)
insert into Posts values ('Today is My Birthday', '2010-05-09', 3, 155, 0)
insert into Posts values ('I bought new car', '2010-02-06', 4,200, 0)
insert into Posts values ('Do u wanna help to poor people', '2010-07-21', 5, 800, 0)

delete from Posts
drop table Posts


create table Comments(
id int primary key identity(1,1),
content nvarchar(200),
PostId int references Posts(id),
UserId int references Users(id),
likeCount int,
isDeleted bit )

insert into Comments values ('Hello', 4, 3, 300, 0) 
insert into Comments values ('Fine, Thanks', 4, 4, 125, 0)
insert into Comments values ('and you?', 4, 5, 250, 0)
insert into Comments values ('Thanks we are good', 4, 3, 125, 0)


insert into Comments values ('Happy Birthday bro', 5, 2, 300, 0)
insert into Comments values ('be happy always', 5, 2, 250, 0)
insert into Comments values ('Happy Birthday my friend ', 5, 4, 325, 0)
insert into Comments values ('why you did not invite me to party?', 5, 4,270, 0)
insert into Comments values ('Congratulations', 5, 5, 350, 0)


insert into Comments values ('Nice', 6, 2, 157, 0)
insert into Comments values ('I want to buy new car too', 6, 2, 165, 0)

insert into Comments values ('its color is not good', 6, 3, 34, 0)
insert into Comments values ('but it is okey', 6, 3, 45, 0)

insert into Comments values ('i liked', 6, 5, 23, 0)
insert into Comments values ('How much is it?', 6, 5, 89, 0)



insert into Comments values ('yes of course', 7, 2, 400, 0)
insert into Comments values ('how can i help?', 7, 3, 450, 0)
insert into Comments values ('they have little company', 7, 4, 475, 0)


drop table Comments
delete from Comments

--Query 1
Select p.content 'Posts', Count(c.id) 'Comment Count' from Comments as c 
join Posts as p on c.PostId=p.id group by p.content order by 'Comment Count'

--Query 2
create view ShowAllInfo as
select pl.name 'Name', pl.surname 'Surname', pl.age 'Age',
u.login 'Login of User', u.password 'Password of User', u.email 'Mail of User',
p.content 'Post', p.sharedTime 'Shared Time', p.likeCount 'Like Count of Post',
c.content 'Comments of Post',c.likeCount 'Like Count of Comment', c.UserId 'Commenter Id'
from Comments as c 
join Posts as p on c.PostId=p.id 
join Users as u on p.UserId=u.id
join People as pl on u.PeopleId=pl.id

select * from ShowAllInfo

--Query 3
create trigger DeleteComment on Comments 
instead of delete as begin 
update Comments set isDeleted='true' where id=(select id from deleted Comments)
end 

create trigger DeletePost on Posts
instead of delete as begin 
update Posts set isDeleted='true' where id=(select id from deleted Posts)
end 

delete from Posts where id=4
delete from Comments where id=20