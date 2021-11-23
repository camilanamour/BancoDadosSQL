SELECT * FROM alunos
SELECT * FROM materias
SELECT * FROM avaliacoes
SELECT * FROM notas ORDER by id_materia, id_avaliacao
SELECT * FROM alunomateria
 
/*Fun��es de Agrega��o
SUM(), AVG(), COUNT(), MAX(), MIN() 
 
GROUP BY - Cl�usula de Agrega��o
HAVING - Filtro para Fun��es de Agrega��o
*/
 
 
--Consultar a m�dia das notas de cada avalia��o por mat�ria
--Select M�dia aritm�tica a partir da soma com filtro de Avalia��o e Mat�ria
--Consultar M�dia Aritm�tica das P2 de Banco de Dados
SELECT CAST(SUM(nt.nota) / 40 AS DECIMAL(4,1)) AS media_p2_bd
FROM avaliacoes av INNER JOIN notas nt
ON av.id = nt.id_avaliacao
INNER JOIN materias mat
ON mat.id = nt.id_materia
WHERE av.tipo = 'P2'
	AND mat.nome = 'Banco de Dados'
 
SELECT CAST(SUM(nt.nota) / 40 AS DECIMAL(4,1)) AS media_p2_bd
FROM avaliacoes av, notas nt, materias mat
WHERE av.id = nt.id_avaliacao
	AND mat.id = nt.id_materia
	AND av.tipo = 'P2'
	AND mat.nome = 'Banco de Dados'
 
--Select M�dia aritm�tica com filtro de Avalia��o e Mat�ria
--Consultar M�dia Aritm�tica das P2 de Banco de Dados
SELECT CAST(AVG(nt.nota) AS DECIMAL(4,1)) AS media_p2_bd
FROM avaliacoes av, notas nt, materias mat
WHERE av.id = nt.id_avaliacao
	AND mat.id = nt.id_materia
	AND av.tipo = 'P2'
	AND mat.nome = 'Banco de Dados'
 
SELECT CAST(AVG(nt.nota) AS DECIMAL(4,1)) AS media_p2_bd
FROM avaliacoes av INNER JOIN notas nt
ON av.id = nt.id_avaliacao
INNER JOIN materias mat
ON mat.id = nt.id_materia
WHERE av.tipo = 'P2'
	AND mat.nome = 'Banco de Dados'
 
--Agrupando por mat�ria e tipo de avalia��o
SELECT mat.nome, av.tipo,
		CAST(AVG(nt.nota) AS DECIMAL(4,1)) AS media
FROM materias mat, avaliacoes av, notas nt
WHERE mat.id = nt.id_materia
	AND av.id = nt.id_avaliacao
GROUP BY mat.nome, av.tipo
ORDER BY mat.nome, av.tipo
 
SELECT mat.nome, av.tipo,
		CAST(AVG(nt.nota) AS DECIMAL(4,1)) AS media
FROM materias mat INNER JOIN notas nt 
ON mat.id = nt.id_materia
INNER JOIN avaliacoes av
ON av.id = nt.id_avaliacao
GROUP BY mat.nome, av.tipo
ORDER BY mat.nome, av.tipo
 
--Consultar o RA do aluno (mascarado), a nota final dos alunos, 
--de alguma mat�ria e uma coluna conceito 
--(aprovado caso nota >= 6, reprovado, caso contr�rio)
SELECT SUBSTRING(al.ra,1,9)+'-'+SUBSTRING(al.ra,10,1) AS ra, 
		al.nome,
		CAST(SUM(nt.nota * av.peso) AS DECIMAL(7,1)) AS nota_final,
		CASE WHEN (SUM(nt.nota * av.peso) > 6.0)
			THEN
				'Aprovado'
			ELSE
				'Reprovado'
		END AS conceito
FROM alunos al INNER JOIN notas nt
ON al.ra = nt.ra_aluno
INNER JOIN avaliacoes av
ON av.id = nt.id_avaliacao
INNER JOIN materias mat
ON mat.id = nt.id_materia
WHERE mat.nome = 'Banco de Dados'
GROUP BY al.ra, al.nome
ORDER BY al.nome
 
SELECT SUBSTRING(al.ra,1,9)+'-'+SUBSTRING(al.ra,10,1) AS ra, 
		al.nome,
		CAST(SUM(nt.nota * av.peso) AS DECIMAL(7,1)) AS nota_final,
		CASE WHEN (SUM(nt.nota * av.peso) > 6.0)
			THEN
				'Aprovado'
			ELSE
				'Reprovado'
		END AS conceito
