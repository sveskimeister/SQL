-- kommentaar
--teeme andmebaasi e db
create database TARpe22

-- db kustutamine
drop database TARpe22

--tabeli loomine
create table Gender
(
Id int not null primary key,
Gender nvarchar (10) not null
)

---- andmete sisestamine
insert into Gender (Id, Gender)
values (2, 'Male')
insert into Gender (Id, Gender)
values (1, 'Female')
insert into Gender (Id, Gender)
values (3, 'Unknown')

--- Sama Id v��rtusega rida ei saa sisestada
select * from Gender

--- teeme uue tabeli
create table Person
(
Id int not null primary key,
Name nvarchar(30),
Email nvarchar(30),
GenderId int
)

--- vaatame Person tabeli sisu
select * from Person

--- andmete sisestamine
insert into Person (Id, Name, Email, GenderId)
values(1, 'Superman', 'w@w.com', 1)
insert into Person (Id, Name, Email, GenderId)
values(2, 'Wonderwoman', 's@s.com', 2)
insert into Person (Id, Name, Email, GenderId)
values(3, 'Batman', 'b@b.com', 2)
insert into Person (Id, Name, Email, GenderId)
values(4, 'Aquaman', 'a@a.com', 2)
insert into Person (Id, Name, Email, GenderId)
values(5, 'Catwoman', 'c@c.com', 1)
insert into Person (Id, Name, Email, GenderId)
values(6, 'Antman', 'ant"ant.com', 2)
insert into Person (Id, Name, Email, GenderId)
values(8, NULL, NULL, 2)

select * from Person

-- v��rv�tme �henduse loomine kahe tabeli vahel
alter table Person add constraint tblPerson_GenderId_FK
foreign key (GenderId) references Gender(Id)

--- kui sisestad uue rea andmeid ja ei ole sisestanud GenderId all v��rtust siis
--- see automaatselt sisestab tabelisse v��rtuse 3 ja selleks on unknown
alter table Person
add constraint DF_Persons_GenderId
default 3 for GenderId

insert into Person (Id, Name, Email)
values (9, 'Ironman', 'i@i.com')

select * from Person

-- piirangu maha v�tmine
alter table Person
drop constraint DF_Persons_GenderId

--- lisame uue veeru
alter table Person
add Age nvarchar(10)

--- lisame vanuse piirangu sisestamisel
--- ei saa lisada suuremat v��rtust kui 801
alter table Person
add constraint CK_Person_Age check (Age > 0 and Age < 801)

-- rea kustutamine
-- kui paned vale Id, siis ei muuda midagi
delete from Person where Id = 11

select * from Person

-- kuidas uuendada andmeid tabelis
update Person 
set Age = 50
where Id = 1

-- lisame juurde uue veeru
alter table Person
add City nvarchar(50)

-- k�ik,kes elavad Gothami linnas
select * from Person where City = 'Gotham'
-- k�ik kes ei ela Gothami linnas
select * from Person where City != 'Gotham'
-- teine variant 
select * from Person where City not 'Gotham'
-- kolmas variant 
select * from Person where City <> 'Gotham'

-- n�itab teatud vanusega inimesi
select * from Person where Age = 800 or Age = 35 or Age = 27
select * from Person where Age in (800, 35, 27)

-- n�itab teatud vanusevahemikus olevaid inimesi
select * from Person where Age between 20 and 35

-- wildcard e n�itab k�ik g-t�hega linnad
select * from Person where City like 'g%'
--n�itab, k�ik emailid, milles on @ m�rk
select * from Person where Email like '%@%'

--- n�itab k�iki, kellel ei ole @-m�rki emailis
select * from Person where Email not like '%@%'

--- n�itab, kellel on emailis ees ja peale @-m�rki
--- ainult �ks t�ht
select * from Person where Email like '_@_.com'

--- k�ik, kellel ei ole nimes esimene t�ht W, A, C
select * from Person where Name like '[^WAC]%'

--- kes elavad Gothamis ja New Yorkis
select * from Person where (City = 'Gotham' or City = 'New York')

--k�ik, kes elavad Gothamis ja New Yorkis ning 
--- alla 30 eluaastat
select * from Person where 
(City = 'Gotham' or City = 'New York')
and Age >= 30

--- kuvab t�hestikulises j�rjekorras inimesi
--- ja v�tab aluseks nime
select * from Person order by Name
--- kuvab vastupidises j�rjekorras 
select * from Person order by Name desc


--- v�tab kolm esimest rida
select top 3 * from Person

--- 2 tund
---muudab Age muutuja int-iks ja n�itab vanuselises j�rjekorras
select * from Person order by CAST(Age as int)

-- l�ikide isikute koondvanus
select SUM(CAST)Age as int)) from Person

--- n�itab, k�ige nooremat isikut
select MIN(CAST(Age as int)) from Person

--- n�itab 
select MAX(CAST(Age as int)) from Person

--- n�eme konkreetsetes linnades olevate isikute koondvanust
---enne oli Age string, aga p�ringu ajal muutsime selle int-ks
select City, SUM(CAST(Age as int) as TotalAge from Person group by City

--- kuidas saab koodiga muuta tabeli andmet��pi ja selle pikkust
alter table Person
alter column Name nvarchar(25)

alter table Person
alter column Age int

--- kuvab esimeses reas v�lja toodud j�rjestuses ja muudab Age-i TotalAge-ks
--- teeb j�rjestuse vaatesse: City, GenderId ja j�rjestuse omakorda City veeru j�rgi
select City, GenderId, SUM(Age) as TotalAge from Person
group by City, GenderId order by City

--- n�itab mitu rida on selles tabelis
select COUNT(*) from Person

--- veergude lugemine 
select COUNT(*)
from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME = 'Person'

---n�itab tulemust mitu inimest ib GenerId v��rtusega 2 konkreetses linnas
--- arvutab kokku vanuse
select GenderId, City, SUM(Age) as TotalAge, COUNT(Id) as [Total Person(s)]
from Person
where GenderId = '2'
group by GenderId, City

---n�itab mitu inimest on vanemad kui 41 ja kui palju igas linnas
select GenderId, City, SUM(Age) as TotalAge, COUNT(Id) as [Total Person(s)]
from Person
group by GenderId, City having SUM(Age) > 41

--- loome uue tabeli
create table Department
(
Id int primary key,
DepartmentName nvarchar(50),
Location nvarchar(50),
DepartmentHead nvarchar(50)
)

create table Employees
(
Id int primary key,
Name nvarchar(50),
Gender nvarchar(50),
Salary nvarchar(50),
DepartmentId int
)

insert into Employees (Name, Gender, Salary, DepartmentId)
values ('Tom', 'Male','4000', 1)
insert into Employees (Name, Gender, Salary, DepartmentId)
values ('Pam', 'Female','3000', 3)
insert into Employees (Name, Gender, Salary, DepartmentId)
values ('John', 'Male','3500', 1)
insert into Employees (Name, Gender, Salary, DepartmentId)
values ('Sam', 'Male', '4500', 2)
insert into Employees (Name, Gender, Salary, DepartmentId)
values ('Todd', 'Male', '2800', 2)
insert into Employees (Name, Gender, Salary, DepartmentName)
values ('Ben', 'Male', '7000', 1)