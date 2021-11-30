CREATE DATABASE aula_ex_livraria
GO
USE aula_ex_livraria
GO
CREATE TABLE editora (
codigo			INT				NOT NULL,
nome			VARCHAR(30)		NOT NULL,
site			VARCHAR(40)		NULL
PRIMARY KEY (codigo)
)
GO
CREATE TABLE autor (
codigo			INT				NOT NULL,
nome			VARCHAR(30)		NOT NULL,
biografia		VARCHAR(100)	NOT NULL
PRIMARY KEY (codigo)
)
GO
CREATE TABLE estoque (
codigo			INT				NOT NULL,
nome			VARCHAR(100)	NOT NULL	UNIQUE,
quantidade		INT				NOT NULL,
valor			DECIMAL(7,2)	NOT NULL	CHECK(valor > 0.00),
codEditora		INT				NOT NULL,
codAutor		INT				NOT NULL
PRIMARY KEY (codigo)
FOREIGN KEY (codEditora) REFERENCES editora (codigo),
FOREIGN KEY (codAutor) REFERENCES autor (codigo)
)
GO
CREATE TABLE compra (
codigo			INT				NOT NULL,
codEstoque		INT				NOT NULL,
qtdComprada		INT				NOT NULL,
valor			DECIMAL(7,2)	NOT NULL,
dataCompra		DATE			NOT NULL
PRIMARY KEY (codigo, codEstoque, dataCompra)
FOREIGN KEY (codEstoque) REFERENCES estoque (codigo)
)
GO
INSERT INTO editora VALUES
(1,'Pearson','www.pearson.com.br'),
(2,'Civilização Brasileira',NULL),
(3,'Makron Books','www.mbooks.com.br'),
(4,'LTC','www.ltceditora.com.br'),
(5,'Atual','www.atualeditora.com.br'),
(6,'Moderna','www.moderna.com.br')
GO
INSERT INTO autor VALUES
(101,'Andrew Tannenbaun','Desenvolvedor do Minix'),
(102,'Fernando Henrique Cardoso','Ex-Presidente do Brasil'),
(103,'Diva Marília Flemming','Professora adjunta da UFSC'),
(104,'David Halliday','Ph.D. da University of Pittsburgh'),
(105,'Alfredo Steinbruch','Professor de Matemática da UFRS e da PUCRS'),
(106,'Willian Roberto Cereja','Doutorado em Lingüística Aplicada e Estudos da Linguagem'),
(107,'William Stallings','Doutorado em Ciências da Computacão pelo MIT'),
(108,'Carlos Morimoto','Criador do Kurumin Linux')
GO
INSERT INTO estoque VALUES
(10001,'Sistemas Operacionais Modernos ',4,108.00,1,101),
(10002,'A Arte da Política',2,55.00,2,102),
(10003,'Calculo A',12,79.00,3,103),
(10004,'Fundamentos de Física I',26,68.00,4,104),
(10005,'Geometria Analítica',1,95.00,3,105),
(10006,'Gramática Reflexiva',10,49.00,5,106),
(10007,'Fundamentos de Física III',1,78.00,4,104),
(10008,'Calculo B',3,95.00,3,103)
GO
INSERT INTO compra VALUES
(15051,10003,2,158.00,'2021-07-04'),
(15051,10008,1,95.00,'2021-07-04'),
(15051,10004,1,68.00,'2021-07-04'),
(15051,10007,1,78.00,'2021-07-04'),
(15052,10006,1,49.00,'2021-07-05'),
(15052,10002,3,165.00,'2021-07-05'),
(15053,10001,1,108.00,'2021-07-05'),
(15054,10003,1,79.00,'2021-08-06'),
(15054,10008,1,95.00,'2021-08-06')

SELECT * FROM autor
SELECT * FROM editora
SELECT * FROM estoque
SELECT * FROM compra

-- Pede-se:
SELECT DISTINCT est.nome, est.valor, ed.nome, aut.nome 
FROM editora ed INNER JOIN estoque est
ON est.codEditora = ed.codigo
INNER JOIN autor aut
ON est.codAutor = aut.codigo
INNER JOIN compra
ON est.codigo = compra.codEstoque

-- 2) Consultar nome do livro, quantidade comprada e valor de compra da compra 15051
SELECT est.nome, compra.qtdComprada, compra.valor
FROM estoque est, compra
WHERE est.codigo = compra.codEstoque
	AND compra.codigo = 15051

-- 3) Consultar Nome do livro e site da editora dos livros da Makron books (Caso o site tenha mais de 10 dígitos, remover o www.).
SELECT est.nome, 
	   CASE 
		WHEN LEN(ed.site) > 10 THEN
			SUBSTRING(ed.site,5,LEN(ed.site)-4)
		ELSE 
			ed.site
		END AS editora_site
FROM estoque est, editora ed
WHERE est.codEditora = ed.codigo
	AND ed.nome = 'Makron books'

-- 4) Consultar nome do livro e Breve Biografia do David Halliday
SELECT est.nome, aut.biografia
FROM estoque est, autor aut
WHERE est.codAutor = aut.codigo
	AND aut.nome = 'David Halliday'

