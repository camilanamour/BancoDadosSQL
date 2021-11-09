create database aulajoin
GO
use aulajoin

create table materias(
id int identity not null,
nome varchar(100),
carga_horaria int
primary key (id))
GO
insert into materias values
('Arquitetura e Organização de Computadores', 80),
('Banco de Dados', 80),
('Laboratorio de Hardware', 40),
('Sistemas Operacionais I', 80)

create table avaliacoes(
id int identity(100001,1),
tipo varchar(10),
peso decimal(7,2)
primary key (id))
GO
insert into avaliacoes values
('P1',0.3),
('P2',0.5),
('T',0.2)

create table alunos(
ra char(10) not null,
nome varchar(100)
primary key (ra))

create table alunomateria(
ra_aluno char(10) not null,
id_materia int not null
primary key (ra_aluno, id_materia)
foreign key (ra_aluno) references alunos (ra),
foreign key (id_materia) references materias (id))

create table notas(
ra_aluno char(10) not null,
id_materia int not null,
id_avaliacao int not null,
nota decimal(7,2)
primary key (ra_aluno, id_materia, id_avaliacao)
foreign key (ra_aluno) references alunos (ra),
foreign key (id_materia) references materias (id),
foreign key (id_avaliacao) references avaliacoes(id))


SELECT * FROM alunos
SELECT * FROM materias
SELECT * FROM alunomateria
SELECT * FROM avaliacoes
SELECT * FROM notas


--JOINS
SELECT col1, col2, col3
FROM tabela
WHERE condição


--INNER JOIN
--SQL2
SELECT tab1.col1, tab2.col2, tab1.col2
FROM tab1 INNER JOIN tab2
ON tab1.pk = tab2.fk
INNER JOIN tab3
ON tab3.pk = tab2.fk
INNER JOIN tab4
ON tab4.fk = tab1.pk
WHERE tab1.col3 = valor AND tab2.col4 = outro_valor

--SQL3
SELECT tab1.col1, tab2.col2, tab1.col2
FROM tab1, tab2, tab3, tab4
WHERE tab1.pk = tab2.fk
	AND tab3.pk = tab2.fk
	AND tab4.fk = tab1.pk
	AND tab1.col3 = valor
	AND tab2.col4 = outro_valor

--OUTER JOIN
SELECT tab1.col1, tab1.col2

FROM tab1 LEFT OUTER JOIN tab2 --Dados que estão na tab1 e não existem na tab2
OU
FROM tab1 RIGHT OUTER JOIN tab2 --Dados que estão na tab2 e não existem na tab1

ON tab1.pk = tab2.fk

WHERE tab2.fk IS NULL --MUITA ATENÇÃO NESSA CLÁUSULA
	  OU tab1.pk IS NULL

	AND tab1.col3 = valor

-- INNER JOIN --> Criar listas de chamadas (RA tem um (-) antes do último digito), ordenados pelo nome, caso o nome tenha mais de 30 caract. mostrar 29 e um ponto(.) no final

--SQL 2
SELECT SUBSTRING(alunos.ra,1,9)+'-'+ SUBSTRING(alunos.ra,10,1) AS alunos_ra,
	CASE WHEN (LEN(alunos.nome) > 30) THEN
		SUBSTRING(alunos.nome,1,29)+'.'
	ELSE
		alunos.nome
	END AS alunos_nome
FROM alunos INNER JOIN alunomateria
ON alunos.ra = alunomateria.ra_aluno
INNER JOIN materias
ON materias.id = alunomateria.id_materia
WHERE materias.nome = 'Banco de Dados'
ORDER BY alunos.nome ASC


--ALIAS
SELECT SUBSTRING(al.ra,1,9)+'-'+ SUBSTRING(al.ra,10,1) AS alunos_ra,
	CASE WHEN (LEN(al.nome) > 30) THEN
		SUBSTRING(al.nome,1,29)+'.'
	ELSE
		al.nome
	END AS alunos_nome
FROM alunos al INNER JOIN alunomateria am
ON al.ra = am.ra_aluno
INNER JOIN materias mat
ON mat.id = am.id_materia
WHERE mat.nome = 'Banco de Dados'
ORDER BY al.nome ASC


--SQL 3
SELECT SUBSTRING(al.ra,1,9)+'-'+ SUBSTRING(al.ra,10,1) AS alunos_ra,
	CASE WHEN (LEN(al.nome) > 30) THEN
		SUBSTRING(al.nome,1,29)+'.'
	ELSE
		al.nome
	END AS alunos_nome
FROM alunos al, alunomateria am, materias mat
WHERE al.ra = am.ra_aluno
	  AND mat.id = am.id_materia
	  AND mat.nome = 'Banco de Dados'
ORDER BY al.nome ASC


-- OUTER JOIN --> Matérias que não tem notas cadastradas
SELECT mat.nome
FROM materias mat LEFT OUTER JOIN notas nt
ON mat.id = nt.id_materia
WHERE nt.id_materia IS NULL

SELECT mat.nome
FROM notas nt RIGHT OUTER JOIN materias mat
ON mat.id = nt.id_materia
WHERE nt.id_materia IS NULL

-- OUTROS EXEMPLOS

-- Fazer uma consulta que retorne o RA mascarado e o nome dos alunos que não estão matriculados em nenhuma matéria
SELECT SUBSTRING(al.ra,1,9)+'-'+ SUBSTRING(al.ra,10,1) AS alunos_ra, al.nome
FROM alunos al LEFT OUTER JOIN alunomateria am
ON al.ra = am.ra_aluno
WHERE am.ra_aluno IS NULL
ORDER BY al.nome

SELECT SUBSTRING(al.ra,1,9)+'-'+ SUBSTRING(al.ra,10,1) AS alunos_ra, al.nome
FROM alunomateria am RIGHT OUTER JOIN alunos al
ON al.ra = am.ra_aluno
WHERE am.ra_aluno IS NULL
ORDER BY al.nome


--Fazer uma consulta que retorne o RA mascarado, o nome dos alunos, o nome da matéria, a nota, o tipo da avaliação, dos alunos que tiraram
--Notas abaixo da média(6.0) em P1 ou P2, ordenados por matéria e nome do aluno

--SQL 2
SELECT SUBSTRING(al.ra,1,9)+'-'+ SUBSTRING(al.ra,10,1) AS alunos_ra,
	al.nome, mat.nome AS mat_nome, av.tipo, nt.nota
FROM alunos al INNER JOIN notas nt
ON al.ra = nt.ra_aluno
INNER JOIN materias mat
ON mat.id = nt.id_materia
INNER JOIN avaliacoes av
ON av.id = nt.id_avaliacao
WHERE nt.nota < 6.0
	AND av.tipo != 'T' --AND (av.tipo = 'P1' OR av.tipo = 'P2')
ORDER BY mat.nome ASC, al.nome ASC

--SQL 3
SELECT SUBSTRING(al.ra,1,9)+'-'+ SUBSTRING(al.ra,10,1) AS alunos_ra,
	al.nome, mat.nome AS mat_nome, av.tipo, nt.nota
FROM alunos al, notas nt, materias mat, avaliacoes av
WHERE al.ra = nt.ra_aluno
	  AND mat.id = nt.id_materia
	  AND av.id = nt.id_avaliacao
	  AND nt.nota < 6.0
	  AND av.tipo != 'T'
ORDER BY mat.nome ASC, al.nome ASC
