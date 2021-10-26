CREATE DATABASE aulaselects
GO 
USE aulaselects

CREATE TABLE funcionario(
id			INT				NOT NULL	IDENTITY,
nome		VARCHAR(100)	NOT NULL,
sobrenome	VARCHAR(200)	NOT NULL,
logradouro	VARCHAR(200)	NOT NULL,
numero		INT				NOT NULL	CHECK(numero > 0),
bairro		VARCHAR(100)	NULL,
cep			CHAR(8)			NULL		CHECK(LEN(cep) = 8),
ddd			CHAR(2)			NULL		DEFAULT('11'),
telefone	CHAR(8)			NULL		CHECK (LEN(telefone) = 8),
data_nasc	DATE			NOT NULL	CHECK (data_nasc < GETDATE()),
salario		DECIMAL(7,2)	NOT NULL	CHECK (salario > 0)
PRIMARY KEY (id)
)
GO
CREATE TABLE projeto(
codigo		INT				NOT NULL	IDENTITY(1001, 1),
nome		VARCHAR(200)	NOT NULL	UNIQUE,
descricao	VARCHAR(300)	NULL
PRIMARY KEY(codigo)
)
GO
CREATE TABLE funcproj(
id_funcionario	INT			NOT NULL,
codigo_projeto	INT			NOT NULL,
data_inicio		DATE		NOT NULL,
data_fim		DATE		NOT NULL,
CONSTRAINT chk_dt CHECK(data_fim > data_inicio),
PRIMARY KEY (id_funcionario, codigo_projeto),
FOREIGN KEY (id_funcionario) REFERENCES funcionario(id),
FOREIGN KEY (codigo_projeto) REFERENCES projeto(codigo)
)

EXEC sp_help funcionario
EXEC sp_help projeto
EXEC sp_help funcproj

SELECT * FROM funcionario
SELECT * FROM projeto
SELECT * FROM funcproj

INSERT INTO funcionario (nome, sobrenome, logradouro, numero, bairro, cep, ddd, telefone, data_nasc, salario) VALUES
('Fulano', 'Da Silva', 'R. Voluntários da Pátria', 12, 'Santana', '01234567', '11', '20563014', '1951-10-12', 2500.0),
('Cicrano', 'De Souza', 'Av. Águia de Haia', 125, 'Arthur Alvim', '01235567', '11', '92563014', '1984-11-12', 3650.0),
('Beltrano', 'Dos Santos', 'R. ABC', 1100, 'Barra Funda', '01244567', '11', '25639854', '1963-06-02', 2200.0),
('Tirano',	'De Souza', 'R. Anhaia', 353, 'Barra Funda', '01324567', NULL, NULL, '1975-10-15', 2800.0)

 
INSERT INTO projeto VALUES
('Implantação de Sistemas','Colocar o sistema no ar'),
('Modificação do módulo de cadastro','Modificar CRUD'),
('Teste de Sistema de Cadastro',NULL)
 
 
INSERT INTO funcproj VALUES
(1, 1001, '2015-04-18', '2015-04-30'),
(3, 1001, '2015-04-18', '2015-04-30'),
(1, 1002, '2015-05-06', '2015-05-10'),
(2, 1002, '2015-05-06', '2015-05-10'),
(3, 1003, '2015-05-11', '2015-05-13')

-- Mesmo deletando continua o autoincremente da identity
DELETE funcionario
-- DBCC CHECKIDENT (TABELA, RESEED, VALOR_INICIAL -1) = renicia a contagem do identity
DBCC CHECKIDENT (funcionario, RESEED, 0)

/*
--> RESTIÇÕES - CONSTRAINTS: não inseri no BD senão atende as restrições
PK- identificador - único
FK - verifica as referências de PK nas entidades
UNIQUE - não admite valores repetidos na mesma coluna
IDENTITY(X,Y) - cria um autoincremental naquela coluna p/ identificadores
	X- valor inicial
	Y- incremento
CHECK - faz uma verificação de um teste lógico - se fallha tudo é perdido
	- CHECK em nível de tabela (constraint) tudo com vírgulas na criaçã da tabela
DEFAULT - inseri um valor padrão, caso não haja valor na coluna
*/

--> FUNÇÕES IMPORTANTES

-- Tamanho do dado LEN - qtd de caracteres
SELECT LEN('Quantidade de caracteres')

-- Data e hora atual do sistema
SELECT GETDATE()

-- CAST (Conversão de tipos)
SELECT CAST('12' AS INT) AS char_to_int
SELECT CAST(12 AS VARCHAR(2)) AS int_to_char

