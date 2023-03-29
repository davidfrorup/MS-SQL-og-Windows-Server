
USE Master;
GO
alter database [TEC] set single_user with rollback immediate

IF EXISTS (select * from sys.databases where name = 'TEC')
BEGIN 
    DROP DATABASE TEC
    
END
    CREATE DATABASE TEC;
   	GO

USE TEC

CREATE TABLE post_nr_by
(

	post_nr int NOT NULL,
	by_navn varchar(250) NULL,
	Gade varchar(250) NULL,
	Firma varchar(250) NULL,
	Provins varchar(250) NULL,
	Land int NULL,

	PRIMARY KEY (post_nr)
)

ALTER TABLE post_nr_by REBUILD WITH (IGNORE_DUP_KEY = ON)


CREATE TABLE klasse
(
	klasse_id int IDENTITY(1, 1) NOT NULL,
	klasse varchar(250) NOT NULL,

	PRIMARY KEY (klasse_id)
)


CREATE TABLE elev
(
	elev_id int IDENTITY NOT NULL,
	fornavn varchar(250) NOT NULL,
	efternavn varchar(250) NOT NULL,
	adresse varchar(250) NOT NULL,
	post_nr int NOT NULL,
	klasse_id int,

	PRIMARY KEY (elev_id),
	FOREIGN KEY(post_nr) REFERENCES post_nr_by(post_nr),
	FOREIGN KEY(Klasse_id) REFERENCES klasse(klasse_id)
)


CREATE TABLE laerer
(
	laerer_id int IDENTITY(1, 1) NOT NULL,
	fornavn varchar(250) NOT NULL,
	efternavn varchar(250) NOT NULL,
	adresse varchar(250) NOT NULL,
	post_nr int NOT NULL,
	klasse_id int NULL,

	PRIMARY KEY(laerer_id),
	FOREIGN KEY(post_nr) REFERENCES post_nr_by(post_nr),
	FOREIGN KEY(Klasse_id) REFERENCES klasse(klasse_id)
)





--INSERT INTO elev (elev_id, fornavn, efternavn, adresse, post_nr, klasse_id)
	--VALUES ('1', 
BULK INSERT dbo.elev
FROM 'C:\Users\Administrator\Desktop\elev.csv'
WITH
(
        DATAFILETYPE = 'char',
        FIRSTROW=2,
		FIELDTERMINATOR=';'
)
GO


BULK INSERT dbo.laerer
FROM 'C:\Users\Administrator\Desktop\laerer.csv'
WITH
(
        DATAFILETYPE = 'char',
        FIRSTROW=2,
		FIELDTERMINATOR=';'
)
GO


BULK INSERT dbo.klasse
FROM 'C:\Users\Administrator\Desktop\klasse.csv'
WITH
(
        DATAFILETYPE = 'char',
        FIRSTROW=2,
		FIELDTERMINATOR=';'
		
)
GO

BULK INSERT dbo.post_nr_by
FROM 'C:\Users\Administrator\Desktop\postnummer.csv'
WITH
(
        DATAFILETYPE = 'char',
        FIRSTROW=2,
		FIELDTERMINATOR=';'
		


)
GO

SELECT laerer.fornavn, laerer.efternavn, laerer.adresse, post_nr_by.post_nr, post_nr_by.by_navn
FROM post_nr_by
inner JOIN laerer ON post_nr_by.post_nr=laerer.post_nr

SELECT elev.fornavn, elev.efternavn, klasse.klasse
FROM klasse
INNER JOIN elev on klasse.klasse_id=elev.klasse_id
ORDER BY elev.fornavn

SELECT elev.fornavn, elev.efternavn, klasse.klasse, elev.adresse, post_nr_by.post_nr, post_nr_by.by_navn
FROM post_nr_by
INNER JOIN elev on post_nr_by.post_nr=elev.post_nr
INNER JOIN klasse on elev.klasse_id=klasse.klasse_id
ORDER BY klasse.klasse_id