FROM alunos al, notas nt, avaliacoes av, materias mat
WHERE al.ra = nt.ra_aluno
	AND av.id = nt.id_avaliacao
	AND mat.id = nt.id_materia
	AND mat.nome = 'Banco de Dados'
GROUP BY al.ra, al.nome
ORDER BY al.nome
 
 
--Consultar nome da mat�ria e quantos alunos est�o matriculados
SELECT mat.nome, COUNT(al.nome) AS qtd_matriculados
FROM alunos al, alunomateria am, materias mat
WHERE al.ra = am.ra_aluno
	AND mat.id = am.id_materia
GROUP BY mat.nome
ORDER BY mat.nome
 
UPDATE alunomateria
SET id_materia = 10
WHERE ra_aluno IN
(
	SELECT TOP 40 al.ra
	FROM alunos al INNER JOIN alunomateria am
	ON al.ra = am.ra_aluno
	WHERE am.id_materia = 2
)
 
--Consultar quantos alunos n�o est�o matriculados
SELECT COUNT(al.ra) AS nao_matriculados
FROM alunos al LEFT OUTER JOIN alunomateria am
ON al.ra = am.ra_aluno
WHERE am.ra_aluno IS NULL
 
SELECT COUNT(al.ra) AS nao_matriculados
FROM alunomateria am RIGHT OUTER JOIN alunos al 
ON al.ra = am.ra_aluno
WHERE am.ra_aluno IS NULL
 
--Consultar quais alunos est�o aprovados em alguma mat�ria 
--(nota final >= 6,0)
SELECT SUBSTRING(al.ra,1,9)+'-'+SUBSTRING(al.ra,10,1) AS ra, 
		al.nome
FROM alunos al, notas nt, avaliacoes av, materias mat
WHERE al.ra = nt.ra_aluno
	AND av.id = nt.id_avaliacao
	AND mat.id = nt.id_materia
	AND mat.nome = 'Banco de Dados'
GROUP BY al.ra, al.nome
HAVING SUM(av.peso * nt.nota) > 6
 
SELECT SUBSTRING(al.ra,1,9)+'-'+SUBSTRING(al.ra,10,1) AS ra, 
		al.nome
FROM alunos al INNER JOIN notas nt
ON al.ra = nt.ra_aluno
INNER JOIN avaliacoes av
ON av.id = nt.id_avaliacao
INNER JOIN materias mat
ON mat.id = nt.id_materia
WHERE mat.nome = 'Banco de Dados'
GROUP BY al.ra, al.nome
HAVING SUM(av.peso * nt.nota) > 6
 
--Consultar quantos alunos est�o aprovados em alguma mat�ria
--(nota final >= 6,0)
SELECT COUNT(ra) AS aprovados
FROM alunos
WHERE ra IN
(
	SELECT al.ra
	FROM alunos al, notas nt, avaliacoes av, materias mat
	WHERE al.ra = nt.ra_aluno
		AND av.id = nt.id_avaliacao
		AND mat.id = nt.id_materia
		AND mat.nome = 'Banco de Dados'
	GROUP BY al.ra
	HAVING SUM(av.peso * nt.nota) > 6
)
 
SELECT COUNT(ra) AS aprovados
FROM alunos
WHERE ra IN
(
	SELECT al.ra
	FROM alunos al INNER JOIN notas nt
	ON al.ra = nt.ra_aluno
	INNER JOIN avaliacoes av
	ON av.id = nt.id_avaliacao
	INNER JOIN materias mat
	ON mat.id = nt.id_materia
	WHERE mat.nome = 'Banco de Dados'
	GROUP BY al.ra
	HAVING SUM(av.peso * nt.nota) > 6
)
--Consultar quantos alunos est�o reprovados em alguma mat�ria
--(nota final < 6,0)
--M�todo 1
SELECT COUNT(ra) AS reprovados
FROM alunos
WHERE ra IN
(
	SELECT al.ra
	FROM alunos al, notas nt, avaliacoes av, materias mat
	WHERE al.ra = nt.ra_aluno
		AND av.id = nt.id_avaliacao
		AND mat.id = nt.id_materia
		AND mat.nome = 'Banco de Dados'
	GROUP BY al.ra
	HAVING SUM(av.peso * nt.nota) < 6
)
 