-- CONVERT (Conversão de tipos) - apenas SQLSERVER
SELECT CONVERT(VARCHAR(2), 12) AS convert_int_to_char

-- CONVERT para DATE ou DATETIME - passa para VARCHAR
SELECT GETDATE() AS atual
SELECT CONVERT(CHAR(10), GETDATE(), 103) AS hoje -- 103 = formato dd/mm/aaaa (BR)
SELECT CONVERT(CHAR(8), GETDATE(), 108) AS hora -- 108 = apenas o tempo
-- CHAR(5) = dd/mm | pode usar char (quando não concatena) ou varchar
-- 100 = char(11), americano...até 107


/* 
--> CONSULTAS SIMPLES - SELECT:
SELECT colunas
FROM tabela
WHERE condições_filtragem
*/
SELECT id, nome, sobrenome, logradouro, numero, cep, salario
FROM funcionario

SELECT id, nome, sobrenome, ddd, telefone
FROM funcionario

--> LIKE (%) SIGINIFICA "TIPO" --> LIKE '%Last', '%Med%', 'First%'
-- SGBD É LITERAL ENTÃO PODE USAR LIKE QUE É != DE IGUAL
SELECT id, nome, sobrenome, logradouro, numero, cep, salario
FROM funcionario
WHERE nome = 'Fulano' AND sobrenome LIKE '%Silva%'
-- OPERADORES LÓGICOS - OR & AND 

--> CONCATENAÇÃO
-- id e nome quem não tem telefone cadastrado
--> ALIAS (AS) = APELIDO DA COLUNA
--> IS NULL || IS NOT NULL
SELECT id AS id_func, nome + ' ' + sobrenome AS nome_completo
FROM funcionario
WHERE telefone IS NULL

-- id, nome e telefone (sem ddd)
--> ORDER BY col1, col2
--> ASC (CRESCENTE-padrão) || DESC (DECRESCENTE)
SELECT id, nome + ' ' + sobrenome AS nome_completo, telefone
FROM funcionario
WHERE telefone IS NOT NULL
ORDER BY nome ASC, sobrenome ASC

-- Nome Completo, Endereço (numero converte para VARCHAR), ddd e telefone, ordem alfabetica
-- CAST quando há tipos distintos
SELECT id, 
	nome + ' ' + sobrenome AS nome_completo, 
	logradouro + ',' + CAST(numero AS VARCHAR(5)) + '- CEP:' + cep AS endereco_completo,
	ddd, telefone
FROM funcionario
WHERE telefone IS NOT NULL

-- Nome Completo, Endereço e data de nascimento
-- CONVERT PARA DATAS
SELECT id, 
	nome + ' ' + sobrenome AS nome_completo, 
	logradouro + ',' + CAST(numero AS VARCHAR(5)) + '- CEP:' + cep AS endereco_completo,
	CONVERT(CHAR(10), data_nasc, 103) AS nascimento
FROM funcionario

-- Datas distintas (BR) de inicio de trabalhos
-- DISTINCT (Remove linhas inteiras duplicadas) -- não repete
SELECT DISTINCT CONVERT(CHAR(10), data_inicio, 103) AS dt_inicio
FROM funcproj
ORDER BY dt_inicio

-- nome_completo e 15% de aumento para Fulano
SELECT id,
	nome + ' ' + sobrenome AS nome_completo,
	salario, 
	CAST(salario * 1.15 AS DECIMAL(7,2)) AS aumento, -- exibo e não mudo o dado
	salario + salario * 0.15 AS aumento_outra_forma
FROM funcionario
WHERE nome = 'Fulano'

UPDATE funcionario -- altero o dado armazenado
SET salario = salario * 1.15
WHERE nome = 'Fulano'

-- Nome e salario mais de 3000
-- =, !=, <>, <, <=, >, >=
SELECT id,
	nome + ' ' + sobrenome AS nome_completo,
	salario
FROM funcionario
WHERE salario > 2000

-- Nome Completo com salario entre 2000 e 3000
SELECT id,
	nome + ' ' + sobrenome AS nome_completo,
	salario
FROM funcionario
WHERE salario BETWEEN 2000 AND 3000

-- Nome completo, salario menor que 2000 e maior que 3000
-- NOT BETWEEN
SELECT id,
	nome + ' ' + sobrenome AS nome_completo,
	salario
FROM funcionario
WHERE salario NOT BETWEEN 2000 AND 3000