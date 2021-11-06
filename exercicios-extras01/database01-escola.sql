CREATE DATABASE escola
GO
USE escola

CREATE TABLE Aluno(
ra			INT				NOT NULL,
nome		VARCHAR(50)		NOT NULL,
sobrenome	VARCHAR(50)		NOT NULL,
logradouro	VARCHAR(100)	NOT NULL,
numero		INT				NOT NULL,
bairro		VARCHAR(50)		NOT NULL,
cep			CHAR(8)			NOT NULL,
telefone	VARCHAR(9)		NULL
PRIMARY KEY (ra)
)
GO
CREATE TABLE Curso(
codigo		INT				NOT NULL	IDENTITY,
nome		VARCHAR(50)		NOT NULL,
carga		INT				NOT NULL,
turno		CHAR(5)			NOT NULL
PRIMARY KEY (codigo)
)
GO
CREATE TABLE Disciplina(
codigo		INT				NOT NULL	IDENTITY,
nome		VARCHAR(50)		NOT NULL,
carga		INT				NOT NULL,
turno		CHAR(5)			NOT NULL,
semestre	INT				NOT NULL
PRIMARY KEY (codigo)
)

INSERT INTO Aluno VALUES
(12345,'José','Silva','Almirante Noronha',236,'Jardim São Paulo','1589000','69875287'),
(12346,'Ana','Maria Bastos','Anhaia',1568,'Barra Funda','3569000','25698526'),
(12347,'Mario','Santos','XV de Novembro',1841,'Centro','1020030', NULL),
(12348,'Marcia','Neves','Voluntários da Patria',225,'Santana','2785090','78964152')

INSERT INTO Curso VALUES
('Informática',2800,'Tarde'),
('Informática',2800,'Noite'),
('Logística',2650,'Tarde'),
('Logística',2650,'Noite'),
('Plásticos',2500,'Tarde'),
('Plásticos',2500,'Noite')

INSERT INTO Disciplina VALUES
('Informática',4,'Tarde',1),
('Informática',4,'Noite',1),
('Quimica',4,'Tarde',1),
('Quimica',4,'Noite',1),
('Banco de Dados I',2,'Tarde',3),
('Banco de Dados I',2,'Noite',3),
('Estrutura de Dados',4,'Tarde',4),
('Estrutura de Dados',4,'Noite',4)

SELECT * FROM Aluno
SELECT * FROM Curso
SELECT * FROM Disciplina

-- Nome e sobrenome, como nome completo dos Alunos Matriculados
SELECT nome +' '+ sobrenome AS nome_completo
FROM Aluno

-- Rua, nº , Bairro e CEP como Endereço do aluno que não tem telefone
SELECT logradouro +', '+ CAST(numero AS VARCHAR(5)) + ', ' + bairro + ' - ' + cep AS endereco
FROM Aluno
WHERE telefone IS NULL

-- Telefone do aluno com RA 12348
SELECT telefone
FROM Aluno
WHERE ra = 12348

-- Nome e Turno dos cursos com 2800 horas
SELECT nome, turno
FROM Curso
WHERE carga = 2800

-- O semestre do curso de Banco de Dados I noite
SELECT semestre
FROM Disciplina
WHERE nome ='Banco de Dados I' AND turno = 'Noite'