SELECT COUNT(ra) AS reprovados
FROM alunos
WHERE ra IN
(
	SELECT al.ra
	FROM alunos al INNER JOIN notas nt
	ON al.ra = nt.ra_aluno
	INNER JOIN avaliacoes av
	ON av.id = nt.id_avaliacao
	INNER JOIN materias mat
	ON mat.id = nt.id_materia
	WHERE mat.nome = 'Banco de Dados'
	GROUP BY al.ra
	HAVING SUM(av.peso * nt.nota) < 6
)
--M�todo 2
SELECT COUNT(al.ra) AS reprovados
FROM alunos al, alunomateria am, materias mat
WHERE al.ra = am.ra_aluno
	AND mat.id = am.id_materia
	AND mat.nome = 'Banco de Dados'
	AND al.ra NOT IN
(
	SELECT al.ra
	FROM alunos al, notas nt, avaliacoes av, materias mat
	WHERE al.ra = nt.ra_aluno
		AND av.id = nt.id_avaliacao
		AND mat.id = nt.id_materia
		AND mat.nome = 'Banco de Dados'
	GROUP BY al.ra
	HAVING SUM(av.peso * nt.nota) > 6
)
 
SELECT COUNT(al.ra) AS reprovados
FROM alunos al INNER JOIN alunomateria am
ON al.ra = am.ra_aluno
INNER JOIN materias mat
ON mat.id = am.id_materia
WHERE mat.nome = 'Banco de Dados'
	AND al.ra NOT IN
(
	SELECT al.ra
	FROM alunos al INNER JOIN notas nt
	ON al.ra = nt.ra_aluno
	INNER JOIN avaliacoes av
	ON av.id = nt.id_avaliacao
	INNER JOIN materias mat
	ON mat.id = nt.id_materia
	WHERE mat.nome = 'Banco de Dados'
	GROUP BY al.ra
	HAVING SUM(av.peso * nt.nota) > 6
)
 
--Consultar a maior e menor notas das avalia��es das mat�rias
SELECT mat.nome, av.tipo, 
	MAX(nt.nota) AS maior_nota, MIN(nt.nota) AS menor_nota
FROM materias mat INNER JOIN notas nt
ON mat.id = nt.id_materia
INNER JOIN avaliacoes av
ON av.id = nt.id_avaliacao
GROUP BY mat.nome, av.tipo
ORDER BY mat.nome, av.tipo 
 
SELECT mat.nome, av.tipo, 
	MAX(nt.nota) AS maior_nota, MIN(nt.nota) AS menor_nota
FROM materias mat, notas nt, avaliacoes av
WHERE mat.id = nt.id_materia
	AND av.id = nt.id_avaliacao
GROUP BY mat.nome, av.tipo
ORDER BY mat.nome, av.tipo 
 
--Consultar a menor notas das avalia��es das mat�rias
--que n�o sejam zero
 
SELECT mat.nome, av.tipo, MIN(nt.nota) AS menor_nota
FROM materias mat, notas nt, avaliacoes av
WHERE mat.id = nt.id_materia
	AND av.id = nt.id_avaliacao
	AND nt.nota IN
	(
		SELECT nota
		FROM notas
		WHERE nota > 0.00
	)
GROUP BY mat.nome, av.tipo
ORDER BY mat.nome, av.tipo 
 
SELECT mat.nome, av.tipo, MIN(nt.nota) AS menor_nota
FROM materias mat INNER JOIN notas nt
ON mat.id = nt.id_materia
INNER JOIN avaliacoes av
ON av.id = nt.id_avaliacao
WHERE nt.nota IN
(
	SELECT nota
	FROM notas
	WHERE nota > 0.00
)
GROUP BY mat.nome, av.tipo
ORDER BY mat.nome, av.tipo 
 
--Retornar nome da mat�ria, tipo da avalia��o e as 2 maiores notas
--Banco de Dados
SELECT TOP 2 mat.nome, av.tipo, nt.nota
FROM materias mat INNER JOIN notas nt
ON mat.id = nt.id_materia
INNER JOIN avaliacoes av
ON av.id = nt.id_avaliacao
INNER JOIN alunos al
ON al.ra = nt.ra_aluno
WHERE mat.nome = 'Banco de Dados'
	AND av.tipo = 'P2'