-- 5) Consultar código de compra e quantidade comprada do livro Sistemas Operacionais Modernos
SELECT compra.codigo, compra.qtdComprada
FROM compra, estoque est
WHERE compra.codEstoque = est.codigo
	AND est.nome = 'Sistemas Operacionais Modernos'

-- 6) Consultar quais livros não foram vendidos	
SELECT estoque.nome
FROM estoque LEFT OUTER JOIN compra
ON estoque.codigo = compra.codEstoque
WHERE compra.codEstoque IS NULL

-- 7) Consultar quais livros foram vendidos e não estão cadastrados	
SELECT estoque.nome
FROM compra LEFT OUTER JOIN estoque
ON estoque.codigo = compra.codEstoque
WHERE compra.codEstoque IS NULL

-- 8) Consultar Nome e site da editora que não tem Livros no estoque (Caso o site tenha mais de 10 dígitos, remover o www.)	
SELECT ed.nome, 
	   CASE 
		WHEN LEN(ed.site) > 10 THEN
			SUBSTRING(ed.site,5,LEN(ed.site)-4)
		ELSE 
			ed.site
		END AS editora_site
FROM editora ed LEFT OUTER JOIN estoque est
ON ed.codigo = est.codEditora
WHERE est.codEditora IS NULL

-- 9) Consultar Nome e biografia do autor que não tem Livros no estoque (Caso a biografia inicie com Doutorado, substituir por Ph.D.)
SELECT aut.nome, 
	   CASE 
		WHEN SUBSTRING(aut.biografia,1,9) = 'Doutorado' THEN
			'Ph.D.' + SUBSTRING(aut.biografia,10,LEN(aut.biografia)-9)
		ELSE 
			aut.biografia
		END AS biografia
FROM autor aut LEFT OUTER JOIN estoque est
ON aut.codigo = est.codAutor
WHERE est.codAutor IS NULL

-- 10) Consultar o nome do Autor, e o maior valor de Livro no estoque. Ordenar por valor descendente
SELECT aut.nome, est.valor AS maior
FROM autor aut, estoque est
WHERE est.codAutor = aut.codigo
GROUP BY aut.nome, est.valor
HAVING est.valor IN
(
	SELECT MAX(valor)
	FROM estoque
)

-- 11) Consultar o código da compra, o total de livros comprados e a soma dos valores gastos. Ordenar por Código da Compra ascendente.
SELECT codigo, SUM(qtdComprada) AS qtd_livros_comprados, SUM(valor) AS soma_valores
FROM compra
GROUP BY codigo
ORDER BY codigo ASC

-- 12) Consultar o nome da editora e a média de preços dos livros em estoque.Ordenar pela Média de Valores ascendente.
SELECT ed.nome, CAST(AVG(est.valor) AS DECIMAL(7,2)) AS media_valores
FROM editora ed, estoque est
WHERE ed.codigo = est.codEditora
GROUP BY ed.nome
ORDER BY AVG(est.valor) ASC

-- 13) Consultar o nome do Livro, a quantidade em estoque o nome da editora, o site da editora (Caso o site tenha mais de 10 dígitos, remover o www.), 
-- criar uma coluna status onde:	
	-- Caso tenha menos de 5 livros em estoque, escrever Produto em Ponto de Pedido
	-- Caso tenha entre 5 e 10 livros em estoque, escrever Produto Acabando
	-- Caso tenha mais de 10 livros em estoque, escrever Estoque Suficiente
	-- A Ordenação deve ser por Quantidade ascendente
SELECT est.nome, est.quantidade, ed.nome, 
	CASE 
		WHEN LEN(ed.site) > 10 THEN
			SUBSTRING(ed.site,5,LEN(ed.site)-4)
		ELSE 
			ed.site
		END AS editora_site,
	CASE 
		WHEN est.quantidade < 5 THEN
			'Produto em Ponto de Pedido'
		WHEN  est.quantidade >= 5 AND est.quantidade <= 10 THEN
			'Produto Acabando'
	    ELSE 
			'Estoque Suficiente'
		END AS status
FROM editora ed, estoque est
WHERE ed.codigo = est.codEditora
ORDER BY est.quantidade ASC

-- 14) Para montar um relatório, é necessário montar uma consulta com a seguinte saída: Código do Livro, Nome do Livro, 
-- Nome do Autor, Info Editora (Nome da Editora + Site) de todos os livros	
-- Só pode concatenar sites que não são nulos
SELECT est.codigo, est.nome, aut.nome,  
	CASE 
		WHEN ed.site IS NOT NULL THEN
			ed.nome + ' - ' + ed.site
		ELSE 
			ed.nome
		END AS editora
FROM editora ed, estoque est, autor aut
WHERE ed.codigo = est.codEditora
	AND aut.codigo = est.codAutor

-- 15) Consultar Codigo da compra, quantos dias da compra até hoje e quantos meses da compra até hoje
SELECT codigo, DATEDIFF(DAY,dataCompra,GETDATE()) AS dias_compra, DATEDIFF(MONTH,dataCompra,GETDATE()) AS meses_compra 
FROM compra

-- 16) Consultar o código da compra e a soma dos valores gastos das compras que somam mais de 200.00
SELECT codigo, SUM(valor)			
FROM compra
GROUP BY codigo
HAVING SUM(valor) > 200