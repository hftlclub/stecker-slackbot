create database db;

use db;


CREATE TABLE `termine` (
  `id` INT NOT NULL AUTO_INCREMENT, 
  `name` TEXT,
  `datum` date,
  PRIMARY KEY (`id`)
  )
  

CREATE TABLE `nutzer` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` TEXT,
  primary key (`id`)
  )

CREATE TABLE `terminteilnehmer` (
  `termin` INT not null,
  `teilnehmer` int not null,
  
  FOREIGN KEY (termin) REFERENCES termine(id),
  foreign key (teilnehmer) references nutzer(id)
  )
  


select * from termine
select * from nutzer
select * from terminteilnehmer