ORDER BY nt.nota DESC
 
SELECT TOP 2 mat.nome, av.tipo, nt.nota
FROM materias mat, notas nt, avaliacoes av, alunos al
WHERE mat.id = nt.id_materia
	AND av.id = nt.id_avaliacao
	AND al.ra = nt.ra_aluno
	AND mat.nome = 'Banco de Dados'
	AND av.tipo = 'P2'
ORDER BY nt.nota DESC
 
--Fazer uma consulta que retorne o RA formatado e o nome dos 
--alunos que tem a menor nota da P1 de banco de dados
SELECT SUBSTRING(al.ra,1,9)+'-'+SUBSTRING(al.ra,10,1) AS ra, 
		al.nome, nt.nota
FROM materias mat, notas nt, avaliacoes av, alunos al
WHERE mat.id = nt.id_materia
	AND av.id = nt.id_avaliacao
	AND al.ra = nt.ra_aluno
	AND mat.nome = 'Banco de Dados'
	AND nt.nota IN
	(
		SELECT MIN(nt.nota)
		FROM materias mat, notas nt, avaliacoes av, alunos al
		WHERE mat.id = nt.id_materia
			AND av.id = nt.id_avaliacao
			AND al.ra = nt.ra_aluno
			AND mat.nome = 'Banco de Dados'
			AND av.tipo = 'P1'
	)
 
SELECT SUBSTRING(al.ra,1,9)+'-'+SUBSTRING(al.ra,10,1) AS ra, 
		al.nome, nt.nota
FROM materias mat INNER JOIN notas nt
ON mat.id = nt.id_materia
INNER JOIN avaliacoes av
ON av.id = nt.id_avaliacao
INNER JOIN alunos al
ON al.ra = nt.ra_aluno
WHERE mat.nome = 'Banco de Dados'
	AND nt.nota IN
	(
		SELECT MIN(nt.nota)
		FROM materias mat INNER JOIN notas nt
		ON mat.id = nt.id_materia
		INNER JOIN avaliacoes av
		ON av.id = nt.id_avaliacao
		INNER JOIN alunos al
		ON al.ra = nt.ra_aluno
		WHERE mat.nome = 'Banco de Dados'
			AND av.tipo = 'P1'
	)
 
RAW Paste Data
USE aulajoin10

SELECT * FROM alunos
SELECT * FROM materias
SELECT * FROM avaliacoes
SELECT * FROM notas ORDER by id_materia, id_avaliacao
SELECT * FROM alunomateria

/*Fun��es de Agrega��o
SUM(), AVG(), COUNT(), MAX(), MIN() 

GROUP BY - Cl�usula de Agrega��o
HAVING - Filtro para Fun��es de Agrega��o
*/


--Consultar a m�dia das notas de cada avalia��o por mat�ria
--Select M�dia aritm�tica a partir da soma com filtro de Avalia��o e Mat�ria
--Consultar M�dia Aritm�tica das P2 de Banco de Dados
SELECT CAST(SUM(nt.nota) / 40 AS DECIMAL(4,1)) AS media_p2_bd
FROM avaliacoes av INNER JOIN notas nt
ON av.id = nt.id_avaliacao
INNER JOIN materias mat
ON mat.id = nt.id_materia
WHERE av.tipo = 'P2'
	AND mat.nome = 'Banco de Dados'

SELECT CAST(SUM(nt.nota) / 40 AS DECIMAL(4,1)) AS media_p2_bd
FROM avaliacoes av, notas nt, materias mat
WHERE av.id = nt.id_avaliacao
	AND mat.id = nt.id_materia
	AND av.tipo = 'P2'
	AND mat.nome = 'Banco de Dados'

--Select M�dia aritm�tica com filtro de Avalia��o e Mat�ria
--Consultar M�dia Aritm�tica das P2 de Banco de Dados
SELECT CAST(AVG(nt.nota) AS DECIMAL(4,1)) AS media_p2_bd
FROM avaliacoes av, notas nt, materias mat
WHERE av.id = nt.id_avaliacao
	AND mat.id = nt.id_materia
	AND av.tipo = 'P2'
	AND mat.nome = 'Banco de Dados'

