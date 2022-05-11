-- commento su una riga
/* commento su più 
righe */

create database Musei

create table Museo(
CodiceMuseo int,
Nome varchar(50) not null unique,
Citta varchar(30) not null default 'Sconosciuta',
constraint PK_Museo primary key (CodiceMuseo)
)

create table Artista(
IdArtista int constraint PK_ARTISTA primary key identity(1,1),
Nome varchar(50) not null constraint UNQ_NOMEARTISTA unique,
Nazionalita varchar(30) not null
)

create table Opera(
CodiceOpera char(5) constraint PK_Opera primary key,
Titolo varchar(50) not null,
CodiceMuseo int not null constraint FK_Museo foreign key references Museo(CodiceMuseo),
idArtista int not null,
constraint FK_Artista foreign key (idArtista) references Artista(IdArtista) 
)
--alter table Opera add constraint FK_Artista foreign key (idArtista) references Artista(IdArtista) on delete cascade;

create table Personaggio(
IdPersonaggio int primary key identity(1,1),
Nome varchar(50) not null
);

create table OperaPersonaggio(
CodiceOpera char(5) not null foreign key references Opera(CodiceOpera),
IdPersonaggio int not null foreign key references Personaggio(IdPersonaggio),
constraint PK_Opera_Personaggio primary key(CodiceOpera, IdPersonaggio)
)
--alter table OperaPersonaggio add constraint FK_Opera foreign key (CodiceOpera) references Opera(CodiceOpera) on delete cascade
--insert
insert into Museo values (100, 'National Gallery', 'Londra');
insert into Museo (CodiceMuseo, Citta, Nome) values (101, 'Londra', 'Museo arte contemporanea')
insert into Museo values (102, 'Maxxi', 'Roma'), 
						 (103, 'Museum', 'Londra')
insert into Museo values (104, 'Nuovo museo di Londra', 'Londra');

select * from Museo;
select * from Artista;
select * from Opera;
select * from Personaggio;
select * from OperaPersonaggio;

insert into Artista values ('Tiziano', 'Italia');
insert into Artista values ('Michelangelo', 'Italia');
insert into Artista values('Picasso', 'Spagna');
insert into Artista values('ArtistaAAAA', 1234);
insert into Artista values('Picasso', 'Spagna');--errore
insert into Artista values('Michele', 'Italia');

insert into Opera values ('Op001', 'Venere', 100, 1);
insert into Opera values ('Op002', 'Pietà', 100,2);
insert into Opera values ('Op003', 'Guernica', 100,3);
insert into Opera values ('Op004', 'OperaAstratta', 101,3);
insert into Opera values ('Op005', 'Opera5', 103,1);

insert into Personaggio values ('Madonna');
insert into Personaggio values ('Dea Venere');
insert into Personaggio values ('Personaggio1');
insert into Personaggio values ('Personaggio2');

insert into OperaPersonaggio values ('Op001',2);
insert into OperaPersonaggio values ('Op002',1);

--update
update Artista set Nome='Giotto' where IdArtista=5;

--delete
delete from Artista where IdArtista=4;
--delete from Artista where IdArtista=1; -- no cancellazione perchè FK on delete no action

--selezionare tutti gli artisti con nazionalità= "italia"
select * 
from Artista
where Nazionalita='Italia';

--elenco distinto delle nazioanlità
select distinct Nazionalita 
from Artista

--selezionare gli artisti il cui nome inizia per M
select *
from Artista
where Nome like 'M%'

--alias
select IdArtista as Codice, Nome as [Nome Artista], Nazionalita as 'Nazione' 
from Artista

--selezionare tutti gli artisti che iniziano per T e sono italiani
select *
from Artista
where Nome like 'T%' and Nazionalita='Italia'

--selezionare tutti gli artisti che iniziano per T o che sono italiani
select *
from Artista
where Nome like 'T%' or Nazionalita='Italia'

--selezionare le opere di tiziano
select * 
from Opera, Artista
where Opera.idArtista=Artista.IdArtista
and Artista.Nome='tiziano';

