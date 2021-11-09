CREATE DATABASE projetos
GO
use projetos

CREATE TABLE Projeto(
id				INT			NOT NULL	IDENTITY(10001,1),
nome			VARCHAR(45)	NOT NULL,
descricao		VARCHAR(45)	NULL,
data_projeto	DATE		NOT NULL	CHECK(data_projeto > '2014-09-01')
PRIMARY KEY (id)
)
GO
CREATE TABLE Usuario(
id				INT			NOT NULL	IDENTITY(1,1),
nome			VARCHAR(45)	NOT NULL,
username		VARCHAR(45)	NOT NULL	UNIQUE,
senha			VARCHAR(45)	NOT NULL	DEFAULT('123mudar'),
email			VARCHAR(45)	NOT NULL
PRIMARY KEY (id)
)
GO
CREATE TABLE Usuario_Projeto(
id_usuario		INT			NOT NULL,
id_projeto		INT			NOT NULL
PRIMARY KEY (id_usuario, id_projeto)
FOREIGN KEY (id_usuario) REFERENCES Usuario(id),
FOREIGN KEY (id_projeto) REFERENCES Projeto(id)
)

-- ALTERAR COLUNA UNIQUE --
ALTER TABLE Usuario
DROP CONSTRAINT UQ__Usuario__F3DBC57280F4850C -- TABELA > CHAVES > UQ...
GO
ALTER TABLE Usuario
ALTER COLUMN username VARCHAR(10)
GO
ALTER TABLE Usuario
ADD UNIQUE(username)

-- ALTERAR COLUNA
ALTER TABLE Usuario
ALTER COLUMN senha VARCHAR(8) NOT NULL 

INSERT INTO Usuario VALUES
('Maria','Rh_maria','123mudar','maria@empresa.com'),
('Paulo','Ti_paulo','123@456','paulo@empresa.com'),
('Ana','Rh_ana','123mudar','ana@empresa.com'),
('Clara','Ti_clara','123mudar','clara@empresa.com'),
('Aparecido','Rh_apareci','55@!cido', 'aparecido@empresa.com')

INSERT INTO Projeto VALUES
('Re-folha','Refatoração das Folhas','2014-09-05'),
('Manutenção PC´s','Manutenção PC´s','2014-09-06'),
('Auditoria',NULL,'2014-09-07')

INSERT INTO Usuario_Projeto VALUES
(1,10001),
(5,10001),
(3,10003),
(4,10002),
(2,10002)

SELECT * FROM Usuario
SELECT id, nome, descricao, CONVERT(CHAR(10),data_projeto,103) FROM Projeto
SELECT * FROM Usuario_Projeto

UPDATE Projeto
SET data_projeto = '2014-09-12'
WHERE nome LIKE 'Manutenção%'

UPDATE Usuario
SET username = 'Rh_cido'
WHERE nome LIKE 'Aparecido%'

UPDATE Usuario
SET senha = '888@*'
WHERE senha = '123mudar' AND username = 'Rh_maria'

DELETE Usuario_Projeto
WHERE id_projeto = 10002 AND id_usuario = 2

-- - Fazer uma consulta que retorne id, nome, email, username e caso a senha seja diferente de 123mudar, 
-- mostrar ******** (8 asteriscos), caso contrário, mostrar a própria senha.
SELECT id, nome, email, username, 
	 CASE
		WHEN senha != '123mudar' THEN
			'********'  
	 ELSE
		senha
	 END AS senha
FROM Usuario

-- Considerando que o projeto 10001 durou 15 dias, 
-- fazer uma consulta que mostre o nome do projeto, descrição, data, data_final do projeto 
-- realizado por usuário de e-mail aparecido@empresa.com
SELECT nome, descricao, data_projeto, DATEADD(DAY, 15, data_projeto) AS  data_final
FROM Projeto
WHERE id IN
(
	SELECT id_projeto
	FROM Usuario_Projeto
	WHERE id_usuario IN
	(
		SELECT id
		FROM Usuario
		WHERE email = 'aparecido@empresa.com'
	)
)

-- Fazer uma consulta que retorne o nome e o email dos usuários que estão 
-- envolvidos no projeto de nome Auditoria
SELECT nome, email
FROM Usuario
WHERE id IN
(
	SELECT id_usuario
	FROM Usuario_Projeto
	WHERE id_projeto IN
	(
		SELECT id
		FROM Projeto
		WHERE nome = 'Auditoria'
	)
)

-- Considerando que o custo diário do projeto, cujo nome tem o termo Manutenção, 
-- é de 79.85 e ele deve finalizar 16/09/2014, consultar, nome, descrição, data, data_final 
-- e custo_total do projeto
SELECT nome, descricao, data_projeto, DATEDIFF(DAY, data_projeto, '2014-09-16') AS data_final,
	   DATEDIFF(DAY, data_projeto, '2014-09-16') * 79.85 AS custo_total
FROM Projeto
WHERE nome LIKE 'Manutenção%'