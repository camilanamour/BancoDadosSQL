CREATE DATABASE locadora
GO
USE locadora

-- Criar Entidades
CREATE TABLE Filme(
id		INT			NOT NULL	IDENTITY(1001,1),
titulo	VARCHAR(40)	NOT NULL,
ano		INT			NULL		CHECK(ano <= 2021)
PRIMARY KEY(id)
)
GO
CREATE TABLE Estrela(
id		INT			NOT NULL	IDENTITY(9901,1),
nome	VARCHAR(50)	NOT NULL
PRIMARY KEY(id)
)
GO
CREATE TABLE Filme_Estrela(
id_filme	INT		NOT NULL,
id_estrela	INT		NOT NULL
PRIMARY KEY(id_filme, id_estrela)
FOREIGN KEY(id_filme) REFERENCES Filme(id),
FOREIGN KEY(id_estrela) REFERENCES Estrela(id)
)
GO
CREATE TABLE DVD(
num				INT			NOT NULL	IDENTITY(10001,1),
data_fabricacao	DATE		NOT NULL	CHECK(data_fabricacao < GETDATE()),		
id_filme		INT			NOT NULL
PRIMARY KEY(num)
FOREIGN KEY(id_filme) REFERENCES Filme(id)
)
GO
CREATE TABLE Cliente(
num_cadastro	INT				NOT NULL	IDENTITY(5501,1),
nome			VARCHAR(70)		NOT NULL,
logradouro		VARCHAR(150)	NOT NULL,
numero			INT				NOT NULL	CHECK(numero > 0),
cep				CHAR(8)			NULL		CHECK(LEN(cep) = 8)
PRIMARY KEY(num_cadastro)
)
GO
CREATE TABLE Locacao(
num_DVD			INT				NOT NULL,
num_cadastro	INT				NOT NULL,
data_locacao	DATE			NOT NULL	DEFAULT(GETDATE()),
data_devolucao	DATE			NOT NULL,
valor			DECIMAL(7,2)	NOT NULL	CHECK(valor > 0),
CONSTRAINT chk_dt CHECK(data_devolucao > data_locacao),
PRIMARY KEY(num_DVD, num_cadastro, data_locacao),
FOREIGN KEY(num_DVD) REFERENCES DVD(num),
FOREIGN KEY(num_cadastro) REFERENCES Cliente(num_cadastro)
)

ALTER TABLE Estrela
ADD nome_real	VARCHAR(50)	NULL

ALTER TABLE	Filme
ALTER COLUMN titulo VARCHAR(80) NOT NULL

DROP TABLE Filme
DROP TABLE Estrela
DROP TABLE Filme_Estrela
DROP TABLE DVD
DROP TABLE Cliente
DROP TABLE Locacao

EXEC sp_help 
EXEC sp_help Estrela

INSERT INTO Filme VALUES
('Whiplash', 2015),
('Birdman', 2015),
('Interestelar', 2014),
('A Culpa é das estrelas', 2014),
('Alexandre e o Dia Terrível, Horrível, Espantoso e Horroroso', 2014),
('Sing', 2016)

INSERT INTO Estrela VALUES
('Michael Keaton','Michael John Douglas'),
('Emma Stone', 'Emily Jean Stone'),
('Miles Teller', NULL),
('Steve Carell', 'Steven John Carell'),
('Jennifer Garner', 'Jennifer Anne Garner')

INSERT INTO Filme_Estrela VALUES
(1002,9901),
(1002,9902),
(1001,9903),
(1005,9904),
(1005,9905)

INSERT INTO Filme_Estrela VALUES
(1002,9901),
(1002,9902),
(1001,9903),
(1005,9904),
(1005,9905)

INSERT INTO DVD VALUES
('2020-12-02', 1001),
('2019-10-18', 1002),
('2020-04-03', 1003),
('2020-12-02', 1001),
('2019-10-18', 1004),
('2020-04-03', 1002),
('2020-12-02', 1005),
('2019-10-18', 1002),
('2020-04-03', 1003)

INSERT INTO Cliente VALUES
('Matilde Luz', 'Rua Síria',150, '03086040'),
('Carlos Carreiro', 'Rua Bartolomeu Aires', 1250, '04419110'),
('Daniel Ramalho', 'Rua Itajutiba', 169, NULL),
('Roberta Bento', 'Rua Jayme Von Rosenburg', 36, NULL),
('Rosa Cerqueira', 'Rua Arnaldo Simões Pinto', 235, '02917110')

INSERT INTO Locacao VALUES
(10001,5502,'2021-02-18','2021-02-21',3.50),
(10009,5502,'2021-02-18','2021-02-21',3.50),
(10002,5503,'2021-02-18','2021-02-19',3.50),
(10002,5505,'2021-02-20','2021-02-23',3.00),
(10004,5505,'2021-02-20','2021-02-23',3.00),
(10005,5505,'2021-02-20','2021-02-23',3.00),
(10001,5501,'2021-02-24','2021-02-26',3.50),
(10008,5501,'2021-02-24','2021-02-26',3.50)

SELECT * FROM Filme
SELECT * FROM Estrela
SELECT * FROM Filme_Estrela
SELECT * FROM DVD
SELECT * FROM Cliente
SELECT * FROM Locacao