SELECT CAST(AVG(nt.nota) AS DECIMAL(4,1)) AS media_p2_bd
FROM avaliacoes av INNER JOIN notas nt
ON av.id = nt.id_avaliacao
INNER JOIN materias mat
ON mat.id = nt.id_materia
WHERE av.tipo = 'P2'
	AND mat.nome = 'Banco de Dados'

--Agrupando por mat�ria e tipo de avalia��o
SELECT mat.nome, av.tipo,
		CAST(AVG(nt.nota) AS DECIMAL(4,1)) AS media
FROM materias mat, avaliacoes av, notas nt
WHERE mat.id = nt.id_materia
	AND av.id = nt.id_avaliacao
GROUP BY mat.nome, av.tipo
ORDER BY mat.nome, av.tipo

SELECT mat.nome, av.tipo,
		CAST(AVG(nt.nota) AS DECIMAL(4,1)) AS media
FROM materias mat INNER JOIN notas nt 
ON mat.id = nt.id_materia
INNER JOIN avaliacoes av
ON av.id = nt.id_avaliacao
GROUP BY mat.nome, av.tipo
ORDER BY mat.nome, av.tipo

--Consultar o RA do aluno (mascarado), a nota final dos alunos, 
--de alguma mat�ria e uma coluna conceito 
--(aprovado caso nota >= 6, reprovado, caso contr�rio)
SELECT SUBSTRING(al.ra,1,9)+'-'+SUBSTRING(al.ra,10,1) AS ra, 
		al.nome,
		CAST(SUM(nt.nota * av.peso) AS DECIMAL(7,1)) AS nota_final,
		CASE WHEN (SUM(nt.nota * av.peso) > 6.0)
			THEN
				'Aprovado'
			ELSE
				'Reprovado'
		END AS conceito
FROM alunos al INNER JOIN notas nt
ON al.ra = nt.ra_aluno
INNER JOIN avaliacoes av
ON av.id = nt.id_avaliacao
INNER JOIN materias mat
ON mat.id = nt.id_materia
WHERE mat.nome = 'Banco de Dados'
GROUP BY al.ra, al.nome
ORDER BY al.nome

SELECT SUBSTRING(al.ra,1,9)+'-'+SUBSTRING(al.ra,10,1) AS ra, 
		al.nome,
		CAST(SUM(nt.nota * av.peso) AS DECIMAL(7,1)) AS nota_final,
		CASE WHEN (SUM(nt.nota * av.peso) > 6.0)
			THEN
				'Aprovado'
			ELSE
				'Reprovado'
		END AS conceito
FROM alunos al, notas nt, avaliacoes av, materias mat
WHERE al.ra = nt.ra_aluno
	AND av.id = nt.id_avaliacao
	AND mat.id = nt.id_materia
	AND mat.nome = 'Banco de Dados'
GROUP BY al.ra, al.nome
ORDER BY al.nome


--Consultar nome da mat�ria e quantos alunos est�o matriculados
SELECT mat.nome, COUNT(al.nome) AS qtd_matriculados
FROM alunos al, alunomateria am, materias mat
WHERE al.ra = am.ra_aluno
	AND mat.id = am.id_materia
GROUP BY mat.nome
ORDER BY mat.nome

UPDATE alunomateria
SET id_materia = 10
WHERE ra_aluno IN
(
	SELECT TOP 40 al.ra
	FROM alunos al INNER JOIN alunomateria am
	ON al.ra = am.ra_aluno
	WHERE am.id_materia = 2
)

--Consultar quantos alunos n�o est�o matriculados
SELECT COUNT(al.ra) AS nao_matriculados
FROM alunos al LEFT OUTER JOIN alunomateria am
ON al.ra = am.ra_aluno
WHERE am.ra_aluno IS NULL

SELECT COUNT(al.ra) AS nao_matriculados
FROM alunomateria am RIGHT OUTER JOIN alunos al 
ON al.ra = am.ra_aluno
WHERE am.ra_aluno IS NULL

--Consultar quais alunos est�o aprovados em alguma mat�ria 
--(nota final >= 6,0)
SELECT SUBSTRING(al.ra,1,9)+'-'+SUBSTRING(al.ra,10,1) AS ra, 
		al.nome
FROM alunos al, notas nt, avaliacoes av, materias mat
WHERE al.ra = nt.ra_aluno
	AND av.id = nt.id_avaliacao
	AND mat.id = nt.id_materia
	AND mat.nome = 'Banco de Dados'
GROUP BY al.ra, al.nome
HAVING SUM(av.peso * nt.nota) > 6

