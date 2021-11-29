USE locadora

-- 1) Consultar, num_cadastro do cliente, nome do cliente, titulo do filme, data_fabricação
-- do dvd, valor da locação, dos dvds que tem a maior data de fabricação dentre todos os
-- cadastrados.
SELECT c.num_cadastro, c.nome, f.titulo, d.data_fabricacao, l.valor
FROM Cliente c, Filme f, DVD d, Locacao l
WHERE l.num_DVD = d.num
	AND d.id_filme = f.id
	AND l.num_cadastro = c.num_cadastro
    AND d.data_fabricacao IN 
(
		SELECT MAX(data_fabricacao) AS maior_fab
		FROM DVD
)


SELECT * FROM Cliente
SELECT * FROM Locacao
SELECT * FROM DVD
SELECT * FROM Filme

-- 2) Consultar Consultar, num_cadastro do cliente, nome do cliente, data de locação
-- (Formato DD/MM/AAAA) e a quantidade de DVD´s alugados por cliente (Chamar essa
-- coluna de qtd), por data de locação
SELECT c.num_cadastro, c.nome, CONVERT(VARCHAR(10), l.data_locacao, 103) AS locacao, COUNT(l.num_cadastro) AS qtd
FROM Cliente c, Locacao l
WHERE l.num_cadastro = c.num_cadastro
GROUP BY c.num_cadastro, c.nome, l.data_locacao

-- 3) Consultar Consultar, num_cadastro do cliente, nome do cliente, data de locação
-- (Formato DD/MM/AAAA) e a valor total de todos os dvd´s alugados (Chamar essa
-- coluna de valor_total), por data de locação
SELECT c.num_cadastro, c.nome, CONVERT(VARCHAR(10), l.data_locacao, 103) AS locacao, SUM(l.valor) AS valor_total
FROM Cliente c, Locacao l
WHERE l.num_cadastro = c.num_cadastro
GROUP BY c.num_cadastro, c.nome, l.data_locacao

-- 4) Consultar Consultar, num_cadastro do cliente, nome do cliente, Endereço
-- concatenado de logradouro e numero como Endereco, data de locação (Formato
-- DD/MM/AAAA) dos clientes que alugaram mais de 2 filmes simultaneamente
SELECT c.num_cadastro, c.nome, 
	   c.logradouro + ', ' + CAST(c.numero AS VARCHAR) + ' - ' + c.cep AS Endereço, 
	   CONVERT(VARCHAR(10), l.data_locacao, 103) AS locacao
FROM Cliente c, Locacao l
WHERE l.num_cadastro = c.num_cadastro
GROUP BY c.num_cadastro, c.nome, c.logradouro, c.numero, c.cep, l.data_locacao
HAVING COUNT(l.num_DVD) >= 2