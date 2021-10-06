-- Criar database (domínio) Clinica
CREATE DATABASE clinica
GO
USE clinica

-- Criar as tabelas (entidades)
CREATE TABLE paciente(
numBeneficio				INT						NOT NULL,
nome						VARCHAR(100)			NOT NULL,
logradouro					VARCHAR(200)			NOT NULL,
numero						INT						NOT NULL,
cep							CHAR(8)					NOT NULL,
complemento					VARCHAR(255)			NULL,
telefone					VARCHAR(11)				NOT NULL
PRIMARY KEY (numBeneficio)
)

CREATE TABLE especialidade(
idEspecialidade				INT						NOT NULL,
especialidade				VARCHAR(100)			NOT NULL
PRIMARY KEY(idEspecialidade)
)

CREATE TABLE medico(
codMedico					INT						NOT NULL,
nome						VARCHAR(100)			NOT NULL,
logradouro					VARCHAR(200)			NOT NULL,
numero						INT						NOT NULL,
cep							CHAR(8)					NOT NULL,
complemento					VARCHAR(255)			NULL,
contato						VARCHAR(11)				NOT NULL,
idEspecialidade				INT						NOT NULL
PRIMARY KEY (codMedico)
FOREIGN KEY (idEspecialidade) REFERENCES especialidade(idEspecialidade)
)

CREATE TABLE consulta(
numBeneficio				INT						NOT NULL,
codMedico					INT						NOT NULL,
dataHora					DATETIME				NOT NULL,
observacao					VARCHAR(255)			NOT NULL
PRIMARY KEY (numBeneficio, codMedico, dataHora)
FOREIGN KEY (numBeneficio) REFERENCES paciente(numBeneficio),
FOREIGN KEY (codMedico) REFERENCES medico(codMedico)
)

EXEC sp_help paciente
EXEC sp_help especialidade
EXEC sp_help medico
EXEC sp_help consulta

-- Inserir registros
INSERT INTO paciente VALUES
(99901, 'Washington Silva', 'R. Anhaia', 150, '02345000', 'Casa', '922229999' ),
(99902, 'Luis Ricardo', 'R. Voluntários da Pátria', 2251, '03254010', 'Bloco B. Apto 25', '923450987'),
(99903, 'Maria Elisa', 'Av. Aguia de Haia', 1188, '06987020', 'Apto 1208', '912348765'),
(99904, 'José Araujo', 'R. XV Novembro', 18, '03678000', 'Casa', '945674312'),
(99905, 'Joana Paula', 'R. 7 de Abril', 97, '01214000', 'Conjunto 3 - Apto 801', '912095674')

INSERT INTO medico VALUES
(100001, 'Ana Paula', 'R. 7 de Setembro', 256, '03698000', 'Casa', '915689456',1),
(100002, 'Ana Aparecida', 'Av. Brasil', 32, '02145070', 'Casa', '923235454',1),
(100003, 'Lucas Borges', 'Av. do Estado', 3210, '05241000', 'Apto 205', '963698585',2),
(100004, 'Gabriel Oliveira', 'Av. Dom Helder Camara', 350, '03145000', 'Apto 602', '932458745',3)

INSERT INTO especialidade VALUES
(1, 'Otorrinolaringologista'),
(2, 'Urologista'),
(3, 'Geriatra'),
(4, 'Pediatra')

INSERT INTO consulta VALUES
(99901, 100003, '2021-09-04 13:20', 'Infecção Urina'),
(99902, 100004, '2021-09-04 13:15', 'Gripe'),
(99901, 100001, '2021-09-04 12:30', 'Infecção Garganta')

SELECT * FROM paciente
SELECT * FROM especialidade
SELECT * FROM medico
SELECT * FROM consulta

/*
Adicionar a coluna dia_atendimento para médico
100001 – Passa a atender na 2ª feira
100002 – Passa a atender na 4ª feira
100003 – Passa a atender na 2ª feira
100004 – Passa a atender na 5ª feira
*/

ALTER TABLE medico
ADD dia_atendimento varchar(10) NULL

UPDATE medico
SET dia_atendimento = '2ª feira'
WHERE codMedico = 100001

UPDATE medico
SET dia_atendimento = '4ª feira'
WHERE codMedico = 100002

UPDATE medico
SET dia_atendimento = '2ª feira'
WHERE codMedico = 100003

UPDATE medico
SET dia_atendimento = '5ª feira'
WHERE codMedico = 100004

-- A especialidade Pediatra não está disponível
DELETE especialidade
WHERE idEspecialidade = 4

-- Renomear a coluna dia_atendimento para dia_semana_atendimento
EXEC sp_rename 'dbo.medico.dia_atendimento', 'dia_semana_atendimento', 'COLUMN'

/* Atualizar os dados do médico Lucas Borges 
que passou a residir à Av. Bras Leme, no. 876, apto 504, CEP 02122000
*/
UPDATE medico
SET logradouro = 'Av. Bras Leme', numero = 876, complemento = 'apto 504', cep = '02122000'
WHERE nome = 'Lucas Borges' -- ou codMedico = 100003

-- Mudar o tipo de dado da observação da consulta para VARCHAR(200)
ALTER TABLE consulta
ALTER COLUMN observacao VARCHAR(200) NOT NULL