SELECT SUBSTRING(al.ra,1,9)+'-'+SUBSTRING(al.ra,10,1) AS ra, 
		al.nome
FROM alunos al INNER JOIN notas nt
ON al.ra = nt.ra_aluno
INNER JOIN avaliacoes av
ON av.id = nt.id_avaliacao
INNER JOIN materias mat
ON mat.id = nt.id_materia
WHERE mat.nome = 'Banco de Dados'
GROUP BY al.ra, al.nome
HAVING SUM(av.peso * nt.nota) > 6

--Consultar quantos alunos est�o aprovados em alguma mat�ria
--(nota final >= 6,0)
SELECT COUNT(ra) AS aprovados
FROM alunos
WHERE ra IN
(
	SELECT al.ra
	FROM alunos al, notas nt, avaliacoes av, materias mat
	WHERE al.ra = nt.ra_aluno
		AND av.id = nt.id_avaliacao
		AND mat.id = nt.id_materia
		AND mat.nome = 'Banco de Dados'
	GROUP BY al.ra
	HAVING SUM(av.peso * nt.nota) > 6
)

SELECT COUNT(ra) AS aprovados
FROM alunos
WHERE ra IN
(
	SELECT al.ra
	FROM alunos al INNER JOIN notas nt
	ON al.ra = nt.ra_aluno
	INNER JOIN avaliacoes av
	ON av.id = nt.id_avaliacao
	INNER JOIN materias mat
	ON mat.id = nt.id_materia
	WHERE mat.nome = 'Banco de Dados'
	GROUP BY al.ra
	HAVING SUM(av.peso * nt.nota) > 6
)
--Consultar quantos alunos est�o reprovados em alguma mat�ria
--(nota final < 6,0)
--M�todo 1
SELECT COUNT(ra) AS reprovados
FROM alunos
WHERE ra IN
(
	SELECT al.ra
	FROM alunos al, notas nt, avaliacoes av, materias mat
	WHERE al.ra = nt.ra_aluno
		AND av.id = nt.id_avaliacao
		AND mat.id = nt.id_materia
		AND mat.nome = 'Banco de Dados'
	GROUP BY al.ra
	HAVING SUM(av.peso * nt.nota) < 6
)

SELECT COUNT(ra) AS reprovados
FROM alunos
WHERE ra IN
(
	SELECT al.ra
	FROM alunos al INNER JOIN notas nt
	ON al.ra = nt.ra_aluno
	INNER JOIN avaliacoes av
	ON av.id = nt.id_avaliacao
	INNER JOIN materias mat
	ON mat.id = nt.id_materia
	WHERE mat.nome = 'Banco de Dados'
	GROUP BY al.ra
	HAVING SUM(av.peso * nt.nota) < 6
)
--M�todo 2
SELECT COUNT(al.ra) AS reprovados
FROM alunos al, alunomateria am, materias mat
WHERE al.ra = am.ra_aluno
	AND mat.id = am.id_materia
	AND mat.nome = 'Banco de Dados'
	AND al.ra NOT IN
(
	SELECT al.ra
	FROM alunos al, notas nt, avaliacoes av, materias mat
	WHERE al.ra = nt.ra_aluno
		AND av.id = nt.id_avaliacao
		AND mat.id = nt.id_materia
		AND mat.nome = 'Banco de Dados'
	GROUP BY al.ra
	HAVING SUM(av.peso * nt.nota) > 6
)

SELECT COUNT(al.ra) AS reprovados
FROM alunos al INNER JOIN alunomateria am
ON al.ra = am.ra_aluno
INNER JOIN materias mat
ON mat.id = am.id_materia
WHERE mat.nome = 'Banco de Dados'
	AND al.ra NOT IN
(
	SELECT al.ra
	FROM alunos al INNER JOIN notas nt
	ON al.ra = nt.ra_aluno
	INNER JOIN avaliacoes av
	ON av.id = nt.id_avaliacao
	INNER JOIN materias mat
	ON mat.id = nt.id_materia
	WHERE mat.nome = 'Banco de Dados'
	GROUP BY al.ra
	HAVING SUM(av.peso * nt.nota) > 6
)

--Consultar a maior e menor notas das avalia��es das mat�rias
SELECT mat.nome, av.tipo, 
	MAX(nt.nota) AS maior_nota, MIN(nt.nota) AS menor_nota