--join
select * 
from Opera o, Artista as a
where o.idArtista=a.IdArtista

select * 
from Opera inner join Artista on Opera.idArtista=Artista.IdArtista

select * 
from Opera right join Artista on Opera.idArtista=Artista.IdArtista



--Esercitazione
--1.Il nome dell’artista ed il titolo delle opere conservate alla “Galleria degli Uffizi” o alla “National Gallery”.
select a.Nome, o.Titolo
from Opera o join Artista a on o.idArtista=a.IdArtista
			 join Museo m on m.CodiceMuseo=o.CodiceMuseo
--where m.Nome='Galleria degli Uffizi' or m.Nome='National Gallery';
where m.Nome in('Galleria degli Uffizi','National Gallery');


--2.Il nome dell’artista ed il titolo delle opere di artisti spagnoli conservate nei musei di Firenze
select a.Nome, o.Titolo
from Opera o join Artista a on o.idArtista=a.IdArtista
			 join Museo m on m.CodiceMuseo=o.CodiceMuseo
where a.Nazionalita='Spagna' and m.Citta='Firenze'

--3.Il codice ed il titolo delle opere di artisti italiani conservate nei musei di Londra, in cui è rappresentata la Madonna
select o.CodiceOpera, o.Titolo
from Opera o join Artista a on o.idArtista=a.IdArtista
			 join Museo m on m.CodiceMuseo=o.CodiceMuseo
			 join OperaPersonaggio op on op.CodiceOpera=o.CodiceOpera
			 join Personaggio p on p.IdPersonaggio=op.IdPersonaggio
where a.Nazionalita='italia' and m.Citta='londra' and p.Nome='madonna'


--4.Per ciascun museo di Londra, il numero di opere di artisti italiani ivi conservate
select m.Nome, COUNT(o.CodiceOpera) as [Numero opere]
from Opera o join Artista a on o.idArtista=a.IdArtista
			 join Museo m on m.CodiceMuseo=o.CodiceMuseo
where m.Citta='Londra' and a.Nazionalita='Italia'
group by m.Nome

--5.Il nome dei musei di Londra che non conservano opere di Tiziano
--sbagliata
--select *
--from Opera o join Artista a on o.idArtista=a.IdArtista
--			 join Museo m on m.CodiceMuseo=o.CodiceMuseo
--where m.Citta='Londra' 
--and a.Nome<>'Tiziano'

select m.Nome
from Museo m 
where m.Citta='Londra' 
and m.Nome not in (
select m.Nome
from Opera o join Artista a on o.idArtista=a.IdArtista
			 join Museo m on m.CodiceMuseo=o.CodiceMuseo
where a.Nome='Tiziano');

--6.Il nome dei musei di Londra che conservano solo opere di Tiziano
select m.Nome
from Opera o join Artista a on o.idArtista=a.IdArtista
			 join Museo m on m.CodiceMuseo=o.CodiceMuseo
where m.Citta='Londra' and a.Nome='Tiziano' 
and m.Nome not in (
select m.Nome
from Opera o join Artista a on o.idArtista=a.IdArtista
			 join Museo m on m.CodiceMuseo=o.CodiceMuseo
where a.Nome<>'Tiziano');

--7.I musei che conservano almeno 2 opere di artisti italiani
select m.Nome, COUNT(o.CodiceOpera)
from Opera o join Artista a on o.idArtista=a.IdArtista
			 join Museo m on m.CodiceMuseo=o.CodiceMuseo
where a.Nazionalita='italia'
group by m.Nome
having COUNT(*)>=2;

--8.Per ogni museo, il numero di opere divise per la nazionalità dell’artista
select m.Nome, a.Nazionalita, COUNT(*) as 'Numero Opere'
from Opera o join Artista a on o.idArtista=a.IdArtista
			 join Museo m on m.CodiceMuseo=o.CodiceMuseo
group by m.Nome, a.Nazionalita