FROM materias mat INNER JOIN notas nt
ON mat.id = nt.id_materia
INNER JOIN avaliacoes av
ON av.id = nt.id_avaliacao
GROUP BY mat.nome, av.tipo
ORDER BY mat.nome, av.tipo 

SELECT mat.nome, av.tipo, 
	MAX(nt.nota) AS maior_nota, MIN(nt.nota) AS menor_nota
FROM materias mat, notas nt, avaliacoes av
WHERE mat.id = nt.id_materia
	AND av.id = nt.id_avaliacao
GROUP BY mat.nome, av.tipo
ORDER BY mat.nome, av.tipo 

--Consultar a menor notas das avalia��es das mat�rias
--que n�o sejam zero

SELECT mat.nome, av.tipo, MIN(nt.nota) AS menor_nota
FROM materias mat, notas nt, avaliacoes av
WHERE mat.id = nt.id_materia
	AND av.id = nt.id_avaliacao
	AND nt.nota IN
	(
		SELECT nota
		FROM notas
		WHERE nota > 0.00
	)
GROUP BY mat.nome, av.tipo
ORDER BY mat.nome, av.tipo 

SELECT mat.nome, av.tipo, MIN(nt.nota) AS menor_nota
FROM materias mat INNER JOIN notas nt
ON mat.id = nt.id_materia
INNER JOIN avaliacoes av
ON av.id = nt.id_avaliacao
WHERE nt.nota IN
(
	SELECT nota
	FROM notas
	WHERE nota > 0.00
)
GROUP BY mat.nome, av.tipo
ORDER BY mat.nome, av.tipo 

--Retornar nome da mat�ria, tipo da avalia��o e as 2 maiores notas
--Banco de Dados
SELECT TOP 2 mat.nome, av.tipo, nt.nota
FROM materias mat INNER JOIN notas nt
ON mat.id = nt.id_materia
INNER JOIN avaliacoes av
ON av.id = nt.id_avaliacao
INNER JOIN alunos al
ON al.ra = nt.ra_aluno
WHERE mat.nome = 'Banco de Dados'
	AND av.tipo = 'P2'
ORDER BY nt.nota DESC

SELECT TOP 2 mat.nome, av.tipo, nt.nota
FROM materias mat, notas nt, avaliacoes av, alunos al
WHERE mat.id = nt.id_materia
	AND av.id = nt.id_avaliacao
	AND al.ra = nt.ra_aluno
	AND mat.nome = 'Banco de Dados'
	AND av.tipo = 'P2'
ORDER BY nt.nota DESC

--Fazer uma consulta que retorne o RA formatado e o nome dos 
--alunos que tem a menor nota da P1 de banco de dados
SELECT SUBSTRING(al.ra,1,9)+'-'+SUBSTRING(al.ra,10,1) AS ra, 
		al.nome, nt.nota
FROM materias mat, notas nt, avaliacoes av, alunos al
WHERE mat.id = nt.id_materia
	AND av.id = nt.id_avaliacao
	AND al.ra = nt.ra_aluno
	AND mat.nome = 'Banco de Dados'
	AND nt.nota IN
	(
		SELECT MIN(nt.nota)
		FROM materias mat, notas nt, avaliacoes av, alunos al
		WHERE mat.id = nt.id_materia
			AND av.id = nt.id_avaliacao
			AND al.ra = nt.ra_aluno
			AND mat.nome = 'Banco de Dados'
			AND av.tipo = 'P1'
	)

SELECT SUBSTRING(al.ra,1,9)+'-'+SUBSTRING(al.ra,10,1) AS ra, 
		al.nome, nt.nota
FROM materias mat INNER JOIN notas nt
ON mat.id = nt.id_materia
INNER JOIN avaliacoes av
ON av.id = nt.id_avaliacao
INNER JOIN alunos al
ON al.ra = nt.ra_aluno
WHERE mat.nome = 'Banco de Dados'
	AND nt.nota IN
	(
		SELECT MIN(nt.nota)
		FROM materias mat INNER JOIN notas nt
		ON mat.id = nt.id_materia
		INNER JOIN avaliacoes av
		ON av.id = nt.id_avaliacao
		INNER JOIN alunos al
		ON al.ra = nt.ra_aluno
		WHERE mat.nome = 'Banco de Dados'
			AND av.tipo = 'P1'
	)
